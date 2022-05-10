param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$file,
    [Parameter(ParameterSetName="r")]
    [string]$range=0,
    [int]$timeout=0,
    [string[]]$exclude
)

function checkRange($range) {
    if (!($range -match '^([0-9]+\-[0-9]+)$')) {
        Write-Host "Wrong range"
        Exit-PSSession
    }
    elseif ([int]$range.split('-')[0] -ge [int]$range.split('-')[1]) {
        Write-Host "Wrong range"
        Exit-PSSession
    }
   

}

function portscanning($port) {
    $socket = New-Object system.Net.Sockets.TcpClient
    $conn = $socket.ConnectAsync($h,$port)
    $msg = "Port $port "
    #Waiting for connection to be established or refused
    for($i=0; $i -lt 5; $i++){
        if ($conn.IsCompleted) {
            break
        }
        Start-Sleep -Milliseconds 50
    }
    $status = "Filtered"
    if ($conn.IsFaulted -and $conn.Exception -match "refus") {
        $status = "Closed"
    } elseif ($conn.Status -eq "RanToCompletion") {
        $status = "Open"
    }
    $socket.Close()
    $msg += $status
    Write-Host $msg


}

$start = 1
$end = 1024
if (!($range -eq 0)) { 
   checkRange $range
   $start = [int]$range.split('-')[0]
   $end =  [int]$range.split('-')[1]
}

foreach ($line in Get-Content $file) {
    $h = $line
    if (Test-Connection -Count 1 $h) {
        for($port=$start; $port -le $end; $port++){
            if ($port -notin $exclude) {
                portscanning $port
                Start-Sleep -Milliseconds $timeout
            }
            
        }
    }else {
        Write-Host "Host unreachable"
    }
}

