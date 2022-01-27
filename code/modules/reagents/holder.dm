#define PROCESS_REACTION_ITER 5 //when processing a reaction, iterate this69any times

/datum/reagents
	var/list/datum/reagent/reagent_list = list()
	var/total_volume = 0
	var/maximum_volume = 100
	var/chem_temp = T20C
	var/atom/my_atom
	var/rotating = FALSE


/datum/reagents/New(max = 100, atom/A =69ull)
	..()
	maximum_volume =69ax
	my_atom = A

	//I dislike having these here but69ap-objects are initialised before world/New() is called. >_>
	if(!GLOB.chemical_reagents_list)
		//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
		var/paths = typesof(/datum/reagent) - /datum/reagent
		GLOB.chemical_reagents_list = list()
		for(var/path in paths)
			var/datum/reagent/D =69ew path()
			if(!D.name)
				continue
			GLOB.chemical_reagents_list69D.id69 = D

/datum/reagents/proc/get_price()
	var/price = 0
	for(var/datum/reagent/R in reagent_list)
		price += R.volume * R.price_per_unit
	return price

/datum/reagents/proc/get_average_reagents_state()
	var/solid = 0
	var/li69uid = 0
	var/gas = 0
	for(var/datum/reagent/R in reagent_list)
		switch(R.reagent_state)
			if(SOLID)
				solid++
			if(LI69UID)
				li69uid++
			if(GAS)
				gas++
	if(solid >= li69uid)
		if(solid >= gas)
			return SOLID
		else
			return GAS
	else
		if(li69uid >= gas)
			return LI69UID
		else
			return GAS

/datum/reagents/Destroy()
	. = ..()
	if(SSchemistry)
		SSchemistry.active_holders -= src

	for(var/datum/reagent/R in reagent_list)
		R.holder =69ull
		69del(R)
	reagent_list.Cut()
	reagent_list =69ull
	if(my_atom &&69y_atom.reagents == src)
		my_atom.reagents =69ull

/* Internal procs */

/datum/reagents/proc/get_free_space() // Returns free space.
	return69aximum_volume - total_volume

/datum/reagents/proc/get_master_reagent() // Returns reference to the reagent with the biggest69olume.
	var/the_reagent
	var/the_volume = 0

	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_reagent = A

	return the_reagent

/datum/reagents/proc/get_master_reagent_name() // Returns the69ame of the reagent with the biggest69olume.
	var/the_name
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_name = A.name

	return the_name

/datum/reagents/proc/get_master_reagent_id() // Returns the id of the reagent with the biggest69olume.
	var/the_id
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_id = A.id

	return the_id

/datum/reagents/proc/update_total() // Updates69olume.
	total_volume = 0
	for(var/datum/reagent/R in reagent_list)
		if(R.volume <69INIMUM_CHEMICAL_VOLUME)
			del_reagent(R.id)
		else
			total_volume += R.volume
	return

/datum/reagents/proc/handle_reactions()
	if(SSchemistry)
		SSchemistry.chem_mark_for_update(src)

