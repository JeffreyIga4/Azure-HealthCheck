param sites_healthcheckfunc_jiga_name string = 'healthcheckfunc-jiga'
param serverfarms_orderplan_externalid string = '/subscriptions/d01cfca0-e36c-4a9c-afaf-73093d78a2d6/resourceGroups/rg-order-logic-northeurope/providers/Microsoft.Web/serverfarms/orderplan'

resource sites_healthcheckfunc_jiga_name_resource 'Microsoft.Web/sites@2024-11-01' = {
  name: sites_healthcheckfunc_jiga_name
  location: 'North Europe'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/d01cfca0-e36c-4a9c-afaf-73093d78a2d6/resourceGroups/rg-order-logic-northeurope/providers/microsoft.insights/components/healthcheckfunc-jiga'
  }
  kind: 'functionapp'
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
    dnsConfiguration: {}
    outboundVnetRouting: {
      allTraffic: false
      applicationTraffic: false
      contentShareTraffic: false
      imagePullTraffic: false
      backupRestoreTraffic: false
    }
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: true
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientAffinityProxyEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    customDomainVerificationId: 'DF21905225A9ED247EF9D257673E1E83385C0A3FFE79F2CC88C6DADA8FD0FCE0'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: false
    endToEndEncryptionEnabled: false
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_healthcheckfunc_jiga_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: 'ftp'
  location: 'North Europe'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/d01cfca0-e36c-4a9c-afaf-73093d78a2d6/resourceGroups/rg-order-logic-northeurope/providers/microsoft.insights/components/healthcheckfunc-jiga'
  }
  properties: {
    allow: true
  }
}

resource sites_healthcheckfunc_jiga_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: 'scm'
  location: 'North Europe'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/d01cfca0-e36c-4a9c-afaf-73093d78a2d6/resourceGroups/rg-order-logic-northeurope/providers/microsoft.insights/components/healthcheckfunc-jiga'
  }
  properties: {
    allow: true
  }
}

resource sites_healthcheckfunc_jiga_name_web 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: 'web'
  location: 'North Europe'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/d01cfca0-e36c-4a9c-afaf-73093d78a2d6/resourceGroups/rg-order-logic-northeurope/providers/microsoft.insights/components/healthcheckfunc-jiga'
  }
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
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
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
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
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
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 200
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
    http20ProxyFlag: 0
  }
}

resource sites_healthcheckfunc_jiga_name_00d06c13fed345ea95eb7bba9abf56a7 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: '00d06c13fed345ea95eb7bba9abf56a7'
  location: 'North Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-07-16T14:42:15.1267765Z'
    end_time: '2025-07-16T14:42:16.6580275Z'
    active: false
  }
}

resource sites_healthcheckfunc_jiga_name_0eebcb7503e644a08ff82d94cec9895d 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: '0eebcb7503e644a08ff82d94cec9895d'
  location: 'North Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-07-16T17:18:20.5414341Z'
    end_time: '2025-07-16T17:18:21.9023863Z'
    active: false
  }
}

resource sites_healthcheckfunc_jiga_name_13f2520f6484411388673b38507b55d8 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: '13f2520f6484411388673b38507b55d8'
  location: 'North Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-07-28T03:11:10.5437313Z'
    end_time: '2025-07-28T03:11:11.7468956Z'
    active: true
  }
}

resource sites_healthcheckfunc_jiga_name_1797ddd7087046df872b6bce3fc5b61a 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: '1797ddd7087046df872b6bce3fc5b61a'
  location: 'North Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-07-16T14:52:36.3515547Z'
    end_time: '2025-07-16T14:52:37.9609313Z'
    active: false
  }
}

resource sites_healthcheckfunc_jiga_name_2565ecc2b8c04a82b12bc6837be9d338 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: '2565ecc2b8c04a82b12bc6837be9d338'
  location: 'North Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-07-14T15:18:15.4964101Z'
    end_time: '2025-07-14T15:18:17.0766702Z'
    active: false
  }
}

resource sites_healthcheckfunc_jiga_name_784a2e0c31b64afa8d101e83e20f956d 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: '784a2e0c31b64afa8d101e83e20f956d'
  location: 'North Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-07-14T15:59:46.0116185Z'
    end_time: '2025-07-14T15:59:47.2933924Z'
    active: false
  }
}

resource sites_healthcheckfunc_jiga_name_9022bdcbf0764dd1a628b9b2dfd4f679 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: '9022bdcbf0764dd1a628b9b2dfd4f679'
  location: 'North Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'ms-azuretools-vscode'
    deployer: 'ms-azuretools-vscode'
    message: 'Created via a push deployment'
    start_time: '2025-07-14T16:02:13.4968475Z'
    end_time: '2025-07-14T16:02:14.7780897Z'
    active: false
  }
}

resource sites_healthcheckfunc_jiga_name_cb00637e22ea40a8bcccabc0a369b1f7 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: 'cb00637e22ea40a8bcccabc0a369b1f7'
  location: 'North Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-07-16T15:15:04.3219685Z'
    end_time: '2025-07-16T15:15:06.0102033Z'
    active: false
  }
}

resource sites_healthcheckfunc_jiga_name_HealthCheckPing 'Microsoft.Web/sites/functions@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: 'HealthCheckPing'
  location: 'North Europe'
  properties: {
    script_href: 'https://healthcheckfunc-jiga.azurewebsites.net/admin/vfs/site/wwwroot/Azure-Healthcheck.dll'
    test_data_href: 'https://healthcheckfunc-jiga.azurewebsites.net/admin/vfs/data/Functions/sampledata/HealthCheckPing.dat'
    href: 'https://healthcheckfunc-jiga.azurewebsites.net/admin/functions/HealthCheckPing'
    config: {
      name: 'HealthCheckPing'
      entryPoint: 'Company.Function.HealthCheckPing.Run'
      scriptFile: 'Azure-Healthcheck.dll'
      language: 'dotnet-isolated'
      functionDirectory: ''
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

resource sites_healthcheckfunc_jiga_name_sites_healthcheckfunc_jiga_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2024-11-01' = {
  parent: sites_healthcheckfunc_jiga_name_resource
  name: '${sites_healthcheckfunc_jiga_name}.azurewebsites.net'
  location: 'North Europe'
  properties: {
    siteName: 'healthcheckfunc-jiga'
    hostNameType: 'Verified'
  }
}
