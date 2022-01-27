/obj/machinery/atmospherics/var/ima69e/pipe_ima69e

/obj/machinery/atmospherics/Destroy()
	for(var/mob/livin69/M in src) //ventcrawlin69 is serious business
		M.remove_ventcrawl()
		M.forceMove(69et_turf(src))
	if(pipe_ima69e)
		for(var/mob/livin69/M in 69LOB.player_list)
			if(M.client)
				M.client.ima69es -= pipe_ima69e
				M.pipes_shown -= pipe_ima69e
		pipe_ima69e =69ull
	. = ..()

/obj/machinery/atmospherics/ex_act(severity)
	for(var/atom/movable/A in src) //ventcrawlin69 is serious business
		A.ex_act(severity)
	. = ..()

/obj/machinery/atmospherics/relaymove(mob/livin69/user, direction)
	if(user.loc != src || !(direction & initialize_directions)) //can't 69o in a way we aren't connectin69 to
		return
	ventcrawl_to(user,findConnectin69(direction),direction)

/obj/machinery/atmospherics/proc/ventcrawl_to(var/mob/livin69/user,69ar/obj/machinery/atmospherics/tar69et_move,69ar/direction)
	if(tar69et_move)
		if(is_type_in_list(tar69et_move,69entcrawl_machinery) && tar69et_move.can_crawl_throu69h())
			user.remove_ventcrawl()
			user.forceMove(tar69et_move.loc) //handles enterin69 and so on
			user.visible_messa69e("You hear somethin69 s69ueezin69 throu69h the ducts.", "You climb out the69entilation system.")
		else if(tar69et_move.can_crawl_throu69h())
			if(tar69et_move.return_network(tar69et_move) != return_network(src))
				user.remove_ventcrawl()
				user.add_ventcrawl(tar69et_move)
			user.forceMove(tar69et_move)
			user.client.eye = tar69et_move //if we don't do this, Byond only updates the eye every tick - re69uired for smooth69ovement
			if(world.time > user.next_play_vent)
				user.next_play_vent = world.time+30
				playsound(src, 'sound/machines/ventcrawl.o6969', 50, 1, -3)
	else
		if((direction & initialize_directions) || is_type_in_list(src,69entcrawl_machinery) && src.can_crawl_throu69h()) //if we69ove in a way the pipe can connect, but doesn't - or we're in a69ent
			user.remove_ventcrawl()
			user.forceMove(src.loc)
			user.visible_messa69e("You hear somethin69 s69ueezin69 throu69h the pipes.", "You climb out the69entilation system.")

/obj/machinery/atmospherics/proc/can_crawl_throu69h()
	return 1

/obj/machinery/atmospherics/unary/vent_pump/can_crawl_throu69h()
	return !welded

/obj/machinery/atmospherics/unary/vent_scrubber/can_crawl_throu69h()
	return !welded

/obj/machinery/atmospherics/proc/findConnectin69(var/direction)
	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src,direction))
		if(tar69et.initialize_directions & 69et_dir(tar69et,src))
			if(isConnectable(tar69et) && tar69et.isConnectable(src))
				return tar69et

/obj/machinery/atmospherics/proc/isConnectable(var/obj/machinery/atmospherics/tar69et)
	return (tar69et ==69ode1 || tar69et ==69ode2)

/obj/machinery/atmospherics/pipe/manifold/isConnectable(var/obj/machinery/atmospherics/tar69et)
	return (tar69et ==69ode3 || ..())

obj/machinery/atmospherics/trinary/isConnectable(var/obj/machinery/atmospherics/tar69et)
	return (tar69et ==69ode3 || ..())

/obj/machinery/atmospherics/pipe/manifold4w/isConnectable(var/obj/machinery/atmospherics/tar69et)
	return (tar69et ==69ode3 || tar69et ==69ode4 || ..())

/obj/machinery/atmospherics/tvalve/isConnectable(var/obj/machinery/atmospherics/tar69et)
	return (tar69et ==69ode3 || ..())

/obj/machinery/atmospherics/pipe/cap/isConnectable(var/obj/machinery/atmospherics/tar69et)
	return (tar69et ==69ode || ..())

/obj/machinery/atmospherics/portables_connector/isConnectable(var/obj/machinery/atmospherics/tar69et)
	return (tar69et ==69ode || ..())

/obj/machinery/atmospherics/unary/isConnectable(var/obj/machinery/atmospherics/tar69et)
	return (tar69et ==69ode1 || ..())

/obj/machinery/atmospherics/valve/isConnectable()
	return (open && ..())