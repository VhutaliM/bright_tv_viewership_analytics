# 📊 BrightTV Viewership Analytics

## 🚀 Project Summary
This project analyzes BrightTV’s viewership data to uncover **user behavior patterns, content performance, and engagement drivers**.

The goal is to transform raw data into **actionable business insights** that support **subscription growth and improved user engagement**.

---

## 🎯 Business Problem
BrightTV aims to grow its subscription base. To achieve this, the business needs to:

- Understand **who is watching**
- Identify **when users are most active**
- Determine **what content drives engagement**
- Improve **low-consumption periods**
- Develop **targeted growth strategies**

---

## 🧠 Approach

### 1. Data Preparation (SQL – Databricks)
- Joined viewership and user profile datasets  
- Cleaned and standardized inconsistent values  
- Handled missing data (`none`, NULL values)  
- Converted UTC timestamps to South African time  

### 2. Feature Engineering
- Created **age groups** for demographic segmentation  
- Created **time cohorts** for behavioral analysis  
- Built **session length buckets** to measure engagement  
- Classified **weekday vs weekend patterns**  

### 3. Analysis & Visualization (Excel)
- Built pivot tables  
- Created charts to identify trends  
- Developed a business presentation for stakeholders  

---

## 📂 Dataset Overview

### 📺 Viewership Dataset
- ~10,000 session records  
- Each row represents a viewing session  

**Key Fields:**
- `userID`
- `channel_name`
- `record_utc`
- `session_duration`

---

### 👤 User Profiles Dataset
- Demographic data for each user  

**Key Fields:**
- `userID`
- `gender`
- `race`
- `age`
- `province`

---

## 🛠️ Tech Stack

 Tool | Purpose |
|------|--------|
| **Databricks (SQL)** | Data cleaning, transformation, and feature engineering |
| **Microsoft Excel** | Data analysis, pivot tables, and visualization |
| **Microsoft PowerPoint** | Presentation of insights and business recommendations |
| **XMind** | Project planning and structuring analytical approach |
| **GitHub** | Version control and project documentation |
---

## 📊 Key Insights

### 👥 Audience Profile
- Adults (25–34) and Mid-Age Adults dominate viewership  
- These groups contribute **over 75% of sessions**  
- Younger and older segments show lower engagement  

---

### 📅 Viewing Behavior
- **Lowest engagement:** Monday  
- **Highest engagement:** Friday and Saturday  
- Viewership increases progressively through the week  

---

### ⏰ Time-Based Consumption
- Peak viewing occurs during:
  - Afternoon  
  - Evening Peak  
- Late Night shows the lowest activity  

---

### 📺 Content Performance
- **Live sports content** is the strongest driver  
- Entertainment and music channels perform well  
- A small number of channels dominate total views  

---

### ⏱️ User Engagement
- Most sessions are **short (0–5 minutes)**  
- Significant drop-off after initial engagement  
- Fewer users continue to longer sessions  

---

### 🌍 Geographic Distribution
- Gauteng leads overall viewership  
- Western Cape is the second strongest region  
- Some user locations are unknown  

---

### 🧬 Demographics
- Black users form the largest segment  
- Male users dominate viewership  
- Opportunity to increase female engagement  

---

## 💡 Business Recommendations

### 📉 Improve Low-Consumption Periods
- Focus on Mondays as recovery opportunities  
- Promote short-form content (highlights, recaps)  
- Use teaser campaigns before peak viewing periods  

---

### 📈 Drive Growth
- Target high-value audience segments  
- Re-engage users with short sessions  
- Expand content targeting female audiences  
- Focus campaigns in Gauteng and Western Cape  
- Promote top-performing content strategically  

---

## 📁 Project Structure
