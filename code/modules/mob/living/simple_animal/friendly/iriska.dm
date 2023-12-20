/mob/living/simple_animal/iriska
	name = "Iriska"
	desc = "The captain's own cat. Fat and lazy."
	icon = 'icons/mob/iriska.dmi'
	description_fluff = "Its said that the cat has bluespace powers, cursing anyone whom it has been angered by upon death."
	icon_state = "iriska"
	health = 80
	maxHealth = 80
	wander = FALSE
	canmove = FALSE
	speak_emote = list("purrs.", "meows.")
	emote_see = list("shakes her head.", "shivers.")
	speak_chance = 0.75
	meat_amount = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help = "pets"
	response_disarm = "rubs"
	response_harm = "makes terrible mistake by kicking"
	min_oxy = 16
	minbodytemp = 223
	maxbodytemp = 323
	mob_size = MOB_HUGE
	harm_intent_damage = 20
	melee_damage_lower = 10
	melee_damage_upper = 30
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	density = TRUE
	bite_factor = 0.8
	stomach_size_mult = 10

	autoseek_food = FALSE // Original code for seeking food doesn't fit, Iriska will use slightly modified version
	beg_for_food = FALSE
	max_scan_interval = 10
	eat_from_hand = FALSE

var/atom/snack = null

var/list/tolerated = list()
var/list/despised = list()

/mob/living/simple_animal/iriska/fall_asleep()
	return

/mob/living/simple_animal/iriska/wake_up()
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
		if(snack && (!(isturf(snack.loc) || (foodtarget && !can_eat()) )))
			snack = null
			foodtarget = 0
		if(!snack || !(snack.loc in oview(src, 1)))
			snack = null
			foodtarget = 0
			if (can_eat())
				for(var/obj/item/reagent_containers/food/snacks/S in oview(src,1))
					if(!istype(S, /obj/item/reagent_containers/food/snacks/grown))
						if(isturf(S.loc))
							snack = S
							foodtarget = 1
							break

		if(snack)
			scan_interval = min_scan_interval

			if (snack.loc.x < src.x)
				set_dir(WEST)
			else if (snack.loc.x > src.x)
				set_dir(EAST)
			else if (snack.loc.y < src.y)
				set_dir(SOUTH)
			else if (snack.loc.y > src.y)
				set_dir(NORTH)
			else
				set_dir(SOUTH)

			if(isturf(snack.loc) && Adjacent(get_turf(snack), src))
				var/mob/mob = get_mob_by_key(snack.fingerprintslast)
				UnarmedAttack(snack)
				if(!(mob in despised))
					tolerate(mob)
	else
		scan_interval = max(min_scan_interval, min(scan_interval+1, max_scan_interval))

/mob/living/simple_animal/iriska/proc/react_to_mob()
	for(var/mob/living/M in oview(src, 1))
		if (M.stat != DEAD)

			if(iscorgi(M))
				if(prob(5)) visible_emote("pointedly ignores [M].")

			else if(iscat(M))
				var/verb = pick("meows", "mews", "mrowls")
				if(prob(5)) visible_emote("[verb] at [M].")

			else if(ishuman(M))
				if(M.real_name in tolerated)
					if(prob(2)) say("Meoow!")

				else if ((M.job == "Captain") && !(M.real_name in despised)) // Recognize captain
					tolerated |= M.real_name
					visible_emote("looks at [M] with a hint of respect.")

				else
					assert_dominance(M)

			else
				assert_dominance(M)
	return

/mob/living/simple_animal/iriska/proc/assert_dominance(var/mob/target_mob)
	if(prob(15)) say("HSSSSS")
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return L
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B

/mob/living/simple_animal/iriska/proc/despise(mob/living/carbon/human/M as mob)
	if(istype(M))
		despised |= M.real_name
		if(M.real_name in tolerated)
			tolerated -= M.real_name

/mob/living/simple_animal/iriska/proc/tolerate(mob/living/carbon/human/M as mob)
	if(istype(M))
		if(!(M.real_name in tolerated) && prob(30))
			visible_emote("looks at [M] approvingly.")
			tolerated += M.real_name

/mob/living/simple_animal/iriska/attackby(var/obj/item/O, var/mob/user)
	. = ..()
	if(dhTotalDamage(O))
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

/mob/living/simple_animal/iriska/death(gibbed, deathmessage = "dies!")
	destroy_lifes()
	.=..()

	snack = null
	return ..(gibbed,deathmessage)

/mob/living/simple_animal/iriska/proc/destroy_lifes()
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.real_name in despised)
			H.sanity.insight = 0
			H.sanity.environment_cap_coeff = 0
			H.sanity.negative_prob += 30
			H.sanity.positive_prob = 0
			H.sanity.level = 0
			H.max_style = MIN_HUMAN_STYLE
			for(var/stat in ALL_STATS)
				H.stats.changeStat(stat, -10)
			to_chat(H, SPAN_DANGER("The shadows seem to lengthen, the walls are closing in. The ship itself wants you dead."))
