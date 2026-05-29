/mob/living/simple_animal/hostile/onestar_custodian
	name = "One Star Custodial Drone"
	desc = "Old and weathered One Star drone. It seems to be malfunctioning and hostile."
	icon = 'icons/mob/build_a_drone.dmi'
	icon_state = "drone_os"
	faction = "onestar"
	attacktext = "zapped"
	health = 40
	maxHealth = 40
	melee_damage_lower = 5
	melee_damage_upper = 13
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4
	light_range = 3
	light_color = COLOR_LIGHTING_BLUE_BRIGHT
	mob_classification = CLASSIFICATION_SYNTHETIC
	move_to_delay = 3
	spawn_tags = SPAWN_TAG_MOB_OS_CUSTODIAN
	rarity_value = 23.8
	var/shell_type = "os"
	var/marks_type = "os"
	var/screen_type = "os" //if someone decides to make the drones for something aside from OS and have different desgins
	var/tool = "laser"
	var/tooltype = "os"
	attack_sound = 'sound/weapons/Egloves.ogg'

/mob/living/simple_animal/hostile/onestar_custodian/New()
	. = ..()
	marks_type = pick("green", "blue", "pink", "orange", "cyan", "red", "os")
	screen_type = pick("green", "os_red", "yellow", "cyan", "red", "os")
	update_icon()
	set_glide_size(DELAY2GLIDESIZE(move_to_delay))

/mob/living/simple_animal/hostile/onestar_custodian/update_icon()
	. = ..()
	overlays.Cut()
	var/image/shell_I = image(icon, src, "shell_[shell_type]")
	var/image/marks_I = image(icon, src, "marks_[marks_type]")
	var/image/screen_I = image(icon, src, "screen_[screen_type]")
	var/image/tool_I = image(icon, src, "tool_[tool]_[tooltype]")
	var/image/radio_I = image(icon, src, "radio_os")
	overlays += shell_I
	overlays += marks_I
	overlays += screen_I
	overlays += tool_I
	overlays += radio_I



/mob/living/simple_animal/hostile/onestar_custodian/death()
	..()
	visible_message("<b>[src]</b> blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	if(prob(20))
		var/os_components_reward = pick(list(
			/obj/item/stock_parts/capacitor/one_star,
			/obj/item/stock_parts/scanning_module/one_star,
			/obj/item/stock_parts/manipulator/one_star,
			/obj/item/stock_parts/micro_laser/one_star,
			/obj/item/stock_parts/matter_bin/one_star
		))
		new os_components_reward(get_turf(src))
	qdel(src)
	return



/mob/living/simple_animal/hostile/onestar_custodian/chef
	name = "One Star Service Drone"
	desc = "Old and weathered One Star drone. This one looks like it used to cook. It seems to be malfunctioning and hostile."
	tool = "flamer"
	fire_verb = "lobs flame"
	screen_type = "os_red"
	projectiletype = /obj/item/projectile/flamer_lob
	ranged = TRUE
	rarity_value = 59.5


/mob/living/simple_animal/hostile/onestar_custodian/chef/adjustFireLoss(amount)
	if(status_flags & GODMODE)
		return FALSE	//godmode
	fireloss = min(max(fireloss + amount/2, 0),(maxHealth*2)) //Slightly resistant to fire, because it would blow apart otherwise


/mob/living/simple_animal/hostile/onestar_custodian/engineer
	name = "One Star Engineering Drone"
	desc = "Old and weathered One Star drone. This one has a laser welder. It seems to be malfunctioning and hostile."
	tool = "laser"
	tooltype = "os_red"
	screen_type = "yellow"
	projectiletype = /obj/item/projectile/beam/drone
	ranged = TRUE
	melee_damage_lower = 7
	melee_damage_upper = 15
	rarity_value = 39.66
	move_to_delay = 5

/mob/living/simple_animal/hostile/onestar_custodian/engineer/MoveToTarget()
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		OpenFire(target_mob)

/mob/living/simple_animal/hostile/onestar_custodian/engineer/OpenFire()
	var/distance = get_dist(src, target_mob)
	switch(distance)
		if(0 to 2)
			walk_away(src, target_mob, 6, move_to_delay)
		if(7 to 10)
			walk_to(src, target_mob, 6, move_to_delay)
		else
			walk(src, 0)
			Shoot(target_mob, loc, src)
			LoseTarget()
			if(casingtype)
				new casingtype(get_turf(src))



/mob/living/simple_animal/hostile/onestar_custodian/AttackTarget()
	. = ..()
	if(.)
		playsound(src, attack_sound, 50, 1)
		target_mob.stun_effect_act(0, 50, get_exposed_defense_zone(target_mob), src) // shocking content
