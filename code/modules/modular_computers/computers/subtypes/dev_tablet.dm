/obj/item/modular_computer/tablet
	name = "tablet computer"
	desc = "A small, portable microcomputer."
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet"
	matter = list(MATERIAL_STEEL = 5, MATERIAL_GLASS = 2)

	icon_state_menu = "menu"
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1
	volumeClass = ITEM_SIZE_SMALL
	screen_light_strength = 2.1
	screen_light_range = 2.1
	price_tag = 100
	suitable_cell = /obj/item/cell/small //We take small battery


/obj/item/modular_computer/tablet/lease
	desc = "A small, portable microcomputer. This one has a gold and blue stripe, and a serial number stamped into the case."
	icon_state = "tabletsol"


/obj/item/modular_computer/tablet/moebius
	desc = "A small, portable microcomputer. This one has two extra screens and a Moebius Laboratories logo stamped on the back."
	icon = 'icons/obj/modular_tablet_moebius.dmi'
	var/image/direction_overlay
	var/image/z_level_overlay
	var/direction_overlay_blink_delay = 0
	var/z_level_overlay_blink_delay = 0
	var/is_tracking = FALSE
	var/mob/living/carbon/human/target_mob


/obj/item/modular_computer/tablet/moebius/New()
	direction_overlay = image(icon, icon_state = "point")
	z_level_overlay = image(icon, icon_state = "z_same")
	. = ..()


/obj/item/modular_computer/tablet/moebius/Destroy()
	qdel(direction_overlay)
	qdel(z_level_overlay)
	target_mob = null
	. = ..()


/obj/item/modular_computer/tablet/moebius/update_icon()
	..()
	if(active_program && istype(active_program, /datum/computer_file/program/suit_sensors))
		spawn(direction_overlay_blink_delay)
			overlays += direction_overlay
		spawn(z_level_overlay_blink_delay)
			overlays += z_level_overlay


/obj/item/modular_computer/tablet/moebius/proc/pinpoint()
	is_tracking = TRUE

	if(!enabled)
		direction_overlay_reset()
		return

	if(!target_mob)
		direction_overlay_reset()
		return

	if(!hassensorlevel(target_mob, SUIT_SENSOR_TRACKING))
		direction_overlay_reset()
		return

	var/new_dir
	var/new_state

	if(get_dist(src, target_mob) == 0)
		direction_overlay.icon_state = "point"
		new_dir = set_dir(SOUTH)
	else
		direction_overlay.icon_state = "arrow"
		new_dir = set_dir(get_dir(src, target_mob))

	if(direction_overlay.dir != new_dir)
		direction_overlay.dir = new_dir
		direction_overlay_blink_delay = 4
	else
		direction_overlay_blink_delay = 0

	if(target_mob.z < loc.z)
		new_state = "z_down"
	else if(target_mob.z > loc.z)
		new_state = "z_up"
	else
		new_state = "z_same"

	if(z_level_overlay.icon_state != new_state)
		z_level_overlay.icon_state = new_state
		z_level_overlay_blink_delay = 4
	else
		z_level_overlay_blink_delay = 0

	update_icon()
	spawn(12)
	.()

/obj/item/modular_computer/tablet/moebius/proc/direction_overlay_reset()
	direction_overlay.icon_state = "point"
	z_level_overlay.icon_state = "z_same"
	is_tracking = FALSE
