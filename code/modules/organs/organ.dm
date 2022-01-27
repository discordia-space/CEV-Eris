/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	germ_level = 0
	matter = list(MATERIAL_BIOMATTER = 20)
	bad_type = /obj/item/organ
	spawn_tags = SPAWN_TAG_ORGAN

	// Strings.
	var/surgery_name					// A special69ame that replaces item69ame in surgery69essages
	var/organ_tag = "organ"				// Unique identifier.
	var/parent_organ_base = BP_CHEST	// Base organ holding this object.
	var/dead_icon

	// Status tracking.
	var/status =69ONE					//69arious status flags
	var/vital = FALSE					// Lose a69ital limb, die immediately.
	var/damage = 0						// Current damage to the organ

	// Type of69odification, (If you ever69eed to apply several types69ake this a bit flag)
	var/nature =69ODIFICATION_ORGANIC

	// Reference data.
	var/mob/living/carbon/human/owner	// Current69ob owning the organ.
	var/obj/item/organ/external/parent	// A limb the organ is currently attached to or installed in.
	var/list/transplant_data			// Transplant69atch data.
	var/list/autopsy_data = list()		// Trauma data for forensics.
	var/list/trace_chemicals = list()	// Traces of chemicals in the organ.
	var/datum/dna/dna
	var/datum/species/species

	// Damage69ars.
	var/min_bruised_damage = 10			// Damage before considered bruised
	var/min_broken_damage = 30			// Damage before becoming broken
	var/max_damage						// Damage cap
	var/rejecting						// Is this organ already being rejected?

	var/death_time						// limits organ self recovery

/obj/item/organ/Destroy()
	if(parent || owner)
		removed()

	QDEL_NULL(dna)
	species =69ull
	STOP_PROCESSING(SSobj, src)

	return ..()

/obj/item/organ/proc/update_health()
	return

/obj/item/organ/New(mob/living/carbon/human/holder, datum/organ_description/OD)
	..(holder)
	create_reagents(5)
	if(!max_damage)
		max_damage =69in_broken_damage * 2

	if(istype(holder))
		species = all_species69SPECIES_HUMAN69
		if(holder.dna)
			dna = holder.dna.Clone()
			species = all_species69dna.species69

			if(!blood_DNA)
				blood_DNA = list()
			blood_DNA69dna.unique_enzymes69 = dna.b_type
		else
			log_debug("69src69 at 69loc69 spawned without a proper DNA.")

		if(parent_organ_base)
			replaced(holder.get_organ(parent_organ_base))
		else
			replaced_mob(holder)

// Surgery hooks
/obj/item/organ/attack_self(mob/living/user)
	if(do_surgery(user,69ull))
		return
	return ..()

/obj/item/organ/attackby(obj/item/I,69ob/living/user)
	if(do_surgery(user, I))
		return
	return ..()


/obj/item/organ/proc/set_dna(var/datum/dna/new_dna)
	if(new_dna)
		dna =69ew_dna.Clone()
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA.Cut()
		blood_DNA69dna.unique_enzymes69 = dna.b_type
		species = all_species69new_dna.species69

/obj/item/organ/proc/die()
	if(BP_IS_ROBOTIC(src))
		return
	damage =69ax_damage
	status |= ORGAN_DEAD
	STOP_PROCESSING(SSobj, src)
	death_time = world.time
	if(dead_icon)
		icon_state = dead_icon
	if(owner &&69ital && owner.stat != DEAD)
		owner.death()

/obj/item/organ/get_item_cost()
	if((status & ORGAN_DEAD) || species != all_species69SPECIES_HUMAN69) //No dead or69onkey organs!
		return 0
	return ..()


// Checks if the organ is in a freezer, an69MI or a stasis bag - it will69ot be processed then
/obj/item/organ/proc/is_in_stasis()
	if(istype(loc, /obj/item/device/mmi) || istype(loc, /mob/living/simple_animal/spider_core))
		return TRUE

	if(istype(loc, /obj/structure/closet/body_bag/cryobag) || istype(loc, /obj/structure/closet/crate/freezer) || istype(loc, /obj/item/storage/freezer))
		return TRUE

	return FALSE


