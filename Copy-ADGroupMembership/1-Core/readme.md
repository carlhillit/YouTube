# Part 1: Core Script - Copy AD Group Membership (Mirror Permissions) w/ PowerShell

## Introduction
Hello and welcome to [Part 1](https://www.youtube.com/watch?v=lVrwnCeJB88) of the video series where we write a PowerShell script that automates the process of adding a new Active Directory user to all of the groups of an existing user.

The script is only three lines of code, but that little bit will save you time and energy in the future.
<br></br>

### Logical Progression / Outline
Whenever I write a script, way before I even start writing any code, I like to map out the logical progression that the script will follow.
I'll do this in the form of comments which start with a number sign ( `#` ).
Everything after the number sign will not be run by PowerShell and is used for any notes, reminders, or explanations that you'd want to put in.

For this script, it's a three-step process:
1. Get the reference user along with group memberships
2. Isolate the group identities from the reference user
3. Add the new user to those groups

### [Get-ADUser](https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-aduser?view=win10-ps)
First, I'll explain how to use the `Get-ADUser` command to get information about the reference user and the groups that she is a member of.

If we just run the `Get-ADUser` command by itself, PowerShell won't know from which user to get the information for and the command won't work. We want to identify _Michelle_ as the user to get.

To identify Michelle as the user, we'll use the `-Identity` parameter.

Parameters are extra bits of information that you're adding to the command to narrow the scope or help specify the task that you're telling PowerShell to do
    and they always start with a dash (`-`).

`Get-ADUser` has many parameters and I may show those later in some other videos, but for now, I'm only going to be concerned with the `-Identity` parameter.

The command is going to look like:

    Get-ADUser -Identity [USER]


`[USER]` can be identified by:
* distinguished name
* GUID (objectGUID)
* security identifier (objectSid)
* SAM account name (sAMAccountName)

I, personally, like to use the SAM account name because it's almost universally accepted in PowerShell commands, and it's usually short and easy to remember.

The SAM account name can be found in Active Directory Users and Computers.

Now, I've heard it pronounced A-D-U-C, Ay-duck, or a duck, but saying that we're going to look for Michelle inside a duck just sounds kind of silly,
    so I'm just going to pronounce it "A-D-U-C"

The SAM account name can be found by double-clicking on the user, selecting the **Account** tab, and it'll be under **User Logon Name (Pre-Windows 2000)**.

You can find each of the other identifiers in ADUC by going to the toolbar at the top, clicking on **View**, and ensure **Advanced Features** are enabled.

Then double-click on the user and select the **Attribute Editor** tab.


Now that we've got the correct identity of our example user, Michelle, we're ready to use the command.

    Get-ADUser -Identity michelle.adams


### Object [Properties](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/03-discovering-objects?view=powershell-5.1)

By default, the `Get-ADUser` command returns these 10 bits of information about the user. These bits are called "properties", and every PowerShell object has them. 

If you want to retrieve additional properties with `Get-ADUser`, you must use the `-Properties` parameter.

If you want too view all properties of a user, use the asterisk (`*`) wildcard.

    Get-ADUser -Identity michelle.adams -Properties *


For our script, we want the `MemberOf` property.
So we type in:

    Get-ADUser -Identity michelle.adams -Properties MemberOf


We can see the same 10 properties as before, with an additional 11th that shows Michelle's AD group membership.

These groups are in Distinguished Name format, which isn't easy to read or type, but that's OK because in the next segment, we're going to store these group names in memory so we don't actually have to ever type them in.
<br></br>

### Storing Values in [Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_variables?view=powershell-5.1)

PowerShell objects can be stored using something called **variables**. After a variable is assigned a value, we can then call it later to return the stored object.

Variables can be things may things, but the most common are numbers, text, or PowerShell objects.

They are represented by text strings that begin with a dollar sign `$`, such as `$a`, `$process`, or `$my_var`.

Names of variables, like most everything in PowerShell, are not case-sensitive.

They can be UPPERCASE, lowercase, PascalCase (which is capitalizing the 1st letter of each word and not using spaces), or anything in between.

To create a new variable, use an assignment statement to assign a value to it.

    $text = 'text'

The assignment statement can be used with or without spaces around the equals (`=`) sign, but _with_ spaces are the recommend style to make it easier to read when scripting.[1]

Keep in mind that without the assignment statement, the default value of all variables is **$null**, that is, nothing or without value.
If you try to call a variable before it's been assigned a value, you'll get nothing in return.
<br></br>

Let's assign the output of our previously used `Get-ADUser` command to the variable name `$ReferenceUser`.

    $ReferenceUser = Get-ADUser -Identity michelle.adams -Properties MemberOf

_No output is given during a variable assignment._

We then recall the output of the command stored, by simply typing in the variable name.

    $ReferenceUser

If we type in `$ReferenceUser`, we'll get the output just the same as if we were to type in the command by itself.

We now have completed the **first segment of the script!**

[1]: https://poshcode.gitbooks.io/powershell-practice-and-style/content/Style-Guide/Code-Layout-and-Formatting.html
<br></br>


To return an individual property of an object stored as a variable, type the variable name, dot, and the property name.

    $ReferenceUser.MemberOf

Now we have isolated the groups that we want to add the new user to, let's assign the groups to the `$SelectedGroups` variable to complete the **second part of our script**.
<br></br>

### [Add-ADGroupMember](https://docs.microsoft.com/en-us/powershell/module/addsadministration/add-adgroupmember?view=win10-ps)
The final step in our script is to add our new user, Paul, to the selected groups with the `Add-ADGroupMember` command.


Add-ADGroupMember works like:

    Add-ADGroupMember -Identity [GROUPNAME] -Members [NEWUSER]


The `-Identity` parameter for this command specifies the _group that receives_ the new members.
You can identify a group by the same ways as `Get-ADUser`:
(again, I prefer to use SAM account name):
* Security Account Manager (SAM) account name
* distinguished name (DN)
* GUID
* security identifier (SID)


The `-Members` parameter specifies the new members to add to a group.
You can identify new members by the same ways as you can with the `-Identity` parameter.

To demonstrate the `Add-ADGroupMember` command, let's add Paul to the Sales group.

    Add-ADGroupMember -Identity Sales -Members paul.allen

*No output is given but we can confirm that the command worked by looking in ADUC.*
<br></br>

Now, we will want do the last step and add Paul to the four groups that Michelle is a member of.

If we try:

    Add-ADGroupMember -Identity $SelectedGroups -Members paul.allen

We'll get an error because the `-Identity` parameter does not accept more than one group, as stated in the Microsoft PowerShell documentation.

It does, however, accept input from the pipeline.

So we'll just use the **pipeline** to pass that information onto the `Add-ADGroupMember` command.

A word of caution: each PowerShell command behaves just a little bit differently from the others.

If something doesn't work the way you think it should, look to the documentation.


### Passing Objects Through the [Pipeline](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/04-pipelines?view=powershell-5.1#the-pipeline)

The **pipeline** is represented by the `|` symbol.
It is how we can take the output of one command from the left side of the pipe, and use it as input of another command on the right of the pipe.

When we use the pipeline, it allows us to chain multiple commands together into a super-command that can create many more possibilities of automation.



Let's try it out and add user Paul Allen to all of the groups that Michelle is a member of using all that we learned so far and chain them together with the pipeline.

    $SelectedGroups | Add-ADGroupMember -Members paul.allen

_No output is given but we can confirm that it worked by looking in ADUC._

Awesome! That worked! **We now have completed the last part of the script!**
<br></br>

Let's review the entire core script:

    # Gets User information including the MemberOf property
    $ReferenceUser = Get-ADUser -Identity michelle.adams -Properties MemberOf

    # assigning only the groups to variable
    $SelectedGroups = $ReferenceUser.MemberOf

    # Adds TargetUser to groups
    $SelectedGroups | Add-ADGroupMember -Members paul.allen

If you're using Visual Studio Code or PowerShell ISE, you can run the completed script with the **RUN** button.

Verify the results in ADUC and scan the PowerShell console for any errors that could indicate any mistakes that you might have made.

*End of Part 1*

