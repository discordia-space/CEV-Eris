
/****************************************************
					WOUNDS
****************************************************/
/datum/wound
	// number representing the current stage
	var/current_stage = 0

	// description of the wound
	var/desc = "wound" //default in case something borks

	// amount of damage this wound causes
	var/damage = 0
	// ticks of bleeding left.
	var/bleed_timer = 0
	// amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/min_damage = 0

	// is the wound bandaged?
	var/bandaged = 0
	// Similar to bandaged, but works differently
	var/clamped = 0
	// is the wound salved?
	var/salved = 0
	var/created = 0
	// number of wounds of this type
	var/amount = 1

	/*  These are defined by the wound type and should not be changed */

	// stages such as "cut", "deep cut", etc.
	var/list/stages
	// internal wounds can only be fixed through surgery
	var/internal = 0
	// maximum stage at which bleeding should still happen. Beyond this stage bleeding is prevented.
	var/max_bleeding_stage = 0
	// one of CUT, PIERCE, BRUISE, BURN
	var/damage_type = CUT
	// whether this wound needs a bandage/salve to heal at all
	// the maximum amount of damage that this wound can have and still autoheal
	var/autoheal_cutoff = 15




	// helper lists
	var/tmp/list/desc_list = list()
	var/tmp/list/damage_list = list()

	New(var/damage)

		created = world.time

		// reading from a list("stage" = damage) is pretty difficult, so build two separate
		// lists from them instead
		for(var/V in stages)
			desc_list += V
			damage_list += stages[V]

		src.damage = damage

		// initialize with the appropriate stage
		src.init_stage(damage)

		bleed_timer += damage

	// returns 1 if there's a next stage, 0 otherwise
	proc/init_stage(var/initial_damage)
		current_stage = stages.len

		while(src.current_stage > 1 && src.damage_list[current_stage-1] <= initial_damage / src.amount)
			src.current_stage--

		src.min_damage = damage_list[current_stage]
		src.desc = desc_list[current_stage]

	// the amount of damage per wound
	proc/wound_damage()
		return src.damage / src.amount

	proc/can_autoheal()
		if(src.wound_damage() <= autoheal_cutoff)
			return 1

		return is_treated()

	// checks whether the wound has been appropriately treated
	proc/is_treated()
		if(damage_type == BRUISE || damage_type == CUT)
			return bandaged
		else if(damage_type == BURN)
			return salved

	proc/damtype_sanitize()
		if(damage_type == BURN)
			return BURN
		return BRUTE

	// Checks whether other other can be merged into src.
	proc/can_merge(var/datum/wound/other)
		if (other.type != src.type) return 0
		if (other.current_stage != src.current_stage) return 0
		if (other.damage_type != src.damage_type) return 0
		if (!(other.can_autoheal()) != !(src.can_autoheal())) return 0
		if (!(other.bandaged) != !(src.bandaged)) return 0
		if (!(other.clamped) != !(src.clamped)) return 0
		if (!(other.salved) != !(src.salved)) return 0
		return 1

	proc/merge_wound(var/datum/wound/other)
		src.damage += other.damage
		src.amount += other.amount
		src.bleed_timer += other.bleed_timer
		src.created = max(src.created, other.created)	//take the newer created time

	proc/bandage()
		bandaged = 1

	proc/salve()
		salved = 1

	// heal the given amount of damage, and if the given amount of damage was more
	// than what needed to be healed, return how much heal was left
	// set @heals_internal to also heal internal organ damage
	proc/heal_damage(amount, heals_internal = 0)
		if(src.internal && !heals_internal)
			// heal nothing
			return amount

		var/healed_damage = min(src.damage, amount)
		amount -= healed_damage
		src.damage -= healed_damage

		while(src.wound_damage() < damage_list[current_stage] && current_stage < src.desc_list.len)
			current_stage++
		desc = desc_list[current_stage]
		src.min_damage = damage_list[current_stage]

		// return amount of healing still leftover, can be used for other wounds
		return amount

	// opens the wound again
	proc/open_wound(damage)
		src.damage += damage
		bleed_timer += damage
		clamped = FALSE

		while(src.current_stage > 1 && src.damage_list[current_stage-1] <= src.damage / src.amount)
			src.current_stage--

		src.desc = desc_list[current_stage]
		src.min_damage = damage_list[current_stage]

	// returns whether this wound can absorb the given amount of damage.
	// this will prevent large amounts of damage being trapped in less severe wound types
	proc/can_worsen(damage_type, damage)
		if (src.damage_type != damage_type)
			return 0	//incompatible damage types

		if (src.amount > 1)
			return 0

		//with 1.5*, a shallow cut will be able to carry at most 30 damage,
		//37.5 for a deep cut
		//52.5 for a flesh wound, etc.
		var/max_wound_damage = 1.5*src.damage_list[1]
		if (src.damage + damage > max_wound_damage)
			return 0

		return 1

	proc/bleeding()
		if (current_stage > max_bleeding_stage)
			return 0

		if (bandaged||clamped)
			return 0

		if (wound_damage() <= 30 && bleed_timer <= 0)
			return 0	//Bleed timer has run out. Wounds with more than 30 damage don't stop bleeding on their own.

		return 1

