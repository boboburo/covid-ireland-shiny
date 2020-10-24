# Description

A offline DB is used in case the online link goes down and also for development purposes. Each download is createa as a new table. The db shouldn't get too big. 

# Create new table 

```bash
curl "https://opendata-geohive.hub.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D" | \
sqlite-utils insert --csv covid-ireland.db dailycases_"`date +"%Y_%m_%d"`" - --pk OBJECTID 
```
