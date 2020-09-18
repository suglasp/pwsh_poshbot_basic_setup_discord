
# Discord simple demo plugin
# in Discord chat channel, type !install-plugin MyPoshBotDiscordPlugin
# !Invoke-HelloDiscord

$CommandsToExport = @()

function Invoke-HelloDiscord {
    
    Write-Output 'Hi from PoshBot to Discord!'
}
$CommandsToExport += 'Invoke-HelloDiscord'



Export-ModuleMember -Function $CommandsToExport