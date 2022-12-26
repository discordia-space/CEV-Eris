//These are meant for spawning on maps, namely Away Missions.

//If someone can do this in a neater way, be my guest-Kor

//To do: Allow corpses to appear mangled, bloody, etc. Allow customizing the bodies appearance (they're all bald and white right now).

/obj/landmark/corpse
	name = "Unknown"
	icon_state = "player-black"
	var/mobname
	var/skintone				// Needs to be a negative number
	var/min_age
	var/max_age
	//var/gender				// Built-in byond variable
	var/corpseuniform			// Set this to an object path to have the slot filled with said object on the corpse.
	var/corpsesuit
	var/corpseshoes
	var/corpsegloves
	var/corpseradio
	var/corpseglasses
	var/corpsemask
	var/corpsehelmet
	var/corpsebelt
	var/corpsepocket1
	var/corpsepocket2
	var/corpseback
	var/corpseid = 0    		// Just set to 1 if you want them to have an ID
	var/corpseidjob 			// Needs to be in quotes, such as "Clown" or "Chef." This just determines what the ID reads as, not their access
	var/corpseidaccess 			// This is for access. See access.dm for which jobs give what access. Again, put in quotes. Use "Captain" if you want it to be all access.
	var/species = SPECIES_HUMAN
	var/injury_level = 0		// Number of times to inflict a random injury on the mob

/obj/landmark/corpse/Initialize()
	..()
	createCorpse()
	return INITIALIZE_HINT_QDEL

/obj/landmark/corpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/M = new /mob/living/carbon/human (src.loc)

	if(gender == NEUTER)
		gender = pick(MALE, FEMALE)
	M.gender = gender

	M.set_species(species)

	if(species)
		M.reset_hair()

	for(var/count in 1 to injury_level)
		M.take_overall_damage(30,10)

	// Kill the mob
	M.death(FALSE)
	for(var/obj/item/organ/O in M.internal_organs)
		O.die()
	M.pulse = PULSE_NONE			// Because killing a mob and its organs doesn't stop its pulse
	GLOB.human_mob_list -= M
	STOP_PROCESSING(SSmobs, src)

	if(mobname)
		M.real_name = mobname
	else
		M.real_name = M.species.get_random_name(gender)

	if(skintone)
		M.change_skin_tone(skintone)
	else
		if(prob(80))	// If I don't do this, we're going to have a bunch of black corpses everywhere
			M.change_skin_tone(rand(-80,-15))
		else
			M.change_skin_tone(rand(-200,-81))

	if(min_age && max_age)
		M.age = rand(min_age, max_age)
	else if(M.species.min_age && M.species.max_age)
		M.age = rand(M.species.min_age, M.species.max_age)

	if(corpseuniform)
		M.equip_to_slot_or_del(new corpseuniform(M), slot_w_uniform)
	if(corpsesuit)
		M.equip_to_slot_or_del(new corpsesuit(M), slot_wear_suit)
	if(corpseshoes)
		M.equip_to_slot_or_del(new corpseshoes(M), slot_shoes)
	if(corpsegloves)
		M.equip_to_slot_or_del(new corpsegloves(M), slot_gloves)
	if(corpseradio)
		M.equip_to_slot_or_del(new corpseradio(M), slot_l_ear)
	if(corpseglasses)
		M.equip_to_slot_or_del(new corpseglasses(M), slot_glasses)
	if(corpsemask)
		M.equip_to_slot_or_del(new corpsemask(M), slot_wear_mask)
	if(corpsehelmet)
		M.equip_to_slot_or_del(new corpsehelmet(M), slot_head)
	if(corpsebelt)
		M.equip_to_slot_or_del(new corpsebelt(M), slot_belt)
	if(corpsepocket1)
		M.equip_to_slot_or_del(new corpsepocket1(M), slot_r_store)
	if(corpsepocket2)
		M.equip_to_slot_or_del(new corpsepocket2(M), slot_l_store)
	if(corpseback)
		M.equip_to_slot_or_del(new corpseback(M), slot_back)

	var/datum/job/jobdatum = corpseidjob ? SSjob.GetJob(corpseidjob) : null
	if(jobdatum)
		jobdatum.equip(M)

	if(corpseid)
		var/datum/money_account/MA = create_account(M.real_name, rand(500,2000))
		var/datum/job/job_access = jobdatum
		if(corpseidaccess)
			job_access = SSjob.GetJob(corpseidaccess)
		var/obj/item/card/id/W = new(M)
		if(job_access)
			W.access = job_access.get_access()
		else
			W.access = list()
		W.assignment = pick(corpseidjob)
		W.associated_account_number = MA.account_number
		M.set_id_info(W)
		M.equip_to_slot_or_del(W, slot_wear_id)

