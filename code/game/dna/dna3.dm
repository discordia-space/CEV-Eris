//DNA 3: Revenge of The Geneticists

/datum/dna
	var/list/mutations

/datum/dna/New()
	mutations = list()
	add_random_mutations(1, 3)

/datum/dna/proc/add_random_mutations(min, max)
	var/list/possible_mutations = subtypesof(/datum/mutation) - /datum/mutation/disability
	var/list/picked_mutations = list()
	for(var/k = 1, k <= rand(min, max), k++)
		picked_mutations += pick(possible_mutations)
	var/list/init_mutations = list()
	for(var/path in picked_mutations)
		init_mutations += new path
	mutations.Add(init_mutations)