/obj/item/organ/Process()

	if(loc != owner)
		owner =69ull

	//dead already,69o69eed for69ore processing
	if(status & ORGAN_DEAD)
		return
	// Don't process if we're in a freezer, an69MI or a stasis bag.or a freezer or something I dunno
	if(is_in_stasis())
		return

	//Process infections
	if (BP_IS_ROBOTIC(src) || (owner && owner.species && (owner.species.flags & IS_PLANT)))
		germ_level = 0
		return

	if(!owner)
		if(reagents)
			var/datum/reagent/organic/blood/B = locate(/datum/reagent/organic/blood) in reagents.reagent_list
			if(B && prob(40))
				reagents.remove_reagent("blood",0.1)
				blood_splatter(src,B,1)
		if(config.organs_decay) damage += rand(1,3)
		if(damage >=69ax_damage)
			damage =69ax_damage
		germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_TWO)
			germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_THREE)
			die()

	else if(owner && owner.bodytemperature >= 170)	//cryo stops germs from69oving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		handle_rejection()
		handle_germ_effects()

	//check if we've hit69ax_damage
	if(damage >=69ax_damage)
		die()

/obj/item/organ/examine(mob/user)
	..(user)
	if(status & ORGAN_DEAD)
		to_chat(user, SPAN_NOTICE("The decay has set in."))

/obj/item/organ/proc/handle_germ_effects()
	//** Handle the effects of infections
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
		germ_level--

	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 1569inutes
		if(antibiotics < 5 && prob(round(germ_level/6)))
			germ_level++

	if(germ_level >= INFECTION_LEVEL_ONE)
		var/fever_temperature = (owner.species.heat_level_1 - owner.species.body_temperature - 5)*69in(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		owner.bodytemperature += between(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)

	if (germ_level >= INFECTION_LEVEL_TWO)
		//spread germs
		if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30) ))
			parent.germ_level++

		if (prob(3))	//about once every 30 seconds
			take_damage(1,silent=prob(30))

/obj/item/organ/proc/handle_rejection()
	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to69ake it69atch.
	if(dna)
		if(!rejecting)
			if(blood_incompatible(dna.b_type, owner.dna.b_type, species, owner.species))
				rejecting = 1
		else
			rejecting++ //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						germ_level++
					if(51 to 200)
						germ_level += rand(1,2)
					if(201 to 500)
						germ_level += rand(2,3)
					if(501 to INFINITY)
						germ_level += rand(3,5)
						owner.reagents.add_reagent("toxin", rand(1,2))

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/rejuvenate()
	damage = 0

/obj/item/organ/proc/is_damaged()
	return damage > 0

/obj/item/organ/proc/is_bruised()
	return damage >=69in_bruised_damage

