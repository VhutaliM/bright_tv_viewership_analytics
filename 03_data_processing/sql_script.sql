-- ============================================
-- BRIGHTTV PROJECT: DATA UNDERSTANDING PHASE
-- ============================================

-- 1. View the first few rows of the viewership table
SELECT *
FROM viewership
LIMIT 10;

-- 2. View the first few rows of the user profiles table
SELECT *
FROM user_profiles
LIMIT 10;

-- 3. Count total rows in the viewership table
SELECT COUNT(*) AS total_viewership_rows
FROM viewership;

-- 4. Count total rows in the user profiles table
SELECT COUNT(*) AS total_user_profile_rows
FROM user_profiles;

-- 5. Check for NULL values in important columns in viewership
SELECT 
    COUNT(*) - COUNT(UserID0) AS missing_userid,
    COUNT(*) - COUNT(Channel2) AS missing_channel,
    COUNT(*) - COUNT(RecordDate2) AS missing_recorddate,
    COUNT(*) - COUNT(`Duration 2`) AS missing_duration
FROM viewership;

-- 6. Check for NULL values in important columns in user profiles
SELECT 
    COUNT(*) - COUNT(UserId) AS missing_userid,
    COUNT(*) - COUNT(Gender) AS missing_gender,
    COUNT(*) - COUNT(Race) AS missing_race,
    COUNT(*) - COUNT(Age) AS missing_age,
    COUNT(*) - COUNT(Province) AS missing_province
FROM user_profiles;

-- 7. Check for duplicate users in user_profiles
SELECT 
    UserId,
    COUNT(*) AS record_count
FROM user_profiles
GROUP BY UserId
HAVING COUNT(*) > 1;

-- 8. Check whether users appear multiple times in viewership
SELECT 
    UserID0,
    COUNT(*) AS session_count
FROM viewership
GROUP BY UserID0
ORDER BY session_count DESC
LIMIT 20;

-- 9. Check for missing or zero durations
SELECT *
FROM viewership
WHERE `Duration 2` IS NULL
   OR `Duration 2` = '00:00:00';

-- 10. Check the date range of the dataset
SELECT 
    MIN(RecordDate2) AS earliest_record_utc,
    MAX(RecordDate2) AS latest_record_utc
FROM viewership;

-- 11. View unique channels
SELECT DISTINCT Channel2
FROM viewership
ORDER BY Channel2;

-- 12. View unique provinces
SELECT DISTINCT Province
FROM user_profiles
ORDER BY Province;

-- 13. View unique genders
SELECT DISTINCT Gender
FROM user_profiles
ORDER BY Gender;

-- 14. Check for suspicious ages
SELECT *
FROM user_profiles
WHERE Age IS NOT NULL
  AND (Age < 0 OR Age > 100);

-- 15. Check how many viewership rows match to profiles
SELECT
    COUNT(*) AS total_viewership_rows,
    COUNT(u.UserId) AS matched_profile_rows,
    COUNT(*) - COUNT(u.UserId) AS unmatched_profile_rows
FROM viewership v
LEFT JOIN user_profiles u
    ON v.UserID0 = u.UserId;

-- ==========================================================
-- BRIGHTTV PROJECT: FINAL CLEAN TABLE FOR EXCEL EXPORT
-- ==========================================================

