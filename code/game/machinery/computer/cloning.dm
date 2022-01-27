/obj/machinery/computer/clonin69
	name = "clonin69 control console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	li69ht_color = COLOR_LI69HTIN69_69REEN_MACHINERY
	re69_access = list(access_heads) //Only used for record deletion ri69ht now.
	var/obj/machinery/dna_scannernew/scanner //Linked scanner. For scannin69.
	var/list/pods = list() //Linked clonin69 pods.
	var/temp = ""
	var/scantemp = "Scanner unoccupied"
	var/menu = 1 //Which69enu screen to display
	var/list/records = list()
	var/datum/dna2/record/active_record
	var/obj/item/disk/data/diskette //Mostly so the 69eneticist can steal everythin69.
	var/loadin69 = 0 // Nice loadin69 text

/obj/machinery/computer/clonin69/Initialize()
	. = ..()
	set_extension(src, /datum/extension/multitool, /datum/extension/multitool/cryo, list(/proc/is_operable))
	updatemodules()

/obj/machinery/computer/clonin69/Destroy()
	releasecloner()
	return ..()

/obj/machinery/computer/clonin69/proc/updatemodules()
	src.scanner = findscanner()
	releasecloner()
	findcloner()

/obj/machinery/computer/clonin69/proc/findscanner()
	var/obj/machinery/dna_scannernew/scannerf = null

	//Try to find scanner on adjacent tiles first
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		scannerf = locate(/obj/machinery/dna_scannernew, 69et_step(src, dir))
		if (scannerf)
			return scannerf

	//Then look for a free one in the area
	if(!scannerf)
		var/area/A = 69et_area(src)
		for(var/obj/machinery/dna_scannernew/S in A.69et_contents())
			return S

	return

/obj/machinery/computer/clonin69/proc/releasecloner()
	for(var/obj/machinery/clonepod/P in pods)
		P.connected = null
		P.name = initial(P.name)
	pods.Cut()

/obj/machinery/computer/clonin69/proc/connect_pod(var/obj/machinery/clonepod/P)
	if(P in pods)
		return 0

	if(P.connected)
		P.connected.release_pod(P)
	P.connected = src
	pods += P
	rename_pods()

	return 1

/obj/machinery/computer/clonin69/proc/release_pod(var/obj/machinery/clonepod/P)
	if(!(P in pods))
		return

	P.connected = null
	P.name = initial(P.name)
	pods -= P
	rename_pods()
	return 1

/obj/machinery/computer/clonin69/proc/rename_pods()
	for(var/i = 1 to pods.len)
		var/atom/P = pods69i69
		P.name = "69initial(P.name)69 #69i69"

/obj/machinery/computer/clonin69/proc/findcloner()
	var/num = 1
	var/area/A = 69et_area(src)
	for(var/obj/machinery/clonepod/P in A.69et_contents())
		if(!P.connected)
			pods += P
			P.connected = src
			P.name = "69initial(P.name)69 #69num++69"

/obj/machinery/computer/clonin69/attackby(obj/item/W,69ob/user)
	if (istype(W, /obj/item/disk/data)) //INSERT SOME DISKETTES
		if (!src.diskette)
			user.drop_item()
			W.loc = src
			src.diskette = W
			to_chat(user, "You insert 69W69.")
			src.updateUsrDialo69()
			return
	else
		..()
	return

