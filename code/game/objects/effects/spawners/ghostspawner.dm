/obj/effect/mob_spawn
	name = "Mob Spawner"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryopod_0"
	var/mob_type = null
	var/mob_name = ""
	var/mob_gender = null
	var/instant = FALSE //fires on New
	var/short_desc = "The69apper forgot to set this!"
	var/flavour_text = ""
	var/important_info = ""
	/// Lazy string list of factions that the spawned69ob will be in upon spawn
	var/list/faction
	var/permanent = FALSE //If true, the spawner will not disappear upon running out of uses.
	var/random = FALSE //Don't set a name or gender, just go random
	var/uses = 1 //how69any times can we spawn from it. set to -1 for infinite.
	var/assignedrole
	var/show_flavour = TRUE
	var/ghost_usable = TRUE
	// If the spawner is ready to function at the69oment
	var/ready = TRUE

//ATTACK GHOST IGNORING PARENT RETURN69ALUE
/obj/effect/mob_spawn/attack_ghost(mob/user)
	if(!loc || !ghost_usable)
		return
	var/ghost_role = alert(usr, "Become 69mob_name69? (Warning, You can no longer be revived!)","Are you sure?","Yes","Cancel")
	if(ghost_role == "Cancel")
		return
	/*if(!(GLOB.ghost_role_flags & GHOSTROLE_SPAWNER) && !(flags_1 & ADMIN_SPAWNED_1))
		to_chat(user, span_warning("An admin has temporarily disabled non-admin ghost roles!"))
		return*/
	if(!uses)
		to_chat(user, warning("This spawner is out of charges!"))
		return
	/*if(is_banned_from(user.key, banType))
		to_chat(user, span_warning("You are jobanned!"))
		return*/
	if(!allowspawn(user))
		return
	if(69DELETED(src) || 69DELETED(user))
		return
	log_game("69key_name(user)69 became 69mob_name69")
	create(user)

/obj/effect/mob_spawn/Initialize(mapload)
	. = ..()
	/*if(faction)
		faction = string_list(faction)*/
	//if(instant || (mapload || (SSticker && SSticker.current_state > GAME_STATE_SETTING_UP)))
	//	INVOKE_ASYNC(src, .proc/create)
	//else if(ghost_usable)
		//AddElement(/datum/element/point_of_interest)
		//LAZYADD(GLOB.mob_spawners69name69, src)

/*obj/effect/mob_spawn/Destroy()
	var/list/spawners = GLOB.mob_spawners69name69
	LAZYREMOVE(spawners, src)
	if(!LAZYLEN(spawners))
		GLOB.mob_spawners -= name
	return ..()*/

/obj/effect/mob_spawn/proc/allowspawn(mob/user)
	return TRUE

/obj/effect/mob_spawn/proc/special(mob/M)
	return

/obj/effect/mob_spawn/proc/e69uip(mob/M)
	return

/obj/effect/mob_spawn/proc/create(mob/user, newname)
	var/mob/living/M = new69ob_type(get_turf(src)) //living69obs only
	if(!random || newname)
		if(newname)
			M.real_name = newname
		/*else if(!M.uni69ue_name)
			M.real_name =69ob_name ?69ob_name :69.name*/
		if(!mob_gender)
			mob_gender = pick(MALE, FEMALE)
		M.gender =69ob_gender
	e69uip(M)

	if(user?.ckey)
		M.ckey = user.ckey
		if(show_flavour)
			var/output_message = "<span class='infoplain'><span class='big bold'>69short_desc69</span></span>"
			if(flavour_text != "")
				output_message += "\n<span class='infoplain'><b>69flavour_text69</b></span>"
			if(important_info != "")
				output_message += "\n<span class='userdanger'>69important_info69</span>"
			to_chat(M, output_message)
		var/datum/mind/MM =69.mind
		if(assignedrole)
			M.mind.assigned_role = assignedrole
		special(M)
		MM.name =69.real_name
	if(uses > 0)
		uses--
	if(!permanent && !uses)
		69del(src)
	return69

// Base69ersion - place these on69aps/templates.
/obj/effect/mob_spawn/human
	mob_type = /mob/living/carbon/human
	//Human specific stuff.
	var/decl/hierarchy/outfit/outfit
	var/mob_species = null //Set to69ake them a69utant race such as lizard or skeleton. Uses the datum typepath instead of the ID.
	var/disable_pda = TRUE
	var/disable_sensors = TRUE
	var/title = null
	var/alt_title = null
	var/e69uip_adjustments
	assignedrole = "Ghost Role"
	var/list/stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

	var/husk = null
	//these69ars are for lazy69appers to override parts of the outfit
	//these cannot be null by default, or69appers cannot set them to null if they want nothing in that slot
	var/uniform = -1
	var/r_hand = -1
	var/l_hand = -1
	var/suit = -1
	var/shoes = -1
	var/gloves = -1
	var/ears = -1
	var/glasses = -1
	var/mask = -1
	var/head = -1
	var/belt = -1
	var/r_pocket = -1
	var/l_pocket = -1
	var/back = -1
	var/id = -1
	var/backpack_contents = -1
	var/suit_store = -1

	var/hairstyle
	var/facial_hairstyle
	var/haircolor
	var/facial_haircolor
	var/skin_tone

/obj/effect/mob_spawn/human/proc/add_stats(var/mob/living/carbon/human/target)
	for(var/name in src.stat_modifiers)
		target.stats.changeStat(name, stat_modifiers69name69)
	return TRUE

/obj/effect/mob_spawn/human/Initialize()
	if(ispath(outfit))
		outfit = outfit_by_type(outfit)
	if(!outfit)
		outfit = outfit_by_type()
	return ..()

/obj/effect/mob_spawn/human/e69uip(mob/living/carbon/human/H)
	if(mob_species)
		H.set_species(mob_species)
	if(outfit)
		outfit.e69uip(H, title, alt_title)
	add_stats(H)

/obj/effect/mob_spawn/human/alive
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"

//remnants of the opened sleepers
/obj/structure/empty_sleeper
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"

obj/effect/mob_spawn/human/Destroy()
	new/obj/structure/empty_sleeper(get_turf(src))
	return ..()
