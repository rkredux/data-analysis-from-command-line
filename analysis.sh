#Capital Bike Share data analysis from Command Line
#Download Bikeshare system data from link below
#https://s3.amazonaws.com/capitalbikeshare-data/index.html


#Concatenating the data 
awk 'FNR > 1' *.csv > consolidated.csv && awk -F, 'BEGIN { print  "Duration,Start date,End date,Start station number,Start station,End station number,End station,Bike number,Member type" } { print $0 }' OFS=, consolidated.csv |  sed 's/"//g' > clean.csv

#Check the file header 
head -2 clean.csv 

#hours driven by casual riders 
awk -F, '$9 == "Casual" { duration = duration + $1; } END {print duration/3600,"hrs";}'  clean.csv

#hours driven by members 
awk -F, '$9 == "Member" { duration = duration + $1; } END {print duration/3600,"hrs";}'  clean.csv

#month with most number of rides 
wc -l *.csv | sort -r -n | awk 'NR > 2 { print }'

#longest duration of bike ride 
echo "The Longest duration for which a bike was in use is `sort -k1 -n -r clean.csv | head -1 | awk '{ print $1/3600,"hrs"}'`"

#Bike ride with that longest duration
sortk -k1 -n -r clean.csv | head -1

#Top 3 busiest station from where bikes get taken out the most 
awk -F, '{ print $5 }' clean.csv | sort | uniq -c | sort -k1 -r -n | head -3

#Top 3 busiest station from where bikes get returned to the most 
awk -F, '{ print $7 }' clean.csv | sort | uniq -c | sort -k1 -r -n | head -3

#Top 10 busiest days in the year
awk -F, 'NR > 1{ print $2 }' clean.csv | awk '{ print $1}' | sort | uniq -c | sort -k1 -r -n | head -10

#Search bike trip history by start and end station names 
awk -F, '$5 == "Henry Bacon Dr & Lincoln Memorial Circle NW" && $7 == "Market Square / King St & Royal St" { print $0 }' clean.csv