SELECT *
FROM course_aggregator.reviews_switchup;

SELECT *
FROM course_aggregator.reviews_coursereport;


-- Merge overall rating from both tables
-- Use alias rc and rs for the tables reviews_coursereport and reviews_switchup
USE course_aggregator;
CREATE TABLE review_aggregate AS
SELECT 
    COALESCE(rc.School_id, rs.school_id) AS school_id,
    COALESCE(rc.School, rs.school) AS school,
    COALESCE((rc.Rating + rs.overallRating) / 2, rc.Rating, rs.overallRating) AS average_rating,
    COALESCE(rc.Reviews, 0) + COALESCE(rs.reviewCount, 0) AS total_reviews
FROM reviews_coursereport rc
LEFT JOIN reviews_switchup rs ON rc.School_id = rs.school_id

UNION

SELECT 
    COALESCE(rc.School_id, rs.school_id) AS school_id,
    COALESCE(rc.School, rs.school) AS school,
    COALESCE((rc.Rating + rs.overallRating) / 2, rc.Rating, rs.overallRating) AS average_rating,
    COALESCE(rc.Reviews, 0) + COALESCE(rs.reviewCount, 0) AS total_reviews
FROM reviews_coursereport rc
RIGHT JOIN reviews_switchup rs ON rc.School_id = rs.school_id;

SELECT *
FROM review_aggregate
ORDER BY total_reviews DESC;



