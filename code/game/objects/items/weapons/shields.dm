//** Shield Helpers
//These are shared by various items that have shield-like behaviour

//bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_parry_arc(mob/user, var/bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		attack_dir = get_dir(get_turf(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(get_turf(user), get_turf(attacker))
	else if(damage_source)
		attack_dir = get_dir(get_turf(user), get_turf(damage_source))

	if(!(attack_dir && (attack_dir & bad_arc)))
		return 1
	return 0

/proc/default_parry_check(mob/user, mob/attacker, atom/damage_source)
	//parry only melee attacks
	if(istype(damage_source, /obj/item/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(!check_parry_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/shield
	name = "shield"
	var/base_block_chance = 30
	var/slowdown_time = 1
	var/shield_integrity = 100
	var/shield_difficulty = 60
	style = STYLE_NEG_HIGH

/obj/item/shield/examine(var/mob/user)
	. = ..()
	switch(get_block_chance(user))
		if(0 to 30)
			to_chat(user, "So heavy... You feel doubtful in your ability to parry with this shield using only one hand until you grow stronger.")
		if(31 to 45)
			to_chat(user, "Holding this feels a little clumsy. Perhaps if you were a bit stronger...")
		if(46 to 55)
			to_chat(user, "A bit hefty, but you feel confident in your ability to parry with this shield.")
		if(56 to 70)
			to_chat(user, "The weight of this shield feels comfortable and maneuverable.")
		if(71 to INFINITY)
			to_chat(user, "You feel ready for a gladiator duel! Bring it on, roaches!")



/obj/item/shield/proc/get_wielder_skill(mob/user, stat_type)
	if(user && user.stats)
		return max(1,user.stats.getStat(stat_type))

	return 1 //STAT_LEVEL_MIN doesn't work due to division by zero error

/obj/item/shield/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(istype(damage_source, /obj/item/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_parry_arc(user, bad_arc, damage_source, attacker))
		if(prob(get_block_chance(user)))
			user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
			return 1
	return 0

/obj/item/shield/block_bullet(mob/user, var/obj/item/projectile/damage_source, def_zone)
	var/bad_arc = reverse_direction(user.dir)
	var/list/protected_area
	if(prob(50))
		protected_area = get_partial_protected_area(user)
	else protected_area = get_protected_area(user)
	if(protected_area.Find(def_zone) && check_shield_arc(user, bad_arc, damage_source))
		if(!damage_source.check_penetrate(src))
			visible_message(SPAN_DANGER("\The [user] blocks [damage_source] with \his [src]!"))
			playsound(user.loc, 'sound/weapons/shield/shieldblock.ogg', 50, 1)
			return 1
	return 0

/obj/item/shield/proc/check_shield_arc(mob/user, var/bad_arc, atom/damage_source = null, mob/attacker = null)
	//shield direction

	var/shield_dir = 0
	if(user.get_equipped_item(slot_l_hand) == src)
		shield_dir = turn(user.dir, 90)
	else if(user.get_equipped_item(slot_r_hand) == src)
		shield_dir = turn(user.dir, -90)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		attack_dir = get_dir(get_turf(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(get_turf(user), get_turf(attacker))
	else if(damage_source)
		attack_dir = get_dir(get_turf(user), get_turf(damage_source))

	//blocked directions
	if(user.get_equipped_item(slot_back) == src)
		if(attack_dir & bad_arc && attack_dir)
			return TRUE
		else
			return FALSE

	if(wielded && !(attack_dir && (attack_dir & bad_arc)))
		return TRUE
	else if(!(attack_dir == bad_arc) && !(attack_dir == reverse_direction(shield_dir)) && !(attack_dir == (bad_arc | reverse_direction(shield_dir))))
		return TRUE
	return FALSE

/obj/item/shield/proc/get_block_chance(mob/user)
	return shield_difficulty/(1+100/get_wielder_skill(user,STAT_ROB))+base_block_chance

/obj/item/shield/proc/get_protected_area(mob/user)
	return BP_ALL_LIMBS

/obj/item/shield/proc/get_partial_protected_area(mob/user)
	return get_protected_area(user)

/obj/item/shield/attack(mob/M, mob/user)
	if(isliving(M))
		var/mob/living/L = M
		if(L.slowdown < slowdown_time * 3)
			L.slowdown += slowdown_time
	return ..()

/obj/item/shield/buckler
	name = "tactical shield"
	desc = "A compact personal shield made of pre-preg aramid fibres designed to stop or deflect bullets without slowing down its wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tactical"
	item_state = "tactical"
	flags = CONDUCT
	slot_flags = SLOT_BELT|SLOT_BACK
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	throw_speed = 2
	throw_range = 6
	w_class = ITEM_SIZE_BULKY
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MATERIAL_GLASS = 5, MATERIAL_STEEL = 5, MATERIAL_PLASTEEL = 12)
	price_tag = 500
	attack_verb = list("shoved", "bashed")
	shield_integrity = 125
	var/cooldown = 0 //shield bash cooldown. based on world.time
	var/picked_by_human = FALSE
	var/mob/living/carbon/human/picking_human

/obj/item/shield/buckler/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/buckler/get_protected_area(mob/user)
	var/list/p_area = list(BP_CHEST)

	if(user.get_equipped_item(slot_back) == src)
		return p_area

	if(user.get_equipped_item(slot_l_hand) == src)
		p_area.Add(BP_L_ARM)
	else if(user.get_equipped_item(slot_r_hand) == src)
		p_area.Add(BP_R_ARM)

	return p_area

/obj/item/shield/buckler/get_partial_protected_area(mob/user)
	var/list/p_area = get_protected_area(user)
	p_area.Add(BP_GROIN, BP_HEAD)
	return p_area

/obj/item/shield/buckler/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/baton))
		on_bash(W, user)
	else
		..()

/obj/item/shield/buckler/proc/on_bash(var/obj/item/W, var/mob/user)
	if(cooldown < world.time - 25)
		user.visible_message(SPAN_WARNING("[user] bashes [src] with \his [W]!"))
		playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
		cooldown = world.time

/obj/item/shield/riot
	name = "ballistic shield"
	desc = "A heavy personal shield made of pre-preg aramid fibres designed to stop or deflect bullets and other projectiles fired at its wielder at the cost of mobility."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riot"
	item_state = "riot"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MATERIAL_GLASS = 10, MATERIAL_STEEL = 10, MATERIAL_PLASTEEL = 15)
	price_tag = 500
	base_block_chance = 45
	shield_difficulty = 35
	attack_verb = list("shoved", "bashed")
	shield_integrity = 135
	var/cooldown = 0 //shield bash cooldown. based on world.time
	var/picked_by_human = FALSE
	var/mob/living/carbon/human/picking_human

/obj/item/shield/riot/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/shield/shieldmelee.ogg', 50, 1)

/obj/item/shield/riot/get_block_chance(mob/user)
	if(MOVING_QUICKLY(user))
		return shield_difficulty/(1+100/get_wielder_skill(user,STAT_ROB))
	if(MOVING_DELIBERATELY(user))
		return shield_difficulty/(1+100/get_wielder_skill(user,STAT_ROB))+base_block_chance //diminishing returns

/obj/item/shield/riot/get_protected_area(mob/user)
	var/list/p_area = list(BP_CHEST, BP_GROIN, BP_HEAD)

	if(user.get_equipped_item(slot_back) == src)
		return p_area

	if(MOVING_QUICKLY(user))
		if(user.get_equipped_item(slot_l_hand) == src)
			p_area = list(BP_L_ARM)
		else if(user.get_equipped_item(slot_r_hand) == src)
			p_area = list(BP_R_ARM)
	else if(MOVING_DELIBERATELY(user) && wielded)
		p_area = BP_ALL_LIMBS

	if(user.get_equipped_item(slot_l_hand) == src)
		p_area.Add(BP_L_ARM)
	else if(user.get_equipped_item(slot_r_hand) == src)
		p_area.Add(BP_R_ARM)
	return p_area

/obj/item/shield/riot/get_partial_protected_area(mob/user)
	if(MOVING_DELIBERATELY(user))
		return BP_ALL_LIMBS
	else return get_protected_area(user)

/obj/item/shield/riot/New()
	RegisterSignal(src, COMSIG_ITEM_PICKED, .proc/is_picked)
	RegisterSignal(src, COMSIG_ITEM_DROPPED, .proc/is_dropped)
	return ..()

/obj/item/shield/riot/proc/is_picked()
	var/mob/living/carbon/human/user = loc
	if(istype(user))
		picked_by_human = TRUE
		picking_human = user
		RegisterSignal(picking_human, COMSIG_HUMAN_WALKINTENT_CHANGE, .proc/update_state)
		update_state()

/obj/item/shield/riot/proc/is_dropped()
	if(picked_by_human && picking_human)
		UnregisterSignal(picking_human, COMSIG_HUMAN_WALKINTENT_CHANGE)
		picked_by_human = FALSE
		picking_human = null

/obj/item/shield/riot/proc/update_state()
	if(!picking_human)
		return
	if(MOVING_QUICKLY(picking_human))
		item_state = "[initial(item_state)]_run"
		visible_message("[picking_human] lowers [gender_datums[picking_human.gender].his] [src.name].")
	else
		item_state = "[initial(item_state)]_walk"
		visible_message("[picking_human] raises [gender_datums[picking_human.gender].his] [src.name] to cover [gender_datums[picking_human.gender].him]self!")
	update_wear_icon()

/obj/item/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/baton))
		on_bash(W, user)
	else
		..()

