# PS-FileSize
Shows files and folders in current directory with time and size data.


This function has default values for the 3 variables, dir (the directory you want to search), min (the minimum file size you want to be shown), and max (the maximum file size you want shown).

Folders won't be shown unless you select '0' for the min.

It defaults to dir="C:\", min=5 kilobytes, and max=100 gigabytes.

By setting these when you call this function, you can override any or all of the defaults. They are also positional so if they're in the right order, you don't need to call the variable names.

The min and max variables can use bytes, KB, MB, etc so you don't have to convert everything to bytes.


Example: PS> FileSize -dir C:\Users\Owner\Downloads -min 100MB -max 5GB
Example: PS> FileSize C:\Users\Owner\Downloads 100MB 5GB
Example: PS> FileSize -min 0
