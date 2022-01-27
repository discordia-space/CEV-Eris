#define EMPTY 0
#define WIRED 1
#define READY 2

/obj/item/grenade/chem_grenade
	name = "grenade casing"
	icon_state = "chemg"
	item_state = "grenade"
	desc = "A hand69ade chemical grenade."
	w_class = ITEM_SIZE_SMALL
	force = WEAPON_FORCE_HARMLESS
	det_time = null
	unacidable = 1
	matter = list(MATERIAL_STEEL = 3)
	variance = 0.25

	var/can_be_modified = TRUE
	var/stage = EMPTY
	var/state = 0
	var/path = 0
	var/obj/item/device/assembly_holder/detonator
	var/list/beakers = new/list()
	var/list/allowed_containers = list(/obj/item/reagent_containers/glass/beaker, /obj/item/reagent_containers/glass/bottle)
	var/affected_area = 3

/obj/item/grenade/chem_grenade/Initialize()
	create_reagents(1000)
	. = ..()

/obj/item/grenade/chem_grenade/attack_self(mob/user as69ob)
	if(stage != READY)
		if(detonator)
//				detonator.loc=loc
			detonator.detached()
			usr.put_in_hands(detonator)
			detonator = null
			det_time = null
			stage = EMPTY
			icon_state = initial(icon_state)
		else if(beakers.len)
			for(var/obj/B in beakers)
				beakers -= B
				user.put_in_hands(B)
		name = "unsecured grenade with 69beakers.len69 containers69detonator?" and detonator":""69"
	if(stage == READY && !active && clown_check(user))
		to_chat(user, SPAN_WARNING("You prime \the 69name69!"))

		activate()
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()

/obj/item/grenade/chem_grenade/attackby(obj/item/W as obj,69ob/user as69ob)

	if(!can_be_modified)
		to_chat(user, SPAN_WARNING("This grenade is sealed and can't be69odified."))
		return
	if(istype(W,/obj/item/device/assembly_holder) && stage != READY && path != 2)
		var/obj/item/device/assembly_holder/det = W
		if(istype(det.left_assembly,det.right_assembly.type) || (!is_igniter(det.left_assembly) && !is_igniter(det.right_assembly)))
			to_chat(user, SPAN_WARNING("Assembly69ust contain one igniter."))
			return
		if(!det.secured)
			to_chat(user, SPAN_WARNING("Assembly69ust be secured with screwdriver."))
			return
		path = 1
		to_chat(user, SPAN_NOTICE("You add 69W69 to the69etal casing."))
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, -3)
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
		name = "unsecured grenade with 69beakers.len69 containers69detonator?" and detonator":""69"
		stage = WIRED
	else if(istype(W,/obj/item/tool/screwdriver) && path != 2)
		if(stage == WIRED)
			path = 1
			if(beakers.len)
				to_chat(user, SPAN_NOTICE("You lock the assembly."))
				name = "grenade"
			else
				to_chat(user, SPAN_NOTICE("You lock the empty assembly."))
				name = "fake grenade"
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, -3)
			icon_state = initial(icon_state) +"_locked"
			stage = READY
		else if(stage == READY)
			if(active && prob(95))
				to_chat(user, SPAN_WARNING("You trigger the assembly!"))
				prime()
				return
			else
				to_chat(user, SPAN_NOTICE("You unlock the assembly."))
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, -3)
				name = "unsecured grenade with 69beakers.len69 containers69detonator?" and detonator":""69"
				icon_state = initial(icon_state) + (detonator?"_ass":"")
				stage = WIRED
				active = FALSE
	else if(is_type_in_list(W, allowed_containers) && (stage != READY) && path != 2)
		path = 1
		if(beakers.len == 2)
			to_chat(user, SPAN_WARNING("The grenade can not hold69ore containers."))
			return
		else
			if(W.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("You add \the 69W69 to the assembly."))
				user.drop_item()
				W.loc = src
				beakers += W
				stage = WIRED
				name = "unsecured grenade with 69beakers.len69 containers69detonator?" and detonator":""69"
			else
				to_chat(user, SPAN_WARNING("\The 69W69 is empty."))

