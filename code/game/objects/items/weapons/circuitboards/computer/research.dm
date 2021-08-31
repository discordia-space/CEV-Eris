#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/electronics/circuitboard/rdconsole
	name = T_BOARD("R&D control console")
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/electronics/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/tool/screwdriver))
		user.visible_message(
			SPAN_NOTICE("\The [user] adjusts the jumper on \the [src]'s access protocol pins."),
			SPAN_NOTICE("You adjust the jumper on the access protocol pins.")
		)
		if(src.build_path == /obj/machinery/computer/rdconsole/core)
			src.name = T_BOARD("RD Console - Robotics")
			src.build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_NOTICE("Access protocols set to robotics."))
		else
			src.name = T_BOARD("RD Console")
			src.build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, SPAN_NOTICE("Access protocols set to default."))
	return