/obj/item/organ/proc/is_broken()
	return (damage >=69in_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

//Germs
/obj/item/organ/proc/handle_antibiotics()
	var/antibiotics = 0
	if(owner)
		antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (!germ_level || antibiotics < 5)
		return

	if (germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0	//cure instantly
	else if (germ_level < INFECTION_LEVEL_TWO)
		germ_level -= 6	//at germ_level == 500, this should cure the infection in a69inute
	else
		germ_level -= 2 //at germ_level == 1000, this will cure the infection in 569inutes

//Adds autopsy data for used_weapon.
/obj/item/organ/proc/add_autopsy_data(var/used_weapon,69ar/damage)
	var/datum/autopsy_data/W = autopsy_data69used_weapon69
	if(!W)
		W =69ew()
		W.weapon = used_weapon
		autopsy_data69used_weapon69 = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

//Note: external organs have their own69ersion of this proc
/obj/item/organ/proc/take_damage(amount,69ar/silent=0)
	if(BP_IS_ROBOTIC(src))
		src.damage = between(0, src.damage + (amount * 0.8),69ax_damage)
	else
		src.damage = between(0, src.damage + amount,69ax_damage)

		//only show this if the organ is69ot robotic
		if(owner && parent && amount > 0 && !silent)
			owner.custom_pain("Something inside your 69parent.name69 hurts a lot.", 1)

/obj/item/organ/proc/bruise()
	damage =69ax(damage,69in_bruised_damage)

/obj/item/organ/emp_act(severity)
	if(!BP_IS_ROBOTIC(src))
		return
	switch (severity)
		if (1)
			take_damage(12)
		if (2)
			take_damage(6)
		if (3)
			take_damage(3)

// Gets the limb this organ is located in, if any
/obj/item/organ/proc/get_limb()
	if(parent)
		return parent

	if(owner)
		return owner.get_organ(parent_organ_base)

	else if(istype(loc, /obj/item/organ/external))
		return loc

	return69ull


/obj/item/organ/proc/removed(mob/living/user)
	var/obj/item/organ/external/affected = get_limb()

	if(affected)
		affected.internal_organs -= src
		forceMove(affected.drop_location())
	else
		forceMove(get_turf(src))

	parent =69ull

	if(owner)
		removed_mob(user)


/obj/item/organ/proc/removed_mob(mob/living/user)
	var/datum/reagent/organic/blood/organ_blood = locate(/datum/reagent/organic/blood) in reagents?.reagent_list
	if(!organ_blood || !organ_blood.data69"blood_DNA"69)
		owner.vessel.trans_to(src, 5, 1, 1)

	if(vital && !(owner.status_flags & REBUILDING_ORGANS) && owner.stat != DEAD)
		if(user)
			admin_attack_log(user, owner, "Removed a69ital organ (69src69)", "Had a a69ital organ (69src69) removed.", "removed a69ital organ (69src69) from")
		owner.death()

	owner =69ull
	rejecting =69ull

	if(parent)
		forceMove(parent)

	START_PROCESSING(SSobj, src)


/obj/item/organ/proc/replaced(obj/item/organ/external/affected)
	parent = affected
	forceMove(parent)
	if(parent.owner)
		replaced_mob(parent.owner)


/obj/item/organ/proc/replaced_mob(mob/living/carbon/human/target)
	owner = target
	forceMove(owner)
	STOP_PROCESSING(SSobj, src)
	if(BP_IS_ROBOTIC(src))
		SEND_SIGNAL(owner, COMSIG_HUMAN_ROBOTIC_MODIFICATION)

	var/datum/reagent/organic/blood/transplant_blood = locate(/datum/reagent/organic/blood) in reagents?.reagent_list
	transplant_data = list()
	if(!transplant_blood)
		transplant_data69"species"69 =    owner.species.name
		transplant_data69"blood_type"69 = owner.dna.b_type
		transplant_data69"blood_DNA"69 =  owner.dna.unique_enzymes
	else
		transplant_data69"species"69 =    transplant_blood.data69"species"69
		transplant_data69"blood_type"69 = transplant_blood.data69"blood_type"69
		transplant_data69"blood_DNA"69 =  transplant_blood.data69"blood_DNA"69

/obj/item/organ/proc/heal_damage(amount)
	return

/obj/item/organ/proc/can_recover()
	return (max_damage > 0) && !(status & ORGAN_DEAD) || death_time >= world.time - ORGAN_RECOVERY_THRESHOLD

/obj/item/organ/proc/can_feel_pain()
	if(!owner)
		return FALSE

	if(BP_IS_ROBOTIC(src))
		return FALSE

	if(status & ORGAN_DEAD)
		return FALSE

	if(species && (species.flags &69O_PAIN))
		return FALSE

	if(owner.stat >= UNCONSCIOUS)
		return FALSE

	if(owner.analgesic >= 100)
		return FALSE

	return TRUE

/obj/item/organ/proc/is_usable()
	return !(status & (ORGAN_CUT_AWAY|ORGAN_MUTATED|ORGAN_DEAD))
