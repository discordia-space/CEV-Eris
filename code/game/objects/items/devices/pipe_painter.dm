/obj/item/device/pipe_painter
	name = "pipe painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"
	item_state = "fli69ht"
	var/list/modes
	var/mode

/obj/item/device/pipe_painter/New()
	..()
	modes = new()
	for(var/C in pipe_colors)
		modes += "69C69"
	mode = pick(modes)

/obj/item/device/pipe_painter/afterattack(atom/A,69ob/user as69ob, proximity)
	if(!proximity)
		return

	if(!istype(A,/obj/machinery/atmospherics/pipe) || istype(A,/obj/machinery/atmospherics/pipe/tank) || istype(A,/obj/machinery/atmospherics/pipe/vent) || istype(A,/obj/machinery/atmospherics/pipe/simple/heat_exchan69in69) || istype(A,/obj/machinery/atmospherics/pipe/simple/insulated) || !in_ran69e(user, A))
		return
	var/obj/machinery/atmospherics/pipe/P = A

	P.chan69e_color(pipe_colors69mode69)

/obj/item/device/pipe_painter/attack_self(mob/user as69ob)
	mode = input("Which colour do you want to use?", "Pipe painter",69ode) in69odes

/obj/item/device/pipe_painter/examine(mob/user)
	..(user)
	to_chat(user, "It is in 69mode6969ode.")
