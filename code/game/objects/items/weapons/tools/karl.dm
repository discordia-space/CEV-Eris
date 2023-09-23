/obj/item/tool/karl
	name = "K.A.R.L"
	desc = "Kinetic Acceleration Reconfigurable Lodebreaker. Rock and stone to the bone, miner!"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	icon_state = "pickaxe"
	item_state = "pickaxe"
	w_class = ITEM_SIZE_BULKY
	matter = list(MATERIAL_STEEL = 6)
    origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
    attack_verb = list("hit", "pierced", "sliced", "attacked")
	hitsound = 'sound/weapons/melee/heavystab.ogg'

    // Damage related
    force = WEAPON_FORCE_DANGEROUS
	armor_divisor = ARMOR_PEN_HALF // It's a pickaxe. It's destined to poke holes in things, even armor.
	throwforce = WEAPON_FORCE_NORMAL
	sharp = TRUE
	structure_damage_factor = STRUCTURE_DAMAGE_DESTRUCTIVE //Drills and picks are made for getting through hard materials
    embed_mult = 1.2 //Digs deep
    
    // Spawn and value related
    spawn_blacklisted = TRUE
	rarity_value = 24

    // Turn on-off related
    toggleable = TRUE
	tool_qualities = list(QUALITY_EXCAVATION = 10, QUALITY_PRYING = 10) //So it still shares its switch off quality despite not yet being used.
	switched_off_qualities = list(QUALITY_EXCAVATION = 10, QUALITY_PRYING = 10, QUALITY_CUTTING = 5)
	switched_on_qualities = list(QUALITY_EXCAVATION = 10, QUALITY_WELDING = 10)
    suitable_cell = /obj/item/cell/medium
	use_power_cost = 1.5
    glow_color = COLOR_BLUE_LIGHT

    // Gun-mode related
    var/gunmode = FALSE  // TRUE when KARL is in gun mode
    var/obj/item/gun/energy/plasma/installation = /obj/item/gun/energy/plasma	// The inbuilt gun. Store as path to initialize a new gun on creation.
	var/projectile	        // Holder for bullettype
	var/shot_sound 			// What sound should play when the gun fires
	var/reqpower = 500		// Power needed to shoot
    

/obj/item/tool/karl/New()
	..()

    // Init inbuilt gun
	if(ispath(installation))
        installation = new installation
        projectile = installation.projectile_type
        shot_sound = installation.fire_sound

/obj/item/tool/karl/Destroy()
	QDEL_NULL(installation)
	.=..()

/obj/item/tool/karl/equipped(mob/user)
	..()
	update_icon()

/obj/item/tool/karl/dropped(mob/user)
	..()
	update_icon()

/obj/item/tool/karl/turn_on(mob/user)
	.=..()
	if(.)
		to_chat(user, SPAN_NOTICE("A dangerous energy blade now covers the edges of the tool."))

/obj/item/tool/karl/turn_off(mob/user)
	to_chat(user, SPAN_NOTICE("The energy blade switfly retracts."))
	..()

// Same values than /obj/item/proc/use_tool
/obj/item/tool/karl/use_tool(mob/living/user, atom/target, base_time, required_quality, fail_chance, required_stat, instant_finish_tier = 110, forced_sound = null, sound_repeat = 2.5 SECONDS)
    .=..()  // That proc will return TRUE only when everything was done right, and FALSE if something went wrong, ot user was unlucky.
    
    // Recharge upon successfull use when switched off
    if(. && !switched_on && cell)
        log_and_message_admins("Recharging KARL battery")
        cell.give(use_power_cost * 1 SECOND) // Enough to use the tool during 1 second

/obj/item/tool/karl/proc/toggle_safety_verb()
	set name = "Toggle K.A.R.L mode"
	set category = "Object"
	set src in view(1)

	toggle_karl_mode(usr)

/obj/item/tool/karl/proc/toggle_karl_mode(mob/user)
    gunmode = !gunmode
    to_chat(user, SPAN_NOTICE("\The [src] switches to [gunmode ? "gun" : "tool"] mode."))
    update_icon()

/obj/item/tool/karl/afterattack(atom/target, mob/user, proximity, params)

	if(isBroken)
		to_chat(user, SPAN_WARNING("\The [src] is broken."))
		return

    if(gunmode)
        if(!cell?.checked_use(reqpower))
            to_chat(user, SPAN_WARNING("[src] battery is dead or missing."))
            return
        shootAt(target, user.targeted_organ)
        return

	return ..()

/obj/item/tool/karl/proc/shootAt(var/mob/living/target, def_zone)

    // Check source and destination
	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if(!istype(T) || !istype(U))
		return
	
    // Launching projectile
	var/obj/item/projectile/A = new projectile(loc)
	playsound(loc, shot_sound, 75, 1)

	// Shooting Code
	A.launch(target, def_zone)
