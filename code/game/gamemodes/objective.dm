//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
var/global/list/all_objectives = list()

/datum/objective
	var/datum/mind/owner = null			//Who owns the objective.
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = FALSE				//currently only used for custom objectives.

/datum/objective/New(var/text)
	all_objectives.Add(src)
	if(text)
		explanation_text = text
	..()

/datum/objective/Destroy()
	all_objectives.Remove(src)
	..()

/datum/objective/proc/check_completion()
	return completed

/datum/objective/proc/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in ticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2))
			possible_targets.Add(possible_target)
	if(possible_targets.len > 0)
		target = pick(possible_targets)


/datum/objective/proc/find_target_by_role(role, role_type = FALSE) //Option sets either to check assigned role or special role. Default to assigned.
	for(var/datum/mind/possible_target in ticker.minds)
		if((possible_target != owner) && ishuman(possible_target.current) && ((role_type ? possible_target.special_role : possible_target.assigned_role) == role))
			target = possible_target
			return


/datum/objective/assassinate


/datum/objective/assassinate/find_target()
	..()
	if(target && target.current)
		explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target


/datum/objective/assassinate/find_target_by_role(role, role_type = FALSE)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Assassinate [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target


/datum/objective/assassinate/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return TRUE
		return FALSE
	return TRUE


/datum/objective/anti_revolution/execute

/datum/objective/anti_revolution/execute/find_target()
	..()
	if(target && target.current)
		explanation_text = "[target.current.real_name], the [target.assigned_role] has extracted confidential information above their clearance. Execute \him[target.current]."
	else
		explanation_text = "Free Objective"
	return target


/datum/objective/anti_revolution/execute/find_target_by_role(role, role_type = FALSE)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "[target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] has extracted confidential information above their clearance. Execute \him[target.current]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/execute/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || !ishuman(target.current))
			return TRUE
		return FALSE
	return FALSE

/datum/objective/anti_revolution/brig
	var/already_completed = FALSE

/datum/objective/anti_revolution/brig/find_target()
	..()
	if(target && target.current)
		explanation_text = "Brig [target.current.real_name], the [target.assigned_role] for 20 minutes to set an example."
	else
		explanation_text = "Free Objective"
	return target


/datum/objective/anti_revolution/brig/find_target_by_role(role, role_type = FALSE)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Brig [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] for 20 minutes to set an example."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/brig/check_completion()
	if(already_completed)
		return TRUE

	if(target && target.current)
		if(target.current.stat == DEAD)
			return FALSE
		if(target.is_brigged(10 * 60 * 10))
			already_completed = TRUE
			return TRUE
		return FALSE
	return FALSE

/datum/objective/anti_revolution/demote

/datum/objective/anti_revolution/demote/find_target()
	..()
	if(target && target.current)
		explanation_text = "[target.current.real_name], the [target.assigned_role]  has been classified as harmful to [company_name]'s goals. Demote \him[target.current] to assistant."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/demote/find_target_by_role(role, role_type = FALSE)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "[target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] has been classified as harmful to [company_name]'s goals. Demote \him[target.current] to assistant."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/demote/check_completion()
	if(target && target.current && istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		var/obj/item/weapon/card/id/I = H.wear_id
		if(I)
			if(istype(I, /obj/item/device/pda))
				var/obj/item/device/pda/P = I
				I = P.id
			if(I.assignment == "Assistant")
				return TRUE
		else
			return FALSE
	return TRUE


/datum/objective/debrain

/datum/objective/debrain/find_target()
	..()
	if(target && target.current)
		explanation_text = "Steal the brain of [target.current.real_name]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/debrain/find_target_by_role(role, role_type = FALSE)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Steal the brain of [target.current.real_name] the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/debrain/check_completion()
	if(!target) //If it's a free objective.
		return TRUE
	if(!owner.current || owner.current.stat == DEAD)//If you're otherwise dead.
		return FALSE
	if(!target.current || !isbrain(target.current))
		return FALSE
	var/atom/A = target.current
	while(A.loc)			//check to see if the brainmob is on our person
		A = A.loc
		if(A == owner.current)
			return TRUE
	return FALSE


/datum/objective/protect

/datum/objective/protect/find_target()
	..()
	if(target && target.current)
		explanation_text = "Protect [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target


/datum/objective/protect/find_target_by_role(role, role_type = FALSE)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Protect [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/protect/check_completion()
	if(!target)
		return TRUE
	if(target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current))
			return FALSE
		return TRUE
	return FALSE


/datum/objective/hijack
	explanation_text = "Hijack the emergency shuttle by escaping alone."

/datum/objective/hijack/check_completion()
	if(!owner.current || owner.current.stat)
		return FALSE
	if(!emergency_shuttle.returned())
		return FALSE
	if(issilicon(owner.current))
		return FALSE

	var/area/first_escape_pod = locate(/area/shuttle/escape_pod1/centcom)
	var/area/second_escape_pod = locate(/area/shuttle/escape_pod2/centcom)
	var/list/protected_mobs = list(/mob/living/silicon/ai, /mob/living/silicon/pai)
	for(var/mob/living/player in player_list)
		if(player.type in protected_mobs)
			continue
		if(player.mind && (player.mind != owner))
			if(player.stat != DEAD)			//they're not dead!
				if(get_turf(player) in first_escape_pod || get_turf(player) in second_escape_pod)
					return FALSE
	return TRUE


/datum/objective/block
	explanation_text = "Do not allow any organic lifeforms to escape on the shuttle alive."


/datum/objective/block/check_completion()
	if(!istype(owner.current, /mob/living/silicon))
		return FALSE
	if(!emergency_shuttle.returned())
		return FALSE
	if(!owner.current)
		return FALSE

	var/area/first_escape_pod = locate(/area/shuttle/escape_pod1/centcom)
	var/area/second_escape_pod = locate(/area/shuttle/escape_pod2/centcom)
	var/protected_mobs[] = list(/mob/living/silicon/ai, /mob/living/silicon/pai, /mob/living/silicon/robot)
	for(var/mob/living/player in player_list)
		if(player.type in protected_mobs)
			continue
		if(player.mind)
			if(player.stat != 2)
				if(get_turf(player) in first_escape_pod || get_turf(player) in second_escape_pod)
					return FALSE
	return TRUE


/datum/objective/silence
	explanation_text = "Do not allow anyone to escape the station.  Only allow the shuttle to be called when everyone is dead and your story is the only one left."

/datum/objective/silence/check_completion()
	if(!emergency_shuttle.returned())
		return FALSE

	for(var/mob/living/player in player_list)
		if(player == owner.current)
			continue
		if(player.mind)
			if(player.stat != DEAD)
				var/turf/T = get_turf(player)
				if(!T)
					continue
				switch(T.loc.type)
					if(/area/shuttle/escape_pod1/centcom, /area/shuttle/escape_pod2/centcom)
						return FALSE
	return TRUE


// TODO: probably remove this objective as redundant
/datum/objective/escape
	explanation_text = "Escape on the shuttle or an escape pod alive and free."


/datum/objective/escape/check_completion()
	if(issilicon(owner.current))
		return FALSE
	if(isbrain(owner.current))
		return FALSE
	if(!emergency_shuttle.returned())
		return FALSE
	if(!owner.current || owner.current.stat == 2)
		return FALSE
	var/turf/location = get_area(owner.current)
	if(!location)
		return FALSE
	if(istype(location, /area/shuttle/escape_pod1/centcom) || istype(location, /area/shuttle/escape_pod2/centcom))
		if(istype(owner.current, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = owner.current
			if(!H.handcuffed)
				return TRUE
	return FALSE


/datum/objective/survive
	explanation_text = "Stay alive until the end."

/datum/objective/survive/check_completion()
	if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
		return FALSE
	if(issilicon(owner.current) && owner.current != owner.original)
		return FALSE
	return TRUE


// Similar to the anti-rev objective, but for traitors
/datum/objective/brig
	var/already_completed = FALSE

/datum/objective/brig/find_target()
	..()
	if(target && target.current)
		explanation_text = "Have [target.current.real_name], the [target.assigned_role] brigged for 10 minutes."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/brig/find_target_by_role(role, role_type = FALSE)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Have [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] brigged for 10 minutes."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/brig/check_completion()
	if(already_completed)
		return TRUE

	if(target && target.current)
		if(target.current.stat == DEAD)
			return FALSE
		// Make the actual required time a bit shorter than the official time
		if(target.is_brigged(10 * 60 * 5))
			already_completed = TRUE
			return TRUE
		return FALSE
	return FALSE


// Harm a crew member, making an example of them
/datum/objective/harm
	var/already_completed = FALSE

/datum/objective/harm/find_target()
	..()
	if(target && target.current)
		explanation_text = "Make an example of [target.current.real_name], the [target.assigned_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
	else
		explanation_text = "Free Objective"
	return target


/datum/objective/harm/find_target_by_role(role, role_type = FALSE)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Make an example of [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/harm/check_completion()
	if(already_completed)
		return TRUE

	if(target && target.current && istype(target.current, /mob/living/carbon/human))
		if(target.current.stat == DEAD)
			return FALSE

		var/mob/living/carbon/human/H = target.current
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_BROKEN)
				return TRUE

		for(var/limb_tag in H.species.has_limbs) //todo check prefs for robotic limbs and amputations.
			var/list/organ_data = H.species.has_limbs[limb_tag]
			var/limb_type = organ_data["path"]
			var/found
			for(var/obj/item/organ/external/E in H.organs)
				if(limb_type == E.type)
					found = TRUE
					break
			if(!found)
				return TRUE

		var/obj/item/organ/external/head/head = H.get_organ("head")
		if(head.disfigured)
			return TRUE
	return FALSE


/datum/objective/nuclear
	explanation_text = "Destroy the station with a nuclear device."


/datum/objective/steal
	var/obj/item/steal_target
	var/target_name

	var/global/possible_items[] = list(
		"the captain's antique laser gun" = /obj/item/weapon/gun/energy/captain,
		"a hand teleporter" = /obj/item/weapon/hand_tele,
		"an RCD" = /obj/item/weapon/rcd,
		"a jetpack" = /obj/item/weapon/tank/jetpack,
		"a captain's jumpsuit" = /obj/item/clothing/under/rank/captain,
		"a functional AI" = /obj/item/device/aicard,
		"a pair of magboots" = /obj/item/clothing/shoes/magboots,
		"the station blueprints" = /obj/item/blueprints,
		"a nasa voidsuit" = /obj/item/clothing/suit/space/void,
		"28 moles of plasma (full tank)" = /obj/item/weapon/tank,
		"a sample of slime extract" = /obj/item/slime_extract,
		"a piece of corgi meat" = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi,
		"a Moebius expedition overseer's jumpsuit" = /obj/item/clothing/under/rank/expedition_overseer,
		"a exultant's jumpsuit" = /obj/item/clothing/under/rank/exultant,
		"a Moebius biolab officer's jumpsuit" = /obj/item/clothing/under/rank/moebius_biolab_officer,
		"a Ironhammer commander's jumpsuit" = /obj/item/clothing/under/rank/ih_commander,
		"a First Officer's jumpsuit" = /obj/item/clothing/under/rank/first_officer,
		"the hypospray" = /obj/item/weapon/reagent_containers/hypospray,
		"the captain's pinpointer" = /obj/item/weapon/pinpointer,
		"an ablative armor vest" = /obj/item/clothing/suit/armor/laserproof,
	)

	var/global/possible_items_special[] = list(
		"nuclear gun" = /obj/item/weapon/gun/energy/gun/nuclear,
		"diamond drill" = /obj/item/weapon/pickaxe/diamonddrill,
		"bag of holding" = /obj/item/weapon/storage/backpack/holding,
		"hyper-capacity cell" = /obj/item/weapon/cell/big/hyper,
		"10 diamonds" = /obj/item/stack/material/diamond,
		"50 gold bars" = /obj/item/stack/material/gold,
		"25 refined uranium bars" = /obj/item/stack/material/uranium,
	)


/datum/objective/steal/proc/set_target(var/item_name)
	target_name = item_name
	steal_target = possible_items[target_name]
	if(!steal_target)
		steal_target = possible_items_special[target_name]
	explanation_text = "Steal [target_name]."
	return steal_target


/datum/objective/steal/find_target()
	return set_target(pick(possible_items))


/datum/objective/steal/proc/select_target()
	var/list/possible_items_all = possible_items + possible_items_special
	var/new_target = input("Select target:", "Objective target", steal_target) as null|anything in possible_items_all
	if(!new_target)
		return

	set_target(new_target)
	return steal_target

/datum/objective/steal/check_completion()
	if(!steal_target || !owner.current)
		return FALSE
	if(!isliving(owner.current))
		return FALSE
	var/list/all_items = owner.current.get_contents()
	switch(target_name)
		if("28 moles of plasma (full tank)","10 diamonds","50 gold bars","25 refined uranium bars")
			var/target_amount = text2num(target_name)//Non-numbers are ignored.
			var/found_amount = 0.0//Always starts as zero.

			for(var/obj/item/I in all_items) //Check for plasma tanks
				if(istype(I, steal_target))
					found_amount += (target_name == "28 moles of plasma (full tank)" ? (I:air_contents:gas["plasma"]) : (I:amount))
			return found_amount >= target_amount

		if("50 coins (in bag)")
			var/obj/item/weapon/moneybag/B = locate() in all_items

			if(B)
				var/target = text2num(target_name)
				var/found_amount = 0.0
				for(var/obj/item/weapon/coin/C in B)
					found_amount++
				return found_amount>=target

		if("a functional AI")

			for(var/obj/item/device/aicard/C in all_items) //Check for ai card
				for(var/mob/living/silicon/ai/M in C)
					if(istype(M, /mob/living/silicon/ai) && M.stat != 2) //See if any AI's are alive inside that card.
						return TRUE

			for(var/mob/living/silicon/ai/ai in world)
				var/turf/T = get_turf(ai)
				if(istype(T))
					var/area/check_area = get_area(ai)
					if(istype(check_area, /area/shuttle/escape_pod1/centcom))
						return TRUE
					if(istype(check_area, /area/shuttle/escape_pod2/centcom))
						return TRUE
		else
			for(var/obj/I in all_items) //Check for items
				if(istype(I, steal_target))
					return TRUE
	return FALSE


/datum/objective/download

/datum/objective/download/proc/gen_amount_goal()
	target_amount = rand(10, 20)
	explanation_text = "Download [target_amount] research levels."
	return target_amount

/datum/objective/download/check_completion()
	if(!ishuman(owner.current))
		return FALSE
	if(!owner.current || owner.current.stat == 2)
		return FALSE

	var/current_amount
	var/obj/item/weapon/rig/S
	if(istype(owner.current, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner.current
		S = H.back

	if(!istype(S) || !S.installed_modules || !S.installed_modules.len)
		return FALSE

	var/obj/item/rig_module/datajack/stolen_data = locate() in S.installed_modules
	if(!istype(stolen_data))
		return FALSE

	for(var/datum/tech/current_data in stolen_data.stored_research)
		if(current_data.level > 1)
			current_amount += (current_data.level - 1)

	return (current_amount < target_amount) ? 0 : 1


/datum/objective/capture

/datum/objective/capture/proc/gen_amount_goal()
	target_amount = rand(5, 10)
	explanation_text = "Accumulate [target_amount] capture points."
	return target_amount

/datum/objective/capture/check_completion() //Basically runs through all the mobs in the area to determine how much they are worth.
	var/captured_amount = 0
	var/area/centcom/holding/A = locate()

	for(var/mob/living/carbon/human/M in A) // Humans (and subtypes).
		var/worth = M.species.rarity_value
		if(M.stat == 2) //Dead folks are worth less.
			worth *= 0.5
			continue
		captured_amount += worth

	for(var/mob/living/carbon/alien/larva/M in A)//Larva are important for research.
		if(M.stat == 2)
			captured_amount += 0.5
			continue
		captured_amount += 1

	if(captured_amount < target_amount)
		return FALSE
	return TRUE


/datum/objective/absorb

/datum/objective/absorb/proc/gen_amount_goal(var/lowbound = 4, var/highbound = 6)
	target_amount = rand(lowbound, highbound)
	if(ticker)
		var/needed_count = 1 //autowin
		if (ticker.current_state == GAME_STATE_SETTING_UP)
			for(var/mob/new_player/P in player_list)
				if(P.client && P.ready && P.mind!=owner)
					needed_count ++
		else if(ticker.current_state == GAME_STATE_PLAYING)
			for(var/mob/living/carbon/human/P in player_list)
				if(P.client && !(P.mind.changeling) && P.mind != owner)
					needed_count ++
		target_amount = min(target_amount, needed_count)

	explanation_text = "Absorb [target_amount] compatible genomes."
	return target_amount

/datum/objective/absorb/check_completion()
	if(owner && owner.changeling && owner.changeling.absorbed_dna && (owner.changeling.absorbedcount >= target_amount))
		return TRUE
	else
		return FALSE

// Heist objectives.
/datum/objective/heist

/datum/objective/heist/proc/choose_target()
	return

/datum/objective/heist/kidnap

/datum/objective/heist/kidnap/choose_target()
	var/list/roles = list("Technomancer Exultant", "Moebius Expedition Overseer", "Moebius Roboticist", "Moebius Chemist", "Technomancer")
	var/list/possible_targets = list()
	var/list/priority_targets = list()

	for(var/datum/mind/possible_target in ticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2) && (!possible_target.special_role))
			possible_targets.Add(possible_target)
			for(var/role in roles)
				if(possible_target.assigned_role == role)
					priority_targets += possible_target
					continue

	if(priority_targets.len > 0)
		target = pick(priority_targets)
	else if(possible_targets.len > 0)
		target = pick(possible_targets)

	if(target && target.current)
		explanation_text = "We can get a good price for [target.current.real_name], the [target.assigned_role]. Take them alive."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/heist/kidnap/check_completion()
	if(target && target.current)
		if (target.current.stat == 2)
			return FALSE // They're dead. Fail.

		var/area/skipjack_station/start/A = locate()
		for(var/mob/living/carbon/human/M in A)
			if(target.current == M)
				return TRUE //They're restrained on the shuttle. Success.
	else
		return FALSE


/datum/objective/heist/loot

/datum/objective/heist/loot/choose_target()
	var/loot = "an object"
	switch(rand(1, 8))
		if(1)
			target = /obj/structure/particle_accelerator
			target_amount = 6
			loot = "a complete particle accelerator"
		if(2)
			target = /obj/machinery/the_singularitygen
			target_amount = 1
			loot = "a gravitational generator"
		if(3)
			target = /obj/machinery/power/emitter
			target_amount = 4
			loot = "four emitters"
		if(4)
			target = /obj/machinery/nuclearbomb
			target_amount = 1
			loot = "a nuclear bomb"
		if(5)
			target = /obj/item/weapon/gun
			target_amount = 6
			loot = "six guns"
		if(6)
			target = /obj/item/weapon/gun/energy
			target_amount = 4
			loot = "four energy guns"
		if(7)
			target = /obj/item/weapon/gun/energy/laser
			target_amount = 2
			loot = "two laser guns"
		if(8)
			target = /obj/item/weapon/gun/energy/ionrifle
			target_amount = 1
			loot = "an ion gun"

	explanation_text = "It's a buyer's market out here. Steal [loot] for resale."

/datum/objective/heist/loot/check_completion()
	var/total_amount = 0

	for(var/obj/O in locate(/area/skipjack_station/start))
		if(istype(O, target))
			total_amount++
		for(var/obj/I in O.contents)
			if(istype(I, target))
				total_amount++
		if(total_amount >= target_amount)
			return TRUE

	for(var/datum/mind/raider in raiders.current_antagonists)
		if(raider.current)
			for(var/obj/O in raider.current.get_contents())
				if(istype(O, target))
					total_amount++
				if(total_amount >= target_amount)
					return TRUE

	return FALSE


/datum/objective/heist/salvage

/datum/objective/heist/salvage/choose_target()
	switch(rand(1, 8))
		if(1)
			target = DEFAULT_WALL_MATERIAL
			target_amount = 300
		if(2)
			target = "glass"
			target_amount = 200
		if(3)
			target = "plasteel"
			target_amount = 100
		if(4)
			target = "plasma"
			target_amount = 100
		if(5)
			target = "silver"
			target_amount = 50
		if(6)
			target = "gold"
			target_amount = 20
		if(7)
			target = "uranium"
			target_amount = 20
		if(8)
			target = "diamond"
			target_amount = 20

	explanation_text = "Ransack the station and escape with [target_amount] [target]."

/datum/objective/heist/salvage/check_completion()
	var/total_amount = 0

	for(var/obj/item/O in locate(/area/skipjack_station/start))
		var/obj/item/stack/material/S
		if(istype(O, /obj/item/stack/material))
			if(O.name == target)
				S = O
				total_amount += S.get_amount()
		for(var/obj/I in O.contents)
			if(istype(I, /obj/item/stack/material))
				if(I.name == target)
					S = I
					total_amount += S.get_amount()

	for(var/datum/mind/raider in raiders.current_antagonists)
		if(raider.current)
			for(var/obj/item/O in raider.current.get_contents())
				if(istype(O,/obj/item/stack/material))
					if(O.name == target)
						var/obj/item/stack/material/S = O
						total_amount += S.get_amount()

	if(total_amount >= target_amount)
		return TRUE
	return FALSE


/datum/objective/heist/preserve_crew
	explanation_text = "Do not leave anyone behind, alive or dead."

/datum/objective/heist/preserve_crew/check_completion()
	if(raiders && raiders.is_raider_crew_safe())
		return TRUE
	return FALSE


//Borer objective(s).
/datum/objective/borer_survive
	explanation_text = "Survive in a host until the end of the round."

/datum/objective/borer_survive/check_completion()
	if(owner)
		var/mob/living/simple_animal/borer/B = owner
		if(istype(B) && B.stat < 2 && B.host && B.host.stat < 2)
			return TRUE
	return FALSE


/datum/objective/borer_reproduce
	explanation_text = "Reproduce at least once."

/datum/objective/borer_reproduce/check_completion()
	if(owner && owner.current)
		var/mob/living/simple_animal/borer/B = owner.current
		if(istype(B) && B.has_reproduced)
			return TRUE
	return FALSE


// Old cult objectives

/datum/objective/cult/survive
	explanation_text = "Our knowledge must live on."
	target_amount = 5

/datum/objective/cult/survive/New()
	..()
	explanation_text = "Our knowledge must live on. Make sure at least [target_amount] acolytes escape on the shuttle to spread their work on an another station."

/datum/objective/cult/survive/check_completion()
	var/acolytes_survived = 0
	if(!cult)
		return FALSE
	for(var/datum/mind/cult_mind in cult.current_antagonists)
		if (cult_mind.current && cult_mind.current.stat != 2)
			var/area/A = get_area(cult_mind.current)
			if(is_type_in_list(A, centcom_areas))
				acolytes_survived++
	if(acolytes_survived >= target_amount)
		return FALSE
	else
		return TRUE


/datum/objective/cult/eldergod
	explanation_text = "Summon Nar-Sie via the use of the appropriate rune (Hell join self). It will only work if nine cultists stand on and around it. The convert rune is join blood self."

/datum/objective/cult/eldergod/check_completion()
	return (locate(/obj/singularity/narsie/large) in machines)


/datum/objective/cult/sacrifice
	explanation_text = "Conduct a ritual sacrifice for the glory of Nar-Sie."

/datum/objective/cult/sacrifice/find_target()
	var/list/possible_targets = list()
	if(!possible_targets.len)
		for(var/mob/living/carbon/human/player in player_list)
			if(player.mind && !(player.mind in cult))
				possible_targets.Add(player.mind)
	if(possible_targets.len > 0)
		target = pick(possible_targets)
	if(target)
		explanation_text = "Sacrifice [target.name], the [target.assigned_role]. You will need the sacrifice rune (Hell blood join) and three acolytes to do so."

/datum/objective/cult/sacrifice/check_completion()
	return (target && cult && !cult.sacrificed.Find(target))


/datum/objective/rev/find_target()
	..()
	if(target && target.current)
		explanation_text = "Assassinate, capture or convert [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/rev/find_target_by_role(role, role_type = FALSE)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Assassinate, capture or convert [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/rev/check_completion()
	if(target && target.current)
		var/mob/living/carbon/human/H = target.current
		if(!istype(H))
			return TRUE
		if(H.stat == DEAD || H.restrained())
			return TRUE
		// Check if they're converted
		if(target in revs.current_antagonists)
			return TRUE
	return FALSE
