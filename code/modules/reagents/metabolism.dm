/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, or CHEM_BLOOD
	var/mob/living/carbon/parent

/datum/reagents/metabolism/New(var/max = 100, mob/living/carbon/parent_mob, var/met_class)
	..(max, parent_mob)
	
	metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/proc/metabolize()
	
	var/metabolism_type = 0 //non-human mobs
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		metabolism_type = H.species.reagent_tag

	for(var/current in reagent_list)
		var/datum/reagent/R = current

		parent.metabolism_effects.check_reagent(R)
		R.on_mob_life(parent, metabolism_type, metabolism_class)

	update_total()



// Lasting side effects from reagents: addictions, withdrawals.
/datum/metabolism_effects
	var/mob/living/carbon/parent
	var/list/datum/reagent/addiction_list = list()
	var/addiction_tick = 1

/datum/metabolism_effects/New(mob/living/carbon/parent_mob)
	..()
	if(istype(parent_mob))
		parent = parent_mob

/datum/metabolism_effects/proc/check_reagent(datum/reagent/R)
	if(R.addiction_threshold)
		if(R.volume >= R.addiction_threshold && !is_type_in_list(R, addiction_list))
			var/datum/reagent/new_reagent = new R.type()
			addiction_list.Add(new_reagent)
			addiction_list[new_reagent] = 0

	if(is_type_in_list(R, addiction_list))
		for(var/addiction in addiction_list)
			var/datum/reagent/A = addiction
			if(istype(R, A))
				addiction_list[A] = -15 // you're satisfied for a good while.


/datum/metabolism_effects/proc/process()

	if(addiction_tick == 6)
		addiction_tick = 1
		process_addictions()
	addiction_tick++

/datum/metabolism_effects/proc/process_addictions()
	for(var/addiction in addiction_list)
		var/datum/reagent/R = addiction
		if(!R)
			addiction_list.Remove(R)
			continue

		addiction_list[R]++

		switch(addiction_list[R])
			if(1 to 10)
				R.addiction_act_stage1(parent)
			if(10 to 20)
				R.addiction_act_stage2(parent)
			if(20 to 30)
				R.addiction_act_stage3(parent)
			if(30 to 40)
				R.addiction_act_stage4(parent)
			if(40 to INFINITY)
				R.addiction_end(parent)
				addiction_list.Remove(R)

/datum/metabolism_effects/proc/clear_effects()
	addiction_list.Cut()
