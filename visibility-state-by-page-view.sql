# standardSQL
# distribution (%) of dimension "visibility state" filtered to beacon type="page view"

SELECT
  VISIBILITYSTATE,
  COUNT(0) AS FREQ,
  SUM(COUNT(0)) OVER () AS TOTAL,
  COUNT(0) / SUM(COUNT(0)) OVER () AS PCT
FROM 
  `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE
  DATE = '2022-09-30' AND
  BEACONTYPE = 'page view'
GROUP BY
  VISIBILITYSTATE
ORDER BY
  PCT DESC