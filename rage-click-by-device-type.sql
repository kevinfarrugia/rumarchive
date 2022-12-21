# standardSQL
# Median number of rage clicks per page view by device type

SELECT
  DEVICETYPE,
  APPROX_QUANTILES(RAGECLICKSAVG, 1000)[OFFSET(500)] AS P50_RAGECLICKS
FROM 
  `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
WHERE
  DATE = '2022-09-30' AND
  BEACONTYPE = 'page view'
GROUP BY
  DEVICETYPE
ORDER BY
  DEVICETYPE