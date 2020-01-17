/obj/item/weapon/grenade/chem_grenade
	name = "grenade casing"
	icon_state = "chemg"
	item_state = "grenade"
	desc = "A hand made chemical grenade."
	w_class = ITEM_SIZE_SMALL
	force = WEAPON_FORCE_HARMLESS
	det_time = null
	unacidable = 1
	matter = list(MATERIAL_STEEL = 3)
	variance = 0.25

	var/can_be_modified = TRUE
	var/stage = 0
	var/state = 0
	var/path = 0
	var/obj/item/device/assembly_holder/detonator = null
	var/list/beakers = new/list()
	var/list/allowed_containers = list(/obj/item/weapon/reagent_containers/glass/beaker, /obj/item/weapon/reagent_containers/glass/bottle)
	var/affected_area = 3

/obj/item/weapon/grenade/chem_grenade/New()
	..()
	create_reagents(1000)

/obj/item/weapon/grenade/chem_grenade/attack_self(mob/user as mob)
	if(!stage || stage==1)
		if(detonator)
//				detonator.loc=src.loc
			detonator.detached()
			usr.put_in_hands(detonator)
			detonator=null
			det_time = null
			stage=0
			icon_state = initial(icon_state)
		else if(beakers.len)
			for(var/obj/B in beakers)
				beakers -= B
				user.put_in_hands(B)
		name = "unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]"
	if(stage > 1 && !active && clown_check(user))
		to_chat(user, SPAN_WARNING("You prime \the [name]!"))

		activate()
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()

/obj/item/weapon/grenade/chem_grenade/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(!can_be_modified)
		to_chat(user, SPAN_WARNING("This grenade is sealed and can't be modified."))
		return
	if(istype(W,/obj/item/device/assembly_holder) && (!stage || stage==1) && path != 2)
		var/obj/item/device/assembly_holder/det = W
		if(istype(det.left_assembly,det.right_assembly.type) || (!is_igniter(det.left_assembly) && !is_igniter(det.right_assembly)))
			to_chat(user, SPAN_WARNING("Assembly must contain one igniter."))
			return
		if(!det.secured)
			to_chat(user, SPAN_WARNING("Assembly must be secured with screwdriver."))
			return
		path = 1
		to_chat(user, SPAN_NOTICE("You add [W] to the metal casing."))
		playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, -3)
		user.remove_from_mob(det)
		det.loc = src
		detonator = det
		if(is_timer(detonator.left_assembly))
			var/obj/item/device/assembly/timer/T = detonator.left_assembly
			det_time = 10*T.time
		if(is_timer(detonator.right_assembly))
			var/obj/item/device/assembly/timer/T = detonator.right_assembly
			det_time = 10*T.time
		icon_state = initial(icon_state) +"_ass"
		name = "unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]"
		stage = 1
	else if(istype(W,/obj/item/weapon/tool/screwdriver) && path != 2)
		if(stage == 1)
			path = 1
			if(beakers.len)
				to_chat(user, SPAN_NOTICE("You lock the assembly."))
				name = "grenade"
			else
				to_chat(user, SPAN_NOTICE("You lock the empty assembly."))
				name = "fake grenade"
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
			icon_state = initial(icon_state) +"_locked"
			stage = 2
		else if(stage == 2)
			if(active && prob(95))
				to_chat(user, SPAN_WARNING("You trigger the assembly!"))
				prime()
				return
			else
				to_chat(user, SPAN_NOTICE("You unlock the assembly."))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
				name = "unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]"
				icon_state = initial(icon_state) + (detonator?"_ass":"")
				stage = 1
				active = 0
	else if(is_type_in_list(W, allowed_containers) && (!stage || stage==1) && path != 2)
		path = 1
		if(beakers.len == 2)
			to_chat(user, SPAN_WARNING("The grenade can not hold more containers."))
			return
		else
			if(W.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("You add \the [W] to the assembly."))
				user.drop_item()
				W.loc = src
				beakers += W
				stage = 1
				name = "unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]"
			else
				to_chat(user, SPAN_WARNING("\The [W] is empty."))

/obj/item/weapon/grenade/chem_grenade/examine(mob/user)
	..(user)
	if(detonator)
		to_chat(user, "With attached [detonator.name]")

/obj/item/weapon/grenade/chem_grenade/activate(mob/user as mob)
	if(active) return

	if(detonator)
		if(!is_igniter(detonator.left_assembly))
			detonator.left_assembly.activate()
			active = 1
		if(!is_igniter(detonator.right_assembly))
			detonator.right_assembly.activate()
			active = 1
	if(active)
		icon_state = initial(icon_state) + "_active"

		if(user)
			msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	return

