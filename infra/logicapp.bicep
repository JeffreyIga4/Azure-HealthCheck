param workflows_logicapp_scheduled_check_name string = 'logicapp-scheduled-check'
param healthCheckUrl string
param appInsightsKey string
param appInsightsIKey string

resource workflows_logicapp_scheduled_check_name_resource 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_logicapp_scheduled_check_name
  location: 'northeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        Recurrence: {
          recurrence: {
            interval: 5
            frequency: 'Minute'
            timeZone: 'GMT Standard Time'
          }
          evaluatedRecurrence: {
            interval: 5
            frequency: 'Minute'
            timeZone: 'GMT Standard Time'
          }
          type: 'Recurrence'
        }
      }
      actions: {
        HTTP: {
          runAfter: {}
          type: 'Http'
          inputs: {
            uri: healthCheckUrl
            method: 'GET'
          }
          runtimeConfiguration: {
            contentTransfer: {
              transferMode: 'Chunked'
            }
          }
        }
        Condition: {
          actions: {
            Compose: {
              type: 'Compose'
              inputs: 'Service Healthy'
            }
          }
          runAfter: {
            HTTP: [
              'Succeeded'
              'Failed'
              'TimedOut'
              'Skipped'
            ]
          }
          else: {
            actions: {
              Compose_1: {
                type: 'Compose'
                inputs: 'Health check failed at @{utcNow()} – status not 200'
              }
              HTTP_1: {
                runAfter: {
                  Compose_1: [
                    'Succeeded'
                  ]
                }
                type: 'Http'
                inputs: {
                  uri: 'https://dc.services.visualstudio.com/v2/track'
                  method: 'POST'
                  headers: {
                    'Content-Type': 'application/json'
                    'x-api-key': appInsightsKey
                  }
                  body: {
                    name: 'Microsoft.ApplicationInsights.Event'
                    time: '@{utcNow()}'
                    iKey: appInsightsIKey
                    data: {
                      baseType: 'EventData'
                      baseData: {
                        ver: 2
                        name: 'HealthCheckFailure'
                        properties: {
                          message: 'Health check failed: @{outputs(\'Compose_1\')}'
                          code: '@{body(\'HTTP\')?[\'StatusCode\']}'
                          source: 'LogicApp'
                          timestamp: '@{utcNow()}'
                        }
                      }
                    }
                  }
                }
                runtimeConfiguration: {
                  contentTransfer: {
                    transferMode: 'Chunked'
                  }
                }
              }
            }
          }
          expression: {
            and: [
              {
                equals: [
                  '@outputs(\'HTTP\')[\'statusCode\']\n'
                  200
                ]
              }
            ]
          }
          type: 'If'
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {}
      }
    }
  }
}
