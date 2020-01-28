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
	move_to_delay = 9
	var/shell_type = "os"
	var/marks_type = "os"
	var/screen_type = "os" //if someone decides to make the drones for something aside from OS and have different desgins
	var/tool = "laser"
	var/tooltype = "os"

/mob/living/simple_animal/hostile/onestar_custodian/New()
	. = ..()
	marks_type = pick("green", "blue", "pink", "orange", "cyan", "red", "os")
	screen_type = pick("green", "os_red", "yellow", "cyan", "red", "os")
	update_icon()


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
	qdel(src)
	return



/mob/living/simple_animal/hostile/onestar_custodian/chef
	name = "One Star Service Drone"
	desc = "Old and weathered One Star drone. This one looks like it used to cook. It seems to be malfunctioning and hostile."
	tool = "flamer"
	fire_verb = "lobs flame"
	screen_type = "os_red"
	projectiletype = /obj/item/projectile/flamer_lob
	ranged = 1


/mob/living/simple_animal/hostile/onestar_custodian/chef/adjustFireLoss(var/amount)
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
	ranged = 1
	melee_damage_lower = 7
	melee_damage_upper = 15