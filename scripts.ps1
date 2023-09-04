# write-output Apigee Artifacts
$token = $env:TOKEN
$org = $env:ORG
$baseURL = "https://apigee.googleapis.com/v1/organizations/"
$headers = @{Authorization = "Bearer $token"}

# Set your GitHub repository information
$repositoryOwner = "rajeshjanapati@gmail.com"
$repositoryName = "apigee-artifacts"
$branchName = "release/org"  # Change this to the branch you want to access
$githubToken = "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"

# Set your Apigee X organization and environment
$orgName = "esi-apigee-x-394004"
$envName = "eval"
$apiKey = "Bearer $token"

# # Clone the repository
# git clone https://github.com/rajeshjanapati/apigee-artifacts.git
# # cd $repositoryName
# cd apigee/artifacts-nonprod/proxies

# # Read JSON files
# $jsonFiles = Get-ChildItem -Filter *.json -Recurse

# $jsonContent = Get-Content -Path $jsonFile -Raw
# # Parse the JSON content
# $jsonData = ConvertFrom-Json $jsonContent

# # Extract the value of the "name" key from the JSON data
# $proxyName = $jsonData.name

# Write-Host "Proxy-Name: $proxyName"

# Define the list of GitHub file URLs to download
$githubFileUrls = @(
    "https://github.com/$repositoryOwner/$repositoryName/zipball/$branchName"
    # Add more file URLs as needed
)

# Create headers with the GitHub authentication token and User-Agent
$githubHeaders = @{
    "Authorization" = "Bearer $githubToken"
    "User-Agent" = "PowerShell-GitHub-Downloader"
}

# Loop through each GitHub file URL
foreach ($githubFileUrl in $githubFileUrls) {
    # Generate a unique name for the downloaded ZIP file
    $zipFileName = "downloaded_$(Get-Date -Format 'yyyyMMddHHmmss').zip"
    $zipFilePath = Join-Path -Path $env:TEMP -ChildPath $zipFileName

    # Download the ZIP file from GitHub
    Invoke-WebRequest -Uri $githubFileUrl -Headers $githubHeaders -OutFile $zipFilePath

    # Check if the ZIP file download was successful
    if (Test-Path -Path $zipFilePath) {
        Write-Host "ZIP file downloaded successfully from GitHub: $zipFileName"

        # Define the Apigee X API endpoint to upload the ZIP file
        $apigeeApiUrl = "https://apigee.googleapis.com/v1/organizations/$orgName/environments/$envName/deployments"

        # Create headers with the Apigee X API key and Content-Type
        $apigeeHeaders = @{
            "x-api-key" = $apiKey
            "Content-Type" = "application/octet-stream"
        }

        # Read the contents of the ZIP file
        $zipFileContent = [System.IO.File]::ReadAllBytes($zipFilePath)

        # Send a POST request to upload the ZIP file to Apigee X
        $apigeeResponse = Invoke-RestMethod -Uri $apigeeApiUrl -Method 'POST' -Headers $apigeeHeaders -Body $zipFileContent

        # Check if the ZIP file upload was successful
        if ($apigeeResponse -ne $null) {
            Write-Host "ZIP file uploaded successfully to Apigee X."
        } else {
            Write-Host "Failed to upload the ZIP file to Apigee X."
        }

        # Remove the downloaded ZIP file to avoid cluttering the system
        # Remove-Item -Path $zipFilePath -Force
    } else {
        Write-Host "Failed to download the ZIP file from GitHub."
    }
}
