function Get-DSPamRootFolder {
    [CmdletBinding()]
    param ()
    
    BEGIN {
        Write-Verbose '[]'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }
    }
    
    PROCESS {
        $URI = "$Script:DSBaseURI/api/pam/folders?folderID=null"

        $RequestParams = @{
            URI    = $URI
            Method = 'GET'
        }

        $res = Invoke-DS @RequestParams
        return $res
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose '[Get-DSPAMRootFolder] Completed successfully!'
        }
        else {
            Write-Verbose '[Get-DSPAMRootFolder] Ended with errors...'
        }
    }
}