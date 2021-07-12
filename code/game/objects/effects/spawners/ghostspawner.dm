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
	var/short_desc = "The mapper forgot to set this!"
	var/flavour_text = ""
	var/important_info = ""
	/// Lazy string list of factions that the spawned mob will be in upon spawn
	var/list/faction
	var/permanent = FALSE //If true, the spawner will not disappear upon running out of uses.
	var/random = FALSE //Don't set a name or gender, just go random
	var/uses = 1 //how many times can we spawn from it. set to -1 for infinite.
	var/assignedrole
	var/show_flavour = TRUE
	var/ghost_usable = TRUE
	// If the spawner is ready to function at the moment
	var/ready = TRUE

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/effect/mob_spawn/attack_ghost(mob/user)
	if(!loc || !ghost_usable)
		return
	var/ghost_role = alert(usr, "Become [mob_name]? (Warning, You can no longer be revived!)","Are you sure?","Yes","Cancel")
	if(ghost_role == "cancel")
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
	if(QDELETED(src) || QDELETED(user))
		return
	log_game("[key_name(user)] became [mob_name]")
	create(user)

/obj/effect/mob_spawn/Initialize(mapload)
	. = ..()
	/*if(faction)
		faction = string_list(faction)*/
	//if(instant || (mapload || (SSticker && SSticker.current_state > GAME_STATE_SETTING_UP)))
	//	INVOKE_ASYNC(src, .proc/create)
	//else if(ghost_usable)
		//AddElement(/datum/element/point_of_interest)
		//LAZYADD(GLOB.mob_spawners[name], src)

/*obj/effect/mob_spawn/Destroy()
	var/list/spawners = GLOB.mob_spawners[name]
	LAZYREMOVE(spawners, src)
	if(!LAZYLEN(spawners))
		GLOB.mob_spawners -= name
	return ..()*/

/obj/effect/mob_spawn/proc/allowspawn(mob/user)
	return TRUE

/obj/effect/mob_spawn/proc/special(mob/M)
	return

/obj/effect/mob_spawn/proc/equip(mob/M)
	return

/obj/effect/mob_spawn/proc/create(mob/user, newname)
	var/mob/living/M = new mob_type(get_turf(src)) //living mobs only
	if(!random || newname)
		if(newname)
			M.real_name = newname
		/*else if(!M.unique_name)
			M.real_name = mob_name ? mob_name : M.name*/
		if(!mob_gender)
			mob_gender = pick(MALE, FEMALE)
		M.gender = mob_gender
	equip(M)

	if(user?.ckey)
		M.ckey = user.ckey
		if(show_flavour)
			var/output_message = "<span class='infoplain'><span class='big bold'>[short_desc]</span></span>"
			if(flavour_text != "")
				output_message += "\n<span class='infoplain'><b>[flavour_text]</b></span>"
			if(important_info != "")
				output_message += "\n<span class='userdanger'>[important_info]</span>"
			to_chat(M, output_message)
		var/datum/mind/MM = M.mind
		if(assignedrole)
			M.mind.assigned_role = assignedrole
		special(M)
		MM.name = M.real_name
	if(uses > 0)
		uses--
	if(!permanent && !uses)
		qdel(src)
	return M

// Base version - place these on maps/templates.
/obj/effect/mob_spawn/human
	mob_type = /mob/living/carbon/human
	//Human specific stuff.
	var/decl/hierarchy/outfit/outfit = /decl/hierarchy/outfit
	var/mob_species = null //Set to make them a mutant race such as lizard or skeleton. Uses the datum typepath instead of the ID.
	var/disable_pda = TRUE
	var/disable_sensors = TRUE
	var/title = null
	var/alt_title = null
	var/equip_adjustments
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
	//these vars are for lazy mappers to override parts of the outfit
	//these cannot be null by default, or mappers cannot set them to null if they want nothing in that slot
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
		target.stats.changeStat(name, stat_modifiers[name])
	return TRUE

/obj/effect/mob_spawn/human/Initialize()
	if(ispath(outfit))
		outfit = new outfit()
	if(!outfit)
		outfit = new outfit
	return ..() 

/obj/effect/mob_spawn/human/equip(mob/living/carbon/human/H)
	if(mob_species)
		H.set_species(mob_species)
	if(outfit)
		outfit.equip(H, title, alt_title)
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