#!/bin/bash

MODE=$1

ATTACKS=("normal" "dos" "occupancy")
STATIONS=(2 10 20)
DISTANCES=(1 20)
MCS_VALUES=(3 7 11)
CHANNELS=(20 80 160)
GIS=(800 3200)
SIM_TIMES=(5 10 20)

if [ "$MODE" == "quick" ]; then
    STATIONS=(2)
    DISTANCES=(1)
    MCS_VALUES=(7)
    CHANNELS=(80)
    GIS=(800)
fi

COUNT=1
RESUME_FROM=443

for attack in "${ATTACKS[@]}"
do

    if [ "$attack" == "normal" ]; then
        INTENSITIES=("none")
    else
        INTENSITIES=("low" "medium" "high" "extreme")
    fi

    for intensity in "${INTENSITIES[@]}"
    do
        for stations in "${STATIONS[@]}"
        do
            for distance in "${DISTANCES[@]}"
            do
                for mcs in "${MCS_VALUES[@]}"
                do
                    for channel in "${CHANNELS[@]}"
                    do
                        for gi in "${GIS[@]}"
                        do
                            if [ $COUNT -lt $RESUME_FROM ]; then
                                COUNT=$((COUNT+1))
                                continue
                            fi
                            echo "===================================="
                            echo "Scenario $COUNT"
                            echo "Attack      : $attack"
                            echo "Intensity   : $intensity"
                            echo "Stations    : $stations"
                            echo "Distance    : $distance"
                            echo "MCS         : $mcs"
                            echo "Channel     : $channel"
                            echo "GI          : $gi"
                            echo "===================================="

                            cd ~/ns-allinone-3.44/ns-3.44

                            ./ns3 run "scratch/wifi7_mlo/wifi_security_attack \
                            --attack=$attack \
                            --attackIntensity=$intensity \
                            --nStations=$stations \
                            --distance=$distance \
                            --mcs=$mcs \
                            --channelWidth=$channel \
                            --guardInterval=$gi"
                            COUNT=$((COUNT+1))

                        done
                    done
                done
            done
        done
    done
done
