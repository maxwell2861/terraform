<powershell>
Start-Transcript c:\Windows\temp\terraform_setting.txt

#------------------------------------------------------------------------
# 1. Define Variable
#------------------------------------------------------------------------
$SERVERNAME = "${server_name}"

#------------------------------------------------------------------------
# 2. Chef Setting [Add Node Name]
#------------------------------------------------------------------------

Add-Content -Path C:\chef\client.rb. -Value  `r`n"node_name '$SERVERNAME'"

#------------------------------------------------------------------------
# 3. Use Chef [Join Chef]
#------------------------------------------------------------------------

# Join Chef Node
chef-client -r test

# Timezone (UTC)
    #kst 일 경우 timezone::kst
chef-client -o timezone::utc

#------------------------------------------------------------------------
# 4. Rename Computer
#------------------------------------------------------------------------
Stop-Transcript
Rename-computer -NewName $SERVERNAME -Restart
</powershell>



