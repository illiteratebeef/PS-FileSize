#################################################################################################################################################################################################
###Function that sorts and shows files and their sizes in a selected directory
#
#Created by: illiteratebeef
#Version: 9.0
#Created: 8/24/2016
#Updated: 9/01/2016
#
#Update History:
#8/24/2016 - v1.0 - initial build
#8/24/2016 - v2.0 - Added ElseIf for mb/gb apended to size
#8/24/2016 - v3.0 - Expanded appended Size values to include KB
#8/24/2016 - v4.0 - added table formatting
#8/24/2016 - v5.0 - removed unneeded variables and added comments
#8/24/2016 - v5.1 - additional formatting
#8/25/2016 - v5.2 - more formatting and documentation
#8/25/2016 - v6.0 - Formatted datetime for readability, modified variables for readability, messed with default values
#8/25/2016 - v6.1 - removed '@' in time field
#8/25/2016 - v7.0 - Added terabyte, byte, and directory values for FileSize
#8/25/2016 - v7.1 - Updated greaterthan/lessthan values for better readability
#9/01/2016 - v8.0 - Added colors based on folder or file, includes Format-Color function
#9/01/2016 - v9.0 - Added file name string limits, cutting off super long file names that cause the script to not show columns
#
#Instructions:
#This function has default values for the 3 variables, dir (the directory you want to search), min (the minimum file size you want to be shown), and max (the maximum file size you want shown).
#Folders won't be shown unless you select '0' for the min.
#It defaults to dir="C:\", min=5 kilobytes, and max=100 gigabytes.
#By setting these when you call this function, you can override any or all of the defaults. They are also positional so if they're in the right order, you don't need to call the variable names.
#The min and max variables can use bytes, KB, MB, etc so you don't have to convert everything to bytes.
#
#Example: PS> FileSize -dir C:\Users\Owner\Downloads -min 100MB -max 5GB
#Example: PS> FileSize C:\Users\Owner\Downloads 100MB 5GB
#Example: PS> FileSize -min 0
#
#
function FileSize
([string] $dir="C:",
[int] $min=5MB,
[long] $max=100GB)
{
dir $dir |
where {$_.Length -gt $min -and $_.Length -lt $max}  | 
sort -property Length -descending | 
Format-Table @{Name="Name";Expression={
If ($_.Name.Length -gt 40 ) {$_.Name.Trim().Substring(0,40)}
Else {$_.Name}
}}, 
	@{Name="FileSize";Expression={ 
		If ($_.Length -gt 1000GB) { "{0:N2}" -f ($_.Length / 1Tb) + " TB"} 
		elseif ($_.Length -lt 1000GB -and $_.Length -gt 1GB){ "{0:N2}" -f ($_.Length / 1Gb) + " GB"} 
		elseif ($_.Length -lt 1GB -and $_.Length -gt 1MB){ "{0:N2}" -f ($_.Length / 1Mb) + " MB"} 
		elseif ($_.Length -lt 1MB -and $_.Length -gt 1KB){ "{0:N2}" -f ($_.Length / 1kb) + " KB"} 
		elseif ($_.Length -lt 1KB -and $_.Length -gt 1){ "{0:N2}" -f ($_.Length) + " Bt"} 
		else{ "Directory"}}
		align='right'}, 
	@{Name="LastWrite";Expression={"{0:MM-dd-yyyy hh:mm:ss}" -f $_.LastWriteTime}; align='center'},
	@{Name="Attributes";Expression={$_.Attributes}; align='left'} | 
	Format-Color @{'Directory' = 'Green'; 'FileSize' = 'White'; 'Hidden' = 'Cyan'; 'System' = 'Cyan'; 'ReadOnly' = 'Cyan'; 'Archive' = 'Cyan'; 'Normal' = 'Cyan'; 'Volume' = 'Cyan'}
	}
	
	function Format-Color([hashtable] $Colors = @{}, [switch] $SimpleMatch) {
	$lines = ($input | Out-String) -replace "`r", "" -split "`n"
	foreach($line in $lines) {
		$color = ''
		foreach($pattern in $Colors.Keys){
			if(!$SimpleMatch -and $line -match $pattern) { $color = $Colors[$pattern] }
			elseif ($SimpleMatch -and $line -like $pattern) { $color = $Colors[$pattern] }
		}
		if($color) {
			Write-Host -ForegroundColor $color $line
		} else {
			Write-Host $line
		}
	}
}
