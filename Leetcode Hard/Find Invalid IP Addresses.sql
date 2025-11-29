/* Question 3451
Table:  logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| log_id      | int     |
| ip          | varchar |
| status_code | int     |
+-------------+---------+
log_id is the unique key for this table.
Each row contains server access log information including IP address and HTTP status code.
Write a solution to find invalid IP addresses. An IPv4 address is invalid if it meets any of these conditions:

Contains numbers greater than 255 in any octet
Has leading zeros in any octet (like 01.02.03.04)
Has less or more than 4 octets
Return the result table ordered by invalid_count, ip in descending order respectively. 

The result format is in the following example.

Example:

Input:
logs table:
+--------+---------------+-------------+
| log_id | ip            | status_code | 
+--------+---------------+-------------+
| 1      | 192.168.1.1   | 200         | 
| 2      | 256.1.2.3     | 404         | 
| 3      | 192.168.001.1 | 200         | 
| 4      | 192.168.1.1   | 200         | 
| 5      | 192.168.1     | 500         | 
| 6      | 256.1.2.3     | 404         | 
| 7      | 192.168.001.1 | 200         | 
+--------+---------------+-------------+
Output:
+---------------+--------------+
| ip            | invalid_count|
+---------------+--------------+
| 256.1.2.3     | 2            |
| 192.168.001.1 | 2            |
| 192.168.1     | 1            |
+---------------+--------------+
Explanation:

256.1.2.3 is invalid because 256 > 255
192.168.001.1 is invalid because of leading zeros
192.168.1 is invalid because it has only 3 octets
The output table is ordered by invalid_count, ip in descending order respectively. */

-- Write your PostgreSQL query statement below
SELECT ip,
       COUNT(DISTINCT  log_id) AS invalid_count
FROM
    (SELECT log_id, 
            string_agg(ip_elements, '.') AS ip,
            string_agg(CASE WHEN (CAST(ip_elements AS INTEGER) > 255
                                  OR LENGTH(ip_elements) <> LENGTH(CAST(CAST(ip_elements AS INTEGER) AS TEXT))
                                  OR ip_octet_length != 4)
                            THEN '0'
                            ELSE '1'
                       END, ',') AS check_flag -- Checking all the condition for an invalid ip
    FROM
        (SELECT log_id, 
                ip_octet_length,
                UNNEST(ip_array_elements) AS ip_elements --Exploding the ip octect from array to row for a particular log_id
         FROM
            (SELECT log_id, 
                    array_length(string_to_array(ip, '.'), 1) AS ip_octet_length, -- Getting octet length
                    string_to_array(ip, '.') AS ip_array_elements -- Getting all octect elements in array
             FROM logs)
        )
    GROUP BY log_id)
WHERE '0' = ANY(string_to_array(check_flag, ',')) -- Filtering the ip's even if one conidition get violated
GROUP BY ip
ORDER BY invalid_count DESC, 
         ip DESC
