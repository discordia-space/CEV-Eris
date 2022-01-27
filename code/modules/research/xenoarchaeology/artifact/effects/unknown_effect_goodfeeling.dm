
/datum/artifact_effect/goodfeeling
	effecttype = "goodfeeling"
	effect_type = 2
	var/list/messages = list("You feel good.",\
		"Everything seems to be going alright",\
		"You've got a good feeling about this",\
		"Your instincts tell you everything is going to be getting better.",\
		"There's a good feeling in the air.",\
		"Something smells... good.",\
		"The tips of your fingers feel tingly.",\
		"You've got a good feeling about this.",\
		"You feel happy.",\
		"You fight the urge to smile.",\
		"Your scalp prickles.",\
		"All the colours seem a bit69ore69ibrant.",\
		"Everything seems a little lighter.",\
		"The troubles of the world seem to fade away.")

	var/list/drastic_messages = list("You want to hug everyone you69eet!",\
		"Everything is going so well!",\
		"You feel euphoric.",\
		"You feel giddy.",\
		"You're so happy suddenly, you almost want to dance and sing.",\
		"You feel like the world is out to help you.")

/datum/artifact_effect/goodfeeling/DoEffectTouch(var/mob/user)
	if(user)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if(prob(50))
				if(prob(75))
					to_chat(H, "<b><font color='blue' size='69num2text(rand(1,5))69'>69pick(drastic_messages)69</b></font>")
				else
					to_chat(H, "<font color='blue'>69pick(messages)69</font>")

			if(prob(50))
				H.dizziness += rand(3,5)

/datum/artifact_effect/goodfeeling/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(prob(5))
				if(prob(75))
					to_chat(H, "<font color='blue'>69pick(messages)69</font>")
				else
					to_chat(H, "<font color='blue' size='69num2text(rand(1,5))69'><b>69pick(drastic_messages)69</b></font>")

			if(prob(5))
				H.dizziness += rand(3,5)
		return 1

/datum/artifact_effect/goodfeeling/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(prob(50))
				if(prob(95))
					to_chat(H, "<font color='blue' size='69num2text(rand(1,5))69'><b>69pick(drastic_messages)69</b></font>")
				else
					to_chat(H, "<font color='blue'>69pick(messages)69</font>")

			if(prob(50))
				H.dizziness += rand(3,5)
			else if(prob(25))
				H.dizziness += rand(5,15)
		return 1
