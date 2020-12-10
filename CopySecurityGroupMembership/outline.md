## Introduction:
Hello and welcome to PowerShell Breakdown where we break down real PowerShell scripts used in the enterprise in order to teach concepts, best practices, and a few tips & tricks in a practical way.

Today I will be breaking down my [Copy-SecurityGroupMembership](./Copy-SecurityGroupMembership.ps1) script. 

What this script does is find all of the Active Directory security groups a user is a member of and makes another user a member of those same groups.
This procedure is also known as "permissions mirroring".
It is typically used when a user should have the same access rights and permissions of another user.

## Demonstrate the procedure manually

1. Open Active Directory Users and Computers
2. Double-click on the user to use as a reference
3. Select the **MemberOf** tab
4. Keep window open somewhere on the screen where it is visible

5. Double-click on the user to add to groups
6. Select the **MemberOf** tab, click **Add...**
7. Enter the names of the groups from the reference user, seperated by a semicolon (`;`)
8. Verify with **Check Names**
9. Click **OK** and **OK** again
<br></br>

## Breakdown Overview:
While the manual process isn't too cumbersome in our example, we can use PowerShell to automate this process.

In [Part 1](./Part1.md), I'll breakdown the core of the script where we will be learning the `Get-ADUser` and `Add-ADGroupMember` cmdlets
    and then we'll go over the concepts of storing an object as a variable as well as passing objects through the pipeline.

In [Part 2](./Part2.md), we'll add the `Out-GridView` cmdlet to give you a pop-out window so you can select specific groups with a few mouse clicks.

Finally, in [Part 3](./Part3.md), we'll put everything together into an advanced function and add it to a PowerShell module for long-term reuse.
