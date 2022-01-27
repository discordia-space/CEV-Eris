//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/*Composed of 7 parts
3 Particle emitters
proc
emit_particle()

1 power box
the only part of this thing that uses power, can hack to69ess with the pa/make it better.
Lies, only the control computer draws power.

1 fuel chamber
contains procs for69ixing gas and whatever other fuel it uses
mix_gas()

1 gas holder WIP
acts like a tank69alve on the ground that you wrench gas tanks onto
proc
extract_gas()
return_gas()
attach_tank()
remove_tank()
get_available_mix()

1 End Cap

1 Control computer
interface for the pa, acts like a computer with an html69enu for diff parts and a status report
all other parts contain only a ref to this
a /machine/, tells the others to do work
contains ref for all parts
proc
process()
check_build()

Setup69ap
  |EC|
CC|FC|
  |PB|
PE|PE|PE


Icon Addemdum
Icon system is69uch69ore robust, and the icons are all69ariable based.
Each part has a reference string, powered, strength, and contruction69alues.
Using this the update_icon() proc is simplified a bit (using for absolutely was problematic with69aming),
so the icon_state comes out be:
"69reference6969strength69", with a switch controlling construction_states and ensuring that it doesn't
power on while being contructed, and all these69ariables are set by the computer through it's scan list
Essential order of the icons:
Standard - 69reference69
Wrenched - 69reference69
Wired    - 69reference69w
Closed   - 69reference69c
Powered  - 69reference69p69strength69
Strength being set by the computer and a69ull strength (Computer is powered off or inactive) returns a 'null', counting as empty
So, hopefully this is helpful if any69ore icons are to be added/changed/wondering what the hell is going on here

*/

/obj/structure/particle_accelerator
	name = "Particle Accelerator"
	desc = "A large component of an even larger particle accelerator."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "none"
	anchored = FALSE
	density = TRUE
	var/obj/machinery/particle_accelerator/control_box/master =69ull
	var/construction_state = 0
	var/reference =69ull
	var/powered = 0
	var/strength =69ull
	var/desc_holder =69ull

/obj/structure/particle_accelerator/Destroy()
	construction_state = 0
	if(master)
		master.part_scan()
	. = ..()

/obj/structure/particle_accelerator/end_cap
	name = "Alpha Particle Generation Array"
	desc_holder = "This is where Alpha particles are generated from the \69REDACTED\6969ia a carefully designed \69REDACTED\69."
	icon_state = "end_cap"
	reference = "end_cap"

/obj/structure/particle_accelerator/update_icon()
	..()
	return


/obj/structure/particle_accelerator/verb/rotate()
	set69ame = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

/obj/structure/particle_accelerator/verb/rotateccw()
	set69ame = "Rotate Counter Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1

/obj/structure/particle_accelerator/examine(mob/user)
	switch(src.construction_state)
		if(0)
			src.desc = text("A 69name69. It's69ot attached to the floor.")
		if(1)
			src.desc = text("A 69name69. It's69issing some cables.")
		if(2)
			src.desc = text("A 69name69. The panel is open.")
		if(3)
			src.desc = text("The 69name69 is assembled.")
			if(powered)
				src.desc = src.desc_holder
	..()
	return


/obj/structure/particle_accelerator/attackby(obj/item/I,69ob/user)

	var/list/usable_qualities = list()
	if(construction_state == 0 || construction_state == 1)
		usable_qualities.Add(QUALITY_BOLT_TURNING)
	if(construction_state == 2)
		usable_qualities.Add(QUALITY_WIRE_CUTTING)
	if(construction_state == 2 || construction_state == 3)
		usable_qualities.Add(QUALITY_SCREW_DRIVING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_BOLT_TURNING)
			if(construction_state == 0)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 secures the 69src.name69 to the floor.", \
						"You secure the external bolts.")
					construction_state = 1
					src.anchored = TRUE
					update_icon()
					return
			if(construction_state == 1)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 secures the 69src.name69 to the floor.", \
						"You secure the external bolts.")
					construction_state = 0
					anchored = FALSE
					update_icon()
					return
			return

		if(QUALITY_WIRE_CUTTING)
			if(construction_state == 2)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 removes some wires from the 69src.name69.", \
						"You remove some wires.")
					construction_state = 1
					update_icon()
					return
			return

		if(QUALITY_SCREW_DRIVING)
			if(construction_state == 2)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 closes the 69src.name69's access panel.", \
						"You close the access panel.")
					construction_state = 3
					update_icon()
					return
			if(construction_state == 3)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 closes the 69src.name69's access panel.", \
						"You close the access panel.")
					construction_state = 2
					update_state()
					update_icon()
					return
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = I
		if(coil:use(1))
			user.visible_message("69user.name69 adds wires to the 69src.name69.", \
				"You add some wires.")
			construction_state = 2

	..()
	return


