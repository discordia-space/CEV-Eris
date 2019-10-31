/datum/mutation/disability/hallucinate
	name = "Hallucinate"
	activation_message = "Your mind says 'Hello'."
	mutation = mHallucination

/datum/mutation/disability/nearsighted/New()
	..()
	block = HALLUCINATIONBLOCK

/datum/mutation/disability/epilepsy
	name = "Epilepsy"
	activation_message = "You get a headache."
	disability = EPILEPSY

/datum/mutation/disability/nearsighted/New()
	..()
	block = HEADACHEBLOCK

/datum/mutation/disability/cough
	name = "Coughing"
	activation_message = "You start coughing."
	disability = COUGHING

/datum/mutation/disability/nearsighted/New()
	..()
	block = COUGHBLOCK

/datum/mutation/disability/clumsy
	name = "Clumsiness"
	activation_message = "You feel lightheaded."
	mutation = CLUMSY

/datum/mutation/disability/nearsighted/New()
	..()
	block = CLUMSYBLOCK

/datum/mutation/disability/tourettes
	name = "Tourettes"
	activation_message = "You twitch."
	disability = TOURETTES

/datum/mutation/disability/nearsighted/New()
	..()
	block = TWITCHBLOCK

/datum/mutation/disability/nervousness
	name = "Nervousness"
	activation_message = "You feel nervous."
	disability = NERVOUS

/datum/mutation/disability/nearsighted/New()
	..()
	block = NERVOUSBLOCK

/datum/mutation/disability/blindness
	name = "Blindness"
	activation_message = "You can't seem to see anything."
	sdisability = BLIND

/datum/mutation/disability/nearsighted/New()
	..()
	block = BLINDBLOCK

/datum/mutation/disability/deaf
	name = "Deafness"
	activation_message = "It's kinda quiet."
	sdisability = DEAF

/datum/mutation/disability/nearsighted/New()
	..()
	block = DEAFBLOCK

/datum/mutation/disability/deaf/activate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.ear_deaf = 1

/datum/mutation/disability/nearsighted
	name = "Nearsightedness"
	activation_message = "Your eyes feel weird..."
	disability = NEARSIGHTED

/datum/mutation/disability/nearsighted/New()
	..()
	block = GLASSESBLOCK
