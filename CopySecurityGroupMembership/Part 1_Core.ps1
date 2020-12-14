# assign user SAM account names to variables
$ReferenceUserSAM = 'michelle.adams'
$TargetUserSAM = 'paul.allen'

# Gets User information including the MemberOf property
$ReferenceUser = Get-ADUser -Identity $ReferenceUserSAM -Properties MemberOf

# assigning only the groups to variable
$SelectedGroups = $ReferenceUser.MemberOf

# Adds groups to TargetUser
$SelectedGroups | Add-ADGroupMember -Members $TargetUserSAM
