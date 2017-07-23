var/list/organ_cache = list()

/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	var/dead_icon
	germ_level = 0

	// Strings.
	var/organ_tag = "organ"           // Unique identifier.
	var/parent_organ = BP_CHEST       // Organ holding this object.
	var/obj/item/organ/external/parent

	// Status tracking.
	var/status = 0                    // Various status flags
	var/vital                         // Lose a vital limb, die immediately.
	var/damage = 0                    // Current damage to the organ
	var/robotic = 0

	// Reference data.
	var/mob/living/carbon/human/owner // Current mob owning the organ.
	var/list/transplant_data          // Transplant match data.
	var/list/autopsy_data = list()    // Trauma data for forensics.
	var/list/trace_chemicals = list() // Traces of chemicals in the organ.

	// Damage vars.
	var/min_bruised_damage = 10       // Damage before considered bruised
	var/min_broken_damage = 30        // Damage before becoming broken
	var/max_damage                    // Damage cap
	var/rejecting                     // Is this organ already being rejected?
	var/preserved = 0                 // If this is 1, prevents organ decay.

	var/datum/dna/dna
	var/datum/species/species


/obj/item/organ/New(var/mob/living/carbon/human/holder)
	..(holder)
	create_reagents(5)
	if(!max_damage)
		max_damage = min_broken_damage * 2

	install(holder)

/obj/item/organ/Destroy()
	if(owner)           owner = null
	if(parent)          parent = null
	if(transplant_data) transplant_data.Cut()
	if(autopsy_data)    autopsy_data.Cut()
	if(trace_chemicals) trace_chemicals.Cut()
	processing_objects -= src

	return ..()

// Move organ inside new owner and attach it.
/obj/item/organ/proc/install(mob/living/carbon/human/H, var/redraw_mob = 1)
	if(!istype(H))
		return 1

	owner = H
	forceMove(owner)
	if(parent_organ)
		parent = H.get_organ(parent_organ)

	if(H.dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[H.dna.unique_enzymes] = H.dna.b_type
	processing_objects -= src
	sync_to_owner()

/obj/item/organ/proc/removed(var/mob/living/user)
	if(!istype(owner))
		return

	loc = get_turf(owner)
	processing_objects |= src
	rejecting = null

	var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	if(!organ_blood || !organ_blood.data["blood_DNA"])
		owner.vessel.trans_to(src, 5, 1, 1)

	if(owner && vital)
		if(user)
			admin_attack_log(user, owner,
				"removed a vital organ ([src]) from [key_name(owner)]",
				"had a vital organ ([src]) removed by [key_name(user)]",
				"removed a vital organ ([src]) from"
			)
		owner.death()

	parent = null
	owner = null


/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)

	if(!istype(target)) return

	var/datum/reagent/blood/transplant_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	transplant_data = list()
	if(!transplant_blood)
		transplant_data["species"] =    target.species.name
		transplant_data["blood_type"] = target.dna.b_type
		transplant_data["blood_DNA"] =  target.dna.unique_enzymes
	else
		transplant_data["species"] =    transplant_blood.data["species"]
		transplant_data["blood_type"] = transplant_blood.data["blood_type"]
		transplant_data["blood_DNA"] =  transplant_blood.data["blood_DNA"]

	owner = target
	loc = owner
	processing_objects -= src
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[organ_tag] = src
	if(robotic)
		status |= ORGAN_ROBOT

/obj/item/organ/proc/sync_to_owner()
	return

/obj/item/organ/proc/get_icon()
	return null

/obj/item/organ/proc/get_icon_key()
	return

/obj/item/organ/proc/update_health()
	return


/obj/item/organ/New(var/mob/living/carbon/holder, var/datum/organ_description/OD)
	..(holder)
	var/internal = !istype(src, /obj/item/organ/external)
	create_reagents(5)
	if(!max_damage)
		max_damage = min_broken_damage * 2
	if(istype(holder))
		src.owner = holder
		species = all_species["Human"]
		if(holder.dna)
			dna = holder.dna.Clone()
			species = all_species[dna.species]
		else
			log_debug("[src] at [loc] spawned without a proper DNA.")
		var/mob/living/carbon/human/H = holder
		if(istype(H))
			if(internal)
				var/obj/item/organ/external/E = H.get_organ(parent_organ)
				if(E)
					if(E.internal_organs == null)
						E.internal_organs = list()
					E.internal_organs |= src
			if(dna)
				if(!blood_DNA)
					blood_DNA = list()
				blood_DNA[dna.unique_enzymes] = dna.b_type
				if(internal)
					H.internal_organs_by_name[src.organ_tag] = src
		if(internal)
			holder.internal_organs |= src
	if(internal)
		update_icon()

/obj/item/organ/proc/set_dna(var/datum/dna/new_dna)
	if(new_dna)
		dna = new_dna.Clone()
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA.Cut()
		blood_DNA[dna.unique_enzymes] = dna.b_type
		species = all_species[new_dna.species]


/obj/item/organ/proc/die()
	if(robotic >= ORGAN_ROBOT)
		return
	damage = max_damage
	status |= ORGAN_DEAD
	processing_objects -= src
	if(dead_icon)
		icon_state = dead_icon
	if(owner && vital)
		owner.death()

