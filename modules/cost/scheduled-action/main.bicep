// https://learn.microsoft.com/rest/api/cost-management/scheduled-actions/create-or-update

/**
 * Parameters
 */

// TODO: targetScope = 'subscription'

@description('Required. The name of the scheduled action.')
param scheduledActionName string

@description('Optional. Indicates the kind of scheduled action. Allowed: Email, InsightAlert. Default: InsightAlert.')
@allowed([
  'Email'
  'InsightAlert'
])
param kind string = 'InsightAlert'

@description('Optional. Specifies which built-in view to use. This is a shortcut for the full view ID. Allowed: AccumulatedCosts, DailyCosts, InvoiceDetails. Ignored if kind is "InsightAlert".')
@allowed([
  ''
  'AccumulatedCosts'
  'DailyCosts'
  'InvoiceDetails'
])
param builtInView string = ''

@description('Required if kind is "Email" and builtInView is not set. The resource ID of the view to which the scheduled action will send. The view must either be private (tenant level) or owned by the same scope as the scheduled action. Ignored if kind is "InsightAlert" or if builtInView is set.')
param viewId string = ''
var internalViewId = builtInView == null ? viewId : '${subscription().id}/providers/Microsoft.CostManagement/views/ms:${builtInView}'

@description('Optional. The display name to show in the portal when viewing the list of scheduled actions. Default: scheduledActionName.')
param displayName string = scheduledActionName

@description('Optional. The status of the scheduled action. Allowed: Enabled, Disabled. Default: Enabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param status string = 'Enabled'

@description('Optional. Email address of the person or team responsible for this scheduled action. This email address will be included in emails.')
param notificationEmail string = ''

@description('Required. List of email addresses that should receive emails. At least one valid email address is required.')
param emailRecipients array

@description('Optional. The subject of the email that will be sent to the email recipients.')
@maxLength(70)
param emailSubject string = ''

@description('Optional. Include a message for recipients to add context about why they are getting the email, what to do, and/or who to contact.')
@maxLength(250)
param emailMessage string = ''

@description('Optional. The language that will be used for the email template. Default: en.')
param emailLanguage string = 'en'

@description('Optional. The regional format that will be used for dates, times, and numbers. Default: en-US.')
param emailRegionalFormat string = 'en-US'

@description('Optional. Indicates whether to include a link to a CSV file with the backing data for the chart. Default: false. Ignored if kind is "InsightAlert".')
param includeCsv bool = false

@description('Required if kind is "Email". The frequency at which the scheduled action will run. Allowed: Daily, Weekly, Monthly.')
@allowed([
  'Daily'
  'Weekly'
  'Monthly'
])
param scheduleFrequency string = kind == 'InsightAlert' ? 'Daily' : 'Weekly'

@description('Required if kind is "Email" and scheduleFrequency is "Weekly". List of days of the week that emails should be delivered. Allowed: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday.')
param scheduleDaysOfWeek array = [ 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday' ]

@description('Required if kind is "Email" and scheduleFrequency is "Monthly". The day of the month that emails should be delivered. Note monthly cost is not final until the 3rd of the month. This or scheduleWeeksOfMonth is required if scheduleFrequency is "Monthly". Allowed: 1-31.')
@allowed([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 ])
param scheduleDayOfMonth int = 0

@description('Optional. List of weeks of the month that emails should be delivered. This or scheduleDayOfMonth is required if scheduleFrequency is "Monthly". Allowed: First, Second, Third, Fourth, Last.')
param scheduleWeeksOfMonth array = []

@description('Required if kind is "Email". The first day the schedule should run. Use the time to indicate when you want to receive emails. Must be in the format yyyy-MM-ddTHH:miZ. Ignored if kind is "InsightAlert".')
param scheduleStartDate string = ''

@description('Required if kind is "Email". The last day the schedule should run. Must be in the format yyyy-MM-dd. Ignored if kind is "InsightAlert".')
param scheduleEndDate string = ''

/**
 * Resources
 */

resource sa 'Microsoft.CostManagement/scheduledActions@2022-10-01' = {
  name: scheduledActionName
  kind: kind
  properties: {
    scope: subscription().id
    displayName: displayName
    viewId: kind == 'InsightAlert' ? '/providers/Microsoft.CostManagement/views/ms:DailyAnomalyByResourceGroup' : internalViewId
    notificationEmail: notificationEmail
    status: status
    fileDestination: {
      fileFormats: includeCsv ? [ 'Csv' ] : []
    }
    notification: {
      to: emailRecipients
      subject: emailSubject
      message: emailMessage
      language: emailLanguage
      regionalFormat: emailRegionalFormat
    }
    schedule: {
      startDate: scheduleStartDate
      endDate: scheduleEndDate
      frequency: kind == 'InsightAlert' ? 'Daily' : scheduleFrequency
      daysOfWeek: kind == 'Email' && scheduleFrequency == 'Weekly' ? scheduleDaysOfWeek : null
      dayOfMonth: kind == 'Email' && scheduleFrequency == 'Monthly' && scheduleDayOfMonth != null ? scheduleDayOfMonth : null
      weeksOfMonth: kind == 'Email' && scheduleFrequency == 'Monthly' && scheduleDayOfMonth == null ? scheduleWeeksOfMonth : null
    }
  }
}

/**
 * Outputs
 */

@description('Resource ID of the scheduled action.')
output scheduledActionId string = sa.id
