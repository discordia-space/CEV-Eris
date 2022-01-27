//Warning! If you change icon_state or item_state,69ake sure you change path for sneath as well. icons/obj/sneath.dmi
/obj/item/tool/sword/nt // not supposed to be in the game, had to69ake the shortsword its own type to prevent fucking up the scourge. sorry.
	name = "NT Sword"
	desc = "A saintly-looking sword forged to do God's work."
	icon = 'icons/obj/nt_melee.dmi'
	icon_state = "nt_shortsword"
	item_state = "nt_shortsword"
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_WEAK
	armor_penetration = ARMOR_PEN_DEEP
	spawn_blacklisted = TRUE
	aspects = list(SANCTIFIED)
	price_tag = 300
	matter = list(MATERIAL_BIOMATTER = 25,69ATERIAL_STEEL = 5)
	bad_type = /obj/item/tool/sword/nt

/obj/item/tool/sword/nt/e69uipped(mob/living/M)
	..()
	if(is_held() && is_neotheology_disciple(M))
		embed_mult = 0.1
	else
		embed_mult = initial(embed_mult)

/obj/item/tool/sword/nt/shortsword
	name = "NT Gladius"
	desc = "A saintly-looking sword forged to do God's work."
	icon = 'icons/obj/nt_melee.dmi'
	icon_state = "nt_shortsword"
	item_state = "nt_shortsword"
	force = 25
	force_wielded_multiplier = 1.04
	throwforce = WEAPON_FORCE_WEAK
	armor_penetration = ARMOR_PEN_DEEP
	spawn_blacklisted = TRUE
	aspects = list(SANCTIFIED)
	price_tag = 300
	matter = list(MATERIAL_BIOMATTER = 25,69ATERIAL_STEEL = 5)



/obj/item/tool/sword/nt/longsword
	name = "NT Spatha"
	desc = "This saintly-looking longsword is the first choice of experienced crusaders."
	icon_state = "nt_longsword"
	item_state = "nt_longsword"
	force = 30
	armor_penetration = ARMOR_PEN_EXTREME
	w_class = ITEM_SIZE_HUGE
	price_tag = 1200
	matter = list(MATERIAL_BIOMATTER = 75,69ATERIAL_STEEL = 10,69ATERIAL_PLASTEEL = 5,69ATERIAL_DIAMOND = 1)


/obj/item/tool/knife/dagger/nt
	name = "NT Pugio"
	desc = "A saintly-looking dagger.69ay God have69ercy."
	icon = 'icons/obj/nt_melee.dmi'
	icon_state = "nt_dagger"
	item_state = "nt_dagger"
	force = WEAPON_FORCE_PAINFUL
	armor_penetration = ARMOR_PEN_MASSIVE
	aspects = list(SANCTIFIED)
	price_tag = 120
	matter = list(MATERIAL_BIOMATTER = 10,69ATERIAL_STEEL = 1)


/obj/item/tool/knife/dagger/nt/e69uipped(mob/living/H)
	..()
	if(is_held() && is_neotheology_disciple(H))
		embed_mult = 0.1
	else
		embed_mult = initial(embed_mult)


/obj/item/tool/sword/nt/halberd
	name = "NT Halebarda"
	desc = "A saintly-looking halberd for emergency situations."
	icon_state = "nt_halberd"
	item_state = "nt_halberd"
	wielded_icon = "nt_halberd_wielded"
	force = WEAPON_FORCE_BRUTAL
	hitsound = 'sound/weapons/melee/heavystab.ogg'
	armor_penetration = ARMOR_PEN_HALF
	max_upgrades = 1
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	price_tag = 600
	matter = list(MATERIAL_BIOMATTER = 80,69ATERIAL_STEEL = 8,69ATERIAL_WOOD = 10,69ATERIAL_PLASTEEL = 2)

/obj/item/tool/sword/nt/scourge
	name = "NT Scourge"
	desc = "A saintly-looking whip that can be extended for69ore pain."
	icon_state = "nt_scourge"
	item_state = "nt_scourge"
	force = WEAPON_FORCE_ROBUST
	var/force_extended = WEAPON_FORCE_PAINFUL
	armor_penetration = ARMOR_PEN_MASSIVE
	var/armor_penetration_extended = ARMOR_PEN_HALF
	var/extended = FALSE
	var/agony = 20
	var/agony_extended = 45
	var/stun = 0
	w_class = ITEM_SIZE_BULKY
	price_tag = 1000
	matter = list(MATERIAL_BIOMATTER = 50,69ATERIAL_STEEL = 5,69ATERIAL_PLASTEEL = 2)

