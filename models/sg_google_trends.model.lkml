# Define the database connection to be used for this model.
connection: "sudipto-google-trends"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: sg_google_trends_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: sg_google_trends_default_datagroup



explore: top_terms {}

explore: international_top_rising_terms {}

explore: international_top_terms {}

explore: top_rising_terms {}

explore: latest_intl_top25_ranked {}

explore: latest_international_top_terms {}