/** WOUND DEFINITIONS **/

//Note that the MINIMUM damage before a wound can be applied should correspond to
//the damage amount for the stage with the same name as the wound.
//e.g. /datum/wound/cut/deep should only be applied for 15 damage and up,
//because in it's stages list, "deep cut" = 15.
/proc/get_wound_type(var/type = CUT, var/damage)
	switch(type)
		if(CUT)
			switch(damage)
				if(70 to INFINITY)
					return /datum/wound/cut/massive
				if(60 to 70)
					return /datum/wound/cut/gaping_big
				if(50 to 60)
					return /datum/wound/cut/gaping
				if(25 to 50)
					return /datum/wound/cut/flesh
				if(15 to 25)
					return /datum/wound/cut/deep
				if(0 to 15)
					return /datum/wound/cut/small
		if(PIERCE)
			switch(damage)
				if(60 to INFINITY)
					return /datum/wound/puncture/massive
				if(50 to 60)
					return /datum/wound/puncture/gaping_big
				if(30 to 50)
					return /datum/wound/puncture/gaping
				if(15 to 30)
					return /datum/wound/puncture/flesh
				if(0 to 15)
					return /datum/wound/puncture/small
		if(BRUISE)
			return /datum/wound/bruise
		if(BURN)
			switch(damage)
				if(50 to INFINITY)
					return /datum/wound/burn/carbonised
				if(40 to 50)
					return /datum/wound/burn/deep
				if(30 to 40)
					return /datum/wound/burn/severe
				if(15 to 30)
					return /datum/wound/burn/large
				if(0 to 15)
					return /datum/wound/burn/moderate
	return null //no wound

/** CUTS **/
/datum/wound/cut/bleeding()
	return ..() && wound_damage() >= 5

/datum/wound/cut/small
	// link wound descriptions to amounts of damage
	// Minor cuts have max_bleeding_stage set to the stage that bears the wound type's name.
	// The major cut types have the max_bleeding_stage set to the clot stage (which is accordingly given the "blood soaked" descriptor).
	max_bleeding_stage = 3
	stages = list("ugly ripped cut" = 20, "ripped cut" = 10, "cut" = 5, "healing cut" = 2, "small scab" = 0)
	damage_type = CUT

/datum/wound/cut/deep
	max_bleeding_stage = 3
	stages = list("ugly deep ripped cut" = 25, "deep ripped cut" = 20, "deep cut" = 15, "clotted cut" = 8, "scab" = 2, "fresh skin" = 0)
	damage_type = CUT

/datum/wound/cut/flesh
	max_bleeding_stage = 4
	stages = list("ugly ripped flesh wound" = 35, "ugly flesh wound" = 30, "flesh wound" = 25, "blood soaked clot" = 15, "large scab" = 5, "fresh skin" = 0)
	damage_type = CUT

/datum/wound/cut/gaping
	max_bleeding_stage = 3
	stages = list("gaping wound" = 50, "large blood soaked clot" = 25, "blood soaked clot" = 15, "small angry scar" = 5, "small straight scar" = 0)
	damage_type = CUT

/datum/wound/cut/gaping_big
	max_bleeding_stage = 3
	stages = list("big gaping wound" = 60, "healing gaping wound" = 40, "large blood soaked clot" = 25, "large angry scar" = 10, "large straight scar" = 0)
	damage_type = CUT

datum/wound/cut/massive
	max_bleeding_stage = 3
	stages = list("massive wound" = 70, "massive healing wound" = 50, "massive blood soaked clot" = 25, "massive angry scar" = 10,  "massive jagged scar" = 0)
	damage_type = CUT

