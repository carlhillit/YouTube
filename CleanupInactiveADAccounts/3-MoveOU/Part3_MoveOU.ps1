
# number of past days where a user has not logged onto a computer
$DaysInactive = New-TimeSpan -Days 45

# OU in which to disable inactive computers
$ComputersOU = 'OU=Computers,OU=LAB,DC=breakdown,DC=lab'

# OU in which to move the inactive/disabled computers
$InactiveOU = 'OU=Inactive,OU=Computers,OU=LAB,DC=breakdown,DC=lab'


# get all computer accounts that have not been logged into with X days
$searchParams = @{
    AccountInactive = $true
    TimeSpan = $DaysInactive
    ComputersOnly = $true
    SearchBase = $ComputersOU
}

$InactiveComputers = Search-ADAccount @searchParams | Where-Object -Property DistinguishedName -notlike "*$InactiveOU"

# append disabled date to description
$DisabledDate = Get-Date -Format yyyy-MM-dd # date format that goes into computer description

foreach ($Computer in $InactiveComputers) {

    $Description = Get-ADComputer $Computer.Name -Properties Description

    $Description = $Description.Description

    Set-ADComputer $Computer.Name -Description "Inactive, disabled on $DisabledDate --- $Description"

}


# disable accounts
$InactiveComputers | Disable-ADAccount -PassThru

# Move to disabled computers OU
$InactiveComputers | Move-ADObject -TargetPath $InactiveOU
    

# remove computers from Inactive OU
$searchParams = @{
    AccountInactive = $true
    TimeSpan = $DaysInactive+$DaysInactive # double days inactive
    ComputersOnly = $true
    SearchBase = $InactiveOU
}

$UnusedComputers = Search-ADAccount @searchParams

$UnusedComputers | Remove-ADComputer