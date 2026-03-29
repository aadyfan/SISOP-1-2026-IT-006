#!/bin/bash

DATA="data/penghuni.csv"
HISTORY="history_penghuni.csv"
LAPORAN="laporan/laporan_bulanan.txt"
LOG="log/tagihan.log"

menu() {
    clear
    echo "===== KOST SLEBEW ====="
    echo "1. Tambah"
    echo "2. Hapus"
    echo "3. Tampilkan"
    echo "4. Update Status"
    echo "5. Laporan"
    echo "6. Cron"
    echo "7. Exit"
}

tambah() {
    read -p "Nama: " nama
    read -p "Kamar: " kamar
    read -p "Harga: " harga
    read -p "Tanggal: " tanggal
    read -p "Status: " status

    echo "$nama,$kamar,$harga,$tanggal,$status" >> $DATA
    echo "Berhasil!"
    read
}

hapus() {
    read -p "Nama: " nama

    awk -F, -v n="$nama" '
    BEGIN{OFS=","}
    NR==1{print; next}
    {
        if($1==n){
            print $0 >> "history_penghuni.csv"
        } else {
            print
        }
    }' $DATA > temp.csv

    mv temp.csv $DATA
    read
}

tampilkan() {
    column -t -s, $DATA
    read
}

update_status() {
    read -p "Nama: " nama
    read -p "Status baru: " status

    awk -F, -v n="$nama" -v s="$status" '
    BEGIN{OFS=","}
    NR==1{print; next}
    {
        if($1==n){$5=s}
        print
    }' $DATA > temp.csv

    mv temp.csv $DATA
    read
}

laporan() {
    awk -F, '
    NR>1 {
        if($5=="Aktif") total+=$3
        else tunggakan+=$3
    }
    END {
        print "Total:", total
        print "Tunggakan:", tunggakan
    }' $DATA

    read
}

cron_job() {
    echo "1. Lihat"
    echo "2. Tambah"
    echo "3. Hapus"
    read -p "Pilih: " c

    case $c in
        1) crontab -l ;;
        2) (crontab -l 2>/dev/null; echo "0 7 * * * bash $(pwd)/kost_slebew.sh --check") | crontab - ;;
        3) crontab -r ;;
    esac
    read
}

if [ "$1" == "--check" ]; then
    awk -F, '
    NR>1 && $5=="Menunggak" {
        print strftime("[%Y-%m-%d %H:%M:%S]"), $1
    }' $DATA >> $LOG
    exit
fi

while true; do
    menu
    read -p "Pilih: " pilih

    case $pilih in
        1) tambah ;;
        2) hapus ;;
        3) tampilkan ;;
        4) update_status ;;
        5) laporan ;;
        6) cron_job ;;
        7) exit ;;
    esac
done
