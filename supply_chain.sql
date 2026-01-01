use supply_chain_analysis;

select * from finantial;

select * from inventory;

select * from patient;

select * from staff;

select * from vendor;

-- Stock-Out Risk Items
SELECT
    Item_ID,
    Item_Name,
    Current_Stock,
    Min_Required
FROM inventory
WHERE Current_Stock <= Min_Required;

-- overstock inventory
SELECT
    Item_ID,
    Item_Name,
    Current_Stock,
    Max_Capacity
FROM inventory
WHERE Current_Stock > Max_Capacity;

-- inventory value in hand
SELECT
    Item_Name,
    Current_Stock,
    Unit_Cost,
    round((Current_Stock * Unit_Cost),2) AS Inventory_Value
FROM inventory;

-- high cost invetory items
select 
Item_Name,
Current_Stock,
Unit_Cost
from inventory
order by Unit_Cost desc
limit 10;

-- vendor lead time analysis
select Vendor_ID,
Vendor_Name,
round(avg(`Avg_Lead_Time (days)`),2) as avg_lead_time_days
from vendor
group by Vendor_ID,Vendor_Name
Order by avg_lead_time_days desc;

-- items with slow vendors
SELECT
    v.Item_Supplied,
    v.Vendor_Name,
    v.`Avg_Lead_Time (days)`
FROM vendor as v
WHERE v.`Avg_Lead_Time (days)` > 7;

-- Montholy inventory spend
SELECT
    DATE_FORMAT(
        STR_TO_DATE(TRIM(Date), '%d/%m/%Y'),
        '%Y-%m'
    ) AS Month,
    round(SUM(Amount),2) AS Total_Expense
FROM finantial
GROUP BY Month
ORDER BY Month;

-- Expence Breakdown by Category
SELECT
    Expense_Category,
    round(SUM(Amount),2) AS Total_Amount
FROM finantial
GROUP BY Expense_Category
ORDER BY Total_Amount DESC;

-- Item cost vs Vendor cost comparision
SELECT
    i.Item_Name,
    i.Unit_Cost AS Internal_Cost,
    v.Cost_Per_Item AS Vendor_Cost
FROM inventory as i
JOIN vendor as v
    ON i.Item_Name = v.Item_Supplied;

-- Reorder Priroty score
SELECT
    Item_Name,
    (Min_Required - Current_Stock) AS Stock_Gap,
    Unit_Cost,
    ((Min_Required - Current_Stock) * Unit_Cost) AS Priority_Score
FROM inventory
WHERE Current_Stock < Min_Required
ORDER BY Priority_Score DESC;

-- Top 5 Critical Items by Stock Gap
SELECT
    Item_Name,
    (Min_Required - Current_Stock) AS Stock_Gap
FROM inventory
WHERE Current_Stock < Min_Required
ORDER BY Stock_Gap DESC
LIMIT 5;

-- Inventory Cost Contribution %
SELECT
    Item_Name,
    (Current_Stock * Unit_Cost) AS Item_Value,
    ROUND(
        (Current_Stock * Unit_Cost) /
        (SELECT SUM(Current_Stock * Unit_Cost) FROM inventory) * 100, 2
    ) AS Contribution_Percentage
FROM inventory;
















