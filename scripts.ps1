# write-output Apigee Artifacts
$token = $env:TOKEN
$org = $env:ORG
$git_token = $env:GIT_TOKEN

$baseURL = "https://apigee.googleapis.com/v1/organizations/"
$headers = @{Authorization = "Bearer $token"}

# # Set your GitHub repository information
# $repositoryOwner = "rajeshjanapati@gmail.com"
# $repositoryName = "github-proxies-X"
# $branchName = "main"  # Change this to the branch you want to access
# $githubToken = $git_token

# # ------------------------------------Proxies------------------------------------------

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
    # Write-Host "KVM Name: $kvmName"

    $body1 =@{
        "name"=$kvmName;
        "encrypted"=true;
        }
    Write-Host $body1
    $kvmcreate = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps' -Method 'POST' -Headers $headers -Body ($body1|ConvertTo-Json)
    $kvmcreate | ConvertTo-Json
    }

    

#     $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
#     $headers.Add("Authorization", "Bearer $token")
#     $headers.Add("Content-Type", "application/json")


#     $kvmget = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps' -Method 'GET' -Headers $headers
#     $kvmget | ConvertTo-Json
#     # Write-Host $kvmget

#     $url = "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps/$kvmName/entries"

#     $kvmgetentries = Invoke-RestMethod -Uri $url -Method 'GET' -Headers $headers
#     $kvmgetentriesvalues = $kvmgetentries | ConvertTo-Json
#     # Write-Host $kvmgetentriesvalues
    
    
#     # # Output the KVM entries for debugging
#     $kvmgetentriesvalues | Format-Table

#     # Your array
#     $array = $kvmget
    
#     foreach ($valueToCheck in $array) {
#         if ($array -contains $valueToCheck) {
#             Write-Host "$valueToCheck is present in the array."
#             $entries = $jsonData.entry
#             Write-Host "Values: $vlaues"
        
#             foreach ($entry in $entries) {
#                 Write-Host "step-2"
#                 $name = $entry.key
#                 $value = $entry.value
#                 Write-Host "Key: $name, Value: $value"
#                 $body2 = @{
#                     "name" = $name;
#                     "value" = $value;
#                 }
#                 Write-Host "body2: $body2"
                
#                 try {
                    
#                     # Make the API request
#                     $response = Invoke-RestMethod -Uri "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps/$kvmName/entries" -Method 'POST' -Headers $headers -Body ($body2 | ConvertTo-Json)
                
#                     # Get and print the status code
#                     $statuscode = $response.StatusCode
#                     Write-Host "Status Code: $statuscode"
#                 } catch [System.Net.HttpStatusCode] {
#                     # Handle the specific error (HTTP status code 409) gracefully
#                     Write-Host "Conflict (409) error occurred, but the script will continue."
#                 } catch {
#                     # Handle any other exceptions that may occur
#                     Write-Host "An error occurred: $_"
#                 }

#             }
#         } else {
#             $body1 =@{
#                 "name"=$kvmName;
#                 "encrypted"=true;
#                 }
#             Write-Host $body1
#             Write-Host "$valueToCheck is not present in the array."
#             $kvmcreate = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/environments/eval/keyvaluemaps' -Method 'POST' -Headers $headers -Body ($body1|ConvertTo-Json)
#             $kvmcreate | ConvertTo-Json
#         }
#     }
# }
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
#     # Write-Host ($apiproductget | ConvertTo-Json)

#     # Your array
#     $array = $apiproductget
    
#     $apiproducts = $apiproductget.apiProduct  # Access the correct property

#     foreach ($apiproduct in $($apiproducts)) {
#         Write-Host "entered into foreach..."
#         if ($apiproduct.name -eq $apiproductname) {
#         }
#         else{
#             try {
#                 $response = Invoke-RestMethod 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/apiproducts' -Method 'POST' -Headers $headers -Body ($jsonData | ConvertTo-Json)
#                 $response | ConvertTo-Json

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

# # # --------------------------------- Developers ----------------------------------------------------

# cd developers

# # Read JSON files
# $jsonFiles = Get-ChildItem -Filter *.json -Recurse

# # Loop through each JSON file and make POST requests
# foreach ($jsonFile in $jsonFiles) {
#     $jsonContent = Get-Content -Path $jsonFile -Raw
#     # Parse the JSON content
#     $jsonData = ConvertFrom-Json $jsonContent
#     # Write-Host ($jsonData | ConvertTo-Json)

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

# # ---------------------------------------Apps-----------------------------------------------

# cd apps

# # Read JSON files
# $jsonFiles = Get-ChildItem -Filter *.json -Recurse

# # Loop through each JSON file and make POST requests
# foreach ($jsonFile in $jsonFiles) {
#     Write-Host "Entered into FOREACH..."
#     $jsonContent = Get-Content -Path $jsonFile -Raw
#     # Parse the JSON content
#     $jsonData = ConvertFrom-Json $jsonContent

#     # Extract the value of the "appId" key from the JSON data
#     $appId = $jsonData.appId

#     Write-Host $appId

#     $headers = @{
#         "Authorization" = "Bearer $token"
#         "Content-Type" = "application/json"
#     }

#     # Make a GET request to check if the app already exists
#     $appList = Invoke-RestMethod "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/apps" -Headers $headers


#     # Check if the "appId" already exists in the list of apps
#     $appExists = $appList | Where-Object { $_.appId -eq $appId }

#     if ($appExists) {
#         Write-Host "$appId is already present in the API products."
#         # Perform actions when the app already exists
#     } else {
#         try {
#             # Make a POST request to create a new app
#             $response = Invoke-RestMethod "https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/developers/test.developer@gmail.com/apps" -Method 'POST' -Headers $headers -Body $jsonContent
#             $response | ConvertTo-Json
#             Write-Host "Done..."
#             # Get and print the status code
#             $statusCode = $response.StatusCode
#             Write-Host "Status Code: $statusCode"
#         } catch {
#             # Handle any exceptions that may occur
#             Write-Host "An error occurred: $_"
#         }
#     }
# }

# cd ..


# # ---------------------------------------APP KEYS-----------------------------------------------

# cd keys

# # Define the Apigee X API endpoint for creating keys
# $apiEndpoint = 'https://apigee.googleapis.com/v1/organizations/esi-apigee-x-394004/developers/test.developer@gmail.com/apps/developer-test-app/keys'

# # Read JSON files
# $jsonFiles = Get-ChildItem -Filter *.json -Recurse

# # Loop through each JSON file and make POST requests
# foreach ($jsonFile in $jsonFiles) {
#     Write-Host "Entered into FOREACH..."
#     $jsonContent = Get-Content -Path $jsonFile -Raw
#     # Parse the JSON content
#     $jsonData = ConvertFrom-Json $jsonContent

#     try {
#         # Make a POST request to create keys for the app
#         $response = Invoke-RestMethod -Uri $apiEndpoint -Method 'POST' -Headers $headers -Body ($jsonData | ConvertTo-Json)
        
#         # Print the response (including the newly created keys)
#         Write-Host "Keys Created:"
#         Write-Host ($response | ConvertTo-Json)
#     } catch {
#         # Handle any exceptions that may occur
#         Write-Host "An error occurred: $_"
#     }
# }
# cd ..

# ----------------------------------------------------------------------------------------------
