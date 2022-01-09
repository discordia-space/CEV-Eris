#define DOMINO_MIN_VALUE			1
#define DOMINO_MAX_VALUE			8


/proc/get_domino_value()
	return pick(DOMINO_MIN_VALUE to DOMINO_MAX_VALUE)

/proc/get_random_hex()
	var/hex = ""
	while(hex.len < 6)
		hex += pick(hexdigits)
	return hex

/*
	name = "Primus sequence"
	value = SPECIES_HUMAN // species // SPECIES_HUMAN, SPECIES_SLIME, SPECIES_MONKEY, SPECIES_GOLEM
	name = "Sanguinis sequence"
	name = "Genus sequence"
	value =	MALE // gender // all_genders_define_list // list(MALE, FEMALE, PLURAL, NEUTER)
	name = "Aspectus sequence"
	value =	"John Doe" // real_name
	var/b_type // GLOB.blood_types // list("A-", "A+", "B-", "B+", "AB-", "AB+", "O-", "O+")
	var/dna_trace
	hair_color, facial_color, skin_color, eyes_color
*/

/datum/mutation
	var/name = "Unknown sequence"
	var/desc = "Unknown function"
	var/hex = "FFFFFF"
	var/tier_num = 0 // 0, 1, 2, 3, 4
	var/tier_string = "Nero" // "Nero", "Vespasian", "Tacitus", "Hadrian", "Aurelien"
	var/NSA_load = 1 // How much NSA holder get if mutation is active
	var/
	var/domino_r = 1
	var/domino_l = 1


/datum/mutation/New()
	hex = get_random_hex()
	domino_r = get_domino_value()
	domino_l = get_domino_value()


/datum/mutation/proc/activate(mob/living/carbon/user)
	if(!istype(user))
		return

	if(src in user.active_mutations)
		return

// Check for maximum active mutations of certain type

	if(src in user.dormant_mutations)
		user.dormant_mutations -= src

	user.active_mutations |= src
	user.metabolism_effects.adjust_nsa(NSA_load, "Mutation_[hex]_[name]")


/datum/mutation/proc/deactivate(mob/living/carbon/user)
	if(!istype(user))
		return

	user.active_mutations -= src
	user.dormant_mutations |= src
	user.metabolism_effects.remove_nsa("Mutation_[hex]_[name]")


/datum/computer_file/binary/animalgene
	filetype = "ADNA"
	size = 10

	var/referenced_datum = /datum/mutation/





