/mob/living/simple_animal/hostile/stranger
	name = "Stranger"
	desc = "A stranger from an unknown place."
	icon_state = "strangerranged"
	icon_dead = "stranger_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 4
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = FALSE
	maxHealth = 200
	health = 200
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "punched"
	a_intent = I_HURT
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	status_flags = CANPUSH
	ranged = TRUE
	rapid = TRUE
	projectiletype = /obj/item/projectile/plasma/heavy
	projectilesound = 'sound/weapons/laser.ogg'
	faction = "bluespace"
	var/empy_cell = FALSE
	var/prob_tele = 20

/mob/living/simple_animal/hostile/stranger/Initialize(mapload)
	. = ..()
	do_sparks(3, 0, src.loc)

/mob/living/simple_animal/hostile/stranger/death()
	. = ..()
	var/obj/item/gun/energy/plasma/stranger/S = new (src.loc)
	S.cell = new S.suitable_cell(S)
	if(empy_cell)
		S.cell.use(S.cell.charge)
	else
		S.cell.use(S.cell.maxcharge/2)
	S.update_icon()
	new /obj/effect/decal/cleanable/ash (src.loc)
	var/atom/movable/overlay/animation
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon =  'icons/mob/mob.dmi'
	animation.master = src
	flick("dust2-h", animation)
	addtimer(CALLBACK(src, .proc/check_delete, animation), 15)
	do_sparks(3, 0, src.loc)
	qdel(src)

/mob/living/simple_animal/hostile/stranger/attack_generic(mob/user, damage, attack_message)
	if(!damage || !istype(user))
		return FALSE
	if(prob(prob_tele))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 4, 2)
		do_sparks(3, 0, src.loc)
		do_teleport(src, T)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/stranger/attackby(obj/item/W, mob/user, params)
	if(prob(prob_tele))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 4, 2)
		do_sparks(3, 0, src.loc)
		do_teleport(src, T)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/stranger/attack_hand(mob/living/carbon/M)
	if(M.a_intent != I_HELP && prob(prob_tele))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 4, 2)
		do_sparks(3, 0, src.loc)
		do_teleport(src, T)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/stranger/bullet_act(obj/item/projectile/P, def_zone)
	if(prob(prob_tele))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 4, 2)
		do_sparks(3, 0, src.loc)
		do_teleport(src, T)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/stranger/Life()
	. = ..()
	if(. && prob(prob_tele/2))
		var/source = src
		if(target_mob)
			source = target_mob
		var/turf/T = get_random_secure_turf_in_range(source, 4, 2)
		do_sparks(3, 0, src.loc)
		do_teleport(src, T)

/obj/item/gun/energy/plasma/stranger
	name = "unknown plasma gun"
	desc = "A plasma gun with unknown origins, it seems to always spark a different feeling in those inspired by it."
	icon = 'icons/obj/guns/energy/lancer.dmi'
	icon_state = "lancer"
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 7, MATERIAL_URANIUM = 8, MATERIAL_GOLD = 4)
	price_tag = 5000
	charge_cost = 5
	fire_delay = 5
	init_recoil = SMG_RECOIL(1)
	twohanded = FALSE
	suitable_cell = /obj/item/cell/small
	can_dual = TRUE
	w_class = ITEM_SIZE_NORMAL
	spawn_blacklisted = TRUE

	init_firemodes = list(
		list(mode_name="uo4E6SBeGe", mode_desc="c25F2OeGUi", burst=1, projectile_type=/obj/item/projectile/plasma/light, fire_sound='sound/weapons/Taser.ogg', fire_delay=5, move_delay=null, charge_cost=3, icon="stun", projectile_color = "#0000FF"),
		list(mode_name="0sXYAJGCv4", mode_desc="yQI241FKDh", burst=1, projectile_type=/obj/item/projectile/plasma, fire_sound='sound/weapons/Laser.ogg', fire_delay=10, move_delay=null, charge_cost=6, icon="kill", projectile_color = "#FF0000"),
		list(mode_name="XhddhrdJkJ", mode_desc="uDsfMdPQkm", burst=1, projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/pulse.ogg', fire_delay=15, move_delay=null, charge_cost=9, icon="destroy", projectile_color = "#FFFFFF"),
		list(mode_name="bP6hfnj3Js", mode_desc="AhG8GjobYa", burst=3, projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/pulse.ogg', fire_delay=5, move_delay=4, charge_cost=11, icon="vaporize", projectile_color = "#FFFFFF")
	)

/obj/item/gun/energy/plasma/stranger/update_icon(ignore_inhands)
	if(charge_meter)
		var/ratio = 0

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(cell && cell.charge >= charge_cost)
			ratio = 100
		else if(!cell)
			ratio = "empty"

		if(modifystate)
			icon_state = "[modifystate]-[ratio]"
		else
			icon_state = "[initial(icon_state)]-[ratio]"

		if(item_charge_meter)
			set_item_state("-[item_modifystate][ratio]")
	if(!item_charge_meter && item_modifystate)
		set_item_state("-[item_modifystate]")
	if(!ignore_inhands)
		update_wear_icon()

/obj/item/gun/energy/plasma/stranger/examine(user, distance)
	. = ..()
	var/area/my_area = get_area(src)
	switch(my_area.bluespace_entropy)
		if(0 to my_area.bluespace_hazard_threshold*0.3)
			to_chat(user, SPAN_NOTICE("It's fading out."))
		if(my_area.bluespace_hazard_threshold*0.7 to INFINITY)
			to_chat(user, SPAN_NOTICE("It's occasionally pulsing with energy."))
	if(GLOB.bluespace_entropy > GLOB.bluespace_hazard_threshold*0.7)
		to_chat(user, SPAN_NOTICE("It glows with an inner radiance."))
	if(my_area.bluespace_entropy > my_area.bluespace_hazard_threshold*0.95 || GLOB.bluespace_entropy > GLOB.bluespace_hazard_threshold*0.95)
		to_chat(user, SPAN_NOTICE("The energy surrounding it is overwhelming to the point of feeling warm in your hands."))



/obj/item/gun/energy/plasma/stranger/proc/chaos()
	var/list/stats = ALL_STATS
	var/list/final_oddity = list()
	var/stat = pick(stats)
	final_oddity += stat
	var/area/my_area = get_area(src)
	var/bluespacemodifier = round(my_area.bluespace_entropy/(my_area.bluespace_hazard_threshold/4))
	final_oddity[stat] = 6 + bluespacemodifier
	my_area.bluespace_entropy = max(0, my_area.bluespace_entropy - (6 + bluespacemodifier))
	var/datum/component/inspiration/odd = GetComponent(/datum/component/inspiration)
	odd.stats = final_oddity

/obj/item/gun/energy/plasma/stranger/New()
	. = ..()
	AddComponent(/datum/component/inspiration, list())
	RegisterSignal(src, COMSIG_ODDITY_USED, .proc/chaos)
	chaos()

/obj/item/gun/energy/plasma/stranger/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	else
		var/mob/living/carbon/human/H = user
		H.sanity.valid_inspirations |= src
