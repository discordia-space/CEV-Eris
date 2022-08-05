/obj/item/gun/reagent
	name = "chemthrower"
	desc = "A handheld liquid dispenser."
	icon = 'icons/obj/guns/launcher/pneumatic.dmi'
	icon_state = "pneumatic"
	item_state = "pneumatic"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_BULKY
	fire_sound_text = "a loud swhoosh of flowing liquid"
	fire_delay = 6
	fire_sound = 'sound/weapons/tablehit1.ogg'
	rarity_value = 10//no price tag, high rarity

	init_firemodes = list(
		list(mode_name="Throw", mode_desc="Throws a ball of liquid", fire_delay=6),
		list(mode_name="Stream", mode_desc="Steady stream of liquid", mode_type = /datum/firemode/automatic, fire_delay=2),
	)

	var/list/beakers = list() //All containers inside the gun.
	var/max_beakers = 4
	var/projectile_type = /obj/item/projectile/reagent

	var/beaker_type = /obj/item/reagent_containers/glass/beaker
	var/list/starting_chems = list()

//Override this to avoid a runtime with suicide handling.
/obj/item/gun/reagent/handle_suicide(mob/living/user)
	to_chat(user, SPAN_WARNING("Shooting yourself with \a [src] is pretty tricky. You can't seem to manage it."))
	return

/obj/item/gun/reagent/New()
	..()
	if(starting_chems.len)
		for(var/chem in starting_chems)
			var/obj/B = new beaker_type(src)
			B.reagents.add_reagent(chem, 60)
			beakers += B
	update_icon()

/obj/item/gun/reagent/consume_next_projectile()
	if(has_reagents())
		var/obj/item/projectile/reagent/P = new projectile_type(src)
		if(istype(P))
			fill_liquid(P)
			return P

/obj/item/gun/reagent/proc/has_reagents()
	for(var/obj/item/reagent_containers/glass/beaker/B in beakers)
		if(B.reagents.total_volume)
			return TRUE
	return FALSE

/obj/item/gun/reagent/examine(mob/user)
	..()
	if(beakers.len)
		to_chat(user, SPAN_NOTICE("[src] contains:"))
		for(var/obj/item/reagent_containers/glass/beaker/B in beakers)
			if(B.reagents && B.reagents.reagent_list.len)
				for(var/datum/reagent/R in B.reagents.reagent_list)
					to_chat(user, SPAN_NOTICE("[R.volume] units of [R.name]"))

/obj/item/gun/reagent/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!istype(I, beaker_type))
			to_chat(user, SPAN_NOTICE("[I] doesn't seem to fit into [src]."))
			return
		if(beakers.len >= max_beakers)
			to_chat(user, SPAN_NOTICE("[src] already has [max_beakers] beakers in it - another one isn't going to fit!"))
			return
		var/obj/item/reagent_containers/glass/beaker/B = I
		user.drop_item()
		B.loc = src
		beakers += B
		to_chat(user, SPAN_NOTICE("You slot [B] into [src]."))
		src.updateUsrDialog()
		return 1
	..()

//fills the given projectile with reagents
/obj/item/gun/reagent/proc/fill_liquid(var/obj/item/projectile/reagent/LiquidProjectile)
	if(beakers.len)
		var/mix_amount = LiquidProjectile.volume/beakers.len
		for(var/obj/item/reagent_containers/glass/beaker/B in beakers)
			B.reagents.trans_to_obj(LiquidProjectile, mix_amount)

/obj/item/gun/reagent/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && beakers.len)
		var/obj/item/reagent_containers/glass/beaker/B = removeBeaker()
		user.put_in_active_hand(B)
		return
	..()

/obj/item/gun/reagent/proc/removeBeaker()
	if(beakers.len)
		var/obj/item/reagent_containers/glass/beaker/B = beakers[1]
		beakers -= B
		return B

/obj/item/gun/reagent/verb/quick_empty()
	set name = "Empty Beaker Storage"
	set category = "Object"
	set src in view(1)

	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return

	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	dump_it(T, usr)

/obj/item/gun/reagent/proc/dump_it(var/turf/target)
	if(!istype(target))
		return
	if(!Adjacent(usr))
		return
	if(!beakers.len)
		to_chat(usr, SPAN_NOTICE("[src] is already empty!"))
		return
	to_chat(usr, SPAN_NOTICE("You take out the beakers from [src]."))
	for(var/i=1 to beakers.len)
		var/obj/item/reagent_containers/glass/beaker/B = removeBeaker()
		B.forceMove(target)


/obj/item/gun/reagent/flame
	name = "chemthrower"
	desc = "A handheld liquid dispenser."
	icon = 'icons/obj/guns/launcher/pneumatic.dmi'
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE
	fire_sound_text = "a loud swhoosh of flowing liquid"
	fire_delay = 6
	fire_sound = 'sound/weapons/tablehit1.ogg'
	rarity_value = 10//no price tag, high rarity

	max_beakers = 4
	projectile_type = /obj/item/projectile/reagent/hot

/obj/item/gun/reagent/flame/fill_liquid(var/obj/item/projectile/reagent/LiquidProjectile)
	..()
	LiquidProjectile.damage_types[HEAT] = LiquidProjectile.reagents.total_volume
