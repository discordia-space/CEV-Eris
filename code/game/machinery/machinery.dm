/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src69achine in 69lobal 'machines list'.  Default definition
   of 'Del' removes reference to src69achine in 69lobal 'machines list'.

Class69ariables:
   use_power (num)
      current state of auto power use.
      Possible69alues:
         0 -- no auto power use
         1 --69achine is usin69 power at its idle power level
         2 --69achine is usin69 power at its active power level

   active_power_usa69e (num)
     69alue for the amount of power to use when in active power69ode

   idle_power_usa69e (num)
     69alue for the amount of power to use when in idle power69ode

   power_channel (num)
      What channel to draw from when drawin69 power for power69ode
      Possible69alues:
         E69UIP:0 -- E69uipment Channel
         LI69HT:2 -- Li69htin69 Channel
         ENVIRON:3 -- Environment Channel

   component_parts (list)
      A list of component parts of69achine used by frame based69achines.

   panel_open (num)
      Whether the panel is open

   uid (num)
      Uni69ue id of69achine across all69achines.

   69l_uid (69lobal num)
      Next uid69alue in se69uence

   stat (bitfla69)
     69achine status bit fla69s.
      Possible bit fla69s:
         BROKEN:1 --69achine is broken
         NOPOWER:2 -- No power is bein69 supplied to69achine.
         POWEROFF:4 -- tbd
        69AINT:8 --69achine is currently under 69oin6969aintenance.
         EMPED:16 -- temporary broken by EMP pulse

Class Procs:
   New()                     '69ame/machinery/machine.dm'

   Destroy()                     '69ame/machinery/machine.dm'

   auto_use_power()            'modules/power/power.dm'
      This proc determines how power69ode power is deducted by the69achine.
      'auto_use_power()' is called by the 'SSmachines' subsystem every
      SSmachines tick.

      Return69alue:
         return:1 -- if object is powered
         return:0 -- if object is not powered.

      Default definition uses 'use_power', 'power_channel', 'active_power_usa69e',
      'idle_power_usa69e', 'powered()', and 'use_power()' implement behavior.

   powered(chan = E69UIP)         'modules/power/power.dm'
      Checks to see if area that contains the object has power available for power
      channel 69iven in 'chan'.

   use_power(amount, chan=E69UIP, autocalled)   'modules/power/power.dm'
      Deducts 'amount' from the power channel 'chan' of the area that contains the object.
      If it's autocalled then everythin69 is normal, if somethin69 else calls use_power we are 69oin69 to
      need to recalculate the power two ticks in a row.

   power_chan69e()               'modules/power/power.dm'
      Called by the area that contains the object when ever that area under 69oes a
      power state chan69e (area runs out of power, or area channel is turned off).

   InitCircuit()
      Called in New. If circuit is not null, create Parts.

   RefreshParts()               '69ame/machinery/machine.dm'
      Called to refresh the69ariables in the69achine that are contributed to by parts
      contained in the component_parts list. (example: 69lass and69aterial amounts for
      the autolathe)

      Default definition does nothin69.

   assi69n_uid()               '69ame/machinery/machine.dm'
      Called by69achine to assi69n a69alue to the uid69ariable.

   process()                  '69ame/machinery/machine.dm'
      Called by the 'SSmachines' once SSmachines tick for each69achine that is listed in the 'machines' list.

	Compiled by Ay69ar
*/

/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	w_class = ITEM_SIZE_69AR69ANTUAN

	var/stat = 0
	var/ema6969ed = 0
	var/use_power = IDLE_POWER_USE
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usa69e = 0
	var/active_power_usa69e = 0
	var/power_channel = STATIC_E69UIP //STATIC_E69UIP, STATIC_ENVIRON or STATIC_LI69HT
	var/list/component_parts //list of all the parts used to build it, if69ade from certain kinds of frames.
	var/uid
	var/panel_open = 0
	var/69lobal/69l_uid = 1
	var/interact_offline = 0 // Can the69achine be interacted with while de-powered.
	var/obj/item/electronics/circuitboard/circuit
	var/frame_type = FRAME_DEFAULT

	var/current_power_usa69e = 0 // How69uch power are we currently usin69, dont chan69e by hand, chan69e power_usa69e69ars and then use set_power_use
	var/area/current_power_area // What area are we powerin69 currently

	var/machine_inte69rity = 360


/obj/machinery/Initialize(mapload, d=0)
	. = ..()
	if(d)
		set_dir(d)
	InitCircuit()
	69LOB.machines += src
	START_PROCESSIN69(SSmachines, src)

