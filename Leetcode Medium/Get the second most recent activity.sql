-- Question 109
-- Table: UserActivity

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | username      | varchar |
-- | activity      | varchar |
-- | startDate     | Date    |
-- | endDate       | Date    |
-- +---------------+---------+
-- This table does not contain primary key.
-- This table contain information about the activity performed of each user in a period of time.
-- A person with username performed a activity from startDate to endDate.

-- Write an SQL query to show the second most recent activity of each user.

-- If the user only has one activity, return that one. 

-- A user can't perform more than one activity at the same time. Return the result table in any order.

-- The query result format is in the following example:

-- UserActivity table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Travel       | 2020-02-12  | 2020-02-20  |
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Alice      | Travel       | 2020-02-24  | 2020-02-28  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+

-- Result table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+

-- The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
-- Bob only has one record, we just take that one.

-- Explanation:
-- Step1 : As we know one uer cannot peform 2 activities at the same time, we can pick the data for second most based on ranking
-- Step2 : If the user don't have more than 1 activity we need to return that only as we need to find 2nd most which is equivalent to
-- 		   at most
-- Step3 : As at most is required we need to count the number of activities performed by the user in different days

WITH useractivity_extn AS (SELECT username,
				  activity,
				  startDate,
				  endDate,
				  ROW_NUMBER() OVER (PARTITION BY username ORDER BY startDate) AS rnk
				  COUNT(startDate) OVER(PARTITION BY username) AS cnts
			   FROM UserActivity)

SELECT username,
       activity,
       startDate,
       endDate
FROM useractivity_extn
WHERE rnk = 2 or cnts = 1;
