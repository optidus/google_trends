view: latest_us_top25_ranked {
  derived_table: {
    sql: WITH latest_US_top_terms AS (SELECT
--       country_name,
        term,
        week,
        rank,
        refresh_date,
        coalesce(round(avg(nullif(score,0)),1),0) as average_score
        -- ARRAY_AGG(STRUCT(rank,week) ORDER BY week DESC, refresh_date DESC LIMIT 1) x
      FROM
          `bigquery-public-data.google_trends.top_terms`
      WHERE
          refresh_date =
              (SELECT
                  MAX(refresh_date)
              FROM
              `bigquery-public-data.google_trends.top_terms`)
              AND
           week =
              (SELECT
                  MAX(week)
              FROM
              `bigquery-public-data.google_trends.top_terms`
              )
              group by 1,2,3,4
              order by 3 asc
       )
SELECT
    latest_US_top_terms.term  AS latest_US_top_terms_term,
    AVG(latest_US_top_terms.rank ) AS latest_US_top_terms_average_rank_worldwide,
    AVG(latest_US_top_terms.average_score ) AS latest_US_top_terms_average_score_worldwide,
    COUNT(*) AS latest_US_top_terms_count,
    RANK() OVER (ORDER BY count(*) desc, AVG(latest_US_top_terms.average_score ) desc) as overall_rank
FROM latest_US_top_terms
GROUP BY
    1
ORDER BY
    4 desc, 3 desc, 2 asc
LIMIT 25
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: latest_US_top_terms_term {
    type: string
    sql: ${TABLE}.latest_US_top_terms_term ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
  }

  dimension: latest_US_top_terms_average_rank_worldwide {
    type: number
    value_format_name: decimal_1
    sql: ${TABLE}.latest_US_top_terms_average_rank_worldwide ;;
  }

  dimension: latest_US_top_terms_average_score_worldwide {
    type: number
    value_format_name: decimal_1
    sql: ${TABLE}.latest_US_top_terms_average_score_worldwide ;;
  }

  dimension: latest_US_top_terms_count {
    type: number
    sql: ${TABLE}.latest_US_top_terms_count ;;
  }

  dimension: overall_rank {
    type: number
    sql: ${TABLE}.overall_rank ;;
  }

  set: detail {
    fields: [latest_US_top_terms_term, latest_US_top_terms_average_rank_worldwide, latest_US_top_terms_average_score_worldwide, latest_US_top_terms_count, overall_rank]
  }


 }
