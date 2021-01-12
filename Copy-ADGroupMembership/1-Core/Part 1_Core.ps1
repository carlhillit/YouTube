# Gets User information including the MemberOf property
$ReferenceUser = Get-ADUser -Identity michelle.adams -Properties MemberOf

# Isolate the groups
$SelectedGroups = $ReferenceUser.MemberOf

# Adds TargetUser to groups
$SelectedGroups | Add-ADGroupMember -Members paul.allen


