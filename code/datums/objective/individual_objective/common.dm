/datum/individual_objetive/common/casda
    name = "common"

/datum/individual_objetive/job/beyond
    name = "A Particular Spot"
    var/x
    var/y
    var/time = 5 MINUTES

/datum/individual_objetive/job/beyond/New()
    . = ..()
    if(!.) return FALSE
    x = rand(1, GLOB.maps_data.overmap_size)
    y = rand(1, GLOB.maps_data.overmap_size)

/datum/individual_objetive/get_description()
	return "Move the ship to coordenates [x], [y] for 5 minutes"
