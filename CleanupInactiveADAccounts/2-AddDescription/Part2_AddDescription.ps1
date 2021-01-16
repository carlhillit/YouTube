# OU in which to disable inactive computers
$ComputersOU = 'OU=Computers,OU=LAB,DC=breakdown,DC=lab'
# days inactive
$TimespanDays = 45


# define the inactive threshold
$DaysInactive = New-TimeSpan -Days $TimespanDays

# search for all computer accounts that have not been logged into with X days
$InactiveComputers = Search-ADAccount -AccountInactive -TimeSpan $DaysInactive -SearchBase $ComputersOU

# disable accounts
$InactiveComputers | Disable-ADAccount -PassThru

# add disabled date to description
$DisabledDate = Get-Date -Format yyyy-MM-dd

$InactiveComputers | ForEach-Object {

    $ComputerInfo = Get-ADComputer -Identity $_.Name -Properties Description

    $Description = $ComputerInfo.Description

    $NewDescription = "Inactive, disabled on $DisabledDate -- $Description"

    Set-ADComputer -Identity $_.Name -Description $NewDescription

}

