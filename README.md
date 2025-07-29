# Azure Health Check with Logic App Alerting 

This project implements an automated **health check system** for monitoring an Azure Function using **Logic Apps**, **Application Insights**, and **CI/CD via GitHub Actions**. It pings your function endpoint on a schedule and alerts Application Insights if the health check fails.

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

## What It Does

- Deploys a .NET 8 Azure Function (`HealthCheckPing`) that returns `{"status": "Healthy"}`.
- A **scheduled Logic App** pings the Function URL at regular intervals.
- If the check fails, it triggers an alert by sending a **custom event to Application Insights**.

---

## How to Deploy

### 1. **Setup GitHub Secrets**

| Secret Name              | Description                                     |
|--------------------------|-------------------------------------------------|
| `AZURE_CREDENTIALS`      | JSON of your Azure service principal            |
| `APPINSIGHTS_KEY`        | App Insights API key                            |
| `APPINSIGHTS_IKEY`       | App Insights instrumentation key                |
| `HEALTHCHECK_URL`        | Full Function URL (with `code=...`)             |

### 2. **Push to `main`**

This triggers the GitHub Actions workflow:
- Deploys infrastructure via Bicep
- Publishes and deploys the Function App
- Creates the Logic App scheduler
- Connects monitoring to Application Insights

---

## 📡 Monitoring & Alerting

If the Function returns anything other than `200 OK`:
- The Logic App sends a custom `HealthCheckFailure` event to Application Insights.
- Includes:
  - `message`
  - `statusCode`
  - `timestamp`
  - `source`


---

## Health Check Function

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
