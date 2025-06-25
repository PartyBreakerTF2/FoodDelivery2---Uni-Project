# SQL Server Service and Configuration Checker
# Run this in PowerShell as Administrator

Write-Host "=== SQL Server Service and Configuration Checker ===" -ForegroundColor Green
Write-Host ""

# Check SQL Server Services
Write-Host "1. Checking SQL Server Services:" -ForegroundColor Yellow
try {
    $sqlServices = Get-Service | Where-Object { $_.Name -like "*SQL*" }
    if ($sqlServices) {
        foreach ($service in $sqlServices) {
            $status = if ($service.Status -eq "Running") { "✓" } else { "✗" }
            Write-Host "   $status $($service.Name): $($service.Status)" -ForegroundColor $(if ($service.Status -eq "Running") { "Green" } else { "Red" })
        }
    } else {
        Write-Host "   ✗ No SQL Server services found" -ForegroundColor Red
    }
} catch {
    Write-Host "   ✗ Error checking services: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Check SQL Server instances
Write-Host "2. Checking SQL Server Instances:" -ForegroundColor Yellow
try {
    # Try to get SQL Server instances from registry
    $instances = @()
    
    # Check for default instance
    if (Get-Service -Name "MSSQLSERVER" -ErrorAction SilentlyContinue) {
        $instances += "Default Instance (MSSQLSERVER)"
    }
    
    # Check for named instances
    $namedInstances = Get-Service | Where-Object { $_.Name -like "MSSQL`$*" }
    foreach ($instance in $namedInstances) {
        $instanceName = $instance.Name -replace "MSSQL\$", ""
        $instances += "Named Instance: $instanceName"
    }
    
    if ($instances.Count -gt 0) {
        foreach ($instance in $instances) {
            Write-Host "   ✓ $instance" -ForegroundColor Green
        }
    } else {
        Write-Host "   ✗ No SQL Server instances found" -ForegroundColor Red
    }
} catch {
    Write-Host "   ✗ Error checking instances: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Check TCP/IP connectivity
Write-Host "3. Checking TCP/IP Connectivity:" -ForegroundColor Yellow
$ports = @(1433, 1434)
foreach ($port in $ports) {
    try {
        $result = Test-NetConnection -ComputerName "localhost" -Port $port -WarningAction SilentlyContinue
        if ($result.TcpTestSucceeded) {
            Write-Host "   ✓ Port $port is open" -ForegroundColor Green
        } else {
            Write-Host "   ✗ Port $port is closed" -ForegroundColor Red
        }
    } catch {
        Write-Host "   ✗ Error testing port $port" -ForegroundColor Red
    }
}

Write-Host ""

# Check SQL Server Browser service (for named instances)
Write-Host "4. Checking SQL Server Browser Service:" -ForegroundColor Yellow
try {
    $browserService = Get-Service -Name "SQLBrowser" -ErrorAction SilentlyContinue
    if ($browserService) {
        $status = if ($browserService.Status -eq "Running") { "✓" } else { "✗" }
        Write-Host "   $status SQL Server Browser: $($browserService.Status)" -ForegroundColor $(if ($browserService.Status -eq "Running") { "Green" } else { "Red" })
        
        if ($browserService.Status -ne "Running") {
            Write-Host "   Note: SQL Server Browser is needed for named instances (like SQLEXPRESS)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ✗ SQL Server Browser service not found" -ForegroundColor Red
    }
} catch {
    Write-Host "   ✗ Error checking SQL Server Browser: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Check Windows Authentication
Write-Host "5. Checking Current User:" -ForegroundColor Yellow
try {
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    Write-Host "   Current User: $($currentUser.Name)" -ForegroundColor Green
    Write-Host "   Authentication Type: $($currentUser.AuthenticationType)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Error getting current user: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Provide recommendations
Write-Host "=== Recommendations ===" -ForegroundColor Green
Write-Host ""
Write-Host "If SQL Server services are not running:" -ForegroundColor Yellow
Write-Host "1. Start SQL Server service:"
Write-Host "   Start-Service -Name 'MSSQL`$SQLEXPRESS'"
Write-Host "2. Start SQL Server Browser (for named instances):"
Write-Host "   Start-Service -Name 'SQLBrowser'"
Write-Host ""
Write-Host "If services are running but connection fails:" -ForegroundColor Yellow
Write-Host "1. Check SQL Server Configuration Manager"
Write-Host "2. Enable TCP/IP protocol"
Write-Host "3. Set TCP port to 1433 or use dynamic port"
Write-Host "4. Restart SQL Server service after changes"
Write-Host ""
Write-Host "To test connection manually:" -ForegroundColor Yellow
Write-Host "1. Open SQL Server Management Studio (SSMS)"
Write-Host "2. Connect to: localhost\SQLEXPRESS"
Write-Host "3. Use Windows Authentication"
Write-Host "4. Check if FoodDeliveryDB database exists"

Write-Host ""
Write-Host "=== End of Check ===" -ForegroundColor Green