/** PUNCTURES **/
/datum/wound/puncture/can_worsen(damage_type, damage)
	return 0
/datum/wound/puncture/can_merge(var/datum/wound/other)
	return 0
/datum/wound/puncture/bleeding()
	return ..() && wound_damage() >= 5

/datum/wound/puncture/small
	max_bleeding_stage = 2
	stages = list("puncture" = 5, "healing puncture" = 2, "small scab" = 0)
	damage_type = PIERCE

/datum/wound/puncture/flesh
	max_bleeding_stage = 2
	stages = list("puncture wound" = 15, "blood soaked clot" = 5, "large scab" = 2, "small round scar" = 0)
	damage_type = PIERCE

/datum/wound/puncture/gaping
	max_bleeding_stage = 3
	stages = list("gaping hole" = 30, "large blood soaked clot" = 15, "blood soaked clot" = 10, "small angry scar" = 5, "small round scar" = 0)
	damage_type = PIERCE

/datum/wound/puncture/gaping_big
	max_bleeding_stage = 3
	stages = list("big gaping hole" = 50, "healing gaping hole" = 20, "large blood soaked clot" = 15, "large angry scar" = 10, "large round scar" = 0)
	damage_type = PIERCE

datum/wound/puncture/massive
	max_bleeding_stage = 3
	stages = list("massive wound" = 60, "massive healing wound" = 30, "massive blood soaked clot" = 25, "massive angry scar" = 10,  "massive jagged scar" = 0)
	damage_type = PIERCE

/** BRUISES **/
/datum/wound/bruise/bleeding()
	return ..() && wound_damage() >= 20

/datum/wound/bruise
	stages = list("monumental bruise" = 80, "huge bruise" = 50, "large bruise" = 30,
				  "moderate bruise" = 20, "small bruise" = 10, "tiny bruise" = 5)
	max_bleeding_stage = 3 //only large bruise and above can bleed.
	autoheal_cutoff = 30
	damage_type = BRUISE

/** BURNS **/
/datum/wound/burn
	max_bleeding_stage = 0
/datum/wound/burn/bleeding()
	return 0

/datum/wound/burn/moderate
	stages = list("ripped burn" = 10, "moderate burn" = 5, "healing moderate burn" = 2, "fresh skin" = 0)
	damage_type = BURN

/datum/wound/burn/large
	stages = list("ripped large burn" = 20, "large burn" = 15, "healing large burn" = 5, "fresh skin" = 0)
	damage_type = BURN

/datum/wound/burn/severe
	stages = list("ripped severe burn" = 35, "severe burn" = 30, "healing severe burn" = 10, "burn scar" = 0)
	damage_type = BURN

/datum/wound/burn/deep
	stages = list("ripped deep burn" = 45, "deep burn" = 40, "healing deep burn" = 15,  "large burn scar" = 0)
	damage_type = BURN

/datum/wound/burn/carbonised
	stages = list("carbonised area" = 50, "healing carbonised area" = 20, "massive burn scar" = 0)
	damage_type = BURN

/** EXTERNAL ORGAN LOSS **/
/datum/wound/lost_limb

/datum/wound/lost_limb/New(var/obj/item/organ/external/lost_limb, var/losstype, var/clean)
	var/damage_amt = lost_limb.max_damage
	if(clean)
		damage_amt /= 2
	if(BP_IS_ROBOTIC(lost_limb))
		damage_amt /= 2

	switch(losstype)
		if(DROPLIMB_EDGE, DROPLIMB_BLUNT)
			damage_type = CUT
			max_bleeding_stage = 3 //clotted stump and above can bleed.
			stages = list(
				"ripped stump" = damage_amt*1.3,
				"bloody stump" = damage_amt,
				"clotted stump" = damage_amt*0.5,
				"scarred stump" = 0
				)
		if(DROPLIMB_BURN, DROPLIMB_EDGE_BURN)
			damage_type = BURN
			stages = list(
				"ripped charred stump" = damage_amt*1.3,
				"charred stump" = damage_amt,
				"scarred stump" = damage_amt*0.5,
				"scarred stump" = 0
				)

	..(damage_amt)

/datum/wound/lost_limb/can_merge(var/datum/wound/other)
	return 0 //cannot be merged
