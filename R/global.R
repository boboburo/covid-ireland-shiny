#Load the latest daily cases 
#The value is set to online in github and thereafter global.R added to .gitignore

run_mode = "online"

if(run_mode == "online"){
  dailycases <- load_covid_ireland(src = "online_csv")
}
  
if(run_mode == "offline") {
  dailycases <- load_covid_ireland(src = "offline_sqlite")
}
  

