# Define output file path
$outputFile = "C:\Temp\policyAKSCompliance.csv"

# Get all Azure subscriptions
$subscriptions = Get-AzSubscription

# Create an array to hold the result
$results = @()

# Loop through each subscription
foreach ($subscription in $subscriptions) {
	# Set the current subscription context
	Set-AzContext -Subscription $subscription.Id

    # Get all Azure Policy compliance states
    $complianceStates = Get-AzPolicyState -All

    # Select relevant properties and export to CSV
    $results += $complianceStates | ForEach-Object { [PSCustomObject] @{
        SubscriptionName = $subscription.Name
        PolicyDefinitionName = $_.PolicyDefinitionName
        ResourceGroup = $_.ResourceGroup
        ResourceLocation = $_.ResourceLocation
        ResourceType = $_.ResourceType
        ComplianceState = $_.ComplianceState
    }
    
}
}
$results | Export-Csv -Path $outputFile -NoTypeInformation
