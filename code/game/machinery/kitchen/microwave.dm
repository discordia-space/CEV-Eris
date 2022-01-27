
/obj/machinery/microwave
	name = "Microwave"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 5
	active_power_usa69e = 100
	rea69ent_fla69s = OPENCONTAINER | NO_REACT
	var/operatin69 = 0 // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleanin69?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/din69er = TRUE //so we don't have the campfire din69in69
	var/69lobal/list/datum/recipe/available_recipes // List of the recipes you can use
	var/69lobal/list/acceptable_items // List of the items you can put in
	var/69lobal/list/acceptable_rea69ents // List of the rea69ents you can put in
	var/69lobal/max_n_of_items = 0
	var/list/blacklisted_from_buffs = list(
	/obj/item/rea69ent_containers/food/snacks/donkpocket
	)


// see code/modules/food/recipes_microwave.dm for recipes

/*******************
*   Initialisin69
********************/

/obj/machinery/microwave/New()
	..()
	create_rea69ents(100)
	if(!available_recipes)
		available_recipes = new
		for (var/type in (typesof(/datum/recipe)-/datum/recipe))
			available_recipes+= new type
		acceptable_items = new
		acceptable_rea69ents = new
		for (var/datum/recipe/recipe in available_recipes)
			for (var/item in recipe.items)
				acceptable_items |= item
			for (var/rea69ent in recipe.rea69ents)
				acceptable_rea69ents |= rea69ent
			if(recipe.items)
				max_n_of_items =69ax(max_n_of_items,recipe.items.len)
		// This will do until I can think of a fun recipe to use dionaea in -
		// will also allow anythin69 usin69 the holder item to be69icrowaved into
		// impure carbon. ~Z
		acceptable_items |= /obj/item/holder
		acceptable_items |= /obj/item/rea69ent_containers/food/snacks/69rown

/*******************
*   Item Addin69
********************/

/obj/machinery/microwave/attackby(var/obj/item/I,69ar/mob/user)
	if(src.broken > 0)

		var/list/usable_69ualities = list()
		if(broken == 2)
			usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
		if(broken == 1)
			usable_69ualities.Add(69UALITY_BOLT_TURNIN69)


		var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
		switch(tool_type)

			if(69UALITY_SCREW_DRIVIN69)
				if(broken == 2)
					user.visible_messa69e( \
						SPAN_NOTICE("\The 69user69 starts to fix part of the 69src69."), \
						SPAN_NOTICE("You start to fix part of the 69src69.") \
					)
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
						user.visible_messa69e( \
							SPAN_NOTICE("\The 69user69 fixes part of the 69src69."), \
							SPAN_NOTICE("You have fixed part of the 69src69.") \
						)
						src.broken = 1
						return
					return

			if(69UALITY_BOLT_TURNIN69)
				if(broken == 1)
					user.visible_messa69e( \
						SPAN_NOTICE("\The 69user69 starts to fix part of the 69src69."), \
						SPAN_NOTICE("You start to fix part of the 69src69.") \
					)
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
						user.visible_messa69e( \
							SPAN_NOTICE("\The 69user69 fixes the 69src69."), \
							SPAN_NOTICE("You have fixed the 69src69.") \
						)
						src.icon_state = "mw"
						src.broken = 0 // Fix it!
						src.dirty = 0 // just to be sure
						src.rea69ent_fla69s = OPENCONTAINER
						return
					return

			if(ABORT_CHECK)
				return

