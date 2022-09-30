view: latest_international_top_terms {
  derived_table: {
    sql: SELECT
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
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: country_name {
    type: string
    sql: ${TABLE}.country_name ;;
  }

  dimension: country {
    map_layer_name: countries
    sql: ${TABLE}.country_name;;
  }

  dimension: term {
    type: string
    sql: ${TABLE}.term ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
  }

  dimension: week {
    type: date
    datatype: date
    sql: ${TABLE}.week ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: refresh_date {
    type: date
    datatype: date
    sql: ${TABLE}.refresh_date ;;
  }

  dimension: average_score {
    type: number
    label: "Average Score in country"
    sql: ${TABLE}.average_score ;;
  }

  measure: average_score_worldwide {
    type: average
    label: "Average Score WW"
    value_format_name: decimal_1
    sql: ${TABLE}.average_score ;;
  }

  set: detail {
    fields: [
      country_name,
      term,
      week,
      rank,
      refresh_date,
      average_score
    ]
  }
}
