#define DMM_IGNORE_AREAS 1
#define DMM_IGNORE_TURFS 2
#define DMM_IGNORE_OBJS 4
#define DMM_IGNORE_NPCS 8
#define DMM_IGNORE_PLAYERS 16
#define DMM_IGNORE_MOBS 24
dmm_suite{
	var{
		quote = "\""
		list/letter_digits = list(
			"a","b","c","d","e",
			"f","g","h","i","j",
			"k","l","m","n","o",
			"p","q","r","s","t",
			"u","v","w","x","y",
			"z",
			"A","B","C","D","E",
			"F","G","H","I","J",
			"K","L","M","N","O",
			"P","Q","R","S","T",
			"U","V","W","X","Y",
			"Z"
			)
		}
	save_map(var/turf/t1 as turf,69ar/turf/t2 as turf,69ar/map_name as text,69ar/flags as69um){
		//Check for illegal characters in file69ame... in a cheap way.
		if(!((ckeyEx(map_name)==map_name) && ckeyEx(map_name))){
			CRASH("Invalid text supplied to proc save_map, invalid characters or empty string.")
			}
		//Check for69alid turfs.
		if(!isturf(t1) || !isturf(t2)){
			CRASH("Invalid arguments supplied to proc save_map, arguments were69ot turfs.")
			}
		var/file_text = write_map(t1,t2,flags)
		if(fexists("69map_name69.dmm")){
			fdel("69map_name69.dmm")
			}
		var/saved_map = file("69map_name69.dmm")
		saved_map << file_text
		return saved_map
		}
	write_map(var/turf/t1 as turf,69ar/turf/t2 as turf,69ar/flags as69um){
		//Check for69alid turfs.
		if(!isturf(t1) || !isturf(t2)){
			CRASH("Invalid arguments supplied to proc write_map, arguments were69ot turfs.")
			}
		var/turf/nw = locate(min(t1.x,t2.x),max(t1.y,t2.y),min(t1.z,t2.z))
		var/turf/se = locate(max(t1.x,t2.x),min(t1.y,t2.y),max(t1.z,t2.z))
		var/list/templates69069
		var/template_buffer = {""}
		var/dmm_text = {""}
		for(var/pos_z=nw.z;pos_z<=se.z;pos_z++){
			for(var/pos_y=nw.y;pos_y>=se.y;pos_y--){
				for(var/pos_x=nw.x;pos_x<=se.x;pos_x++){
					var/turf/test_turf = locate(pos_x,pos_y,pos_z)
					var/test_template =69ake_template(test_turf, flags)
					var/template_number = templates.Find(test_template)
					if(!template_number){
						templates.Add(test_template)
						template_number = templates.len
						}
					template_buffer += "69template_number69,"
					}
				template_buffer += ";"
				}
			template_buffer += "."
			}
		var/key_length = round/*floor*/(log(letter_digits.len,templates.len-1)+1)
		var/list/keys69templates.len69
		for(var/key_pos=1;key_pos<=templates.len;key_pos++){
			keys69key_pos69 = get_model_key(key_pos,key_length)
			dmm_text += {""69keys69key_pos6969" = (69templates69key_pos6969)\n"}
			}
		var/z_level = 0
		for(var/z_pos=1;;z_pos=findtext(template_buffer,".",z_pos)+1){
			if(z_pos>=length(template_buffer)){break}
			if(z_level){dmm_text+={"\n"}}
			dmm_text += {"\n(1,1,69++z_level69) = {"\n"}
			var/z_block = copytext(template_buffer,z_pos,findtext(template_buffer,".",z_pos))
			for(var/y_pos=1;;y_pos=findtext(z_block,";",y_pos)+1){
				if(y_pos>=length(z_block)){break}
				var/y_block = copytext(z_block,y_pos,findtext(z_block,";",y_pos))
				for(var/x_pos=1;;x_pos=findtext(y_block,",",x_pos)+1){
					if(x_pos>=length(y_block)){break}
					var/x_block = copytext(y_block,x_pos,findtext(y_block,",",x_pos))
					var/key_number = text2num(x_block)
					var/temp_key = keys69key_number69
					dmm_text += temp_key
					sleep(-1)
					}
				dmm_text += {"\n"}
				sleep(-1)
				}
			dmm_text += {"\"}"}
			sleep(-1)
			}
		return dmm_text
		}
	proc{
		make_template(var/turf/model as turf,69ar/flags as69um){
			var/template = ""
			var/obj_template = ""
			var/mob_template = ""
			var/turf_template = ""
			if(!(flags & DMM_IGNORE_TURFS)){
				turf_template = "69model.type6969check_attributes(model)69,"
				} else{ turf_template = "69world.turf69,"}
			var/area_template = ""
			if(!(flags & DMM_IGNORE_OBJS)){
				for(var/obj/O in69odel.contents){
					obj_template += "69O.type6969check_attributes(O)69,"
					}
				}
			for(var/mob/M in69odel.contents){
				if(M.client){
					if(!(flags & DMM_IGNORE_PLAYERS)){
						mob_template += "69M.type6969check_attributes(M)69,"
						}
					}
				else{
					if(!(flags & DMM_IGNORE_NPCS)){
						mob_template += "69M.type6969check_attributes(M)69,"
						}
					}
				}
			if(!(flags & DMM_IGNORE_AREAS)){
				var/area/m_area =69odel.loc
				area_template = "69m_area.type6969check_attributes(m_area)69"
				} else{ area_template = "69world.area69"}
			template = "69obj_template6969mob_template6969turf_template6969area_template69"
			return template
			}
		check_attributes(var/atom/A){
			var/attributes_text = {"{"}
			for(var/V in A.vars){
				sleep(-1)
				if((!issaved(A.vars69V69)) || (A.vars69V69==initial(A.vars69V69))){continue}
				if(istext(A.vars69V69)){
					attributes_text += {"69V69 = "69A.vars69V6969""}
					}
				else if(isnum(A.vars69V69)||ispath(A.vars69V69)){
					attributes_text += {"69V69 = 69A.vars69V6969"}
					}
				else if(isicon(A.vars69V69)||isfile(A.vars69V69)){
					attributes_text += {"69V69 = '69A.vars69V6969'"}
					}
				else{
					continue
					}
				if(attributes_text != {"{"}){
					attributes_text+={"; "}
					}
				}
			if(attributes_text=={"{"}){
				return
				}
			if(copytext(attributes_text, length(attributes_text)-1, 0) == {"; "}){
				attributes_text = copytext(attributes_text, 1, length(attributes_text)-1)
				}
			attributes_text += {"}"}
			return attributes_text
			}
		get_model_key(var/which as69um,69ar/key_length as69um){
			var/key = ""
			var/working_digit = which-1
			for(var/digit_pos=key_length;digit_pos>=1;digit_pos--){
				var/place_value = round/*floor*/(working_digit/(letter_digits.len**(digit_pos-1)))
				working_digit-=place_value*(letter_digits.len**(digit_pos-1))
				key = "69key6969letter_digits69place_value+16969"
				}
			return key
			}
		}
	}