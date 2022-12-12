/mob/living/carbon/superior_animal/roach/toxic
	name = "Gestrahlte Roach"
	desc = "A hulking beast of green, congealed waste. It has an enlarged salivatory gland for lobbing projectiles."
	icon_state = "radioactiveroach"

	meat_amount = 3
	turns_per_move = 1
	maxHealth = 40
	health = 40

	contaminant_immunity = TRUE

	melee_damage_lower = 5
	melee_damage_upper = 9 // Lacks penetration and wounding multiplier compared to hunter
	rarity_value = 22.5

	ranged = 1
	projectiletype = /obj/item/projectile/roach_spit
	fire_verb = "spits glowing bile"
	acceptableTargetDistance = 5
	kept_distance = 3

	mob_size = MOB_MEDIUM

	// Armor related variables
	armor = list(
		melee = 0,
		bullet = 5,
		energy = 0,
		bomb = 0,
		bio = 50,
		rad = 100
	)

/mob/living/carbon/superior_animal/roach/toxic/UnarmedAttack(atom/A, var/proximity)
	. = ..()
	if(prob(25))
		if(isliving(A))
			var/mob/living/L = A
			var/damage = rand(melee_damage_lower, melee_damage_upper)
			L.apply_effect(40, IRRADIATE)
			L.damage_through_armor(damage, TOX, attack_flag = ARMOR_BIO)
			playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)
			L.visible_message(SPAN_DANGER("\the [src] globs up some glowing bile all over \the [L]!"))

/obj/item/projectile/roach_spit
	name = "Glowing bile"
	icon = 'icons/obj/hivemind.dmi'
	icon_state = "goo_proj"
	damage_types = list(TOX = 15)
	irradiate = 15
	check_armour = ARMOR_BIO
	step_delay = 2

/obj/item/projectile/roach_spit/on_hit(atom/target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		var/damage = rand(3, 7)
		L.damage_through_armor(damage, TOX, attack_flag = ARMOR_BIO)

/obj/item/projectile/roach_spit/attack_mob(mob/living/target_mob, distance, miss_modifier=0)
	if (isroach(target_mob))
		return FALSE // so these pass through roaches
	..()
