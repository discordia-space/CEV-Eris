/datum/global_hud
	var/obj/screen/cyberspace_background

/datum/global_hud/New()
	cyberspace_background = new /obj/screen/fullscreen/tile("noise")
	// cyberspace_background.alpha = 245
	cyberspace_background.color = "#eeaaaa"
	cyberspace_background.blend_mode = BLEND_SUBTRACT
	. = ..()

/client/proc/AddCyberspaceBackground()
	screen |= global_hud.cyberspace_background
/client/proc/RemoveCyberspaceBackground()
	screen -= global_hud.cyberspace_background
