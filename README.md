# Warehouse Management System (WMS) Demo

![n8n](https://img.shields.io/badge/n8n-Workflow-EA4B71?logo=n8n)
![Google Sheets](https://img.shields.io/badge/Google-Sheets-34A853?logo=googlesheets)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?logo=powershell&logoColor=white)
![Status](https://img.shields.io/badge/status-demo-blue)

A warehouse inventory management system demonstration built with n8n workflow automation. This project simulates real WMS operations including stock movements, automated alerts, and comprehensive audit logging.

## Project Overview

This project demonstrates my understanding of:
- **Warehouse operations** (receive, pick, move, adjust inventory)
- **System integration** and workflow automation
- **Business process logic** (validation, alerts, audit trails)
- **IT support** for enterprise applications

Built to showcase skills relevant to **IT Support Technician** roles supporting WMS platforms like SAP EWM, Manhattan Associates, or Oracle WMS.

---

## Features

### 1. **Automated Stock Movement Processing**
- Webhook-based API receives stock transactions (receive, pick, move, adjust)
- Validates stock availability before processing picks
- Prevents overselling with negative inventory checks
- Supports multiple transaction types for different warehouse operations

### 2. **Real-Time Inventory Tracking**
- Live inventory database with product locations and quantities
- Automatic stock level updates after each transaction
- Timestamp tracking for audit compliance
- Multi-product and multi-location support

### 3. **Intelligent Low Stock Alerts**
- Automated monitoring of inventory against minimum thresholds
- Triggers alerts when stock falls below reorder points
- Logs all alerts with product details and recommendations
- Prevents stockouts through proactive notifications

### 4. **Comprehensive Transaction Logging**
- Complete audit trail of all stock movements
- Tracks user, timestamp, action type, quantities, and notes
- Enables root cause analysis for inventory discrepancies
- Compliance-ready transaction history

### 5. **User Access Tracking**
- Records which user performed each transaction
- Simulates role-based access control
- Validates required fields and action types

### 6. **System Integration Architecture**
- n8n workflow orchestration
- Google Sheets cloud integration
- REST API webhook interface
- Modular, scalable design

---

## Architecture

<img width="1249" height="902" alt="image" src="https://github.com/user-attachments/assets/b6b58531-7ca2-4231-b367-db1bbff318a3" />

### **Workflow Components:**

1. **Webhook Trigger**: REST API endpoint for stock transactions
2. **Processing Logic**: Validates data and calculates stock changes
3. **Inventory Lookup**: Retrieves current product data from Google Sheets
4. **Stock Calculation**: Computes new inventory levels with validation
5. **Inventory Update**: Updates stock quantities and timestamps
6. **Transaction Logger**: Records all movements for audit trail
7. **Alert System**: Monitors thresholds and logs low stock warnings

---

## Data Model

### **Inventory Sheet**
| Field | Description |
|-------|-------------|
| Product_ID | Unique SKU identifier |
| Product_Name | Product description |
| Location | Warehouse location code |
| Quantity | Current stock level |
| Min_Stock | Reorder threshold |
| Category | Product classification |
| Last_Updated | Last modification timestamp |

<img width="877" height="274" alt="image" src="https://github.com/user-attachments/assets/3768c74b-433b-46b4-b6ef-301f9857bf4c" />

### **Transaction Log Sheet**
| Field | Description |
|-------|-------------|
| Timestamp | Transaction date/time |
| User | Who performed the action |
| Action | receive/pick/move/adjust |
| Product_ID | SKU affected |
| Quantity_Changed | Units added/removed |
| New_Stock_Level | Resulting inventory |
| Notes | Transaction details |

<img width="1217" height="273" alt="image" src="https://github.com/user-attachments/assets/851fc021-916c-4a72-ac5b-c3f344f414a3" />

### **Alerts Sheet**
| Field | Description |
|-------|-------------|
| Timestamp | Alert date/time |
| Alert_Type | Warning category |
| Product_ID | Affected SKU |
| Current_Stock | Current quantity |
| Min_Stock | Threshold breached |
| Message | Alert description |

<img width="996" height="298" alt="image" src="https://github.com/user-attachments/assets/4ead57c0-1ee1-4a83-86b6-60ac702109ce" />

---

## Quick Start

### **Prerequisites**
- n8n (local or cloud)
- Google account
- PowerShell (for testing)

---

## 📈 Real-World Applications

This demo simulates functionality found in enterprise WMS platforms:

| Demo Feature | Enterprise WMS Equivalent |
|--------------|---------------------------|
| Webhook API | RF scanner/barcode integration |
| Stock validation | Available-to-Promise (ATP) logic |
| Transaction logging | Audit trail for compliance (SOX, FDA) |
| Low stock alerts | Automatic replenishment triggers |
| User tracking | Role-based access control (RBAC) |
| Google Sheets integration | ERP/database connectivity |

---

## Skills Demonstrated

**For WMS IT Support roles:**
- ✅ Understanding of warehouse operations and logistics
- ✅ System configuration and workflow automation
- ✅ User access management concepts
- ✅ Performance monitoring (stock levels, alerts)
- ✅ Audit trail and compliance tracking
- ✅ Integration with cloud platforms
- ✅ API-based system communication
- ✅ Process automation and optimization

**Technical skills:**
- n8n workflow automation
- REST API design
- Google Sheets integration
- PowerShell scripting
- Data validation logic
- Error handling and edge cases

---

<p align="center">
  <em>⭐ If you find this project helpful, please star the repository!</em>
</p>
