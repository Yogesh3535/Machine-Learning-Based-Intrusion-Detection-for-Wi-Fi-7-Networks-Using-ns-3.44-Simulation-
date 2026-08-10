#!/bin/bash

rm -f results/normal.csv

for stations in 2 4 6 8
do
    for distance in 1 5 10 20
    do
        for payload in 500 700 900 1200 1500
        do
            echo "Stations=$stations Distance=$distance Payload=$payload"

            ./ns3 run "scratch/wifi7_mlo/wifi_security_project \
                --attack=normal \
                --nStations=$stations \
                --distance=$distance \
                --payloadSize=$payload"

        done
    done
done

echo "Dataset generation completed."
