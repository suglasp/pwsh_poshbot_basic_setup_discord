
#
# Poshbot for Discord
# Pieter De Ridder aka Suglasp
# Poshbot Discord Demo Chatbot (ChatOps)
#
# Create date : 17/09/2020
# Change date : 18/09/2020
#
# Tested with Powershell 7.0.3 and Powershell 5.1
#

#
# some reading:
# discord : https://poshbot.readthedocs.io/en/latest/guides/backends/setup-discord-backend/
# plugins : https://poshbot.readthedocs.io/en/latest/guides/plugin-configuration/
#


# load Poshbot module
If (-not (Get-Module -Name PoshBot)) {
    Install-Module -Name PoshBot -Scope CurrentUser
    Import-Module -Name PoshBot
}


# global vars
$global:WorkingDir = $($PSScriptRoot)
$global:PoshPluginsPath = "$($global:WorkingDir)\plugins"
$global:PoshLogPath = "$($global:WorkingDir)\logs"
$global:PoshConfigPath = "$($global:WorkingDir)\config"
$global:PoshConfigFile = "$($global:PoshConfigPath)\config.psd1"


# create Poshbot runtime folders
if (-not (Test-Path $global:PoshPluginsPath)) {
    New-Item -Path $global:PoshPluginsPath -ItemType Directory
}

if (-not (Test-Path $global:PoshConfigPath)) {
    New-Item -Path $global:PoshConfigPath -ItemType Directory
}

if (-not (Test-Path $global:PoshLogPath)) {
    New-Item -Path $global:PoshLogPath -ItemType Directory
}


# include our Poshbot plugins path into our global PWSH modules path
If (-not ($env:PSModulePath.Contains($global:PoshPluginsPath))) {
    $env:PSModulePath += ";" + $global:PoshPluginsPath
    [Environment]::SetEnvironmentVariable('PSModulePath', $env:PSModulePath, 'User')
}


# config poshbot
$pbc = New-PoshBotConfiguration
$pbc.Name = "channelbot"
$pbc.BotAdmins = @($env:USERNAME)      # We assume your current user exists and is Admin in the Discord channel
$pbc.ConfigurationDirectory = $global:WorkingDir
$pbc.PluginDirectory = $global:PoshPluginsPath
$pbc.LogDirectory = $global:PoshLogPath
$pbc.CommandPrefix = '!'
$pbc.LogLevel = 'Info'    # change to 'Verbose' for extended logging
$pbc.MaxLogSizeMB = 10
$pbc.MaxLogsToKeep = 30
#$pbc.AddCommandReactions = $false   # Disable Discord reactions from Bot


Save-PoshBotConfiguration -InputObject $pbc -Path $global:PoshConfigFile -Force


# config Discord settings for our bot
$backendConfig = @{
    Name     = 'DiscordBackend'
    Token    = '<Add_Discord_Token_Here>'
    ClientId = '<Add_ClientID_Here>'
    GuildId  = '<Add_GUILDID_Here>'
}

$backend = New-PoshBotDiscordBackend -Configuration $backendConfig

# start our Discord chat bot
while($True) {
    try {
        Write-Host "Starting Poshbot for Discord..."
        $err = $null
        $bot = New-PoshBotInstance -Configuration $pbc -Backend $backend
        $bot | Start-PoshBot -Verbose -ErrorVariable err
        if($err) {
            throw $err
        }
    }
    catch {
        $_ | Format-List -Force | Out-String | Out-File (Join-Path $pbc.LogDirectory Service.Error)
    }
}

Exit(0)
