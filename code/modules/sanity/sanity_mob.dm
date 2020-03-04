#define SANITY_PASSIVE_GAIN 0.2

#define SANITY_DAMAGE_MOD 0.6

// Damage received from unpleasant stuff in view
#define SANITY_DAMAGE_VIEW(damage, vig, dist) ((damage) * SANITY_DAMAGE_MOD * (1.2 - (vig) / STAT_LEVEL_MAX) * (1 - (dist)/15))

// Damage received from body damage
#define SANITY_DAMAGE_HURT(damage, vig) (min((damage) / 5 * SANITY_DAMAGE_MOD * (1.2 - (vig) / STAT_LEVEL_MAX), 60))

// Damage received from shock
#define SANITY_DAMAGE_SHOCK(shock, vig) ((shock) / 50 * SANITY_DAMAGE_MOD * (1.2 - (vig) / STAT_LEVEL_MAX))

// Damage received from psy effects
#define SANITY_DAMAGE_PSY(damage, vig) (damage * SANITY_DAMAGE_MOD * (2 - (vig) / STAT_LEVEL_MAX))

// Damage received from seeing someone die
#define SANITY_DAMAGE_DEATH(vig) (10 * SANITY_DAMAGE_MOD * (1 - (vig) / STAT_LEVEL_MAX))

#define SANITY_GAIN_SMOKE 0.05 // A full cig restores 300 times that
#define SANITY_GAIN_SAY 1

#define SANITY_COOLDOWN_SAY rand(30 SECONDS, 45 SECONDS)
#define SANITY_COOLDOWN_BREAKDOWN rand(7 MINUTES, 10 MINUTES)

#define SANITY_CHANGE_FADEOFF(level_change) (level_change * 0.75)

#define INSIGHT_PASSIVE_GAIN 0.05
#define INSIGHT_GAIN(level_change) (INSIGHT_PASSIVE_GAIN + level_change / 15)

#define INSIGHT_DESIRE_COUNT 2

#define INSIGHT_DESIRE_FOOD "food"
#define INSIGHT_DESIRE_ALCOHOL "alcohol"
#define INSIGHT_DESIRE_SMOKING "smoking"
#define INSIGHT_DESIRE_DRUGS "drugs"

/datum/sanity
	var/flags
	var/mob/living/carbon/human/owner

	var/sanity_invulnerability = 0
	var/level
	var/max_level = 100
	var/level_change = 0

	var/insight
	var/insight_rest = 0
	var/resting = 0

	var/list/desires = list()

	var/positive_prob = 20
	var/negative_prob = 30

	var/view_damage_threshold = 20

	var/say_time = 0
	var/breakdown_time = 0
	var/spook_time = 0

	var/list/datum/breakdown/breakdowns = list()

/datum/sanity/New(mob/living/carbon/human/H)
	owner = H
	level = max_level
	insight = rand(0, 30)
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
	handle_insight()
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

/datum/sanity/proc/handle_insight()
	insight += INSIGHT_GAIN(level_change)
	while(insight >= 100)
		to_chat(owner, SPAN_NOTICE("You have gained insight.[resting ? null : " Now you need to rest and rethink your life choices."]"))
		++resting
		pick_desires()
		insight -= 100
	owner.HUDneed["sanity"]?.update_icon()

/datum/sanity/proc/handle_level()
	level_change = SANITY_CHANGE_FADEOFF(level_change)

	if(level < 40 && world.time >= spook_time)
		spook_time = world.time + rand(1 MINUTES, 8 MINUTES) - (40 - level) * 1 SECONDS //Each missing sanity point below 40 decreases cooldown by a second

		var/static/list/effects_40 = list(
			.proc/effect_emote = 25,
			.proc/effect_quote = 50
		)
		var/static/list/effects_30 = effects_40 + list(
			.proc/effect_sound = 1,
			.proc/effect_whisper = 25,
		)
		var/static/list/effects_20 = effects_30 + list(
			.proc/effect_hallucination = 30
		)

		call(src, pickweight(level < 30 ? level < 20 ? effects_20 : effects_30 : effects_40))()


/datum/sanity/proc/pick_desires()
	desires.Cut()
	var/list/candidates = list(
		INSIGHT_DESIRE_FOOD,
		INSIGHT_DESIRE_ALCOHOL,
		INSIGHT_DESIRE_SMOKING,
		INSIGHT_DESIRE_DRUGS,
	)
	for(var/i = 0; i < INSIGHT_DESIRE_COUNT; i++)
		var/desire = pick_n_take(candidates)
		switch(desire)
			if(INSIGHT_DESIRE_FOOD)
				var/static/list/food_types = subtypesof(/obj/item/weapon/reagent_containers/food/snacks)
				var/desire_count = 0
				while(desire_count < 5)
					var/obj/item/weapon/reagent_containers/food/snacks/candidate = pick(food_types)
					if(!initial(candidate.cooked))
						food_types -= candidate
						continue
					desires += candidate
					++desire_count
			if(INSIGHT_DESIRE_ALCOHOL)
				var/static/list/ethanol_types = subtypesof(/datum/reagent/ethanol)
				var/desire_count = 0
				while(desire_count < 5)
					var/candidate = pick(ethanol_types)
					if(subtypesof(candidate).len) //Exclude categories
						ethanol_types -= candidate
						continue
					desires += candidate
					++desire_count
			else
				desires += desire
	print_desires()

