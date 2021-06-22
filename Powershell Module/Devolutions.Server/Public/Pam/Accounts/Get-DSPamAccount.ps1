function Get-DSPamAccount {
    <#
    .SYNOPSIS
    #>
    [CmdletBinding()]
    param(
        [guid]$AccountId,
        [switch]$All
    )

    BEGIN {
        Write-Verbose '[Get-DSPamAccount] Beginning...'
 
        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session invalid. Please call New-DSSession.'
        }

        [ServerResponse]$Response = [ServerResponse]::new()
    }
    PROCESS {
        $ProviderIDs = ($res = Get-DSPamProviders).isSuccess ? ($res.Body | Select-Object -ExpandProperty 'id') : $null
        $AccountIDs = ($res = Get-DSPAMRootFolder).isSuccess ? ($res.Body.credentialIDs | Where-Object { $_ -notin $ProviderIDs } ) : $(throw 'Could not find your PAM root folder. Please make sure your DVLS instance is reachable and try again.')
            
        $RequestParams = @{
            URI    = ''
            Method = 'GET'
        }

        if ($All) {
            $Accounts = @()
            $AccountIDs | ForEach-Object {
                $RequestParams.URI = "$Script:DSBaseURI/api/pam/credentials/$_"
                (($res = Invoke-DS @RequestParams).isSuccess ? ($Accounts += $res.Body) : (Write-Error "Trouble accessing account with ID $_.")) | Out-Null
            }

            $Response.isSuccess = $true
            $Response.Body = $Accounts
            $Response.StandardizedStatusCode = 200
        }
        else {
            if (!$AccountId) { throw 'Please provide an account ID or use the -All parameter.' }

            $RequestParams.URI = "$Script:DSBaseURI/api/pam/credentials/$AccountId"

            ((($res = Invoke-DS @RequestParams).isSuccess) ? ($Response.Body = $res.Body) : $(throw 'Could not find an account associated to this ID.')) | Out-Null
            $Response.isSuccess = $res.isSuccess
            $Response.StandardizedStatusCode = 200
        }

        return $Response
    }
    END {
        If ($Response.isSuccess) {
            Write-Verbose '[Get-DSPamAccount] Completed Successfully.'
        }
        else {
            Write-Verbose '[Get-DSPamAccount] Ended with errors...'
        }
    }
}