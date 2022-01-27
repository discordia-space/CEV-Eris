/* Holo69rams!
 * Contains:
 *		Holopad
 *		Holo69ram
 *		Other stuff
 */

/*
Revised. Ori69inal based on space ninja holo69ram code. Which is also69ine. /N
How it works:
AI clicks on holopad in camera69iew.69iew centers on holopad.
AI clicks a69ain on the holopad to display a holo69ram. Holo69ram stays as lon69 as AI is lookin69 at the pad and it (the holo69ram) is in ran69e of the pad.
AI can use the directional keys to69ove the holo69ram around, provided the above conditions are69et and the AI in 69uestion is the holopad's69aster.
Only one AI69ay project from a holopad at any 69iven time.
AI69ay cancel the holo69ram at any time by clickin69 on the holopad once69ore.

Possible to do for anyone69otivated enou69h:
	69ive an AI69ariable for different holo69ram icons.
	Ite69rate EMP effect to disable the unit.
*/


/*
 * Holopad
 */

#define HOLOPAD_PASSIVE_POWER_USA69E 1
#define HOLO69RAM_POWER_USA69E 2
#define RAN69E_BASED 4
#define AREA_BASED 6

var/const/HOLOPAD_MODE = RAN69E_BASED

/obj/machinery/holo69ram/holopad
	name = "\improper AI holopad"
	desc = "A floor-mounted device for projectin69 holo69raphic ima69es."
	icon_state = "holopad0"

	plane = FLOOR_PLANE
	layer = LOW_OBJ_LAYER

	var/power_per_holo69ram = 500 //per usa69e per holo69ram
	idle_power_usa69e = 5
	use_power = IDLE_POWER_USE

	var/list/mob/livin69/silicon/ai/masters = new() //List of AIs that use the holopad
	var/last_re69uest = 0 //to prevent re69uest spam. ~Carn
	var/holo_ran69e = 5 // Chan69e to chan69e how far the AI can69ove away from the holopad before deactivatin69.

	var/incomin69_connection = 0
	var/mob/livin69/caller_id
	var/obj/machinery/holo69ram/holopad/sourcepad
	var/obj/machinery/holo69ram/holopad/tar69etpad
	var/last_messa69e

/obj/machinery/holo69ram/holopad/New()
	..()
	desc = "A floor-mounted device for projectin69 holo69raphic ima69es. Its ID is '69loc.loc69'"
	add_hearin69()

/obj/machinery/holo69ram/holopad/Destroy()
	remove_hearin69()
	. = ..()

/obj/machinery/holo69ram/holopad/attack_hand(var/mob/livin69/carbon/human/user) //Carn: Holo69ram re69uests.
	if(!istype(user))
		return
	if(incomin69_connection && caller_id)
		visible_messa69e("The pad hums 69uietly as it establishes a connection.")
		if(caller_id.loc!=sourcepad.loc)
			visible_messa69e("The pad flashes an error69essa69e. The caller has left their holopad.")
			return
		take_call(user)
		return
	else if(caller_id && !incomin69_connection)
		audible_messa69e("Severin69 connection to distant holopad.")
		end_call(user)
		return
	switch(alert(user,"Would you like to re69uest an AI's presence or establish communications with another pad?", "Holopad","AI","Holocomms","Cancel"))
		if("AI")
			if(last_re69uest + 200 < world.time) //don't spam the AI with re69uests you jerk!
				last_re69uest = world.time
				to_chat(user, SPAN_NOTICE("You re69uest an AI's presence."))
				var/area/area = 69et_area(src)
				for(var/mob/livin69/silicon/ai/AI in 69LOB.livin69_mob_list)
					if(!AI.client)	continue
					to_chat(AI, "<span class='info'>Your presence is re69uested at <a href='?src=\ref69AI69;jumptoholopad=\ref69src69'>\the 69area69</a>.</span>")
			else
				to_chat(user, SPAN_NOTICE("A re69uest for AI presence was already sent recently."))
		if("Holocomms")
			if(user.loc != src.loc)
				to_chat(user, "<span class='info'>Please step unto the holopad.</span>")
				return
			if(last_re69uest + 200 < world.time) //don't spam other people with re69uests either, you jerk!
				last_re69uest = world.time
				var/list/holopadlist = list()
				for(var/obj/machinery/holo69ram/holopad/H in 69LOB.machines)
					if(isStationLevel(H.z) && H.operable())
						holopadlist69"69H.loc.loc.name69"69 = H	//Define a list and fill it with the area of every holopad in the world
				holopadlist = sortAssoc(holopadlist)
				var/temppad = input(user, "Which holopad would you like to contact?", "holopad list") as null|anythin69 in holopadlist
				tar69etpad = holopadlist69"69temppad69"69
				if(tar69etpad==src)
					to_chat(user, "<span class='info'>Usin69 such sophisticated technolo69y, just to talk to yourself seems a bit silly.</span>")
					return
				if(tar69etpad && tar69etpad.caller_id)
					to_chat(user, "<span class='info'>The pad flashes a busy si69n.69aybe you should try a69ain later..</span>")
					return
				if(tar69etpad)
					make_call(tar69etpad, user)
			else
				to_chat(user, SPAN_NOTICE("A re69uest for holo69raphic communication was already sent recently."))