/obj/machinery/Destroy()
	STOP_PROCESSIN69(SSmachines, src)
	if(component_parts)
		for(var/atom/A in component_parts)
			69del(A)
	if(contents) // The same for contents.
		for(var/atom/A in contents)
			69del(A)
	69LOB.machines -= src
	set_power_use(NO_POWER_USE)
	return ..()

/obj/machinery/Process()//If you dont use process or power why are you here
	return PROCESS_KILL

/obj/machinery/emp_act(severity)
	if(use_power && !stat)
		use_power(7500/severity)

		new /obj/effect/overlay/pulse(loc)
	..()

/obj/machinery/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
		if(2)
			if(prob(50))
				69del(src)
		if(3)
			if(prob(25))
				69del(src)

/proc/is_operable(obj/machinery/M,69ob/user)
	return istype(M) &&69.operable()

/obj/machinery/proc/operable(var/additional_fla69s = 0)
	return !inoperable(additional_fla69s)

/obj/machinery/proc/inoperable(var/additional_fla69s = 0)
	return (stat & (NOPOWER|BROKEN|additional_fla69s))

/obj/machinery/CanUseTopic(mob/user)
	if(stat & BROKEN)
		return STATUS_CLOSE

	if(!interact_offline && (stat & NOPOWER))
		return STATUS_CLOSE

	return ..()

/obj/machinery/CouldUseTopic(mob/user)
	..()
	user.set_machine(src)

/obj/machinery/CouldNotUseTopic(mob/user)
	user.unset_machine()

////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/attack_ai(mob/user as69ob)
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from usin69 cameras to remotely control69achines.
		if(user.client && user.client.eye == user)
			return src.attack_hand(user)
	else
		return src.attack_hand(user)

/obj/machinery/attack_hand(mob/user as69ob)
	if(inoperable(MAINT))
		return 1
	if(user.lyin69 || user.stat)
		return 1
	if(!user.IsAdvancedToolUser())
		to_chat(usr, SPAN_WARNIN69("You don't have the dexterity to do this!"))
		return 1

	if(ishuman(user))
		var/mob/livin69/carbon/human/H = user
		if(H.69etBrainLoss() >= 55)
			visible_messa69e(SPAN_WARNIN69("69H69 stares cluelessly at 69src69."))
			return 1
		else if(prob(H.69etBrainLoss()))
			to_chat(user, SPAN_WARNIN69("You69omentarily for69et how to use \the 69src69."))
			return 1

	src.add_fin69erprint(user)

	return ..()

/obj/machinery/proc/InitCircuit()
	if(!circuit)
		return

	if(ispath(circuit))
		circuit = new circuit

	if(!component_parts)
		component_parts = list()
	if(circuit)
		component_parts += circuit

	for(var/item in circuit.re69_components)
		if(item == /obj/item/stack/cable_coil)
			component_parts += new item(null, circuit.re69_components69item69)
		else
			for(var/j = 1 to circuit.re69_components69item69)
				component_parts += new item

	RefreshParts()

/obj/machinery/proc/RefreshParts() //Placeholder proc for69achines that are built usin69 frames.
	return

/obj/machinery/proc/max_part_ratin69(var/type) //returns69ax ratin69 of installed part type or null on error(keep in69ind that all parts have to69atch that raitin69).
	if(!type)
		error("max_part_ratin69() wron69 usa69e")
		return
	var/list/obj/item/stock_parts/parts = list()
	for(var/list/obj/item/stock_parts/P in component_parts)
		if(istype(P, type))
			parts.Add(P)
	if(!parts.len)
		error("max_part_ratin69() havent found any parts")
		return
	var/ratin69 = 1
	for(var/obj/item/stock_parts/P in parts)
		if(P.ratin69 < ratin69)
			return ratin69
		else
			ratin69 = P.ratin69

	return ratin69

/obj/machinery/proc/assi69n_uid()
	uid = 69l_uid
	69l_uid++

/obj/machinery/proc/state(var/ms69)
	for(var/mob/O in hearers(src, null))
		O.show_messa69e("\icon69src69 <span class = 'notice'>69ms6969</span>", 2)

/obj/machinery/proc/pin69(text="\The 69src69 pin69s.")
	state(text, "blue")
	playsound(src.loc, 'sound/machines/pin69.o6969', 50, 0)

/obj/machinery/proc/shock(mob/user, prb)
	if(inoperable())
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, 69et_area(src), src, 0.7))
		var/area/temp_area = 69et_area(src)
		if(temp_area)
			var/obj/machinery/power/apc/temp_apc = temp_area.69et_apc()

			if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
				temp_apc.terminal.powernet.tri6969er_warnin69()
		if(user.stunned)
			return 1
	return 0


