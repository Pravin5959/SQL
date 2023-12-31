-- Question 78
-- Table Variables:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | name          | varchar |
-- | value         | int     |
-- +---------------+---------+
-- name is the primary key for this table.
-- This table contains the stored variables and their values.
 

-- Table Expressions:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | left_operand  | varchar |
-- | operator      | enum    |
-- | right_operand | varchar |
-- +---------------+---------+
-- (left_operand, operator, right_operand) is the primary key for this table.
-- This table contains a boolean expression that should be evaluated.
-- operator is an enum that takes one of the values ('<', '>', '=')
-- The values of left_operand and right_operand are guaranteed to be in the Variables table.
 

-- Write an SQL query to evaluate the boolean expressions in Expressions table.

-- Return the result table in any order.

-- The query result format is in the following example.

-- Variables table:
-- +------+-------+
-- | name | value |
-- +------+-------+
-- | x    | 66    |
-- | y    | 77    |
-- +------+-------+

-- Expressions table:
-- +--------------+----------+---------------+
-- | left_operand | operator | right_operand |
-- +--------------+----------+---------------+
-- | x            | >        | y             |
-- | x            | <        | y             |
-- | x            | =        | y             |
-- | y            | >        | x             |
-- | y            | <        | x             |
-- | x            | =        | x             |
-- +--------------+----------+---------------+

-- Result table:
-- +--------------+----------+---------------+-------+
-- | left_operand | operator | right_operand | value |
-- +--------------+----------+---------------+-------+
-- | x            | >        | y             | false |
-- | x            | <        | y             | true  |
-- | x            | =        | y             | false |
-- | y            | >        | x             | true  |
-- | y            | <        | x             | false |
-- | x            | =        | x             | true  |
-- +--------------+----------+---------------+-------+
-- As shown, you need find the value of each boolean exprssion in the table using the variables table.
-- Explanation:
-- Step1 : First we need to get the actual values for the operands which is present in value tables
-- Step2 : As we need to get the values for both left and right operand we will have to merge the value table twice as using
--         value tables once with both left and right operand won't result in correct behavior
-- Step3 : Once we have the operand's value present based upon the operator given we will have to evaluate and provide the result


WITH expression_extn AS (SELECT v.value AS left_val,
				left_operand
				operator,
				right_operand,
				v1.value AS right_val 
			 FROM Expressions e
			 INNER JOIN Variables v
			 ON e.left_operand = v.name
			 INNER JOIN Variables v1
			 ON e.right_operand = v1.name),


pre_final AS (SELECT left_operand,
		     operator,
		     right_operand,
		     CASE WHEN operator = '<' THEN left_val < right_val
			  WHEN operator = '>' THEN left_val > right_val
			  ELSE left_val = right_val
		     END AS value
	      FROM expression_extn)

SELECT left_operand,
       operator,
       right_operand,
       CASE WHEN value = 1 then true
	    ELSE false 
       END AS value
FROM pre_final;
