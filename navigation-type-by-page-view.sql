# standardSQL
# distribution (%) of dimension "navigation type" filtered to beacon type="page view"

SELECT
  NAVIGATIONTYPE,
  SUM(BEACONS) AS FREQ,
  SUM(SUM(BEACONS)) OVER () AS TOTAL,
  SUM(BEACONS) / SUM(SUM(BEACONS)) OVER () AS PCT
FROM 
  `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE
  DATE = '2022-09-30' AND
  BEACONTYPE = 'page view'
GROUP BY
  NAVIGATIONTYPE
ORDER BY
  PCT DESC
