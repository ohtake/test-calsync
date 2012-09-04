$private = (Join-Path (pwd) "private.ics")
$public = (Join-Path (pwd) "public.ics")

$outlook = New-Object -ComObject Outlook.Application
$folder = $outlook.Session.GetDefaultFolder(9) # olFolderCalendar = 9
$exporter = $folder.GetCalendarExporter()
$exporter.CalendarDetail = 2 # olFullDetails = 2
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
    if ($str -match "^SUMMARY:\[TW\] (.)?.*") {
        return "SUMMARY:[TW] " + $Matches[1]
    } elseif ($str -match "^SUMMARY(?:;[^;:]*)*:(.)?.*") {
        return "SUMMARY:" + $Matches[1]
    } else {
        return $str
    }
}
function is-description([string]$str) {
    $str -match "^(?:DESCRIPTION:|X-ALT-DESC[;:])"
}

$lines = cat $private -Encoding UTF8
$lines = normalize-ical $lines
$lines = $lines |% {replace-summary($_)}
$lines = $lines |? {(is-description($_)) -eq $false}
$lines | Out-File -Encoding UTF8 $public

