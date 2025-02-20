# Need the TDXSettings environment variable set to be able to import the module and run the tests
BeforeAll{
    $env:TDXSettings = '{ "BaseURI": [""], "AppID": ["01"] }'
    [String]$ModuleRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src\UofITDXTickets'
    Import-Module -Name $ModuleRoot
}

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\UofITDXTickets\UofITDXTickets.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }
}
