function UpdateConfigurationSetting($configurationFile, $settingValue, $settingKey)
{
    [xml]$xml = get-content $configurationFile;
	
	$xml.ServiceConfiguration.Role | 
	  ForEach-Object  { $_.ConfigurationSettings.Setting } | 
	  Where-Object { $_.name -match $settingKey } | 
	  ForEach-Object  { $_.value = $settingValue;}
	  
    $xml.Save($configurationFile);
}

function UpdateWebConfigurationSetting($configurationFile, $settingValue, $settingKey)
{
    [xml]$xml = get-content $configurationFile;
	$entry = $xml.configuration.appSettings.add | Where-Object { $_.key -match $settingKey }
	$entry.value = $settingValue;

    $xml.Save($configurationFile);
}

function UpdateProperty($file, $property, $value)
{
    $content = get-content $file;
	$replaceStr = '$1' + """$value""";
	$content = $content -replace "($property\s*\=\s*)\""(.*)\""", $replaceStr
	set-content $file $content
}

# ------------------------------ 
# Obtaining Configuration Values
# ------------------------------
$configurationFilePath = "..\..\..\Configuration.xml";
[xml]$xml = Get-Content $configurationFilePath;
$storageAccountName = $xml.Configuration.WindowsAzureStorage.AccountName.ToLower();
$storageAccountKey = $xml.Configuration.WindowsAzureStorage.AccountKey;

$localServiceConfigurationPath = "..\..\..\code\SocialGames.Cloud.Local\ServiceConfiguration.cscfg";
$webConfigurationPath = "..\..\..\code\SocialGames.TicTacToe\Web.config";

# -----------------------------
# Updating connection strings 
# -----------------------------

Write-Output ""
Write-Output "Updating connection strings..."


if($connectionString) 
{
    $connectionString = "UseDevelopmentStorage=true";
	$blobEndpoint = "http://127.0.0.1:10000/devstoreaccount1/";
}
else
{
    $connectionString = "DefaultEndpointsProtocol=https;AccountName=$storageAccountName;AccountKey=$storageAccountKey";
	$blobEndpoint = "http://$storageAccountName.blob.core.windows.net/";
}

$settingKey = "DataConnectionString";
UpdateConfigurationSetting $localServiceConfigurationPath $connectionString $settingKey;
UpdateProperty $clientScriptPath $clientProperty $blobEndpoint;

$settingKey = "BlobUrl";
UpdateWebConfigurationSetting $webConfigurationPath $blobEndpoint $settingKey;