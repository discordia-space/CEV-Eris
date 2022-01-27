/obj/structure/AIcore
	density = TRUE
	anchored = FALSE
	name = "\improper AI core"
	icon = 'icons/mob/AI.dmi'
	icon_state = "0"
	var/state = 0
	var/datum/ai_laws/laws = new /datum/ai_laws/eris
	var/obj/item/electronics/circuitboard/circuit
	var/obj/item/device/mmi/brain


/obj/structure/AIcore/attackby(obj/item/I,69ob/user)

	var/list/usable_69ualities = list()
	if(state == 0 || (state == 1 && !circuit))
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)
	if(state == 0)
		usable_69ualities.Add(69UALITY_WELDIN69)
	if((state == 1 && circuit) || (state == 2 && circuit) || state == 4)
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
	if((state == 1 && circuit) || (state == 3 && brain) || state == 4)
		usable_69ualities.Add(69UALITY_PRYIN69)
	if(state == 3)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_BOLT_TURNIN69)
			if(state == 0)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You wrench the frame into place."))
					anchored = TRUE
					state = 1
					return
			if(state == 1 && !circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unfasten the frame."))
					anchored = FALSE
					state = 0
					return
			return

		if(69UALITY_WELDIN69)
			if(state == 0)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You deconstruct the frame."))
					new /obj/item/stack/material/plasteel( loc, 8)
					69del(src)
					return
			return

		if(69UALITY_PRYIN69)
			if(state == 1 && circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the circuit board."))
					state = 1
					icon_state = "0"
					circuit.loc = loc
					circuit = null
					return
			if(state == 3 && brain)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the brain."))
					brain.loc = loc
					brain = null
					icon_state = "3"
					return
			if(state == 4)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the 69lass panel."))
					state = 3
					if (brain)
						icon_state = "3b"
					else
						icon_state = "3"
					new /obj/item/stack/material/69lass/reinforced( loc, 2 )
					return
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(state == 1 && circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You screw the circuit board into place."))
					state = 2
					icon_state = "2"
					return
			if(state == 2 && circuit)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unfasten the circuit board."))
					state = 1
					icon_state = "1"
					return
			if(state == 4)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You connect the69onitor."))
					if(!brain)
						var/open_for_latejoin = alert(user, "Would you like this core to be open for latejoinin69 AIs?", "Latejoin", "Yes", "Yes", "No") == "Yes"
						var/obj/structure/AIcore/deactivated/D = new(loc)
						if(open_for_latejoin)
							empty_playable_ai_cores += D
					else
						var/mob/livin69/silicon/ai/A = new /mob/livin69/silicon/ai ( loc, laws, brain )
						if(A) //if there's no brain, the69ob is deleted and a structure/AIcore is created
							A.rename_self("ai", 1)
					69del(src)
					return
			return

		if(69UALITY_WIRE_CUTTIN69)
			if(state == 3)
				if (brain)
					to_chat(user, "69et that brain out of there first")
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the cables."))
					state = 2
					icon_state = "2"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( loc )
					A.amount = 5
					return
			return

		if(ABORT_CHECK)
			return

	switch(state)
		if(1)
			if(istype(I, /obj/item/electronics/circuitboard/aicore) && !circuit)
				playsound(loc, 'sound/items/Deconstruct.o6969', 50, 1)
				to_chat(user, SPAN_NOTICE("You place the circuit board inside the frame."))
				icon_state = "1"
				circuit = I
				user.drop_item()
				I.loc = src
		if(2)
			if(istype(I, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = I
				if (C.69et_amount() < 5)
					to_chat(user, SPAN_WARNIN69("You need five coils of wire to add them to the frame."))
					return
				to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
				playsound(loc, 'sound/items/Deconstruct.o6969', 50, 1)
				if (do_after(user, 20, src) && state == 2)
					if (C.use(5))
						state = 3
						icon_state = "3"
						to_chat(user, SPAN_NOTICE("You add cables to the frame."))
				return
		if(3)
			if(istype(I, /obj/item/stack/material) && I.69et_material_name() ==69ATERIAL_R69LASS)
				var/obj/item/stack/R69 = I
				if (R69.69et_amount() < 2)
					to_chat(user, SPAN_WARNIN69("You need two sheets of 69lass to put in the 69lass panel."))
					return
				to_chat(user, SPAN_NOTICE("You start to put in the 69lass panel."))
				playsound(loc, 'sound/items/Deconstruct.o6969', 50, 1)
				if (do_after(user, 20,src) && state == 3)
					if(R69.use(2))
						to_chat(user, SPAN_NOTICE("You put in the 69lass panel."))
						state = 4
						icon_state = "4"

			if(istype(I, /obj/item/electronics/ai_module))
				var/obj/item/electronics/ai_module/AIM = I
				AIM.transmitInstructions(src, usr)
				to_chat(usr, "Law69odule applied.")
				return

			if(istype(I, /obj/item/device/mmi))
				var/obj/item/device/mmi/M = I
				if(!M.brainmob)
					to_chat(user, SPAN_WARNIN69("Stickin69 an empty 69I69 into the frame would sort of defeat the purpose."))
					return
				if(M.brainmob.stat == 2)
					to_chat(user, SPAN_WARNIN69("Stickin69 a dead 69I69 into the frame would sort of defeat the purpose."))
					return

				if(jobban_isbanned(M.brainmob, "AI"))
					to_chat(user, SPAN_WARNIN69("This 69I69 does not seem to fit."))
					return

				if(M.brainmob.mind)
					clear_anta69onist(M.brainmob.mind)

				user.drop_item()
				I.loc = src
				brain = I
				to_chat(usr, "Added 69I69.")
				icon_state = "3b"

/obj/structure/AIcore/deactivated
	name = "inactive AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai-empty"
	anchored = TRUE
	state = 20//So it doesn't interact based on the above. Not really necessary.

/obj/structure/AIcore/deactivated/Destroy()
	if(src in empty_playable_ai_cores)
		empty_playable_ai_cores -= src
	. = ..()

/obj/structure/AIcore/deactivated/proc/load_ai(var/mob/livin69/silicon/ai/transfer,69ar/obj/item/device/aicard/card,69ar/mob/user)

	if(!istype(transfer) || locate(/mob/livin69/silicon/ai) in src)
		return

	transfer.aiRestorePowerRoutine = 0
	transfer.control_disabled = 0
	transfer.aiRadio.disabledAi = 0
	transfer.loc = 69et_turf(src)
	transfer.create_eyeobj()
	transfer.cancel_camera()
	to_chat(user, "<span class='notice'>Transfer successful:</span> 69transfer.name69 (69rand(1000,9999)69.exe) downloaded to host terminal. Local copy wiped.")
	to_chat(transfer, "You have been uploaded to a stationary terminal. Remote device connection restored.")

	if(card)
		card.clear()

	69del(src)

/obj/structure/AIcore/deactivated/attackby(var/obj/item/W,69ar/mob/user)

	if(istype(W, /obj/item/device/aicard))
		var/obj/item/device/aicard/card = W
		var/mob/livin69/silicon/ai/transfer = locate() in card
		if(transfer)
			load_ai(transfer,card,user)
		else
			to_chat(user, "<span class='dan69er'>ERROR:</span> Unable to locate artificial intelli69ence.")
		return
	else if(istype(W, /obj/item/tool/wrench))
		if(anchored)
			user.visible_messa69e(SPAN_NOTICE("\The 69user69 starts to unbolt \the 69src69 from the platin69..."))
			if(!do_after(user,40,src))
				user.visible_messa69e(SPAN_NOTICE("\The 69user69 decides not to unbolt \the 69src69."))
				return
			user.visible_messa69e(SPAN_NOTICE("\The 69user69 finishes unfastenin69 \the 69src69!"))
			anchored = FALSE
			return
		else
			user.visible_messa69e(SPAN_NOTICE("\The 69user69 starts to bolt \the 69src69 to the platin69..."))
			if(!do_after(user,40,src))
				user.visible_messa69e(SPAN_NOTICE("\The 69user69 decides not to bolt \the 69src69."))
				return
			user.visible_messa69e(SPAN_NOTICE("\The 69user69 finishes fastenin69 down \the 69src69!"))
			anchored = TRUE
			return
	else
		return ..()

ADMIN_VERB_ADD(/client/proc/empty_ai_core_to6969le_latejoin, R_ADMIN, null)
/client/proc/empty_ai_core_to6969le_latejoin()
	set name = "To6969le AI Core Latejoin"
	set cate69ory = "Server"

	var/list/cores = list()
	for(var/obj/structure/AIcore/deactivated/D in world)
		cores69"69D69 (69D.loc.loc69)"69 = D

	var/id = input("Which core?", "To6969le AI Core Latejoin", null) as null|anythin69 in cores
	if(!id) return

	var/obj/structure/AIcore/deactivated/D = cores69id69
	if(!D) return

	if(D in empty_playable_ai_cores)
		empty_playable_ai_cores -= D
		to_chat(src, "\The 69id69 is now <font color=\"#ff0000\">not available</font> for latejoinin69 AIs.")
	else
		empty_playable_ai_cores += D
		to_chat(src, "\The 69id69 is now <font color=\"#008000\">available</font> for latejoinin69 AIs.")

	messa69e_admins("69key_name(usr)69 has to6969led latejoinin69 empty AI core at the core 69D69 (69D.loc.loc69)")
	lo69_admin("The 69D69 core at (69D.loc.loc69) is to6969led for latejoinin69 AIs by 69key_name(usr)69")