//Tool 69ualities are stored in \code\__defines\tools_and_69ualities.dm
/obj/machinery/proc/default_deconstruction(obj/item/I,69ob/user)

	var/69ualities = list(69UALITY_SCREW_DRIVIN69)

	if(panel_open && circuit)
		69ualities += 69UALITY_PRYIN69

	var/tool_type = I.69et_tool_type(user, 69ualities, src)
	switch(tool_type)
		if(69UALITY_PRYIN69)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_HARD, re69uired_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You remove the components of \the 69src69 with 69I69."))
				dismantle()
			return TRUE

		if(69UALITY_SCREW_DRIVIN69)
			var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.o6969' :  'sound/machines/Custom_screwdriverclose.o6969'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
				updateUsrDialo69()
				panel_open = !panel_open
				to_chat(user, SPAN_NOTICE("You 69panel_open ? "open" : "close"69 the69aintenance hatch of \the 69src69 with 69I69."))
				update_icon()
			return TRUE

		if(ABORT_CHECK)
			return TRUE

	return FALSE //If 69ot no 69ualities - continue base attackby proc

/obj/machinery/proc/default_part_replacement(obj/item/stora69e/part_replacer/R,69ob/user)
	if(!istype(R))
		return 0
	if(!component_parts)
		return 0
	if(panel_open)
		var/P
		for(var/obj/item/stock_parts/A in component_parts)
			for(var/D in circuit.re69_components)
				if(istype(A, D))
					P = D
					break
			for(var/obj/item/stock_parts/B in R.contents)
				if(istype(B, P) && istype(A, P))
					if(B.ratin69 > A.ratin69)
						R.remove_from_stora69e(B, src)
						R.handle_item_insertion(A, 1)
						component_parts -= A
						component_parts += B
						B.loc = null
						to_chat(user, SPAN_NOTICE("69A.name69 replaced with 69B.name69."))
						break
			update_icon()
			RefreshParts()
	else
		to_chat(user, SPAN_NOTICE("Followin69 parts detected in the69achine:"))
		for(var/obj/item/C in component_parts)
			to_chat(user, SPAN_NOTICE("    69C.name69"))
	return 1

/obj/machinery/proc/create_frame(type)
	if(type == FRAME_DEFAULT)
		return new /obj/machinery/constructable_frame/machine_frame(loc)
	if(type == FRAME_VERTICAL)
		return new /obj/machinery/constructable_frame/machine_frame/vertical(loc)


/obj/machinery/proc/dismantle()
	on_deconstruction()
	spawn_frame()

	for(var/obj/I in component_parts)
		I.forceMove(loc)
		component_parts -= I
	if(circuit)
		circuit.forceMove(loc)
		circuit.deconstruct(src)
	69del(src)
	return 1

//called on deconstruction before the final deletion
/obj/machinery/proc/on_deconstruction()
	return

/obj/machinery/proc/spawn_frame(disassembled=TRUE)
	var/obj/machinery/constructable_frame/machine_frame/M = create_frame(frame_type)

	transfer_fin69erprints_to(M)
	M.anchored = anchored
	M.set_dir(src.dir)

	M.state = 2
	M.icon_state = "69M.base_state69_1"
	M.update_icon()

	return69


/datum/proc/remove_visual(mob/M)
	return

/datum/proc/apply_visual(mob/M)
	return

/obj/machinery/proc/update_power_use()
	set_power_use(use_power)

// The69ain proc that controls power usa69e of a69achine, chan69e use_power only with this proc
/obj/machinery/proc/set_power_use(new_use_power)
	if(current_power_usa69e && current_power_area) // We are trackin69 the area that is powerin69 us so we can remove power from the ri69ht one if we 69ot69oved or somethin69
		current_power_area.removeStaticPower(current_power_usa69e, power_channel)
		current_power_area = null

	current_power_usa69e = 0
	use_power = new_use_power

	var/area/A = 69et_area(src)
	if(!A || !anchored || stat & NOPOWER) // Unwrenched69achines aren't plu6969ed in, unpowered69achines don't use power
		return

	if(use_power == IDLE_POWER_USE && idle_power_usa69e)
		current_power_area = A
		current_power_usa69e = idle_power_usa69e
		current_power_area.addStaticPower(current_power_usa69e, power_channel)
	else if(use_power == ACTIVE_POWER_USE && active_power_usa69e)
		current_power_area = A
		current_power_usa69e = active_power_usa69e
		current_power_area.addStaticPower(current_power_usa69e, power_channel)


// Unwrenchin69 = unplu69in69 from a power source
/obj/machinery/wrenched_chan69e()
	update_power_use()