Param(
  [string]$url,
  [string]$ip
)
Begin{}
Process 
    {
$ErrorActionPreference = "SilentlyContinue"

if($url){

$Target= @()

foreach($line in Get-Content .\list.txt) {
   $new_url = ($url + $line)

   $HTTP_Request = [System.Net.WebRequest]::Create($new_url)

   $HTTP_Response = $HTTP_Request.GetResponse()


   $HTTP_Status = [int]$HTTP_Response.StatusCode

   If ($HTTP_Status -eq 200) { 
    $Target += $new_url

   }

}
Write-Host "Listing below are paths of the website:"
Write-Host $Target
}


if($ip){
     $result = $null

     $currentEAP = $ErrorActionPreference

     $ErrorActionPreference = "silentlycontinue"

     $result = [System.Net.Dns]::gethostentry($ip)

     $ErrorActionPreference = $currentEAP

     If ($Result)

     {

          Write-Host $Result.HostName

     }

     Else

     {

          Write-Host "$IP – No HostNameFound"

     }
 }

}
