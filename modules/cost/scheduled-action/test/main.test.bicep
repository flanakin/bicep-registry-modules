/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

// Test 1 - Creating an anomaly alert.
module anomalyAlert '../main.bicep' = {
  name: 'anomalyAlert'
  params: {
    scheduledActionName: 'AnomalyAlert'
    displayName: 'My anomaly check'
    emailRecipients: [ 'ana@contoso.com' ]
  }
}

// Test 2 - Creating a scheduled alert for a saved view called MyView.
module dailyCostsAlert '../main.bicep' = {
  name: 'dailyCostsAlert'
  params: {
    kind: 'Email'
    scheduledActionName: 'DailyCostsAlert'
    viewId: '${subscription().id}/providers/Microsoft.CostManagement/views/ms:DailyCosts'
    displayName: 'My schedule'
    emailRecipients: [ 'ema@contoso.com' ]
    scheduleFrequency: 'Weekly'
    scheduleDaysOfWeek: [ 'Monday' ]
    scheduleStartDate: '2023-01-01T08:00Z'
    scheduleEndDate: '2024-01-01T08:00Z'
  }
}

output anomalyAlertId string = anomalyAlert.outputs.scheduledActionId
output dailyCostsAlertId string = dailyCostsAlert.outputs.scheduledActionId