/obj/item/tool/sword/nt/scourge/attack_self(mob/user)
	if(isBroken)
		to_chat(user, SPAN_WARNING("\The 69src69 is broken."))
		return
	if(extended)
		unextend()
	else
		extend()

/obj/item/tool/sword/nt/scourge/proc/extend()
	extended = TRUE
	force += (force_extended - initial(force))
	armor_penetration += (armor_penetration_extended - initial(armor_penetration))
	agony += (agony_extended - initial(agony))
	slot_flags = null
	w_class = ITEM_SIZE_HUGE
	update_icon()

/obj/item/tool/sword/nt/scourge/proc/unextend()
	extended = FALSE
	w_class = initial(w_class)
	agony = initial(agony)
	slot_flags = initial(slot_flags)
	armor_penetration = initial(armor_penetration)
	refresh_upgrades() //it's also sets all to default
	update_icon()

/obj/item/tool/sword/nt/scourge/update_icon()
	if(extended)
		icon_state = initial(icon_state) + "_extended"
	else
		icon_state = initial(icon_state)
	..()

/obj/item/tool/sword/nt/scourge/apply_hit_effect(mob/living/carbon/human/target,69ob/living/user, hit_zone)
	..()
	if(ishuman(target))
		var/mob/living/carbon/human/O = target
		target.stun_effect_act(stun, agony, hit_zone, src)
		O.say(pick("OH", "LORD", "MERCY", "SPARE", "ME", "HAVE", "PLEASE"))

/obj/item/tool/sword/nt/spear
	name = "NT Pilum"
	desc = "A short, saintly-looking spear for throwing or use with a shield. The spear-tip usually deforms after being thrown at a target, but it can be hammered into shape again."
	icon_state = "nt_spear"
	item_state = "nt_spear"
	wielded_icon = "nt_spear_wielded"
	force = 24
	force_wielded_multiplier = 1.08
	var/tipbroken = FALSE
	var/force_broken = WEAPON_FORCE_NORMAL
	var/throwforce_broken = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK | SLOT_BELT
	throwforce = 75
	armor_penetration = ARMOR_PEN_HALF
	throw_speed = 3
	price_tag = 150
	allow_spin = FALSE
	matter = list(MATERIAL_BIOMATTER = 10,69ATERIAL_STEEL = 5) // easy to69ass-produce and arm the faithful

/obj/item/tool/sword/nt/spear/e69uipped(mob/living/W)
	..()
	if(is_held() && is_neotheology_disciple(W))
		embed_mult = 0.1
	else
		embed_mult = initial(embed_mult)

/obj/item/tool/sword/nt/spear/dropped(mob/living/W)
	embed_mult = 300
	..()

/obj/item/tool/sword/nt/spear/throw_impact(atom/hit_atom, speed)
	..()
	if(ismob(hit_atom) || isobj(hit_atom))
		tipbroken = TRUE
		force = force_broken
		throwforce = throwforce_broken
		visible_message(SPAN_DANGER("The spear-tip of the 69src69 bends into a useless shape!"))


/obj/item/tool/sword/nt/spear/examine(mob/user)
	..()
	if (tipbroken)
		to_chat(user, SPAN_WARNING("\The 69src69 is broken. It looks like it could be repaired with a hammer."))

/obj/item/tool/sword/nt/spear/attackby(obj/item/I,69ar/mob/user)
	..()
	if (I.has_69uality(69UALITY_HAMMERING))
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_HAMMERING, FAILCHANCE_EASY, STAT_MEC))
			to_chat(user, SPAN_NOTICE("You repair the damaged spear-tip."))
			tipbroken = FALSE
			force = initial(force)
			throwforce = initial(throwforce)


