/mob/living/carbon/superior_animal/roach
	name = "Kampfer Roach"
	desc = "A monstrous, dog-sized cockroach. These huge mutants can be everywhere where humans are, on ships, planets and stations."

	icon_state = "roach"

	mob_size = MOB_SMALL

	density = 0 //Swarming roaches! They also more robust that way.

	attack_sound = 'sound/voice/insect_battle_bite.ogg'
	emote_see = list("chirps loudly.", "cleans its whiskers with forelegs.")
	turns_per_move = 4
	turns_since_move = 0

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/roachmeat
	meat_amount = 3

	maxHealth = 10
	health = 10

	var/blattedin_revives_left = 1 // how many times blattedin can get us back to life (as num for adminbus fun).

	melee_damage_lower = 1
	melee_damage_upper = 4

	min_breath_required_type = 3
	min_air_pressure = 15 //below this, brute damage is dealt

	faction = "roach"
	pass_flags = PASSTABLE
	acceptableTargetDistance = 3 //consider all targets within this range equally
	randpixel = 12
	overkill_gib = 16
	var/fire_sound = 'sound/weapons/roach_minigun.ogg'
	var/casingtype = /obj/item/ammo_casing/a10mm
	var/projectiletype = /obj/item/projectile/bullet/a10mm
	var/has_gun = FALSE //Can roach of shooting gun

//When roaches die near a leader, the leader may call for reinforcements
/mob/living/carbon/superior_animal/roach/death()
	.=..()
	if (.)
		for (var/mob/living/carbon/superior_animal/roach/fuhrer/F in range(src,8))
			F.distress_call()

/obj/item/roach_minigun
	name = "KM-64 Roach Mounted Minigun"
	desc = "An ungodly device which comes with a convenient fitting strap, mounting hardpoints, and an all in one ammo autoloader + delivery system. Simply click a roach with it to begin installation (you should probably tame them first!). <b>Combine with roach riding for maximum effectiveness</b>"
	icon = 'icons/mob/animal.dmi'
	icon_state = "roachgun_item"

/mob/living/carbon/superior_animal/roach/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/roach_minigun))
		to_chat(user, "<span class='notice'>You start to put [I]'s straps around [src]...</span>")
		if(do_after(user, 50))
			to_chat(user, "<span class='notice'>You buckle [I]'s straps and watch as it wobbles comically. Oh man this was a terrible idea.</span>")
			get_gun()
			qdel(I)

/mob/living/carbon/superior_animal/roach/proc/get_gun()
	emote("grins")
	visible_message("<span class='warning'>[src] spools its minigun playfully, looking incredibly pleased with itself.</span>")
	say("Cyka bylat.")
	overlays += image(src.icon, "roachgun")
	has_gun = TRUE

/mob/living/carbon/superior_animal/roach/proc/OpenFire(var/target_mob) //Adapted from ranged simple animals
	var/target = target_mob
	visible_message("\red <b>[src]</b> fires at [target]!", 1)
	for(var/I = 0, I < 3, I++)
		Shoot(target, src.loc, src)
		if(casingtype)
			new casingtype(get_turf(src))
	return

/mob/living/carbon/superior_animal/roach/proc/Shoot(var/target, var/start, var/user, var/bullet = 0)
	if(target == start)
		return
	var/obj/item/projectile/A = new projectiletype(user:loc)
	playsound(src, fire_sound, 100, 1)
	if(!A)	return
	var/def_zone = get_exposed_defense_zone(target)
	A.launch(target, def_zone)

/datum/uplink_item/item/visible_weapons/roachgun
	name = "Roach mounted minigun"
	item_cost = 20 //Almost same as an AR, because good lord it's fucking strong
	path = /obj/item/roach_minigun
