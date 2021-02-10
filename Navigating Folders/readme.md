# Navigating Folders (Directories) with PowerShell

In this short video, I'm going to show you some ways to navigate folders, aka directories, with PowerShell.

## Navigating Folders

I'll start with navigating folders, also known as directories.

I have a two-window setup to better show what's going on with both PowerShell and File Explorer.
By default, an elevated PowerShell starts in the C:\Windows\System32 folder.

### [Get-Location](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-location?view=powershell-5.1)

The `Get-Location` (alias `pwd`) command outputs the folder path that I'm in to the console.

For those that are more familiar with the linux command or command prompt commands, the alias `pwd` can be substituted for Get-Location.

### [Set-Location](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-location?view=powershell-5.1)

To move to another folder, use the `Set-Location` command. Type the command followed by the path to set the location to.

The alias `cd` can be used as a substitute.

If I wanted to change to another folder, I can navigate to the folder in File Explorer and copy the path from the address bar and paste into PowerShell.

Another technique using File Explorer is to hold Shift and right-click on the folder and select "Copy as path" to copy the folder path to the clipboard.

This is particularly useful as it includes double quotes which is needed for paths with spaces.

## Relative Paths

You can also use relative folder paths. Using `..` with `cd` will change the current working directory to the parent directory.

A `.\` is used to mean the working directory, so I can type .\Lab to mean the Lab folder in C:\PowerShellBreakdown.

## [Location Stack](https://devblogs.microsoft.com/scripting/location-location-location-in-powershell/)

In File Explorer, when you navigate folders, you can use the Back button to go a previous folder.

In PowerShell, something called the "Location Stack" is a way to have something similar to navigating through the browsing history.

### [Push-Location](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/push-location?view=powershell-5.1)

Each time you "push" to go to a new directory the current directory is added to the stack to which creates something like a history of working directories which you can go back through, or "pop" to later.

From the current location of C:\PowerShellBreakdown, I will use the command `Push-Location` to adds the current location to the top of a location stack and changes the location to what's specified.

When using `Get-Location`, I can add the `-Stack` parameter to view the location stack.

Each time I push to another location with `Push-Location` or the alias `pushd`, I can see that the current location has been added to the top of the stack.

### [Pop-Location](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/pop-location?view=powershell-5.1)

To change locations to the one at the top of the stack, I'll use the Push-Location command or the alias `popd`.

I can continue to do this, each time returning to the previous location and removing the current one from the stack until the location stack is empty.

### [Named Location Stacks](https://devblogs.microsoft.com/scripting/using-named-location-stacks-in-powershell/)

If you're workflow is a bit more advanced, you can create multiple location stacks by specifying a stack name by adding the -StackName parameter when using the Push, Pop, and Get-Location commands.

    Push-Location C:\StorageReports -StackName reports

    Get-Location -StackName reports

    Pop-Location -StackName reports


