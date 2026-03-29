BEGIN{
	option = ARGV[2]
	delete ARGV[2]
	FS= ","
	max_age = 0
	sum_age = 0
	business = 0
}

{
	if (NR > 1 && $0 != ""){
		sub(/\r/, "",$4)
		if($4 != ""){
		carriage[$4] = 1
		}
		
		total++

		if($2 > max_age){
        	max_age = $2
        	oldest = $1
	        }	
		
		sum_age += $2

		if($3 == "Business"){
		business++
		}
	}
}

END{
	if(option == "a"){
		print "Jumlah seluruh penumpang KANJ adalah ", total, "orang"
		}
	else if(option == "b"){
		count = 0
		for(i in carriage){
		count++
		}
		print "Jumlah gerbong penumpang KANJ adalah", count
		}
	else if(option == "c"){
		print oldest, "adalah penumpang tertua dengan usia", max_age, "tahun"
		}
	else if(option == "d"){
		avg = int(sum_age / total)
		print "Rata-rata usia penumpang adalah", avg, "tahun"
		}
	else if(option == "e"){
		print "Jumlah penumpang business class ada", business, "orang"
		}
	else{
		print "error, hanya bisa opsi a/b/c/d/e"
		}
}
