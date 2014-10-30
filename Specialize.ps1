$ErrorActionPreference = "Stop"

try
{
    $temp = "$ENV:SystemRoot\Temp"
    $baseUrl = "https://raw.github.com/anchor/windows-openstack-imaging-tools/Anchor"

    # Put the wallpaper in place
    $wallpaper_dir = "$ENV:SystemRoot\web\Wallpaper\Cloudbase"
    if (!(Test-Path $wallpaper_dir))
    {
        mkdir $wallpaper_dir
    }

    $Host.UI.RawUI.WindowTitle = "Downloading wallpaper..."
    $wallpaper = "Wallpaper-Cloudbase-2013.png"
    (new-object System.Net.WebClient).DownloadFile("$baseUrl/$wallpaper", "$wallpaper_dir\$wallpaper")

    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value "$wallpaper_dir\$wallpaper"
    rundll32.exe user32.dll, UpdatePerUserSystemParameters

    # Put the Anchor bmp in place
    $bmp_dir = "$ENV:SystemRoot\OEM"
    if (!(Test-Path $bmp_dir))
    {
        mkdir $bmp_dir
    }

    $Host.UI.RawUI.WindowTitle = "Downloading bmp..."
    $bmp = "logo.bmp"
    (new-object System.Net.WebClient).DownloadFile("$baseUrl/$bmp", "$bmp_dir\$bmp")

    # Enable ping (ICMP Echo Request on IPv4 and IPv6)
    # TODO: replace with with a netsh advfirewall command
    # possibly avoiding duplicates with "File and printer sharing (Echo Request - ICMPv[4,6]-In)"
    netsh firewall set icmpsetting 8

    $Host.UI.RawUI.WindowTitle = "Downloading FirstLogon script..."
    #Make sure that in case of exception the FirstLogon script will not be executed.
    #Being the last instruction this is already ok
    (new-object System.Net.WebClient).DownloadFile("$baseUrl/FirstLogon.ps1", "$temp\FirstLogon.ps1")
}
catch
{
    $host.ui.WriteErrorLine($_.Exception.ToString())
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    throw
}
