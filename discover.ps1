param( 
        #[parameter(Mandatory=$true)] 
            
        [System.Net.IPAddress]$StartScanIP, 
        [System.Net.IPAddress]$EndScanIP, 
        [Int[]]$Ports   
    ) 

    Begin{} 

    Process 
    {
   if($StartScanIP -ne $null){
        $ScanIPRange = @() 
            if($EndScanIP -ne $null) 
            { 

                $StartIP = $StartScanIP -split '\.' 
              
                  [Array]::Reverse($StartIP)   
                  $StartIP = ([System.Net.IPAddress]($StartIP -join '.')).Address  
              
                $EndIP = $EndScanIP -split '\.' 
                  [Array]::Reverse($EndIP)   
                  $EndIP = ([System.Net.IPAddress]($EndIP -join '.')).Address  
         
                For ($x=$StartIP; $x -le $EndIP; $x++) {     
                    $IP = [System.Net.IPAddress]$x -split '\.'          
                    [Array]::Reverse($IP)    
                    $ScanIPRange += $IP -join '.'  
                } 
                 
            } 
            else 
            { 
                $ScanIPRange = $StartScanIP 
                Write-Host $ScanIPRange
            }  
     
            Write-Verbose "Start scaning..." 
          
            Foreach($IP in $ScanIPRange) 
            {
           
                #HOSTNAME
                if(Test-Connection -ComputerName $IP -Quiet) 
                    {
                        Try 
                            { 
                                $HostName = [System.Net.Dns]::GetHostbyAddress($IP).HostName 
                            } 
                        Catch 
                            { 
                                $HostName = $null 
                            } 
                  
                        
                        #MAC
                         Try 
                            { 
                                $result= nbtstat -A $IP | select-string "MAC" 
                                $MAC = [string]([Regex]::Matches($result, "([0-9A-F][0-9A-F]-){5}([0-9A-F][0-9A-F])")) 
                            } 
                         Catch 
                            { 
                                $MAC = $null 
                  
                            }
                        #port
                        $PortsStatus = @() 
                        ForEach($Port in $Ports) 
                        { 
                            Try 
                            {                             
                                $TCPClient = new-object Net.Sockets.TcpClient 
                                $TCPClient.Connect($IP, $Port) 
                                $TCPClient.Close() 

                              $PortStatus = New-Object PSObject -Property @{             
                                    Port        = $Port 
                                } 
                                $PortsStatus += $PortStatus
                               
                                
                            }     
                            Catch 
                            { 
                                 
                                $PortsStatus=$null 
                         }   
                        }
                        #OS
                        if($HostName) 
                        { 
                            $Result = Invoke-Command -ComputerName $HostName -ScriptBlock {systeminfo} -ErrorAction SilentlyContinue  
                        } 
                        else 
                        { 
                            $Result = Invoke-Command -ComputerName $IP -ScriptBlock {systeminfo} -ErrorAction SilentlyContinue  
                        } 
                         
                        if($Result -ne $null) 
                        { 
                            if($OS_Name -eq $null) 
                            { 
                                $OS_Name = ($Result[2..3] -split ":\s+")[1] 
                                $OS_Ver = ($Result[2..3] -split ":\s+")[3] 
                            }     
                            $WinRMAccess = $true 
                        } 
                        else 
                        { 
                            $WinRMAccess = $false 
                        } 
                        
                    } 
         
            Write-Host $IP  $HostName  $MAC $PortsStatus $OS_Name $OS_Ver
          
            }
        
        
        }


    }
   
