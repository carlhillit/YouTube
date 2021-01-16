# Cleanup Inactive AD Accounts w/ PowerShell Pt 3: Splatting, Where-Object, Move-ADObject

## Introduction & Script Demonstration

Hello my favorite PowerShellians!

In the previous two videos, I made a simple script that finds and disables all computers in an OU that have not had any users logon to them in the past 45 days and updated the AD description to include the disabled date.

In this video, I'm going to further expand the script by moving the disabled computers to an different OU for inactive computers and then removing the ones from that Inactive OU that haven't had any users logon in the past 90 days.

I'll introduce you, the viewer, to Splatting and the `Where-Object` and `Move-ADObject` commands.
<br></br>

## Script Changes
1. Added variable for the Inactive OU Distinguished Name
2. Combined the parameters for `Search-ADAccount` command into a hash table for a splatting variable.
3. Filtered out the Inactive OU with `Where-Object` during the first search.
4. Moved the inactive computers to the Inactive OU with `Move-ADObject`.
5. Code block to remove computers from the Inactive OU that have been inactive for 90 days.
<br></br>

## [Splatting](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-5.1)
Splatting is a way to pass a collection of parameter inputs to a command all at once.

When writing a script, splatting makes it easier to read and understand the parameters and their input values when commands have more than two or three parameters.

Instead of one big line, a splatting variable uses a [hash table](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-5.1) to store the parameter name and input in pairs.

Splatting variables, like normal variables begin with a dollar sign ( `$` ), a name and an equals sign ( `=` ).

To make a hash table, type an at symbol ( `@` ) and curly braces ( `{}` )

Inside the braces, the value pairs are added, with an equals separating the key from the value.

The item left of the equals sign will be the parameter name and the item on the right is the parameter input.

Regular variables can be used as inputs in the hash table.

Switch parameters' must have a value that is either `$true` or `$false`.

Instead of this:

    Search-ADAccount -AccountInactive -TimeSpan $DaysInactive -ComputersOnly -SearchBase $ComputersOU

Use this:


    $searchParams = @{
        AccountInactive = $true
        TimeSpan = $DaysInactive
        ComputersOnly = $true
        SearchBase = $ComputersOU
    }



By typing the variable `$searchParams` in PowerShell, you can see the result as a table.

    Name                           Value
    ----                           -----
    SearchBase                     OU=Computers,OU=LAB,DC=breakdown,DC=lab
    ComputersOnly                  True
    AccountInactive                True
    TimeSpan                       45.00:00:00


Once the hash table is complete, type the at sign ( `@` ) then the splatting variable name after the command.

    Search-ADAccount @searchParams

<br></br>

## Where-Object

I don't want to add an additional date to the description each time the script is run.
To prevent that, I will exclude the computers from the Inactive OU from the initial search.

`Search-ADAccount` does not have a `-Filter` parameter so I'll use the `Where-Object` command to filter out these computers instead.

`Where-Object` typically receives input from the pipeline and then, selects objects based on their property values.

The `-Property` parameter identifies the property to compare.

    Search-ADAccount @searchParams | Where-Object -Property




I can compare things with a [comparison operator](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-5.1).

The simplest comparison operator is equals ( `-eq` ).

*Comparison operators begin with a dash ( `-` ). `-eq` is a comparison operator, the equals sign ( `=` ) assigns value to a variable.*

This will display only the result where the name is Win201.

    Search-ADAccount @searchParams | Where-Object -Property Name -eq 'Win201'

To find a match for a string using a wildcard ( `*` ), use comparison `-like`.

    Search-ADAccount @searchParams | Where-Object -Property Name -like 'Win*1'

I need to compare the DistinguishedName of the computer to the Distinguished name of the Inactive OU since the distinguished name of a computer has the DN of the OU in it.
I can use a wildcard in front of the OU DN to find the computers in the OU.
I'll use the opposite of the `-like` operator, `-notlike`, along with the `$InactiveOU` variable and a wildcard to find computers that are not in the Inactive OU.

    Search-ADAccount @searchParams | Where-Object -Property DistinguishedName -notlike "*$InactiveOU"

*A common way that `Where-Object` is typed like ForEach-Object with braces ( `{}` ) and the variable `$_` used to represent the object received from the pipeline. But I think it's simpler for new PowerShell users to use the `-Property` parameter.*

    Search-ADAccount @searchParams | Where-Object {$_.DistinguishedName -eq 'Win201'}

<br></br>
*Disabled accounts is unchanged from the previous script.*

## [Move-ADObject](https://docs.microsoft.com/en-us/powershell/module/addsadministration/move-adobject?view=win10-ps)

Move-Object is fairly simple if you've watched my other videos.

    Move-ADObject -Identity ADOBJECT -TargetPath DistinguishedName

The Identity parameter's input is an AD Object. The results of `Search-ADAccount` is an array (collection) of AD objects, so we can pipe that into `Move-ADObject`, and the use `-TargetPath` to determine where to move the object to.

`-TargetPath` input is in distinguished name format.

    $InactiveComputers | Move-ADObject -TargetPath $InactiveOU

<br></br>


<br></br>

## Searching for Unused Computers

This is not much different from earlier except the search is in the Inactive OU only for computers that have been inactive for 90 days.
Those are determined to be unused and will be removed.

### Adding Timespans

Timespans can added together just like numbers (integers), so to double the number of days inactive:

    $DaysInactive+$DaysInactive


### [Remove-ADComputer](https://docs.microsoft.com/en-us/powershell/module/addsadministration/remove-adcomputer?view=win10-ps)
This one is straight forward: pipe the `$UnusedComputers` variable into `Remove-ADComputer` to remove from Active Directory.
<br></br>

## Script Choices & Decisions

I've opted to use the $UnusedComputers variable as s middle ground between the simpler

    Search-ADAccount @searchParams | Remove-ADComputer

and leaving an opening to export those computers that are going to be removed to a file for those people that prefer to have them.

    $UnusedComputers | Export-Csv -Path '\\server\share\folder\removed_computers.csv'

<br></br>

## Script Review


Let's take a look at ADUC to see the result.
<br></br>

*End of Part 3, conclusion of AD Cleanup series*

