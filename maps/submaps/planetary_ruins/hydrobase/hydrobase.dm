/datum/map_template/ruin/exoplanet/hydrobase
	name = "hydroponics base"
	id = "exoplanet_hydrobase"
	description = "hydroponics base with random plants and a lot of enemies"
	suffix = "hydrobase/hydrobase.dmm"
	cost = 2
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_ALIEN
	/*apc_test_exempt_areas = list(
		/area/map_template/hydrobase = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/hydrobase/station = NO_SCRUBBER
	)*/

// Areas //
/area/map_template/hydrobase
	name = "\improper Hydroponics Base X207"
	icon_state = "hydro"
	icon = 'maps/submaps/planetary_ruins/hydrobase/hydro.dmi'

/area/map_template/hydrobase/solars
	name = "\improper X207 Solar Array"
	icon_state = "solar"

/area/map_template/hydrobase/station/processing
	name = "\improper X207 Processing Area"
	icon_state = "processing"

/area/map_template/hydrobase/station/shipaccess
	name = "\improper X207 Shipping Access"
	icon_state = "shipping"

/area/map_template/hydrobase/station/shower
	name = "\improper X207 Clean Room"
	icon_state = "shower"

/area/map_template/hydrobase/station/growA
	name = "\improper X207 Growing Zone A"
	icon_state = "A"

/area/map_template/hydrobase/station/growB
	name = "\improper X207 Growing Zone B"
	icon_state = "B"

/area/map_template/hydrobase/station/growC
	name = "\improper X207 Growing Zone C"
	icon_state = "C"

/area/map_template/hydrobase/station/growD
	name = "\improper X207 Growing Zone D"
	icon_state = "D"

/area/map_template/hydrobase/station/growF //nobody knows what happened to growing zone e
	name = "\improper X207 Growing Zone F"
	icon_state = "F"

/area/map_template/hydrobase/station/growX
	name = "\improper X207 Growing Zone X"
	icon_state = "X"

/area/map_template/hydrobase/station/goatzone
	name = "\improper X207 Containment Zone"
	icon_state = "goatzone"

/area/map_template/hydrobase/station/dockport
	name = "\improper X207 Access Port"
	icon_state = "airlock"

/area/map_template/hydrobase/station/solarlock
	name = "\improper X207 External Airlock"
	icon_state = "airlock"


// Objs //
/obj/structure/closet/secure_closet/hydroponics/hydro
	name = "hydroponics supplies locker"
	req_access = list()

// Mobs //
/mob/living/simple_animal/hostile/retaliate/goat/hydro
	name = "goat"
	desc = "An impressive goat, in size and coat. His horns look pretty serious!"
	health = 100
	maxHealth = 100
	melee_damage_lower = 10
	melee_damage_upper = 15
	faction = "farmbots"
	attacktext = "bonked"

/mob/living/simple_animal/hostile/retaliate/malf_hydro_drone
	name = "Farmbot"
	desc = "The botanist's best friend. There's something slightly odd about the way it moves."
	icon = 'maps/submaps/planetary_ruins/hydrobase/hydro.dmi'
	icon_state = "farmbot"
	icon_living = "farmbot"
	icon_dead = "farmbot_dead"
	faction = "farmbots"
	attacktext = "zapped"
	speak = list("Initiating harvesting subrout-ine-ine.", "Connection timed out.", "Connection with master AI syst-tem-tem lost.", "Core systems override enab-...")
	emote_see = list("beeps repeatedly", "whirrs violently", "flashes its indicator lights", "emits a ping sound")
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	move_to_delay = 2
	turns_per_move = 5
	minbodytemp = 0
	speed = 4
	light_range = 3
	light_color = COLOR_LIGHTING_BLUE_BRIGHT
	mob_classification = CLASSIFICATION_SYNTHETIC
	projectiletype = /obj/item/projectile/beam/drone
	ranged = TRUE
	ranged_cooldown = 2 SECONDS
	move_to_delay = 9
	health = 200
	maxHealth = 200
	melee_damage_lower = 5
	melee_damage_upper = 10
	rarity_value = 42
	speak_chance = 5

/mob/living/simple_animal/hostile/retaliate/malf_hydro_drone/death()
	..()
	visible_message("<b>[src]</b> blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	return

/mob/living/simple_animal/hostile/retaliate/malf_hydro_drone/FindTarget()
	. = ..()
	if(.)
		visible_emote("[pick(emote_see)].")
		say(pick(speak))

/mob/living/simple_animal/hostile/retaliate/malf_hydro_drone/speak_audio()
	say(pick(speak))
	return
