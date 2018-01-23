# soundcloud tracks search
Get track information of artists of sound cloud and search

## Elasticsearch mapping
```
$ curl -X PUT localhost:9200/socl_index -d @mapping/socl/mapping.json
$ curl -X PUT localhost:9200/socl_history -d @mapping/socl/history_mapping.json
```

## start
```
$ rails s
```

### Register URL
`http://localhost:3000/socls/search/`

### Search URL
`http://localhost:3000/`
