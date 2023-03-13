# Cost Management scheduled action

Creates a Cost Management scheduled action to notify recipients when an anomaly is detected or about the latest cost status on a daily, weekly, or monthly basis.

## Description

Use this module within other Bicep templates to simplify creating and updating scheduled actions.

## Parameters

| Name                   | Type     | Required    | Description |
| :--------------------- | :------: | :---------: | :---------- |
| `scheduledActionName`  | `string` | Yes         | Required. The name of the scheduled action. |
| `kind`                 | `string` | No          | Optional. Indicates the kind of scheduled action. Allowed: Email, InsightAlert. Default: InsightAlert. |
| `builtInView`          | `string` | No          | Optional. Specifies which built-in view to use. This is a shortcut for the full view ID. Allowed: AccumulatedCosts, DailyCosts, InvoiceDetails. Ignored if kind is "InsightAlert". |
| `viewId`               | `string` | Conditional | Required if kind is "Email". The resource ID of the view to which the scheduled action will send. The view must either be private (tenant level) or owned by the same scope as the scheduled action. |
| `displayName`          | `string` | No          | Optional. The display name to show in the portal when viewing the list of scheduled actions. Default: scheduledActionName. |
| `status`               | `string` | No          | Optional. The status of the scheduled action. Allowed: Enabled, Disabled. Default: Enabled. |
| `notificationEmail`    | `string` | No          | Optional. Email address of the person or team responsible for this scheduled action. This email address will be included in emails. |
| `emailRecipients`      | `array`  | Yes         | Required. List of email addresses that should receive emails. At least one valid email address is required. |
| `emailSubject`         | `string` | No          | Optional. The subject of the email that will be sent to the email recipients. |
| `emailMessage`         | `string` | No          | Optional. Include a message for recipients to add context about why they are getting the email, what to do, and/or who to contact. |
| `emailLanguage`        | `string` | No          | Optional. The language that will be used for the email template. Default: en. |
| `emailRegionalFormat`  | `string` | No          | Optional. The regional format that will be used for dates, times, and numbers. Default: en-US. |
| `includeCsv`           | `bool`   | No          | Optional. Indicates whether to include a link to a CSV file with the backing data for the chart. Default: false. Ignored if kind is "InsightAlert". |
| `scheduleFrequency`    | `string` | Conditional | Required if kind is "Email". The frequency at which the scheduled action will run. Allowed: Daily, Weekly, Monthly. |
| `scheduleDaysOfWeek`   | `array`  | Conditional | Required if kind is "Email" and scheduleFrequency is "Weekly". List of days of the week that emails should be delivered. Allowed: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday. |
| `scheduleDayOfMonth`   | `int`    | Conditional | Required if kind is "Email" and scheduleFrequency is "Monthly". The day of the month that emails should be delivered. Note monthly cost is not final until the 3rd of the month. This or scheduleWeeksOfMonth is required if scheduleFrequency is "Monthly". Allowed: 1-31. |
| `scheduleWeeksOfMonth` | `array`  | No          | Optional. List of weeks of the month that emails should be delivered. This or scheduleDayOfMonth is required if scheduleFrequency is "Monthly". Allowed: First, Second, Third, Fourth, Last. |
| `scheduleStartDate`    | `string` | Conditional | Required if kind is "Email". The first day the schedule should run. Use the time to indicate when you want to receive emails. Must be in the format yyyy-MM-ddTHH:miZ. Ignored if kind is "InsightAlert". |
| `scheduleEndDate`      | `string` | Conditional | Required if kind is "Email". The last day the schedule should run. Must be in the format yyyy-MM-dd. Ignored if kind is "InsightAlert". |

## Outputs

| Name                | Type     | Description |
| :------------------ | :------: | :---------- |
| `scheduledActionId` | `string` | Resource ID of the scheduled action. |

## Examples

### Example 1

Creating an anomaly alert.

```bicep
module anomalyAlert `br/public:cogs/cost/scheduled-action:1.0` = {
  name: 'anomalyAlert'
  params: {
    scheduledActionName: 'AnomalyAlert'
    displayName: 'My anomaly check'
    emailRecipients: ['']
  }
}
```

### Example 2

Creating a scheduled alert for a saved view called MyView.

```bicep
module scheduledAlert `br/public:cogs/cost/scheduled-action:1.0` = {
  name: 'scheduledAlert'
  params: {
    scheduledActionName: 'myScheduledAlert'
    displayName: 'My scheduled alert'
    kind: 'Email'
    viewId: '/subscriptions/##-#-#-#-###/providers/Microsoft.CostManagement/views/MyView'
    emailRecipients: ['']
    scheduleFrequency: 'Weekly'
    scheduleDaysOfWeek: ['Monday']
    scheduleStartDate: '2023-01-01T08:00Z'
    scheduleEndDate: '2024-01-01T08:00Z'
  }
}
```