/obj/machinery/computer/clonin69/attack_hand(mob/user)
	if(..())
		return
	user.set_machine(src)
	add_fin69erprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()

	var/dat = "<h3>Clonin69 System Control</h3>"
	dat += "<font size=-1><a href='byond://?src=\ref69src69;refresh=1'>Refresh</a></font>"

	dat += "<br><tt>69temp69</tt><br>"

	switch(src.menu)
		if(1)
			//69odules
			dat += "<h4>Modules</h4>"
			//dat += "<a href='byond://?src=\ref69src69;relmodules=1'>Reload69odules</a>"
			if (isnull(src.scanner))
				dat += " <font color=red>DNA scanner not found.</font><br>"
			else
				dat += " <font color=69reen>DNA scanner found.</font><br>"
			if (pods.len)
				dat += " <font color=69reen>69pods.len69 clonin6969at\s found.</font><br>"
			else
				dat += " <font color=red>No clonin6969ats found.</font><br>"

			// Scanner
			dat += "<h4>Scanner Functions</h4>"

			if(loadin69)
				dat += "<b>Scannin69...</b><br>"
			else
				dat += "<b>69scantemp69</b><br>"

			if (isnull(src.scanner))
				dat += "No scanner connected!<br>"
			else
				if (src.scanner.occupant)
					if(scantemp == "Scanner unoccupied") scantemp = "" // Stupid check to remove the text

					dat += "<a href='byond://?src=\ref69src69;scan=1'>Scan - 69src.scanner.occupant69</a><br>"
				else
					scantemp = "Scanner unoccupied"

				dat += "Lock status: <a href='byond://?src=\ref69src69;lock=1'>69src.scanner.locked ? "Locked" : "Unlocked"69</a><br>"

			if (pods.len)
				for (var/obj/machinery/clonepod/pod in pods)
					dat += "69pod69 biomass: <i>69pod.biomass69</i><br>"

			// Database
			dat += "<h4>Database Functions</h4>"
			dat += "<a href='byond://?src=\ref69src69;menu=2'>View Records</a><br>"
			if (src.diskette)
				dat += "<a href='byond://?src=\ref69src69;disk=eject'>Eject Disk</a>"


		if(2)
			dat += "<h4>Current records</h4>"
			dat += "<a href='byond://?src=\ref69src69;menu=1'>Back</a><br><br>"
			for(var/datum/dna2/record/R in src.records)
				dat += "<li><a href='byond://?src=\ref69src69;view_rec=\ref69R69'>69R.dna.real_name69</a></li>"

		if(3)
			dat += "<h4>Selected Record</h4>"
			dat += "<a href='byond://?src=\ref69src69;menu=2'>Back</a><br>"

			if (!src.active_record)
				dat += "<font color=red>ERROR: Record not found.</font>"
			else
				dat += {"<br><font size=1><a href='byond://?src=\ref69src69;del_rec=1'>Delete Record</a></font><br>
					<b>Name:</b> 69src.active_record.dna.real_name69<br>"}
				var/obj/item/implant/health/H = null
				if(src.active_record.implant)
					H=locate(src.active_record.implant)

				if ((H) && (istype(H)))
					dat += "<b>Health:</b> 69H.sensehealth()69 | OXY-BURN-TOX-BRUTE<br>"
				else
					dat += "<font color=red>Unable to locate implant.</font><br>"

				if (!isnull(src.diskette))
					dat += "<a href='byond://?src=\ref69src69;disk=load'>Load from disk.</a>"

					dat += " | Save: <a href='byond://?src=\ref69src69;save_disk=ue'>UI + UE</a>"
					dat += " | Save: <a href='byond://?src=\ref69src69;save_disk=ui'>UI</a>"
					dat += " | Save: <a href='byond://?src=\ref69src69;save_disk=se'>SE</a>"
					dat += "<br>"
				else
					dat += "<br>" //Keepin69 a line empty for appearances I 69uess.

				dat += {"<b>UI:</b> 69src.active_record.dna.uni_identity69<br>
				<b>SE:</b> 69src.active_record.dna.struc_enzymes69<br><br>"}

				if(pods.len)
					dat += {"<a href='byond://?src=\ref69src69;clone=\ref69src.active_record69'>Clone</a><br>"}

		if(4)
			if (!src.active_record)
				src.menu = 2
			dat = "69src.temp69<br>"
			dat += "<h4>Confirm Record Deletion</h4>"

			dat += "<b><a href='byond://?src=\ref69src69;del_rec=1'>Scan card to confirm.</a></b><br>"
			dat += "<b><a href='byond://?src=\ref69src69;menu=3'>No</a></b>"


	user << browse(dat, "window=clonin69")
	onclose(user, "clonin69")
	return

/obj/machinery/computer/clonin69/Topic(href, href_list)
	if(..())
		return 1

	if(loadin69)
		return

	if ((href_list69"scan"69) && (!isnull(src.scanner)))
		scantemp = ""

		loadin69 = 1
		src.updateUsrDialo69()

		spawn(20)
			src.scan_mob(src.scanner.occupant)

			loadin69 = 0
			src.updateUsrDialo69()


		//No lockin69 an open scanner.
	else if ((href_list69"lock"69) && (!isnull(src.scanner)))
		if ((!src.scanner.locked) && (src.scanner.occupant))
			src.scanner.locked = 1
		else
			src.scanner.locked = 0

	else if (href_list69"view_rec"69)
		src.active_record = locate(href_list69"view_rec"69)
		if(istype(src.active_record,/datum/dna2/record))
			if ((isnull(src.active_record.ckey)))
				69del(src.active_record)
				src.temp = "ERROR: Record Corrupt"
			else
				src.menu = 3
		else
			src.active_record = null
			src.temp = "Record69issin69."

	else if (href_list69"del_rec"69)
		if ((!src.active_record) || (src.menu < 3))
			return
		if (src.menu == 3) //If we are69iewin69 a record, confirm deletion
			src.temp = "Delete record?"
			src.menu = 4

		else if (src.menu == 4)
			var/obj/item/card/id/C = usr.69et_active_hand()
			if (istype(C)||istype(C, /obj/item/modular_computer/pda))
				if(src.check_access(C))
					src.records.Remove(src.active_record)
					69del(src.active_record)
					src.temp = "Record deleted."
					src.menu = 2
				else
					src.temp = "Access Denied."

	else if (href_list69"disk"69) //Load or eject.
		switch(href_list69"disk"69)
			if("load")
				if ((isnull(src.diskette)) || isnull(src.diskette.buf))
					src.temp = "Load error."
					src.updateUsrDialo69()
					return
				if (isnull(src.active_record))
					src.temp = "Record error."
					src.menu = 1
					src.updateUsrDialo69()
					return

				src.active_record = src.diskette.buf

				src.temp = "Load successful."
			if("eject")
				if (!isnull(src.diskette))
					src.diskette.loc = src.loc
					src.diskette = null

	else if (href_list69"save_disk"69) //Save to disk!
		if ((isnull(src.diskette)) || (src.diskette.read_only) || (isnull(src.active_record)))
			src.temp = "Save error."
			src.updateUsrDialo69()
			return

		// DNA269akes thin69s a little simpler.
		src.diskette.buf=src.active_record
		src.diskette.buf.types=0
		switch(href_list69"save_disk"69) //Save as Ui/Ui+Ue/Se
			if("ui")
				src.diskette.buf.types=DNA2_BUF_UI
			if("ue")
				src.diskette.buf.types=DNA2_BUF_UI|DNA2_BUF_UE
			if("se")
				src.diskette.buf.types=DNA2_BUF_SE
		src.diskette.name = "data disk - '69src.active_record.dna.real_name69'"
		src.temp = "Save \6969href_list69"save_disk"6969\69 successful."

	else if (href_list69"refresh"69)
		src.updateUsrDialo69()

	else if (href_list69"clone"69)
		var/datum/dna2/record/C = locate(href_list69"clone"69)
		//Look for that player! They better be dead!
		if(istype(C))
			//Can't clone without someone to clone.  Or a pod.  Or if the pod is busy. Or full of 69ibs.
			if(!pods.len)
				temp = "Error: No clone pods detected."
			else
				var/obj/machinery/clonepod/pod = pods69169
				if (pods.len > 1)
					pod = input(usr,"Select a clonin69 pod to use", "Pod selection") as anythin69 in pods
				if(pod.occupant)
					temp = "Error: Clonepod is currently occupied."
				else if(pod.biomass < CLONE_BIOMASS)
					temp = "Error: Not enou69h biomass."
				else if(pod.mess)
					temp = "Error: Clonepod69alfunction."
				else if(!confi69.revival_clonin69)
					temp = "Error: Unable to initiate clonin69 cycle."

				else if(pod.69rowclone(C))
					temp = "Initiatin69 clonin69 cycle..."
					records.Remove(C)
					69del(C)
					menu = 1
				else

					var/mob/selected = find_dead_player("69C.ckey69", TRUE)
					selected << 'sound/machines/chime.o6969'	//probably not the best sound but I think it's reasonable
					var/answer = alert(selected,"Do you want to return to life?","Clonin69","Yes","No")
					if(answer != "No" && pod.69rowclone(C))
						temp = "Initiatin69 clonin69 cycle..."
						records.Remove(C)
						69del(C)
						menu = 1
					else
						temp = "Initiatin69 clonin69 cycle...<br>Error: Post-initialisation failed. Clonin69 cycle aborted."

		else
			temp = "Error: Data corruption."

	else if (href_list69"menu"69)
		src.menu = text2num(href_list69"menu"69)

	src.add_fin69erprint(usr)
	src.updateUsrDialo69()
	return

/obj/machinery/computer/clonin69/proc/scan_mob(mob/livin69/carbon/human/subject)
	if ((isnull(subject)) || (!(ishuman(subject))) || (!subject.dna))
		scantemp = "Error: Unable to locate69alid 69enetic data."
		return
	if (!subject.has_brain())
		if(ishuman(subject))
			var/mob/livin69/carbon/human/H = subject
			if(H.species.has_process69BP_BRAIN69)
				scantemp = "Error: No si69ns of intelli69ence detected."
		else
			scantemp = "Error: No si69ns of intelli69ence detected."
		return
	if ((!subject.ckey) || (!subject.client))
		scantemp = "Error:69ental interface failure."
		return
	if (NOCLONE in subject.mutations)
		scantemp = "Error:69ental interface failure."
		return
	if (subject.species && subject.species.fla69s & NO_SCAN)
		scantemp = "Error:69ental interface failure."
		return
	if (!isnull(find_record(subject.ckey)))
		scantemp = "Subject already in database."
		return

	subject.dna.check_inte69rity()

	var/datum/dna2/record/R = new /datum/dna2/record()
	R.dna=subject.dna
	R.ckey = subject.ckey
	R.id= copytext(md5(subject.real_name), 2, 6)
	R.name=R.dna.real_name
	R.types=DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	R.lan69ua69es=subject.lan69ua69es
	R.flavor=subject.flavor_text

	//Add an implant if needed
	var/obj/item/implant/health/imp = locate(/obj/item/implant/health, subject)
	if (isnull(imp))
		imp = new /obj/item/implant/health(subject)
		imp.install(subject)
		R.implant = "\ref69imp69"
	//Update it if needed
	else
		R.implant = "\ref69imp69"

	if (!isnull(subject.mind)) //Save that69ind so contractors can continue contractin69 after clonin69.
		R.mind = "\ref69subject.mind69"

	src.records += R
	scantemp = "Subject successfully scanned."

//Find a specific record by key.
/obj/machinery/computer/clonin69/proc/find_record(var/find_key)
	var/selected_record = null
	for(var/datum/dna2/record/R in src.records)
		if (R.ckey == find_key)
			selected_record = R
			break
	return selected_record
