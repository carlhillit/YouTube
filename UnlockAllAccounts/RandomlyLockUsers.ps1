[CmdletBinding()]
param (

    # number of users to lock out
    [Parameter(ParameterSetName = 'NumberToLock')]
    [int]
    $NumberToLock,

    # Percentage of users in the OU/domain to lock out
    [Parameter(ParameterSetName = 'PercentToLock')]
    [int]
    $PercentToLock,

    # number of times allowed for failed logon attempts before lockout
    [Parameter(Mandatory)]
    [int]
    $LockoutThreshold,

    # Organizational Unit to search for users to lock out
    [Parameter()]
    [Microsoft.ActiveDirectory.Management.ADOrganizationalUnit]
    $OrganizationalUnit = 'OU=Users,OU=LAB,DC=breakdown,DC=lab'
)


begin {
    $NetBiosName = (Get-ADDomain).NetBiosName

    $Users = Get-ADUser -Filter * -SearchBase $OrganizationalUnit

    if ($PercentToLock) {

        $NumberOfUsers = [math]::Round($Users.Count * $PercentToLock/100)

    }

    if ($NumberToLock) {

        $NumberOfUsers = $NumberToLock
    
    }

}

process {


    $SelectedUsers = 1..$NumberOfUsers | ForEach-Object{
        Get-Random -InputObject $Users
    }


    foreach ($User in $SelectedUsers) {

        $username = "$NetBiosName\$($User.SamAccountName)"
        $password = '9ijnht5%TGBHU*&YGVFR$4rfvgy7' | ConvertTo-SecureString -AsPlainText -Force
        $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

        1..$LockoutThreshold | ForEach-Object {

            Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock {"lockmeout"} -Credential $cred -ErrorAction SilentlyContinue
            
        }

    }


}

end {

    $SelectedUsers

}