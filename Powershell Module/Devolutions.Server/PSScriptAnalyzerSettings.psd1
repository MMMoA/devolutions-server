# PSScriptAnalyzerSettings.psd1
@{
    Severity     = @('Error', 'Warning')

    ExcludeRules = @('PSAvoidUsingCmdletAliases',
        'PSAvoidGlobalVars',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSAvoidUsingUsernameAndPasswordParams',
        'PSAvoidUsingPlainTextForPassword'
    )
}