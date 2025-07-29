# Azure Health Check with Logic App Alerting 

This project implements an automated **health check system** for monitoring an Azure Function using **Logic Apps**, **Application Insights**, and **CI/CD via GitHub Actions**. It pings your function endpoint on a schedule and alerts Application Insights if the health check fails.

---


## Features

- **Health Check API**: A .NET Azure Function (`HealthCheckPing`) that returns a `200 OK` status and `{ "status": "Healthy" }` when running properly.
- **Logic App Monitor**: A Logic App that runs **every 5 minutes** to check the health of the Function App by sending an HTTP GET request to the health check endpoint.
- **Alerting**: If the health check fails, the Logic App sends a **custom event** to **Application Insights** for logging and alerting.
- **Infrastructure-as-Code**: Uses Bicep files (`logicapp.bicep`) to deploy the Function App and Logic App resources.
- **CI/CD Pipeline**: GitHub Actions workflow automates deployment on push to the `main` branch.

---

## Deployment Flow

The GitHub Actions workflow:

- Deploys infrastructure (`logicapp.bicep` for the Logic App)
- Builds and publishes the .NET Function
- Automatically restarts the Function App before deployment to avoid read-only state
- Pushes the compiled Function App code to Azure

---

## Project Structure

```
Azure-HealthCheck/
│
├── Azure-Healthcheck/                # .NET 8 isolated Azure Function
│   ├── HealthCheckPing.cs            # Health check function
│   ├── Program.cs
│   ├── host.json
│   ├── local.settings.json
│   └── Azure-Healthcheck.csproj
│
├── infra/
│   ├── logicapp.bicep                # Logic App deployment
│   └── check.bicep                   # Function App & related infra
│
├── .github/workflows/
│   └── deploy.yml                    # CI/CD workflow
│
└── global.json                       # SDK pinning (8.0.313)
```

---

## How to Deploy

### Prerequisites
- Azure Subscription
- Azure CLI installed and logged in
- GitHub repository with the following secrets:
  - `AZURE_CREDENTIALS` – output from az ad sp create-for-rbac with contributor permissions
  - `APPINSIGHTS_KEY` - App Insights API key
  - `APPINSIGHTS_IKEY` - App Insights instrumentation key
  - `HEALTHCHECK_URL` -  Full Function URL (with `code=...`)  

### Deployment Steps
1. **Push to main Branch**
When you push to the `main` branch, the `deploy.yml` GitHub Actions workflow will automatically:
- Restart the Function App to clear read-only locks
- Deploy infrastructure using Bicep:
  - `logicapp.bicep`: for the Logic App and alert configuration
- Build and publish the .NET Function App to Azure

2. **GitHub Actions Will Do the Following:**
``` yaml
az deployment group create \
            --name logicapp-alerting-${{ github.run_number }} \
            --resource-group rg-order-logic-northeurope \
            --template-file ./infra/logicapp.bicep \
            --parameters \
              healthCheckUrl='${{ secrets.HEALTHCHECK_URL }}' \
              appInsightsIKey='${{ secrets.APPINSIGHTS_INSTRUMENTATION_KEY }}' \
              appInsightsKey='${{ secrets.APPINSIGHTS_API_KEY }}'


- name: Publish Function App
  run: dotnet publish Azure-Healthcheck.csproj --configuration Release --output ./publish

- name: Deploy Azure Function
  uses: Azure/functions-action@v1
  with:
    app-name: healthcheckfunc-jiga
    package: ./publish
```

---

## 📡 Monitoring & Alerting

1. The **Logic App runs every 5 minutes** (`Recurrence` trigger).
2. It sends a `GET` request to the deployed `HealthCheckPing` Azure Function.
3. If the response status is not `200`, it sends a custom Application Insights event:

```json
{
  "name": "Microsoft.ApplicationInsights.Event",
  "time": "@{utcNow()}",
  "iKey": "<your-app-insights-key>",
  "data": {
    "baseType": "EventData",
    "baseData": {
      "ver": 2,
      "name": "HealthCheckFailure",
      "properties": {
        "message": "Health check failed: @{outputs('Compose_1')}",
        "code": "@{body('HTTP')?['StatusCode']}",
        "source": "LogicApp",
        "timestamp": "@{utcNow()}"
      }
    }
  }
}
```

---

## Health Check Function

The health check function is a simple HTTP-triggered Azure Function named `HealthCheckPing`. It's written in C# using the **.NET isolated process model**, providing better scalability and separation from the Azure Functions runtime.

```csharp
public class HealthCheckPing
{
    [Function("HealthCheckPing")]
    public async Task<HttpResponseData> Run([HttpTrigger(AuthorizationLevel.Function, "get")] HttpRequestData req)
    {
        var response = req.CreateResponse(HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json");
        await response.WriteStringAsync("{\"status\": \"Healthy\"}", Encoding.UTF8);
        return response;
    }
}
```

---

## CI/CD via GitHub Actions

- Deploys infrastructure (`logicapp.bicep`)
- Builds and publishes the .NET Function
- Automatically restarts the Function App before redeploy

---

## Requirements

- .NET SDK 8.0.313 (pinned via `global.json`)
- Azure CLI
- Bicep CLI
- Azure Subscription
- GitHub Actions Runner

---
