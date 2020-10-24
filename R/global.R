#Load the latest daily cases 

run_mode = "offline"

if(run_mode == "online"){
  dailycases <- load_covid_ireland(src = "online_csv")
}
  
if(run_mode == "offline") {
  dailycases <- load_covid_ireland(src = "offline_sqlite")
}
  

