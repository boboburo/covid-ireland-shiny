# covid_ireland_shiny

Shiny application visualising the Covid Situation in the Republic of Ireland. The app is currently published on the RStudio shinyapps.io platform 

https://iboboburo.shinyapps.io/covid-ireland/

## Data Source

Initially I was pulling data from [Ireland Covid Data Hub](https://covid19ireland-geohive.hub.arcgis.com/) and specifically from [here](https://opendata.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0.csv). However this proved to be buggy and often times didn't return the full data dataset 

TODO: Write some test for this based on the return the count and comparing with the downloaded data ? 

After a search I moved to data pull to [Irelands Open Data Portal](https://data.gov.ie/) and grabbed the [csv data](https://opendata-geohive.hub.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D). This has proved to be more stable. 


## Installation 

If you want to run local or extend you can do so by ...

## Docker

Nice guide written [here](https://www.statworx.com/ch/blog/how-to-dockerize-shinyapps/)

Create the docker image
```bash
docker build -t covid-irl-image . 
```

Run the image 

```bash
docker run -d --rm -p 3838:3838 covid-irl-image .
```



# To do

- add tests
- add Ireland as a "county" 
- write up installation. 
- add data in sqlite for Docker container
- update dockerFile
- create Docker ignore file 
- create docker image and publish ?
- add other countries ?  
- reduce dependencies

## blog write up. 

- project template
- start with plots
- then modules
- then stick it together
- move to tests - note on naming convention, need to change the test file, helper functions. 
- docker file vs shiny apps.  
- discuss golem as option vs https://shiny.rstudio.com/reference/shiny/1.5.0/shinyAppTemplate.html
