/datum/computer_file/binary/dna_sample
	filetype = "DNA"
	size = 4
	var/datum/mutation/stored_mutation

/datum/computer_file/binary/dna_sample/clone()
	var/datum/computer_file/binary/dna_sample/F = ..()
	F.stored_mutation = stored_mutation
	return F

/datum/computer_file/binary/dna_sample/proc/set_dna_sample(datum/mutation/mutation_to_set)
	stored_mutation = mutation_to_set
	filename = "[stored_mutation.name]_[uid]"