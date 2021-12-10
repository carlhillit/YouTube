## Introduction:
This is PowerShell Breakdown One-Liners where the entire script is written in just one line.

[This one](https://www.youtube.com/watch?v=R40Xt96zMIg) finds all of the Active Directory accounts that are locked out within an Organizational Unit and then unlocks them all.

This really comes in handy when _something_ causes large numbers of users to have their accounts become locked.

*WARNING: Account lockouts can also be an indicator of malicious activity. Assess the risks involved with unlocking all accounts before doing so.*

When the IT team becomes overwhelmed with support calls, you can run this one-liner to stave off the angry mob long enough so you can fix whatever that _something_ is.
<br></br>

## [Unlock-ADAccount](https://docs.microsoft.com/en-us/powershell/module/addsadministration/unlock-adaccount?view=win10-ps)

The command that unlocks accounts is called `Unlock-ADAccount` and it is fairly simple to use and understand.

We only need to be concerned with the `-Identity` parameter, which identifies the account to unlock.

I typically use the SAM account name to identify a user.

It can be found in ADUC by double-clicking on the user, selecting the **Account** tab, and looking under **User Logon Name (Pre-Windows 2000)**.

I'll go ahead and copy the SAM account name to the clipboard.

You can also use any of _these_, which are found in the **Attribute Editor** tab.

* distinguished name
* GUID (objectGUID)
* security identifier (objectSid)

We know that Michelle's account is locked out by this message here.

Now we can paste the SAM account name into PowerShell by right-clicking.

Hit ENTER and verify the account is unlocked in ADUC.

The message that was there before is now gone, so the account is now unlocked.
<br></br>

## [Search-ADAccount](https://docs.microsoft.com/en-us/powershell/module/addsadministration/search-adaccount?view=win10-ps)

That's how you unlock an account. Now I'll show you how to search for all of the accounts that are currently locked out.

The command we're using this time is `Search-ADAccount`.

This searches Active Directory for various things like expired or inactive accounts, expired passwords,
and what we're using it for: _locked out accounts_.

We'll use two parameters with this command:

The first is `-LockedOut`. This will return the accounts that are currently locked out.

The second is `-SearchBase`. This tells PowerShell _where_ to search. Without it, PowerShell will search the entire domain.

Since we want to search only in a specific Organizational Unit, we need to input the OU here in Distinguished Name format.

To find the Distinguished Name of an Organizational Unit in ADUC, right-click on the OU, select **Properties**, and it will be listed in the **Attribute Editor** tab.

You can simply copy the Distinguished Name from the Attribute Editor and right-click to paste into PowerShell.

Add quotes around the Distinguished Name and we're good to go.
<br></br>

## Combination

We can combine `Search-ADAccount` and `Unlock-ADAccount` together with the [pipe](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/04-pipelines?view=powershell-5.1#the-pipeline) ( | ) to unlock all accounts that are currently locked out.

Since the command on the left outputs the identities of accounts, we don't need to use the `-Identity` parameter for the command on the right of the pipe.

Verify that the account are unlocked by spot-checking in ADUC or re-run the `Search-ADAccount` command.

No results are returned, so that tells us that no accounts are currently locked out.
<br></br>


## Conclusion:
That's it! That's all there is to it.

