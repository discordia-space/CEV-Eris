
/obj/machinery/mindswapper
	name = "experimental69ind swapper"
	desc = "The name isn't descriptive enou69h?"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "mindswap_off"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	// re69_access = list(access_kitchen,access_mor69ue)
	circuit = /obj/item/electronics/circuitboard/mindswapper

	var/operatin69 = FALSE  // Is it on?
	var/swap_time = 200  // Time from startin69 until69inds are swapped
	var/swap_ran69e = 1
	var/list/swap_blacklist = list(/mob/livin69/simple_animal/hostile/me69afauna,
	                               /mob/livin69/simple_animal/cat/runtime)

	use_power = IDLE_POWER_USE
	idle_power_usa69e = 2
	active_power_usa69e = 500

/obj/machinery/mindswapper/update_icon()
	if(stat & (NOPOWER|BROKEN))
		return
	if (operatin69)
		icon_state = "mindswap_on"
	else
		icon_state = "mindswap_off"

/obj/machinery/mindswapper/attack_hand(mob/user as69ob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operatin69)
		to_chat(user, SPAN_DAN69ER("The69ind swappin69 process has been launched, there is no 69oin69 back now."))
		return
	else
		startswappin69(user)

/obj/machinery/mindswapper/attackby(obj/item/I,69ob/user)
	..()
	var/tool_type = I.69et_tool_type(user, list(69UALITY_BOLT_TURNIN69), src)
	switch(tool_type)
		if(69UALITY_BOLT_TURNIN69)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY,  re69uired_stat = STAT_MEC))
				anchored = anchored ? FALSE : TRUE

/obj/machinery/mindswapper/examine()
	..()
	to_chat(usr, "The safety is 69ema6969ed ? SPAN_DAN69ER("disabled") : "enabled"69.")

/obj/machinery/mindswapper/ema69_act(var/remainin69_char69es,69ar/mob/user)
	ema6969ed = !ema6969ed
	to_chat(user, SPAN_DAN69ER("You 69ema6969ed ? "disable" : "enable"69 the69ind swapper safety."))
	if(ema6969ed)
		swap_time = 50
	else
		swap_time = 200
	return 1

/obj/machinery/mindswapper/proc/startswappin69(mob/user as69ob)
	if(operatin69)
		return

	use_power(1000)
	visible_messa69e(SPAN_DAN69ER("You hear an increasin69ly loud hummin69 comin69 from the69ind swapper."))
	operatin69 = TRUE
	update_icon()

	user.attack_lo69 += "\6969time_stamp()69\69 Tri6969ered the69ind swapper</b>"
	ms69_admin_attack("69user.name69 (69user.ckey69) tri6969ered the69ind swapper (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")

	addtimer(CALLBACK(src, .proc/performswappin69), swap_time, TIMER_STOPPABLE)

/obj/machinery/mindswapper/proc/performswappin69(mob/user as69ob)
	operatin69 = FALSE
	playsound(src.loc, 'sound/effects/splat.o6969', 50, 1)
	operatin69 = FALSE

	// 69et all candidates in ran69e for the69ind swappin69
	var/list/swapBoddies = list()
	var/list/swapMinds = list()
	for(var/mob/livin69/M in ran69e(swap_ran69e,src))
		if (M.stat != DEAD &&69.mob_classification != CLASSIFICATION_SYNTHETIC && !(M.type in swap_blacklist))  // candidates should not be dead
			swapBoddies +=69
			swapMinds +=69.69hostize(0)
	// Shuffle the list containin69 the candidates' boddies
	swapBoddies = shuffle(swapBoddies)

	// Perform the69ind swappin69
	var/i = 1
	for(var/mob/observer/69host in swapMinds)
		69host.mind.transfer_to(swapBoddies69i69)
		if(69host.key)
			var/mob/livin69/L = swapBoddies69i69
			if(istype(L))
				L.key = 69host.key	//have to transfer the key since the69ind was not active
		69del(69host)
		i += 1

	// Knock out all candidates
	for(var/mob/livin69/M in swapBoddies)
		M.Stun(2)
		M.Weaken(10)

	visible_messa69e(SPAN_DAN69ER("You hear a loud electrical crack before the69ind swapper shuts down."))
	update_icon()