// Eris corpses
/obj/landmark/corpse/hobo
	name = "Hobo"
	corpseuniform = /obj/item/clothing/under/turtleneck
	corpsesuit = /obj/item/clothing/suit/storage/leather_jacket
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	corpsepocket1 = /obj/item/modular_computer/pda
	corpsepocket2 = /obj/item/oddity/common/old_id
	corpseid = TRUE
	corpseidjob = list("Therapist", "Private Security", "Master Chef", "Researcher", "Market Analyst", "Colonist")
	injury_level = 4

/obj/landmark/corpse/excelsior
	name = "Unknown"
	corpseuniform = /obj/item/clothing/under/excelsior
	corpsesuit = /obj/item/clothing/suit/space/void/excelsior
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsegloves = /obj/item/clothing/gloves/security
	injury_level = 8

/obj/landmark/corpse/one_star
	name = "twisted skeletal remains"
	species = SPECIES_SKELETON
	min_age = 359	// OS disappeared in 2291, CEV Eris launched 2642. This means the skeleton of a child of 8 years would be 359 years old.
	max_age = 499	// Oldest skeleton is of a person of 140 years. Implies OS managed to extend life expectancy. Revise according to lore.
	corpseuniform = /obj/item/clothing/under/onestar
	corpsesuit = /obj/item/clothing/suit/storage/greatcoat/onestar
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpseradio = /obj/item/device/radio/headset
	corpsehelmet = /obj/item/clothing/head/onestar
	//corpseid = TRUE
	//corpseidjob = list("Therapist", "Private Security", "Master Chef", "Researcher", "Market Analyst", "Colonist")

/obj/landmark/corpse/one_star/void
	name = "warped skeletal remains"
	corpseuniform = /obj/item/clothing/under/onestar
	corpsesuit = /obj/item/clothing/suit/space/void/onestar		// Helmet won't spawn pre-equipped, but it's there
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpseradio = /obj/item/device/radio/headset
	//corpseid = TRUE
	//corpseidjob = list("Therapist", "Private Security", "Master Chef", "Researcher", "Market Analyst", "Colonist")

// Legacy corpses
/obj/landmark/corpse/syndicatesoldier
	name = "Syndicate Operative"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/vest
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsegloves = /obj/item/clothing/gloves/security
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/armor/helmet
	corpseback = /obj/item/storage/backpack
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"



/obj/landmark/corpse/syndicatecommando
	name = "Syndicate Commando"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/space/void/merc
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsegloves = /obj/item/clothing/gloves/security
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/syndicate
	corpseback = /obj/item/tank/jetpack/oxygen
	corpsepocket1 = /obj/item/tank/emergency_oxygen
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"

/obj/landmark/corpse/hobo
	name = "Hobo"
	corpseuniform = /obj/item/clothing/under/rank/assistant

///////////Civilians//////////////////////

/obj/landmark/corpse/chef
	name = "Chef"
	corpseuniform = /obj/item/clothing/under/rank/chef
	corpsesuit = /obj/item/clothing/suit/chef
	corpseshoes = /obj/item/clothing/shoes/reinforced
	corpseradio = /obj/item/device/radio/headset
	corpsehelmet = /obj/item/clothing/head/chefhat
	corpseid = 1
	corpseidjob = "Chef"

