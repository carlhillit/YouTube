
## Introduction
In this video, I'll demonstrate an easy way to export a VMware virtual machine to an OVA template file using PowerCLI.


## OVF vs OVA
First, a little background on OVF and OVA templates:

### OVF
When exporting VM templates from the vCenter web GUI, a "Folder of files (OVF)" is the default chosen option.
The .ovf file is like an index configuration file in XML format that tells vCenter all of the specifications and component files of the VM template.

### OVA
OVAs are more like zip files for VM templates in that it is a single file that contains other files.
This makes it a bit easier to transfer and store the VM template outside of vCenter.

[From vSphere 6.5 and newer](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-AFEDC48B-C96F-4088-9C1F-4F0A30E965DE.html), VM templates can only be exported in OVF format from the vCenter web GUI, which is why I'm using PowerCLI for this demonstration.

## Prerequisites

### Install the PowerCLI Module
Before I can begin working with vCenter, I'll first need to install PowerCLI.

From my computer, I'll open PowerShell as an Administrator and install the VMware PowerCLI module from the PS Gallery by typing:

    Install-Module VMware.PowerCLI -Force

### Initial Configuration of PowerCLI

Because this is my first time using a PowerShell module on this computer, I need to allow the execution of the module I've just installed.
For lab purposes, I'll set the policy to "Unrestricted".

    Set-ExecutionPolicy Unrestricted

I'll then opt out of the Customer Experience Improvement Program for all users:

    Set-PowerCLIConfiguration -ParticipateInCeip $false -Scope AllUsers

And since my vCenter lab has a non-trusted SSL certificate, I'll also need to set PowerCLI to ignore invalid certificates:

    Set-PowerCLIConfiguration -InvalidCertificateAction Ignore

### Connect to vCenter
Now all the prerequisites are filled, I can connect to vCenter.

I find it useful to store the credentials in a variable in case I need to later reconnect or connect to a different vCenter.

Store the vCenter credentials in a variable using the `Get-Credential` command.

    $vscreds = Get-Credential

Then connect to the vCenter server using the credentials variable.

    Connect-VIServer -Server vcsa.breakdown.lab -Credential $vscreds

*If you'd like, you can add the `-SaveCredentials` parameter to save the credentials to the credentials store when using Windows PowerShell*

### Get-VM

The command that I'll be using to export the VM to an OVA template is `Export-vApp`.
Before I use the command, I'll take a look at the [documentation](https://powercli-core.readthedocs.io/en/latest/cmd_export.html) for a quick reference on how to use it.

I can see that either the `VApp` or `VM` parameter is required. For this demo, I'm using `VM`.


Since the VM parameter type requires a VM object type, we need to use `Get-VM` before I can export.

The two VMs that I want to export to a template are named "WS19C", which is Windows Server 2019 Core and "WS19D", with Desktop Experience.

    Get-VM -Name WS19C

*if the VM is powered on, be sure to power it off at this time*

To export a single VM, I can simply assign a single VM to a variable, then use the variable with the Export-VApp command

    $VM = Get-VM -Name WS19C

Verify the `$VM` variable is the correct type

    $VM.GetType()

## Exporting the Template

Now everything is in place, I can now export the VM to the OVA template:

    Export-VApp -VM $VM -Description "Windows Server 2019 Core" -Format Ova -Destination C:\templates

Since the VM parameter allows objects to be passed to it from the pipeline, I could combine these two commands into a one-liner:

    Get-VM -Name WS19C | Export-VApp -Format Ova -Destination C:\templates

*PowerCLI will assume the name of the VM as the ova file name*

Either the command documentation, or a quick Ctrl+Space keyboard shortcut, will show me that the VM parameter can take an array of objects as input, as indicated by the double brackets ( `[]` ).
This means that I can export multiple VMs to templates with a single command.

    Get-VM WS19* | Export-VApp -Format Ova -Destination C:\templates


## Conclusion

That concludes the video on how to use PowerCLI to export VMware virtual machines to Ova templates.
Thank you for watching, I hope you learned something.



