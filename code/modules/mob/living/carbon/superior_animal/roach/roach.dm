/mob/living/carbon/superior_animal/roach
	name = "Kampfer Roach"
	desc = "A monstrous, dog-sized cockroach. These huge mutants can be everywhere where humans are, on ships, planets and stations."

	icon_state = "roach"

	mob_size = MOB_SMALL

	density = FALSE //Swarming roaches! They also more robust that way.

	attack_sound = 'sound/voice/insect_battle_bite.ogg'
	emote_see = list("chirps loudly.", "cleans its whiskers with forelegs.")
	turns_per_move = 4
	turns_since_move = 0

	meat_type = /obj/item/reagent_containers/food/snacks/meat/roachmeat/kampfer
	meat_amount = 2

	maxHealth = 10
	health = 10

	var/blattedin_revives_left = 1 // how many times blattedin can get us back to life (as num for adminbus fun).

	melee_damage_lower = 4
	melee_damage_upper = 8
	wound_mult = WOUNDING_WIDE

	min_breath_required_type = 3
	min_air_pressure = 15 //below this, brute damage is dealt

	faction = "roach"
	pass_flags = PASSTABLE
	acceptableTargetDistance = 3 //consider all targets within this range equally
	randpixel = 12
	overkill_gib = 16

	sanity_damage = 0.5

	//spawn_values
	spawn_tags = SPAWN_TAG_ROACH
	rarity_value = 5

	var/atom/eat_target // target that the roach wants to eat
	var/fed = 0 // roach gets fed after eating a corpse
	var/probability_egg_laying = 25 // probability to lay an egg
	var/taming_window = 30 //How long you have to tame this roach, once it's pacified.
	var/busy_time // how long it will take to eat/lay egg
	var/busy_start_time // when it started eating/laying egg

	var/obj/item/hat
	var/hat_x_offset = 6
	var/hat_y_offset = 8

	var/list/hats4roaches = list(/obj/item/clothing/head/collectable/chef,
			/obj/item/clothing/head/collectable/paper,
			/obj/item/clothing/head/collectable/beret,
			/obj/item/clothing/head/collectable/welding,
			/obj/item/clothing/head/collectable/flatcap,
			/obj/item/clothing/head/collectable/pirate,
			/obj/item/clothing/head/collectable/thunderdome,
			/obj/item/clothing/head/collectable/swat,
			/obj/item/clothing/head/collectable/police,
			/obj/item/clothing/head/collectable/xenom,
			/obj/item/clothing/head/collectable/petehat,
			/obj/item/clothing/head/collectable/wizard,
			/obj/item/clothing/head/collectable/hardhat,
			/obj/item/clothing/head/fedora,
			/obj/item/clothing/head/hasturhood,
			/obj/item/clothing/head/hgpiratecap,
			/obj/item/clothing/head/nursehat,
			/obj/item/clothing/head/soft/rainbow,
			/obj/item/clothing/head/soft/grey
			)


	// Armor related variables
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 25,
		rad = 50
	)

/mob/living/carbon/superior_animal/roach/New()
	. = ..()
	var/newhat = pick(hats4roaches)
	var/obj/item/hatobj = new newhat(loc)
	wear_hat(hatobj)

/mob/living/carbon/superior_animal/roach/Destroy()
	clearEatTarget()
	return ..()

//When roaches die near a leader, the leader may call for reinforcements
/mob/living/carbon/superior_animal/roach/death()
	.=..()
	if(.)
		for(var/mob/living/carbon/superior_animal/roach/fuhrer/F in range(src,8))
			if(!F.stat)
				F.distress_call()

		layer = BELOW_MOB_LAYER // Below stunned roaches

		if(prob(3))
			visible_message(SPAN_DANGER("\the [src] hacks up a tape!"))
			new /obj/item/music_tape(get_turf(src))

	else if(prob(10))
		visible_message(SPAN_DANGER("\the [src] drops behind a gift basket!"))
		new /obj/item/storage/box/halloween_basket(get_turf(src))

	if(hat)
		hat.loc = get_turf(src)
		hat.update_plane()
		hat = null
		update_hat()



/mob/living/carbon/superior_animal/roach/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.forceMove(src)
	update_hat()

/mob/living/carbon/superior_animal/roach/proc/update_hat()
	overlays.Cut()
	if(hat)
		var/offset_x = hat_x_offset
		var/offset_y = hat_y_offset
		switch(dir)
			if(EAST)
				offset_y = -hat_y_offset
				offset_x = hat_x_offset
			if(WEST)
				offset_y = -hat_y_offset
				offset_x = -hat_x_offset
			if(NORTH)
				offset_y = -2
				offset_x = 0
			if(SOUTH)
				offset_y = -16
				offset_x = 0
		overlays |= get_hat_icon(hat, offset_x, offset_y)
