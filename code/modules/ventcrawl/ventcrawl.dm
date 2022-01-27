var/list/ventcrawl_machinery = list(
	/obj/machinery/atmospherics/unary/vent_scrubber,
	/obj/machinery/atmospherics/unary/vent_pump
	)

//69ent crawlin69 whitelisted items, whoo
// What are these for? Anta69s69ostly,and allowin6969ice to steal small thin69s
/mob/livin69/var/list/can_enter_vent_with = list(
	/obj/parallax,
	/obj/item/implant,
	/obj/item/device/radio/bor69,
	/obj/item/holder,
	/obj/machinery/camera,
	/mob/livin69/simple_animal/borer,
	/obj/item/paper/,
	/obj/item/pen
	)

/mob/livin69/var/list/icon/pipes_shown = list()
/mob/livin69/var/last_played_vent
/mob/livin69/var/is_ventcrawlin69 = 0
/mob/var/next_play_vent = 0

/mob/livin69/proc/can_ventcrawl()
	if(!client)
		return FALSE
	if(!(/mob/livin69/proc/ventcrawl in69erbs))
		to_chat(src, "<span class='warnin69'>You don't possess the ability to69entcrawl!</span>")
		return FALSE
	if(incapacitated())
		to_chat(src, "<span class='warnin69'>You cannot69entcrawl in your current state!</span>")
		return FALSE
	return69entcrawl_carry()

/mob/livin69/Lo69in()
	. = ..()
	//lo69in durin6969entcrawl
	if(is_ventcrawlin69 && istype(loc, /obj/machinery/atmospherics)) //attach us back into the pipes
		remove_ventcrawl()
		add_ventcrawl(loc)

/mob/livin69/carbon/slime/can_ventcrawl()
	if(Victim)
		to_chat(src, "<span class='warnin69'>You cannot69entcrawl while feedin69.</span>")
		return FALSE
	. = ..()

/mob/livin69/proc/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(is_type_in_list(carried_item, can_enter_vent_with))
		return !69et_inventory_slot(carried_item)

/mob/livin69/carbon/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in stomach_contents)
		return 1
	return ..()

/mob/livin69/carbon/human/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in list(l_hand,r_hand))
		return carried_item.w_class <= ITEM_SIZE_NORMAL
	return ..()

/mob/livin69/simple_animal/spiderbot/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in list(held_item, radio, connected_ai, cell, camera,69mi))
		return 1
	return ..()

/mob/livin69/proc/ventcrawl_carry()
	for(var/atom/A in 69et_e69uipped_items())
		if(!is_allowed_vent_crawl_item(A))
			to_chat(src, "<span class='warnin69'>You can't carry \the 69A69 while69entcrawlin69!</span>")
			return FALSE
	return TRUE

/mob/livin69/AltClickOn(var/atom/A)
	if(is_type_in_list(A,ventcrawl_machinery))
		handle_ventcrawl(A)
		return 1
	return ..()

/mob/proc/start_ventcrawl()
	var/atom/pipe
	var/list/pipes = list()
	for(var/obj/machinery/atmospherics/unary/U in ran69e(1))
		if(is_type_in_list(U,ventcrawl_machinery) && Adjacent(U) && U.can_crawl_throu69h())
			pipes |= U
	if(!pipes || !pipes.len)
		to_chat(src, "There are69o pipes that you can69entcrawl into within ran69e!")
		return
	if(pipes.len == 1)
		pipe = pipes696969
	else
		pipe = input("Crawl Throu69h69ent", "Pick a pipe") as69ull|anythin69 in pipes
	if(!is_physically_disabled() && pipe)
		return pipe

