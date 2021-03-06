# Deleting page manually in Media Wiki:
# Title - Φάνης_Γκέκας
# Page Id - 74392
# Rev Id, Page Latest - 5664947
# Old Rev Text Id - 5664947

# 1. Listing all related table keys

SELECT
    p.page_id AS "page_id",
    CAST(p.page_title AS CHAR(10000) CHARACTER SET utf8) AS "page_title",
    r.rev_text_id AS "revision_id",
    t.old_id AS "text_id"
FROM
    page p
        INNER JOIN revision r
            ON p.page_latest = r.rev_id
        INNER JOIN text t
            ON r.rev_text_id = t.old_id
			
# 2. Deleting from database the rows

SELECT
    CONCAT('IN(', GROUP_CONCAT(`p`.`page_id`), ')') AS 'page',
    CONCAT('IN(', GROUP_CONCAT(`r`.`rev_text_id`), ')')  AS 'revision',
    CONCAT('IN(', GROUP_CONCAT(`t`.`old_id`), ')')  AS 'text'
FROM
    page p
        INNER JOIN `revision` r
            ON `p`.`page_id` = `r`.`rev_page`        -- Confirmed to be reference to page.page_id
        INNER JOIN text t
            ON `r`.`rev_text_id` = `t`.`old_id`      -- Confirmed to be reference to revision table
WHERE 
	p.page_title LIKE '%Tests/parent-a%';
	
# 3. Deleted from the ids selected from above

SET autocommit=0;

START TRANSACTION;
  DELETE FROM `page` WHERE page_id IN(5530,5528,5529,5530,5529,5528,5532,5532,5532);
  DELETE FROM `revision` WHERE rev_text_id IN(9918,9921,9917,9919,9920,9916,9922,9915,9923);
  DELETE FROM `text` WHERE old_id IN(9918,9921,9917,9919,9920,9916,9922,9915,9923);
COMMIT;
