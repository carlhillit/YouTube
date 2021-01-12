# Part 2: Interactive Window (Out-GridView) - Copy Group Membership (Mirror Permissions) w/ PowerShell

## Part 2 Intro

Hello and welcome to [Part 2](https://www.youtube.com/watch?v=09FbxZ44LfQ). In this video we'll add an interactive selection window using `Out-GridView` to our [script](./Part2_AddOutGridView.ps1) that finds the groups of one user and makes _another_ user a member of those same groups.
<br></br>

## Using [Out-GridView](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/out-gridview?view=powershell-5.1) for Group Selection

If we compare the finished script, here, with the one from [Part 1](./Part1_Core.ps1), we can see two changes:
1. The SAM account names of Michelle and Paul are assigned to variables at the very top.
   1. Any user-defined variables should be at the top to make it easier to find for anyone making changes to the script.
   2. Our script here is fairly simple and these SAM account names _are_ easy to find, but you could probably imagine the ordeal in a script that has hundreds or thousands of lines of code. So it's a good habit to get into.
2. Added Out-GridView to filter/select groups before assigning to the `$SelectedGroups` variable.

### Use Cases and Scenario

This feature is added to the script because there _are_ scenarios in which an administrator blindly copying group membership would be a huge problem.

Let's say that user Michelle Adams is now a supervisor of the Sales team at the Breakdown Lab and has access to a restricted network folder via the 'Sales Supervisors' group.

Our new user, Paul, should not have access to _this specific_ folder, but _should_ have access to all other network folders for the Sales team.

Now, we still want to leverage PowerShell to help automate this task but also want to have an adminstrator filter out any groups that may not be appropriate for our new user.

This is where `Out-GridView` is very useful.
<br></br>

### Description & Demonstration

What `Out-GridView` does is display a PowerShell object in an interactive table.

To show a quick example of how the grid view displays a PowerShell object, we'll use the `Get-ADUser` command from the previous video.

    Get-ADUser -Identity michelle.adams

Compare that to the grid view output by piping the command into `Out-GridView`.

    Get-ADUser -Identity michelle.adams | Out-GridView

We can see that the output displays the properties Distinguished Name, Enabled, Name, and so on. And those are the same in the window columns.

To get a full appreciation of what `Out-GridView` can do, let's try it will all AD users.

    Get-ADUser -Filter * | Out-GridView

Now that we have many results with multiple properties, we can begin to explore the features of the grid view window.

### Out-GridView Features

The grid view window has many features.

One of them is that you can sort the rows by clicking on the column header.

On the first click, you will see a small "up" arrow indicating that the rows are sorted in _acending_ order, that is A-Z alphabetically or small to large numerically.

On the second click, the small arrow will change from up to down indicating that the rows are sorted in _decending_ order, that is Z-A reverse alphabetically or large to small numerically.

If you want to hide a column, right-click on a column header and select **Select Columns...**

From the **Selected Columns** box, select a column name and click on the double left arrow button and hit OK and it'll be removed from the window.

_(Not displayed in video: To reorder the columns, go to the **Selected Columns** box, select a column, and click the "up" or "down" arrow to rearrange the order.)_

This field at the top is called **Quick Filter** and it will search all properties of the PowerShell objects displayed in the window that matches the typed pattern.

If we type M-I-C-H it would find both Michelle and Michael because their Given Names both begin with M-I-C-H.

To search a specific property, click the **Add criteria** button and check the box for the property to search.

In this case, select **Surname**. (Surname is another name for Last Name or Family Name) and click **Add**.

We'll leave the selection on **contains**, but you have other filtering options.

Type in the Last Name, "Adams". Now only Michelle Adams is shown in the results.
<br></br>

### -PassThru Parameter

When you want to pass the selction from a grid view window to the console, you'll use the `-PassThru` parameter.

Now, whenever we select a user and hit OK, the object is then output to the console.

You can output multiple users by holding the **Control** key while clicking. All selected users are then output to the console.

Note: hiding columns in the grid view window does not affect the object during pass thru.

#### -Title Parameter

To give the window a title, use the `-Title` parameter.

### Script Implimentation

Here is how we've used it in the script.

    $SelectedGroups = $UserGroups.MemberOf | Out-GridView -Title "Select groups to add $TargetUser to" -PassThru

For those with a keen eye, you'll have noticed that we've used double-quotes (`"`) instead of single quotes (`'`) for the grid view window title text.

When using a variable in a text string, double-quotes are used to display the value of the variable, and single quotes are used to display the literal text.

    'Text displaying $TargetUser variable with single quotes'
    
    "Text displaying $TargetUser variable with double quotes"

This time instead of using run selection, I'll type the name of the script file from PowerShell.
I'll then control + click the groups to add Paul to, leaving out the Sales Supervisors group, and hit OK.
Verify the results in ADUC. Paul Allen now is a member of all of Michelle's groups, except the "Sales Supervisors" group.
<br></br>

### End of Part 2

This concludes **Part 2**.

As always, the script as shown and the write-up will be uploaded to my GitHub which is linked in the description.

Thank you for watching, and I hoped you learned something.