/obj/item/weapon/grenade/chem_grenade/proc/primed(var/primed = 1)
	if(active)
		icon_state = initial(icon_state) + (primed?"_primed":"_active")

/obj/item/weapon/grenade/chem_grenade/prime()
	if(!stage || stage<2) return

	var/has_reagents = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
		if(G.reagents.total_volume) has_reagents = 1

	active = 0
	if(!has_reagents)
		icon_state = initial(icon_state) +"_locked"
		playsound(src.loc, 'sound/items/Screwdriver2.ogg', 50, 1)
		spawn(0) //Otherwise det_time is erroneously set to 0 after this
			if(is_timer(detonator.left_assembly)) //Make sure description reflects that the timer has been reset
				var/obj/item/device/assembly/timer/T = detonator.left_assembly
				det_time = 10*T.time
			if(is_timer(detonator.right_assembly))
				var/obj/item/device/assembly/timer/T = detonator.right_assembly
				det_time = 10*T.time
		return

	playsound(src.loc, 'sound/effects/bamf.ogg', 50, 1)

	for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
		G.reagents.trans_to_obj(src, G.reagents.total_volume)

	if(reagents.total_volume) //The possible reactions didnt use up all reagents.
		chem_splash(get_turf(src), affected_area, list(reagents), extra_heat=10)

	if(iscarbon(loc))		//drop dat grenade if it goes off in your hand
		var/mob/living/carbon/C = loc
		C.drop_from_inventory(src)
		C.throw_mode_off()

	invisibility = INVISIBILITY_MAXIMUM //Why am i doing this?
	spawn(50)		   //To make sure all reagents can work
		qdel(src)	   //correctly before deleting the grenade.


/obj/item/weapon/grenade/chem_grenade/large
	name = "large chem grenade"
	desc = "An oversized grenade that affects a larger area."
	icon_state = "large_grenade"
	allowed_containers = list(/obj/item/weapon/reagent_containers/glass)
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	affected_area = 4
	matter = list(MATERIAL_STEEL = 5)

/obj/item/weapon/grenade/chem_grenade/metalfoam
	name = "Asters \"Stop-Space\""
	icon_state = "foam"
	desc = "Used for emergency sealing of air breaches."
	can_be_modified = FALSE
	path = 1
	stage = 2

/obj/item/weapon/grenade/chem_grenade/metalfoam/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 30)
	B2.reagents.add_reagent("foaming_agent", 10)
	B2.reagents.add_reagent("pacid", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2

/obj/item/weapon/grenade/chem_grenade/incendiary
	name = "FS IG \"River\""
	desc = "Used for clearing rooms of living things."
	icon_state = "incendiary"
	can_be_modified = FALSE
	path = 1
	stage = 2

/obj/item/weapon/grenade/chem_grenade/incendiary/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 15)
	B1.reagents.add_reagent("fuel",20)
	B2.reagents.add_reagent("plasma", 15)
	B2.reagents.add_reagent("sacid", 15)
	B1.reagents.add_reagent("fuel",20)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2

/obj/item/weapon/grenade/chem_grenade/antiweed
	name = "Asters \"Flora Armageddon\""
	desc = "Used for purging large areas of invasive plant species. Contents under pressure. Do not directly inhale contents."
	icon_state = "foam"
	can_be_modified = FALSE
	path = 1
	stage = 2

/obj/item/weapon/grenade/chem_grenade/antiweed/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("plantbgone", 25)
	B1.reagents.add_reagent("potassium", 25)
	B2.reagents.add_reagent("phosphorus", 25)
	B2.reagents.add_reagent("sugar", 25)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2
	icon_state = "grenade"

/obj/item/weapon/grenade/chem_grenade/cleaner
	name = "Asters \"Shit-Be-Gone\""
	icon_state = "foam"
	desc = "Dirt? Grime? Blood and criminal evidence? Say good-fucking-bye to all of those things with one simple throw!"
	can_be_modified = FALSE
	stage = 2
	path = 1

/obj/item/weapon/grenade/chem_grenade/cleaner/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("surfactant", 40)
	B2.reagents.add_reagent("water", 40)
	B2.reagents.add_reagent("cleaner", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2

/obj/item/weapon/grenade/chem_grenade/teargas
	name = "FS TGG \"Simon\""
	desc = "Concentrated Capsaicin. Contents under pressure. Use with caution."
	can_be_modified = FALSE
	icon_state = "grenade"
	stage = 2
	path = 1

/obj/item/weapon/grenade/chem_grenade/teargas/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent("phosphorus", 40)
	B1.reagents.add_reagent("potassium", 40)
	B1.reagents.add_reagent("condensedcapsaicin", 40)
	B2.reagents.add_reagent("sugar", 40)
	B2.reagents.add_reagent("condensedcapsaicin", 80)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2
