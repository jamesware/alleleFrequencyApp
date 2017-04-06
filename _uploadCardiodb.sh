#!bin/bash

#webFiles=`ls | grep -v uploadCardiodb | grep -v Rproj`
#rsync -r --delete-after --delete-excluded \'$webFiles\' cardiodb:/srv/shiny-server/sample-apps/alleleFrequencyApp

rsync -r --exclude _uploadCardiodb.sh --exclude '^.*' --exclude '*.Rproj' --exclude rsconnect --delete-after --delete-excluded . cardiodb:/srv/shiny-server/sample-apps/alleleFrequencyApp