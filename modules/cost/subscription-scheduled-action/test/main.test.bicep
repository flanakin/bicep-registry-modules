targetScope = 'subscription'

// Test 1 - Creating a scheduled alert for the DailyCosts built-in view.
module dailyCostsAlert '../main.bicep' = {
  name: 'dailyCostsAlert'
  params: {
    name: 'DailyCostsAlert'
    displayName: 'My schedule'
    builtInView: 'DailyCosts'
    emailRecipients: [ 'ema@contoso.com' ]
    scheduleFrequency: 'Weekly'
    scheduleDaysOfWeek: [ 'Monday' ]
    scheduleStartDate: '2024-01-01T08:00Z'
    scheduleEndDate: '2025-01-01T08:00Z'
  }
}

// Test 2 - Creating an anomaly alert.
module anomalyAlert '../main.bicep' = {
  name: 'anomalyAlert'
  params: {
    name: 'AnomalyAlert'
    kind: 'InsightAlert'
    displayName: 'My anomaly check'
    emailRecipients: [ 'ana@contoso.com' ]
  }
}

output anomalyAlertId string = anomalyAlert.outputs.scheduledActionId 
output dailyCostsAlertId string = dailyCostsAlert.outputs.scheduledActionId

