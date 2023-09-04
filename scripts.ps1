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

# Define the GitHub API endpoint to get the ZIP file
$githubApiUrl = "https://api.github.com/repos/$repositoryOwner/$repositoryName/zipball/$branchName"

# Create headers with the GitHub authentication token and User-Agent
$githubHeaders = @{
    "Authorization" = "Bearer $githubToken",
    "User-Agent" = "PowerShell-GitHub-Downloader"
}

# Define the path to save the downloaded ZIP file
$zipFilePath = "downloaded.zip"

# Download the ZIP file from GitHub
Invoke-WebRequest -Uri $githubApiUrl -Headers $githubHeaders -OutFile $zipFilePath

# Check if the ZIP file download was successful
if (Test-Path -Path $zipFilePath) {
    Write-Host "ZIP file downloaded successfully from GitHub."

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
} else {
    Write-Host "Failed to download the ZIP file from GitHub."
}