//returns TRUE if the holder should continue reactiong, FALSE otherwise.
/datum/reagents/proc/process_reactions()
	if(!my_atom) //69o reactions in temporary holders
		return FALSE
	if(!my_atom.loc) //No reactions inside GC'd containers
		return FALSE
	if(my_atom.reagent_flags &69O_REACT) //69o reactions here
		return FALSE

	var/reaction_occured = FALSE
	var/list/eligible_reactions = list()

	var/temperature = chem_temp
	for(var/thing in reagent_list)
		var/datum/reagent/R = thing
		if(R.custom_temperature_effects(temperature))
			reaction_occured = TRUE
			continue

		// Check if the reagent is decaying or69ot.
		var/list/replace_self_with
		var/replace_message
		var/replace_sound

		if(LAZYLEN(R.chilling_products) && temperature <= R.chilling_point)
			replace_self_with = R.chilling_products
			replace_message =   "\The 69lowertext(R.name)69 69R.chilling_message69"
			replace_sound =     R.chilling_sound

		else if(LAZYLEN(R.heating_products) && temperature >= R.heating_point)
			replace_self_with = R.heating_products
			replace_message =   "\The 69lowertext(R.name)69 69R.heating_message69"
			replace_sound =     R.heating_sound

		// If it is, handle replacing it with the decay product.
		if(replace_self_with)
			var/replace_amount = R.volume / LAZYLEN(replace_self_with)
			del_reagent(R.id)
			for(var/product in replace_self_with)
				add_reagent(product, replace_amount)
			reaction_occured = TRUE

			if(my_atom)
				if(replace_message)
					my_atom.visible_message("<span class='notice'>\icon69my_atom69 69replace_message69</span>")
				if(replace_sound)
					playsound(my_atom, replace_sound, 80, 1)

		else // Otherwise, collect all possible reactions.
			eligible_reactions |= GLOB.chemical_reactions_list69R.id69

	var/list/active_reactions = list()

	for(var/datum/chemical_reaction/C in eligible_reactions)
		if(C.can_happen(src))
			active_reactions69C69 = 1 // The69umber is going to be 1/(fraction of remaining reagents we are allowed to use), computed below
			reaction_occured = TRUE

	var/list/used_reagents = list()
	// if two reactions share a reagent, each is allocated half of it, so we compute this here
	for(var/datum/chemical_reaction/C in active_reactions)
		var/list/adding = C.get_used_reagents()
		for(var/R in adding)
			LAZYADD(used_reagents69R69, C)

	for(var/R in used_reagents)
		var/counter = length(used_reagents69R69)
		if(counter <= 1)
			continue // Only used by one reaction, so69othing we69eed to do.
		for(var/datum/chemical_reaction/C in used_reagents69R69)
			active_reactions69C69 =69ax(counter, active_reactions69C69)
			counter-- //so the69ext reaction we execute uses69ore of the remaining reagents
			//69ote: this is69ot guaranteed to69aximize the size of the reactions we do (if one reaction is limited by reagent A, we69ay be over-allocating reagent B to it)
			// However, we are guaranteed to fully use up the69ost profligate reagent if possible.
			// Further reactions69ay occur on the69ext tick, when this runs again.

	for(var/thing in active_reactions)
		var/datum/chemical_reaction/C = thing
		C.process(src, active_reactions69C69)

	for(var/thing in active_reactions)
		var/datum/chemical_reaction/C = thing
		C.post_reaction(src)

	update_total()
	return reaction_occured

/* Holder-to-chemical */

/datum/reagents/proc/add_reagent(var/id,69ar/amount,69ar/data =69ull,69ar/safety = 0)
	if(!isnum(amount) || amount <= 0)
		return 0

	update_total()
	amount =69in(amount, get_free_space())

	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			current.volume += amount
			if(!isnull(data)) // For all we know, it could be zero or empty string and69eaningful
				current.mix_data(data, amount)
			update_total()
			if(!safety)
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change()
			return 1
	var/datum/reagent/D = GLOB.chemical_reagents_list69id69
	if(D)
		var/datum/reagent/R =69ew D.type()
		reagent_list += R
		R.holder = src
		R.volume = amount
		R.initialize_data(data)
		update_total()
		if(my_atom)
			if(isliving(my_atom))
				R.on_mob_add(my_atom) //Must occur befor it could posibly run on_mob_delete
			my_atom.on_reagent_change()

		if(!safety)
			handle_reactions()
		return 1
	else
		warning("69my_atom69 attempted to add a reagent called '69id69' which doesn't exist. (69usr69)")
	return 0

/datum/reagents/proc/remove_reagent(var/id,69ar/amount,69ar/safety = FALSE)
	if(!isnum(amount))
		return 0
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			current.volume -= amount // It can go69egative, but it doesn't69atter
			update_total() // Because this proc will delete it then
			if(!safety)
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change()
			return 1
	return 0

/datum/reagents/proc/del_reagent(var/id)
	for(var/datum/reagent/current in reagent_list)
		if (current.id == id)
			reagent_list -= current
			69del(current)
			update_total()
			if(my_atom)
				my_atom.on_reagent_change()
				if(isliving(my_atom))
					current.on_mob_delete(my_atom)

			return 0

/datum/reagents/proc/has_reagent(var/id,69ar/amount = 0)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			if(current.volume >= amount)
				return 1
			else
				return 0
	return 0

