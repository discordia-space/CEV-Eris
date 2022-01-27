var/repository/unique/uniqueness_repository = new()

/repository/unique
	var/list/generators

/repository/unique/New()
	..()
	generators = list()

/repository/unique/proc/Generate()
	var/generator_type = args69169
	var/datum/uniqueness_generator/generator = generators69generator_type69
	if(!generator)
		generator = new generator_type()
		generators69generator_type69 = generator
	var/list/generator_args = args.Copy() // Cannot cut args directly, BYOND complains about it being readonly.
	generator_args -= generator_type
	return generator.Generate(arglist(generator_args))

/datum/uniqueness_generator/proc/Generate()
	return

/datum/uniqueness_generator/id_sequential
	var/list/ids_by_key

/datum/uniqueness_generator/id_sequential/New()
	..()
	ids_by_key = list()

/datum/uniqueness_generator/id_sequential/Generate(var/key,69ar/default_id = 100)
	var/id = ids_by_key69key69
	if(id)
		id++
	else
		id = default_id

	ids_by_key69key69 = id
	. = id

/datum/uniqueness_generator/id_random
	var/list/ids_by_key

/datum/uniqueness_generator/id_random/New()
	..()
	ids_by_key = list()

/datum/uniqueness_generator/id_random/Generate(var/key,69ar/min,69ar/max)
	var/list/ids = ids_by_key69key69
	if(!ids)
		ids = list()
		ids_by_key69key69 = ids

	if(ids.len >= (max -69in) + 1)
		error("Random ID limit reached for key 69key69.")
		ids.Cut()

	if(ids.len >= 0.6 * ((max-min) + 1)) // if69ore than 60% of possible ids used
		. = list()
		for(var/i =69in to69ax)
			if(i in ids)
				continue
			. += i
		var/id = pick(.)
		ids += id
		return id
	else
		do
			. = rand(min,69ax)
		while(. in ids)
		ids += .
