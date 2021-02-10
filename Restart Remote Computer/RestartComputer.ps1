# To restart my local computer:
Restart-Computer

# To restart another domain-joined computer named WIN102 remotely:
Restart-Computer -ComputerName WIN102

# To suspend BitLocker on the C: drive of WIN102 for one reboot:
Invoke-Command -ComputerName WIN102 -ScriptBlock {
    Suspend-BitLocker -Mountpoint C: -RebootCount 1
}


## Suspend bitlocker and reboot WIN102:
$ComputerName = 'WIN102'

Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    Suspend-BitLocker -Mountpoint C: -RebootCount 1
}

Restart-Computer -ComputerName $ComputerName


