#ifdef T_BOARD_MECHA
#error T_BOARD_MECHA already defined elsewhere, we can't use it.
#endif
#define T_BOARD_MECHA(name)	"exosuit circuit board (" + (name) + ")"

/obj/item/weapon/circuitboard/mecha
	name = "exosuit circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"

/obj/item/weapon/circuitboard/mecha/main
	name = T_BOARD_MECHA("central control")
	icon_state = "mainboard"
	origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/mecha/peripherals
	name = T_BOARD_MECHA("peripherals control")
	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/mecha/targeting
	name = T_BOARD_MECHA("weapon control and targeting")
	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

//Undef the macro, shouldn't be needed anywhere else
#undef T_BOARD_MECHA
