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

# # ------------------------------------Proxies------------------------------------------
# # Clone the repository
# git clone https://github.com/rajeshjanapati/github-proxies-X.git
# # cd $repositoryName

# # Use Get-ChildItem to list all files in the directory with a .zip extension
# $zipFiles = Get-ChildItem -Path $directoryPath -Filter *.zip

# # Loop through each .zip file and do something with them
# foreach ($zipFile in $zipFiles) {
#     # Get the full path of the .zip file
#     $zipFilePath = $zipFile.FullName

#     # Do something with the file, for example, print the file name
#     Write-Host "Found .zip file: $($zipFile.Name)"

#     $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
#     $headers.Add("Authorization", "Bearer $token")

#     $multipartContent = [System.Net.Http.MultipartFormDataContent]::new()
#     $multipartFile = $zipFilePath
#     $FileStream = [System.IO.FileStream]::new($multipartFile, [System.IO.FileMode]::Open)
#     $fileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new("form-data")
#     $fileHeader.Name = "file"
#     $fileHeader.FileName = $zipFilePath
#     $fileContent = [System.Net.Http.StreamContent]::new($FileStream)
#     $fileContent.Headers.ContentDisposition = $fileHeader
#     $multipartContent.Add($fileContent)

#     $body = $multipartContent

#     # Set the filename with the ".zip" extension
#     $filenameWithExtension = $($zipFile.Name)

#     # Use the [System.IO.Path] class to remove the extension
#     $filenameWithoutExtension = [System.IO.Path]::ChangeExtension($filenameWithExtension, $null)

#     # Remove the dot from the filename
#     $filenameWithoutExtension = $filenameWithoutExtension.Replace(".", "")

#     # Print the filename without the extension
#     Write-Host "Filename without extension: $filenameWithoutExtension"

#     $uploadurl = "https://apigee.googleapis.com/v1/organizations/"+$org+"/apis?name="+$filenameWithoutExtension+"&action=import"

#     Write-Host $uploadurl

#     $response = Invoke-RestMethod $uploadurl -Method 'POST' -Headers $headers -Body $body
#     $response | ConvertTo-Json

# }

# --------------------------------------KVMs-------------------------------------------

cd kvms

# Read JSON files
$jsonFiles = Get-ChildItem -Filter *.json -Recurse

