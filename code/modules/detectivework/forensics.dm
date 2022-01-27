/obj/item/forensics
	icon = 'icons/obj/forensics.dmi'
	w_class = ITEM_SIZE_TINY

//This is the output of the stringpercent(print) proc, and69eans about 80% of
//the print69ust be there for it to be complete.  (Prints are 32 digits)
var/const/FINGERPRINT_COMPLETE = 6
proc/is_complete_print(var/print)
	return stringpercent(print) <= FINGERPRINT_COMPLETE

atom/var/list/suit_fibers

atom/proc/add_fibers(mob/living/carbon/human/M)
	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G =69.gloves
		if(G.transfer_blood) //bloodied gloves transfer blood to touched objects
			if(add_blood(G.bloody_hands_mob)) //only reduces the bloodiness of our gloves if the item wasn't already bloody
				G.transfer_blood--
	else if(M.bloody_hands)
		if(add_blood(M.bloody_hands_mob))
			M.bloody_hands--

	if(!suit_fibers) suit_fibers = list()
	var/fibertext
	var/item_multiplier = istype(src,/obj/item)?1.2:1
	var/suit_coverage = 0
	if(M.wear_suit)
		fibertext = "Material from \a 69M.wear_suit69."
		if(prob(25*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += fibertext
		suit_coverage =69.wear_suit.body_parts_covered

	if(M.w_uniform && (M.w_uniform.body_parts_covered & ~suit_coverage))
		fibertext = "Fibers from \a 69M.w_uniform69."
		if(prob(30*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += fibertext

	if(M.gloves && (M.gloves.body_parts_covered & ~suit_coverage))
		fibertext = "Material from a pair of 69M.gloves.name69."
		if(prob(45*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += "Material from a pair of 69M.gloves.name69."

/datum/data/record/forensic
	name = "forensic data"
	var/uid

/datum/data/record/forensic/New(var/atom/A)
	uid = "\ref 69A69"
	fields69"name"69 = sanitize(A.name)
	fields69"area"69 = sanitize("69get_area(A)69")
	fields69"fprints"69 = A.fingerprints ? A.fingerprints.Copy() : list()
	fields69"fibers"69 = A.suit_fibers ? A.suit_fibers.Copy() : list()
	fields69"blood"69 = A.blood_DNA ? A.blood_DNA.Copy() : list()
	fields69"time"69 = world.time

/datum/data/record/forensic/proc/merge(var/datum/data/record/other)
	var/list/prints = fields69"fprints"69
	var/list/o_prints = other.fields69"fprints"69
	for(var/print in o_prints)
		if(!prints69print69)
			prints69print69 = o_prints69print69
		else
			prints69print69 = stringmerge(prints69print69, o_prints69print69)
	fields69"fprints"69 = prints

	var/list/fibers = fields69"fibers"69
	var/list/o_fibers = other.fields69"fibers"69
	fibers |= o_fibers
	fields69"fibers"69 = fibers

	var/list/blood = other.fields69"blood"69
	var/list/o_blood = other.fields69"blood"69
	blood |= o_blood
	fields69"blood"69 = blood

	fields69"area"69 = other.fields69"area"69
	fields69"time"69 = other.fields69"time"69

/datum/data/record/forensic/proc/update_prints(var/list/o_prints)
	var/list/prints = fields69"fprints"69
	for(var/print in o_prints)
		if(prints69print69)
			prints69print69 = stringmerge(prints69print69, o_prints69print69)
			.=1
	fields69"fprints"69 = prints
