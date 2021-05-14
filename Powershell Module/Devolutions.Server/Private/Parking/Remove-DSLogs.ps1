function Remove-DSLogs {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
    
    .NOTES
    
    .LINK
    #>
        [CmdletBinding()]
        param(
        )
        
        BEGIN {
            Write-Verbose '[Remove-DSLogs] begin...'

            $URI = "$Script:DSBaseURI/api/log/cleanup/run"
    
    		if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))
			{
				throw "Session does not seem authenticated, call New-DSSession."
			}
        }
    
        PROCESS {

            $tableList = [System.Collections.Generic.List[object]]::new()

            $cleanupOptions = @{
                cleanupOlderThan = 1
                cleanupOption = 1
                deleteWhenOlderThan = 3
            }

            $anOption = @{
                cleanupOlderThan = 1
                cleanupOption = 1
                deleteWhenOlderThan = 3
                tableName = 'ConnectionLog'
            }

            $tableList.Add($anOption)

            $body = @{
                logTablesCleanupInfo = $tableList
                defaultLogCleanupInfo = $cleanupOptions
            }

            $params = @{
                Uri = $URI
                Method = 'POST'
                LegacyResponse = $true
                Body = $body | ConvertTo-Json
            }

            return Invoke-DS @params
        }

        END {
            Write-Verbose '[Remove-DSLogs] Exit.'
        }
    }
