#!/bin/bash

DATE=$(date | tr ' ' '_' | tr ':' '-')
async_endpoint="http://127.0.0.1:61555/"
sync_endpoint="http://127.0.0.1:61563/syncdoor"

asyncfile="asyncfile_${DATE}.txt"
syncfile="syncfile_${DATE}.txt"
resultfile="results_${DATE}.txt"

for i in {1..10000}
do
   curl $async_endpoint -s -o /dev/null -w "$description connect:%{time_connect}s pretransfer:%{time_pretransfer}s starttransfer:%{time_starttransfer}s total:%{time_total}\n" >> $asyncfile
   curl $sync_endpoint -s -o /dev/null -w "$description connect:%{time_connect}s pretransfer:%{time_pretransfer}s starttransfer:%{time_starttransfer}s total:%{time_total}\n" >> $syncfile
done

asum=0
asyncinput=${asyncfile}
while IFS= read -r line
do
  asynccount=$(echo "$line" | cut -d ' ' -f5 | cut -d ':' -f2)
  echo ${asynccount}
  asum=$(echo ${asum} + ${asynccount} | bc)
done < "$asyncinput"

echo "Total sum of 10000 async requests : ${asum}" >> ${resultfile}
aavg=$(echo $asum / 10000 | bc -l)
echo "Average ASync Time: ${aavg}" >> ${resultfile}

ssum=0
syncinput=${syncfile}
while IFS= read -r line
do
  synccount=$(echo "$line" | cut -d ' ' -f5 | cut -d ':' -f2)
  echo ${synccount}
  ssum=$(echo ${ssum} + ${synccount} | bc)
done < "$syncinput"

echo "Total sum of 10000 sync requests : ${ssum}" >> ${resultfile}
savg=$(echo $ssum / 10000 | bc -l)
echo "Average Sync Time: ${savg}" >> ${resultfile}