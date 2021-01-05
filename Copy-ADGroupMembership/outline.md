# Copy Group Membership (Mirror Permissions) for Active Directory Users with PowerShell

## Introduction:
Hello, in this [video series](https://www.youtube.com/playlist?list=PLnkgJzscsB-Dfm5DD-qQeuyEvvv4HNDa5) I will be breaking down my script that finds all of the Active Directory groups that one user is a member of and makes another user a member of those same groups.
This procedure is also commonly known as "permissions mirroring" and is used to grant one user the same access rights and permissions of another user.

## Demonstrate the manual procedure that the script automates

1. Open Active Directory Users and Computers
2. Double-click on the user to use as a reference
3. Select the **MemberOf** tab
4. Keep window open somewhere on the screen where it is visible

5. Double-click on the user to add to groups
6. Select the **MemberOf** tab, click **Add...**
7. Enter the names of the groups from the reference user, seperated by a semicolon (`;`)
8. Verify the group names with **Check Names**
9. Click **OK** and **OK** again
<br></br>

## Breakdown Overview:
While the manual process isn't too cumbersome in our example, we can use PowerShell to automate this process.
[show time comparison of manual process (51 seconds vs script (2 seconds)]

In [Part 1](./Part1.md), I'll show the core script and cover the `Get-ADUser` and `Add-ADGroupMember` commands,
    as well as how to store objects as a variable, and how you can use output of one command as input of another using the pipeline.

In [Part 2](./Part2.md), we'll add the `Out-GridView` command to the script to give you an interactive window so you can select specific groups.

Finally, in [Part 3](./Part3.md), we'll put everything together into an advanced function and add it to a PowerShell module for long-term reuse.
