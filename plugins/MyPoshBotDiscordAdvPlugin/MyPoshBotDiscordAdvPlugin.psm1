
# Discord advanced demo plugin
# in Discord chat channel, type !install-plugin MyPoshBotDiscordAdvPlugin
# !hello <something>

$CommandsToExport = @()

function Invoke-HelloWorld {
  [PoshBot.BotCommand(CommandName = 'hello')]
  [cmdletbinding()]
  param(
    [string]$Subject
  )
  Write-Output "Hello $($Subject)"
}
$CommandsToExport += "Invoke-HelloWorld"


Export-ModuleMember -Function $CommandsToExport