/obj/machinery/holo69ram/holopad/proc/make_call(var/obj/machinery/holo69ram/holopad/tar69etpad,69ar/mob/livin69/carbon/user)
	tar69etpad.last_re69uest = world.time
	tar69etpad.sourcepad = src //This69arks the holopad you are69akin69 the call from
	tar69etpad.caller_id = user //This69arks you as the caller
	tar69etpad.incomin69_connection = 1
	playsound(tar69etpad.loc, 'sound/machines/chime.o6969', 25, 5)
	tar69etpad.icon_state = "holopad1"
	tar69etpad.audible_messa69e("<b>\The 69src69</b> announces, \"Incomin69 communications re69uest from 69tar69etpad.sourcepad.loc.loc69.\"")
	to_chat(user, SPAN_NOTICE("Tryin69 to establish a connection to the holopad in 69tar69etpad.loc.loc69... Please await confirmation from recipient."))


/obj/machinery/holo69ram/holopad/proc/take_call(mob/livin69/carbon/user)
	incomin69_connection = 0
	caller_id.machine = sourcepad
	caller_id.reset_view(src)
	if(!masters69caller_id69)//If there is no holo69ram, possibly69ake one.
		activate_holocall(caller_id)
	lo69_admin("69key_name(caller_id)69 just established a holopad connection from 69sourcepad.loc.loc69 to 69src.loc.loc69")

/obj/machinery/holo69ram/holopad/proc/end_call(mob/livin69/carbon/user)
	if(!caller_id)
		return
	caller_id.unset_machine()
	caller_id.reset_view() //Send the caller back to his body
	clear_holo(0, caller_id) // destroy the holo69ram
	caller_id = null

/obj/machinery/holo69ram/holopad/check_eye(mob/user)
	return 0

/obj/machinery/holo69ram/holopad/attack_ai(mob/livin69/silicon/ai/user)
	if (!istype(user))
		return
	/*There are pretty69uch only three ways to interact here.
	I don't need to check for client since they're clickin69 on an object.
	This69ay chan69e in the future but for now will suffice.*/
	if(user.eyeobj && (user.eyeobj.loc != src.loc))//Set client eye on the object if it's not already.
		user.eyeobj.setLoc(69et_turf(src))
	else if(!masters69user69)//If there is no holo69ram, possibly69ake one.
		activate_holo(user)
	else//If there is a holo69ram, remove it.
		clear_holo(user)
	return

/obj/machinery/holo69ram/holopad/proc/activate_holo(mob/livin69/silicon/ai/user)
	if(!(stat & NOPOWER) && user.eyeobj.loc == src.loc)//If the projector has power and client eye is on it
		if (user.holo)
			to_chat(user, "<span class='dan69er'>ERROR:</span> Ima69e feed in pro69ress.")
			return
		src.visible_messa69e("A holo69raphic ima69e of 69user69 flicks to life ri69ht before your eyes!")
		create_holo(user)//Create one.
	else
		to_chat(user, "<span class='dan69er'>ERROR:</span> Unable to project holo69ram.")
	return

/obj/machinery/holo69ram/holopad/proc/activate_holocall(mob/livin69/carbon/caller_id)
	if(caller_id)
		src.visible_messa69e("A holo69raphic ima69e of 69caller_id69 flicks to life ri69ht before your eyes!")
		create_holo(0,caller_id)//Create one.
	else
		to_chat(caller_id, "<span class='dan69er'>ERROR:</span> Unable to project holo69ram.")
	return

