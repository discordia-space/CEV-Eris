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
	var/list/present_reagent_ids = list()

	var/list/datum/reagent/withdrawal_list = list()
	var/list/datum/reagent/active_withdrawals = list()
	var/list/datum/reagent/addiction_list = list()
	var/addiction_tick = 1

/datum/metabolism_effects/New(mob/living/carbon/parent_mob)
	..()
	if(istype(parent_mob))
		parent = parent_mob

/datum/metabolism_effects/proc/check_reagent(datum/reagent/R)
	present_reagent_ids += R.id

	// Withdrawals
	if(R.withdrawal_threshold && R.volume >= R.addiction_threshold && !is_type_in_list(R, withdrawal_list))
		if(R.volume >= R.withdrawal_threshold)
			var/datum/reagent/new_reagent = new R.type()
			new_reagent.max_dose = R.max_dose
			withdrawal_list.Add(new_reagent)
			withdrawal_list[new_reagent] = R.max_dose

	if(is_type_in_list(R, withdrawal_list))
		for(var/withdrawal in withdrawal_list)
			var/datum/reagent/A = withdrawal
			if(istype(R, A))
				withdrawal_list[A] = max(withdrawal_list[A], A.max_dose)

	// Addictions
	if(R.addiction_threshold)
		if(R.volume >= R.addiction_threshold && !is_type_in_list(R, addiction_list))
			var/datum/reagent/new_reagent = new R.type()
			new_reagent.max_dose = R.max_dose
			addiction_list.Add(new_reagent)
			addiction_list[new_reagent] = 0

	if(is_type_in_list(R, addiction_list))
		for(var/addiction in addiction_list)
			var/datum/reagent/A = addiction
			if(istype(R, A))
				addiction_list[A] = -15 // you're satisfied for a good while.


/datum/metabolism_effects/proc/process()
	process_withdrawals()

	if(addiction_tick == 6)
		addiction_tick = 1
		process_addictions()
	addiction_tick++

	present_reagent_ids.Cut()

/datum/metabolism_effects/proc/process_withdrawals()
	for(var/withdrawal in withdrawal_list - active_withdrawals)
		var/datum/reagent/R = withdrawal
		if(!(R.id in present_reagent_ids))
			start_withdrawal(R)

	for(var/withdrawal in active_withdrawals)
		var/datum/reagent/R = withdrawal
		if((R.id in present_reagent_ids))
			stop_withdrawal(R)
			continue

		if(withdrawal_list[R] <= 0)
			stop_withdrawal(R)
			withdrawal_list.Remove(R)
			continue

		R.withdrawal_act(parent)
		withdrawal_list[R] -= R.withdrawal_rate

/datum/metabolism_effects/proc/start_withdrawal(datum/reagent/R)
	active_withdrawals += R
	R.withdrawal_start(parent)

/datum/metabolism_effects/proc/stop_withdrawal(datum/reagent/R)
	active_withdrawals -= R
	R.withdrawal_end(parent)


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
	for(var/withdrawal in active_withdrawals)
		stop_withdrawal(withdrawal)

	active_withdrawals.Cut()
	withdrawal_list.Cut()
	addiction_list.Cut()