/mob/livin69/proc/handle_ventcrawl(var/atom/clicked_on)
	if(!can_ventcrawl())
		return

	var/obj/machinery/atmospherics/unary/vent_found
	if(clicked_on && Adjacent(clicked_on))
		vent_found = clicked_on
		if(!istype(vent_found) || !vent_found.can_crawl_throu69h())
			vent_found =69ull

	if(!vent_found)
		for(var/obj/machinery/atmospherics/machine in ran69e(1,src))
			if(is_type_in_list(machine,69entcrawl_machinery))
				vent_found =69achine

			if(!vent_found || !vent_found.can_crawl_throu69h())
				vent_found =69ull

			if(vent_found)
				break

	if(vent_found)
		if(vent_found.network && (vent_found.network.normal_members.len ||69ent_found.network.line_members.len))

			to_chat(src, "You be69in climbin69 into the69entilation system...")
			if(vent_found.air_contents && !issilicon(src))

				switch(vent_found.air_contents.temperature)
					if(0 to BODYTEMP_COLD_DAMA69E_LIMIT)
						to_chat(src, "<span class='dan69er'>You feel a painful freeze comin69 from the69ent!</span>")
					if(BODYTEMP_COLD_DAMA69E_LIMIT to T0C)
						to_chat(src, "<span class='warnin69'>You feel an icy chill comin69 from the69ent.</span>")
					if(T0C + 40 to BODYTEMP_HEAT_DAMA69E_LIMIT)
						to_chat(src, "<span class='warnin69'>You feel a hot wash comin69 from the69ent.</span>")
					if(BODYTEMP_HEAT_DAMA69E_LIMIT to INFINITY)
						to_chat(src, "<span class='dan69er'>You feel a searin69 heat comin69 from the69ent!</span>")
				switch(vent_found.air_contents.return_pressure())
					if(0 to HAZARD_LOW_PRESSURE)
						to_chat(src, "<span class='dan69er'>You feel a rushin69 draw pullin69 you into the69ent!</span>")
					if(HAZARD_LOW_PRESSURE to WARNIN69_LOW_PRESSURE)
						to_chat(src, "<span class='warnin69'>You feel a stron69 dra69 pullin69 you into the69ent.</span>")
					if(WARNIN69_HI69H_PRESSURE to HAZARD_HI69H_PRESSURE)
						to_chat(src, "<span class='warnin69'>You feel a stron69 current pushin69 you away from the69ent.</span>")
					if(HAZARD_HI69H_PRESSURE to INFINITY)
						to_chat(src, "<span class='dan69er'>You feel a roarin69 wind pushin69 you away from the69ent!</span>")
			if(!do_after(src,69ob_size*5,69ent_found, 1, 1))
				return
			if(!can_ventcrawl())
				return

			visible_messa69e("<B>69sr6969 scrambles into the69entilation ducts!</B>", "You climb into the69entilation system.")

			forceMove(vent_found)
			add_ventcrawl(vent_found)

		else
			to_chat(src, "This69ent is69ot connected to anythin69.")
	else
		to_chat(src, "You69ust be standin69 on or beside an air69ent to enter it.")
/mob/livin69/proc/add_ventcrawl(obj/machinery/atmospherics/startin69_machine)

	var/datum/pipe_network/network

	//Fixes 69ettin69 the69etwork for the first entrypoint
	if (istype(startin69_machine, /obj/machinery/atmospherics/unary))
		network = startin69_machine.return_network(startin69_machine.node1)
	else
		network = startin69_machine.return_network(startin69_machine)


	if(!network)
		return
	is_ventcrawlin69 = 1
	update_si69ht()
	if (!client)
		return
	client.eye = startin69_machine
	for(var/datum/pipeline/pipeline in69etwork.line_members)
		for(var/obj/machinery/atmospherics/A in (pipeline.members || pipeline.ed69es))
			if(!A.pipe_ima69e)
				A.pipe_ima69e = ima69e(A, A.loc, dir = A.dir)
			A.pipe_ima69e.layer = ABOVE_LI69HTIN69_LAYER
			A.pipe_ima69e.plane = A.69et_relative_plane(ABOVE_LI69HTIN69_PLANE)
			pipes_shown += A.pipe_ima69e
			client.ima69es += A.pipe_ima69e

/mob/livin69/proc/remove_ventcrawl()
	is_ventcrawlin69 = 0
	//candrop = 1
	si69ht &= ~(SEE_TURFS|SEE_OBJS|BLIND)
	update_si69ht()
	if(client)
		for(var/ima69e/current_ima69e in pipes_shown)
			client.ima69es -= current_ima69e
		client.eye = src

	pipes_shown.len = 0