/obj/item/grenade/chem_grenade/examine(mob/user)
	..(user)
	if(detonator)
		to_chat(user, "With attached 69detonator.name69")

/obj/item/grenade/chem_grenade/activate(mob/user as69ob)
	if(active) return

	if(detonator)
		if(!is_igniter(detonator.left_assembly))
			detonator.left_assembly.activate()
			active = TRUE
			log_and_message_admins("primed69ia detonator \a 69src69")
		if(!is_igniter(detonator.right_assembly))
			detonator.right_assembly.activate()
			active = TRUE
			log_and_message_admins("primed69ia detonator \a 69src69")
	if(active)
		icon_state = initial(icon_state) + "_active"

		if(user)
			msg_admin_attack("69user.name69 (69user.ckey69) primed \a 69src69 (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")

	return

/obj/item/grenade/chem_grenade/proc/primed(primed = 1)
	if(active)
		icon_state = initial(icon_state) + (primed?"_primed":"_active")

/obj/item/grenade/chem_grenade/prime()
	if(stage != READY) return

	var/has_reagents = FALSE
	for(var/obj/item/reagent_containers/glass/G in beakers)
		if(G.reagents.total_volume) has_reagents = TRUE

	active = FALSE
	if(!has_reagents)
		icon_state = initial(icon_state) +"_locked"
		playsound(loc, 'sound/items/Screwdriver2.ogg', 50, 1)
		spawn(0) //Otherwise det_time is erroneously set to 0 after this
			if(is_timer(detonator.left_assembly)) //Make sure description reflects that the timer has been reset
				var/obj/item/device/assembly/timer/T = detonator.left_assembly
				det_time = 10*T.time
			if(is_timer(detonator.right_assembly))
				var/obj/item/device/assembly/timer/T = detonator.right_assembly
				det_time = 10*T.time
		return

	playsound(loc, 'sound/effects/bamf.ogg', 50, 1)

	for(var/obj/item/reagent_containers/glass/G in beakers)
		G.reagents.trans_to_obj(src, G.reagents.total_volume)

	if(reagents.total_volume) //The possible reactions didnt use up all reagents.
		chem_splash(get_turf(src), affected_area, list(reagents), extra_heat=10)

	if(iscarbon(loc))		//drop dat grenade if it goes off in your hand
		var/mob/living/carbon/C = loc
		C.drop_from_inventory(src)
		C.throw_mode_off()

	invisibility = INVISIBILITY_MAXIMUM //Why am i doing this?
	spawn(50)		   //To69ake sure all reagents can work
		69del(src)	   //correctly before deleting the grenade.


/obj/item/grenade/chem_grenade/large
	name = "large chem grenade"
	desc = "An oversized grenade that affects a larger area."
	icon_state = "large_grenade"
	allowed_containers = list(/obj/item/reagent_containers/glass, )
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	affected_area = 4
	matter = list(MATERIAL_STEEL = 5)

	//I tried to just put it in the allowed_containers list but
	//if you do that it69ust have reagents.  If you're going to
	//make a special case you69ight as well do it explicitly. -Sayu
/obj/item/grenade/chem_grenade/large/attackby(obj/item/I,69ob/user, params)
	if(istype(I, /obj/item/slime_extract) && stage == WIRED)
		to_chat(user, "<span class='notice'>You add 69I69 to the assembly.</span>")
		user.drop_item()
		I.loc = src
		beakers += I
	else
		return ..()

/obj/item/grenade/chem_grenade/large/prime()
	if(stage != READY)
		return

	for(var/obj/item/slime_extract/S in beakers)
		if(S.Uses)
			for(var/obj/item/reagent_containers/glass/G in beakers)
				G.reagents.trans_to(S, G.reagents.total_volume)

			//If there is still a core (sometimes it's used up)
			//and there are reagents left, behave normally,
			//otherwise drop it on the ground for timed reactions like gold.

			if(S)
				if(S.reagents && S.reagents.total_volume)
					for(var/obj/item/reagent_containers/glass/G in beakers)
						S.reagents.trans_to(G, S.reagents.total_volume)
				else
				//	S.forceMove(get_turf(src))
					if(beakers.len)
						for(var/obj/item/slime_extract/O in beakers)
							O.forceMove(get_turf(src))
						beakers = list()
	..()

