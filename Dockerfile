# guide from https://www.statworx.com/ch/blog/how-to-dockerize-shinyapps/ 
# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest 

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

## update system libraries
##RUN apt-get update && \
##    apt-get clean
##    apt-get upgrade -y && \

#copy the renv stuff and setup, this is timley so should happen for other changes to save on rebuilds
RUN Rscript -e 'install.packages("renv")'
COPY renv.lock .

#restore the packages. This takes time so try not do too often. 
RUN Rscript -e 'renv::restore()'

# copy R files
COPY app.R . app/
COPY R/ . app/

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('app/app.R', host = '0.0.0.0', port = 3838)"]