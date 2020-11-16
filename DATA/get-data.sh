#!/bin/sh
curl "https://storage.covid19datahub.io/data-1.csv" | sqlite-utils insert --csv DATA/covid.db data1 -
curl "https://storage.covid19datahub.io/data-2.csv" | sqlite-utils insert --csv DATA/covid.db data2 -
#curl "https://storage.covid19datahub.io/data-3.csv" | sqlite-utils insert --csv covid.db data3 -

