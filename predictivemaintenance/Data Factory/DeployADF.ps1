#Note: set the variables according to your Azure environment
$subscriptionName = ""
$resourceGrp = ""
$dfName = ""

Login-AzureRmAccount
Get-AzureRmSubscription -SubscriptionName $subscriptionName | Set-AzureRmContext

New-AzureRmDataFactory -ResourceGroupName $resourceGrp -Name $dfName -Location "North Europe"
$df = Get-AzureRmDataFactory -ResourceGroupName $resourceGrp -Name $dfName

#Linked Services
New-AzureRmDataFactoryLinkedService $df -File .\LinkedServices\AzureSqlLinkedService_Store.json
New-AzureRmDataFactoryLinkedService $df -File .\LinkedServices\HDInsightStorageLinkedService.json
New-AzureRmDataFactoryLinkedService $df -File .\LinkedServices\StorageLinkedService_Store.json
New-AzureRmDataFactoryLinkedService $df -File .\LinkedServices\AzuremlBatchEndpointBatchLocation_Compute.json
New-AzureRmDataFactoryLinkedService $df -File .\LinkedServices\HDInsightLinkedService_Compute.json

#Datasets
$files = Get-ChildItem .\Datasets
foreach ($file in $files) {
    New-AzureRmDataFactoryDataset $df -File $file.FullName
}

#Pipelines
$files = Get-ChildItem .\Pipelines
foreach ($file in $files) {
    New-AzureRmDataFactoryPipeline $df -File $file.FullName
}

Remove-AzureRmDataFactory -ResourceGroupName $resourceGrp -Name $dfName