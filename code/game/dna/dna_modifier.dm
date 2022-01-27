#define DNA_BLOCK_SIZE 3

// Buffer datatype flags.
#define DNA2_BUF_UI 1
#define DNA2_BUF_UE 2
#define DNA2_BUF_SE 4

//list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0),
/datum/dna2/record
	var/datum/dna/dna
	var/types=0
	var/name="Empty"

	// Stuff for cloners
	var/id
	var/implant
	var/ckey
	var/mind
	var/languages
	var/flavor

/datum/dna2/record/proc/GetData()
	var/list/ser=list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0)
	if(dna)
		ser69"ue"69 = (types & DNA2_BUF_UE) == DNA2_BUF_UE
		if(types & DNA2_BUF_SE)
			ser69"data"69 = dna.SE
		else
			ser69"data"69 = dna.UI
		ser69"owner"69 = src.dna.real_name
		ser69"label"69 = name
		if(types & DNA2_BUF_UI)
			ser69"type"69 = "ui"
		else
			ser69"type"69 = "se"
	return ser

/////////////////////////// DNA69ACHINES
/obj/machinery/dna_scannernew
	name = "\improper DNA69odifier"
	desc = "It scans DNA structures."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 50
	active_power_usage = 300
	interact_offline = 1
	circuit = /obj/item/electronics/circuitboard/clonescanner
	var/locked = 0
	var/mob/living/carbon/occupant = null
	var/obj/item/reagent_containers/glass/beaker
	var/opened = 0

/obj/machinery/dna_scannernew/relaymove(mob/user)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/dna_scannernew/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject DNA Scanner"

	if (usr.stat)
		return

	eject_occupant()

	add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/proc/eject_occupant()
	src.go_out()
	for(var/obj/O in src)
		if((!istype(O,/obj/item/reagent_containers)) && (!istype(O,/obj/item/electronics/circuitboard/clonescanner)) && (!istype(O,/obj/item/stock_parts)) && (!istype(O,/obj/item/stack/cable_coil)))
			O.loc = get_turf(src)//Ejects items that69anage to get in there (exluding the components)
	if(!occupant)
		for(var/mob/M in src)//Failsafe so you can get69obs out
			M.loc = get_turf(src)

/obj/machinery/dna_scannernew/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter DNA Scanner"

	if (usr.stat)
		return
	if (!ishuman(usr) && !issmall(usr)) //Make sure they're a69ob that has dna
		to_chat(usr, SPAN_NOTICE("Try as you69ight, you can not climb up into the scanner."))
		return
	if (src.occupant)
		to_chat(usr, SPAN_WARNING("The scanner is already occupied!"))
		return
	if (usr.abiotic())
		to_chat(usr, SPAN_WARNING("The subject cannot have abiotic items on."))
		return
	usr.stop_pulling()
	put_in(usr)
	src.add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/affect_grab(var/mob/user,69ar/mob/target)
	if (src.occupant)
		to_chat(user, SPAN_WARNING("The scanner is already occupied!"))
		return
	if (target.abiotic())
		to_chat(user, SPAN_WARNING("The subject cannot have abiotic items on."))
		return
	put_in(target)
	src.add_fingerprint(user)
	return TRUE


