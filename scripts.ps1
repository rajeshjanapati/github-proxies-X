# write-output Apigee Artifacts
$token = $env:TOKEN
$org = $env:ORG
$baseURL = "https://apigee.googleapis.com/v1/organizations/"
$headers = @{Authorization = "Bearer $token"}

# Set your GitHub repository information
$repositoryOwner = "rajeshjanapati@gmail.com"
$repositoryName = "github-proxies-X"
$branchName = "main"  # Change this to the branch you want to access
$githubToken = "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"

# Set your Apigee X organization and environment
$orgName = "esi-apigee-x-394004"
$envName = "eval"
$apiKey = "Bearer $token"

# # Define the GitHub API endpoint to get the ZIP file
# $githubApiUrl = "https://api.github.com/repos/$repositoryOwner/$repositoryName/zipball/$branchName"

# # Create headers with the GitHub authentication token and User-Agent
# $githubHeaders = @{
#     Authorization = "Bearer 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"
#     # "User-Agent" = "PowerShell-GitHub-Downloader"
#     "User-Agent" = ".github/workflows"
#     # "USER_AGENT" = ".github/workflows"
#     # "Accept"="application/vnd.github+json"
# }


# $rateLimitUrl = "https://api.github.com/rate_limit"

# $rateLimitResponse = Invoke-RestMethod -Uri $rateLimitUrl -Method 'GET' -Headers $githubHeaders

# # Output the rate limit information
# Write-Host "Rate Limit: $($rateLimitResponse.resources.core.limit)"
# Write-Host "Remaining Requests: $($rateLimitResponse.resources.core.remaining)"

# Define the path to save the downloaded ZIP file
$zipFilePath = "esi-apigee-x-394004-proxy-FLSessionPreFilter-rev5.zip"

# # Download the ZIP file from GitHub
# Invoke-WebRequest -Uri $githubApiUrl -Headers $githubHeaders -OutFile $zipFilePath

# Check if the ZIP file download was successful
if (Test-Path -Path $zipFilePath) {
    Write-Host "ZIP file downloaded successfully from GitHub."

    # Define the Apigee X API endpoint to upload the ZIP file
    $apigeeApiUrl = "https://apigee.googleapis.com/v1/organizations/$orgName/"

    # Create headers with the Apigee X API key and Content-Type
    $apigeeHeaders = @{
        "x-api-key" = "Bearer $token"
        "Content-Type" = "application/octet-stream"
    }

    # Read the contents of the ZIP file
    $zipFileContent = [System.IO.File]::ReadAllBytes($zipFilePath)

    # Send a POST request to upload the ZIP file to Apigee X
    $apigeeResponse = Invoke-RestMethod -Uri "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/apis?name=$zipFilePath&action=import" -Method 'POST' -Headers $apigeeHeaders -Body $zipFileContent

    # Check if the ZIP file upload was successful
    if ($apigeeResponse -ne $null) {
        Write-Host "ZIP file uploaded successfully to Apigee X."
    } else {
        Write-Host "Failed to upload the ZIP file to Apigee X."
    }
} else {
    Write-Host "Failed to download the ZIP file from GitHub."
}



# # Set your GitHub repository information
# $owner = "rajeshjanapati@gmail.com"
# $repo = "github-proxies-X"
# $filePath = "scripts.ps1" # Path to the file you want to download

# # Set your GitHub token (PAT or GitHub Actions token)
# $token = "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"

# # Create headers with the GitHub authentication token and User-Agent
# $headers = @{
#     Authorization = "Bearer $token"
#     "User-Agent" = ".github/workflows/github-proxies-X"  # Replace with your own User-Agent
# }

# # Define the GitHub API URL to get the contents of the file
# $githubApiUrl = "https://api.github.com/repos/$owner/$repo/contents/$filePath"

# # Make an HTTP GET request to the GitHub API
# $fileContent = Invoke-RestMethod -Uri $githubApiUrl -Method 'GET' -Headers $headers

# # Check if the request was successful
# if ($fileContent -ne $null) {
#     # The file content is base64-encoded, so decode it
#     $decodedContent = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($fileContent.content))

#     # Save the file content to a local file
#     $localFilePath = "downloaded_file.ext"  # Choose a local file path and name
#     Set-Content -Path $localFilePath -Value $decodedContent -Encoding UTF8

#     Write-Host "File downloaded successfully to $localFilePath"
# } else {
#     Write-Host "Failed to download the file from GitHub."
# }
