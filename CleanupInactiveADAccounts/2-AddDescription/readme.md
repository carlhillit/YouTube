# Cleanup Inactive AD Accounts w/ PowerShell Pt 2: Get-Date, ForEach-Object

## Introduction & Script Demonstration

Welcome back my fellow PowerShell people.

In the previous video, I made a simple script that finds and disables all computers in an OU that have not had any users logon to them in the past 45 days.

In this one, I'm going to expand the script with a feature that adds the date to the computer's description in ADUC.
<br></br>

## Script Changes

To compare the previous script with the completed one in this video, there are two main differences:

1. Computers OU and number of days for the timespan are assigned to variables and placed at the beginning of the script.

It's good practice to place any inputs, like these, in a variable at the top to make it easier to find and change.

The value is assigned here, and the rest of the script uses the variable.


2. (Main addition) Block of code that adds the disabled date to the Active Directory description.

To start, I'll create a new script, copy over the code from Part 1, and add the beginning variables.

I've covered variables in the previous video, so I'll fast forward through the variable assignments.
<br></br>

## Date & Formats

### [Get-Date](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-date?view=powershell-5.1)

To get the current date in PowerShell, use the `Get-Date` command.

By itself, it returns a datetime object and what is displayed is too long to reasonably fit into a computer's description.

I need a way to get the date and display it in a Year-Month-Day format.
I prefer this format because it's short, readable, and can be sorted easily in ADUC.

Add the `-Format` parameter to specify the date format as `yyyy-MM-dd`.

*See [here](https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings?view=netframework-4.8) for all format possibilities.*

    Get-Date -Format yyyy-MM-dd

Now that I have the date in my preferred format, I'll then assign the command to the `$DisabledDate` variable.
<br></br>

## Add Date to Description


### [ForEach-Object](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/foreach-object?view=powershell-5.1)

Since I wish to keep the existing computer description, I need to first gather the description from each computer before I can then add the disabled date to it.

The `ForEach-Object` command allows me to perform the same operation on each one of the computers that are inactive.

The command is typically used by receiving input from the pipeline.

Since I already have the inactive computers stored in the `$InactiveComputers` variable, I am going to use that as the input.

Each object in the collection is represented by the `$_` variable.

I can then display a property of each of the objects by using `$_.Property`.

So to display the name of each of the computers in `$InactiveComputers`, I use:

    $InactiveComputers | ForEach-Object { $_.Name }

All of the code that will have a different input, like the computer's name, will be placed inside the curly braces ( { } ).
<br></br>

### [Get-ADComputer](https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-adcomputer?view=win10-ps)

To add the date to the description, I first need to retrieve the current description from Active Directory. I do this with the `Get-ADComputer` command.

I'll need to use the `-Identity` parameter to specify which computer I'm getting information from.

I can identify the computer the same way I did in [Part 1](./Part1.md) by using the SAM account name as the identifier.

*Alternative identities are: distinguished name, objectGUID, or objectSid*

    Get-ADComputer -Identity WIN201$

In the result, I cannot see the description, so I need to use the `-Properties` parameter to add the Description property to the output.

Now that it's there, I'll assign it to the `$ComputerInfo` variable.

Isolate the description by using `$ComputerInfo.Description` and assign that to the `$Description` variable.

Now, I can simply add the `$Description` variable inside of double quotes to place the text anywhere in the new description.

    $NewDescription = "Inactive, disabled on $DateDisabled --- $Description"

### [Set-ADComputer](https://docs.microsoft.com/en-us/powershell/module/addsadministration/set-adcomputer?view=win10-ps)

To modify the AD computer object, the `Set-ADComputer` command is used.

It's very similar to `Get-ADComputer` except the property to modify is done with a parameter.

I'll use the -Description parameter and the `$NewDescription` variable to change the computer's description to the new one with the date disabled.

    Set-ADComputer -Identity $_.Name -Description $NewDescription

<br></br>

## Script Review

Let's review the additions to the script:

The Computers OU distinguished name and the 45 number is assigned to variables and placed at the top of the script to make it easier to maintain.

The current date is retrieved in an easily readable and sortable format.

Using `ForEach-Object`, the current computer description is retrieved and then added to a text string to make the new description.

That new description is then changed on the computer object.

Those commands are then repeated on each object in the `$InactiveComputers` collection.

Let's take a look at ADUC to see the result.
<br></br>

*End of Part 2*

