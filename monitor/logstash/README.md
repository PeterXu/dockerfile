

## for nginx access
  set beats's document_type = "nginx-access"

```
filter {
    if [type] == "nginx-access" {
        grok {
            match => {"message" => "%{IPORHOST:client} (%{USER:ident}|-) (%{USER:auth}|-) \[%{HTTPDATE:timestamp}\] \"(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:http_version})?|-)\" %{IPORHOST:domain} %{NUMBER:response} (?:%{NUMBER:bytes}|-) (%{QS:referrer}|-) (%{QS:agent}|-) \"(%{WORD:x_forword}|-)\" (%{URIHOST:upstream_host}|-) (%{NUMBER:upstream_response}|-) (%{WORD:upstream_cache_status}|-) (%{QS:upstream_content_type}|-) (%{BASE16FLOAT:upstream_response_time}|-) > (%{BASE16FLOAT:request_time}|-)"}
        }

        geoip {
            source => "client"
            add_tag => [ "geoip" ]
        }
    }
}
```


## for tomcat access
  set beats's document_type = "tomcat-access"
```
filter {
    if [type] == "tomcat-access" {
        grok {
            match => {"message" => "%{IPORHOST:client} (%{USER:ident}|-) (%{USER:auth}|-) \[%{HTTPDATE:timestamp}\] \"(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:http_version})?|-)\" %{NUMBER:response} (?:%{NUMBER:bytes}|-) (%{URIHOST:remote_client}|-)"}
        }

        geoip {
            source => "remote_client"
        }
    }
}
```

