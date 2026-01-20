# WMS Workflow Test Script
$webhookUrl = "http://localhost:5678/webhook/warehouse-stock"

Write-Host "Testing WMS Workflow..." -ForegroundColor Cyan
Write-Host ""

# Test 1: Receive stock (should succeed, no alert)
Write-Host "Test 1: Receiving 30 units of SKU001..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $webhookUrl -Method POST -ContentType "application/json" -Body '{
  "action": "receive",
  "product_id": "SKU001",
  "quantity": 30,
  "user": "warehouse.manager@mylab.com",
  "notes": "New shipment arrived"
}'
Start-Sleep -Seconds 2

# Test 2: Pick stock (no alert yet)
Write-Host "Test 2: Picking 50 units of SKU002..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $webhookUrl -Method POST -ContentType "application/json" -Body '{
  "action": "pick",
  "product_id": "SKU002",
  "quantity": 50,
  "user": "picker.john@mylab.com",
  "notes": "Order #12345"
}'
Start-Sleep -Seconds 2

# Test 3: Pick to trigger LOW STOCK ALERT
Write-Host "Test 3: Picking 60 units of SKU003 (SHOULD TRIGGER ALERT)..." -ForegroundColor Red
Invoke-WebRequest -Uri $webhookUrl -Method POST -ContentType "application/json" -Body '{
  "action": "pick",
  "product_id": "SKU003",
  "quantity": 60,
  "user": "picker.sarah@mylab.com",
  "notes": "Large customer order"
}'
Start-Sleep -Seconds 2

# Test 4: Pick to trigger another LOW STOCK ALERT
Write-Host "Test 4: Picking 18 units of SKU004 (SHOULD TRIGGER ALERT)..." -ForegroundColor Red
Invoke-WebRequest -Uri $webhookUrl -Method POST -ContentType "application/json" -Body '{
  "action": "pick",
  "product_id": "SKU004",
  "quantity": 18,
  "user": "picker.mike@mylab.com",
  "notes": "Order #98765"
}'
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "All tests completed! Check your Google Sheets:" -ForegroundColor Green
Write-Host "  - Inventory: Updated stock levels"
Write-Host "  - Transaction_Log: 4 new entries"
Write-Host "  - Alerts: 2 low stock warnings (SKU003, SKU004)"