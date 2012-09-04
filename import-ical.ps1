# You have to set icalFolderId
$icalFolderId = "00000000FA354B5DB20CEB42A9076B4E6CB4D72122840000"
$prefix = "[TW] "

$outlook = New-Object -ComObject Outlook.Application
$source = $outlook.Session.GetFolderFromID($icalFolderId)
$target = $outlook.Session.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderCalendar)

# Remove imported items
@($target.Items |? {$_.Subject.StartsWith($prefix)}) |% {$_.Delete()}

# Import all
$source.Items |
% {
    $_.Subject = $prefix + $_.Subject
    $copied = $_.CopyTo($target, [Microsoft.Office.Interop.Outlook.OlAppointmentCopyOptions]::olCreateAppointment)
    $copied.BusyStatus = $_.BusyStatus
    $copied.Save()
    [Runtime.InteropServices.Marshal]::ReleaseComObject($_) | Out-Null
}