/obj/item/shield/riot/proc/on_bash(var/obj/item/W, var/mob/user)
	if(cooldown < world.time - 25)
		user.visible_message(SPAN_WARNING("[user] bashes [src] with [W]!"))
		playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
		cooldown = world.time

/obj/item/shield/riot/dozershield
	name = "bulldozer shield"
	desc = "A crude beast of a shield hewn from slabs of metal welded to a locker door, it has been forged into a wall that stands between you and your foes."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dozershield"
	item_state = "dozershield"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_DANGEROUS
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	origin_tech = list()
	matter = list(MATERIAL_GLASS = 20, MATERIAL_STEEL = 20, MATERIAL_PLASTEEL = 10)
	price_tag = 200
	base_block_chance = 55
	shield_difficulty = 10
	shield_integrity = 160
	slowdown_hold = 1

/obj/item/shield/riot/dozershield/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/hammer) || istype(W, /obj/item/tool/sword))
		on_bash(W, user)
	else
		..()

/obj/item/shield/hardsuit
	name = "hardsuit shield"
	desc = "A massive ballistic shield that seems impossible to wield without mechanical assist."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hardshield"
	item_state = "hardshield"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	origin_tech = list()
	matter = list()
	price_tag = 0
	base_block_chance = 60
	shield_difficulty = 10
	attack_verb = list("smashed", "bashed")
	shield_integrity = 180
	var/cooldown = 0 //shield bash cooldown. based on world.time
	var/picked_by_human = FALSE
	var/mob/living/carbon/human/picking_human
	slowdown_hold = 3
	var/mob/living/creator
	var/cleanup = TRUE	// Should the shield despawn moments after being discarded by the summoner?
	var/init_procees = TRUE
	bad_type = /obj/item/shield/hardsuit

