## Part 1 Intro
Hello and welcome to **Part 1** of the video series where we write a PowerShell script that automates the process of adding a new Active Directory user to all of the groups of an existing user. This will then grant the new user all the rights and permissions of the existing user.

The example that we are using is: a new user, Paul Allen is joining the Breakdown Lab Sales team with Michelle Adams. The new user, Paul, requires all rights and permissions that Michelle has.

In this first part, we will write the [core of the script](./Part1_Core.ps1) using two PowerShell commands. They are called `Get-ADUser` and `Add-ADGroupMember`. We will then learn how to view and isolate specific pieces of information from these commands with PowerShell properties.
Futhermore, we will go over how to store command output and other information into the computer's memory using variables, and finally we'll show how to send the output of one command to another command as input using the pipeline.
<br></br>

### [Get-ADUser](https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-aduser?view=win10-ps)

First, I'll explain how to use the `Get-ADUser` command to get information about the existing user (Michelle in the example) and the groups that she is a member of.

We will then use these groups as a reference to know which groups to add the new user, Paul, to.

If we just run the `Get-ADUser` command by itself, PowerShell won't know from which user to get the information for and the command won't work. We want to identify Michelle as the user to get.

To identify Michelle as the user, we'll use the `-Identity` parameter.

Parameters are extra bits of information that you're feeding the command to narrow the scope or help specify the task that you're telling PowerShell to do.

`Get-ADUser` has many parameters, but to keep the video from getting too complex, I'm only going to be concerned with the `-Identity` parameter.

So the command will look like:
```powershell
Get-ADUser -Identity [USER]
```

With `Get-ADUser`, you can identify a user by one of the following:
* SAM account name
* name
* distinguished name (DN)
* GUID
* security identifier (SID)

I've ordered these from what I think is the easiest to use, to the hardest to use.

You can find each of these in ADUC by looking for them under the **Attribute Editor** tab for the user. From the toolbar at the top, go to **View** and ensure **Advanced Features** are enabled. If they are not, you will not see the Attirubte Editor tab when viewing a user.

For almost all cases, I prefer to use the SAM account name, and will do so in the future unless stated otherwise.

The SAM account name is also found in the **Account** tab under **User Logon Name (Pre-Windows 2000)**.

I have also added the **Pre-Windows 2000** logon name as a column in ADUC by going to **View** > **Add/Remove Colums** and clicking **Add**.

Now that we've got the correct identity of our example user, Michelle, we're ready to use the command.

```powershell
PS C:\> Get-ADUser -Identity michelle.adams



DistinguishedName : CN=Adams\, Michelle,OU=Users,OU=LAB,DC=breakdown,DC=lab
Enabled           : True
GivenName         : Michelle
Name              : Adams, Michelle
ObjectClass       : user
ObjectGUID        : 498a758a-e821-4ec6-8e70-02f50d5e879b
SamAccountName    : michelle.adams
SID               : S-1-5-21-533011244-818119730-515608282-1400
Surname           : Adams
UserPrincipalName : Michelle.Adams@breakdown.lab



PS C:\>
```

### Object [Properties](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/03-discovering-objects?view=powershell-5.1)

By default, the `Get-ADUser` command gets a limited set of information about the user. These bits of information are called properties. Here we see the properties: DistinguishedName,Enabled,GivenName, etc.

Each PowerShell object has properties. By default, `Get-ADUser` returns these 10 properties.

If you want to retrieve additional properties, you must use the `-Properties` parameter.

To view all properties of an Active Directory User, use the asterisk (`*`) wildcard.

```powershell
Get-ADuser -Identity michelle.adams -Properties *
```

For our script, we want the MemberOf property

```powershell
Get-ADuser -Identity michelle.adams -Properties MemberOf
```

Now we can we can see all of the groups Michelle is a member of.
These groups are in Distinguished Name format, which isn't easy to read or type, but that's OK because in the next segment, we're going to store these group names in the computer's memory so we can recall them later without ever actually having to type them in.
<br></br>

### Storing Values in [Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_variables?view=powershell-5.1)

Oftentimes, we need to store PowerShell objects in the computer's memory so that we can call it for later use.

We do this with **variables**.

Variables can be things may things, but the most common are numbers, text, or PowerShell objects.

Variables are represented by text strings that begin with a dollar sign `$`, such as `$a`, `$process`, or `$my_var`.

Names of variables, like most everything in PowerShell, are not case-sensitive. They can be UPPERCASE, lowercase, PascalCase, or anything in between.

Variable names can include spaces and special characters but should be avoided when possible to avoid any potential problems.

There are more than one type of variable, but in this video we will only be showing user-created variables.

To create a new variable, use an assignment statement to assign a value to the variable.
```powershell
$variable = 'text'
```
The assignment statement can be used with or without spaces before and after the equals (`=`) sign, but _with_ spaces are the recommened style to make it easier to read when scripting.[1]

Keep in mind that without the assignment statement, the default value of all variables is **$null**, that is, nothing or without value.
<br></br>

Now we can variables to store outputs of commands to use later.

Let's assign the output of our previously used `Get-ADUser` command to the variable name `$ReferenceUser`.

```powershell
    PS C:\> $ReferenceUser = Get-ADUser -Identity michelle.adams
    
    PS C:\>
```
No output is given during a variable assignment.

We then recall the output of the command stored, by simply typing in the variable name.

