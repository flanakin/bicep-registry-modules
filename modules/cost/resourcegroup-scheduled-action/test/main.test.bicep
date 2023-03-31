targetScope = 'resourceGroup'

param startTime string = utcNow('yyyy-MM-dd')

var scheduleStartDate = '${dateTimeAdd(startTime, 'P1M', 'yyyy-MM-dd')}T08:00Z'
var scheduleEndDate = '${dateTimeAdd(startTime, 'P1M1D', 'yyyy-MM-dd')}T08:00Z'

// Test 1 - Creates a shared scheduled action for the DailyCosts built-in view.
module dailyCostsAlert '../main.bicep' = {
  name: 'dailyCostsAlert'
  params: {
    name: 'DailyCostsAlert'
    displayName: 'My schedule'
    builtInView: 'DailyCosts'
    emailRecipients: [ 'ema@contoso.com' ]
    scheduleFrequency: 'Weekly'
    scheduleDaysOfWeek: [ 'Monday' ]
  }
}

// Test 2 - Creates a private scheduled action for the DailyCosts built-in view with custom start/end dates.
module privateAlert '../main.bicep' = {
  name: 'privateAlert'
  params: {
    name: 'PrivateAlert'
    displayName: 'My private schedule'
    private: true
    builtInView: 'DailyCosts'
    emailRecipients: [ 'priya@contoso.com' ]
    scheduleFrequency: 'Monthly'
    scheduleDayOfMonth: 1
    scheduleStartDate: scheduleStartDate
    scheduleEndDate: scheduleEndDate
  }
}

output dailyCostsAlertId string = dailyCostsAlert.outputs.scheduledActionId
output privateAlertId string = privateAlert.outputs.scheduledActionId