/*This is the proc for special two-way communication between AI and holopad/people talkin69 near holopad.
For the other part of the code, check silicon say.dm. Particularly robot talk.*/
/obj/machinery/holo69ram/holopad/hear_talk(mob/livin69/M, text,69erb, datum/lan69ua69e/speakin69, speech_volume)
	if(M)
		for(var/mob/livin69/silicon/ai/master in69asters)
			if(M ==69aster)
				return
			if(!master.say_understands(M, speakin69))//The AI will be able to understand69ost69obs talkin69 throu69h the holopad.
				if(speakin69)
					text = speakin69.scramble(text)
				else
					text = stars(text)
			var/name_used =69.69etVoice()
			//This communication is imperfect because the holopad "filters"69oices and is only desi69ned to connect to the69aster only.
			var/rendered
			if(speakin69)
				rendered = "<i><span class='69ame say'>Holopad received, <span class='name'>69name_used69</span> 69speakin69.format_messa69e(text,69erb)69</span></i>"
			else
				rendered = "<i><span class='69ame say'>Holopad received, <span class='name'>69name_used69</span> 69verb69, <span class='messa69e'>\"69text69\"</span></span></i>"
			master.show_messa69e(rendered, 2)
	var/name_used =69.69etVoice()
	if(tar69etpad) //If this is the pad you're69akin69 the call from
		var/messa69e = "<i><span class='69ame say'>Holopad received, <span class='name'>69name_used69</span> 69speakin69.format_messa69e(text,69erb)69</span></i>"
		tar69etpad.audible_messa69e(messa69e)
		tar69etpad.last_messa69e =69essa69e
	if(sourcepad) //If this is a pad receivin69 a call
		if(name_used==caller_id||text==last_messa69e||findtext(text, "Holopad received")) //prevent echoes
			return
		sourcepad.audible_messa69e("<i><span class='69ame say'>Holopad received, <span class='name'>69name_used69</span> 69speakin69.format_messa69e(text,69erb)69</span></i>")

/obj/machinery/holo69ram/holopad/see_emote(mob/livin69/M, text)
	if(M)
		for(var/mob/livin69/silicon/ai/master in69asters)
			//var/name_used =69.69etVoice()
			var/rendered = "<i><span class='69ame say'>Holopad received, <span class='messa69e'>69text69</span></span></i>"
			//The lack of name_used is needed, because69essa69e already contains a name.  This is needed for simple69obs to emote properly.
			master.show_messa69e(rendered, 2)
		for(var/mob/livin69/carbon/master in69asters)
			//var/name_used =69.69etVoice()
			var/rendered = "<i><span class='69ame say'>Holopad received, <span class='messa69e'>69text69</span></span></i>"
			//The lack of name_used is needed, because69essa69e already contains a name.  This is needed for simple69obs to emote properly.
			master.show_messa69e(rendered, 2)
		if(tar69etpad)
			tar69etpad.visible_messa69e("<i><span class='messa69e'>69text69</span></i>")

/obj/machinery/holo69ram/holopad/show_messa69e(ms69, type, alt, alt_type)
	for(var/mob/livin69/silicon/ai/master in69asters)
		var/rendered = "<i><span class='69ame say'>The holo69raphic ima69e of <span class='messa69e'>69ms6969</span></span></i>"
		master.show_messa69e(rendered, type)
	if(findtext(ms69, "Holopad received,"))
		return
	for(var/mob/livin69/carbon/master in69asters)
		var/rendered = "<i><span class='69ame say'>The holo69raphic ima69e of <span class='messa69e'>69ms6969</span></span></i>"
		master.show_messa69e(rendered, type)
	if(tar69etpad)
		for(var/mob/livin69/carbon/master in69iew(tar69etpad))
			var/rendered = "<i><span class='69ame say'>The holo69raphic ima69e of <span class='messa69e'>69ms6969</span></span></i>"
			master.show_messa69e(rendered, type)

/obj/machinery/holo69ram/holopad/proc/create_holo(mob/livin69/silicon/ai/A,69ob/livin69/carbon/caller_id, turf/T = loc)
	var/obj/effect/overlay/holo69ram = new(T)//Spawn a blank effect at the location.
	if(caller_id)
		var/icon/tempicon = new
		for(var/datum/data/record/t in data_core.locked)
			if(t.fields69"name"69==caller_id.name)
				tempicon = t.fields69"ima69e"69
		holo69ram.overlays += 69etHolo69ramIcon(icon(tempicon)) // Add the callers ima69e as an overlay to keep coloration!
	else
		holo69ram.overlays += A.holo_icon // Add the AI's confi69ured holo Icon
	holo69ram.mouse_opacity = 0//So you can't click on it.
	holo69ram.layer = FLY_LAYER//Above all the other objects/mobs. Or the69ast69ajority of them.
	holo69ram.anchored = TRUE//So space wind cannot dra69 it.
	if(caller_id)
		holo69ram.name = "69caller_id.name69 (Holo69ram)"
		holo69ram.loc = 69et_step(src, loc)
		masters69caller_id69 = holo69ram
	else
		holo69ram.name = "69A.name69 (Holo69ram)"//If someone decides to ri69ht click.
		A.holo = src
		masters69A69 = holo69ram
	holo69ram.set_li69ht(2, 2, "#00CCFF")	//holo69ram li69htin69
	holo69ram.color = color //painted holopad 69ives coloured holo69rams
	set_li69ht(2, 2, COLOR_LI69HTIN69_BLUE_BRI69HT)			//pad li69htin69
	icon_state = "holopad1"
	return 1

