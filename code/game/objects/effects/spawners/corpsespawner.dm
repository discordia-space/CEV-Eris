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

	corpseuniform = islist(corpseuniform) ? safepick(corpseuniform) : corpseuniform
	corpsesuit = islist(corpsesuit) ? safepick(corpsesuit) : corpsesuit
	corpseshoes = islist(corpseshoes) ? safepick(corpseshoes) : corpseshoes
	corpsegloves = islist(corpsegloves) ? safepick(corpsegloves) : corpsegloves
	corpseradio = islist(corpseradio) ? safepick(corpseradio) : corpseradio
	corpseglasses = islist(corpseglasses) ? safepick(corpseglasses) : corpseglasses
	corpsemask = islist(corpsemask) ? safepick(corpsemask) : corpsemask
	corpsehelmet = islist(corpsehelmet) ? safepick(corpsehelmet) : corpsehelmet
	corpsebelt = islist(corpsebelt) ? safepick(corpsebelt) : corpsebelt
	corpsepocket1 = islist(corpsepocket1) ? safepick(corpsepocket1) : corpsepocket1
	corpsepocket2 = islist(corpsepocket2) ? safepick(corpsepocket2) : corpsepocket2
	corpseback = islist(corpseback) ? safepick(corpseback) : corpseback

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
//	if(jobdatum)
//		jobdatum.equip(M)
//commented out so i can make realistic faction corpses and not have extra loot spawn

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
	corpseuniform = /obj/item/clothing/under/rank/assistant
	corpsesuit = /obj/item/clothing/suit/storage/ass_jacket
	corpseshoes = /obj/item/clothing/shoes/color/black
	corpseradio = /obj/item/device/radio/headset
	corpsepocket1 = /obj/item/modular_computer/pda
	//corpseid = TRUE
	//corpseidjob = list() find a way to pull from vagabond job titles
	injury_level = 4

/obj/landmark/corpse/excelsior
	name = "Unknown"
	corpseuniform = /obj/item/clothing/under/excelsior
	corpsesuit = /obj/item/clothing/suit/space/void/excelsior
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsegloves = /obj/item/clothing/gloves/security
	injury_level = 8

/obj/landmark/corpse/skeleton
	name = "skeletal corpse"
	species = SPECIES_SKELETON
	min_age = 35
	max_age = 250

/obj/landmark/corpse/skeleton/maint //They look like human remains. Some poor soul expired here, a million miles from home.
	name = "Eris Crewmember"
	corpseuniform = list(
		/obj/item/clothing/under/oldsec,
		/obj/item/clothing/under/rank/assistant,
		/obj/item/clothing/under/rank/assistant,
		/obj/item/clothing/under/rank/crewman,
		/obj/item/clothing/under/rank/crewman,
		/obj/item/clothing/under/genericw,
		/obj/item/clothing/under/genericb,
		/obj/item/clothing/under/genericr,
		/obj/item/clothing/under/black,
		/obj/item/clothing/under/leisure,
		/obj/item/clothing/under/color/grey,
		/obj/item/clothing/under/color/black
						)
	corpsesuit = list(
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/suit/armor/vest/warden,
		/obj/item/clothing/suit/armor/vest/toggle,
		/obj/item/clothing/suit/armor/vest/detective,
		/obj/item/clothing/suit/armor/platecarrier,
		/obj/item/clothing/suit/armor/vest/handmade,
		/obj/item/clothing/suit/armor/vest/handmade/full,
		/obj/item/clothing/suit/armor/flak,
		/obj/item/clothing/suit/storage/vest,
		null,//null is chance of not spawning
		null,
		null,
		null,
		null,
		null,
		/obj/item/clothing/suit/punkvest/cyber,
		/obj/item/clothing/suit/punkvest,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest/orange,
		/obj/item/clothing/suit/storage/hazardvest/black,
		/obj/item/clothing/suit/storage/cargo_jacket/black/old,
		/obj/item/clothing/suit/storage/cargo_jacket/black,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/toggle/hoodie/black,
		/obj/item/clothing/suit/storage/toggle/windbreaker,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/ass_jacket,
		/obj/item/clothing/suit/storage/ass_jacket, //increased chance of assistant jacket
		/obj/item/clothing/suit/storage/cyberpunksleek,
		/obj/item/clothing/suit/storage/bladerunner,
		/obj/item/clothing/suit/storage/bomj,
		/obj/item/clothing/suit/storage/leather_jacket,
		/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake,
		/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_jager,
		/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_snake,
		/obj/item/clothing/suit/fire,
		/obj/item/clothing/suit/poncho,
		/obj/item/clothing/suit/poncho/tactical,
		/obj/item/clothing/suit/space/emergency
					)
	corpseshoes = list(/obj/item/clothing/shoes/jackboots, /obj/item/clothing/shoes/color/black, null, /obj/item/clothing/shoes/workboots, /obj/item/clothing/shoes/reinforced)
	corpsegloves = list(/obj/item/clothing/gloves/thick, null, /obj/item/clothing/gloves/fingerless, null, /obj/item/clothing/gloves/security, null, /obj/item/clothing/gloves/insulated/cheap, null)//50% chance to not spawn gloves
	corpsehelmet = list(
		/obj/item/clothing/head/armor/helmet/tanker,
		/obj/item/clothing/head/armor/helmet/handmade,
		/obj/item/clothing/head/armor/helmet,
		/obj/item/clothing/head/armor/helmet/visor,
		/obj/item/clothing/head/armor/faceshield/riot,
		null,
		null,
		null, //20% chance to spawn no helmet/hat
		null,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat/visor,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/head/soft/sec,
		/obj/item/clothing/head/bandana/green,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/beret/oldsec,
		/obj/item/clothing/head/soft/green2soft,
		/obj/item/clothing/head/soft/tan2soft,
		/obj/item/clothing/head/space/emergency
		)
	min_age = 40
	max_age = 250
	//corpseid = TRUE
	//corpseidjob = list() find a way to pull from vagabond job titles. i have 0 clue how to do that but i will
	injury_level = 1

