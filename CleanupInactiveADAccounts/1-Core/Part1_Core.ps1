# define the inactive threshold
$DaysInactive = New-TimeSpan -Days 45

# search for all computer accounts that have not been logged into with X days
$InactiveComputers = Search-ADAccount -AccountInactive -TimeSpan $DaysInactive -ComputersOnly -SearchBase 'OU=Computers,OU=LAB,DC=breakdown,DC=lab'

# disable accounts
$InactiveComputers | Disable-ADAccount -PassThru


