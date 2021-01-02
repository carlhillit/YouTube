
## Part 3 Intro
Hey guys and gals, welcome to **Part 3** of the breakdown of my [Copy-ADGroupMembership](./Copy-ADGroupMembership.ps1) script which finds all the Active Directory groups that one user is a member of and makes _another_ user a member of those same groups.

In this final part, we'll take our script that we've written in Parts 1 & 2 and add it to an advanced function which will turn it into a reusable tool just like native PowerShell cmdlets.
<br></br>

### [Advanced Functions](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced?view=powershell-5.1)

It has:

* Positional Parameters
  
  A positional parameter assumes the name of the parameter by position that you input values.

* Receive input from pipeline
  
  With this feature, you can then integrate it into other scripts and/or use it in conjunction with other commands:

    Get-ADUser -Filter {SurName -eq 'Adams'} | Copy-ADGroupMembership -TargetUser paul.allen

* Switch Parameters
  
  Switch parameters are more of a toggle (on/off) "switch" in which no extra input is needed.
  
  The `-UsePicker` parameter allows us the _option_ of using the Out-GridView windows to select groups and
  
  The `-PassThru` parameter gives us the _option_ of outputting the groups that our target user was added to the console.
  
  This could be useful if you wanted to log/document the action or pass those groups through the pipeline to another command.
<br></br>

### Compare PROCESS block with Part 2 Script

The heart of an advanced function is found inside the `process` block.

You can also think of it as the engine and it's where most of the logic will be placed.

If we compare the `process` block with our script from Part 2, we can see many similarities.

Variable names have slightly changed, and two 'if' statements are added to take action if the switch parameter is used.

Otherwise, they're the same, because they perform the same core function.

Since the core part of the script is the same, we're really just changing _how it's used_.
<br></br>

## Creating an Advanced Function in VS Code

To create an advanced function, start by typing "function" and click on "advanced function".

We see that it's given us a good template to work with.

Now's a good time to give the function a name ensuring that it follows the _Verb-Noun_ format for consistancy with other PowerShell functions and commands.
<br></br>

### [CmdletBinding](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-5.1)

We can see that the CmdletBinding is already there for us. This is what makes a function an **advanced function** and unlocks these features that I previously described.

## Param Block

### [Advanced Parameters](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-5.1)

We'll begin by adding our first parameter.

In the `param` block, simply start typing "parameter" and choose the "parameter declaration snippet".

In the previous video's script, the first variable that was created was the `$ReferenceUser` variable, so let's use that as our first parameter.

[By default](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-5.1#positionalbinding), the order in which we place parameters will determine the parameter position, so it also makes sense to start with `$ReferenceUser`.

We'll give it a brief description like "User who's group membership to use as a reference".

Just something so you get an idea of what the parameter is used for.

### Parameter Attributes

Next, we want to give the parameter some attributes:

Because the function will not work without the reference user, we will make this parameter "Mandatory".

If you were to attempt to use the command without the mandatory parameter, PowerShell will ask you to input something before proceeding.

     [Parameter( Mandatory )]

~~Mandatory does not need to include "=$true"~~

Because this is mandatory, we should also add a Help Message to let the person using the command know what kind of information is mandated.

We also need to seperate the attributes by a comma ( , ) to let PowerShell know that we're starting a new attribute and it's not just a continuation of something before it.

    [Parameter( Mandatory,HelpMessage='Reference user to gather group membership from' )]

The last attribute we'll add is `ValueFromPipeline` to enable this parameter to receive input from the pipeline.

    [Parameter( Mandatory,HelpMessage='Reference user to gather group membership from',ValueFromPipeline )]

Since there are more than one attribute, we'll place each one on a new line to make it easier to read.

    [Parameter( Mandatory,
                HelpMessage='Reference user to gather group membership from',
                ValueFromPipeline )]


### Parameter Type

The parameter type determines how PowerShell treats the input object.

For example: "2" can be either a number (integer) or text (string).
So if we type: integer of two, times integer of two, we get four.

    [int]2 * [int]2
    4

But if we type: string two times string two, we'll get twenty-two, because it combines strings together.
    
    [string]2 * [string]2
    22

Since we're mimicking some functionality of the `Get-ADUser` cmdlet, as well as to ensure interoperability with it, I'm going to use the type from the documentation.
In this case, it's `ADUser`.

        [Microsoft.ActiveDirectory.Management.ADUser]
        $ReferenceUser

Before we add a new parameter, we need to add a comma ( , ) after the `$ReferenceUser` variable to indicate that there will be a follow-on parameter.

We'll add a 2nd parameter similar to the 1st, and make a couple  adjustments for the `$TargetUser` parameter.
Since this is not going to receive input from the pipeline, we'll leave that out.

    # User(s) to add to groups of which ReferenceUser is a member of
    [Parameter( Mandatory,
                HelpMessage='User to add to groups from reference user')]
    [Microsoft.ActiveDirectory.Management.ADPrincipal[]]
    $TargetUser,

Just like with the `Add-ADGroupMember` command from our previous video, we want to be able to add one or more users to a group, so we'll add an opening and closing bracket ( [] ) after "ADPrincipal".

#### [Switch Parameter](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-5.1#switch-parameters)

As I've mentioned earlier, a switch parameter is like a toggle (on/off) switch in which no extra input is needed.

These will not be mandatory and will have no attributes.

### Begin, Process, and End blocks [(Advanced Methods)](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-5.1)

To simplify the Begin, Process, and End blocks (aka Advanced Methods)

* the `Begin` block is for one-time preprocessing
* the `Process` block is for multiple record processing, and this block is required at a minimum for processing input from the pipeline
* the `End` block for one-time post-processing.

Because we're not doing any pre or post processing, and the `ReferenceUser` parameter is receiving input from the pipeline, only the `process` block will be used.

### Placing the Script Logic

Since we've already written most of the script logic, let's use the previous script as a guide for what to place in the `process` block.

We'll add the `if` statements where we would want to use the switch parameters.

### [Comment Based Help](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-5.1)

Now that we've finished the logic portion, let's add some comment-based help.

Comment-based help is a way to add helpful information to your advanced function that can be retrieved with the `Get-Help` command.

It's called "comment-based" because you use it in a block comment.

The position of the comment-based help should be placed after the `function` and before the `Param` block.[1]

Comment-based help is triggered when you use certain [keywords](https://docs.microsoft.com/en-us/powershell/scripting/developer/help/comment-based-help-keywords?view=powershell-5.1).

While all keywords will probably go unused, I would recommend that at a minimum, that a **description** or **synopsys** and **examples** of the function be added to the comment block.

[1]:https://poshcode.gitbooks.io/powershell-practice-and-style/content/Style-Guide/Documentation-and-Comments.html
<br></br>

### Create Module

Now that we've finished writing the funciton, save it with a .psm1 file extension in the PowerShell modules folder.

Import the newly created module, and then we can use the `Copy-ADGroupMembership` command in PowerShell.


### Conclusion
(Music: "Energy" from Bensound.com)

This is the end of the three-part video series where I took you on a PowerShell coding journey starting with a basic script, adding some cool features to it, and concluded with an advanced function.

All of the scripts shown in the videos, as well as the writeup will be on my GitHub, linked in the description.

If you found the video useful, push that "like" button.

I'll be uploading more videos regularly so make sure that you're subscribed.


Thank you for watching, and I hope you learned something.