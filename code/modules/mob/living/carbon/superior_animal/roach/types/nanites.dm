/mob/living/carbon/superior_animal/roach/nanite
	name = "Kraftwerk Roach"
	desc = "A deformed mess of a roach that is covered in metallic outcrops and formations. It seems to have a production center on its thorax."
	icon_state = "naniteroach"

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/roachmeat/kraftwerk
	meat_amount = 3
	turns_per_move = 1
	maxHealth = 35
	health = 35

	melee_damage_lower = 1
	melee_damage_upper = 3 //He's a ranged roach

	breath_required_type = NONE
	breath_poison_type = NONE
	min_breath_required_type = 0
	min_breath_poison_type = 0

	min_air_pressure = 0
	min_bodytemperature = 0

/mob/living/carbon/superior_animal/roach/nanite/UnarmedAttack(var/atom/A, var/proximity)
	. = ..()

	if(isliving(A))
		var/mob/living/L = A
		if(istype(L) && prob(25))
			var/sound/screech = pick('sound/machines/robots/robot_talk_light1.ogg','sound/machines/robots/robot_talk_light2.ogg','sound/machines/robots/robot_talk_heavy4.ogg')
			playsound(src, screech, 30, 1, -3)
			new /mob/living/simple_animal/hostile/naniteswarm(get_turf(src))
			say("10101010011100010101")


/mob/living/simple_animal/hostile/naniteswarm
	name = "nanite infested miniroach cluster"
	desc = "A swarm of disgusting locusts infested with nanomachines."
	icon = 'icons/mob/critter.dmi'
	icon_state = "naniteroach"
	pass_flags = PASSTABLE
	density = FALSE
	health = 10
	maxHealth = 10
	melee_damage_lower = 1
	melee_damage_upper = 2
	attacktext = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	faction = "roach"

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
