
Anyone whose been working in IT for a little while will have had to troubleshoot a network connection on a server or client computer at some point.

Most of the time, cmd prompt commands such as `ping`, `nslookup`, and `ipconfig` are used for network troubleshooting and diagnosis.

`ping` will tell me if the IP 192.168.1.1 is reachable from my computer.

`nslookup` will tell me that the IP resolves to pfSense.karl.lab as well as the DNS server IP address.

And `ipconfig` shows the IP configuration of my computer.


While those work well and perform the desired function, this is a channel about PowerShell so I'd like to show you some ways to do network troubleshooting with PowerShell and discuss the advantages and disadvantages of using PowerShell commands over the traditional cmd prompt commands.
<br></br>


## PowerShell vs. Command Prompt commands

Several cmd commands have a PowerShell equivalent:

* ping > Test-Connection

      Test-Connection -ComputerName 192.168.1.1

* ping -t > Test-Connection -Continuous

      Test-Connection -ComputerName 192.168.1.1 -Continuous

* nslookup > Resolve-DnsName

      Resolve-DnsName 192.168.1.1

* ipconfig > Get-NetIPConfiguration

      Get-NetIPConfiguration

* tracert > Test-NetConnection -TraceRoute

      Test-NetConnection -ComputerName 192.168.1.1 -TraceRoute

* telnet > Test-NetConnection -Port

      Test-NetConnection -ComputerName 192.168.1.1 -Port 443



## Advantages Using PowerShell Over CMD

A lot IT workers know the old cmd prompt commands by heart and will want to stick with what they know and what works. That's perfectly fine.
These are, after all, tools to help you, and their use is ultimately a personal preference.
But I would encourage everyone to at least be aware of what is available and then decide which ones work best for them.

* Some PowerShell commands, like `Test-NetConnection` are simply more useful
* Used in PowerShell scripts
  * (e.g. if a computer answers a ping, do an action)
  * This can greatly improve speed by using a conditional statement when running through a foreach loop that does an action against a remote computer instead of waiting for a timeout
* Older commands, like telnet, are not allowed due to security policies for some organizations

### Test-NetConnection - The Swiss Army Knife of PS Networking Cmdlets


* Ping

      Test-NetConnection -ComputerName 192.168.1.1

* Trace Route

      Test-NetConnection -ComputerName 192.168.1.1 -TraceRoute

* Test Port Opening

      Test-NetConnection -ComputerName 192.168.1.1 -Port 443

* DNS Resolution

      Test-NetConnection -ComputerName 192.168.1.1 -InformationLevel Detailed


### Script Integration

The biggest benefit comes in it's ability to be used in scripts.

This following example script outputs all online computers, but you can easily output the IPs to a file or insert any other PowerShell command in the `if` block.

```powershell
$Computers = @(
    "192.168.1.90"
    "192.168.1.91"
    "192.168.1.92"
    "192.168.1.93"
)

foreach ($comp in $Computers) {

    if (Test-Connection -ComputerName $comp -Count 1 -Quiet) {
        $comp
    }


}

```

In this list, or array, of IP addresses, the first three are pingable, but the last one (the one that ends in .93) is offline.

Since I just want to know which ones are pingable, I'll use a foreach loop to test the connection of each one.
If the IP is pingable, it'll output the IP address

I will use only one ping with `-Count` because I can safely assume that if the first is successful,
the remaining ones will be as well and the script will loop through the IPs faster.

I'll use the `-Quiet` parameter to output a boolean value (true/false) so I can use it in a conditional statement.


Computers that respond successfully to a ping return "True" and those that do not return "False".


## Disadvantages Using PowerShell Over CMD

While I do use some of these aforementioned PowerShell commands frequently, they do have some disadvantages:

* PowerShell commands not universally known.
  In emergency/outage situations which require quick collaboration, sometimes it's better for everyone to use what they know.
* cmd prompt commands still work
  no need to relearn the commands if the added advantages from PowerShell are not needed in your situation
* some PowerShell commands do not have direct equivalent
 ( i.e. `ipconfig /release` ), That's okay, because the cmd prompt commands can be used just fine within PowerShell.


# Conclusion

PowerShell is, at the end of the day, simply a tool and tools are used to help you achieve a goal.

If you can familiarize yourself with some of these network troubleshooting tools, then you might just find them useful for you situation.

Thank you for watching. I hope you learned something.

<br></br>

## Cheatsheet

### Local Configuration

| cmd | PowerShell |
| --- | --- |
| ipconfig | Get-NetIPConfiguration |
| ipconfig /all | Get-NetIPConfiguration -Detailed |
| ipconfig /release | *no direct PS cmdlet* |
| ipconfig /renew | *no direct PS cmdlet* |
| netstat | Get-NetTCPConnection |

### Remote Connectivity

| cmd | PowerShell |
| --- | --- |
| ping 8.8.8.8 | Test-NetConnection 8.8.8.8 |
| ping -t | while ($true) { Test-Connection 8.8.8.8 } |
| tracert 8.8.8.8 | Test-NetConnection 8.8.8.8 -TraceRoute |
| telnet 8.8.8.8 25 | Test-NetConnection -Port 25 |

### DNS

| cmd | PowerShell |
| --- | --- |
| nslookup | Resolve-DnsName |
| ipconfig /flushdns | Clear-DnsClientCache |
| ipconfig /registerdns | Register-DnsClient |
| ipconfig /displaydns | Get-DnsClientCache |
