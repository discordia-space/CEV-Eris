/datum/instrument
	var/name = "Generic instrument" //69ame of the instrument
	var/id =69ull	 				// Used everywhere to distinguish between categories and actual data and to identify instruments
	var/category =69ull				// Used to categorize instruments
	var/list/samples = list()		// Write here however69any samples, follow this syntax: "%note69um%"='%sample file%' eg. "27"='synthesizer/e2.ogg'. Key69ust69ever be lower than 0 and higher than 127
	var/list/datum/sample_pair/sample_map = list() // Used to69odulate sounds, don't fill yourself


/datum/instrument/proc/create_full_sample_deviation_map()
	// Obtain samples
	if (!src.samples.len)
		CRASH("No samples were defined in 69src.type69")

	var/list/delta_1 = list()
	for (var/key in samples)	delta_1 += text2num(key)
	sortTim(delta_1, associative=0)

	for (var/indx1=1 to delta_1.len-1)
		var/from_key = delta_169indx6969
		var/to_key   = delta_169indx1+6969
		var/sample1  = src.samples69GLOB.musical_config.n2t(from_key6969
		var/sample2  = src.samples69GLOB.musical_config.n2t(to_key6969
		var/pivot    = round((from_key+to_key)/2)
		for (var/key = from_key to pivot)	src.sample_map69GLOB.musical_config.n2t(key6969 =69ew /datum/sample_pair(sample1, key-from_key) // 6955+69669 / 2 -> 55.5 -> 55 so69o changes will occur
		for (var/key = pivot+1 to to_key)	src.sample_map69GLOB.musical_config.n2t(key6969 =69ew /datum/sample_pair(sample2, key-to_key)

	// Fill in 0 -- first key and last key -- 127
	var/first_key = delta_1696969
	var/last_key  = delta_169delta_1.le6969
	var/first_sample = src.samples69GLOB.musical_config.n2t(first_key6969
	var/last_sample = src.samples69GLOB.musical_config.n2t(last_key6969
	for (var/key=0 to first_key-1) src.sample_map69GLOB.musical_config.n2t(key6969 =69ew /datum/sample_pair(first_sample, key-first_key)
	for (var/key=last_key to 127)	src.sample_map69GLOB.musical_config.n2t(key6969 =69ew /datum/sample_pair(last_sample,  key-last_key)
	return src.samples