# PowerShell script to disable HID-compliant touch screen
# This script specifically targets the ELAN touchscreen device
# Requires Administrator privileges

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires Administrator privileges!" -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host "Searching for HID-compliant touch screen devices..." -ForegroundColor Cyan

# Get the specific touchscreen device
$touchscreenDevice = Get-PnpDevice -Class "HIDClass" | Where-Object {
    $_.FriendlyName -eq "HID-compliant touch screen"
}

if ($touchscreenDevice) {
    Write-Host "Found touchscreen device:" -ForegroundColor Green
    Write-Host "  Name: $($touchscreenDevice.FriendlyName)" -ForegroundColor White
    Write-Host "  Instance ID: $($touchscreenDevice.InstanceId)" -ForegroundColor White
    Write-Host "  Current Status: $($touchscreenDevice.Status)" -ForegroundColor White
    
    if ($touchscreenDevice.Status -eq "OK") {
        Write-Host "`nDisabling touchscreen device..." -ForegroundColor Yellow
        
        try {
            # Disable the device
            Disable-PnpDevice -InstanceId $touchscreenDevice.InstanceId -Confirm:$false
            Write-Host "Touchscreen has been successfully disabled!" -ForegroundColor Green
            
            # Verify the change
            $updatedDevice = Get-PnpDevice -InstanceId $touchscreenDevice.InstanceId
            Write-Host "New status: $($updatedDevice.Status)" -ForegroundColor Cyan
            
        } catch {
            Write-Host "Error disabling touchscreen: $($_.Exception.Message)" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Touchscreen is already disabled (Status: $($touchscreenDevice.Status))" -ForegroundColor Yellow
    }
} else {
    Write-Host "HID-compliant touch screen device not found!" -ForegroundColor Red
    Write-Host "Available HID devices:" -ForegroundColor Yellow
    Get-PnpDevice -Class "HIDClass" | Where-Object {$_.FriendlyName -like "*touch*"} | 
        Format-Table FriendlyName, Status, InstanceId -AutoSize
}

Write-Host "`nScript completed. Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
