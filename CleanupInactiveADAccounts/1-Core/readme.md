# Cleanup Inactive AD Accounts w/ PowerShell Pt 1: New-Timespan, Search-ADAccount, Disable-ADAccount

## Introduction

This script that I'm showing in [this video](https://www.youtube.com/watch?v=REy_NNYCabo) disables inactive (aka stale) computers in Active Directory.

To be more specific, it disables all of the computers in an Organization Unit that have not had any users logon to them in the past 45 days.

I'm using computers in this script, but everything shown is applicable for user accounts as well.

*To convert this to script to use users instead of computers, simple change each instance of "computer" with "user".*
<br><br>

## Mapping the Script Process

I'll start by typing the three main steps of the script to map out the logical process the script will follow.

The steps will by typed in the form of comments by using the number sign ( `#` ).

1. Define the "inactive" time period (45 days)
2. Search for the accounts in the Computers OU that are inactive past the defined time period
3. Disable the accounts
<br></br>

## Create Timespan with [New-TimeSpan](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-timespan?view=powershell-5.1)

To defined the inactive timespan, I'll create a timespan object of 45 days to use in step two with the `Search-ADAccount` command.

To create a timespan object, the command to use is `New-TimeSpan`.

I need to let PowerShell know that I want 45 days and not 45 hours or 45 seconds.

I then press SPACE, then type a dash ( `-` ).

I'll use the `-Days` parameter to specify 45 days.

    New-TimeSpan -Days 45

These options are called "parameters" and it's used narrow the scope or help specify the task that I'm telling PowerShell to do.

They will always start with a dash ( `-` ).

Now I'll run the command and see that the object is 45 days.
<br</br>

### Alternative Timespan Methods

There are other ways to create a timespan object, but I prefer the `New-TimeSpan` command because it is easiest to read and understand for those who are not familiar with using timespans in PowerShell.

*This first step is not necessary, as the `-TimeSpan` parameter accepts a timespan object as input so it could be written as Search-ADAccount -Timespan '45'.*

*Other ways to create a timespan object of 45 days would be: `[timespan]'45'` or `[timespan]45d`.*

*WARNING: it is easy to mistake `[timespan]'45'` for `[timespan]45`. The latter is not correct, as the object returned is 45 ticks ( 0.009 milliseconds) and not 45 days. This would cause all accounts to be disabled, as all accounts will meet the criteria of 0.009 milliseconds.*

### Variables

I'll next store the timespan in a [variable](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_variables?view=powershell-5.1) to use in later steps.

Variables are a way to store things like text, numbers, or PowerShell objects in the computer's memory that can then be later recalled.

Variables are created by typing a dollar sign ( `$` ) followed by the variable name. The name can be in uppercase, lowercase, or any combination of cases.

*For names with more than one word, I like the [preferred convention](https://github.com/PoshCode/PowerShellPracticeAndStyle/blob/master/Style-Guide/Code-Layout-and-Formatting.md#capitalization-conventions) of using Pascal Case by capitalizing the first letter of each word and use no dashes ( `-` ) or underscores ( `_` ) so that it's easy to read.*

Variables are then given value by typing the variable name, an equals sign ( `=` ) and then the value.

    $DaysInactive = New-TimeSpan -Days 45

I have now finished the first step in the script!
<br></br>

## [Search-ADAccount](https://docs.microsoft.com/en-us/powershell/module/addsadministration/search-adaccount?view=win10-ps)

Next I need to search for the accounts that are inactive using the `Search-ADAccount` command.

This command has been used in a previous video to search for locked-out accounts, but this time I want to search for **inactive** accounts.

I'll use the `-AccountInactive` parameter to let the command know what I want to search for.
<br></br>

### -AccountInactive

This parameter finds the accounts that are inactive based on the **lastLogondate** PowerShell property, also know as the lastLogonTimestamp attribute found in the Attribute Editor in ADUC.

While the attribute that is shown here will likely not be up-to-date, it is good enough for my use in this script.

If you'd like know a way to get more accurate results, check out the write-up on GitHub linked in the description. 

*The lastLogondate/lastLogonTimestamp will be 9-14 days behind the current date as the attribute is replicated infrequently. The lastLogon attribute is updated accurately, but only on the domain controller that authenticated the account logon. Therefore, one must query all domain controllers in the domain for the lastLogon attribute and compare for the most recent.*

*Here's an [alternate script](../CleanupAD_AccurateLastLogon.ps1) using the lastLogon attribute gathered from all DCs.*
<br></br>

### -TimeSpan vs -DateTime

When the `-AccountInactive` parameter is used, we need an additional parameter to specify either a date or timespan in which to determine the accounts to be inactive.

#### DateTime

This means that everything before a given date is determined to be "inactive".

If this option is used, I would have to calculate a date that is 45 days in the past from the date when the script is run.

#### TimeSpan

This means that everything prior to the timespan of 45 days is deemed "inactive".

The advantage of this option is that no date calculation is needed.

### -ComputersOnly

In my Active Directory lab environment, computer and user accounts are kept in separate OUs.

If the OU contains both computer and user accounts, add the `-ComputersOnly` parameter to only search for computers.
<br></br>

### -SearchBase

I can further narrow my search by adding `-SearchBase` followed by the DistinguishedName of the OU.

The DistinguishedName is found in ADUC by right-clicking on the OU, selecting **Properties**, and viewing the **Attribute Editor** tab.

Double-click on the attribute and copy the name to the clipboard.

Paste it into the script and add quotes around it to make it a text string.

I then assign this command and its parameters to the `$InactiveComputers` variable to complete the second step.
<br></br>

## [Disable-ADAccount](https://docs.microsoft.com/en-us/powershell/module/addsadministration/disable-adaccount?view=win10-ps)

Next, I'll use the `Disable-ADAccount` command to disable the computer account.

To use the command by itself, I would use `Disable-ADAccount -Identity COMPUTER`.

I can identify the computer by one of these attributes, found in ADUC in the **Attribute Editor**.

* distinguished name
* GUID (objectGUID)
* Security Identifier (objectSid)
* SAM Account Name (SAMAccountName)

Note that by default, computers' SAM Account names end with a dollar sign ( `$` ) which is different from user accounts.

The `-Identity` parameter does not normally accept multiple identities as seen here in the Microsoft Documentation, but it can by using the [pipeline](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/04-pipelines?view=powershell-5.1#the-pipeline).

The **pipeline** is represented by the pipe ( `|` ) symbol and it is how we can take the output of one command from the left side of the pipe, and use it as input of another command on the right.

Since the `-Identity` parameter can receive input from the pipeline, it can disable multiple computers at once by piping the computer objects returned from `Search-ADAccount`.

The `-PassThru` parameter is not necessary, but I like to use it because it shows which computers are being disabled.

If I want, I can also add something like `| Export-Csv` to export the disabled computers to an [Excel-readable file](https://en.wikipedia.org/wiki/Comma-separated_values).

That completes step three.

Let's review the final script:

## Final Script Review

First, I created a Timespan of 45 days and assigned that value to the `$DaysInactive` variable.

Next, I searched for all inactive AD accounts within the 45 days timespan and looking in the Computers OU.

That result is assigned to the `$InactiveComputers` variable, which is finally piped into the `Disable-ADAccount` command.

With the `-PassThru` parameter, I can see which computers are disabled.

*Entire script is run*

Verify the results in ADUC and scan the PowerShell console for any errors that could indicate any mistakes that you might have made.

*End of Part 1*

