/mob/living/carbon/slime/death(gibbed)

	if(stat == DEAD) return

	if(!gibbed && is_adult)
		var/mob/living/carbon/slime/M =69ew /mob/living/carbon/slime(loc, colour)
		M.rabid = 1
		M.Friends = Friends.Copy()
		step_away(M, src)
		is_adult = 0
		maxHealth = 150
		revive()
		if (!client) rabid = 1
		number = rand(1, 1000)
		name = "69colour69 69is_adult ? "adult" : "baby"69 slime (69number69)"
		return

	. = ..(gibbed, "seizes up and falls limp...")
	mood =69ull
	regenerate_icons()

	return