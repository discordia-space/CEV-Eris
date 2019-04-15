
/obj/machinery/multistructure/bioreactor_part/biotank_platform
	name = "biomatter tank platform"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "tank_platform"
	pixel_y = -4
	var/obj/structure/biomatter_tank/biotank
	var/obj/canister
	var/pipes_opened = FALSE
	var/pipes_cleanness = 100
	var/pipes_wearout_chance = 50


/obj/machinery/multistructure/bioreactor_part/biotank_platform/Initialize()
	..()
	biotank = new(get_turf(src))
	biotank.platform = src


/obj/machinery/multistructure/bioreactor_part/biotank_platform/Destroy()
	if(biotank)
		biotank.platform = null
		qdel(biotank)
	return ..()


/obj/machinery/multistructure/bioreactor_part/biotank_platform/update_icon()
	overlays.Cut()
	if(pipes_cleanness <=90)
		overlays += "[icon_state]-dirty_[get_dirtiness_level()]"


/obj/machinery/multistructure/bioreactor_part/biotank_platform/Process()
	if(!MS)
		return
	if(biotank.canister)
		biotank.reagents.trans_to_holder(biotank.canister.reagents, 10)


/obj/machinery/multistructure/bioreactor_part/biotank_platform/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/mop))
		to_chat(user, SPAN_NOTICE("You begin cleaning pipes with your [I]... O-of, what a smell!"))
		if(do_after(user, CLEANING_TIME * get_dirtiness_level(), src))
			to_chat(user, SPAN_NOTICE("You cleaned the pipes."))
			pipes_cleanness = initial(pipes_cleanness)
			if(get_dirtiness_level() == 2)
				spill_biomass(get_turf(user), cardinal)
			else if(get_dirtiness_level() >= 3)
				spill_biomass(get_turf(user), alldirs)
			toxin_attack(user, 5*get_dirtiness_level())
		else
			to_chat(user, SPAN_WARNING("You need to stand still to clean it properly."))
		update_icon()


/obj/machinery/multistructure/bioreactor_part/biotank_platform/proc/take_amount(var/amount)
	biotank.reagents.add_reagent("biomatter", amount)


/obj/machinery/multistructure/bioreactor_part/biotank_platform/proc/pipes_wearout(var/wearout, var/forced = FALSE)
	if(forced || prob(pipes_wearout_chance))
		pipes_cleanness -= wearout
	if(pipes_cleanness <= 0)
		pipes_cleanness = 0
		for(var/obj/machinery/multistructure/bioreactor_part/platform/P in MS_bioreactor.platforms)
			spill_biomass(P.loc)
	update_icon()


/obj/machinery/multistructure/bioreactor_part/biotank_platform/proc/get_dirtiness_level()
	if(pipes_cleanness >= 70 && pipes_cleanness <=90)
		return 1
	else if(pipes_cleanness >= 40 && pipes_cleanness < 70)
		return 2
	else if(pipes_cleanness < 40)
		return 3


/obj/structure/biomatter_tank
	name = "biomatter tank"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "biotank"
	anchored = TRUE
	density = TRUE
	pixel_y = 16
	var/max_capacity = 1000
	var/obj/machinery/multistructure/bioreactor_part/biotank_platform/platform
	var/obj/structure/reagent_dispensers/biomatter/canister
	var/default_position = 16
	var/to_port_position = -20


/obj/structure/biomatter_tank/Initialize()
	..()
	create_reagents(max_capacity)


/obj/structure/biomatter_tank/Destroy()
	if(platform)
		platform.biotank = null
		qdel(platform)
	return ..()


/obj/structure/biomatter_tank/update_icon()
	overlays.Cut()
	if(canister && platform.pipes_opened)
		var/image/pipe_overlay = image(icon = 'icons/obj/machines/bioreactor.dmi', icon_state = "port-pipe", pixel_y = -9)
		overlays += pipe_overlay


/obj/structure/biomatter_tank/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2)
	if(canister)
		to_chat(user, SPAN_WARNING("You should disconnect it from canister first!"))
		return
	if(platform.MS_bioreactor.chamber_solution)
		to_chat(user, SPAN_WARNING("You should stop whole machine, before opening pipes."))
		return
	if(!platform.pipes_opened)
		animate(src, pixel_y = to_port_position, 12, easing = CUBIC_EASING)
		platform.pipes_opened = TRUE
		to_chat(user, SPAN_NOTICE("You move [src] directly to port. Platform pipes now opened."))
	else
		animate(src, pixel_y = default_position, 12, easing = CUBIC_EASING)
		platform.pipes_opened = FALSE
		to_chat(user, SPAN_NOTICE("You move [src] back to it's default location. Platform pipes are closed."))


/obj/structure/biomatter_tank/attackby(var/obj/item/I, var/mob/user)
	var/tool_type = I.get_tool_type(user, list(QUALITY_BOLT_TURNING), src)
	switch(tool_type)
		if(QUALITY_BOLT_TURNING)
			if(!platform.pipes_opened)
				return
			var/obj/structure/reagent_dispensers/biomatter/possible_canister = locate() in platform.MS_bioreactor.output_port.loc
			if(!possible_canister)
				to_chat(user, SPAN_WARNING("Nothing to connect to!"))
				return
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY,  required_stat = STAT_MEC))
				if(canister)
					unset_canister(canister)
				else
					set_canister(possible_canister)
				to_chat(user, SPAN_NOTICE("You [canister ? "connect [canister] to" : "disconnect [canister] from"] [src]."))
				toxin_attack(user, rand(5, 15))
			else
				to_chat(user, SPAN_WARNING("Ugh. You done something wrong!"))
				toxin_attack(user, rand(15, 25))
				shake_animation()
				spill_biomass(get_turf(user))
			update_icon()


/obj/structure/biomatter_tank/proc/set_canister(obj/target_tank)
	target_tank.anchored = TRUE
	canister = target_tank


/obj/structure/biomatter_tank/proc/unset_canister(obj/target_tank)
	target_tank.anchored = FALSE
	canister = null

