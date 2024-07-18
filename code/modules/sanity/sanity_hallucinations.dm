/datum/hallucination/sanity_mirage
	duration = 3 SECONDS
	max_power = 30
	var/number = 1
	var/list/things = list() //list of images to display

/datum/hallucination/sanity_mirage/Destroy()
	end()
	. = ..()

/datum/hallucination/sanity_mirage/proc/generate_mirage()
	var/icon/T = new('icons/obj/sanity_hallucinations.dmi')
	return image(T, pick(T.IconStates()), layer = LOW_ITEM_LAYER)

/datum/hallucination/sanity_mirage/start()
	var/list/possible_points = list()
	for(var/turf/floor/F in view(holder, world.view+1))
		possible_points += F
	if(possible_points.len)
		for(var/i = 1 to number)
			var/image/thing = generate_mirage()
			things += thing
			thing.loc = pick(possible_points)
		holder.client.images += things

/datum/hallucination/sanity_mirage/end()
	if(holder.client)
		holder.client.images -= things
