$Script:Settings = Get-Content -Path "$PSScriptRoot\settings.json" | ConvertFrom-Json

# This will override the settings.json file if required.
if ($env:TDXSettings) {
    $script:Settings=$env:TDXSettings | ConvertFrom-Json
}
else {
    Write-Error -Message "No environment variable TDXSettings found.
    Set `$env:TDXSettings to a JSON-formatted string containing BaseURI and AppID properties (see settings.json for example)."
}

$Script:Session = $NULL
[int]$Script:APICallCount = 0

[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    . $_.FullName | Out-Null
}