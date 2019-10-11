include: "ad_group.view"
include: "google_adwords_base.view"

explore: keyword_join {
  extension: required

  join: keyword {
    from: keyword_adapter
    view_label: "Keyword"
    sql_on: ${fact.criterion_id} = ${keyword.criterion_id} AND
      ${fact.ad_group_id} = ${keyword.ad_group_id} AND
      ${fact.campaign_id} = ${keyword.campaign_id} AND
      ${fact.external_customer_id} = ${keyword.external_customer_id} AND
      ${fact._date} = ${keyword._date} ;;
    relationship: many_to_one
  }
}

explore: keyword {
  persist_with: adwords_etl_datagroup
  from: keyword_adapter
  view_name: keyword
  hidden: yes

  join: ad_group {
    from: ad_group
    view_label: "Ad Groups"
    sql_on: ${keyword.ad_group_id} = ${ad_group.ad_group_id} AND
      ${keyword.campaign_id} = ${ad_group.campaign_id} AND
      ${keyword.external_customer_id} = ${ad_group.external_customer_id} AND
      ${keyword._date} = ${ad_group._date} ;;
    relationship: many_to_one
  }
  join: campaign {
    from: campaign
    view_label: "Campaign"
    sql_on: ${keyword.campaign_id} = ${campaign.campaign_id} AND
      ${keyword.external_customer_id} = ${campaign.external_customer_id} AND
      ${keyword._date} = ${campaign._date};;
    relationship: many_to_one
  }
  join: customer {
    from: customer
    view_label: "Customer"
    sql_on: ${keyword.external_customer_id} = ${customer.external_customer_id} AND
      ${keyword._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}

view: keyword_adapter {
  extends: [adwords_config, google_adwords_base]
  sql_table_name: {{ keyword.adwords_schema._sql }}.keyword ;;

  dimension: ad_group_id {
    sql: ${TABLE}.ad_group_id ;;
    type: number
    hidden: yes
  }

  dimension: approval_status {
    type: string
    sql: ${TABLE}.approval_status ;;
  }

  dimension: bid_type {
    type: string
    sql: ${TABLE}.bid_type ;;
  }

  dimension: bidding_strategy_id {
    sql: ${TABLE}.bidding_strategy_id ;;
    hidden: yes
  }

  dimension: bidding_strategy_name {
    type: string
    sql: ${TABLE}.bidding_strategy_name ;;
  }

  dimension: bidding_strategy_source {
    type: string
    sql: ${TABLE}.bidding_strategy_source ;;
  }

  dimension: bidding_strategy {
    type: string
    sql: ${TABLE}.bidding_strategy_type ;;
  }

  dimension: bidding_strategy_type {
    type: string
    case: {
      when: {
        sql: ${bidding_strategy} = 'Target CPA' ;;
        label: "Target CPA"
      }
      when: {
        sql: ${bidding_strategy} = 'Enhanced CPC';;
        label: "Enhanced CPC"
      }
      when: {
        sql: ${bidding_strategy} = 'cpc' ;;
        label: "CPC"
      }
      when: {
        sql: ${bidding_strategy} = 'cpv' ;;
        label: "CPV"
      }
      else: "Other"
    }
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
    hidden: yes
  }

  dimension: cpc_bid {
    hidden: yes
    type: number
    sql: ${TABLE}.cpc_bid ;;
  }

  dimension: cpc_bid_source {
    type: string
    sql: ${TABLE}.cpc_bid_source ;;
  }

  dimension: cpm_bid {
    hidden: yes
    type: number
    sql: ${TABLE}.cpm_bid ;;
  }

  dimension: creative_quality_score {
    type: string
    sql: ${TABLE}.creative_quality_score ;;
    hidden: yes
  }

  dimension: criteria {
    type: string
    sql: ${TABLE}.criteria ;;
    link: {
      icon_url: "https://www.google.com/images/branding/product/ico/googleg_lodp.ico"
      label: "Google Search"
      url: "https://www.google.com/search?q={{ value | encode_uri}}"
    }
    required_fields: [external_customer_id, campaign_id, ad_group_id, criterion_id]
  }

  dimension: campaign_ad_group_keyword_combination {
    type: string
    sql: CONCAT(${campaign.name}, "_", ${ad_group.ad_group_name}, "_", ${keyword.criteria}) ;;
  }

  dimension: criteria_destination_url {
    type: string
    sql: ${TABLE}.criteria_destination_url ;;
    group_label: "URLS"
  }

  dimension: criterion_id {
    sql: ${TABLE}.id ;;
    type: number
    hidden: yes
  }

  dimension: enhanced_cpc_enabled {
    type: yesno
    sql: ${TABLE}.enhanced_cpc_enabled ;;
    hidden:  yes
  }

  dimension: estimated_add_clicks_at_first_position_cpc {
    type: number
    sql: ${TABLE}.estimated_add_clicks_at_first_position_cpc ;;
    hidden:  yes
  }

  dimension: estimated_add_cost_at_first_position_cpc {
    type: number
    sql: ${TABLE}.estimated_add_cost_at_first_position_cpc ;;
    hidden:  yes
  }

  dimension: final_app_urls {
    type: string
    sql: ${TABLE}.final_app_urls ;;
    group_label: "URLS"
  }

  dimension: final_mobile_urls {
    type: string
    sql: ${TABLE}.final_mobile_urls ;;
    group_label: "URLS"
  }

  dimension: final_urls {
    type: string
    sql: ${TABLE}.final_urls ;;
    group_label: "URLS"
  }

  dimension: first_page_cpc {
    type: string
    sql: ${TABLE}.first_page_cpc ;;
  }

  dimension: first_position_cpc {
    type: string
    sql: ${TABLE}.first_position_cpc ;;
  }

  dimension: has_quality_score {
    type: yesno
    sql: ${TABLE}.has_quality_score ;;
    hidden: yes
  }

  dimension: is_negative {
    type: yesno
    sql: ${TABLE}.is_negative ;;
  }

  dimension: keyword_match_type {
    type: string
    sql: ${TABLE}.keyword_match_type ;;
  }

  dimension: label_ids {
    type: string
    sql: ${TABLE}.label_ids ;;
    hidden: yes
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: post_click_quality_score {
    type: string
    sql: ${TABLE}.post_click_quality_score ;;
  }

  dimension: quality_score {
    type: number
    sql: ${TABLE}.quality_score ;;
  }

  dimension: search_predicted_ctr {
    type: string
    sql: ${TABLE}.search_predicted_ctr ;;
    hidden:  yes
  }

  dimension: status {
    hidden: yes
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: status_active {
    type: yesno
    sql: ${status} = "enabled" ;;
  }

  dimension: system_serving_status {
    hidden: yes
    type: string
    sql: ${TABLE}.system_serving_status ;;
  }

  dimension: top_of_page_cpc {
    type: string
    sql: ${TABLE}.top_of_page_cpc ;;
  }

  dimension: tracking_url_template {
    type: string
    sql: ${TABLE}.tracking_url_template ;;
    hidden:  yes
  }

  dimension: url_custom_parameters {
    type: string
    sql: ${TABLE}.url_custom_parameters ;;
    hidden:  yes
  }
}
