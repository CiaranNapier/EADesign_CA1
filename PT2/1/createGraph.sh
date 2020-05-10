#!/bin/bash

resultsfile="results_Sat_May__9_17-13-38_IST_2020.txt"
endpoint="https://europe-west1-linear-outcome-275719.cloudfunctions.net/CA1-2_1"

syncavg=$( cat ${resultsfile} | grep "Average Sync Time" | cut -d ':' -f2 | sed 's/^ *//g')
asyncavg=$( cat ${resultsfile} | grep "Average ASync Time" | cut -d ':' -f2 | sed 's/^ *//g')



curl -k -H "Content-Type: application/json" -X POST -d "{\"filename\":\"averages.png\", \"plottype\":\"bar\", \"x\":[\"Sync\", \"Async\"], \"y\":[\"${syncavg}\", \"${asyncavg}\"], \"ylab\":\"Average Total Response times\"}" "${endpoint}"