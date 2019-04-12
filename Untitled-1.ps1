LinuxInfo = Get-Content /etc/os-release -Raw | ConvertFrom-StringData
 
$environment += @{'LinuxInfo' = $LinuxInfo}
$environment += @{'IsUbuntu' = $LinuxInfo.ID -match 'ubuntu'}
$environment += @{'IsUbuntu14' = $Environment.IsUbuntu -and $LinuxInfo.VERSION_ID -match '14.04'}
$environment += @{'IsUbuntu16' = $Environment.IsUbuntu -and $LinuxInfo.VERSION_ID -match '16.04'}
$environment += @{'IsCentOS' = $LinuxInfo.ID -match 'centos' -and $LinuxInfo.VERSION_ID -match '7'}
$environment += @{'IsFedora' = $LinuxInfo.ID -match 'fedora' -and $LinuxInfo.VERSION_ID -ge 24}
$environment += @{'IsOpenSUSE' = $LinuxInfo.ID -match 'opensuse'}
$environment += @{'IsOpenSUSE13' = $Environment.IsOpenSUSE -and $LinuxInfo.VERSION_ID  -match '13'}
$environment += @{'IsOpenSUSE42.1' = $Environment.IsOpenSUSE -and $LinuxInfo.VERSION_ID  -match '42.1'}
$environment += @{'IsRedHatFamily' = $Environment.IsCentOS -or $Environment.IsFedora -or $Environment.IsOpenSUSE}