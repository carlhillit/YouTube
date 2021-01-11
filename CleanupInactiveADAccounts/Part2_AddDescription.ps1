# OU in which to disable inactive computers
$ComputersOU = 'OU=Computers,OU=LAB,DC=breakdown,DC=lab'
$TimespanDays = 45

# number of past days where a user has not logged onto a computer
$DaysInactive = New-TimeSpan -Days $TimespanDays

# search for all computer accounts that have not been logged into with X days
$InactiveComputers = Search-ADAccount -AccountInactive -TimeSpan $DaysInactive -SearchBase $ComputersOU

# disable accounts
$InactiveComputers | Disable-ADAccount -PassThru

# append disabled date to description
$DateDisabled = Get-Date -Format yyyy-MM-dd # date format that goes into computer description

$InactiveComputers | ForEach-Object {

    $ComputerInfo = Get-ADComputer $_.Name -Properties Description

    $Description = $ComputerInfo.Description

    $NewDescription = "Inactive, disabled on $DateDisabled --- $Description"

    Set-ADComputer -Identity $_.Name -Description $NewDescription

}


