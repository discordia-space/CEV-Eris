/mob/living/simple_animal/iriska
	name = "Iriska"
	desc = "A very fat cat."
	icon = 'icons/mob/iriska.dmi'
	icon_state = "iriska"
	health = 60
	maxHealth = 60
	wander = FALSE // Too lazy
	canmove = FALSE
	speak_emote = list("purrs.", "meows.")
	emote_see = list("shakes her head.", "shivers.")
	speak_chance = 0.75
	meat_amount = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "rubs"
	response_harm   = "makes terrible mistake by kicking"
	mob_size = MOB_HUGE // Obviously
	harm_intent_damage = 20
	melee_damage_lower = 10
	melee_damage_upper = 30
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	density = TRUE // No stepping on Iriska
	bite_factor = 1 // Big cat - big bite
	stomach_size_mult = 10

	autoseek_food = FALSE // Original code for seeking food doesn't fit here, Iriska will use modified version
	beg_for_food = FALSE
	max_scan_interval = 10

var/atom/snack = null

var/list/mob/living/carbon/human/tolerated = list()
var/list/mob/living/carbon/human/despised = list()

/mob/living/simple_animal/iriska/fall_asleep()
	return

/mob/living/simple_animal/iriska/wake_up() // Those reset "wander" and "canmove", don't need that
	return

/mob/living/simple_animal/iriska/Life()
	.=..()

	if(!stasis)

		seek_food()
		react_to_mob()

/mob/living/simple_animal/iriska/proc/seek_food()
	turns_since_scan++
	if(turns_since_scan >= scan_interval)
		turns_since_scan = 0
		if(snack && (!(isturf(snack.loc) || ishuman(snack.loc)) || (foodtarget && !can_eat()) ))
			snack = null
			foodtarget = 0
		if(!snack || !(snack.loc in oview(src, 4))) // Find snack
			snack = null
			foodtarget = 0
			if (can_eat())
				for(var/obj/item/weapon/reagent_containers/food/snacks/S in oview(src,4))
					if(isturf(S.loc) || ishuman(S.loc))
						snack = S
						foodtarget = 1
						break

				if (!snack) // Find snack held in hand
					var/obj/item/weapon/reagent_containers/food/snacks/F = null
					for(var/mob/living/carbon/human/H in oview(src, 4))
						if(istype(H.l_hand, /obj/item/weapon/reagent_containers/food/snacks))
							F = H.l_hand

						if(istype(H.r_hand, /obj/item/weapon/reagent_containers/food/snacks))
							F = H.r_hand

						if (F)
							snack = F
							foodtarget = 1
							break

		if(snack)
			scan_interval = min_scan_interval

			if (snack.loc.x < src.x) // Look at the snack
				set_dir(WEST)
			else if (snack.loc.x > src.x)
				set_dir(EAST)
			else if (snack.loc.y < src.y)
				set_dir(SOUTH)
			else if (snack.loc.y > src.y)
				set_dir(NORTH)
			else
				set_dir(SOUTH)

			if(isturf(snack.loc) && Adjacent(get_turf(snack), src)) // Eat the snack if able
				var/mob/mob = get_mob_by_key(snack.fingerprintslast)
				UnarmedAttack(snack)
				if(!(mob in despised))
					tolerate(mob)

			else if(ishuman(snack.loc) && Adjacent(src, get_turf(snack)) && prob(15))
				beg(snack, snack.loc)
	else
		scan_interval = max(min_scan_interval, min(scan_interval+1, max_scan_interval))

/mob/living/simple_animal/iriska/proc/react_to_mob()
	for(var/mob/living/personal_space_intruder in oview(src, 1))
		if (personal_space_intruder.stat != DEAD)
			if(iscorgi(personal_space_intruder))
				if(prob(15)) visible_emote("Pointedly ignores [personal_space_intruder].")

			else if(iscat(personal_space_intruder))
				var/verb = pick("meows", "mews", "mrowls")
				if(prob(10)) visible_emote("[verb] at [personal_space_intruder].")

			else if(ishuman(personal_space_intruder))
				if(personal_space_intruder in tolerated)
					if(prob(5)) say("Meow!")
				else
					assert_dominance(personal_space_intruder)

			else
				assert_dominance(personal_space_intruder)
	return

/mob/living/simple_animal/iriska/proc/assert_dominance(var/mob/target_mob)
	if(prob(15)) say("HSSSSS")
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return L
	if(istype(target_mob,/mob/living/exosuit))
		var/mob/living/exosuit/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B

/mob/living/simple_animal/iriska/proc/despise(mob/living/carbon/human/M)
	despised |= M
	if(M in tolerated)
		tolerated -= M

/mob/living/simple_animal/iriska/proc/tolerate(mob/living/carbon/human/M)
	tolerated |= M

/mob/living/simple_animal/iriska/attackby(var/obj/item/O, var/mob/user)
	. = ..()
	if(O.force)
		despise(user)

/mob/living/simple_animal/iriska/attack_hand(mob/living/carbon/human/M as mob)
	. = ..()
	if(M.a_intent == I_HURT)
		despise(M)
	if((M.a_intent == I_HELP) && (M in tolerated))
		if(prob(15)) say("PRRRR")

/mob/living/simple_animal/iriska/bullet_act(var/obj/item/projectile/proj)
	. = ..()
	despise(proj.firer)

/mob/living/simple_animal/iriska/hitby(atom/movable/AM)
	. = ..()
	despise(AM.thrower)

//[CURSE THEM ON DEATH]
/mob/living/simple_animal/iriska/death(gibbed, deathmessage = "dies!")
	.=..()

	snack = null
	icon_state = icon_dead
	density = FALSE
	destroy_lifes()
	return ..(gibbed,deathmessage)

/mob/living/simple_animal/iriska/proc/destroy_lifes()
	for(var/mob/living/carbon/human/H in despised)
		H.sanity.insight = 0
		H.sanity.environment_cap_coeff = 0
		H.sanity.negative_prob += 30
		H.sanity.positive_prob = 0
		H.sanity.level = 0
		for(var/stat in ALL_STATS)
			H.stats.changeStat(stat, -10)
		to_chat(H, SPAN_DANGER("The shadows seem to lengthen and walls are getting closer. Ship itself want you dead."))