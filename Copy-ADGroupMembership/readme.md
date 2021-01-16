# Copy Group Membership (Mirror Permissions) for Active Directory Users with PowerShell

## Introduction:
This [video series](https://www.youtube.com/playlist?list=PLnkgJzscsB-Dfm5DD-qQeuyEvvv4HNDa5) breaks down my script that finds all of the Active Directory groups that one user is a member of and makes another user a member of those same groups.
This procedure is also commonly known as "permissions mirroring" and is used to grant one user the same access rights and permissions of another user.

*Blindly copying groups may not be desireable. See [Part 2](./2-OutGridView/readme.md) for a way to filter out groups.* 

## Manual Procedure That The Script Automates

1. Open Active Directory Users and Computers
2. Double-click on the user to use as a reference
3. Select the **MemberOf** tab
4. Keep window open somewhere on the screen where it is visible

5. Double-click on the user to add to groups
6. Select the **MemberOf** tab, click **Add...**
7. Enter the names of the groups from the reference user, separated by a semicolon ( `;` )
8. Verify the group names with **Check Names**
9. Click **OK** and **OK** again
<br></br>

## Series Overview:
While the manual process isn't too cumbersome in our example, we can use PowerShell to automate this process.
(*51 seconds manually vs. 2 seconds with script to add a user to four AD groups*)

[Part 1](./1-Core/readme.md) is the core script and covers the `Get-ADUser` and `Add-ADGroupMember` commands, as well as how to store objects as a variable, and how you can use output of one command as input of another using the pipeline.

[Part 2](./2-OutGridView/readme.md) adds the `Out-GridView` command to the script to give you an interactive window so you can select specific groups.

[Part 3](./3-AdvancedFunction/readme.md) puts everything together into an advanced function for long-term reuse.
