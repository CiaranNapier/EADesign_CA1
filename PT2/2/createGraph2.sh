#!/bin/bash

endpoint="https://europe-west1-linear-outcome-275719.cloudfunctions.net/CA1-2_1"
FILES=results*

for f in $FILES
do
    sum=0
    input=${f}
    while IFS= read -r line
    do
        resp=$(echo "$line" | cut -d ' ' -f5 | cut -d ':' -f2)
        echo ${resp}
        sum=$(echo ${sum} + ${resp} | bc)
        done < "$input"
        
        avg=$(echo $sum / 10 | bc -l)
        echo $avg > "avg_${f}.txt"

done

avg1=$(cat avg_results_500_20.txt)
avg2=$(cat avg_results_500_500.txt)
avg3=$(cat avg_results_500_1000.txt)
avg4=$(cat avg_results_500_1100.txt)
avg5=$(cat avg_results_1000_20.txt)
avg6=$(cat avg_results_1000_500.txt)
avg7=$(cat avg_results_1000_1000.txt)
avg8=$(cat avg_results_1000_1100.txt)
avg9=$(cat avg_results_4000_20.txt)
avg10=$(cat avg_results_4000_500.txt)
avg11=$(cat avg_results_4000_1000.txt)
avg12=$(cat avg_results_4000_1100.txt)
avg13=$(cat avg_results_8000_20.txt)
avg14=$(cat avg_results_8000_500.txt)
avg15=$(cat avg_results_8000_1000.txt)
avg16=$(cat avg_results_8000_1100.txt)

curl -k -H "Content-Type: application/json" -X POST -d "{\"filename\":\"resp2-2_test.png\", \"plottype\":\"line\", \"x\":[\"500_20\",\"800_500\",\"500_1000\",\"500_1100\",\"1000_20\",\"1000_500\",\"1000_1000\",\"1000_1100\",\"4000_20\",\"4000_500\",\"4000_1000\",\"4000_1100\",\"8000_20\",\"8000_500\",\"8000_1000\",\"8000_1100\"], \"y\":[\"$avg1\", \"$avg2\", \"$avg3\", \"$avg4\",\"$avg5\",\"$avg6\",\"$avg7\",\"$avg8\",\"$avg9\",\"$avg10\",\"$avg11\",\"$avg12\",\"$avg13\",\"$avg14\",\"$avg15\",\"$avg16\"], \"ylab\":[\"Async Response Times\"]}" "${endpoint}"
