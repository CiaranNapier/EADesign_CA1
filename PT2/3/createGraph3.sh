#!/bin/bash

endpoint="https://europe-west1-linear-outcome-275719.cloudfunctions.net/CA1-2_1"

asyncdoor=$(cat door1-deployment-67dd56b68d-s62sx_Startuptime.txt | cut -d ':' -f2 | sed "s/ //g")
asyncseccon=$(cat seccon-deployment-7b4b77cd8-svzft_Startuptime.txt | cut -d ':' -f2 | sed "s/ //g")
syncdoor=$(cat syncdoor-deployment-58db4cc6b4-dt9gj_Startuptime.txt | cut -d ':' -f2 | sed "s/ //g")
syncdoorseccon=$(cat syncdoorseccon-deployment-cdb84dbc7-mxxcf_Startuptime.txt | cut -d ':' -f2 | sed "s/ //g")

curl -k -H "Content-Type: application/json" -X POST -d "{\"filename\":\"restart2-3.png\", \"plottype\":\"bar\", \"x\":[\"Async Door\",\"Async Seccon\",\"Sync Door\",\"Sync Seccon\"], \"y\":[\"$asyncdoor\", \"$asyncseccon\", \"$syncdoor\", \"$syncdoorseccon\"], \"ylab\":\"Restart Times\"}" "${endpoint}"