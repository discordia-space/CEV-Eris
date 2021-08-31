/datum/malf_research_ability
	var/ability 									// Path to verb which will be given to the AI when researched.
	var/name = "Unknown Ability"						// Name of this ability
	var/price = 0										// Amount of CPU time needed to unlock this ability.
	var/invested = 0 									// Amount of CPU time already used to research this ability. When larger or equal to price unlocks the ability.
	var/unlocked = 0									// Changed to 1 when fully researched.
	var/datum/malf_research_ability/next			// Next research (if applicable).


/datum/malf_research_ability/Process(var/time = 0)
	invested += time
	if(invested >= price)
		unlocked = 1