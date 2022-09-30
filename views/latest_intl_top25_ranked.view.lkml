view: latest_intl_top25_ranked {
  derived_table: {
    sql: WITH latest_international_top_terms AS (SELECT
        country_name,
        term,
        week,
        rank,
        refresh_date,
        coalesce(round(avg(nullif(score,0)),1),0) as average_score
        -- ARRAY_AGG(STRUCT(rank,week) ORDER BY week DESC, refresh_date DESC LIMIT 1) x
      FROM
          `bigquery-public-data.google_trends.international_top_terms`
      WHERE
          refresh_date =
              (SELECT
                  MAX(refresh_date)
              FROM
              `bigquery-public-data.google_trends.international_top_terms`)
              AND
           week =
              (SELECT
                  MAX(week)
              FROM
              `bigquery-public-data.google_trends.international_top_terms`
              )
              group by 1,2,3,4,5
              order by 4 asc
       )
SELECT
    latest_international_top_terms.term  AS latest_international_top_terms_term,
    AVG(latest_international_top_terms.rank ) AS latest_international_top_terms_average_rank_worldwide,
    AVG(latest_international_top_terms.average_score ) AS latest_international_top_terms_average_score_worldwide,
    COUNT(*) AS latest_international_top_terms_count,
    RANK() OVER (ORDER BY count(*) desc, AVG(latest_international_top_terms.average_score ) desc) as overall_rank
FROM latest_international_top_terms
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

  dimension: latest_international_top_terms_term {
    type: string
    sql: ${TABLE}.latest_international_top_terms_term ;;
  }

  dimension: latest_international_top_terms_average_rank_worldwide {
    type: number
    value_format_name: decimal_1
    sql: ${TABLE}.latest_international_top_terms_average_rank_worldwide ;;
  }

  dimension: latest_international_top_terms_average_score_worldwide {
    type: number
    value_format_name: decimal_1
    sql: ${TABLE}.latest_international_top_terms_average_score_worldwide ;;
  }

  dimension: latest_international_top_terms_count {
    type: number
    sql: ${TABLE}.latest_international_top_terms_count ;;
  }

  dimension: overall_rank {
    type: number
    sql: ${TABLE}.overall_rank ;;
  }

  set: detail {
    fields: [latest_international_top_terms_term, latest_international_top_terms_average_rank_worldwide, latest_international_top_terms_average_score_worldwide, latest_international_top_terms_count, overall_rank]
  }
}
