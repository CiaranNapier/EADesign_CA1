#!/bin/bash

# This script uses bash via WSL to connect to minikube running on windows
# This is why .exe files are called

currentseccon=2000
currentdoor=10

seccon_array=(500 1000 4000 8000)
door_array=(20 500 1000 1100)

DATE=$(date | tr ' ' '_' | tr ':' '-')
async_endpoint="http://127.0.0.1:61555/"

#Call fucntion 10 times, get avg response
for x in "${seccon_array[@]}"
do
    for y in "${door_array[@]}"
    do
        echo $y
        echo $x
        kubectl.exe get deployment door1-deployment -o yaml | sed "s/$currentdoor/$y/g" > door_temp.yaml
        kubectl.exe get deployment seccon-deployment -o yaml | sed "s/$currentseccon/$x/g" > seccon_temp.yaml

        kubectl.exe apply -f seccon_temp.yaml && sleep 10
        kubectl.exe apply -f door_temp.yaml && sleep 10

        for i in {1..10}
        do
            outfile="results_${x}_${y}"
            curl $async_endpoint -s -o /dev/null -w "$description connect:%{time_connect}s pretransfer:%{time_pretransfer}s starttransfer:%{time_starttransfer}s total:%{time_total}\n" >> $outfile
            currentseccon=${x}
            currentdoor=${y}

        done
    done
done
