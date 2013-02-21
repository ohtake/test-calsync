$private = (Join-Path (pwd) "private.ics")
$public = (Join-Path (pwd) "public.ics")

$outlook = New-Object -ComObject Outlook.Application
$folder = $outlook.Session.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderCalendar)
$exporter = $folder.GetCalendarExporter()
$exporter.CalendarDetail = [Microsoft.Office.Interop.Outlook.OlCalendarDetail]::olFullDetails
$exporter.EndDate = [DateTime]::Now.Date.AddMonths(2)
$exporter.SaveAsICal($private)

function normalize-ical([string[]]$lines) {
    $lines |% -Begin {
        $temp = ""
    } -Process {
        if($_ -match "^\t(.*)") {
            $temp += $Matches[1]
        } else {
            $ret = $temp
            $temp = $_
            if ($ret -ne "") {$ret}
        }
    } -End {
        if($temp -ne "") {
            $temp
        }
    }
}
function replace-summary([string]$str) {
    if ($str -match "^SUMMARY(;[^;:]*)*:(.*)") {
        $length = 1
        $attrib = $Matches[1]
        $value = $Matches[2]
        if($value.Length -gt $length) {$value = $value.Substring(0, $length)}
        return "SUMMARY${attrib}:$value"
    } else {
        return $str
    }
}
function is-description([string]$str) {
    $str -match "^(?:DESCRIPTION|X-ALT-DESC)[;:]"
}
function contains-username([string]$str) {
    $str -match "^(?:ATTENDEE|ORGANIZER|X-MS-OLK-SENDER)[;:]"
}

$lines = cat $private -Encoding UTF8
$lines = normalize-ical $lines
$lines = $lines |% {replace-summary($_)}
$lines = $lines |? {(is-description($_)) -eq $false}
$lines = $lines |? {(contains-username($_)) -eq $false}

# Use UTF-8N since Google Calendar does not support UTF-8 with BOM
$encoding = New-Object System.Text.UTF8Encoding $false
[IO.File]::WriteAllLines($public, $lines, $encoding)

