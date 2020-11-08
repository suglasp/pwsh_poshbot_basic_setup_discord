
#
# Create a new Poshbot plugin (Powershell Module).
# Notice : This script creates a "simple" Poshbot plugin.
#
# Reading:
# Simple Plugin   : https://poshbot.readthedocs.io/en/latest/guides/plugin-configuration/
# Advanced Plugin : https://poshbot.readthedocs.io/en/latest/tutorials/plugin-development/advanced/poshbot.botcommand-attribute/
#   For advanced Plugins, set in the .psm1 file : RequiredModules = 'PoshBot'
#

# global vars
$global:WorkFolder = $($PSScriptRoot)
$global:PoshPluginsPath = "$($global:WorkFolder)\plugins"

# create plugins folder
If (-Not (Test-Path $global:PoshPluginsPath)) {
    New-Item $global:PoshPluginsPath -ItemType Directory
}

[string]$NewPluginName = Read-Host -Prompt "Enter Poshbot Plugin Name (ex.: MyPoshbotPlugin)"
[string]$NewPluginDesc = Read-Host -Prompt "Enter Plugin Description"
[string]$NewPluginAuthor = Read-Host -Prompt "Enter Plugin Author Name"

# sanity checks
If ([string]::IsNullOrEmpty($NewPluginName)) {
  Write-Warning "You must provide a Plugin name!"
  Exit(-1)
}

# set default Author name
If ([string]::IsNullOrEmpty($NewPluginAuthor)) {
    $NewPluginAuthor = [environment]::GetEnvironmentVariable("USERNAME")
}

# create module manifest file
If (-Not (Test-Path "$($global:PoshPluginsPath)\$($NewPluginName)")) {
    New-Item "$($global:PoshPluginsPath)\$($NewPluginName)" -ItemType Directory
    
    [string]$manifestFilename = "$($global:PoshPluginsPath)\$($NewPluginName)\$($NewPluginName).psd1"
    [string]$moduleFilename = "$($global:PoshPluginsPath)\$($NewPluginName)\$($NewPluginName).psm1"
    [string]$guid = $(New-Guid)

    # create the meta file
    $params = @{
        Path = $manifestFilename
        RootModule = $(Split-Path $moduleFilename -Leaf)
        ModuleVersion = '1.0.0.0'
        Guid = $guid
        Author = $($NewPluginAuthor)
        Description = $($NewPluginDesc)
        #RequiredModules = @("Web.Global")
    }
    New-ModuleManifest @params

    # create empty module file
    New-Item -Path $moduleFilename -ItemType File

    # add some content already
    [string]$timeStampCreated = $(Get-Date).ToString("dd/MM/yyyy")

    Add-Content -Path $moduleFilename -Value ""
    Add-Content -Path $moduleFilename -Value "#"
    Add-Content -Path $moduleFilename -Value "# $($NewPluginAuthor)"
    Add-Content -Path $moduleFilename -Value "# $($NewPluginDesc)"
    Add-Content -Path $moduleFilename -Value "#"
    Add-Content -Path $moduleFilename -Value "# created : $($timeStampCreated)"
    Add-Content -Path $moduleFilename -Value "# changed : $($timeStampCreated)"
    Add-Content -Path $moduleFilename -Value "#"
    Add-Content -Path $moduleFilename -Value ""
    Add-Content -Path $moduleFilename -Value '$CommandsToExport = @()'
    Add-Content -Path $moduleFilename -Value ""
    Add-Content -Path $moduleFilename -Value "#"
    Add-Content -Path $moduleFilename -Value "# Function : Invoke-HelloPoshWorld"
    Add-Content -Path $moduleFilename -Value "#"
    Add-Content -Path $moduleFilename -Value "Function Invoke-HelloPoshWorld {"
    Add-Content -Path $moduleFilename -Value '  Write-Output "Hello from POSHBOT"'
    Add-Content -Path $moduleFilename -Value "}"
    Add-Content -Path $moduleFilename -Value '$CommandsToExport += "Invoke-HelloPoshWorld"'
    Add-Content -Path $moduleFilename -Value ""
    Add-Content -Path $moduleFilename -Value ""
    Add-Content -Path $moduleFilename -Value 'Export-ModuleMember -Function $CommandsToExport'
    Add-Content -Path $moduleFilename -Value ""

    Write-Host "Webserver Plugin has been created!"
} else {
    Write-Warning "Webserver Plugin with same name already present!"
    Exit(-1)
}

Exit(0)