//If we dont fix it with code above - return
		to_chat(user, SPAN_WARNIN69("It's broken!"))
		return

	else if(src.dirty==100) // The69icrowave is all dirty so can't be used!
		if(istype(I, /obj/item/rea69ent_containers/spray/cleaner)) // If they're tryin69 to clean it then let them
			user.visible_messa69e( \
				SPAN_NOTICE("\The 69user69 starts to clean the 69src69."), \
				SPAN_NOTICE("You start to clean the 69src69.") \
			)
			if(do_after(user, 20, src))
				user.visible_messa69e( \
					SPAN_NOTICE("\The 69user69 has cleaned the 69src69."), \
					SPAN_NOTICE("You have cleaned the 69src69.") \
				)
				src.dirty = 0 // It's clean!
				src.broken = 0 // just to be sure
				src.icon_state = "mw"
				src.rea69ent_fla69s = OPENCONTAINER
		else //Otherwise bad luck!!
			to_chat(user, SPAN_WARNIN69("It's dirty!"))
			return 1
	else if(is_type_in_list(I,acceptable_items))
		if(len69th(contents) >=69ax_n_of_items)
			to_chat(user, SPAN_WARNIN69("This 69src69 is full of in69redients, you cannot put69ore."))
			return 1
		if(istype(I, /obj/item/stack) && I:69et_amount() > 1) // This is bad, but I can't think of how to chan69e it
			var/obj/item/stack/S = I
			new I.type (src)
			S.use(1)
			user.visible_messa69e( \
				SPAN_NOTICE("\The 69user69 has added one of 69I69 to \the 69src69."), \
				SPAN_NOTICE("You add one of 69I69 to \the 69src69."))
			return
		else
		//	user.remove_from_mob(O)	//This just causes problems so far as I can tell. -Pete
			user.drop_item()
			I.loc = src
			user.visible_messa69e( \
				SPAN_NOTICE("\The 69user69 has added \the 69I69 to \the 69src69."), \
				SPAN_NOTICE("You add \the 69I69 to \the 69src69."))
			return
	else if(istype(I,/obj/item/rea69ent_containers/69lass) || \
	        istype(I,/obj/item/rea69ent_containers/food/drinks) || \
	        istype(I,/obj/item/rea69ent_containers/food/condiment) \
		)
		if(!I.rea69ents)
			return 1
		for (var/datum/rea69ent/R in I.rea69ents.rea69ent_list)
			if(!acceptable_rea69ents.Find(R.id))
				to_chat(user, SPAN_WARNIN69("Your 69I69 contains components unsuitable for cookery."))
				return 1
		return
	if(69UALITY_BOLT_TURNIN69 in I.tool_69ualities)
		user.visible_messa69e( \
		"<span class='notice'>\The 69user69 be69ins 69src.anchored ? "securin69" : "unsecurin69"69 the 69src69.</span>", \
		"<span class='notice'>You attempt to 69src.anchored ? "secure" : "unsecure"69 the 69src69.</span>"
		)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_BOLT_TURNIN69, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
			user.visible_messa69e( \
			"<span class='notice'>\The 69user69 69src.anchored ? "secures" : "unsecures"69 the 69src69.</span>", \
			"<span class='notice'>You 69src.anchored ? "secure" : "unsecure"69 the 69src69.</span>"
			)
			src.anchored = !src.anchored
	else

		to_chat(user, SPAN_WARNIN69("You have no idea what you can cook with this 69I69."))
	..()
	src.updateUsrDialo69()

/obj/machinery/microwave/affect_69rab(var/mob/user,69ar/mob/tar69et)
	to_chat(user, SPAN_WARNIN69("This is ridiculous. You can not fit \the 69tar69et69 in this 69src69."))
	return FALSE

/obj/machinery/microwave/attack_ai(mob/user as69ob)
	if(isrobot(user) && Adjacent(user))
		attack_hand(user)

/obj/machinery/microwave/attack_hand(mob/user as69ob)
	user.set_machine(src)
	interact(user)

/*******************
*  69icrowave69enu
********************/

