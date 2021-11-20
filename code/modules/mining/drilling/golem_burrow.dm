/obj/structure/golem_burrow
	name = "golem burrow"
	icon = 'icons/obj/burrows.dmi'
	icon_state = "hole"
	desc = "A pile of rocks that regularly pulses as if it was alive."
	density = TRUE
	anchored = TRUE

	var/maxhealth = 50
	var/health = 50
	var/datum/golem_controller/controller 

/obj/structure/golem_burrow/New(var/loc, var/parent)
	.=..()
	controller = parent  // Link burrow with golem controller

/obj/structure/golem_burrow/Destroy()
	if(controller)
		controller.burrows -= src
	.=..()
