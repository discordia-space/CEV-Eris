/datum/job

	//The name of the job
	var/title = "NOPE"
	var/list/access = list()              // Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/flag = 0 	                      // Bitflags for the job
	var/department_flag = 0
	var/faction = "None"	              // Players will be allowed to spawn in as jobs that are set to "Station"
	var/total_positions = 0               // How many players can be this job
	var/spawn_positions = 0               // How many players can spawn in as this job
	var/current_positions = 0             // How many players have this job
	var/supervisors = null                // Supervisors, who this person answers to directly
	var/selection_color = "#ffffff"       // Selection screen color
	var/idtype = /obj/item/weapon/card/id // The type of the ID the player will have
	var/req_admin_notify                  // If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/department = null                 // Does this position have a department tag?
	var/head_position = 0                 // Is this position Command?
	var/minimum_character_age = 0
	var/ideal_character_age = 30
	var/list/also_known_languages = list()// additional chance based languages to all jobs.

	var/account_allowed = 1				  // Does this job type come with a station account?
	var/economic_modifier = 2			  // With how much does this job modify the initial account amount?

	var/survival_gear = /obj/item/weapon/storage/box/survival// Custom box for spawn in backpack
//job equipment
	var/uniform = /obj/item/clothing/under/color/grey
	var/shoes = /obj/item/clothing/shoes/black
	var/pda = /obj/item/device/pda
	var/hat = null
	var/suit = null
	var/gloves = null
	var/mask = null
	var/belt = null
	var/ear = /obj/item/device/radio/headset
	var/hand = null
	var/glasses = null
	var/suit_store = null

	var/list/backpacks = list(
		/obj/item/weapon/storage/backpack,
		/obj/item/weapon/storage/backpack/satchel_norm,
		/obj/item/weapon/storage/backpack/satchel
		)

	//Character stats modifers
	var/list/stat_modifers = list()

	//This will be put in backpack. List ordered by priority!
	var/list/put_in_backpack = list()

	/*For copy-pasting:
	implanted =
	uniform =
	pda =
	ear =
	shoes =
	suit =
	suit_store =
	gloves =
	mask =
	belt =
	hand =
	glasses =
	hat =

	put_in_backpack = list(

		)

	backpacks = list(
		/obj/item/weapon/storage/backpack,
		/obj/item/weapon/storage/backpack/satchel_norm,
		/obj/item/weapon/storage/backpack/satchel
		)
	*/

/datum/job/proc/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	//Put items in hands
	if(hand) H.equip_to_slot_or_del(new hand (H), slot_l_hand)

	//Put items in backpack
	if( H.backbag != 1 )
		var/backpack = backpacks[H.backbag-1]
		var/obj/item/weapon/storage/backpack/BPK = new backpack(H)
		if(H.equip_to_slot_or_del(BPK, slot_back,1))
			new survival_gear(BPK)
			for( var/path in put_in_backpack )
				new path(BPK)

	//Survival equipment


	//No-check items (suits, gloves, etc)
	if(ear)			H.equip_to_slot_or_del(new ear (H), slot_l_ear)
	if(shoes)		H.equip_to_slot_or_del(new shoes (H), slot_shoes)
	if(uniform)		H.equip_to_slot_or_del(new uniform (H), slot_w_uniform)
	if(suit)		H.equip_to_slot_or_del(new suit (H), slot_wear_suit)
	if(suit_store)	H.equip_to_slot_or_del(new suit_store (H), slot_s_store)
	if(mask)		H.equip_to_slot_or_del(new mask (H), slot_wear_mask)
	if(hat)			H.equip_to_slot_or_del(new hat (H), slot_head)
	if(gloves)		H.equip_to_slot_or_del(new gloves (H), slot_gloves)
	if(glasses)		H.equip_to_slot_or_del(new glasses (H), slot_glasses)

	//Belt and PDA
	if(belt)
		H.equip_to_slot_or_del(new belt (H), slot_belt)
		H.equip_to_slot_or_del(new pda (H), slot_l_store)
	else
		H.equip_to_slot_or_del(new pda (H), slot_belt)

	if(!H.back || !istype(H.back, /obj/item/weapon/storage/backpack))
		var/list/slots = list( slot_belt, slot_r_store, slot_l_store, slot_r_hand, slot_l_hand, slot_s_store )
		for( var/path in put_in_backpack )
			if( !slots.len ) break
			var/obj/item/I = new path(H)
			for( var/slot in slots )
				if( H.equip_to_slot_if_possible(I, slot, 0, 1, 0) )
					slots -= slot
					break
			if(istype(H.r_hand,/obj/item/weapon/storage))
				new path(H.r_hand)
			else if(istype(H.l_hand, /obj/item/weapon/storage))
				new path(H.l_hand)


	if(H.religion == "Christianity" && !locate(/obj/item/weapon/implant/core_implant/cruciform, H))
		var/obj/item/weapon/implant/core_implant/cruciform/C = new /obj/item/weapon/implant/core_implant/cruciform(H)

		C.install(H)
		C.activate()

	return TRUE

/datum/job/proc/add_stats(var/mob/living/carbon/human/target)
	if(!ishuman(target))
		return FALSE
	for(var/name in src.stat_modifers)
		target.stats.changeStat(name, stat_modifers[name])

	return TRUE

/datum/job/proc/add_additiional_language(var/mob/living/carbon/human/target)
	if(!ishuman(target))
		return FALSE

	var/mob/living/carbon/human/H = target

	if(!also_known_languages.len)
		return FALSE

	var/i

	for(i in also_known_languages)
		if(prob(also_known_languages[i]))
			H.add_language(i)

	return TRUE

/datum/job/proc/setup_account(var/mob/living/carbon/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	//give them an account in the station database
	var/species_modifier = (H.species ? economic_species_modifier[H.species.type] : 2)
	if(!species_modifier)
		species_modifier = economic_species_modifier[/datum/species/human]

	var/money_amount = one_time_payment(species_modifier)
	var/datum/money_account/M = create_account(H.real_name, money_amount, null)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> $[M.money]<br>"

		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	H << SPAN_NOTICE("<b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b>")

/datum/job/proc/one_time_payment(var/custom_factor = 1)
	return (rand(5,50) + rand(5, 50)) * economic_modifier * custom_factor

/datum/job/proc/get_access()
	return src.access.Copy()

/datum/job/proc/apply_fingerprints(var/mob/living/carbon/human/target)
	if(!istype(target))
		return 0
	for(var/obj/item/item in target.contents)
		apply_fingerprints_to_item(target, item)
	return 1

/datum/job/proc/apply_fingerprints_to_item(var/mob/living/carbon/human/holder, var/obj/item/item)
	item.add_fingerprint(holder,1)
	if(item.contents.len)
		for(var/obj/item/sub_item in item.contents)
			apply_fingerprints_to_item(holder, sub_item)

/datum/job/proc/is_position_available()
	return (current_positions < total_positions) || (total_positions == -1)
