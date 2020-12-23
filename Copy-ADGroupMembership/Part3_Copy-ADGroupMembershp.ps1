function Copy-ADGroupMembership {

    <#
    .SYNOPSIS
        Finds all of the Active Directory groups that a reference user is a member of and makes another user a member of those same groups.

    .DESCRIPTION
        Gets all of the Active Directory groups that a reference user is a member of and add the target user a member of those groups.
        This effectively gives the target user the same access rights as the reference user.

    .INPUTS
        SAM account name of reference user to get get group membership from.

    .OUTPUTS
        Groups that the target user is added to are returned if the -PassThru parameter is specified.

    .EXAMPLE
        Copy-ADGroupMembership -ReferenceUser michelle.adams -TargetUser paul.allen -UsePicker
    
    .EXAMPLE
        Copy-ADGroupMembership -ReferenceUser michelle.adams -TargetUser paul.allen

    .EXAMPLE
        Copy-ADGroupMembership -ReferenceUser michelle.adams -TargetUser paul.allen,timothy.allen
    
    .EXAMPLE
        Get-ADUser -Identity michelle.adams | Copy-ADGroupMembership -TargetUser paul.allen -UsePicker

    #>
    
    Param(
        [CmdletBinding()]
    
        # AD user's group membership to use as a reference for groups to add target user to
        [Parameter( Mandatory,
                    HelpMessage='Reference user to gather group membership from',
                    ValueFromPipeline )]
        [Microsoft.ActiveDirectory.Management.ADUser]
        $ReferenceUser,

        # User(s) to add to groups of which ReferenceUser is a member of
        [Parameter( Mandatory,
                    HelpMessage='User to add to groups from reference user')]
        [Microsoft.ActiveDirectory.Management.ADPrincipal[]]
        $TargetUser,

        # Uses Out-GridView to individually select groups to add the target user(s) to
        [Parameter()]
        [switch]
        $UsePicker,

        # Passes the group objects to console
        [Parameter()]
        [switch]
        $PassThru

    )
       
    
    process {
    
        # Gets User information including the MemberOf property
        $ReferenceUserGroups = Get-ADUser -Identity $ReferenceUser -Properties MemberOf

        # Select groups
        if ($UsePicker) {
            $SelectedGroups = $ReferenceUserGroups.MemberOf | Out-GridView -Title "Select groups to add $TargetUser to" -PassThru
        }
        else {
            $SelectedGroups = $ReferenceUserGroups.MemberOf
        }

        # Adds target user(s) to selected groups
        if ($PassThru) {
            $SelectedGroups | Add-ADGroupMember -Members $TargetUser -PassThru
        }
        else {
            $SelectedGroups | Add-ADGroupMember -Members $TargetUser
        }
    
    }
    
    
}