# Loop through each JSON file and make POST requests
foreach ($jsonFile in $jsonFiles) {
    $jsonContent = Get-Content -Path $jsonFile -Raw
    # Parse the JSON content
    $jsonData = ConvertFrom-Json $jsonContent

    # Extract the value of the "name" key from the JSON data
    $kvmName = $jsonData.name

    # Print the extracted value
    Write-Host "KVM Name: $kvmName"

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Bearer $token")
    $headers.Add("Content-Type", "application/json")


    $kvmget = Invoke-RestMethod -Uri "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps" -Method 'GET' -Headers $headers
    $kvmget | ConvertTo-Json
    Write-Host $kvmget
    

    # Your array
    $array = $kvmget

    # if ($array -contains $kvmget) {
    #     Write-Host "$kvmget is in the list"
    # }
    # else {
    #     Write-Host "$kvmget not found in the list"
    #     $body1 =@{
    #         "name"=$kvmName;
    #         "encrypted"=true;
    #         }
    #     Write-Host ($body1|ConvertTo-Json)
    #     Write-Host "$valueToCheck is not present in the array."
    #     $kvmcreate = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps' -Method 'POST' -Headers $headers -Body ($body1|ConvertTo-Json)
    #     $kvmcreate | ConvertTo-Json

    # }
    
    foreach ($valueToCheck in $array) {
        if ($array -contains $kvmName) {
            Write-Host "entered into IF..."
            Write-Host "$valueToCheck is present in the array."
            $entries = $jsonData.entry
            Write-Host "Values: $vlaues"

            # $url = "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps/"+$kvmName+"/entries"
            # Write-Host $url

            # $kvmgetentries = Invoke-RestMethod -Uri $url -Method 'GET' -Headers $headers
            # $kvmgetentriesvalues = $kvmgetentries | ConvertTo-Json
            # # Write-Host $kvmgetentriesvalues
            
            
            # # # Output the KVM entries for debugging
            # $kvmgetentriesvalues | Format-Table
        
            foreach ($entry in $entries) {
                Write-Host "step-2"
                $name = $entry.key
                $value = $entry.value
                Write-Host "Key: $name, Value: $value"
                $body2 = @{
                    "name" = $name;
                    "value" = $value;
                }
                Write-Host "body2: $body2"
                
                try {
                    
                    # Make the API request
                    $response = Invoke-RestMethod -Uri "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps/$kvmName/entries" -Method 'POST' -Headers $headers -Body ($body2 | ConvertTo-Json)
                
                    # Get and print the status code
                    $statuscode = $response.StatusCode
                    Write-Host "Status Code: $statuscode"
                } catch [System.Net.HttpStatusCode] {
                    # Handle the specific error (HTTP status code 409) gracefully
                    Write-Host "Conflict (409) error occurred, but the script will continue."
                } catch {
                    # Handle any other exceptions that may occur
                    Write-Host "An error occurred: $_"
                }

            }
        } else {
            Write-Host "entered into ELSE..."
            $body1 =@{
                "name"=$kvmName;
                "encrypted"=true;
                }
            Write-Host ($body1|ConvertTo-Json)
            Write-Host "$valueToCheck is not present in the array."
            $kvmcreate = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps' -Method 'POST' -Headers $headers -Body ($body1|ConvertTo-Json)
            $kvmcreate | ConvertTo-Json

            $entries = $jsonData.entry
            Write-Host "Values: $vlaues"

            # $url = "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps/"+$kvmName+"/entries"
            # Write-Host $url

            # $kvmgetentries = Invoke-RestMethod -Uri $url -Method 'GET' -Headers $headers
            # $kvmgetentriesvalues = $kvmgetentries | ConvertTo-Json
            # # Write-Host $kvmgetentriesvalues
            
            
            # # # Output the KVM entries for debugging
            # $kvmgetentriesvalues | Format-Table
        
            foreach ($entry in $entries) {
                Write-Host "step-2"
                $name = $entry.key
                $value = $entry.value
                Write-Host "Key: $name, Value: $value"
                $body2 = @{
                    "name" = $name;
                    "value" = $value;
                }
                Write-Host "body2: $body2"
                
                try {
                    
                    # Make the API request
                    $response = Invoke-RestMethod -Uri "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps/$kvmName/entries" -Method 'POST' -Headers $headers -Body ($body2 | ConvertTo-Json)
                
                    # Get and print the status code
                    $statuscode = $response.StatusCode
                    Write-Host "Status Code: $statuscode"
                } catch [System.Net.HttpStatusCode] {
                    # Handle the specific error (HTTP status code 409) gracefully
                    Write-Host "Conflict (409) error occurred, but the script will continue."
                } catch {
                    # Handle any other exceptions that may occur
                    Write-Host "An error occurred: $_"
                }

            }
        }
    }
}
cd ..

# -------------------------------------API Products----------------------------------------------

# cd apiproducts

# # Read JSON files
# $jsonFiles = Get-ChildItem -Filter *.json -Recurse

# # Loop through each JSON file and make POST requests
# foreach ($jsonFile in $jsonFiles) {
#     $jsonContent = Get-Content -Path $jsonFile -Raw
#     # Parse the JSON content
#     $jsonData = ConvertFrom-Json $jsonContent
#     Write-Host ($jsonData | ConvertTo-Json)

#     # Extract the value of the "name" key from the JSON data
#     $apiproductname = $jsonData.name

#     # Print the extracted value
#     Write-Host "API Product Name: $apiproductname"

#     $headers = @{
#         "Authorization" = "Bearer $token"
#         "Content-Type" = "application/json"
#     }

#     $apiproductget = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/apiproducts' -Method 'GET' -Headers $headers
#     # Print the entire JSON response to inspect its structure
#     Write-Host ($apiproductget | ConvertTo-Json)

#     # Your array
#     $array = $apiproductget
    
#     $apiproducts = $apiproductget.apiProduct  # Access the correct property

#     foreach ($apiproduct in $($apiproducts)) {
#         Write-Host "entered into foreach..."
#         if ($apiproduct.name -eq $apiproductname) {
#             Write-Host "github-apiproduct is present in the API products."
#             # Perform actions when the item is found
#         }
#         else{
#             Write-Host "github-apiproduct is not PRESENT in the API products."
#             try {
#                 $response = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/apiproducts' -Method 'POST' -Headers $headers -Body ($jsonData | ConvertTo-Json)
#                 $response | ConvertTo-Json
#                 Write-Host "Done..."
#                 # Get and print the status code
#                 $statuscode = $response.StatusCode
#                 Write-Host "Status Code: $statuscode"
#                 } catch [System.Net.HttpStatusCode] {
#                     # Handle the specific error (HTTP status code 409) gracefully
#                     Write-Host "Conflict (409) error occurred, but the script will continue."
#                 } catch {
#                     # Handle any other exceptions that may occur
#                     Write-Host "An error occurred: $_"
#                 }
#             }
#         }
#     }

