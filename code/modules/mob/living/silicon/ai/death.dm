/mob/living/silicon/ai/death(gibbed)

	if(stat == DEAD)
		return

	if(src.eyeobj)
		src.eyeobj.setLoc(get_turf(src))

	remove_ai_verbs(src)

	stop_malf(0) // Remove AI's malfunction status, that will fix all hacked APCs, etc.

	for(var/obj/machinery/ai_status_display/O in world)
		O.mode = 2

	if (istype(loc, /obj/item/device/aicard))
		var/obj/item/device/aicard/card = loc
		card.update_icon()

	for (var/mob/living/silicon/robot/R in connected_robots)
		to_chat(R, "<span class='notice'>You lost signal from your master [src.name].</span>")
		
	. = ..(gibbed,"gives one shrill beep before falling lifeless.")
	density = 1
