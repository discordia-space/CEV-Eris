/mob/living/carbon
	gender = MALE
	/// Contains icon generation and language information, set during New().
	var/datum/species/species
	var/list/stomach_contents = list()

	/// The amount of life ticks that have processed on this mob.
	var/life_tick = 0
	/**
	 * When this is set, the mob isn't affected by shock or pain.
	 * Life should decrease this by 1 every tick
	 */
	var/analgesic = 0
	// total amount of wounds on mob, used to spread out healing and the like over all wounds
	/// //Whether or not the mob is handcuffed, and if so, what item is being used.
	var/obj/item/handcuffed
	/// Same as handcuffs but for legs. Bear traps use this.
	var/obj/item/legcuffed
	/// Active emote/pose
	var/pose

	/// Values from all base organs should add up to this
	var/total_blood_req = 40
	var/total_oxygen_req = 50
	var/total_nutriment_req = DEFAULT_HUNGER_FACTOR

	var/datum/reagents/metabolism/bloodstr
	var/datum/reagents/metabolism/ingested
	var/datum/reagents/metabolism/touching
	var/datum/metabolism_effects/metabolism_effects
	/// if we failed to breathe last tick
	var/losebreath = 0

	var/coughedtime
	var/lastpuke = 0

	var/cpr_time = 1
	nutrition = 400//Carbon

	var/obj/item/tank/internal //Human/Monkey


	bad_type = /mob/living/carbon
	//TODO: move to brain

