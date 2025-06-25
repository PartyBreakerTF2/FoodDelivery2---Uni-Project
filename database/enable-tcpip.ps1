# PowerShell script to enable SQL Server TCP/IP protocol
# Run this as Administrator

Write-Host "SQL Server TCP/IP Configuration Script" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "❌ This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please restart PowerShell as Administrator and run this script again." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Running as Administrator" -ForegroundColor Green

# Import SQL Server module if available
try {
    Import-Module SqlServer -ErrorAction SilentlyContinue
    Write-Host "✅ SQL Server PowerShell module loaded" -ForegroundColor Green
} catch {
    Write-Host "⚠️ SQL Server PowerShell module not available" -ForegroundColor Yellow
    Write-Host "   Will use registry method instead" -ForegroundColor White
}

# Method 1: Try using SQL Server PowerShell cmdlets
Write-Host "`nAttempting to enable TCP/IP using SQL Server cmdlets..." -ForegroundColor Cyan

try {
    # Get the server instance
    $serverInstance = "MSSQLSERVER"
    
    # Enable TCP/IP protocol
    $tcp = Get-WmiObject -Namespace "root\Microsoft\SqlServer\ComputerManagement*" -Class ServerNetworkProtocol | Where-Object {$_.InstanceName -eq $serverInstance -and $_.ProtocolName -eq "Tcp"}
    
    if ($tcp) {
        $tcp.SetEnable()
        Write-Host "✅ TCP/IP protocol enabled successfully" -ForegroundColor Green
        
        # Set port 1433
        $tcpIP = Get-WmiObject -Namespace "root\Microsoft\SqlServer\ComputerManagement*" -Class ServerNetworkProtocolProperty | Where-Object {$_.InstanceName -eq $serverInstance -and $_.ProtocolName -eq "Tcp" -and $_.PropertyName -eq "TcpPort"}
        
        if ($tcpIP) {
            $tcpIP.SetStringValue("1433")
            Write-Host "✅ TCP port set to 1433" -ForegroundColor Green
        }
        
        $methodWorked = $true
    } else {
        Write-Host "❌ Could not find TCP/IP protocol settings" -ForegroundColor Red
        $methodWorked = $false
    }
} catch {
    Write-Host "❌ SQL Server cmdlets method failed: $($_.Exception.Message)" -ForegroundColor Red
    $methodWorked = $false
}

# Method 2: Manual registry approach (fallback)
if (-not $methodWorked) {
    Write-Host "`nFallback: Manual configuration required" -ForegroundColor Yellow
    Write-Host "Please follow these manual steps:" -ForegroundColor White
    Write-Host ""
    Write-Host "1. Open SQL Server Configuration Manager:" -ForegroundColor Cyan
    Write-Host "   - Press Win+R, type: SQLServerManager15.msc" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Enable TCP/IP:" -ForegroundColor Cyan
    Write-Host "   - Expand 'SQL Server Network Configuration'" -ForegroundColor White
    Write-Host "   - Click 'Protocols for MSSQLSERVER'" -ForegroundColor White
    Write-Host "   - Right-click 'TCP/IP' → Properties" -ForegroundColor White
    Write-Host "   - Set 'Enabled' to 'Yes'" -ForegroundColor White
    Write-Host "   - In 'IP Addresses' tab, set 'TCP Port' to '1433'" -ForegroundColor White
    Write-Host "   - Click OK" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Restart SQL Server:" -ForegroundColor Cyan
    Write-Host "   - Restart-Service MSSQLSERVER" -ForegroundColor White
}

# Restart SQL Server service
Write-Host "`nRestarting SQL Server service..." -ForegroundColor Cyan
try {
    Restart-Service MSSQLSERVER -Force
    Write-Host "✅ SQL Server service restarted successfully" -ForegroundColor Green
    
    # Wait a moment for service to fully start
    Start-Sleep -Seconds 5
    
    # Check if service is running
    $service = Get-Service MSSQLSERVER
    if ($service.Status -eq "Running") {
        Write-Host "✅ SQL Server is running" -ForegroundColor Green
    } else {
        Write-Host "❌ SQL Server failed to start" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Failed to restart SQL Server: $($_.Exception.Message)" -ForegroundColor Red
}

# Test if port 1433 is now listening
Write-Host "`nChecking if SQL Server is listening on port 1433..." -ForegroundColor Cyan
Start-Sleep -Seconds 3

$portTest = netstat -an | Select-String ":1433"
if ($portTest) {
    Write-Host "✅ SQL Server is listening on port 1433!" -ForegroundColor Green
    Write-Host $portTest -ForegroundColor White
} else {
    Write-Host "❌ SQL Server is not listening on port 1433" -ForegroundColor Red
    Write-Host "   Manual configuration may be required" -ForegroundColor Yellow
}

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "==========" -ForegroundColor Yellow
Write-Host "1. Run the database setup script in SQL Server Management Studio:" -ForegroundColor White
Write-Host "   database/setup-sql-auth.sql" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Test the connection:" -ForegroundColor White
Write-Host "   java -cp ""target/classes;target/test-classes;target/FoodDelivery2-V1/WEB-INF/lib/*"" com.uef.food.test.SQLServerAuthTest" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. If connection works, create the database schema:" -ForegroundColor White
Write-Host "   database/schema.sql" -ForegroundColor Cyan

Write-Host "`nPress Enter to continue..." -ForegroundColor Gray
Read-Host
