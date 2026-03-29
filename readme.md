# SISOP-1-2026-IT-006

**NAMA:** ABHISTA ATHALLAH DYFAN
**NRP:** 5027251006

_Soal 1 - ARGO NGAWI JESGEJES_

**Penjelasan :**

Yang pertama membuat directory soal_1, dan touch file passenger.csv dan KANJ.sh, passenger.csv adalah data penumpang dan KANJ.sh adalah script untuk menampilkan pengolahan data.

Langkah A : mencari total penumpang yang ada di kereta 
disini menghitung jumlah baris dalam data tanpa header menggunakan variabel 'total++'
```
if (NR > 1){
   total++ 
   }
```
Lalu buat output
```
if(option == "a"){
                print "Jumlah seluruh penumpang KANJ adalah ", total, "orang"
                }
```

Langkah B : mencari total gerbong kereta
dilakukan dengan menghitung jumlah $4 yang ada tanpa header ("Gerbong") menggunakan
```
if($4 != ""){
   carriage[$4] = 1
} 
```
menghilangkan \r di setiap baris menggunakan 
```
sub(/\r/, "",$4)
```
dan menggunakan associative array untuk menghitung setiap gerbong
```
if($4 != ""){
   carriage[$4] = 1
}
```
lalu membuat output yang menghitung semua array yang terisi 
```
else if(option == "b"){
                count = 0
                for(i in carriage){
                count++
                }
                print "Jumlah gerbong penumpang KANJ adalah", count
                }
```

Langkah C : mencari penumpang tertua
membuat variabel "max_age" untuk umur tertua lalu membuat fungsi jika setiap $2 lebih besar dari max_age, maka max_age adalah $2 terbaru dan oldest (tertua) diisi $1 yang berupa nama
```
 if($2 > max_age){
        max_age =$2
        oldest = $1
        }
```
lalu membuat output
```
 else if(option == "c"){
                print oldest, "adalah penumpang tertua dengan usia", max_age, "tahun"
                }  

```

Langkah D : mencari rata-rata usia penumpang
membuat variabel "sum_age" untuk menghitung total usia dari seluruh penumpang dan menambahkannya satu per satu
```
sum_age += $2
```
setelah itu membuat output yang mana hasil dari sum_age dibagi dengan total
```
 else if(option == "d"){
                avg = int(sum_age / total)
                print "Rata-rata usia penumpang adalah", avg, "tahun"
                }
```

Langkah E : menghitung penumpang yang ada di kelas bisnis
membuat variabel "business", lalu menghitung setiap $3 yang berisi kelas bisnis
```
if($3 == "Business"){  
        business++
}
```
dan membuat output
```
  else if(option == "e"){
                print "Jumlah penumpang business class ada", business, "orang"
                }
```
yang terakhir membuat error jika opsi selain a/b/c/d/e
```
	else{
		print "error, hanya bisa opsi a/b/c/d/e"
		}
```


**HASIL OUTPUT**


<img width="732" height="221" alt="Screenshot 2026-03-25 at 11 23 29" src="https://github.com/user-attachments/assets/115d209f-c872-4f9b-ab9e-00909d66bc61" />








_soal_2 - EKSPEDISI PESUGIHAN GUNUNG KAWI - MAS AMBA_

**Penjelasan:**

Melakukan proses pencarian lokasi pusaka berdasarkan data koordinat yang didapat dari file JSON, lalu melakukan pengunduhan data, parsing file JSON, dan perhitungan titik tengah dari koordinat yang tersedia.

Langkah 1A: setup virtual environment
membuat virtual environment untuk menghindari konflik dependensi, kemudian menginstall gdown.
```
python3 -m venv venv_amba
source venv_amba/bin/activate
pip install gdown
```

Langkah 1B: download dan analisa file pdf petunjuk
download pdf menggunakan gdown dari link google drive pdf peta-ekspedisi-mba.pdf
```
gdown --id 1q10pHSC3KFfvEiCN3V6PTroPR7YGHF6Q
```
setelah download, membaca isi file menggunakan metode concatonate 
```
cat peta-ekspedisi-amba.pdf
```

