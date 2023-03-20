# Cost Management scheduled action

Creates a Cost Management scheduled action to notify recipients when an anomaly is detected or on a recurring schedule.

## Description

Use this module within other Bicep templates to simplify creating and updating scheduled actions.

## Parameters

| Name | Type | Required | Description |
| :--- | :--: | :------: | :---------- |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1

Creating a scheduled alert for the DailyCosts built-in view.

```bicep
module dailyCostsAlert 'br/public:cost/subscription-scheduled-action:1.0' = {
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
```

### Example 2

Creating an anomaly alert.

```bicep
module anomalyAlert 'br/public:cost/subscription-scheduled-action:1.0' = {
  name: 'anomalyAlert'
  params: {
    name: 'AnomalyAlert'
    kind: 'InsightAlert'
    displayName: 'My anomaly check'
    emailRecipients: [ 'ana@contoso.com' ]
  }
}
```

