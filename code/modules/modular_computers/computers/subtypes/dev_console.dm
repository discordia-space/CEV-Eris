/obj/item/modular_computer/console
	name = "console"
	desc = "A stationary computer."
	icon = 'icons/obj/modular_console.dmi'
	icon_state = "console"
	icon_state_menu = "menu"
	hardware_flag = PROGRAM_CONSOLE
	anchored = TRUE
	density = TRUE
	volumeClass = ITEM_SIZE_GARGANTUAN
	base_idle_power_usage = 100
	base_active_power_usage = 500
	max_hardware_size = 3
	steel_sheet_cost = 20
	screen_light_strength = 2.8
	screen_light_range = 2.1
	max_damage = 300
	broken_damage = 150
	spawn_tags = SPAWN_TAG_MACHINERY

/obj/item/modular_computer/console/CouldUseTopic(mob/user)
	..()
	if(istype(user, /mob/living/carbon))
		if(prob(50))
			playsound(src, "keyboard", 40)
		else
			playsound(src, "keystroke", 40)

/obj/item/modular_computer/console/break_apart()
	..()
	var/datum/effect/effect/system/smoke_spread/S = new/datum/effect/effect/system/smoke_spread()
	S.set_up(3, 0, src)
	S.start()
