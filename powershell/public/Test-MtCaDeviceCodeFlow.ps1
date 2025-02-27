<#
 .Synopsis
    Checks if the tenant has at least one conditional access policy that includes Authentication Flows - Device Code Flow as a condition.

 .Description
    Organizations should block or limit device code flow because it can be exploited in phishing attacks, such as those conducted by the Storm-2372 group.
    Attackers leverage this authentication method to trick users into entering device codes on malicious websites, granting unauthorized access to accounts.
    Blocking or limiting this flow helps prevent exploitation by minimizing attack vectors, improving overall security posture, and safeguarding against compromised credentials through phishing techniques.

    Learn more:
    https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-block-authentication-flows

 .Example
    Test-MtCaDeviceCodeFlow

.LINK
    https://maester.dev/docs/commands/Test-MtCaDeviceCodeFlow
#>
function Test-MtCaDeviceCodeFlow {
    [CmdletBinding()]
    [OutputType([bool])]
    param ()

    $policies = Get-MtConditionalAccessPolicy | Where-Object { $_.state -eq "enabled" }
    $policiesResult = New-Object System.Collections.ArrayList
    $result = $false

    foreach ($policy in $policies) {
        if ( $policy.conditions.authenticationFlows.transfermethods -eq "deviceCodeFlow")
        {
            $result = $true
            $currentresult = $true
            $policiesResult.Add($policy) | Out-Null
        } else {
            $currentresult = $false
        }
        Write-Verbose "$($policy.displayName) - $currentresult"
    }

    if ( $result ) {
        $testResult = "Well done! The following conditional access policies are targeting the Device Code authentication flow:`n`n%TestResult%"
    } else {
        $testResult = "No conditional access policy found that targets the Device Code authentication flow."
    }

    Add-MtTestResultDetail -Result $testResult -GraphObjects $policiesResult -GraphObjectType ConditionalAccess

    return $result
}