/obj/landmark/corpse/skeleton/fortress
	name = "skeletal corpse"
	corpsesuit = list(/obj/item/clothing/suit/armor/vest, null, /obj/item/clothing/suit/armor/vest/toggle, null, /obj/item/clothing/suit/storage/vest)
	corpsehelmet = list(/obj/item/clothing/head/armor/helmet, null, /obj/item/clothing/head/armor/helmet/visor, null, /obj/item/clothing/head/armor/faceshield/riot)

/obj/landmark/corpse/one_star
	name = "twisted skeletal remains"
	species = SPECIES_SKELETON
	min_age = 359	// OS disappeared in 2291, CEV Eris launched 2642. This means the skeleton of a child of 8 years would be 359 years old.
	max_age = 499	// Oldest skeleton is of a person of 140 years. Implies OS managed to extend life expectancy. Revise according to lore.
	corpseuniform = /obj/item/clothing/under/onestar
	corpsesuit = /obj/item/clothing/suit/storage/greatcoat/onestar
	corpseshoes = /obj/item/clothing/shoes/jackboots/ironhammer
	corpseradio = /obj/item/device/radio/headset
	corpsehelmet = /obj/item/clothing/head/onestar
	//corpseid = TRUE
	//corpseidjob = list("General", "Commisar", "Commander", "Captain", "Admiral", "Leiutennant")

/obj/landmark/corpse/one_star/void
	name = "warped skeletal remains"
	corpseuniform = /obj/item/clothing/under/onestar
	corpsesuit = /obj/item/clothing/suit/space/void/onestar		// Helmet won't spawn pre-equipped, but it's there
	corpseshoes = /obj/item/clothing/shoes/workboots
	corpsehelmet = null
	corpseradio = /obj/item/device/radio/headset

//Faction Corpses//
/obj/landmark/corpse/operative
	name = "Ironhammer Operative"
	corpseuniform = list(/obj/item/clothing/under/rank/security, /obj/item/clothing/under/rank/security/turtleneck)
	corpseshoes = /obj/item/clothing/shoes/jackboots/ironhammer
	corpsegloves = list(/obj/item/clothing/gloves/security/ironhammer, /obj/item/clothing/gloves/stungloves)
	corpseradio = /obj/item/device/radio/headset/headset_sec
	corpsesuit = list(/obj/item/clothing/suit/armor/vest/ironhammer, /obj/item/clothing/suit/armor/vest/full/ironhammer, /obj/item/clothing/suit/storage/vest/ironhammer)
	corpsehelmet = list(/obj/item/clothing/head/armor/helmet/ironhammer, /obj/item/clothing/head/soft/sec2soft, /obj/item/clothing/head/beret/sec/navy/officer, /obj/item/clothing/head/armor/bulletproof/ironhammer_nvg)
	corpseglasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	corpsemask = /obj/item/clothing/mask/balaclava/tactical
	corpsebelt = /obj/item/storage/belt/tactical/ironhammer
	corpseid = 1
	corpseidjob = "Ironhammer Operative"
	corpseidaccess = "ihoper"
	injury_level = 9

////LEGACY CORPSES////REPLACE WITH NEW CORPSES IF FOUND IN MAP////
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
