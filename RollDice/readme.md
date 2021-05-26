# Dice Roll Simulator w/ PowerShell Custom Objects


In this video, I'm going to show you how to make a dice roll simulator in PowerShell that displays dice ASCII characters and the total dice roll value.

It works by randomly selecting a die and its value from two arrays that are combined together into a [PowerShell Custom Object](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7.1).


## Script Overview
The PSCustomObject is created from two arrays: one of dice ASCII characters and another one of numbers one through six.

````powershell
$dice = @('⚀','⚁','⚂','⚃','⚄','⚅')

$diceValues = 1..6 
````

They are then combined into a PSCustomObject by using a foreach loop

````powershell
$rolls = foreach ($value in $diceValues){

    [PSCustomObject]@{
        'Roll' = $dice[$value - 1]
        'Value' = $value
    }

}
````

The one or more "dice" are then randomly selected from the PSCustomObject, and their values are added together, which is then output to the console.

````powershell
$playerRoll = Get-Random -InputObject $rolls -Count $NumberOfDice

$playerRoll.Roll
$rollTotalValue = ($playerRoll.Value | Measure-Object -Sum).Sum

Write-Host "You rolled a $rollTotalValue"
````

The dice value sum and ASCII output is then wrapped in a function which allows us to "roll" the dice again without recreating the PSCustomObject.

````powershell
function RollDice {
    param ( [int]$NumberOfDice )

        $playerRoll = Get-Random -InputObject $rolls -Count $NumberOfDice

        $rollTotalValue = ($playerRoll.Value | Measure-Object -Sum).Sum
        
        $playerRoll.Roll
        Write-Host "You rolled a $rollTotalValue"

}
````

## A Tale of Two Arrays
The first two lines of the script are arrays (something akin to a list) of the dice ASCII representations and the numerical value of the die. While both are arrays, they're both created differently.

Arrays are created by using `@()` with each item between parenthesis separated by either a comma, or a new line; whichever is preferable to you.

### Text Array
Text should be wrapped in single or double quotes:
````powershell
$dice = @('⚀','⚁','⚂','⚃','⚄','⚅')
````
or
````powershell
$dice = @(
	'⚀'
	'⚁'
	'⚂'
	'⚃'
	'⚄'
	'⚅'
)
````
### Numbers in Array
Since the numbers that I'm using are in sequence, I can use `1..6` to quickly create an array

This:
````powershell
$diceValues = 1..6
````
Is the same as this:
````powershell
$diceValues = @(1,2,3,4,5,6)
````
Both produce the output:
````powershell
1
2
3
4
5
6
````

### Selecting Items from Array

Items in an array are numbered starting at the top with zero.

````
item1 [0]
item2 [1]
item3 [2]
item4 [3]
item5 [4]
item6 [5]
````
To select one or more items from the array, I can assign a variable to the array and type the item's position number in brackets at the end of the variable.

## PSCustomObject
Now that I have arrays for both the ASCII representations and the numerical values, I need a way to combine them into a structured data set like this one so I can associate a numerical value to an ASCII character.

Roll | Value
--- | ---
⚀ | 1
⚁ | 2
⚂ | 3
⚃ | 4
⚄ | 5
⚅ | 6

### Introduction to PSCustomObject
A PSCustomObject is a way to create structured data within PowerShell using properties and values.

In simple terms it's like a table of information -- much like you'd see in a CSV file, or as output from a PowerShell command.

When using structured data in PowerShell, it's much better to output data as an object because this allows for more flexibility by giving you the ability to:

* Export the data to a file, such as a CSV
* Format the object in a table or list
* Select properties of the object
* Pass it along the pipeline as input for another PowerShell command

### Creating a PSCustomObject
When using VS Code, you can create a PSCustomObject by typing `[PSCustomObject]` and selecting the snippet.

````powershell
[PSCustomObject]@{
    'Roll' = 'One'
    'Value' = 1
}

Roll Value
---- -----
One      1

````

