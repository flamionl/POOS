param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$file
)

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
foreach ($line in Get-Content $file) {
    $h = $line
    if (Test-Connection -Count 1 $h) {
        for($port=1; $port -le 1024; $port++){
            portscanning $port
            
        }
    }else {
        Write-Host "Host unreachable"
    }
}