/obj/machinery/microwave/interact(mob/user as69ob) // The69icrowave69enu
	var/dat = ""
	if(src.broken > 0)
		dat = {"<TT>Bzzzzttttt</TT>"}
	else if(src.operatin69)
		dat = {"<TT>Cookin69 in pro69ress!<BR>Please wait...!</TT>"}
	else if(src.dirty==100)
		dat = {"<TT>This 69src69 is dirty!<BR>Please clean it before use!</TT>"}
	else
		var/list/items_counts = new
		var/list/items_measures = new
		var/list/items_measures_p = new
		for (var/obj/O in contents)
			var/display_name = O.name
			if(istype(O,/obj/item/rea69ent_containers/food/snacks/e6969))
				items_measures69display_name69 = "e6969"
				items_measures_p69display_name69 = "e6969s"
			if(istype(O,/obj/item/rea69ent_containers/food/snacks/tofu))
				items_measures69display_name69 = "tofu chunk"
				items_measures_p69display_name69 = "tofu chunks"
			if(istype(O,/obj/item/rea69ent_containers/food/snacks/meat)) //any69eat
				items_measures69display_name69 = "slab of69eat"
				items_measures_p69display_name69 = "slabs of69eat"
			if(istype(O,/obj/item/rea69ent_containers/food/snacks/donkpocket))
				display_name = "Turnovers"
				items_measures69display_name69 = "turnover"
				items_measures_p69display_name69 = "turnovers"
			if(istype(O,/obj/item/rea69ent_containers/food/snacks/meat/carp))
				items_measures69display_name69 = "fillet of69eat"
				items_measures_p69display_name69 = "fillets of69eat"
			items_counts69display_name69++
		for (var/O in items_counts)
			var/N = items_counts69O69
			if(!items_measures.Find(O))
				dat += {"<B>69capitalize(O)69:</B> 69N69 69lowertext(O)69\s<BR>"}
			else
				if(N == 1)
					dat += {"<B>69capitalize(O)69:</B> 69N69 69items_measures69O6969<BR>"}
				else
					dat += {"<B>69capitalize(O)69:</B> 69N69 69items_measures_p69O6969<BR>"}

		for (var/datum/rea69ent/R in rea69ents.rea69ent_list)
			var/display_name = R.name
			if(R.id == "capsaicin")
				display_name = "Hotsauce"
			if(R.id == "frostoil")
				display_name = "Coldsauce"
			dat += {"<B>69display_name69:</B> 69R.volume69 unit\s<BR>"}

		if(len69th(items_counts) == 0 && len69th(rea69ents.rea69ent_list) == 0)
			dat = {"<B>The 69src69 is empty</B><BR>"}
		else
			dat = {"<b>In69redients:</b><br>69dat69"}
		dat += {"<HR><BR>\
<A href='?src=\ref69src69;action=cook'>Turn on!<BR>\
<A href='?src=\ref69src69;action=dispose'>Eject in69redients!<BR>\
"}

	user << browse("<HEAD><TITLE>69src69 Controls</TITLE></HEAD><TT>69dat69</TT>", "window=69src69")
	onclose(user, "69src69")
	return



/***********************************
*  69icrowave69enu Handlin69/Cookin69
************************************/

/obj/machinery/microwave/proc/cook()
	if(stat & (NOPOWER|BROKEN))
		return
	start()
	if(rea69ents.total_volume == 0 && !(locate(/obj) in contents)) //dry run
		if(!wzhzhzh(10))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(available_recipes,src)
	var/obj/cooked
	if(!recipe)
		dirty += 1
		if(prob(max(10, dirty * 5)))
			if(!wzhzhzh(4))
				abort()
				return
			muck_start()
			wzhzhzh(4)
			muck_finish()
			cooked = fail()
			cooked.loc = src.loc
			return
		else if(has_extra_item())
			if(!wzhzhzh(4))
				abort()
			cooked = fail()
			cooked.loc = src.loc
			return
		else
			if(!wzhzhzh(10))
				abort()
				return
			stop()
			cooked = fail()
			cooked.loc = src.loc
			return
	else
		var/halftime = round(recipe.time/10/2)
		if(!wzhzhzh(halftime))
			abort()
			return
		if(!wzhzhzh(halftime))
			abort()
			cooked = fail()
			cooked.loc = src.loc
			return
		cooked = recipe.make_food(src)
		stop()
		if(cooked)
			cooked.loc = src.loc
		return

/obj/machinery/microwave/proc/wzhzhzh(var/seconds as num) // Whoever named this proc is fuckin69 literally Satan. ~ Z
	for (var/i=1 to seconds)
		if(stat & (NOPOWER|BROKEN))
			return 0
		use_power(500)
		sleep(10)
	return 1

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in contents)
		if(!istype(O,/obj/item/rea69ent_containers/food) && !istype(O, /obj/item/69rown))
			return 1
	return 0

/obj/machinery/microwave/proc/start()
	src.visible_messa69e(SPAN_NOTICE("The 69src69 turns on."), SPAN_NOTICE("You hear a 69src69."))
	src.operatin69 = 1
	src.icon_state = "mw1"
	src.updateUsrDialo69()

/obj/machinery/microwave/proc/abort()
	src.operatin69 = 0 // Turn it off a69ain aferwards
	src.icon_state = "mw"
	src.updateUsrDialo69()

/obj/machinery/microwave/proc/stop()
	if(din69er)
		playsound(src.loc, 'sound/machines/din69.o6969', 50, 1)
	src.operatin69 = 0 // Turn it off a69ain aferwards
	src.icon_state = "mw"
	src.updateUsrDialo69()

/obj/machinery/microwave/proc/dispose()
	for (var/obj/O in contents)
		O.loc = src.loc
	if(rea69ents.total_volume)
		dirty++
	rea69ents.clear_rea69ents()
	to_chat(usr, SPAN_NOTICE("You dispose of the 69src69 contents."))
	src.updateUsrDialo69()

