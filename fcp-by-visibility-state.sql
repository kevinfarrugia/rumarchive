# standardSQL
# combined histogram showing FCP vs different navigation types

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
  VISIBILITYSTATE,
  FCPBUCKETS.bucket AS BUCKET,
  SUM(FCPBUCKETS.count) AS COUNT
FROM (
  SELECT
    VISIBILITYSTATE,
    `akamai-mpulse-rumarchive.rumarchive.COMBINE_HISTOGRAMS`(ARRAY_AGG(FCPHISTOGRAM)) AS FCPHISTOGRAM
  FROM 
    `akamai-mpulse-rumarchive.rumarchive.rumarchive_page_loads`
  WHERE
    DATE = '2022-09-30' AND
    BEACONTYPE = 'page view'
  GROUP BY
    VISIBILITYSTATE
)
CROSS JOIN 
  UNNEST(getBuckets(FCPHISTOGRAM)) AS FCPBUCKETS
GROUP BY
  VISIBILITYSTATE,
  BUCKET
ORDER BY
  VISIBILITYSTATE,
  BUCKET
