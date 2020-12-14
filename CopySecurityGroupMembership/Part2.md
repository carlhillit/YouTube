## Part 2 Intro
Hello and welcome to **Part 2** of the breakdown of my script which finds all of the Active Directory security groups a user is a member of and makes _another_ user a member of those same groups.
<br></br>

### Recap
In [Part 1](./Part1.md), we retrieved the group membership of a user using the `Get-ADUser` cmdlet along with the `MemberOf` property.
We stored the output of that command in a variable and selected only the `MemberOf` property.
And then finally, we piped that into the `Add-ADGroupMember` cmdlet to complete the core script.
<br></br>

## Using [Out-GridView](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/out-gridview?view=powershell-5.1) for Group Selection
In this video we'll [expand the script](./Part2_AddOutGridView.ps1) that we built previously by using `Out-GridView` to bring up an interactive window where we can individually select which groups to add the target user to.
<br></br>

### Use Cases and Scenario
This feature is added to the script because there _are_ scenarios in which an administrator does not want to blindly copy group membership.

Let's use our familiar example scenario where a new employee, Paul, is joining the Breakdown Lab Sales team.
Michelle Adams is the Senior Sales Representative and has access to all the network resources that Paul should have as well.
In our previous video, we gave Paul the same access as Michelle with the core script.
Normally, this would be okay, but there is one major consideration that can make using our previous script a huge problem:
Michelle is now a supervisor and has access to an additional, restricted network folder that Paul should not have access to via the 'Sales Supervisors' group.

Now, we still want to leverage the automation that PowerShell provides when performing this task but also want to have a human give the OK
    and/or filter out any groups that may not be appropriate for our new user.

This is where `Out-GridView` is worth it's weight in gold.
<br></br>

### Description
The `Out-GridView` cmdlet sends the output from a command to a grid view window where the output is displayed in an interactive table.
<br></br>

### Demonstration
Here's quick example of how the grid view displays properties of a PowerShell object. We'll use Michelle as the example user.

```powershell

Get-ADUser -Identity michelle.adams | Out-GridView

```

To get a full appreciation of what `Out-GridView` can do, let's display all AD users in the grid view windows.

```powershell

Get-ADUser -Filter * | Out-GridView

```

Now that we have many command results with multiple properties, we can begin to explore the features of the grid view window.

### Out-GridView Features
The grid view window has the following features:

* Hide, Show, and Reorder Columns
* Sort rows
* Quick Filter
* Add Criteria Filter

_demonstrate all features of grid view window_
<br></br>

### Script Implimentation

```powershell
$SelectedGroups = $UserGroups.MemberOf | Out-GridView  -Title "Select groups to add $TargetUser to" -PassThru
```


_for those hawk-eyed viewers, we've used double-quotes (`"`) instead of single quotes (`'`) for the grid view window title._

When using a variable, use the double-quotes to display the value of the varaible. Use single quotes to display the literal string.
```
PS C:\> $TargetUser = 'paul.allen'
PS C:\> $text1 = 'Text displaying $TargetUser with single quotes'
PS C:\> $text1
Text displaying $TargetUser with single quotes
PS C:\> $text2 = "Text displaying $TargetUser with single quotes"
PS C:\> $text2
Text displaying paul.allen with single quotes
PS C:\>

```


<br></br>

### End of Part 2
This concludes **Part 2**.
To recap, we covered the `Out-GridView` cmdlet and how to use it to display and select object properties in an interactive window.
We also demonstrated the difference between single and double quotes when displaying variables in a text string.

If you liked the video and want to see more, please subscribe to my channel.
If you have any questions about this script or have any suggestions for future videos, leave them in the comments.
As always, the script as shown and the write-up will be uploaded to my GitHub which is linked in the description.

Thank you for watching, and I hoped you learned something.

Stay tuned for [Part 3](./Part3.md) where we'll take our script to the next level by wrapping it into an advanced function to turn it into a reusable tool on par with native PowerShell cmdlets.