# cd ..

# # --------------------------------- Developers ----------------------------------------------------

# cd developers

# # Read JSON files
# $jsonFiles = Get-ChildItem -Filter *.json -Recurse

# # Loop through each JSON file and make POST requests
# foreach ($jsonFile in $jsonFiles) {
#     $jsonContent = Get-Content -Path $jsonFile -Raw
#     # Parse the JSON content
#     $jsonData = ConvertFrom-Json $jsonContent
#     Write-Host ($jsonData | ConvertTo-Json)

#     # Extract the value of the "name" key from the JSON data
#     $developername = $jsonData.email

#     # Print the extracted value
#     Write-Host "Developer Name: $developername"

#     $headers = @{
#         "Authorization" = "Bearer $token"
#         "Content-Type" = "application/json"
#     }

#     $developerget = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/developers' -Method 'GET' -Headers $headers
#     # Print the entire JSON response to inspect its structure
#     Write-Host ($developerget | ConvertTo-Json)

#     # Your array
#     $array = $developerget
    
#     $developers = $developerget.developer  # Access the correct property

#     foreach ($developer in $($developers)) {
#         Write-Host "entered into foreach..."
#         if ($developer.email -eq $developername) {
#             Write-Host "github-apiproduct is present in the API products."
#             # Perform actions when the item is found
#         }
#         else{
#             try {
#                 $response = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/developers' -Method 'POST' -Headers $headers -Body ($jsonData | ConvertTo-Json)
#                 $response | ConvertTo-Json
#                 Write-Host "Done..."
#                 # Get and print the status code
#                 $statuscode = $response.StatusCode
#                 Write-Host "Status Code: $statuscode"
#                 } catch [System.Net.HttpStatusCode] {
#                     # Handle the specific error (HTTP status code 409) gracefully
#                     Write-Host "Conflict (409) error occurred, but the script will continue."
#                 } catch {
#                     # Handle any other exceptions that may occur
#                     Write-Host "An error occurred: $_"
#                 }
#             }
#         }
#     }

# cd ..

# # ------------------------------deployed proxies latest revision-------------------------------------------------------
# https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/deployments
# $proxypathenv = "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/deployments"
# Invoke-RestMethod -Uri $proxypathenv -Method Get -Headers $headers -ContentType "application/json" -ErrorAction Stop -TimeoutSec 60 -OutFile "$env-proxies.json"

# # Load the JSON data from the file
# $jsonData = Get-Content -Path "$env-proxies.json" | ConvertFrom-Json

# # Extract the apiproxy and revision values
# $deployments = $jsonData.deployments
# foreach ($deployment in $deployments) {
#     $apiproxy = $deployment.apiProxy
#     $revision = $deployment.revision
#     if(!(test-path -PathType container $($proxy.name))){
#         mkdir -p "$apiproxy"
#         cd $apiproxy
#     }
#     else {
#         cd $apiproxy
#     }

#     if(!(test-path -PathType container $latestRevision)){
#         mkdir -p "$latestRevision"
#         cd $latestRevision
#     }
#     else {
#         cd $latestRevision
#     }

#     # Output the extracted values
#     Write-Host "API Proxy: $apiproxy, Revision: $revision"
#     $path2 = $baseURL+$org+"/environments/"+$($env)+"/apis/"+$apiproxy+"/revisions/"+$revision+"/deployments"
#     Write-Host $path2
#     Invoke-RestMethod -Uri $path2 -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$env-proxy-$($proxy.name).json"
#     Write-Host "Done..."
# }

# ---------------------------------------------KVM DETAILS------------------------------------------------------------

# # Set your organization, environment, and KVM name
# $orgName = "esi-apigee-x-394004"
# $envName = "eval"
# $kvmName = "postman-KVM"  # Replace with your KVM name


# # Create headers with the Authorization token
# $headers = @{
#     Authorization = "Bearer $token"
# }

# # Construct the URL
# $url = "https://apigee.googleapis.com/v1/organizations/$orgName/environments/$envName/keyvaluemaps/$kvmName"

# # Make the API request to get KVM details
# $response = Invoke-RestMethod -Uri $url -Method 'GET' -Headers $headers

# # Output the response (which includes KVM details and entries)
# $response | ConvertTo-Json