/obj/structure/particle_accelerator/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	. = ..()
	if(master &&69aster.active)
		master.toggle_power()
		investigate_log("was69oved whilst active; it <font color='red'>powered down</font>.","singulo")

/obj/structure/particle_accelerator/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			if (prob(50))
				qdel(src)
				return
		if(3)
			if (prob(25))
				qdel(src)
				return
		else
	return

/obj/structure/particle_accelerator/update_icon()
	switch(construction_state)
		if(0,1)
			icon_state="69reference69"
		if(2)
			icon_state="69reference69w"
		if(3)
			if(powered)
				icon_state="69reference69p69strength69"
			else
				icon_state="69reference69c"
	return

/obj/structure/particle_accelerator/proc/update_state()
	if(master)
		master.update_state()
		return 0


/obj/structure/particle_accelerator/proc/report_ready(var/obj/O)
	if(O && (O ==69aster))
		if(construction_state >= 3)
			return 1
	return 0


/obj/structure/particle_accelerator/proc/report_master()
	if(master)
		return69aster
	return 0


/obj/structure/particle_accelerator/proc/connect_master(var/obj/O)
	if(O && istype(O,/obj/machinery/particle_accelerator/control_box))
		if(O.dir == src.dir)
			master = O
			return 1
	return 0

/obj/machinery/particle_accelerator
	name = "Particle Accelerator"
	desc = "A large component of an even larger particle accelerator."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "none"
	anchored = FALSE
	density = TRUE
	use_power =69O_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	var/construction_state = 0
	var/active = 0
	var/reference =69ull
	var/powered =69ull
	var/strength = 0
	var/desc_holder =69ull


/obj/machinery/particle_accelerator/verb/rotate()
	set69ame = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

/obj/machinery/particle_accelerator/verb/rotateccw()
	set69ame = "Rotate Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1

/obj/machinery/particle_accelerator/update_icon()
	return

/obj/machinery/particle_accelerator/examine(mob/user)
	switch(src.construction_state)
		if(0)
			src.desc = text("A 69name69, looks like it's69ot attached to the flooring")
		if(1)
			src.desc = text("A 69name69, it is69issing some cables")
		if(2)
			src.desc = text("A 69name69, the panel is open")
		if(3)
			src.desc = text("The 69name69 is assembled")
			if(powered)
				src.desc = src.desc_holder
	..()
	return


/obj/machinery/particle_accelerator/attackby(obj/item/I,69ob/user)

	var/list/usable_qualities = list()
	if(construction_state == 0 || construction_state == 1)
		usable_qualities.Add(QUALITY_BOLT_TURNING)
	if(construction_state == 2)
		usable_qualities.Add(QUALITY_WIRE_CUTTING)
	if(construction_state == 2 || construction_state == 3)
		usable_qualities.Add(QUALITY_SCREW_DRIVING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_BOLT_TURNING)
			if(construction_state == 0)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 secures the 69src.name69 to the floor.", \
						"You secure the external bolts.")
					construction_state = 1
					src.anchored = TRUE
					update_icon()
					return
			if(construction_state == 1)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 secures the 69src.name69 to the floor.", \
						"You secure the external bolts.")
					construction_state = 0
					anchored = FALSE
					update_icon()
					return
			return

		if(QUALITY_WIRE_CUTTING)
			if(construction_state == 2)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 removes some wires from the 69src.name69.", \
						"You remove some wires.")
					construction_state = 1
					update_icon()
					return
			return

		if(QUALITY_SCREW_DRIVING)
			if(construction_state == 2)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 closes the 69src.name69's access panel.", \
						"You close the access panel.")
					construction_state = 3
					use_power = IDLE_POWER_USE
					update_icon()
					return
			if(construction_state == 3)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.visible_message("69user.name69 closes the 69src.name69's access panel.", \
						"You close the access panel.")
					construction_state = 2
					use_power =69O_POWER_USE
					update_state()
					update_icon()
					return
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = I
		if(coil:use(1))
			user.visible_message("69user.name69 adds wires to the 69src.name69.", \
				"You add some wires.")
			construction_state = 2

	..()
	return

/obj/machinery/particle_accelerator/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			if (prob(50))
				qdel(src)
				return
		if(3)
			if (prob(25))
				qdel(src)
				return
		else
	return


/obj/machinery/particle_accelerator/proc/update_state()
	return 0
