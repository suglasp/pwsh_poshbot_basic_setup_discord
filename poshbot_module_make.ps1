
#
# Create a new Poshbot plugin (Powershell Module).
# Pieter De Ridder aka Suglasp
#
# Notice : This script creates a "simple" Poshbot plugin.
#
# Create date : 17/09/2020
# Change date : 18/09/2020
#
# Reading:
# Simple Plugin   : https://poshbot.readthedocs.io/en/latest/guides/plugin-configuration/
# Advanced Plugin : https://poshbot.readthedocs.io/en/latest/tutorials/plugin-development/advanced/poshbot.botcommand-attribute/
#   For advanced Plugins, set in the .psm1 file : RequiredModules = 'PoshBot'
#

# global vars
$global:WorkingDir = $($PSScriptRoot)
$global:PoshPluginsPath = "$($global:WorkingDir)\plugins"

# create plugins folder
If (-Not (Test-Path $global:PoshPluginsPath)) {
    New-Item $global:PoshPluginsPath -ItemType Directory
}

# create module manifest file
If (-Not (Test-Path "$($global:PoshPluginsPath)\MyPoshBotPlugin")) {
    New-Item "$($global:PoshPluginsPath)\MyPoshBotPlugin" -ItemType Directory
    
    [string]$manifestFilename = "$($global:PoshPluginsPath)\MyPoshBotPlugin\MyPoshBotPlugin.psd1"
    [string]$moduleFilename = "$($global:PoshPluginsPath)\MyPoshBotPlugin\MyPoshBotPlugin.psm1"
    [string]$guid = $(New-Guid)

    # create the meta file
    $params = @{
        Path = $manifestFilename
        RootModule = $moduleFilename
        ModuleVersion = '0.1.0'
        Guid = $guid
        Author = $($env:USERNAME)
        Description = 'My PoshBot Plugin'
        RequiredModules = @("Poshbot")
    }
    New-ModuleManifest @params

    # create empty module file
    New-Item -Path $moduleFilename -ItemType File

    # add some content already
    Add-Content -Path $moduleFilename -Value '# My Poshbot plugin'
    Add-Content -Path $moduleFilename -Value ''
    Add-Content -Path $moduleFilename -Value '$CommandsToExport = @()'
    Add-Content -Path $moduleFilename -Value ''
    Add-Content -Path $moduleFilename -Value 'function Invoke-HelloWorld {'
    Add-Content -Path $moduleFilename -Value '  Write-Output "Hello"'
    Add-Content -Path $moduleFilename -Value '}'
    Add-Content -Path $moduleFilename -Value '$CommandsToExport += "Invoke-HelloWorld"'
    Add-Content -Path $moduleFilename -Value ''
    Add-Content -Path $moduleFilename -Value ''
    Add-Content -Path $moduleFilename -Value 'Export-ModuleMember -Function $CommandsToExport'
    Add-Content -Path $moduleFilename -Value ''

    Write-Host "Poshbot Plugin created"
} else {
    Write-Warning "Poshbot Plugin with same name already present!"
}