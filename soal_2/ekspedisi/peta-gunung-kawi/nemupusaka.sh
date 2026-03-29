#!/bin/bash

# Cara ini lebih sakti karena awk nyari ID-nya langsung tanpa peduli spasi/koma
awk -F", " '
$1 == "node_001" {lat1=$3; lon1=$4}
$1 == "node_003" {lat2=$3; lon2=$4}
END {
    if (lat1 && lat2) {
        mid_lat = (lat1 + lat2) / 2;
        mid_lon = (lon1 + lon2) / 2;
        printf "Koordinat pusat:\n%.6f, %.6f\n", mid_lat, mid_lon;
    } else {
        print "Wah, node_001 atau node_003 kaga ketemu di titik-penting.txt co!";
    }
}' titik-penting.txt > posisipusaka.txt

# Tampilin hasilnya
cat posisipusaka.txt
