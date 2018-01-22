/obj/item/weapon/gun/projectile/revolver
	name = "FS REV .357 \"Miller\""
	desc = "The Frozen Star's Miller is a choice revolver for when you absolutely, positively need to put a hole in the other guy. Uses old school .357 ammo."
	icon_state = "revolver"
	item_state = "revolver"
	caliber = "357"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 7
	var/drawChargeMeter = TRUE
	ammo_type = /obj/item/ammo_casing/a357
	unload_sound 	= 'sound/weapons/guns/interact/rev_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/rev_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/rev_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/revolver_fire.ogg'
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round

/obj/item/weapon/gun/projectile/revolver/verb/spin_cylinder()
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

/obj/item/weapon/gun/projectile/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/weapon/gun/projectile/revolver/load_ammo(var/obj/item/A, mob/user)
	chamber_offset = 0
	return ..()

/obj/item/weapon/gun/projectile/revolver/proc/update_charge()
	if(!drawChargeMeter)
		return
	overlays.Cut()
	if(loaded.len==0)
		overlays += "[icon_state]_off"
	else
		overlays += "[icon_state]_on"


/obj/item/weapon/gun/projectile/revolver/update_icon()
	update_charge()