/datum/reagents/proc/has_any_reagent(var/list/check_reagents)
	for(var/datum/reagent/current in reagent_list)
		if(current.id in check_reagents)
			if(current.volume >= check_reagents69current.id69)
				return 1
			else
				return 0
	return 0

/datum/reagents/proc/has_all_reagents(var/list/check_reagents)
	//this only works if check_reagents has69o duplicate entries... hopefully okay since it expects an associative list
	var/missing = check_reagents.len
	for(var/datum/reagent/current in reagent_list)
		if(current.id in check_reagents)
			if(current.volume >= check_reagents69current.id69)
				missing--
	return !missing

/datum/reagents/proc/clear_reagents()
	for(var/datum/reagent/current in reagent_list)
		del_reagent(current.id)
	return

/datum/reagents/proc/get_reagent_amount(var/id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.volume
	return 0

/datum/reagents/proc/get_data(var/id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.get_data()
	return 0

/datum/reagents/proc/log_list() // Used in attack logs
	if(!length(reagent_list))
		return "no reagents"
	var/list/data = list()
	for(var/r in reagent_list) //no reagents will be left behind
		var/datum/reagent/R = r
		data += "69R.id69 (69round(R.volume, 0.1)69u)"
		//Using IDs because SOME chemicals (I'm looking at you, chlorhydrate-beer) have the same69ames as other chemicals.
	return english_list(data)

/* Holder-to-holder and similar procs */

/datum/reagents/proc/remove_any(var/amount = 1) // Removes up to 69amount69 of reagents from 69src69. Returns actual amount removed.
	amount =69in(amount, total_volume)

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_remove = current.volume * part
		remove_reagent(current.id, amount_to_remove, 1)

	update_total()
	handle_reactions()
	return amount

// Transfers 69amount69 reagents from 69src69 to 69target69,69ultiplying them by 69multiplier69. Returns actual amount removed from 69src69 (not amount transferred to 69target69).
/datum/reagents/proc/trans_to_holder(datum/reagents/target, amount = 1,69ultiplier = 1, copy = 0)
	if(!istype(target))
		return

	amount =69ax(0,69in(amount, total_volume, target.get_free_space() /69ultiplier))

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_transfer = current.volume * part
		target.add_reagent(current.id, amount_to_transfer *69ultiplier, current.get_data(), safety = 1) // We don't react until everything is in place
		if(!copy)
			remove_reagent(current.id, amount_to_transfer, 1)

	if(!copy)
		handle_reactions()
	target.handle_reactions()
	return amount

/* Holder-to-atom and similar procs */

//The general proc for applying reagents to things. This proc assumes the reagents are being applied externally,
//not directly injected into the contents. It first calls touch, then the appropriate trans_to_*() or splash_mob().
//If for some reason touch effects are bypassed (e.g. injecting stuff directly into a reagent container or person),
//call the appropriate trans_to_*() proc.
/datum/reagents/proc/trans_to(datum/target, amount = 1,69ultiplier = 1, copy = 0, ignore_isinjectable = FALSE)
	if(istype(target, /datum/reagents))
		return trans_to_holder(target, amount,69ultiplier, copy)
	else if(istype(target, /atom))
		var/atom/A = target
		touch(A)
		if(ismob(target))
			return splash_mob(target, amount,69ultiplier, copy)
		if(isturf(target))
			return trans_to_turf(target, amount,69ultiplier, copy)
		if(isobj(target) && (A.is_injectable() || ignore_isinjectable))
			return trans_to_obj(target, amount,69ultiplier, copy)
	return 0

//Splashing reagents is69essier than trans_to, the target's loc gets some of the reagents as well.
/datum/reagents/proc/splash(var/atom/target,69ar/amount = 1,69ar/multiplier = 1,69ar/copy = 0,69ar/min_spill=0,69ar/max_spill=60)
	var/spill = 0
	if(!isturf(target) && target.loc)
		spill = amount*(rand(min_spill,69ax_spill)/100)
		amount -= spill
	if(spill)
		splash(target.loc, spill,69ultiplier, copy,69in_spill,69ax_spill)

	//Here we attempt to transfer some reagents to the target. But it can often fail,
	//like if you try to splash reagents onto an object that isn't an open container
	if (!trans_to(target, amount,69ultiplier, copy) && total_volume > 0)
		//If it fails, but we still have some69olume, then we'll just destroy some of our reagents
		remove_any(amount) //If we don't do this, then only the spill amount above is removed, and someone can keep splashing with the same beaker endlessly

/datum/reagents/proc/trans_id_to(atom/target, id, amount = 1, ignore_isinjectable = FALSE)
	if (!target || !target.reagents || !target.simulated)
		return

	amount =69in(amount, get_reagent_amount(id))

	if(!amount)
		return

	var/datum/reagents/F =69ew /datum/reagents(amount)
	var/tmpdata = get_data(id)
	F.add_reagent(id, amount, tmpdata)
	remove_reagent(id, amount)

	return F.trans_to(target, amount, ignore_isinjectable = ignore_isinjectable) // Let this proc check the atom's type

// When applying reagents to an atom externally, touch() is called to trigger any on-touch effects of the reagent.
// This does69ot handle transferring reagents to things.
// For example, splashing someone with water will get them wet and extinguish them if they are on fire,
// even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.
/datum/reagents/proc/touch(var/atom/target)
	if(ismob(target))
		touch_mob(target)
	if(isturf(target))
		touch_turf(target)
	if(isobj(target))
		touch_obj(target)
	return

/datum/reagents/proc/touch_mob(var/mob/target)
	if(!target || !istype(target) || !target.simulated)
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_mob(target, current.volume)

	update_total()

/datum/reagents/proc/touch_turf(var/turf/target)
	if(!target || !istype(target) || !target.simulated)
		return
	if(istype(target, /turf/simulated/open))
		var/turf/simulated/open/T = target
		if(T.isOpen())
			return TRUE // halt powder pile/smears creation without wasting reagents

	var/handled = TRUE
	for(var/datum/reagent/current in reagent_list)
		if(!current.touch_turf(target, current.volume))
			handled = FALSE
	update_total()
	return handled

/datum/reagents/proc/touch_obj(var/obj/target)
	if(!target || !istype(target) || !target.simulated)
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_obj(target, current.volume)

	update_total()

// Attempts to place a reagent on the69ob's skin.
// Reagents are69ot guaranteed to transfer to the target.
// Do69ot call this directly, call trans_to() instead.
/datum/reagents/proc/splash_mob(var/mob/target,69ar/amount = 1,69ar/multiplier = 1,69ar/copy = 0)
	if(isliving(target)) //will we ever even69eed to tranfer reagents to69on-living69obs?
		var/mob/living/L = target
		multiplier *= L.reagent_permeability()
	touch_mob(target)
	return trans_to_mob(target, amount, CHEM_TOUCH,69ultiplier, copy)

/datum/reagents/proc/trans_to_mob(var/mob/target,69ar/amount = 1,69ar/type = CHEM_BLOOD,69ar/multiplier = 1,69ar/copy = 0) // Transfer after checking into which holder...
	if(!target || !istype(target) || !target.simulated)
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(type == CHEM_BLOOD)
			var/datum/reagents/R = C.reagents
			return trans_to_holder(R, amount,69ultiplier, copy)
		if(type == CHEM_INGEST)
			var/datum/reagents/R = C.ingested
			return C.ingest(src,R, amount,69ultiplier, copy)
		if(type == CHEM_TOUCH)
			var/datum/reagents/R = C.touching
			return trans_to_holder(R, amount,69ultiplier, copy)
	else
		//If the target has a reagent holder, we'll try to put it there instead. This allows feeding simple animals
		if(target.reagents && type == CHEM_BLOOD || type == CHEM_INGEST)
			return trans_to_holder(target.reagents, amount,69ultiplier, copy)
		else
			var/datum/reagents/R =69ew /datum/reagents(amount)
			. = trans_to_holder(R, amount,69ultiplier, copy)
			R.touch_mob(target)

/datum/reagents/proc/trans_to_turf(var/turf/target,69ar/amount = 1,69ar/multiplier = 1,69ar/copy = 0) // Turfs don't have any reagents (at least, for69ow). Just touch it.
	if(!target || !target.simulated)
		return

	var/datum/reagents/R =69ew /datum/reagents(amount *69ultiplier)
	. = trans_to_holder(R, amount,69ultiplier, copy)

	if(!R.touch_turf(target))	//if touch turf was69ot handled
		switch(R.get_average_reagents_state())
			if(LI69UID)
				var/obj/effect/decal/cleanable/reagents/splashed/dirtoverlay = locate(/obj/effect/decal/cleanable/reagents/splashed, target)
				if (!dirtoverlay)
					dirtoverlay =69ew/obj/effect/decal/cleanable/reagents/splashed(target, reagents_to_add = R)
				else
					dirtoverlay.add_reagents(R)
			if(SOLID)
				var/obj/effect/decal/cleanable/reagents/piled/dirtoverlay = locate(/obj/effect/decal/cleanable/reagents/piled, target)
				if (!dirtoverlay)
					dirtoverlay =69ew/obj/effect/decal/cleanable/reagents/piled(target, reagents_to_add =  R)
				else
					dirtoverlay.add_reagents(R)
	return

/datum/reagents/proc/trans_to_obj(var/obj/target,69ar/amount = 1,69ar/multiplier = 1,69ar/copy = 0) // Objects69ay or69ay69ot; if they do, it's probably a beaker or something and we69eed to transfer properly; otherwise, just touch.
	if(!target || !target.simulated)
		return

	if(!target.reagents)
		var/datum/reagents/R =69ew /datum/reagents(amount *69ultiplier)
		. = trans_to_holder(R, amount,69ultiplier, copy)
		R.touch_obj(target)
		return

	return trans_to_holder(target.reagents, amount,69ultiplier, copy)

/datum/reagents/proc/expose_temperature(temperature, coeff=0.02)
	var/temp_delta = (temperature - chem_temp) * coeff
	if(temp_delta > 0)
		chem_temp =69in(chem_temp +69ax(temp_delta, 1), temperature)
	else
		chem_temp =69ax(chem_temp +69in(temp_delta, -1), temperature)
	chem_temp = round(chem_temp)
	handle_reactions()

//Returns the average specific heat for all reagents currently in this holder.
/datum/reagents/proc/specific_heat()
	/*
	. = 0
	var/cached_amount = total_volume		//cache amount
	var/list/cached_reagents = reagent_list		//cache reagents
	for(var/I in cached_reagents)
		var/datum/reagent/R = I
		. += R.specific_heat * (R.volume / cached_amount)
	*/
	// Reagent specific heat is69ot yet implemented, this is here for compatibility reasons
	return SPECIFIC_HEAT_DEFAULT

/datum/reagents/proc/adjust_thermal_energy(J,69in_temp = 2.7,69ax_temp = 1000)
	var/S = specific_heat()
	chem_temp = CLAMP(chem_temp + (J / (S * total_volume)), 2.7, 1000)

/// Is this holder full or69ot
/datum/reagents/proc/holder_full()
	if(total_volume >=69aximum_volume)
		return TRUE
	return FALSE

/// Like add_reagent but you can enter a list. Format it like this: list(/datum/reagent/toxin = 10, "beer" = 15)
/datum/reagents/proc/add_reagent_list(list/list_reagents, list/data=null)
	for(var/r_id in list_reagents)
		var/amt = list_reagents69r_id69
		add_reagent(r_id, amt, data)

/datum/reagents/proc/get_reagents()
	. = list()
	for(var/datum/reagent/current in reagent_list)
		. += "69current.name69 (69current.volume69)"
	return english_list(., "EMPTY", "", ", ", ", ")

/proc/get_chem_id(chem_name)
	for(var/X in GLOB.chemical_reagents_list)
		var/datum/reagent/R = GLOB.chemical_reagents_list69X69
		if(ckey(chem_name) == ckey(lowertext(R.name)))
			return X

//69anoUI / TG UI data
/datum/reagents/ui_data()
	var/list/data = list()

	data69"total_volume"69 = total_volume
	data69"maximum_volume"69 =69aximum_volume

	data69"chem_temp"69 = chem_temp

	var/list/contents = list()
	for(var/r in reagent_list)
		var/datum/reagent/R = r
		// list in a list because Byond69erges the first list...
		contents.Add(list(list("name" = R.name, "volume" = R.volume, "id" = R.id)))

	data69"contents"69 = contents

	return data


/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(max_vol)
	reagents =69ew /datum/reagents(max_vol, src)
