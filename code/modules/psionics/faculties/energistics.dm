/decl/psionic_faculty/energistics
	id = PSI_ENERGISTICS
	name = "Energistics"
	associated_intent = I_HURT
	armour_types = list("bomb", "laser", "energy")

/decl/psionic_power/energistics
	faculty = PSI_ENERGISTICS
	abstract_type = /decl/psionic_power/energistics

/decl/psionic_power/energistics/disrupt
	name =            "Disrupt"
	cost =            10
	cooldown =        100
	use_melee =       TRUE
	min_rank =        PSI_RANK_MASTER
	use_description = "Target the head, eyes or mouth while on harm intent to use a melee attack that causes a localized electromagnetic pulse."

/decl/psionic_power/energistics/disrupt/invoke(mob/living/user, mob/living/target)
	if(user.targeted_organ != BP_HEAD && user.targeted_organ != BP_EYES && user.targeted_organ != BP_MOUTH)
		return FALSE
	if(istype(target, /turf))
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user] releases a gout of crackling static and arcing lightning over \the [target]!"))
		empulse(target, 0, 1)
		return TRUE

/decl/psionic_power/energistics/electrocute
	name =            "Electrocute"
	cost =            15
	cooldown =        25
	use_melee =       TRUE
	min_rank =        PSI_RANK_GRANDMASTER
	use_description = "Target the chest or groin while on harm intent to use a melee attack that electrocutes a victim."

/decl/psionic_power/energistics/electrocute/invoke(mob/living/user, mob/living/target)
	if(user.targeted_organ != BP_CHEST && user.targeted_organ != BP_GROIN)
		return FALSE
	if(!isliving(target))
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user] sends a jolt of electricity arcing into \the [target]!"))
		if(istype(target))
			target.electrocute_act(rand(15,45), user, 1, user.targeted_organ)
			return TRUE

/decl/psionic_power/energistics/zorch
	name =             "Zorch"
	cost =             10
	cooldown =         10
	use_ranged =       TRUE
	min_rank =         PSI_RANK_OPERANT
	use_description = "Use this ranged laser attack while on harm intent. Your mastery of Energistics will determine how powerful the laser is. Be wary of overuse, and try not to fry your own brain."

/decl/psionic_power/energistics/zorch/invoke(mob/living/user, mob/living/target)
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user]'s eyes flare with light!"))

		var/user_rank = user.psi.get_rank(faculty)
		var/obj/item/projectile/pew
		var/pew_sound

		switch(user_rank)
			if(PSI_RANK_PARAMOUNT)
				pew = new /obj/item/projectile/beam/energistic/paramount(get_turf(user))
				pew_sound = 'sound/weapons/lasercannonfire.ogg'
			if(PSI_RANK_GRANDMASTER)
				pew = new /obj/item/projectile/beam/energistic/grandmaster(get_turf(user))
				pew_sound = 'sound/weapons/Laser.ogg'
			if(PSI_RANK_MASTER)
				pew = new /obj/item/projectile/beam/energistic/master(get_turf(user))
				pew_sound = 'sound/weapons/Laser.ogg'
			if(PSI_RANK_OPERANT)
				pew = new /obj/item/projectile/beam/energistic(get_turf(user))
				pew_sound = 'sound/weapons/Taser.ogg'

		if(istype(pew))
			playsound(pew.loc, pew_sound, 25, 1)
			pew.original = target
			pew.current = target
			pew.starting = get_turf(user)
			pew.shot_from = user
			pew.launch(target, user.targeted_organ, (target.x-user.x), (target.y-user.y))
			return TRUE

/decl/psionic_power/energistics/spark
	name =            "Spark"
	cost =            1
	cooldown =        1
	use_melee =       TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Target a non-living target in melee range on harm intent to cause some sparks to appear. This can light fires."

/decl/psionic_power/energistics/spark/invoke(mob/living/user, mob/living/target)
	if(isnull(target) || istype(target)) return FALSE
	. = ..()
	if(.)
		if(istype(target,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/S = target
			S.light("[user] snaps \his fingers and \the [S.name] lights up.")
			playsound(S.loc, "sparks", 50, 1)
		else if(istype(target,/obj/item/cell) && user.psi.get_rank(PSI_ENERGISTICS) >= PSI_RANK_MASTER)
			var/obj/item/cell/charging_cell = target.get_cell()
			if(istype(charging_cell))
				charging_cell.give(rand(15,45))
				user.visible_message(SPAN_DANGER("\The [user] sends a jolt of electricity arcing into \the [target]!"))
		else
			var/datum/effect/effect/system/spark_spread/sparks = new ()
			sparks.set_up(3, 0, get_turf(target))
			sparks.start()
		return TRUE
