targetScope = 'tenant'

// Test 1 - Creating a scheduled alert for the DailyCosts built-in view.
module dailyCostsAlert '../main.bicep' = {
  name: 'dailyCostsAlert'
  params: {
    name: 'DailyCostsAlert'
    displayName: 'My schedule'
    scope: '/providers/Microsoft.Billing/billingAccounts/8611537' 
    builtInView: 'DailyCosts'
    emailRecipients: [ 'ema@contoso.com' ]
    scheduleFrequency: 'Weekly'
    scheduleDaysOfWeek: [ 'Monday' ]
    scheduleStartDate: '2024-01-01T08:00Z'
    scheduleEndDate: '2025-01-01T08:00Z'
  }
}

output dailyCostsAlertId string = dailyCostsAlert.outputs.scheduledActionId

