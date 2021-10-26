set-executionpolicy -executionpolicy bypass
import-module microsoft.graph.intune
connect-msgraph -adminconsent

get-IntuneManagedDevice | select deviceName, lastSyncDateTime, enrolledDateTime, complianceState, operatingSystem, osVersion, serialNumber, manufacturer, model, userDisplayName | export-csv devices.csv