/datum/sanity/proc/print_desires()
	if(!resting)
		return
	var/list/desire_names = list()
	for(var/desire in desires)
		if(ispath(desire))
			var/atom/A = desire
			desire_names += initial(A.name)
		else
			desire_names += desire
	to_chat(owner, SPAN_NOTICE("You desire [english_list(desire_names)]."))

/datum/sanity/proc/add_rest(type, amount)
	if(!(type in desires))
		amount /= 4
	insight_rest += amount
	if(insight_rest >= 100)
		insight_rest = 0
		finish_rest()

/datum/sanity/proc/finish_rest()
	var/list/stat_change = list()

	var/stat_pool = resting * 15
	while(stat_pool--)
		LAZYAPLUS(stat_change, pick(ALL_STATS), 1)

	for(var/stat in stat_change)
		owner.stats.changeStat(stat, stat_change[stat])

	INVOKE_ASYNC(src, .proc/oddity_stat_up, resting)

	to_chat(owner, SPAN_NOTICE("You have rested well and improved your stats."))
	resting = 0

/datum/sanity/proc/oddity_stat_up(multiplier)
	var/list/obj/item/weapon/oddity/oddities = list()
	for(var/obj/item/weapon/oddity/O in owner.get_contents())
		oddities += O
	if(oddities.len)
		var/obj/item/weapon/oddity/O = oddities.len > 1 ? owner.client ? input(owner, "Select oddity to use as inspiration", "Level up") in oddities : pick(oddities) : oddities[1]
		if(!O)
			return
		for(var/stat in O.oddity_stats)
			owner.stats.changeStat(stat, O.oddity_stats[stat] * multiplier)


/datum/sanity/proc/onDamage(amount)
	changeLevel(-SANITY_DAMAGE_HURT(amount, owner.stats.getStat(STAT_VIG)))

/datum/sanity/proc/onPsyDamage(amount)
	changeLevel(-SANITY_DAMAGE_PSY(amount, owner.stats.getStat(STAT_VIG)))

/datum/sanity/proc/onSeeDeath(mob/M)
	if(ishuman(M))
		changeLevel(-SANITY_DAMAGE_DEATH(owner.stats.getStat(STAT_VIG)))

/datum/sanity/proc/onShock(amount)
	changeLevel(-SANITY_DAMAGE_SHOCK(amount, owner.stats.getStat(STAT_VIG)))


/datum/sanity/proc/onDrug(datum/reagent/drug/R, multiplier)
	changeLevel(R.sanity_gain * multiplier)
	if(resting)
		add_rest(INSIGHT_DESIRE_DRUGS, 4 * multiplier)

/datum/sanity/proc/onAlcohol(datum/reagent/ethanol/E, multiplier)
	changeLevel(E.sanity_gain_ingest * multiplier)
	if(resting)
		add_rest(E.type, 3 * multiplier)

/datum/sanity/proc/onEat(obj/item/weapon/reagent_containers/food/snacks/snack, amount_eaten)
	changeLevel(snack.sanity_gain * amount_eaten / snack.bitesize)
	if(snack.cooked && resting)
		add_rest(snack.type, 20 * amount_eaten / snack.bitesize)

/datum/sanity/proc/onSmoke(obj/item/clothing/mask/smokable/S)
	changeLevel(SANITY_GAIN_SMOKE * S.quality_multiplier)
	if(resting)
		add_rest(INSIGHT_DESIRE_SMOKING, 0.4 * S.quality_multiplier)

/datum/sanity/proc/onSay()
	if(world.time < say_time)
		return
	say_time = world.time + SANITY_COOLDOWN_SAY
	changeLevel(SANITY_GAIN_SAY)


/datum/sanity/proc/changeLevel(amount)
	if(sanity_invulnerability && amount < 0)
		return
	updateLevel(level + amount)

/datum/sanity/proc/setLevel(amount)
	if(sanity_invulnerability)
		restoreLevel(amount)
		return
	updateLevel(amount)

/datum/sanity/proc/restoreLevel(amount)
	if(level <= amount)
		return
	updateLevel(amount)

/datum/sanity/proc/updateLevel(new_level)
	new_level = CLAMP(new_level, 0, max_level)
	level_change += abs(new_level - level)
	level = new_level
	if(level == 0 && world.time >= breakdown_time)
		breakdown()
	owner.HUDneed["sanity"]?.update_icon()

/datum/sanity/proc/breakdown()
	breakdown_time = world.time + SANITY_COOLDOWN_BREAKDOWN

	for(var/obj/item/device/mind_fryer/M in GLOB.active_mind_fryers)
		if(get_turf(M) in view(get_turf(owner)))
			M.reg_break(owner)

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
