/obj/item/organ/internal/xenos/resinspinner
	name = "resin spinner"
	parent_organ = BP_HEAD
	icon_state = "xgibmid2"
	organ_tag = O_RESIN
	owner_verbs = list(
		/obj/item/organ/internal/xenos/resinspinner/proc/plant,
		/obj/item/organ/internal/xenos/resinspinner/proc/resin
	)

/obj/item/organ/internal/xenos/resinspinner/proc/plant()
	set name = "Plant Weeds (50)"
	set desc = "Plants some alien weeds"
	set category = "Abilities"

	if(check_alien_ability(50, TRUE))
		owner.visible_message("<span class='alium'><B>[owner] has planted some alien weeds!</B></span>")
		new /obj/structure/alien/node(loc)

/obj/item/organ/internal/xenos/resinspinner/proc/resin() // -- TLE
	set name = "Secrete Resin (75)"
	set desc = "Secrete tough, malleable resin."
	set category = "Abilities"

	var/list/buildings = list(
		"resin door" = /obj/machinery/door/unpowered/simple/resin,
		"resin wall" = /obj/structure/alien/resin/wall,
		"resin membrane" = /obj/structure/alien/resin/membrane,
		"resin nest" = /obj/structure/bed/nest
	)
	var/choice = input("Choose what you wish to shape.","Resin building") as null|anything in buildings
	if(!choice)
		return

	if(!check_alien_ability(75, TRUE))
		return

	owner.visible_message(
		SPAN_WARNING("<B>[owner] vomits up a thick purple substance and begins to shape it!</B>"),
		"<span class='alium'>You shape a [choice].</span>"
	)
	var/selected_type = buildings[choice]
	new selected_type (loc)
