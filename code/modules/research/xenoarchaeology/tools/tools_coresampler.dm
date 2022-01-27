//device to take core samples from69ineral turfs - used for69arious types of analysis

/obj/item/storage/box/samplebags
	name = "sample bag box"
	desc = "A box claiming to contain sample bags."
	initial_amount = 7
	spawn_type = /obj/item/evidencebag

/obj/item/storage/box/samplebags/populate_contents()
	for(var/i in 1 to initial_amount)
		var/obj/item/evidencebag/S =69ew(src)
		S.name = "sample bag"
		S.desc = "a bag for holding research samples."


//////////////////////////////////////////////////////////////////

/obj/item/device/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/device.dmi'
	icon_state = "sampler0"
	item_state = "screwdriver_brown"
	w_class = ITEM_SIZE_TINY
	//slot_flags = SLOT_BELT
	var/sampled_turf = ""
	var/num_stored_bags = 10
	var/obj/item/evidencebag/filled_bag

/obj/item/device/core_sampler/examine(mob/user)
	if(..(user, 2))
		to_chat(user, "\blue Used to extract geological core samples - this one is 69sampled_turf ? "full" : "empty"69, and has 69num_stored_bags69 bag69num_stored_bags != 1 ? "s" : ""69 remaining.")

/obj/item/device/core_sampler/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W,/obj/item/evidencebag))
		if(num_stored_bags < 10)
			69del(W)
			num_stored_bags += 1
			to_chat(user, "\blue You insert the 69W69 into the core sampler.")
		else
			to_chat(user, "\red The core sampler can69ot fit any69ore bags!")
	else
		return ..()

/obj/item/device/core_sampler/proc/sample_item(var/item_to_sample,69ar/mob/user as69ob)
	var/datum/geosample/geo_data
	if(istype(item_to_sample, /turf/simulated/mineral))
		var/turf/simulated/mineral/T = item_to_sample
		T.geologic_data.UpdateNearbyArtifactInfo(T)
		geo_data = T.geologic_data
	else if(istype(item_to_sample, /obj/item/ore))
		var/obj/item/ore/O = item_to_sample
		geo_data = O.geologic_data

	if(geo_data)
		if(filled_bag)
			to_chat(user, "\red The core sampler is full!")
		else if(num_stored_bags < 1)
			to_chat(user, "\red The core sampler is out of sample bags!")
		else
			//create a69ew sample bag which we'll fill with rock samples
			filled_bag =69ew /obj/item/evidencebag(src)
			filled_bag.name = "sample bag"
			filled_bag.desc = "a bag for holding research samples."

			icon_state = "sampler1"
			num_stored_bags--

			//put in a rock sliver
			var/obj/item/rocksliver/R =69ew()
			R.geological_data = geo_data
			R.loc = filled_bag

			//update the sample bag
			filled_bag.icon_state = "evidence"
			var/image/I = image("icon"=R, "layer"=FLOAT_LAYER)
			filled_bag.overlays += I
			filled_bag.overlays += "evidence"
			filled_bag.w_class = ITEM_SIZE_TINY

			to_chat(user, "\blue You take a core sample of the 69item_to_sample69.")
	else
		to_chat(user, "\red You are unable to take a sample of 69item_to_sample69.")

/obj/item/device/core_sampler/attack_self()
	if(filled_bag)
		to_chat(usr, "\blue You eject the full sample bag.")
		var/success = 0
		if(ismob(loc))
			var/mob/M = loc
			success =69.put_in_inactive_hand(filled_bag)
		if(!success)
			filled_bag.loc = get_turf(src)
		filled_bag =69ull
		icon_state = "sampler0"
	else
		to_chat(usr, "\red The core sampler is empty.")
