# assign user SAM account names to variables
$ReferenceUserSAM = 'michelle.adams'
$TargetUserSAM = 'paul.allen'

# Gets User information including the MemberOf property
$ReferenceUser = Get-ADUser -Identity $ReferenceUserSAM -Properties MemberOf

# Use Out-GridView window to select groups
$SelectedGroups = $ReferenceUser.MemberOf | Out-GridView -Title "Select groups to add $TargetUserSAM to" -PassThru

# Adds groups to TargetUser
$SelectedGroups | Add-ADGroupMember -Members $TargetUserSAM
