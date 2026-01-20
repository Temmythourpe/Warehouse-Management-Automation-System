# Setup Guide - WMS Demo Project

Complete installation and configuration guide for the Warehouse Management System demonstration.

---

## Prerequisites

Before starting, ensure you have:

- ✅ **n8n** installed (local or cloud account)
  - Local: Docker or npm installation
  - Cloud: Free account at https://n8n.io
- ✅ **Google Account** for Sheets integration
- ✅ **PowerShell** (Windows) or **Terminal** (Mac/Linux)
- ✅ **Git** (for cloning repository)

---

## Installation Steps

### **Step 1: Clone the Repository**
```bash
git clone https://github.com/YOUR_USERNAME/warehouse-management-system-demo.git
cd warehouse-management-system-demo
```

---

### **Step 2: Set Up Google Sheets**

#### **2.1 Create Google Sheet**

1. Go to [Google Sheets](https://sheets.google.com)
2. Create a new spreadsheet named: **"WMS Demo - Warehouse Inventory"**
3. Create **3 sheets** (tabs):
   - **Inventory**
   - **Transaction_Log**
   - **Alerts**

#### **2.2 Set Up Inventory Sheet**

**In the "Inventory" tab:**

1. Add headers in Row 1:
```
   Product_ID | Product_Name | Location | Quantity | Min_Stock | Category | Last_Updated
```

2. Import sample data from `templates/inventory-template.csv`:
   - Click **File** → **Import** → **Upload**
   - Select `inventory-template.csv`
   - Import location: **Replace current sheet**
   - Click **Import data**

**Or manually add sample data:**
```
SKU001 | Laptop Dell XPS      | A1-01 | 50  | 10 | Electronics  | 2025-01-17
SKU002 | USB-C Cable          | B2-05 | 200 | 50 | Accessories  | 2025-01-17
SKU003 | Mouse Wireless       | A1-03 | 75  | 20 | Accessories  | 2025-01-17
SKU004 | Keyboard Mechanical  | A1-02 | 30  | 15 | Accessories  | 2025-01-17
```

#### **2.3 Set Up Transaction_Log Sheet**

Add headers in Row 1:
```
Timestamp | User | Action | Product_ID | Quantity_Changed | From_Location | To_Location | New_Stock_Level | Notes
```

#### **2.4 Set Up Alerts Sheet**

Add headers in Row 1:
```
Timestamp | Alert_Type | Product_ID | Product_Name | Current_Stock | Min_Stock | Message
```

#### **2.5 Get Sheet ID**

1. Copy the Sheet URL from your browser
2. Extract the Sheet ID from the URL:
```
   https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID_HERE/edit
                                          ^^^^^^^^^^^^^^^^
```
3. Save this ID - you'll need it later

---

### **Step 3: Set Up Google Cloud OAuth**

#### **3.1 Create Google Cloud Project**

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project: **"WMS n8n Integration"**
3. Enable **Google Sheets API**:
   - Go to **APIs & Services** → **Library**
   - Search for "Google Sheets API"
   - Click **Enable**

#### **3.2 Create OAuth Credentials**

1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **OAuth Client ID**
3. Configure consent screen if prompted:
   - User Type: **External**
   - App name: **WMS n8n**
   - Add your email as developer contact
4. Create OAuth Client:
   - Application type: **Desktop app**
   - Name: **n8n WMS**
5. Click **Create**
6. **Copy** Client ID and Client Secret

#### **3.3 Add Test User**

1. Go to **OAuth consent screen**
2. Scroll to **Test users**
3. Click **+ ADD USERS**
4. Add your email address
5. Click **Save**

---

### **Step 4: Import n8n Workflow**

#### **4.1 Start n8n**

**Local (Docker):**
```bash
docker run -it --rm --name n8n -p 5678:5678 -v ~/.n8n:/home/node/.n8n n8nio/n8n
```

**Local (npm):**
```bash
n8n start
```

**Cloud:**
- Go to https://app.n8n.cloud and log in

#### **4.2 Import Workflow**

1. Open n8n in browser: `http://localhost:5678`
2. Click **Workflows** → **Add workflow** → **Import from file**
3. Select `workflows/wms-stock-movement.json`
4. Workflow will load on the canvas

---

### **Step 5: Configure Credentials**

#### **5.1 Google Sheets Credential**

1. Click on any **Google Sheets** node in the workflow
2. Under **Credential**, click **Create New**
3. Enter your **Client ID** and **Client Secret** from Step 3
4. Click **Connect my account**
5. Sign in with Google and grant permissions
6. Save credential

#### **5.2 Update Google Sheet References**

For each Google Sheets node:
1. **Document**: Select your "WMS Demo - Warehouse Inventory" sheet
2. **Sheet**: Select the appropriate tab (Inventory, Transaction_Log, or Alerts)
3. **Data Location on Sheet**: Set Header Row = 1

**Nodes to update:**
- Get Current Inventory → Sheet: **Inventory**
- Update Inventory Stock → Sheet: **Inventory**
- Log Transaction → Sheet: **Transaction_Log**
- Log Low Stock Alert → Sheet: **Alerts**

---

### **Step 6: Activate Workflow**

1. Click **Save** (top right)
2. Click **Publish** to activate
3. Toggle should show **Active**

#### **Get Webhook URL**

1. Click on the **Webhook** node
2. Copy the **Production URL**:
```
   http://localhost:5678/webhook/warehouse-stock
```
3. Save this URL for testing

---

### **Step 7: Configure Environment (Optional)**

1. Copy `.env.example` to `.env`:
```bash
   cp .env.example .env
```

2. Edit `.env` with your values:
```
   GOOGLE_SHEET_ID=your_actual_sheet_id
   WEBHOOK_URL=http://localhost:5678/webhook/warehouse-stock
```

**Note:** The `.env` file is in `.gitignore` and won't be committed to Git.

---

## Testing the Workflow

### **Option 1: Automated Test Script (Recommended)**

**Windows PowerShell:**
```powershell
cd scripts
.\test-wms.ps1
```

This script runs 4 test scenarios:
1. ✅ Receive stock (SKU001) - No alert
2. ✅ Pick stock (SKU002) - No alert
3. ⚠️ Pick stock (SKU003) - Triggers low stock alert
4. ⚠️ Pick stock (SKU004) - Triggers low stock alert

**Expected Results:**
- **Inventory sheet**: Updated quantities
- **Transaction_Log sheet**: 4 new rows
- **Alerts sheet**: 2 low stock warnings

---

### **Option 2: Manual Testing**

**Test 1: Stock Receipt**
```powershell
Invoke-WebRequest -Uri "YOUR_WEBHOOK_URL" -Method POST -ContentType "application/json" -Body '{
  "action": "receive",
  "product_id": "SKU001",
  "quantity": 25,
  "user": "manager@company.com",
  "notes": "New shipment from supplier"
}'
```

**Expected:**
- SKU001 quantity increases by 25
- Transaction logged
- No alert (stock above minimum)

---

**Test 2: Stock Pick (Normal)**
```powershell
Invoke-WebRequest -Uri "YOUR_WEBHOOK_URL" -Method POST -ContentType "application/json" -Body '{
  "action": "pick",
  "product_id": "SKU002",
  "quantity": 30,
  "user": "picker@company.com",
  "notes": "Order #12345"
}'
```

**Expected:**
- SKU002 quantity decreases by 30
- Transaction logged
- No alert (stock still above minimum)

---

**Test 3: Stock Pick (Low Stock Alert)**
```powershell
Invoke-WebRequest -Uri "YOUR_WEBHOOK_URL" -Method POST -ContentType "application/json" -Body '{
  "action": "pick",
  "product_id": "SKU003",
  "quantity": 60,
  "user": "picker@company.com",
  "notes": "Large order"
}'
```

**Expected:**
- SKU003 quantity decreases by 60 (75 → 15)
- Transaction logged
- ⚠️ **Alert triggered** (15 < min of 20)

---

**Test 4: Invalid Transaction (Insufficient Stock)**
```powershell
Invoke-WebRequest -Uri "YOUR_WEBHOOK_URL" -Method POST -ContentType "application/json" -Body '{
  "action": "pick",
  "product_id": "SKU004",
  "quantity": 100,
  "user": "picker@company.com",
  "notes": "Test overselling protection"
}'
```

**Expected:**
- ❌ Transaction **rejected**
- Error: "Insufficient stock"
- No changes to inventory

---

## Monitoring & Validation

### **Check Workflow Executions**

1. In n8n, go to **Executions** tab
2. Click on any execution to see:
   - Which nodes executed
   - Data flow between nodes
   - Any errors or warnings

### **Verify Google Sheets**

**Inventory Sheet:**
- Stock quantities updated correctly
- Last_Updated timestamps are current

**Transaction_Log Sheet:**
- One row per transaction
- All fields populated (user, action, quantities, notes)

**Alerts Sheet:**
- Alerts only for products below minimum stock
- Clear messages with reorder recommendations

---

## Troubleshooting

### **Issue: Webhook returns 404**
**Solution:**
- Ensure workflow is **Published/Active**
- Use **production** URL (not test URL)
- Check webhook path matches exactly

### **Issue: Google Sheets not updating**
**Solution:**
- Verify Google Sheets credential is connected
- Check "Data Location on Sheet" → Header Row = 1
- Ensure sheet names match exactly (case-sensitive)
- Check column mappings use correct field names

### **Issue: Credentials expired**
**Solution:**
- Re-authenticate Google Sheets credential
- Check test user is added in Google Cloud Console

### **Issue: All products trigger alerts**
**Solution:**
- Check IF node condition: `{{$json.alert_needed}} equals true`
- Verify "Convert types" toggle is ON
- Check connections: IF node should connect from "Find Product & Calculate New Stock"

### **Issue: Duplicate alerts**
**Solution:**
- Check workflow connections
- "Log Low Stock Alert" should ONLY connect from IF TRUE output
- "Log Transaction" should connect from "Find Product & Calculate New Stock" directly

---

## Security Best Practices

1. **Never commit credentials**:
   - `.gitignore` includes `.env` and credential files
   - Clean workflow JSON before sharing

2. **Restrict Google Sheet access**:
   - Set sheet to "Restricted" (only you can access)
   - Share only with specific users if needed

3. **Webhook security** (Production):
   - Add authentication header
   - Use HTTPS in production
   - Implement rate limiting

4. **API key rotation**:
   - Rotate Google OAuth credentials periodically
   - Revoke unused credentials

---

## Next Steps

1. Complete setup and testing
2. Take screenshots for documentation
3. Deploy to production (optional):
   - Use n8n cloud for always-on availability
   - Configure email notifications
   - Add ServiceNow integration
4. Extend functionality:
   - Add more warehouse locations
   - Implement barcode scanning
   - Build analytics dashboard

---

## Tips for Interview Presentation

**When demonstrating this project:**

1. **Show the workflow visually** in n8n
2. **Live demo** a stock transaction using PowerShell
3. **Navigate to Google Sheets** to show real-time updates
4. **Explain the business logic**: "This prevents overselling by validating stock before confirming picks"
5. **Discuss real-world applications**: "In a production WMS like SAP, this same logic runs when warehouse staff scan barcodes"

---

## Support

If you encounter issues:
1. Check the [Troubleshooting](#-troubleshooting) section
2. Review n8n execution logs for errors
3. Open an issue on GitHub

---

## Additional Resources

- [n8n Documentation](https://docs.n8n.io)
- [Google Sheets API](https://developers.google.com/sheets/api)
- [WMS Concepts](https://www.techtarget.com/searcherp/definition/warehouse-management-system-WMS)

---

<p align="center">
  <strong>Setup complete! Your WMS demo is ready to use.</strong> 🎉
</p>