/obj/item/shield/hardsuit/get_protected_area(mob/user)
	var/list/p_area = list(BP_CHEST, BP_GROIN, BP_HEAD)

	if(user.get_equipped_item(slot_l_hand) == src)
		p_area.Add(BP_L_ARM)
	else if(user.get_equipped_item(slot_r_hand) == src)
		p_area.Add(BP_R_ARM)
	return p_area

/obj/item/shield/hardsuit/get_partial_protected_area(mob/user)
	return BP_ALL_LIMBS

/obj/item/shield/hardsuit/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/baton))
		on_bash(W, user)
	else
		..()

/obj/item/shield/hardsuit/proc/on_bash(var/obj/item/W, var/mob/user)
	if(cooldown < world.time - 25)
		user.visible_message(SPAN_WARNING("[user] bashes [src] with \his [W]!"))
		playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
		cooldown = world.time

/obj/item/shield/hardsuit/Initialize(mapload)
	. = ..()
	if(init_procees)
		START_PROCESSING(SSobj, src)

/obj/item/shield/hardsuit/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/shield/hardsuit/dropped()
	if(cleanup)
		spawn(1) if(src) qdel(src)

/obj/item/shield/hardsuit/Process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(isliving(loc))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		if(cleanup)
			spawn(1) if(src) qdel(src)