/obj/machinery/dna_scannernew/attackby(var/obj/item/item as obj,69ar/mob/user as69ob)
	if(istype(item, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the69achine."))
			return
		beaker = item
		user.drop_from_inventory(item)
		item.forceMove(src)
		user.visible_message("\The 69user69 adds \a 69item69 to \the 69src69!", "You add \a 69item69 to \the 69src69!")
		return

/obj/machinery/dna_scannernew/proc/put_in(var/mob/M)
	M.reset_view(src)
	M.loc = src
	src.occupant =69
	src.icon_state = "scanner_1"

	// search for ghosts, if the corpse is empty and the scanner is connected to a cloner
	if(locate(/obj/machinery/computer/cloning) in range(1))
		if(!M.client &&69.mind)
			for(var/mob/observer/ghost/ghost in GLOB.player_list)
				if(ghost.mind ==69.mind)
					to_chat(ghost, {"
						<font color = #330033 size = 3>
						<b>Your corpse has been placed into a cloning scanner.
						Return to your body if you want to be resurrected/cloned!</b>
						(Verbs -> Ghost -> Re-enter corpse)
						</font>
					"})
					break
	return

/obj/machinery/dna_scannernew/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective =69OB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	src.icon_state = "scanner_0"
	return

/obj/machinery/dna_scannernew/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as69ob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			69del(src)
			return
		if(2)
			if (prob(50))
				for(var/atom/movable/A as69ob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				69del(src)
				return
		if(3)
			if (prob(25))
				for(var/atom/movable/A as69ob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				69del(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew
	name = "DNA69odifier Access Console"
	desc = "Scand DNA."
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	density = TRUE
	circuit = /obj/item/electronics/circuitboard/scan_consolenew
	var/selected_ui_block = 1
	var/selected_ui_subblock = 1
	var/selected_se_block = 1
	var/selected_se_subblock = 1
	var/selected_ui_target = 1
	var/selected_ui_target_hex = 1
	var/radiation_duration = 2
	var/radiation_intensity = 1
	var/list/datum/dna2/record/buffers69369
	var/irradiating = 0
	var/injector_ready = 0	//69uick fix for issue 286 (screwdriver the screen twice to restore injector)	-Pete
	var/obj/machinery/dna_scannernew/connected
	var/obj/item/disk/data/disk
	var/selected_menu_key
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 400
	var/waiting_for_user_input=0 // Fix for #274 (Mash create block injector without answering dialog to69ake unlimited injectors) - N3X

/obj/machinery/computer/scan_consolenew/attackby(obj/item/I,69ob/user)
	if (istype(I, /obj/item/disk/data)) //INSERT SOME diskS
		if (!src.disk)
			user.drop_from_inventory(I)
			I.forceMove(src)
			src.disk = I
			to_chat(user, "You insert 69I69.")
			SSnano.update_uis(src) // update all UIs attached to src
			return
	else
		..()
	return

/obj/machinery/computer/scan_consolenew/ex_act(severity)

	switch(severity)
		if(1)
			//SN src = null
			69del(src)
			return
		if(2)
			if (prob(50))
				//SN src = null
				69del(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew/New()
	..()
	for(var/i=0;i<3;i++)
		buffers69i+169=new /datum/dna2/record
	spawn(5)
		for(var/dir in list(NORTH,EAST,SOUTH,WEST))
			connected = locate(/obj/machinery/dna_scannernew, get_step(src, dir))
			if(!isnull(connected))
				break
		spawn(250)
			src.injector_ready = 1
		return
	return

/obj/machinery/computer/scan_consolenew/proc/all_dna_blocks(var/list/buffer)
	var/list/arr = list()
	for(var/i = 1, i <= buffer.len, i++)
		arr += "69i69:69EncodeDNABlock(buffer69i69)69"
	return arr

/obj/machinery/computer/scan_consolenew/proc/setInjectorBlock(var/obj/item/dnainjector/I,69ar/blk,69ar/datum/dna2/record/buffer)
	var/pos = findtext(blk,":")
	if(!pos) return 0
	var/id = text2num(copytext(blk,1,pos))
	if(!id) return 0
	I.block = id
	I.buf = buffer
	return 1

/*
/obj/machinery/computer/scan_consolenew/Process() //not really used right now
	if(stat & (NOPOWER|BROKEN))
		return
	if (!( src.status )) //remove this
		return
	return
*/

/obj/machinery/computer/scan_consolenew/attack_ai(user as69ob)
	src.add_hiddenprint(user)
	ui_interact(user)

/obj/machinery/computer/scan_consolenew/attack_hand(user as69ob)
	if(!..())
		ui_interact(user)

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable (which is inherited by /obj and /mob)
  *
  * @param user /mob The69ob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for69ultiple uni69ue uis on one obj/mob (defaut69alue "main")
  * @param ui /datum/nanoui This parameter is passed by the nanoui process() proc when updating an open ui
  *
  * @return nothing
  */
/obj/machinery/computer/scan_consolenew/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)

	if(user == connected.occupant || user.stat)
		return

	// this is the data which will be sent to the ui
	var/data69069
	data69"selectedMenuKey"69 = selected_menu_key
	data69"locked"69 = src.connected.locked
	data69"hasOccupant"69 = connected.occupant ? 1 : 0

	data69"isInjectorReady"69 = injector_ready

	data69"hasDisk"69 = disk ? 1 : 0

	var/diskData69069
	if (!disk || !disk.buf)
		diskData69"data"69 = null
		diskData69"owner"69 = null
		diskData69"label"69 = null
		diskData69"type"69 = null
		diskData69"ue"69 = null
	else
		diskData = disk.buf.GetData()
	data69"disk"69 = diskData

	var/list/new_buffers = list()
	for(var/datum/dna2/record/buf in src.buffers)
		new_buffers += list(buf.GetData())
	data69"buffers"69=new_buffers

	data69"radiationIntensity"69 = radiation_intensity
	data69"radiationDuration"69 = radiation_duration
	data69"irradiating"69 = irradiating

	data69"dnaBlockSize"69 = DNA_BLOCK_SIZE
	data69"selectedUIBlock"69 = selected_ui_block
	data69"selectedUISubBlock"69 = selected_ui_subblock
	data69"selectedSEBlock"69 = selected_se_block
	data69"selectedSESubBlock"69 = selected_se_subblock
	data69"selectedUITarget"69 = selected_ui_target
	data69"selectedUITargetHex"69 = selected_ui_target_hex

	var/occupantData69069
	if (!src.connected.occupant || !src.connected.occupant.dna)
		occupantData69"name"69 = null
		occupantData69"stat"69 = null
		occupantData69"isViableSubject"69 = null
		occupantData69"health"69 = null
		occupantData69"maxHealth"69 = null
		occupantData69"minHealth"69 = null
		occupantData69"uni69ueEnzymes"69 = null
		occupantData69"uni69ueIdentity"69 = null
		occupantData69"structuralEnzymes"69 = null
		occupantData69"radiationLevel"69 = null
	else
		occupantData69"name"69 = connected.occupant.real_name
		occupantData69"stat"69 = connected.occupant.stat
		occupantData69"isViableSubject"69 = 1
		if (NOCLONE in connected.occupant.mutations || !src.connected.occupant.dna)
			occupantData69"isViableSubject"69 = 0
		occupantData69"health"69 = connected.occupant.health
		occupantData69"maxHealth"69 = connected.occupant.maxHealth
		occupantData69"minHealth"69 = HEALTH_THRESHOLD_DEAD
		occupantData69"uni69ueEnzymes"69 = connected.occupant.dna.uni69ue_enzymes
		occupantData69"uni69ueIdentity"69 = connected.occupant.dna.uni_identity
		occupantData69"structuralEnzymes"69 = connected.occupant.dna.struc_enzymes
		occupantData69"radiationLevel"69 = connected.occupant.radiation
	data69"occupant"69 = occupantData;

	data69"isBeakerLoaded"69 = connected.beaker ? 1 : 0
	data69"beakerLabel"69 = null
	data69"beakerVolume"69 = 0
	if(connected.beaker)
		data69"beakerLabel"69 = connected.beaker.label_text ? connected.beaker.label_text : null
		if (connected.beaker.reagents && connected.beaker.reagents.reagent_list.len)
			for(var/datum/reagent/R in connected.beaker.reagents.reagent_list)
				data69"beakerVolume"69 += R.volume

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "dna_modifier.tmpl", "DNA69odifier Console", 660, 700)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every69aster Controller tick
		ui.set_auto_update(1)

/obj/machinery/computer/scan_consolenew/Topic(href, href_list)
	if(..())
		return 0 // don't update uis
	if(!istype(usr.loc, /turf))
		return 0 // don't update uis
	if(!src || !src.connected)
		return 0 // don't update uis
	if(irradiating) //69ake sure that it isn't already irradiating someone...
		return 0 // don't update uis

	add_fingerprint(usr)

	if (href_list69"selectMenuKey"69)
		selected_menu_key = href_list69"selectMenuKey"69
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list69"toggleLock"69)
		if ((src.connected && src.connected.occupant))
			src.connected.locked = !( src.connected.locked )
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list69"pulseRadiation"69)
		irradiating = src.radiation_duration
		var/lock_state = src.connected.locked
		src.connected.locked = 1//lock it
		SSnano.update_uis(src) // update all UIs attached to src

		sleep(10*src.radiation_duration) // sleep for radiation_duration seconds

		irradiating = 0

		if (!src.connected.occupant)
			return 1 // return 1 forces an update to all Nano uis attached to src

		if (prob(95))
			if(prob(75))
				randmutb(src.connected.occupant)
			else
				randmuti(src.connected.occupant)
		else
			if(prob(95))
				randmutg(src.connected.occupant)
			else
				randmuti(src.connected.occupant)

		src.connected.occupant.apply_effect(((src.radiation_intensity*3)+src.radiation_duration*3), IRRADIATE, check_protection = 0)
		src.connected.locked = lock_state
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list69"radiationDuration"69)
		if (text2num(href_list69"radiationDuration"69) > 0)
			if (src.radiation_duration < 20)
				src.radiation_duration += 2
		else
			if (src.radiation_duration > 2)
				src.radiation_duration -= 2
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list69"radiationIntensity"69)
		if (text2num(href_list69"radiationIntensity"69) > 0)
			if (src.radiation_intensity < 10)
				src.radiation_intensity++
		else
			if (src.radiation_intensity > 1)
				src.radiation_intensity--
		return 1 // return 1 forces an update to all Nano uis attached to src

	////////////////////////////////////////////////////////

	if (href_list69"changeUITarget"69 && text2num(href_list69"changeUITarget"69) > 0)
		if (src.selected_ui_target < 15)
			src.selected_ui_target++
			src.selected_ui_target_hex = src.selected_ui_target
			switch(selected_ui_target)
				if(10)
					src.selected_ui_target_hex = "A"
				if(11)
					src.selected_ui_target_hex = "B"
				if(12)
					src.selected_ui_target_hex = "C"
				if(13)
					src.selected_ui_target_hex = "D"
				if(14)
					src.selected_ui_target_hex = "E"
				if(15)
					src.selected_ui_target_hex = "F"
		else
			src.selected_ui_target = 0
			src.selected_ui_target_hex = 0
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list69"changeUITarget"69 && text2num(href_list69"changeUITarget"69) < 1)
		if (src.selected_ui_target > 0)
			src.selected_ui_target--
			src.selected_ui_target_hex = src.selected_ui_target
			switch(selected_ui_target)
				if(10)
					src.selected_ui_target_hex = "A"
				if(11)
					src.selected_ui_target_hex = "B"
				if(12)
					src.selected_ui_target_hex = "C"
				if(13)
					src.selected_ui_target_hex = "D"
				if(14)
					src.selected_ui_target_hex = "E"
		else
			src.selected_ui_target = 15
			src.selected_ui_target_hex = "F"
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list69"selectUIBlock"69 && href_list69"selectUISubblock"69) // This chunk of code updates selected block / sub-block based on click
		var/select_block = text2num(href_list69"selectUIBlock"69)
		var/select_subblock = text2num(href_list69"selectUISubblock"69)
		if ((select_block <= DNA_UI_LENGTH) && (select_block >= 1))
			src.selected_ui_block = select_block
		if ((select_subblock <= DNA_BLOCK_SIZE) && (select_subblock >= 1))
			src.selected_ui_subblock = select_subblock
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list69"pulseUIRadiation"69)
		var/block = src.connected.occupant.dna.GetUISubBlock(src.selected_ui_block,src.selected_ui_subblock)

		irradiating = src.radiation_duration
		var/lock_state = src.connected.locked
		src.connected.locked = 1//lock it
		SSnano.update_uis(src) // update all UIs attached to src

		sleep(10*src.radiation_duration) // sleep for radiation_duration seconds

		irradiating = 0

		if (!src.connected.occupant)
			return 1

		if (prob((80 + (src.radiation_duration / 2))))
			block =69iniscrambletarget(num2text(selected_ui_target), src.radiation_intensity, src.radiation_duration)
			src.connected.occupant.dna.SetUISubBlock(src.selected_ui_block,src.selected_ui_subblock,block)
			src.connected.occupant.UpdateAppearance()
			src.connected.occupant.apply_effect((src.radiation_intensity+src.radiation_duration), IRRADIATE, check_protection = 0)
		else
			if	(prob(20+src.radiation_intensity))
				randmutb(src.connected.occupant)
				domutcheck(src.connected.occupant,src.connected)
			else
				randmuti(src.connected.occupant)
				src.connected.occupant.UpdateAppearance()
			src.connected.occupant.apply_effect(((src.radiation_intensity*2)+src.radiation_duration), IRRADIATE, check_protection = 0)
		src.connected.locked = lock_state
		return 1 // return 1 forces an update to all Nano uis attached to src

	////////////////////////////////////////////////////////

	if (href_list69"injectRejuvenators"69)
		if (!connected.occupant)
			return 0
		var/inject_amount = round(text2num(href_list69"injectRejuvenators"69), 5) // round to nearest 5
		if (inject_amount < 0) // Since the user can actually type the commands himself, some sanity checking
			inject_amount = 0
		if (inject_amount > 50)
			inject_amount = 50
		connected.beaker.reagents.trans_to_mob(connected.occupant, inject_amount, CHEM_BLOOD)
		return 1 // return 1 forces an update to all Nano uis attached to src

	////////////////////////////////////////////////////////

	if (href_list69"selectSEBlock"69 && href_list69"selectSESubblock"69) // This chunk of code updates selected block / sub-block based on click (se stands for strutural enzymes)
		var/select_block = text2num(href_list69"selectSEBlock"69)
		var/select_subblock = text2num(href_list69"selectSESubblock"69)
		if ((select_block <= DNA_SE_LENGTH) && (select_block >= 1))
			src.selected_se_block = select_block
		if ((select_subblock <= DNA_BLOCK_SIZE) && (select_subblock >= 1))
			src.selected_se_subblock = select_subblock
		//testing("User selected block 69selected_se_block69 (sent 69select_block69), subblock 69selected_se_subblock69 (sent 69select_block69).")
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list69"pulseSERadiation"69)
		var/block = src.connected.occupant.dna.GetSESubBlock(src.selected_se_block,src.selected_se_subblock)
		//var/original_block=block
		//testing("Irradiating SE block 69src.selected_se_block69:69src.selected_se_subblock69 (69block69)...")

		irradiating = src.radiation_duration
		var/lock_state = src.connected.locked
		src.connected.locked = 1 //lock it
		SSnano.update_uis(src) // update all UIs attached to src

		sleep(10*src.radiation_duration) // sleep for radiation_duration seconds

		irradiating = 0

		if(src.connected.occupant)
			if (prob((80 + (src.radiation_duration / 2))))
				// FIXME: Find out what these corresponded to and change them to the WHATEVERBLOCK they need to be.
				//if ((src.selected_se_block != 2 || src.selected_se_block != 12 || src.selected_se_block != 8 || src.selected_se_block || 10) && prob (20))
				var/real_SE_block=selected_se_block
				block =69iniscramble(block, src.radiation_intensity, src.radiation_duration)
				if(prob(20))
					if (src.selected_se_block > 1 && src.selected_se_block < DNA_SE_LENGTH/2)
						real_SE_block++
					else if (src.selected_se_block > DNA_SE_LENGTH/2 && src.selected_se_block < DNA_SE_LENGTH)
						real_SE_block--

				//testing("Irradiated SE block 69real_SE_block69:69src.selected_se_subblock69 (69original_block69 now 69block69) 69(real_SE_block!=selected_se_block) ? "(SHIFTED)":""69!")
				connected.occupant.dna.SetSESubBlock(real_SE_block,selected_se_subblock,block)
				src.connected.occupant.apply_effect((src.radiation_intensity+src.radiation_duration), IRRADIATE, check_protection = 0)
				domutcheck(src.connected.occupant,src.connected)
			else
				src.connected.occupant.apply_effect(((src.radiation_intensity*2)+src.radiation_duration), IRRADIATE, check_protection = 0)
				if	(prob(80-src.radiation_duration))
					//testing("Random bad69ut!")
					randmutb(src.connected.occupant)
					domutcheck(src.connected.occupant,src.connected)
				else
					randmuti(src.connected.occupant)
					//testing("Random identity69ut!")
					src.connected.occupant.UpdateAppearance()
		src.connected.locked = lock_state
		return 1 // return 1 forces an update to all Nano uis attached to src

	if(href_list69"ejectBeaker"69)
		if(connected.beaker)
			var/obj/item/reagent_containers/glass/B = connected.beaker
			B.loc = connected.loc
			connected.beaker = null
		return 1

	if(href_list69"ejectOccupant"69)
		connected.eject_occupant()
		return 1

	// Transfer Buffer69anagement
	if(href_list69"bufferOption"69)
		var/bufferOption = href_list69"bufferOption"69

		// These bufferOptions do not re69uire a bufferId
		if (bufferOption == "wipeDisk")
			if ((isnull(src.disk)) || (src.disk.read_only))
				//src.temphtml = "Invalid disk. Please try again."
				return 0

			src.disk.buf=null
			//src.temphtml = "Data saved."
			return 1

		if (bufferOption == "ejectDisk")
			if (!src.disk)
				return
			src.disk.loc = get_turf(src)
			src.disk = null
			return 1

		// All bufferOptions from here on re69uire a bufferId
		if (!href_list69"bufferId"69)
			return 0

		var/bufferId = text2num(href_list69"bufferId"69)

		if (bufferId < 1 || bufferId > 3)
			return 0 // Not a69alid buffer id

		if (bufferOption == "saveUI")
			if(src.connected.occupant && src.connected.occupant.dna)
				var/datum/dna2/record/databuf=new
				databuf.types = DNA2_BUF_UE
				databuf.dna = src.connected.occupant.dna.Clone()
				if(ishuman(connected.occupant))
					databuf.dna.real_name=connected.occupant.dna.real_name
				databuf.name = "Uni69ue Identifier"
				src.buffers69bufferId69 = databuf
			return 1

		if (bufferOption == "saveUIAndUE")
			if(src.connected.occupant && src.connected.occupant.dna)
				var/datum/dna2/record/databuf=new
				databuf.types = DNA2_BUF_UI|DNA2_BUF_UE
				databuf.dna = src.connected.occupant.dna.Clone()
				if(ishuman(connected.occupant))
					databuf.dna.real_name=connected.occupant.dna.real_name
				databuf.name = "Uni69ue Identifier + Uni69ue Enzymes"
				src.buffers69bufferId69 = databuf
			return 1

		if (bufferOption == "saveSE")
			if(src.connected.occupant && src.connected.occupant.dna)
				var/datum/dna2/record/databuf=new
				databuf.types = DNA2_BUF_SE
				databuf.dna = src.connected.occupant.dna.Clone()
				if(ishuman(connected.occupant))
					databuf.dna.real_name=connected.occupant.dna.real_name
				databuf.name = "Structural Enzymes"
				src.buffers69bufferId69 = databuf
			return 1

		if (bufferOption == "clear")
			src.buffers69bufferId69=new /datum/dna2/record()
			return 1

		if (bufferOption == "changeLabel")
			var/datum/dna2/record/buf = src.buffers69bufferId69
			var/text = sanitize(input(usr, "New Label:", "Edit Label", buf.name) as text|null,69AX_NAME_LEN)
			buf.name = text
			src.buffers69bufferId69 = buf
			return 1

		if (bufferOption == "transfer")
			if (!src.connected.occupant || (NOCLONE in src.connected.occupant.mutations) || !src.connected.occupant.dna)
				return

			irradiating = 2
			var/lock_state = src.connected.locked
			src.connected.locked = 1//lock it
			SSnano.update_uis(src) // update all UIs attached to src

			sleep(10*2) // sleep for 2 seconds

			irradiating = 0
			src.connected.locked = lock_state

			var/datum/dna2/record/buf = src.buffers69bufferId69

			if ((buf.types & DNA2_BUF_UI))
				if ((buf.types & DNA2_BUF_UE))
					src.connected.occupant.real_name = buf.dna.real_name
					src.connected.occupant.name = buf.dna.real_name
				src.connected.occupant.UpdateAppearance(buf.dna.UI.Copy())
			else if (buf.types & DNA2_BUF_SE)
				src.connected.occupant.dna.SE = buf.dna.SE
				src.connected.occupant.dna.UpdateSE()
				domutcheck(src.connected.occupant,src.connected)
			src.connected.occupant.apply_effect(rand(20,50), IRRADIATE, check_protection = 0)
			return 1

		if (bufferOption == "createInjector")
			if (src.injector_ready || waiting_for_user_input)

				var/success = 1
				var/obj/item/dnainjector/I = new /obj/item/dnainjector
				var/datum/dna2/record/buf = src.buffers69bufferId69
				if(href_list69"createBlockInjector"69)
					waiting_for_user_input=1
					var/list/selectedbuf
					if(buf.types & DNA2_BUF_SE)
						selectedbuf=buf.dna.SE
					else
						selectedbuf=buf.dna.UI
					var/blk = input(usr,"Select Block","Block") in all_dna_blocks(selectedbuf)
					success = setInjectorBlock(I,blk,buf)
				else
					I.buf = buf
				waiting_for_user_input=0
				if(success)
					I.loc = src.loc
					I.name += " (69buf.name69)"
					//src.temphtml = "Injector created."
					src.injector_ready = 0
					spawn(300)
						src.injector_ready = 1
				//else
					//src.temphtml = "Error in injector creation."
			//else
				//src.temphtml = "Replicator not ready yet."
			return 1

		if (bufferOption == "loadDisk")
			if ((isnull(src.disk)) || (!src.disk.buf))
				//src.temphtml = "Invalid disk. Please try again."
				return 0

			src.buffers69bufferId69=src.disk.buf
			//src.temphtml = "Data loaded."
			return 1

		if (bufferOption == "saveDisk")
			if ((isnull(src.disk)) || (src.disk.read_only))
				//src.temphtml = "Invalid disk. Please try again."
				return 0

			var/datum/dna2/record/buf = src.buffers69bufferId69

			src.disk.buf = buf
			src.disk.name = "data disk - '69buf.dna.real_name69'"
			//src.temphtml = "Data saved."
			return 1


/////////////////////////// DNA69ACHINES
