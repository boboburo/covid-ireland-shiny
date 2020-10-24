# covid_ireland_shiny

Shiny application visualising the Covid Situation in the Republic of Ireland. The app is currently published on the RStudio shinyapps.io platform 

https://iboboburo.shinyapps.io/coviddash/

## Data Source

Initially I was pulling data from [Ireland Covid Data Hub](https://covid19ireland-geohive.hub.arcgis.com/) and specifically from [here](https://opendata.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0.csv). However this proved to be buggy and often times didn't return the full data dataset 

>TODO: Write some test for this based on the return the count and comparing with the downloaded data ? 

I changed the data pull to [Irelands Open Data Portal](https://data.gov.ie/) and grabbed the [csv data](https://opendata-geohive.hub.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D). This has proved to be more stable. 

## Development

Use _renv_ to manage the environment for use in Docker. 

```r
renv::init()
renv::install("package_name")
renv::snapshot()
```


## Installation & Dev

If you want to run local or extend you can do so by pulling the repo, then either setup the project for development locally

```r
install.packages("renv")
renv::restore()
```

TODO: Create a Dockerfile fo development

The app can be run in **online** or **offline** mode. Offline is typically used in development and connect to local stored version of the data. The option can be changed the *R/global.R* file. 

>TODO: Find nicer way of passing this argument. 

This requires creating a SQLite db with grab of the data. This is detailed in the *DATA/create_db_table.md* file. 

### Testing 

There are a number of tests provided. To run 

```r
shiny::runTests()
```

## Deployment 

For all deployment, the *R/global.R* file *mode* should be set to **online** - alternatively you need to upload the SQLite db. 

### RStudio ShinyApps

The app can deployed directly from within R Studio to shinyapps.io

### Github Actions

There a Github Action setup in the repo, this pushes to shinyapps.io on a pull request to the *master* branch. It can also be activated manually. The structure of the workflow is below. You need to add the **secrets** in the github repo. 

```yaml
jobs:
  deploy-shiny:
    runs-on: macOS-latest
    steps:
      - uses: actions/checkout@v2
      - uses: r-lib/actions/setup-r@master
      - name: install-packages
        run: |
         Rscript -e "install.packages(c('renv'), type  = 'binary')"
         Rscript -e "renv::restore()"
      - name: authorise-shiny
        run: |
         Rscript -e "rsconnect::setAccountInfo(name='yourAccount', token=${{secrets.SHINYAPPS_TOKEN}}, secret=${{secrets.SHINYAPPS_SECRET}})"
         Rscript -e "rsconnect::deployApp(appName = 'yourAppName')"
```

### Docker

There is a nice guide to dockerising shiny apps [here](https://www.statworx.com/ch/blog/how-to-dockerize-shinyapps/). A Dockerfile is provided. 

Create the docker image

```bash
docker build -t covid-irl-image . 
```

Run the image 

```bash
docker run -d --rm -p 3838:3838 covid-irl-image
```

# TODO

- [x] add tests
- [ ] add Ireland as a "county" 
- [x] write up installation. 
- [x] add data in sqlite for Docker container
- [x] update dockerFile
- [ ] create Docker ignore file 
- [ ] create docker image and publish ?
- [ ] add other countries ?  
- [ ] reduce dependencies
- [ ] add test check to GA

## Blog write up points

- project template
- start with plots
- then modules
- then stick it together
- move to tests - note on naming convention, need to change the test file, helper functions. 
- docker file vs shiny apps.  
- discuss golem as option vs https://shiny.rstudio.com/reference/shiny/1.5.0/shinyAppTemplate.html
- make sure that the secrets are setup with '', you have a unique secret for this computer ? will it work a second time 