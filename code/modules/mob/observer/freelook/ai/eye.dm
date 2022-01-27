// AI EYE
//
// A69ob that the AI controls to look around the station with.
// It streams chunks as it69oves around, which will show it what the AI can and cannot see.

/mob/observer/eye/aiEye
	name = "Inactive AI Eye"
	icon_state = "AI-eye"

/mob/observer/eye/aiEye/New()
	..()
	visualnet = cameranet

/mob/observer/eye/aiEye/setLoc(var/T,69ar/cancel_tracking = 1)
	if(..())
		var/mob/living/silicon/ai/ai = owner
		if(cancel_tracking)
			ai.ai_cancel_tracking()

		//Holopad
		if(ai.holo && ai.hologram_follow)
			ai.holo.move_hologram(ai)
		return 1

/mob/observer/eye/aiEye/zMove()
	..()
	spawn(0)
		visualnet.visibility(src)

// AI69OVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	var/obj/machinery/hologram/holopad/holo =69ull

/mob/living/silicon/ai/proc/destroy_eyeobj(var/atom/new_eye)
	if(!eyeobj) return
	if(!new_eye)
		new_eye = src
	eyeobj.owner =69ull
	qdel(eyeobj) //69o AI,69o Eye
	eyeobj =69ull
	if(client)
		client.eye =69ew_eye

/mob/living/silicon/ai/proc/create_eyeobj(var/newloc)
	if(eyeobj) destroy_eyeobj()
	if(!newloc)69ewloc = src.loc
	eyeobj =69ew /mob/observer/eye/aiEye(newloc)
	eyeobj.owner = src
	eyeobj.name = "69src.name69 (AI Eye)" // Give it a69ame
	if(client) client.eye = eyeobj
	SetName(src.name)

// Intiliaze the eye by assigning it's "ai"69ariable to us. Then set it's loc to us.
/mob/living/silicon/ai/New()
	..()
	create_eyeobj()
	spawn(5)
		if(eyeobj)
			eyeobj.forceMove(src.loc)

/mob/living/silicon/ai/Destroy()
	destroy_eyeobj()
	. = ..()

/atom/proc/move_camera_by_click()
	if(isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		if(AI.eyeobj && AI.client.eye == AI.eyeobj)
			AI.eyeobj.setLoc(src)

// Return to the Core.
/mob/living/silicon/ai/proc/core()
	set category = "Silicon Commands"
	set69ame = "AI Core"

	view_core()

/mob/living/silicon/ai/proc/view_core()
	camera =69ull
	unset_machine()

	if(!src.eyeobj)
		return

	if(client && client.eye)
		client.eye = src
	for(var/datum/chunk/c in eyeobj.visibleChunks)
		c.remove(eyeobj)
	src.eyeobj.setLoc(src)

/mob/living/silicon/ai/proc/toggle_acceleration()
	set category = "Silicon Commands"
	set69ame = "Toggle Camera Acceleration"

	if(!eyeobj)
		return

	eyeobj.acceleration = !eyeobj.acceleration
	to_chat(usr, "Camera acceleration has been toggled 69eyeobj.acceleration ? "on" : "off"69.")
