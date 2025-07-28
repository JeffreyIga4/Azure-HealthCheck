param sites_healthcheckfunc_jiga_name string = 'healthcheckfunc-jiga'
param serverfarms_orderplan_externalid string = '/subscriptions/d01cfca0-e36c-4a9c-afaf-73093d78a2d6/resourceGroups/rg-order-logic-northeurope/providers/Microsoft.Web/serverfarms/orderplan'

resource sites_healthcheckfunc_jiga_name_resource 'Microsoft.Web/sites@2024-11-01' = {
  name: sites_healthcheckfunc_jiga_name
  location: 'North Europe'
  kind: 'functionapp'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/d01cfca0-e36c-4a9c-afaf-73093d78a2d6/resourceGroups/rg-order-logic-northeurope/providers/microsoft.insights/components/healthcheckfunc-jiga'
  }
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_healthcheckfunc_jiga_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_healthcheckfunc_jiga_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_orderplan_externalid
    reserved: false
    isXenon: false
    hyperV: false
    siteConfig: {
      numberOfWorkers: 1
      alwaysOn: false
      http20Enabled: true
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
    }
    httpsOnly: false
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_healthcheckfunc_jiga_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: 'ftp'
  properties: {
    allow: true
  }
}

resource sites_healthcheckfunc_jiga_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: 'scm'
  properties: {
    allow: true
  }
}

resource sites_healthcheckfunc_jiga_name_web 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: 'web'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v8.0'
    logsDirectorySizeLimit: 35
    publishingUsername: '$healthcheckfunc-jiga'
    scmType: 'None'
    use32BitWorkerProcess: false
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: true
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    functionAppScaleLimit: 200
  }
}

resource sites_healthcheckfunc_jiga_name_function 'Microsoft.Web/sites/functions@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: 'HealthCheckPing'
  properties: {
    script_href: 'https://healthcheckfunc-jiga.azurewebsites.net/admin/vfs/site/wwwroot/Azure-Healthcheck.dll'
    test_data_href: 'https://healthcheckfunc-jiga.azurewebsites.net/admin/vfs/data/Functions/sampledata/HealthCheckPing.dat'
    href: 'https://healthcheckfunc-jiga.azurewebsites.net/admin/functions/HealthCheckPing'
    config: {
      name: 'HealthCheckPing'
      entryPoint: 'Company.Function.HealthCheckPing.Run'
      scriptFile: 'Azure-Healthcheck.dll'
      language: 'dotnet-isolated'
      bindings: [
        {
          name: 'req'
          type: 'httpTrigger'
          direction: 'In'
          authLevel: 'Function'
          methods: [
            'get'
          ]
        }
        {
          name: '$return'
          type: 'http'
          direction: 'Out'
        }
      ]
    }
    invoke_url_template: 'https://healthcheckfunc-jiga.azurewebsites.net/api/healthcheckping'
    language: 'dotnet-isolated'
    isDisabled: false
  }
}
