# standardSQL
# combined histogram showing TTFB vs different navigation types

CREATE TEMPORARY FUNCTION getBuckets(payload STRING)
RETURNS ARRAY<STRUCT<bucket INT64, count INT64>>
LANGUAGE js AS '''
  var result = [];
  const parsed = JSON.parse(payload);
  for (const [bucket, value] of Object.entries(parsed)) {
    result.push({ bucket, count: value[1] });
  }
  return result;
''';

SELECT
  NAVIGATIONTYPE,
  TTFBBUCKETS.bucket AS BUCKET,
  SUM(TTFBBUCKETS.count) AS COUNT
FROM (
  SELECT
    NAVIGATIONTYPE,
    `akamai-mpulse-rumarchive.rumarchive.COMBINE_HISTOGRAMS`(ARRAY_AGG(TTFBHISTOGRAM)) AS TTFBHISTOGRAM
  FROM 
    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads` TABLESAMPLE SYSTEM(50 PERCENT)
  WHERE
    DATE = '2022-09-30' AND
    BEACONTYPE = 'page view'
  GROUP BY
    NAVIGATIONTYPE
)
CROSS JOIN 
  UNNEST(getBuckets(TTFBHISTOGRAM)) AS TTFBBUCKETS
GROUP BY
  NAVIGATIONTYPE,
  BUCKET
ORDER BY
  NAVIGATIONTYPE,
  BUCKET