/obj/item/grenade/chem_grenade/large/moebius
	name = "large69oebius chem grenade"
	desc = "An oversized grenade that affects a larger area. Has69oebius69arkings"
	icon_state = "moebius_grenade"

/obj/item/grenade/chem_grenade/metalfoam
	name = "Asters \"Stop-Space\""
	icon_state = "foam"
	desc = "Used for emergency sealing of air breaches."
	can_be_modified = FALSE
	path = 1
	stage = READY

/obj/item/grenade/chem_grenade/metalfoam/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 30)
	B2.reagents.add_reagent("foaming_agent", 10)
	B2.reagents.add_reagent("pacid", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/incendiary
	name = "FS IG \"River\""
	desc = "Used for clearing rooms of living things."
	icon_state = "incendiary"
	can_be_modified = FALSE
	path = 1
	stage = READY

/obj/item/grenade/chem_grenade/incendiary/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 15)
	B1.reagents.add_reagent("fuel",20)
	B2.reagents.add_reagent("plasma", 15)
	B2.reagents.add_reagent("sacid", 15)
	B1.reagents.add_reagent("fuel",20)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/antiweed
	name = "Asters \"Flora Armageddon\""
	desc = "Used for purging large areas of invasive plant species. Contents under pressure. Do not directly inhale contents."
	icon_state = "foam"
	can_be_modified = FALSE
	path = 1
	stage = READY

/obj/item/grenade/chem_grenade/antiweed/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("surfactant", 40)
	B2.reagents.add_reagent("water", 40)
	B2.reagents.add_reagent("plantbgone", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2
	icon_state = "grenade"

/obj/item/grenade/chem_grenade/antiweed/nt_antiweed
	name = "NeoTheology \"Kudzu Killer\""
	desc = "NT brand weedkiller grenades. Designed to deal with Kudzu infestations back in New Rome.69ixes toxic biomatter with plasticides for great results"
	icon_state = "foam"
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_PLASTIC = 2,69ATERIAL_BIOMATTER = 5)
	matter_reagents = list("water" = 30)

/obj/item/grenade/chem_grenade/cleaner
	name = "Asters \"Shit-Be-Gone\""
	icon_state = "foam"
	desc = "Dirt? Grime? Blood and criminal evidence? Say good-fucking-bye to all of those things with one simple throw!"
	can_be_modified = FALSE
	stage = READY
	path = 1
	spawn_tags = SPAWN_TAG_GRENADE_CLEANER
	rarity_value = 25

/obj/item/grenade/chem_grenade/cleaner/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("surfactant", 40)
	B2.reagents.add_reagent("water", 40)
	B2.reagents.add_reagent("cleaner", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/cleaner/nt_cleaner
	name = "NeoTheology \"Cleanse Capsule\""
	desc = "NT brand cleaner grenades. Designed to deal with Biogenerator accidents and the aftermaths of gang wars inside the New Rome slums."
	icon_state = "foam"
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_BIOMATTER = 5)
	matter_reagents = list("water" = 30)

/obj/item/grenade/chem_grenade/teargas
	name = "FS TGG \"Simon\""
	desc = "Concentrated Capsaicin. Contents under pressure. Use with caution."
	can_be_modified = FALSE
	icon_state = "grenade"
	stage = READY
	path = 1

/obj/item/grenade/chem_grenade/teargas/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent("phosphorus", 40)
	B1.reagents.add_reagent("potassium", 40)
	B1.reagents.add_reagent("condensedcapsaicin", 40)
	B2.reagents.add_reagent("sugar", 40)
	B2.reagents.add_reagent("condensedcapsaicin", 80)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2

#undef EMPTY
#undef WIRED
#undef READY
