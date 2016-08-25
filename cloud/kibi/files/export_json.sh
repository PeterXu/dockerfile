#!/bin/bash

action="put"
uri="http://admin:pass521@10.11.200.9:9200/.kibi"
#action="get"
#uri="http://admin:pass521@10.11.210.252:9200/.kibi"

root="./data"
mkdir -p $root


todo() {
    local items="$1"
    local url="$uri/$2"
    local path="$root/$2"
    mkdir -p $path

    for item in $items; do
        echo "[INFO] $action of <$item>"
        if [ "$action" = "get" ]; then
            curl -XGET $url/$item/_source > $path/${item}.json
        elif [ "$action" = "put" ]; then 
            file="$path/${item}.json"
            if [ -f $file ]; then
                echo "$url/$item"
                curl -XPOST $url/$item -d "@$file"
            else
                echo "[WARN] $file not exist"
            fi
        fi
    done
}

do_dashboard() {
    items="dash_shenbao_areas dash_shenbao_geo dash_shenbao_status dash_soccerdojo_status"
    dtype="dashboard"
    todo "$items" "$dtype"
}

do_template() {
    items="es_jdbc_template kibi-json-jade kibi-table-handlebars kibi-table-jade"
    dtype="template"
    todo "$items" "$dtype"
}

do_visualization() {
    items="v2_day_added_testing_data
    v2_day_created_notes
    v2_day_deleted_notes
    v2_day_lession_count
    v2_day_updated_testing_data
    v2_school_create_notes
    v2_school_lession_count
    v2_teached_lession_count
    v2_teacher_create_notes
    v2_teacher_lession_count
    v_area_registered_school
    v_area_submit_forms
    v_feature_areas
    v_feature_areas_detail
    v_feature_schools
    v_registered_areas
    v_registered_areas_count
    v_registered_schools
    v_registered_schools_count
    v_shenbao_agent
    v_shenbao_geo
    v_unused_areas"

    dtype="visualization"
    todo "$items" "$dtype"
}

do_search() {
    items="filebeat_nginx-access s_feature_area_detail s_nginx_acccess_shenbao"
    dtype="search"
    todo "$items" "$dtype"
}

do_query() {
    items="q2_day_added_testing_data
    q2_day_created_notes
    q2_day_deleted_notes
    q2_day_lession_count
    q2_day_updated_testing_data
    q2_school_create_notes
    q2_school_lession_count
    q2_teached_lession_count
    q2_teacher_create_notes
    q2_teacher_lession_count
    q_area_registered_schools
    q_area_submit_forms
    q_feature_areas
    q_feature_areas_detail
    q_feature_schools
    q_registered_areas
    q_registered_areas_count
    q_registered_schools
    q_registered_schools_count
    q_unused_areas"
    dtype="query"
    todo "$items" "$dtype"
}

do_datasource() {
    items="es_service "
    dtype="datasource"
    todo "$items" "$dtype"
}

do_dashboard
do_template
do_visualization
do_search
do_query
do_datasource