/obj/item/shield/riot/nt
	name = "NT Scutum"
	desc = "A saintly-looking shield.69ay God protect you. The leather straps on the back can hold69elee weapons."
	icon = 'icons/obj/nt_melee.dmi'
	icon_state = "nt_shield"
	item_state = "nt_shield"
	matter = list(MATERIAL_BIOMATTER = 50,69ATERIAL_STEEL = 10,69ATERIAL_PLASTEEL = 5,69ATERIAL_GOLD = 3)
	aspects = list(SANCTIFIED)
	spawn_blacklisted = TRUE
	price_tag = 1000
	base_block_chance = 45
	shield_difficulty = 40
	item_flags = DRAG_AND_DROP_UNE69UIP
	shield_integrity = 130
	var/obj/item/storage/internal/container
	var/storage_slots = 3
	var/max_w_class = ITEM_SIZE_HUGE
	var/list/can_hold = list(
		/obj/item/tool/sword/nt/shortsword,
		/obj/item/tool/sword/nt/spear,
		/obj/item/tool/knife/dagger/nt,
		/obj/item/tool/knife/neotritual,
		/obj/item/book/ritual/cruciform,
		)

/obj/item/shield/riot/nt/New()
	container = new /obj/item/storage/internal(src)
	container.storage_slots = storage_slots
	container.can_hold = can_hold
	container.max_w_class =69ax_w_class
	container.master_item = src
	..()

/obj/item/shield/riot/nt/proc/handle_attack_hand(mob/user as69ob)
	return container.handle_attack_hand(user)

/obj/item/shield/riot/nt/proc/handle_mousedrop(var/mob/user,69ar/atom/over_object)
	return container.handle_mousedrop(user, over_object)

/obj/item/shield/riot/nt/MouseDrop(obj/over_object)
	if(container.handle_mousedrop(usr, over_object))
		return TRUE
	return ..()

/obj/item/shield/riot/nt/attack_hand(mob/user as69ob)
	if (loc == user)
		container.open(user)
	else
		container.close_all()
		..()

	add_fingerprint(user)
	return

/obj/item/shield/riot/nt/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/melee/baton) || istype(W, /obj/item/tool/sword/nt))
		on_bash(W, user)
	else
		..()

/obj/item/shield/buckler/nt
	name = "NT Parma"
	desc = "A round shield adorned with a golden trim. The leather straps on the back can hold69elee weapons."
	icon = 'icons/obj/nt_melee.dmi'
	icon_state = "nt_buckler"
	item_state = "nt_buckler"
	matter = list(MATERIAL_BIOMATTER = 15,69ATERIAL_STEEL = 5,69ATERIAL_PLASTEEL = 2)
	aspects = list(SANCTIFIED)
	spawn_blacklisted = TRUE
	price_tag = 300
	base_block_chance = 35
	shield_difficulty = 70
	item_flags = DRAG_AND_DROP_UNE69UIP
	shield_integrity = 110
	var/obj/item/storage/internal/container
	var/storage_slots = 3
	var/max_w_class = ITEM_SIZE_HUGE
	var/list/can_hold = list(
		/obj/item/tool/sword/nt/shortsword,
		/obj/item/tool/sword/nt/spear,
		/obj/item/tool/knife/dagger/nt,
		/obj/item/tool/knife/neotritual,
		/obj/item/book/ritual/cruciform,
		)

/obj/item/shield/buckler/nt/New()
	container = new /obj/item/storage/internal(src)
	container.storage_slots = storage_slots
	container.can_hold = can_hold
	container.max_w_class =69ax_w_class
	container.master_item = src
	..()

/obj/item/shield/buckler/nt/proc/handle_attack_hand(mob/user as69ob)
	return container.handle_attack_hand(user)

/obj/item/shield/buckler/nt/proc/handle_mousedrop(var/mob/user,69ar/atom/over_object)
	return container.handle_mousedrop(user, over_object)

/obj/item/shield/buckler/nt/MouseDrop(obj/over_object)
	if(container.handle_mousedrop(usr, over_object))
		return TRUE
	return ..()

/obj/item/shield/buckler/nt/attack_hand(mob/user as69ob)
	if (loc == user)
		container.open(user)
	else
		container.close_all()
		..()

	add_fingerprint(user)
	return

/obj/item/shield/riot/nt/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/melee/baton) || istype(W, /obj/item/tool/sword/nt))
		on_bash(W, user)
	else
		..()
