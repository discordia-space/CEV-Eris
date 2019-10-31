#define TIER_0	"N"
#define TIER_1	"I"
#define TIER_2	"II"
#define TIER_3	"III"
#define TIER_4	"IV"

/datum/mutation
	var/name
	var/tier
	var/activated = FALSE
	var/activation_message
	var/deactivation_message
	var/NSA

	var/genocode1
	var/genocode2

/datum/mutation/New()
	if(!tier)
		tier = pickweight(list(
		TIER_1 = 7,
		TIER_2 = 5,
		TIER_3 = 3,
		TIER_4 = 1
		))

	if(!genocode1 && !genocode2)
		genocode1 = rand(1, 8)
		genocode2 = rand(1, 8)

/datum/mutation/proc/activate(mob/M)

/datum/mutation/proc/deactivate(mob/M)

/datum/mutation/disability
	tier = TIER_0
	NSA = 0
	var/mutation
	var/disability
	var/sdisability
	var/block

/datum/mutation/disability/New()
	. = ..()

/datum/mutation/disability/activate(mob/M)
	if(mutation && !(mutation in M.mutations))
		M.mutations.Add(mutation)
	if(disability)
		M.disabilities|=disability
	if(sdisability)
		M.sdisabilities|=sdisability
	if(activation_message)
		to_chat(M, SPAN_WARNING("[activation_message]"))
	else
		testing("[name] has no activation message.")

/datum/mutation/disability/deactivate(mob/M)
	if(mutation && (mutation in M.mutations))
		M.mutations.Remove(mutation)
	if(disability)
		M.disabilities &= (~disability)
	if(sdisability)
		M.sdisabilities &= (~sdisability)
	if(deactivation_message)
		to_chat(M, SPAN_WARNING("[deactivation_message]"))
	else
		testing("[name] has no deactivation message.")