/obj/landmark/corpse/doctor
	name = "Medical doctor"
	corpseuniform = /obj/item/clothing/under/rank/medical
	corpseshoes = /obj/item/clothing/shoes/reinforced
	corpseradio = /obj/item/device/radio/headset
	corpsepocket1 = /obj/item/device/lighting/toggleable/flashlight/pen
	corpsebelt = /obj/item/storage/belt/medical/
	corpseid = 1
	corpseidjob = "Medical doctor"

/obj/landmark/corpse/engineer
	name = "Technomancer"
	corpseid = 1
	corpseidjob = "Technomancer"

/obj/landmark/corpse/engineer/rig
	corpsesuit = /obj/item/clothing/suit/space/void/engineering
	corpsemask = /obj/item/clothing/mask/breath

/obj/landmark/corpse/clown
	name = "Clown"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/bikehorn
	corpseback = /obj/item/storage/backpack/clown
	corpseid = 1
	corpseidjob = "Clown"
	//corpseidaccess = "Clown" //not exist

/obj/landmark/corpse/scientist
	name = "Scientist"
	corpseuniform = /obj/item/clothing/under/rank/scientist
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpseradio = /obj/item/device/radio/headset
	corpsesuit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	corpseid = 1
	corpseidjob = "Scientist"

/obj/landmark/corpse/miner
	name = "Guild Miner"
	corpseuniform = /obj/item/clothing/under/rank/miner
	corpseshoes = /obj/item/clothing/shoes/color/black
	corpseradio = /obj/item/device/radio/headset/headset_cargo
	corpseid = 1
	corpseidjob = "Guild Miner"

/obj/landmark/corpse/miner/rig
	corpsesuit = /obj/item/clothing/suit/space/void/mining
	corpsemask = /obj/item/clothing/mask/breath

/obj/landmark/corpse/security
	name = "Security Officer"
	corpseuniform = /obj/item/clothing/under/rank/security
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpseradio = /obj/item/device/radio/headset
	corpsesuit = /obj/item/clothing/suit/armor/vest/ironhammer
	corpsehelmet = /obj/item/clothing/head/armor/helmet/ironhammer

/obj/landmark/corpse/security/prisonguard
	name = "Prison Guard"
	corpsehelmet = null

/////////////////Officers//////////////////////

/obj/landmark/corpse/bridgeofficer
	name = "Bridge Officer"
	corpseradio = /obj/item/device/radio/headset
	corpseuniform = /obj/item/clothing/under/rank/first_officer
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseshoes = /obj/item/clothing/shoes/color/black
	corpseglasses = /obj/item/clothing/glasses/sunglasses
	corpseid = 1
	corpseidjob = "Bridge Officer"
	// corpseidaccess = "Captain"  // No reason for them to have all access on Eris

/obj/landmark/corpse/commander
	name = "Commander"
	corpseuniform = /obj/item/clothing/under/rank/first_officer
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseradio = /obj/item/device/radio/headset/heads/captain
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsemask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	corpsehelmet = /obj/item/clothing/head/centhat
	corpsegloves = /obj/item/clothing/gloves/security
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsepocket1 = /obj/item/flame/lighter/zippo
	corpseid = 1
	corpseidjob = "Commander"
	// corpseidaccess = "Captain"  // No reason for them to have all access on Eris


/////////////////Enemies//////////////////////

/obj/landmark/corpse/pirate
	name = "Pirate"
	corpseuniform = /obj/item/clothing/under/pirate
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsehelmet = /obj/item/clothing/head/bandana



/obj/landmark/corpse/pirate/ranged
	name = "Pirate Gunner"
	corpsesuit = /obj/item/clothing/suit/pirate
	corpsehelmet = /obj/item/clothing/head/pirate



/obj/landmark/corpse/russian
	name = "Russian"
	corpseuniform = /obj/item/clothing/under/soviet
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsehelmet = /obj/item/clothing/head/bearpelt

/obj/landmark/corpse/russian/ranged
	corpsehelmet = /obj/item/clothing/head/ushanka
