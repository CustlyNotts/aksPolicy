# Create a placeholder for the output file
$outputFile = "C:\Temp\AKSCompliance.csv"

# Get a list of all subscriptions
$subscriptions = Get-AzSubscription

# Create an array to hold the result
$results = @()

# Iterate through every subscription
foreach ($subscription in $subscriptions) {
    Select-AzSubscription -SubscriptionId $subscription.Id

    # Get a list of all clusters in present subscription
    $aksClusters = Get-AzAksCluster

    # Iterate through each cluster
    foreach ($aksCluster in $aksClusters) {
        $aksClusterName = $aksCluster.Name 

        # Get policy compliance information per cluster
        $policyCompliance = Get-AzPolicyState -ResourceGroupName $aksCluster.ResourceGroupName -Filter "PolicyDefinitionAction eq 'deny'" 

        # Select relevant properties and export to CSV
        $results += $policyCompliance | ForEach-Object { 
            [PSCustomObject] @{
                SubscriptionName = $subscription.Name
                ResourceGroupName = $aksCluster.ResourceGroupName
                ResourceName = $aksClusterName
                ComplianceState = $_.ComplianceState
            }
        } 
    }
}
 
# Export final result to the output file
$results | Export-Csv -Path $outputFile -NoTypeInformation
