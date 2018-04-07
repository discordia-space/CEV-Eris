//Define a macro that we can use to assemble all the circuit board names
#ifdef T_BOARD
#error T_BOARD already defined elsewhere, we can't use it.
#endif
#define T_BOARD(name)	"circuit board (" + (name) + ")"

/obj/item/weapon/circuitboard
	name = "circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	item_state = "electronic"
	origin_tech = list(TECH_DATA = 2)
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 3)
	density = 0
	anchored = 0
	w_class = ITEM_SIZE_SMALL
	flags = CONDUCT
	force = WEAPON_FORCE_HARMLESS
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 3
	throw_range = 15

	var/build_path = null
	var/frame_type = FRAME_DEFAULT
	var/board_type = "computer"
	var/list/req_components = null

//Called when the circuitboard is used to contruct a new machine.
/obj/item/weapon/circuitboard/proc/construct(var/obj/machinery/M)
	if (istype(M, build_path))
		return TRUE
	return FALSE

//Called when a computer is deconstructed to produce a circuitboard.
//Only used by computers, as other machines store their circuitboard instance.
/obj/item/weapon/circuitboard/proc/deconstruct(var/obj/machinery/M)
	if (istype(M, build_path))
		return TRUE
	return FALSE