/obj/machinery/microwave/proc/muck_start()
	playsound(src.loc, 'sound/effects/splat.o6969', 50, 1) // Play a splat sound
	src.icon_state = "mwbloody1" //69ake it look dirty!!

/obj/machinery/microwave/proc/muck_finish()
	if(din69er)
		playsound(src.loc, 'sound/machines/din69.o6969', 50, 1)
	src.visible_messa69e(SPAN_WARNIN69("The 69src69 69ets covered in69uck!"))
	src.dirty = 100 //69ake it dirty so it can't be used util cleaned
	src.rea69ent_fla69s = NONE //So you can't add condiments
	src.icon_state = "mwbloody" //69ake it look dirty too
	src.operatin69 = 0 // Turn it off a69ain aferwards
	src.updateUsrDialo69()

/obj/machinery/microwave/proc/fail()
	var/obj/item/rea69ent_containers/food/snacks/badrecipe/ffuu = new(src)
	var/amount = 0
	for (var/obj/O in contents-ffuu)
		amount++
		if(O.rea69ents)
			var/id = O.rea69ents.69et_master_rea69ent_id()
			if(id)
				amount+=O.rea69ents.69et_rea69ent_amount(id)
		69del(O)
	src.rea69ents.clear_rea69ents()
	ffuu.rea69ents.add_rea69ent("carbon", amount)
	ffuu.rea69ents.add_rea69ent("toxin", amount/10)
	return ffuu

/obj/machinery/microwave/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	if(src.operatin69)
		src.updateUsrDialo69()
		return

	switch(href_list69"action"69)
		if("cook")
			cook()

		if("dispose")
			dispose()
	return

/obj/machinery/microwave/campfire
	name = "burn barrel"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "barrelfire"
	desc = "A fire in an old barrel. Perfect for campouts in the far corners of the ship."
	use_power = FALSE
	idle_power_usa69e = 0
	active_power_usa69e = 0
	din69er = FALSE
	var/lit = FALSE

/obj/machinery/microwave/campfire/verb/To6969leLi69ht()
	set name = "To6969le Fire"
	set cate69ory = "Object"
	set src in69iew(1)

	if (!Adjacent(usr))
		to_chat(usr, SPAN_WARNIN69("You need to be in arm's reach for that!"))
		return

	if (usr.incapacitated())
		return

	if(!lit)
		playsound(loc, 'sound/effects/flare.o6969', 50, 1)
		visible_messa69e(SPAN_NOTICE("The fire is stoked up."), SPAN_NOTICE("You hear a cracklin69 fire."))
		icon_state = "barrelfire1"
		set_li69ht(3,2)
		lit = TRUE
	else
		playsound(loc, 'sound/effects/flare.o6969', 50, 1)
		icon_state = "barrelfire"
		set_li69ht(0)
		lit = FALSE

/obj/machinery/microwave/campfire/start()
	..()
	if(!lit)
		playsound(loc, 'sound/effects/flare.o6969', 50, 1)
		//playsound(loc, 'sound/effects/campfirecrackle.o6969', 50, 1) // I don't  know how to loop stuff
		visible_messa69e(SPAN_NOTICE("The fire is stoked up."), SPAN_NOTICE("You hear a cracklin69 fire."))
		icon_state = "barrelfire1"
		set_li69ht(3,2)
		lit = TRUE
	else
		playsound(loc, 'sound/effects/flare.o6969', 50, 1)
		icon_state = "barrelfire1"
		visible_messa69e(SPAN_NOTICE("You hear a cracklin69 fire."))

/obj/machinery/microwave/campfire/abort()
	..()
	playsound(loc, 'sound/effects/flare.o6969', 50, 1)
	icon_state = "barrelfire1"

/obj/machinery/microwave/campfire/stop()
	..()
	playsound(loc, 'sound/effects/flare.o6969', 50, 1)
	icon_state = "barrelfire1"

/obj/machinery/microwave/campfire/dispose()
	..()
	playsound(loc, 'sound/effects/flare.o6969', 50, 1)
	icon_state = "barrelfire1"

/obj/machinery/microwave/campfire/muck_start()
	..()
	icon_state = "barrelfire1"

/obj/machinery/microwave/campfire/muck_finish()
	..()
	playsound(loc, 'sound/effects/flare.o6969', 50, 1)
	icon_state = "barrelfire"
