# standardSQL
# distribution (%) of dimension "navigation type" filtered to beacon type="page view"

SELECT
  NAVIGATIONTYPE,
  COUNT(0) AS FREQ,
  SUM(COUNT(0)) OVER () AS TOTAL,
  COUNT(0) / SUM(COUNT(0)) OVER () AS PCT
FROM 
  `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE
  DATE = '2022-09-30' AND
  BEACONTYPE = 'page view'
GROUP BY
  NAVIGATIONTYPE
ORDER BY
  PCT DESC