/*
 * Handmade shield
 */

/obj/item/shield/buckler/handmade
	name = "round handmade shield"
	desc = "A handmade stout shield, that protects the wielder while not weighting them down."
	icon_state = "buckler"
	item_state = "buckler"
	flags = null
	throw_speed = 2
	throw_range = 6
	matter = list(MATERIAL_STEEL = 6)
	base_block_chance = 35
	shield_difficulty = 65
	shield_integrity = 100

/obj/item/shield/buckler/handmade/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/extinguisher) || istype(W, /obj/item/storage/toolbox) || istype(W, /obj/item/melee))
		on_bash(W, user)
	else
		..()

/obj/item/shield/riot/tray
	name = "tray shield"
	desc = "A thin makeshift shield, but with a good size."
	icon_state = "tray_shield"
	item_state = "tray_shield"
	flags = CONDUCT
	throw_speed = 2
	throw_range = 4
	matter = list(MATERIAL_STEEL = 4)
	base_block_chance = 40
	shield_difficulty = 30
	shield_integrity = 85

/obj/item/shield/riot/tray/get_protected_area(mob/user)
	var/list/p_area = list(BP_CHEST, BP_HEAD, BP_L_ARM, BP_R_ARM, BP_GROIN)
	if(MOVING_DELIBERATELY(user) && wielded)
		p_area = BP_ALL_LIMBS
	return p_area

/obj/item/shield/riot/tray/get_partial_protected_area(mob/user)
	return BP_ALL_LIMBS

/obj/item/shield/riot/tray/get_block_chance(mob/user)
	return shield_difficulty/(1+100/get_wielder_skill(user,STAT_ROB))+base_block_chance

/*
 * Energy Shield
 */

/obj/item/shield/buckler/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	item_state = "eshield0"
	flags = CONDUCT
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_COVERT = 4)
	attack_verb = list("shoved", "bashed")
	var/active = 0
	base_block_chance = 35
	shield_difficulty = 70
	shield_integrity = 130

/obj/item/shield/buckler/energy/handle_shield(mob/user)
	if(!active)
		return 0 //turn it on first!
	. = ..()

	if(.)
		var/datum/effect/effect/system/spark_spread/spark_system = new
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/shield/buckler/energy/attack_self(mob/living/user as mob)
/*	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("You beat yourself in the head with [src]."))
		user.take_organ_damage(5)
	active = !active
*/
	if(active)
		force = WEAPON_FORCE_PAINFUL
		update_icon()
		w_class = ITEM_SIZE_BULKY
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] is now active."))

	else
		force = 3
		update_icon()
		w_class = ITEM_SIZE_TINY
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] can now be concealed."))

	add_fingerprint(user)
	return

/obj/item/shield/buckler/energy/update_icon()
	icon_state = "eshield[active]"
	item_state = "eshield[active]"
	update_wear_icon()
	if(active)
		set_light(1.5, 1.5, COLOR_LIGHTING_BLUE_BRIGHT)
	else
		set_light(0)

