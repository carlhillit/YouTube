$DaysInactive = New-TimeSpan -Days 90

$ComputersOU = 'OU=Computers,OU=LAB,DC=breakdown,DC=lab'

$Computers = Get-ADComputer -Filter * -SearchBase $ComputersOU

foreach ($Computer in $Computers) {
    $ComputerName = $Computer.Name
    
    $lastlogons = Get-ADDomainController -Filter * | ForEach-Object {

        Get-ADComputer -Identity $ComputerName -Properties LastLogon -Server $_.Name | Select-Object LastLogon

    }

    $maxlastlogon = $lastlogons | Measure-Object -Property LastLogon -Maximum

    $AccuLastLogon = [datetime]::FromFileTime($maxlastlogon.Maximum)

    $InactiveDateThreshold = (Get-Date) -$DaysInactive

    ($InactiveDateThreshold -gt $AccuLastLogon)

    if ($InactiveDateThreshold -gt $AccuLastLogon) {
        Disable-ADAccount -Identity $Computer -PassThru -Confirm
    }
    
}