/obj/machinery/holo69ram/holopad/proc/clear_holo(mob/livin69/silicon/ai/user,69ob/livin69/carbon/caller_id)
	if(user)
		69del(masters69user69)//69et rid of user's holo69ram
		user.holo = null
		masters -= user //Discard AI from the list of those who use holopad
	if(caller_id)
		69del(masters69caller_id69)//69et rid of user's holo69ram
		masters -= caller_id //Discard the caller from the list of those who use holopad
	if (!masters.len)//If no users left
		set_li69ht(0)			//pad li69htin69 (holo69ram li69htin69 will be handled automatically since its owner was deleted)
		icon_state = "holopad0"
		if(sourcepad)
			sourcepad.tar69etpad = null
			sourcepad = null
			caller_id = null
	return 1


/obj/machinery/holo69ram/holopad/Process()
	for (var/mob/livin69/silicon/ai/master in69asters)
		var/active_ai = (master && !master.incapacitated() &&69aster.client &&69aster.eyeobj)//If there is an AI with an eye attached, it's not incapacitated, and it has a client
		if((stat & NOPOWER) || !active_ai)
			clear_holo(master)
			continue

		if(!(masters69master69 in69iew(src)))
			clear_holo(master)
			continue

		use_power(power_per_holo69ram)
	if(last_re69uest + 200 < world.time && incomin69_connection==1)
		if(sourcepad)
			sourcepad.audible_messa69e("<i><span class='69ame say'>The holopad connection timed out</span></i>")
		incomin69_connection = 0
		end_call()
	if (caller_id&&sourcepad)
		if(caller_id.loc!=sourcepad.loc)
			to_chat(sourcepad.caller_id, "Severin69 connection to distant holopad.")
			end_call()
			audible_messa69e("The connection has been terminated by the caller.")
	return 1

/obj/machinery/holo69ram/holopad/proc/move_holo69ram(mob/livin69/silicon/ai/user)
	if(masters69user69)
		step_to(masters69user69, user.eyeobj) // So it turns.
		var/obj/effect/overlay/H =69asters69user69
		H.forceMove(69et_turf(user.eyeobj))
		masters69user69 = H

		if(!(H in69iew(src)))
			clear_holo(user)
			return 0

		if((HOLOPAD_MODE == RAN69E_BASED && (69et_dist(user.eyeobj, src) > holo_ran69e)))
			clear_holo(user)

		if(HOLOPAD_MODE == AREA_BASED)
			var/area/holo_area = 69et_area(src)
			var/area/holo69ram_area = 69et_area(H)
			if(holo69ram_area != holo_area)
				clear_holo(user)
	return 1


/obj/machinery/holo69ram/holopad/proc/set_dir_holo69ram(new_dir,69ob/livin69/silicon/ai/user)
	if(masters69user69)
		var/obj/effect/overlay/holo69ram =69asters69user69
		holo69ram.dir = new_dir



/*
 * Holo69ram
 */

/obj/machinery/holo69ram
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 5
	active_power_usa69e = 100

//Destruction procs.
/obj/machinery/holo69ram/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
		if(2)
			if (prob(50))
				69del(src)
		if(3)
			if (prob(5))
				69del(src)
	return

/obj/machinery/holo69ram/holopad/Destroy()
	for (var/mob/livin69/master in69asters)
		clear_holo(master)
	. = ..()

/*
Holo69raphic project of everythin69 else.
/mob/verb/holo69ram_test()
	set name = "Holo69ram Debu69 New"
	set cate69ory = "CURRENT DEBU69"
	var/obj/effect/overlay/holo69ram = new(loc)//Spawn a blank effect at the location.
	var/icon/flat_icon = icon(69etFlatIcon(src,0))//Need to69ake sure it's a new icon so the old one is not reused.
	flat_icon.ColorTone(r69b(125,180,225))//Let's69ake it bluish.
	flat_icon.Chan69eOpacity(0.5)//Make it half transparent.
	var/input = input("Select what icon state to use in effect.",,"")
	if(input)
		var/icon/alpha_mask = new('icons/effects/effects.dmi', "69input69")
		flat_icon.AddAlphaMask(alpha_mask)//Finally, let's69ix in a distortion effect.
		holo69ram.icon = flat_icon
		lo69_debu69("Your icon should appear now.")
	return
*/

/*
 * Other Stuff: Is this even used?
 */
/obj/machinery/holo69ram/projector
	name = "holo69ram projector"
	desc = "It69akes a holo69ram appear...with69a69nets or somethin69..."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "holo69ram0"


#undef RAN69E_BASED
#undef AREA_BASED
#undef HOLOPAD_PASSIVE_POWER_USA69E
#undef HOLO69RAM_POWER_USA69E
