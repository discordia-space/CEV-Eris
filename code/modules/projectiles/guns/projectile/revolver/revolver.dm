/obj/item/gun/projectile/revolver
	name = "FS REV .40 Magnum \"Miller\""
	desc = "The \"Frozen Star\" \"Miller\" is a revolver of choice when you absolutely, positively need to make a hole in someone. Uses .40 Magnum ammo."
	icon = 'icons/obj/guns/projectile/revolver.dmi'
	icon_state = "revolver"
	item_state = "revolver"
	caliber = CAL_MAGNUM
	force = WEAPON_FORCE_NORMAL
	can_dual = TRUE
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 7
	ammo_type = /obj/item/ammo_casing/magnum
	magazine_type = /obj/item/ammo_magazine/slmagnum
	unload_sound = 'sound/weapons/guns/interact/rev_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/rev_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/rev_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/revolver_fire.ogg'
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 8)
	price_tag = 2000 //avasarala of revolver world
	fire_delay = 3 //all revolvers can fire faster, but have huge recoil
	damage_multiplier = 1.6
	penetration_multiplier = -0.3 // Insanely powerful handcannon, but worthless against heavy armor
	init_recoil = HANDGUN_RECOIL(1.2)
	var/drawChargeMeter = TRUE
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round
	gun_parts = list(/obj/item/part/gun/frame/miller = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/revolver = 1, /obj/item/part/gun/barrel/magnum = 1)
	serial_type = "FS"


/obj/item/gun/projectile/revolver/pickup(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/stylish = user
		if(stylish.style > 4)
			style_damage_multiplier = stylish.style / 4 // this is so two stylish users that both shoot each other once at full slickness
			to_chat(user, SPAN_NOTICE("You feel more confident with a revolver in your hand.")) // ends with the more stylish being the winner, commonly known as High Noon
		else
			style_damage_multiplier = 1
			to_chat(user, SPAN_WARNING("You don't feel stylish enough to use a revolver properly."))


/obj/item/gun/projectile/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message(SPAN_WARNING("\The [usr] spins the cylinder of \the [src]!"), \
	SPAN_NOTICE("You hear something metallic spin and click."))
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > loaded.len)
		chamber_offset = rand(0,max_shells - loaded.len)
	if (ishuman(usr))
		var/mob/living/carbon/human/stylish = usr
		stylish.regen_slickness()

/obj/item/gun/projectile/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun/projectile/revolver/load_ammo(obj/item/A, mob/user)
	. = ..()
	chamber_offset = 0
	if (. && ishuman(user)) // if it actually loaded and the user is human
		var/mob/living/carbon/human/stylish = user
		stylish.regen_slickness()

/obj/item/gun/projectile/revolver/proc/update_charge()
	if(!drawChargeMeter)
		return
	cut_overlays()
	if(loaded.len==0)
		overlays += "[icon_state]_off"
	else
		overlays += "[icon_state]_on"


/obj/item/gun/projectile/revolver/update_icon()
	update_charge()

/obj/item/gun/projectile/revolver/generate_guntags()
	..()
	gun_tags |= GUN_REVOLVER

/obj/item/part/gun/frame/miller
	name = "Miller frame"
	desc = "A Miller revolver frame. I hope you're feeling lucky, punk."
	icon_state = "frame_revolver"
	resultvars = list(/obj/item/gun/projectile/revolver)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/revolver
	barrelvars = list(/obj/item/part/gun/barrel/magnum)
