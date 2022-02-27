

Invoke-Command $demo -Credential $cred {
    Install-WindowsFeature web-server -Restart -IncludeManagementTools
}