Function Convert-LegacyResponse {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER 
    .NOTES
    #>
    [cmdletbinding()]
    [OutputType([ServerResponse])]
    param(
        [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject] $Response
    )

    <#
  RDM expected to always get HTTP 200, but analyzed the result field.  During the transition to 
  modern endpoints we need to map 
 #>
    BEGIN {

    }

    PROCESS {
        if ($Response -eq $null) {
            return [ServerResponse]::new($false, $null, $null, $exc, '', 400)                        
        }

        $responseContentHash = $Response.Content | ConvertFrom-Json -AsHashtable
        $responseContent = $Response.Content | ConvertFrom-Json

        #some legacy apis return only result=1...
        if (($responseContentHash.Keys.Count -eq 1) -and ($responseContentHash.ContainsKey('result'))) {
            $newbody = $null
        }
        else {
            # some others return arrays of objects without ceremony
            if ($responseContent -is [system.array]) {
                $newdata = $responseContent
            }
            elseif ($responseContent -is [Boolean]) {
                $newdata = $responseContent
            }
            elseif ($responseContentHash.ContainsKey('data')) {
                $newdata = $responseContent.data
            }
            else {
                throw 'unexpected condition in Convert-LegacyResponse'
            }

            #for standardization, we must push it down to a Body.data element
            $newbody = [PSCustomObject]@{
                totalCount  = -1
                currentPage = -1
                data        = $newdata
            }
        }

        if ($responseContent.result -eq 1) {
            return [ServerResponse]::new($true, $Response, $newbody, $null, '', 200)                        
        }

        #BaseControllerV3.ToHttpStatusCode
        #Absent Result field means success (assume 1 when null...)
        $newStatusCode = 200
        if (!(Get-Member -inputobject $responseContent -name 'result')) {
            return [ServerResponse]::new($true, $Response, $newbody, $null, $null, $newStatusCode)                        
        }

        $newStatusCode = switch ($responseContent.result) {
            2 {
                401            
            }
            3 {
                400
            }
            4 {
                400
            }
            5 {
                400
            }
            6 {
                404
            }
            7 {
                401
            }
            8 {
                500
            }
            9 {
                401
            }
            10 {
                401
            }
            11 {
                400
            }
        }
        return [ServerResponse]::new($false, $Response, $responseContent, $null, $responseContent.errorMessage, $newStatusCode)                        
    }

    END {

    }

}