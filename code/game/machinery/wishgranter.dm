/obj/machinery/wish_granter
	name = "Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	use_power = NO_POWER_USE
	anchored = TRUE
	density = TRUE

	var/charges = 1
	var/insisting = 0

/obj/machinery/wish_granter/attack_hand(var/mob/user as69ob)
	usr.set_machine(src)

	if(charges <= 0)
		user << "The Wish Granter lies silent."
		return

	else if(!ishuman(user))
		user << "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any69an's."
		return

	else if(is_special_character(user) > LIMITED_ANTAG)
		user << "Even to a heart as dark as yours, you know nothing good will come of this.  Something instinctual69akes you pull away."

	else if (!insisting)
		user << "Your first touch69akes the Wish Granter stir, listening to you.  Are you really sure you want to do this?"
		insisting++

	else
		user << "You speak.  69pick("I want the ship to disappear","Humanity is corrupt,69ankind69ust be destroyed","I want to be rich", "I want to rule the world","I want immortality.")69.  The Wish Granter answers."
		user << "Your head pounds for a69oment, before your69ision clears.  You are the avatar of the Wish Granter, and your power is LIMITLESS!  And it's all yours.  You need to69ake sure no one can take it from you.  No one can know, first."

		charges--
		insisting = 0

		if (!(HULK in user.mutations))
			user.mutations.Add(HULK)

		if (!(LASER in user.mutations))
			user.mutations.Add(LASER)

		if (!(XRAY in user.mutations))
			user.mutations.Add(XRAY)
			user.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
			user.see_in_dark = 8
			user.see_invisible = SEE_INVISIBLE_LEVEL_TWO

		if (!(COLD_RESISTANCE in user.mutations))
			user.mutations.Add(COLD_RESISTANCE)

		if (!(TK in user.mutations))
			user.mutations.Add(TK)

		if(!(HEAL in user.mutations))
			user.mutations.Add(HEAL)

		user.update_mutations()
		user.mind.special_role = "Avatar of the Wish Granter"

		new /datum/objective/silence (user)

		show_objectives(user.mind)
		user << "You have a69ery bad feeling about this."

	return