If I wanted to create an object with two or more dice rolls and its corresponding numerical values, I'd first have to create an empty array list, then add the custom objects to the array list by using the `+=` operator.

````powershell
# create empty array
$rolls = @()

# create PSCustomObjects for die 1, 2, and 3
$one = [PSCustomObject]@{
    'Roll' = 'One'
    'Value' = 1
}

$two = [PSCustomObject]@{
    'Roll' = 'Two'
    'Value' = 2
}

$three = [PSCustomObject]@{
    'Roll' = 'Three'
    'Value' = 3
}

# add objects to array
$rolls += $one
$rolls += $two
$rolls += $three


Roll  Value
----  -----
One       1
Two       2
Three     3
````

## Using the [ForEach Loop](https://devblogs.microsoft.com/scripting/basics-of-powershell-looping-foreach/)

Instead of creating an empty array and adding each object individually, I'll create the objects using a `foreach` loop.
The `$dice` array position variable will be one less than the numerical value because the array positions start with 0 instead of 1.

````powershell
foreach ($value in $diceValues){
    [PSCustomObject]@{
        'Roll' = $dice[$value - 1]
        'Value' = $value
    }
}


Roll Value
---- -----
⚀        1
⚁        2
⚂        3
⚃        4
⚄        5
⚅        6
````

The output will be a fixed-size array -- the same as when I created an empty array and added the objects individually. I'll demonstrate by viewing the object type.
````powershell
PS C:\> $rolls.GetType()

IsPublic IsSerial Name                                     BaseType
-------- -------- ----                                     --------
True     True     Object[]                                 System.Array
````

## Roll the Dice
Now the hard part is out of the way, let's "roll the dice".
This will randomly select one of the die from the pscustomobject using `Get-Random`.
If you'd like to roll more than one die, use the `-Count` parameter.

````powershell
$playerRoll = Get-Random -InputObject $rolls -Count 2
$playerRoll

Roll Value
---- -----
⚅        6
⚁        2
````

Now I'll display the ASCII characters from the "roll" by showing the Roll property of the random selection.

I'll calculate the sum of the roll values by piping the value property of the selection into `Measure-Object -Sum` before isolating the Sum property of the result.

````powershell
$playerRoll.Roll
$rollTotalValue = ($playerRoll.Value | Measure-Object -Sum).Sum
Write-Host "You rolled $rollTotalValue"

⚂
⚁
You rolled 5
````

### Function
If I want to reuse the dice roll portion, I'll wrap the random selection part into a function with a NumberOfDice parameter:
````powershell
function RollDice {
param (
        [int]$NumberOfDice
    )

	$playerRoll = Get-Random -InputObject $rolls -Count $NumberOfDice

	$playerRoll.Roll
	$rollTotalValue = ($playerRoll.Value | Measure-Object -Sum).Sum

	Write-Host "You rolled $rollTotalValue"

}

RollDice -NumberOfDice 3
⚅
⚀
⚃
You rolled 11
````

## Considerations

For scripts which will use many object properties, consider a different technique to building a non-fixed-size object array.
The `+=` technique to adding PSCustomObjects to an array is usually simpler and quicker, but comes with a performance impact.
What `+=` actually does is build an entirely new fixed-size array with the additional object, then discards the original.
This impact is negligible for a small number of objects, but will slow down the script when looping through several hundred or thousand times.

If performance matters, consider using this:

````powershell
$rolls = [System.Collections.ArrayList]::new()

$one = [PSCustomObject]@{
    'Roll' = 'One'
    'Value' = 1
}

$two = [PSCustomObject]@{
    'Roll' = 'Two'
    'Value' = 2
}

$rolls.Add($one)
$rolls.Add($two)

$rolls
````
Output:
````powershell
Roll Value
---- -----
One      1
Two      2

````

## Conclusion

The dice roll simulator I made is an example of how to use arrays and PSCustomObjects to create structured data in PowerShell which can then be used in a variety of ways.

Thank you for watching, I hope you learned something.