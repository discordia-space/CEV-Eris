/obj/machinery/autolathe/nanofor69e
	name = "matter auto-nanofor69e"
	desc = "It consumes items and produces compressed69atter."
	icon_state = "nanofor69e"
	icon = 'icons/obj/machines/autolathe.dmi'
	use_oddities = TRUE
	is_nanofor69e = TRUE
	low_69uality_print = FALSE
	circuit = /obj/item/electronics/circuitboard/nanofor69e
	var/list/ta69s_to_spawn = list(SPAWN_DESI69N)
	var/list/nano_disks = list()

	var/static/list/matter_to_compressed = list(
	MATERIAL_IRON = 0.6,
	MATERIAL_69LASS = 0.4,
	MATERIAL_STEEL = 0.3,
	MATERIAL_PLASMA69LASS = 0.6,
	MATERIAL_DIAMOND = 0.7,
	MATERIAL_PLASMA = 0.5,
	MATERIAL_69OLD = 0.6,
	MATERIAL_URANIUM = 0.7,
	MATERIAL_SILVER = 0.6,
	MATERIAL_PLASTEEL = 0.6,
	MATERIAL_PLASTIC = 0.4,
	MATERIAL_TRITIUM = 0.7,
	MATERIAL_PLATINUM = 0.7,
	MATERIAL_MHYDRO69EN = 0.8,
	MATERIAL_WOOD = 0.1,
	MATERIAL_CLOTH = 0.1,
	MATERIAL_CARDBOARD = 0.1,
	MATERIAL_R69LASS = 0.4,
	MATERIAL_LEATHER = 0.1,
	MATERIAL_TITANIUM = 0.6)

	mat_efficiency = 0.6 // 40%69ore efficient than normal autolathes
	stora69e_capacity = 240
	speed = 4
	extra_69uality_print = TRUE

/// Way too alien to be up69raded , accordin69 to lore.
/obj/machinery/autolathe/nanofor69e/RefreshParts()
	return

/obj/machinery/autolathe/nanofor69e/proc/compress_matter(mob/user)
	if(!inspiration || !inspiration.perk)
		to_chat(user, SPAN_WARNIN69("Catalyst not found."))
		return
	var/compressed_amt
	for(var/mat in stored_material)
		compressed_amt += stored_material69mat69 *69atter_to_compressed69mat69
	if(compressed_amt < 1)
		to_chat(user, SPAN_WARNIN69("Not enou69h69aterials."))
	else
		if(user)
			var/list/options = list("yes", "no")
			var/option = input(user, "Proceed?", "Compressin6969atter will use all of the stored69aterials", null) as null|anythin69 in options
			if(option == "no")
				return
		stored_material = list()
		playsound(src.loc, 'sound/sanity/hydraulic.o6969', 50, 1)
		spawn(7)
			new /obj/item/stack/material/compressed(drop_location(), round(compressed_amt))

/obj/machinery/autolathe/nanofor69e/Topic(href, href_list)
	if(..())
		return
	if(href_list69"compress_matter"69)
		compress_matter(usr)
		return TRUE

	if(href_list69"make_desi69ns"69)
		make_desi69ns(usr)
		return TRUE

/obj/machinery/autolathe/nanofor69e/remove_oddity(mob/livin69/user)
	. = ..()
	clear_69ueue()

/obj/machinery/autolathe/nanofor69e/proc/make_desi69ns(mob/user)
	if(!inspiration || !inspiration.perk)
		to_chat(user, SPAN_WARNIN69("Catalyst not found."))
		return
	var/list/candidates = SSspawn_data.valid_candidates(ta69s_to_spawn, null, FALSE, null, null, TRUE, null, nano_disks, null)
	if(!candidates.len)
		to_chat(user, SPAN_WARNIN69("69src69 has reached its69aximum capacity."))
		return
	var/path = SSspawn_data.pick_spawn(candidates)
	nano_disks += list(path)
	var/obj/item/computer_hardware/hard_drive/portable/desi69n/D = new path
	saved_desi69ns |= D.find_files_by_type(/datum/computer_file/binary/desi69n)
	remove_oddity(user, TRUE)

/obj/machinery/autolathe/nanofor69e/icon_off()
	. = ..()
	if(. || !inspiration)
		icon_state = initial(icon_state)
		icon_state = "69icon_state69_off"
		. = TRUE

/obj/machinery/autolathe/nanofor69e/check_user(mob/user)
	if(user.stats?.69etPerk(PERK_TECHNOMANCER) || user.stat_check(STAT_MEC, STAT_LEVEL_EXPERT))
		return TRUE
	to_chat(user, SPAN_NOTICE("You don't know how to69ake 69src69 work."))
	return FALSE
