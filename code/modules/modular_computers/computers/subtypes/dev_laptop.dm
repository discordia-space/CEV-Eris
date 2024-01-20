/obj/item/modular_computer/laptop
	anchored = FALSE
	name = "laptop computer"
	desc = "A portable clamshell computer."
	hardware_flag = PROGRAM_LAPTOP
	icon = 'icons/obj/modular_laptop.dmi'
	icon_state = "laptop"
	matter = list(MATERIAL_STEEL = 8, MATERIAL_GLASS = 4)
	volumeClass = ITEM_SIZE_NORMAL
	base_idle_power_usage = 25
	base_active_power_usage = 200
	max_hardware_size = 2
	screen_light_strength = 3.8
	screen_light_range = 1.7
	max_damage = 200
	broken_damage = 100
	screen_on = FALSE
	volumeClass = ITEM_SIZE_NORMAL
	price_tag = 200

/obj/item/modular_computer/laptop/AltClick(var/mob/user)
// Prevents carrying of open laptops inhand.
// While they work inhand, i feel it'd make tablets lose some of their high-mobility advantage they have over laptops now.
	if(!CanPhysicallyInteract(user))
		return
	if(!istype(loc, /turf/))
		to_chat(usr, "\The [src] has to be on a stable surface first!")
		return
	anchored = !anchored
	screen_on = anchored
	update_icon()

/obj/item/modular_computer/laptop/update_icon()
	..()

	icon_state = initial(icon_state)
	if(!anchored)
		overlays.Cut()
		icon_state += "-closed"