Langkah 1C: clone repository
dari hasi cat peta-ekspedisi-amba.pdf didapatkan link repository github dan melakukan clone
```
git clone (https://github.com/pocongcyber77/peta-gunung-kawi.git)
```

Langkah 1D: mendapat file baru dari clone github tersebut
membuka folder hasil clone dan melihat isi nya
```
cd peta-gunung-kawi
ls
```
didapatkan ada file gsxtrack.json

Langkah 2A: mengambil data koordinat
membuat file parserkoordinat.sh  
```
#!/bin/bash

grep -E "id|site_name|latitude|longitude" gsxtrack.json | sed 's/[," ]//g' | awk '
{
    if ($1 == "id:") id = $2
    if ($1 == "site_name:") name = $2
    if ($1 == "latitude:") lat = $2
    if ($1 == "longitude:") {
        lon = $2
        printf "%s, %s, %s, %s\n", id, name, lat, lon
    }
}' > titik-penting.txt

echo "File titik-penting.txt berhasil dibuat!"
```
mengambil data id, site_name, latitude, dan longtitude menggunankan grep
```
grep -E "id|site_name|latitude|longitude" gsxtrack.json
```
membersihkan karakter koma, tanda kutip, dan spasi menggunakan sed
```
sed 's/[," ]//g'
```
mengolah data menggunakan awk dan menyimpan ke file titik-penting.txt
```
 awk '
{
    if ($1 == "id:") id = $2
    if ($1 == "site_name:") name = $2
    if ($1 == "latitude:") lat = $2
    if ($1 == "longitude:") {
        lon = $2
        printf "%s, %s, %s, %s\n", id, name, lat, lon
    }
}' > titik-penting.txt

```
lalu jalankan
```
./parserkoordinat.sh
```

Langkah 2B: mencari titik pusaka
pada langkah ini sudah diperoleh file titik-penting.txt, berdasarkan pola data, diketahui bahwa koordinat membentuk persegi, sehingga titik pusat dapat ditentukan dengan mengambil dua titik diagonal, node_001 dan node_003, kemudian dihitung titik tengah dari kedua koordinat tersebut

membuat file nemupusaka.sh 
```
#!/bin/bash

awk -F", " '
$1 == "node_001" {lat1=$3; lon1=$4}
$1 == "node_003" {lat2=$3; lon2=$4}
END {
    if (lat1 && lat2) {
        mid_lat = (lat1 + lat2) / 2;
        mid_lon = (lon1 + lon2) / 2;
        printf "Koordinat pusat:\n%.6f, %.6f\n", mid_lat, mid_lon;
    } else {
        print "Data tidak lengkap";
    }
}' titik-penting.txt > posisipusaka.txt

cat posisipusaka.txt
```
memisahkan tiap data melalui koma dan spasi
```
awk -F", " 
```
ambil data dari node_001 di titik-penting.txt, $3 disimpan ke lat_1 dan $4 disimpan ke lon_1
```
$1 == "node_001" {lat1=$3; lon1=$4}
```
ambil data dari node_003 di titik-penting.txt, $3 disimpan ke lat_2 dan $4 disimpan ke lon_3
```
$1 == "node_003" {lat2=$3; lon2=$4}
```
jika sudah ada lat1 dan lat 2, hitung titik tengah menggunakan rumus yang tersedia lalu di tampilkan
```
 if (lat1 && lat2) {
        mid_lat = (lat1 + lat2) / 2;
        mid_lon = (lon1 + lon2) / 2;
        printf "Koordinat pusat:\n%.6f, %.6f\n", mid_lat, mid_lon;
    }
```
jika data belum ada tampilkan data tidak lengkap
```
else {
        print "Data tidak lengkap";
    }
```
lalu simpan ke file posisipusaka.txt dan menampilkan isinya
```
> posisipusaka.txt

cat posisipusaka.txt
```

