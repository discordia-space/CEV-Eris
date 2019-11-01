#define SANITY_PASSIVE_GAIN 0.2

#define SANITY_DAMAGE_MOD 0.7

// Damage received from unpleasant stuff in view
#define SANITY_DAMAGE_VIEW(damage, vig, dist) ((damage) * SANITY_DAMAGE_MOD * (1.2 - (vig) / STAT_LEVEL_MAX) * (1 - (dist)/15))

// Damage received from body damage
#define SANITY_DAMAGE_HURT(damage, vig) ((damage) / 5 * SANITY_DAMAGE_MOD * (1.2 - (vig) / STAT_LEVEL_MAX))

// Damage received from shock
#define SANITY_DAMAGE_SHOCK(shock, vig) ((shock) / 50 * SANITY_DAMAGE_MOD * (1.2 - (vig) / STAT_LEVEL_MAX))

// Damage received from seeing someone die
#define SANITY_DAMAGE_DEATH(vig) (10 * SANITY_DAMAGE_MOD * (1 - (vig) / STAT_LEVEL_MAX))

#define SANITY_GAIN_SMOKE 0.05 // A full cig restores 300 times that
#define SANITY_GAIN_SAY 1

#define SANITY_COOLDOWN_SAY rand(30 SECONDS, 45 SECONDS)
#define SANITY_COOLDOWN_BREAKDOWN rand(7 MINUTES, 10 MINUTES)


/datum/sanity
	var/flags
	var/mob/living/carbon/human/owner

	var/sanity_invulnerability = 0
	var/level
	var/max_level = 100

	var/positive_prob = 20
	var/negative_prob = 30

	var/view_damage_threshold = 20

	var/say_time = 0
	var/breakdown_time = 0

	var/list/datum/breakdown/breakdowns = list()

/datum/sanity/New(mob/living/carbon/human/H)
	owner = H
	level = max_level
	RegisterSignal(owner, COMSIG_MOB_LIFE, .proc/onLife)
	RegisterSignal(owner, COMSIG_HUMAN_SAY, .proc/onSay)

/datum/sanity/proc/onLife()
	if(owner.stat == DEAD || owner.in_stasis)
		return
	var/affect = SANITY_PASSIVE_GAIN
	if(owner.stat)
		changeLevel(affect)
		return
	if(!(owner.sdisabilities & BLIND) && !owner.blinded)
		affect += handle_area()
		affect -= handle_view()
	changeLevel(max(affect, min(view_damage_threshold - level, 0)))
	handle_breakdowns()
	handle_level()

/datum/sanity/proc/handle_view()
	. = 0
	if(sanity_invulnerability)
		return
	var/vig = owner.stats.getStat(STAT_VIG)
	for(var/atom/A in view(owner.client ? owner.client : owner))
		if(A.sanity_damage)
			. += SANITY_DAMAGE_VIEW(A.sanity_damage, vig, get_dist(owner, A))

/datum/sanity/proc/handle_area()
	var/area/my_area = get_area(owner)
	if(!my_area)
		return 0
	. = my_area.sanity.affect
	if(. < 0)
		. *= owner.stats.getStat(STAT_VIG) / STAT_LEVEL_MAX

/datum/sanity/proc/handle_breakdowns()
	for(var/datum/breakdown/B in breakdowns)
		if(!B.update())
			breakdowns -= B

/datum/sanity/proc/handle_level()
	if(level < 40)
		if(prob(5))
			to_chat(owner, SPAN_NOTICE("You hear something squeezing through the ventilation ducts."))

	if(level < 20)
		if(prob(5))
			owner.playsound_local(owner, 'sound/voice/shriek1.ogg', 100, 1, 8, 8)
			spawn(2)
				owner.playsound_local(owner, 'sound/voice/shriek1.ogg', 100, 1, 8, 8)
			to_chat(owner, SPAN_DANGER("You hear a horrifying wail!"))


/datum/sanity/proc/onDamage(amount)
	changeLevel(-SANITY_DAMAGE_HURT(amount, owner.stats.getStat(STAT_VIG)))

/datum/sanity/proc/onSeeDeath(mob/M)
	if(ishuman(M))
		changeLevel(-SANITY_DAMAGE_DEATH(owner.stats.getStat(STAT_VIG)))

/datum/sanity/proc/onShock(amount)
	changeLevel(-SANITY_DAMAGE_SHOCK(amount, owner.stats.getStat(STAT_VIG)))


/datum/sanity/proc/onChem(datum/reagent/R, multiplier)
	changeLevel(R.sanity_gain * multiplier)

/datum/sanity/proc/onAlcohol(datum/reagent/ethanol/E, multiplier)
	changeLevel(E.sanity_gain_ingest * multiplier)

/datum/sanity/proc/onEat(obj/item/weapon/reagent_containers/food/snacks/snack, amount_eaten)
	changeLevel(snack.sanity_gain * amount_eaten / snack.bitesize)

/datum/sanity/proc/onSmoke(obj/item/clothing/mask/smokable/S)
	changeLevel(SANITY_GAIN_SMOKE)

/datum/sanity/proc/onSay()
	if(world.time < say_time)
		return
	say_time = world.time + SANITY_COOLDOWN_SAY
	changeLevel(SANITY_GAIN_SAY)


/datum/sanity/proc/changeLevel(amount)
	if(sanity_invulnerability && amount < 0)
		return
	level = CLAMP(level + amount, 0, max_level)
	updateLevel()

/datum/sanity/proc/setLevel(amount)
	if(sanity_invulnerability)
		restoreLevel(amount)
		return
	level = amount
	updateLevel()

/datum/sanity/proc/restoreLevel(amount)
	level = max(level, amount)
	updateLevel()

/datum/sanity/proc/updateLevel()
	level = CLAMP(level, 0, max_level)
	if(level == 0 && world.time >= breakdown_time)
		breakdown()

/datum/sanity/proc/breakdown()
	breakdown_time = world.time + SANITY_COOLDOWN_BREAKDOWN

	var/list/possible_results
	if(prob(positive_prob))
		possible_results = subtypesof(/datum/breakdown/positive)
	else if(prob(negative_prob))
		possible_results = subtypesof(/datum/breakdown/negative)
	else
		possible_results = subtypesof(/datum/breakdown/common)

	for(var/datum/breakdown/B in breakdowns)
		possible_results -= B.type

	while(possible_results.len)
		var/breakdown_type = pick(possible_results)
		var/datum/breakdown/B = new breakdown_type(src)

		if(!B.can_occur())
			possible_results -= breakdown_type
			qdel(B)
			continue

		if(B.occur())
			breakdowns += B
		return

#undef SANITY_PASSIVE_GAIN