SELECT
    -- Core identifiers
    v.UserID0 AS userID,

    -- Content fields
    COALESCE(v.Channel2, 'Unknown') AS channel_name,
    v.RecordDate2 AS record_utc,
    v.RecordDate2 + INTERVAL 2 HOURS AS record_sa_datetime,
    COALESCE(v.`Duration 2`, '00:00:00') AS session_duration,

    -- User profile fields
    COALESCE(u.Gender, 'Unknown') AS gender,
    COALESCE(u.Race, 'Unknown') AS race,
    u.Age AS age,
    COALESCE(u.Province, 'Unknown') AS province,

    -- Date breakdown fields
    TO_DATE(v.RecordDate2 + INTERVAL 2 HOURS) AS sa_view_date,
    YEAR(v.RecordDate2 + INTERVAL 2 HOURS) AS sa_year,
    MONTH(v.RecordDate2 + INTERVAL 2 HOURS) AS sa_month_number,
    MONTHNAME(v.RecordDate2 + INTERVAL 2 HOURS) AS sa_month_name,
    DAY(v.RecordDate2 + INTERVAL 2 HOURS) AS sa_day_of_month,
    DAYNAME(v.RecordDate2 + INTERVAL 2 HOURS) AS sa_day_name,
    HOUR(v.RecordDate2 + INTERVAL 2 HOURS) AS sa_hour,

    -- Duration converted to seconds
    (
        HOUR(COALESCE(v.`Duration 2`, '00:00:00')) * 3600
        + MINUTE(COALESCE(v.`Duration 2`, '00:00:00')) * 60
        + SECOND(COALESCE(v.`Duration 2`, '00:00:00'))
    ) AS duration_seconds,

    -- Duration converted to minutes
    ROUND(
        (
            HOUR(COALESCE(v.`Duration 2`, '00:00:00')) * 3600
            + MINUTE(COALESCE(v.`Duration 2`, '00:00:00')) * 60
            + SECOND(COALESCE(v.`Duration 2`, '00:00:00'))
        ) / 60.0, 2
    ) AS duration_minutes,

    -- Weekday vs weekend
    CASE
    WHEN DAYOFWEEK(v.RecordDate2 + INTERVAL 2 HOURS) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
END AS day_classification,

     -- Time of day grouping
    CASE
        WHEN HOUR(v.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 0 AND 5 THEN '1.Late Night'
        WHEN HOUR(v.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 6 AND 11 THEN '2.Morning'
        WHEN HOUR(v.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 12 AND 16 THEN '3.Afternoon'
        WHEN HOUR(v.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 17 AND 20 THEN '4.Evening Peak'
        ELSE 'Night'
    END AS time_classification,

    -- Session length bucket
    CASE
        WHEN (
            HOUR(COALESCE(v.`Duration 2`, '00:00:00')) * 3600
            + MINUTE(COALESCE(v.`Duration 2`, '00:00:00')) * 60
            + SECOND(COALESCE(v.`Duration 2`, '00:00:00'))
        ) = 0 THEN 'No Viewing Activity'
        WHEN (
            HOUR(COALESCE(v.`Duration 2`, '00:00:00')) * 3600
            + MINUTE(COALESCE(v.`Duration 2`, '00:00:00')) * 60
            + SECOND(COALESCE(v.`Duration 2`, '00:00:00'))
        ) <= 300 THEN '0-5 min'
        WHEN (
            HOUR(COALESCE(v.`Duration 2`, '00:00:00')) * 3600
            + MINUTE(COALESCE(v.`Duration 2`, '00:00:00')) * 60
            + SECOND(COALESCE(v.`Duration 2`, '00:00:00'))
        ) <= 1800 THEN '6-30 min'
        WHEN (
            HOUR(COALESCE(v.`Duration 2`, '00:00:00')) * 3600
            + MINUTE(COALESCE(v.`Duration 2`, '00:00:00')) * 60
            + SECOND(COALESCE(v.`Duration 2`, '00:00:00'))
        ) <= 3600 THEN '31-60 min'
        ELSE '60+ min'
    END AS session_length_bucket,

-- Age groups
 CASE
    WHEN u.Age BETWEEN 0 AND 12 THEN '1.Kids'
    WHEN u.Age BETWEEN 13 AND 17 THEN '2.Teens'
    WHEN u.Age BETWEEN 18 AND 24 THEN '3.Young Adults'
    WHEN u.Age BETWEEN 25 AND 34 THEN '4.Adults (25-34)'
    WHEN u.Age BETWEEN 35 AND 54 THEN '5.Mid-Age Adults'
    WHEN u.Age >= 55 THEN '6.Seniors'
    ELSE 'Unknown'
END AS age_group

FROM viewership v
LEFT JOIN user_profiles u
    ON v.UserID0 = u.UserId;
