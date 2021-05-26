$dice = @('⚀','⚁','⚂','⚃','⚄','⚅')

$diceValues = 1..6 


$rolls = foreach ($value in $diceValues){

    [pscustomobject]@{
        'Roll' = $dice[$value - 1]
        'Value' = $value
    }

}



function RollDice {
    param ( [int]$NumberOfDice )

        $playerRoll = Get-Random -InputObject $rolls -Count $NumberOfDice

        $rollTotalValue = ($playerRoll.Value | Measure-Object -Sum).Sum
        
        $playerRoll.Roll
        Write-Host "You rolled a $rollTotalValue"

}