```powershell
    PS C:\> $ReferenceUser



    DistinguishedName : CN=Adams\, Michelle,OU=Users,OU=LAB,DC=breakdown,DC=lab
    Enabled           : True
    GivenName         : Michelle
    Name              : Adams, Michelle
    ObjectClass       : user
    ObjectGUID        : 498a758a-e821-4ec6-8e70-02f50d5e879b
    SamAccountName    : michelle.adams
    SID               : S-1-5-21-533011244-818119730-515608282-1400
    Surname           : Adams
    UserPrincipalName : Michelle.Adams@breakdown.lab



    PS C:\>
```
[1]: https://poshcode.gitbooks.io/powershell-practice-and-style/content/Style-Guide/Code-Layout-and-Formatting.html
<br></br>

Now, let's add the `MemberOf` property to the command and assign it to the variable.

```powershell
PS C:\> $ReferenceUser = Get-ADUser -Identity michelle.adams -Properties MemberOf
```

We can view individual properties of the object stored as a variable by typing the variable name, **dot**, and the property name.

```powershell
PS C:\> $ReferenceUser.MemberOf

CN=ExampleGroup5,OU=Groups,OU=LAB,DC=breakdown,DC=lab
CN=ExampleGroup3,OU=Groups,OU=LAB,DC=breakdown,DC=lab
CN=ExampleGroup2,OU=Groups,OU=LAB,DC=breakdown,DC=lab
CN=Sales,OU=Groups,OU=LAB,DC=breakdown,DC=lab
PS C:\>
```
<br></br>

### [Add-ADGroupMember](https://docs.microsoft.com/en-us/powershell/module/addsadministration/add-adgroupmember?view=win10-ps)
Now we have isolated the groups that we want to add Paul to, we can add him to the groups with the `Add-ADGroupMember` command.

The `Add-ADGroupMember` command adds one or more users, groups, or computers as new members of an Active Directory group.
The command has two parameters that we'll be concerned with for the writing of this script: The `-Identity` and `-Members` parameters.

The `-Identity` parameter specifies the Active Directory group that _receives_ the new members.
You can identify a group by the same ways as `Get-ADUser`:
(again, ordered from easiest to hardest _my opinion_):
+ Security Account Manager (SAM) account name
+ name
+ distinguished name (DN)
+ GUID
+ security identifier (SID)


The `-Members` parameter specifies the new members to add to a group.
You can identify new members by the same five ways as you can with the `-Identity` parameter.

To demonstrate the `Add-ADGroupMember` command, let's add Paul to the Sales group.

```powershell
PS C:\> Add-ADGroupMember -Identity Sales -Members paul.allen

PS C:\>
```

_No output is given but we can confirm that the command worked by looking in ADUC._
<br></br>

To round-out our core script, we will want to get the four groups that Michelle is a member of and pass that information onto the `Add-ADGroupMember` command.

The **pipeline** will help us do exactly that.


### Passing Objects Through the [Pipeline](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/04-pipelines?view=powershell-5.1#the-pipeline)

The **pipeline**, represented by the `|` symbol, is how we can take the output of one command from the left of the pipe and use it as input of another command to the right of the pipe.

Now why would we want to use the pipeline? This allows us to chain multiple commands together into a super-command that is greater than the sum of each part and can open many more possibilities of automation.

Now let's try it out and add user Paul Allen to all of the groups that Michelle is a member of using all that we learned so far and chain them together with the pipeline.

Since the `-Identity` parameter of the `Add-ADGroupMember` command accepts input from the pipleline, we can pipe the groups of the `Get-ADUser` command to it.

```powershell
$ReferenceUser.MemberOf | Add-ADGroupMember -Members paul.allen
```

_No output is given but we can confirm that it worked by looking in ADUC or with the `Get-ADGroupMember` command._

We can see from what we just did is that instead of putting all of the groups in the `-Identity` parameter for `Add-ADGroupMember`, we can pipe the groups from another command instead.

_Keep in mind that the cmdlet that is taking an input object, must have a parameter that accepts input from the pipeline. If it does not it will not work._

The built-in `Get-Help` cmdlet or official documentation will let you know if a cmdlet's parameter accepts input from the pipeline.

<br></br>

Let's review the entire core script:

```powershell
# assign user SAM account names to variables
$ReferenceUserSAM = 'michelle.adams'
$TargetUserSAM = 'paul.allen'

# Gets User information including the MemberOf property
$ReferenceUser = Get-ADUser -Identity $ReferenceUserSAM -Properties MemberOf

# assigning only the groups to variable
$SelectedGroups = $ReferenceUser.MemberOf

# Adds groups to TargetUser
$SelectedGroups | Add-ADGroupMember -Members $TargetUserSAM
```

Congratulations! We now have completed the core script.

If you're using Visual Studio Code or PowerShell ISE, you can run the completed script with the **RUN** button.

Verify the results in ADUC and scan the PowerShell console for any errors that could indicate any mistakes.

### End of Part 1
This concludes **Part 1**. Thank you for watching, and I hoped you learned something.

To recap, we learned:
* How to use the `Get-ADUser` and `Add-ADGroupMember` commands.
* About PowerShell object properties and how to display them.
* How to store objects in memory and recall them using variables.
* How to pass the output of one command through the pipeline into an input of another command.

Next, in [Part 2](./Part2.md), we will learn how to use the `Out-GridView` command to bring up a interactive window to select which reference groups our target user will become a member of.

If you liked the video and want to see more, please subscribe to my channel.
If you have any questions about this script or have any suggestions for future videos, leave them in the comments.
As always, the script as shown and the write-up will be uploaded to my GitHub which is linked in the description.
