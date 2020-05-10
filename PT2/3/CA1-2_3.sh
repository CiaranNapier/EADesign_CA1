#!/bin/bash

#Running via bash on WSL using windows minikube so kubectl commands contain .exe

pods="pods.txt"

currenttime=$(date "+%s") && kubectl.exe delete pods --all
sleep 60

kubectl.exe get pods | cut -d ' ' -f1 | sed "/NAME/d" | sed "/redis/d"  > $pods

podlist=${pods}
while IFS= read -r line
do
    podname=$(echo "$line")
    startedat=$(kubectl.exe get pod $podname -o yaml | grep -A 1 running | tail -1 | grep startedAt | cut -d 'T' -f2 | sed "s/Z\"//g")
    startedepoch=$(date -d ${startedat} "+%s")
    startedepoch=$(echo $startedepoch + 3600 | bc) # Account for time difference between minikube and local machine
    startuptime=$(echo $startedepoch - $currenttime | bc)
    echo "Elapsed Startup time for ${podname} is : ${startuptime}" > "${podname}_Startuptime.txt"
  
done < "$podlist"

