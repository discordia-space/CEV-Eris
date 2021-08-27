//device to take core samples from mineral turfs - used for various types of analysis

/obj/item/storage/box/samplebags
	name = "sample bag box"
	desc = "A box claiming to contain sample bags."
	initial_amount = 7
	spawn_type = /obj/item/evidencebag

/obj/item/storage/box/samplebags/populate_contents()
	for(var/i in 1 to initial_amount)
		var/obj/item/evidencebag/S = new(src)
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
		to_chat(user, "\blue Used to extract geological core samples - this one is [sampled_turf ? "full" : "empty"], and has [num_stored_bags] bag[num_stored_bags != 1 ? "s" : ""] remaining.")

/obj/item/device/core_sampler/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/evidencebag))
		if(num_stored_bags < 10)
			qdel(W)
			num_stored_bags += 1
			to_chat(user, "\blue You insert the [W] into the core sampler.")
		else
			to_chat(user, "\red The core sampler can not fit any more bags!")
	else
		return ..()

/obj/item/device/core_sampler/proc/sample_item(var/item_to_sample, var/mob/user as mob)
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
			//create a new sample bag which we'll fill with rock samples
			filled_bag = new /obj/item/evidencebag(src)
			filled_bag.name = "sample bag"
			filled_bag.desc = "a bag for holding research samples."

			icon_state = "sampler1"
			num_stored_bags--

			//put in a rock sliver
			var/obj/item/rocksliver/R = new()
			R.geological_data = geo_data
			R.loc = filled_bag

			//update the sample bag
			filled_bag.icon_state = "evidence"
			var/image/I = image("icon"=R, "layer"=FLOAT_LAYER)
			filled_bag.add_overlays(I)
			filled_bag.add_overlays("evidence")
			filled_bag.w_class = ITEM_SIZE_TINY

			to_chat(user, "\blue You take a core sample of the [item_to_sample].")
	else
		to_chat(user, "\red You are unable to take a sample of [item_to_sample].")

/obj/item/device/core_sampler/attack_self()
	if(filled_bag)
		to_chat(usr, "\blue You eject the full sample bag.")
		var/success = 0
		if(ismob(loc))
			var/mob/M = loc
			success = M.put_in_inactive_hand(filled_bag)
		if(!success)
			filled_bag.loc = get_turf(src)
		filled_bag = null
		icon_state = "sampler0"
	else
		to_chat(usr, "\red The core sampler is empty.")
