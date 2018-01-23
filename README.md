# soundcloud tracks search
Get track information of artists of sound cloud and search

### Env
```
Rails 5.1.1
Elasticsearch 5.5.2
```

## Elasticsearch mapping
```
$ curl -X PUT localhost:9200/socl_index -d @mapping/socl/mapping.json
$ curl -X PUT localhost:9200/socl_history -d @mapping/socl/history_mapping.json
```

## Start
```
$ rails s
```

### Register URL
`http://localhost:3000/socls/search/`

### Search URL
`http://localhost:3000/`