lalu jalankan
```
./nemupusaka.sh
```
dan outputnya adalah isi dri posisipusaka.txt, yaitu
```
Koordinat pusat:
-7.928980, 112.459050
```

**HASIL OUTPUT**

<img width="821" height="124" alt="Screenshot 2026-03-26 at 12 35 10" src="https://github.com/user-attachments/assets/80442281-00d0-4d16-a4bd-97124ce07461" />

_soal_3 - sistem manajemen kost slebew_

**Penjelasan :**

membuat sebuah program berbasis CLI (Command Line Interface) menggunakan Bash Script dan AWK untuk membantu pengelolaan kost slebew yang memiliki fitur manajemen data penghuni, update status pembayaran, laporan keuangan, otomatisasi pengecekan tagihan menggunakan cron, menu interaktif yang berjalan secara looping

1. Membuat Struktur Folder dan File
Langkah pertama adalah membuat direktori dan file yang dibutuhkan:

```
bash
mkdir -p soal_3/data soal_3/log soal_3/rekap soal_3/sampah
cd so
touch kost_slebew.sh data/penghuni.csv sampah/history_penghuni.csv log/tagihan.log rekap/laporan_bulanan.txt
```

2. Membuat Format Database CSV
File `penghuni.csv` digunakan sebagai penyimpanan data:
```
Nama,Kamar,Harga,TanggalMasuk,Status
```
Format ini digunakan agar data dapat diproses menggunakan AWK.

3. Membuat Menu Interaktif
Program dibuat menggunakan looping:
```
while true
```

Sehingga menu akan terus berjalan sampai user memilih keluar.

**Implementasi Fitur**

1. Tambah Penghuni

Pada fitur ini, user dapat menambahkan data penghuni baru.

Langkah:

* Input data menggunakan `read`
* Simpan ke file CSV

```
echo "$nama,$kamar,$harga,$tanggal,$status" >> data/penghuni.csv
```

2. Hapus Penghuni
Fitur ini digunakan untuk menghapus data penghuni berdasarkan nama.

Namun data tidak langsung dihapus, melainkan:

* Dipindahkan ke file `sampah/history_penghuni.csv`
* Dihapus dari file utama

Menggunakan AWK:

```
if($1==n){
    print $0 >> "sampah/history_penghuni.csv"
}
```

---

3. Tampilkan Penghuni

Menampilkan seluruh data penghuni dengan format rapi menggunakan:

```
column -t -s, data/penghuni.csv
```

4. Update Status

Fitur ini digunakan untuk mengubah status penghuni (Aktif / Menunggak).

Menggunakan AWK untuk mengubah kolom ke-5:

```bash
if($1==n){
    $5=s
}
```

Fitur ini penting karena mempengaruhi laporan keuangan.

5. Laporan Keuangan

Menghitung total:

* Pemasukan (status Aktif)
* Tunggakan (status Menunggak)

```bash
if($5=="Aktif") total += $3
else tunggakan += $3
```

Hasil disimpan ke:

```bash
rekap/laporan_bulanan.txt
```

6. Kelola Cron

Digunakan untuk otomatisasi pengecekan tagihan.

Fitur:

* Melihat cron aktif
* Menambah / update cron
* Menghapus cron

Implementasi:

```bash
echo "0 7 * * * bash $(pwd)/kost_slebew.sh --check-tagihan" | crontab -
```

Penjelasan:

* Cron dijalankan setiap hari pukul 07:00
* Menggunakan sistem overwrite agar tidak terjadi duplikasi

---

7. Pengecekan Tagihan Otomatis

Dijalankan menggunakan parameter:

```bash
./kost_slebew.sh --check-tagihan
```

Menggunakan AWK untuk mencari penghuni dengan status menunggak:

```bash
NR>1 && $5=="Menunggak"
```

Hasil dicatat ke file:

```bash
log/tagihan.log
```














