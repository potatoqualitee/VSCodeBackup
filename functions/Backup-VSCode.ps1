function Backup-VSCode {
    <#
    .SYNOPSIS
    Backup VS Code settings and extensions
    
    .DESCRIPTION
    Backup VS Code settings and extensions
    
    .PARAMETER Path
    Location to store zip file
    
    .PARAMETER Settings
    Switch to backup settings
    
    .PARAMETER Extensions
    Switch to backup extensions
    
    .EXAMPLE
    Backup-VSCode -Path c:\Users\bobby\Desktop -Settings -Extensions
    
    .NOTES
    General notes
    #>
    
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $Path,
        # Parameter help description
        [Parameter()]
        [switch]
        $Settings,
        # Parameter help description
        [Parameter()]
        [switch]
        $Extensions
    )
    
    begin {
        $TimeStamp = Get-Date -Format o | foreach {$_ -replace ":", "."}
        $Name = "VSCode-$($TimeStamp).zip"
    }
    
    process {
        #Can't read some files while Code is running
        $CodeRunning = Get-Process code
        
        if($CodeRunning) {
            Write-Verbose "Closing VS Code"
            $CodeRunning.CloseMainWindow() | Out-Null
        }

        $ExtenionsDirectory = "$env:USERPROFILE\.vscode"
        $SettingsDirectory = "$env:APPDATA\Code\User\settings.json"
        if($Extensions) {
            try {
                Compress-Archive -Path $ExtenionsDirectory -DestinationPath $Path\$Name -Update -CompressionLevel NoCompression
            }
            catch {
                throw $_
            }
        }
        if($Settings) {
            try {
                Compress-Archive -LiteralPath $SettingsDirectory -DestinationPath $Path\$Name -Update
            }
            catch {
                throw $_
            }
        }
    }
    
    end {
    }
}