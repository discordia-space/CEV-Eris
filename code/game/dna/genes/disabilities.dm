/////////////////////
// DISABILITY GENES
//
// These activate either a69utation, disability, or sdisability.
//
// Gene is always activated.
/////////////////////

/datum/dna/gene/disability
	name="DISABILITY"

	//69utation to give (or 0)
	var/mutation=0

	// Disability to give (or 0)
	var/disability=0

	// SDisability to give (or 0)
	var/sdisability=0

	// Activation69essage
	var/activation_message=""

	// Yay, you're no longer growing 3 arms
	var/deactivation_message=""

/datum/dna/gene/disability/can_activate(var/mob/M,var/flags)
	return 1 // Always set!

/datum/dna/gene/disability/activate(var/mob/M,69ar/connected,69ar/flags)
	if(mutation && !(mutation in69.mutations))
		M.mutations.Add(mutation)
	if(disability)
		M.disabilities|=disability
	if(sdisability)
		M.sdisabilities|=sdisability
	if(activation_message)
		to_chat(M, SPAN_WARNING("69activation_message69"))
	else
		testing("69name69 has no activation69essage.")

/datum/dna/gene/disability/deactivate(var/mob/M,69ar/connected,69ar/flags)
	if(mutation && (mutation in69.mutations))
		M.mutations.Remove(mutation)
	if(disability)
		M.disabilities &= (~disability)
	if(sdisability)
		M.sdisabilities &= (~sdisability)
	if(deactivation_message)
		to_chat(M, SPAN_WARNING("69deactivation_message69"))
	else
		testing("69name69 has no deactivation69essage.")

// Note: Doesn't seem to do s69uat, at the69oment.
/datum/dna/gene/disability/hallucinate
	name="Hallucinate"
	activation_message="Your69ind says 'Hello'."
	mutation=mHallucination

	New()
		block=HALLUCINATIONBLOCK

/datum/dna/gene/disability/epilepsy
	name="Epilepsy"
	activation_message="You get a headache."
	disability=EPILEPSY

	New()
		block=HEADACHEBLOCK

/datum/dna/gene/disability/cough
	name="Coughing"
	activation_message="You start coughing."
	disability=COUGHING

	New()
		block=COUGHBLOCK

/datum/dna/gene/disability/clumsy
	name="Clumsiness"
	activation_message="You feel lightheaded."
	mutation=CLUMSY

	New()
		block=CLUMSYBLOCK

/datum/dna/gene/disability/tourettes
	name="Tourettes"
	activation_message="You twitch."
	disability=TOURETTES

	New()
		block=TWITCHBLOCK

/datum/dna/gene/disability/nervousness
	name="Nervousness"
	activation_message="You feel nervous."
	disability=NERVOUS

	New()
		block=NERVOUSBLOCK

/datum/dna/gene/disability/blindness
	name="Blindness"
	activation_message="You can't seem to see anything."
	sdisability=BLIND

	New()
		block=BLINDBLOCK

/datum/dna/gene/disability/deaf
	name="Deafness"
	activation_message="It's kinda 69uiet."
	sdisability=DEAF

	New()
		block=DEAFBLOCK

	activate(var/mob/M,69ar/connected,69ar/flags)
		..(M,connected,flags)
		M.ear_deaf = 1

/datum/dna/gene/disability/nearsighted
	name="Nearsightedness"
	activation_message="Your eyes feel weird..."
	disability=NEARSIGHTED

	New()
		block=GLASSESBLOCK
