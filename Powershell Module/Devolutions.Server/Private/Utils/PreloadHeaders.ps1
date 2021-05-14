function PreloadHeaders{
    [cmdletbinding()]
    param(
        [Hashtable]$headers
    )
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSProvideCommentHelp', $null)]
    $Global:DSHdr = $headers
}    
