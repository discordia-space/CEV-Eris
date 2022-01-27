/mob/living/silicon/ai/death(gibbed)

	if(stat == DEAD)
		return

	pull_to_core()  // Pull back69ind to core if it is controlling a drone

	if(eyeobj)
		eyeobj.setLoc(get_turf(src))

	remove_ai_verbs(src)

	stop_malf(0) // Remove AI's69alfunction status, that will fix all hacked APCs, etc.

	for(var/obj/machinery/ai_status_display/O in world)
		O.mode = 2

	if (istype(loc, /obj/item/device/aicard))
		var/obj/item/device/aicard/card = loc
		card.update_icon()

	for (var/mob/living/silicon/robot/R in connected_robots)
		to_chat(R, "<span class='notice'>You lost signal from your69aster 69src.name69.</span>")
		
	. = ..(gibbed,"gives one shrill beep before falling lifeless.")
	density = TRUE