/obj/item/organ/process()

	if(loc != owner)
		owner = null

	//dead already, no need for more processing
	if(status & ORGAN_DEAD)
		return
	// Don't process if we're in a freezer, an MMI or a stasis bag.or a freezer or something I dunno
	if(istype(loc,/obj/item/device/mmi))
		return
	if(preserved)
		return
	//Process infections
	if ((robotic >= ORGAN_ROBOT) || (owner && owner.species && (owner.species.flags & IS_PLANT)))
		germ_level = 0
		return

	if(!owner)
		if(isturf(loc))
			var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
			if(B && prob(40))
				reagents.remove_reagent("blood",0.1)
				blood_splatter(src,B,1)
		if(config.organs_decay) damage += rand(1,3)
		if(damage >= max_damage)
			damage = max_damage
		germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_TWO)
			germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_THREE)
			die()

	else if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		handle_rejection()
		handle_germ_effects()

	//check if we've hit max_damage
	if(damage >= max_damage)
		die()


/obj/item/organ/proc/handle_germ_effects()
	//** Handle the effects of infections
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
		germ_level--

	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
		if(antibiotics < 5 && prob(round(germ_level/6)))
			germ_level++

	if(germ_level >= INFECTION_LEVEL_ONE)
		var/fever_temperature = (owner.species.heat_level_1 - owner.species.body_temperature - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		owner.bodytemperature += between(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)

	if (germ_level >= INFECTION_LEVEL_TWO)
		var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
		//spread germs
		if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30) ))
			parent.germ_level++

		if (prob(3))	//about once every 30 seconds
			take_damage(1,silent=prob(30))

/obj/item/organ/proc/handle_rejection()
	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to make it match.
	if(transplant_data)
		if(!rejecting && transplant_data && prob(20) && owner.dna && blood_incompatible(transplant_data["blood_type"],owner.dna.b_type,transplant_data["species"],owner.species))
			rejecting = 1
		else
			rejecting++ //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						take_damage(1)
					if(51 to 200)
						owner.reagents.add_reagent("toxin", 1)
						take_damage(1)
					if(201 to 500)
						take_damage(rand(2,3))
						owner.reagents.add_reagent("toxin", 2)
					if(501 to INFINITY)
						take_damage(4)
						owner.reagents.add_reagent("toxin", rand(3,5))

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/rejuvenate()
	damage = 0

/obj/item/organ/proc/is_damaged()
	return damage > 0

/obj/item/organ/proc/is_hurt()
	return damage > 5

/obj/item/organ/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

//Germs
/obj/item/organ/proc/handle_antibiotics()
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (!germ_level || antibiotics < 5)
		return

	if (germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0	//cure instantly
	else if (germ_level < INFECTION_LEVEL_TWO)
		germ_level -= 6	//at germ_level == 500, this should cure the infection in a minute
	else
		germ_level -= 2 //at germ_level == 1000, this will cure the infection in 5 minutes

//Adds autopsy data for used_weapon.
/obj/item/organ/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

//Note: external organs have their own version of this proc
/obj/item/organ/proc/take_damage(amount, var/silent=0)
	if(src.robotic >= ORGAN_ROBOT)
		src.damage = between(0, src.damage + (amount * 0.8), max_damage)
	else
		src.damage = between(0, src.damage + amount, max_damage)

		//only show this if the organ is not robotic
		if(owner && parent_organ && amount > 0)
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
			if(parent && !silent)
				owner.custom_pain("Something inside your [parent.name] hurts a lot.", 1)

/obj/item/organ/proc/bruise()
	damage = max(damage, min_bruised_damage)

/obj/item/organ/proc/robotize() //Being used to make robutt hearts, etc
	robotic = 2
	src.status &= ~ORGAN_BROKEN
	src.status &= ~ORGAN_BLEEDING
	src.status &= ~ORGAN_SPLINTED
	src.status &= ~ORGAN_CUT_AWAY
	src.status |= ORGAN_ROBOT
	src.status |= ORGAN_ASSISTED

/obj/item/organ/proc/mechassist() //Used to add things like pacemakers, etc
	robotize()
	src.status &= ~ORGAN_ROBOT
	robotic = 1
	min_bruised_damage = 15
	min_broken_damage = 35

/obj/item/organ/emp_act(severity)
	if(!(status & ORGAN_ROBOT))
		return
	switch (severity)
		if (1)
			take_damage(9)
		if (2)
			take_damage(3)
		if (3)
			take_damage(1)

/*
/obj/item/organ/emp_act(severity)
	switch(robotic)
		if(0)
			return
		if(1)
			switch(severity)
				if(1.0)
					take_damage(20,0)
					return
				if(2.0)
					take_damage(7,0)
					return
				if(3.0)
					take_damage(3,0)
					return
		if(2)
			switch(severity)
				if(1.0)
					take_damage(40,0)
					return
				if(2.0)
					take_damage(15,0)
					return
				if(3.0)
					take_damage(10,0)
					return
*/
/obj/item/organ/proc/can_feel_pain()
	return (robotic < ORGAN_ROBOT) && !(status & (ORGAN_CUT_AWAY|ORGAN_DEAD|ORGAN_DESTROYED))

/obj/item/organ/proc/is_usable()
	return !(status & (ORGAN_CUT_AWAY|ORGAN_MUTATED|ORGAN_DEAD))
