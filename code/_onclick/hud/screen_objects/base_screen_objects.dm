 /*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/image/no_recolor
	appearance_flags = RESET_COLOR


/obj/screen
	name = ""
	icon = 'icons/mob/screen1.dmi'
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE
	unacidable = 1
	var/obj/master = null //A reference to the object in the slot. Grabs or items, generally.
	var/mob/living/parentmob
	var/process_flag = FALSE
	var/hideflag = 0
	var/list/image/ovrls = list()

/obj/screen/New(_name = "unnamed", mob/living/_parentmob, _icon, _icon_state)//(_name = "unnamed", _screen_loc = "7,7", mob/living/_parentmob, _icon, _icon_state)
	src.parentmob = _parentmob
	src.name = _name
//	src.screen_loc = _screen_loc
	if (_icon)
		src.icon = _icon
	if (_icon_state)
		src.icon_state = _icon_state
	..()


/obj/screen/Process()
	return

/obj/screen/proc/DEADelize()
	return

/obj/screen/Destroy()
	master = null
	return ..()

/obj/screen/update_plane()
	return

/obj/screen/set_plane(var/np)
	plane = np


/obj/screen/Click(location, control, params)
	if(!usr)
		return TRUE

	switch(name)

		if("equip")
			if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
				return TRUE
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()

		if("Reset Machine")
			usr.unset_machine()
		else
			return FALSE
	return TRUE
//--------------------------------------------------close---------------------------------------------------------

/obj/screen/close
	name = "close"

/obj/screen/close/New()
	return

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = master
			S.close(usr)
	return TRUE
//--------------------------------------------------close end---------------------------------------------------------


//--------------------------------------------------GRAB---------------------------------------------------------
/obj/screen/grab
	name = "grab"

/obj/screen/grab/Click()
	var/obj/item/weapon/grab/G = master
	G.s_click(src)
	return TRUE

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return
//-----------------------------------------------GRAB END---------------------------------------------------------





//-----------------------------------------------ITEM ACTION---------------------------------------------------------
/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Destroy()
	. = ..()
	owner = null

/obj/screen/item_action/Click()
	if(!usr || !owner)
		return TRUE
	if(!usr.can_click())
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return TRUE

	if(!(owner in usr))
		return TRUE

	owner.ui_action_click(usr, name)
	update_icon()
	return TRUE

/obj/screen/item_action/top_bar
	name = "actionA"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "actionA"
	screen_loc = "8,1:13"
	var/minloc = "7,2:13"
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE

/obj/screen/item_action/top_bar/Initialize()
	. = ..()
	name = initial(name)

/obj/screen/item_action/top_bar/update_icon()
	..()
	if(!ismob(owner.loc))
		return

	var/mob/living/M = owner.loc
	if(M.client && M.get_active_hand() == owner)
		if(M.client.prefs.UI_compact_style)
			screen_loc = minloc
		else
			screen_loc = initial(screen_loc)


/obj/screen/item_action/top_bar/A
	icon_state = "actionA"
	screen_loc = "8,1:13"

/obj/screen/item_action/top_bar/B
	icon_state = "actionB"
	screen_loc = "8,1:13"

/obj/screen/item_action/top_bar/C
	icon_state = "actionC"
	screen_loc = "9,1:13"

/obj/screen/item_action/top_bar/D
	icon_state = "actionD"
	screen_loc = "9,1:13"


//-----------------------------------------------ITEM ACTION END---------------------------------------------------------



//--------------------------------------------------ZONE SELECT---------------------------------------------------------
/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel

/obj/screen/zone_sel/Click(location, control, params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/selecting

	switch(icon_y)
		if(1 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					selecting = BP_R_LEG
				if(17 to 22)
					selecting = BP_L_LEG
				else
					return TRUE
		if(10 to 13) //Arms and groin
			switch(icon_x)
				if(8 to 11)
					selecting = BP_R_ARM
				if(12 to 20)
					selecting = BP_GROIN
				if(21 to 24)
					selecting = BP_L_ARM
				else
					return TRUE
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					selecting = BP_R_ARM
				if(12 to 20)
					selecting = BP_CHEST
				if(21 to 24)
					selecting = BP_L_ARM
				else
					return TRUE
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				selecting = BP_HEAD
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							selecting = BP_MOUTH
					if(25 to 27)
						if(icon_x in 14 to 18)
							selecting = BP_EYES

	set_selected_zone(selecting)
	return TRUE

/obj/screen/zone_sel/New()
	..()
	update_icon()

/obj/screen/zone_sel/update_icon()
	overlays.Cut()
	overlays += image('icons/mob/zone_sel.dmi', "[parentmob.targeted_organ]")

/obj/screen/zone_sel/proc/set_selected_zone(bodypart)
	var/old_selecting = parentmob.targeted_organ
	if(old_selecting != bodypart)
		parentmob.targeted_organ = bodypart
		update_icon()
//--------------------------------------------------ZONE SELECT END---------------------------------------------------------

/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480


/obj/screen/storage
	name = "storage"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/storage/Click()
	if(!usr.can_click())
		return TRUE
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return TRUE
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return TRUE
	if(master)
		var/obj/item/I = usr.get_active_hand()
		if(I)
			usr.ClickOn(master)
	return TRUE

//--------------------------------------------------inventory---------------------------------------------------------
/obj/screen/inventory
	var/slot_id //The indentifier for the slot. It has nothing to do with ID cards.
	icon = 'icons/mob/screen/ErisStyle.dmi'
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/inventory/New(_name = "unnamed", _slot_id = null, _icon = null, _icon_state = null, _parentmob = null)//(_name = "unnamed", _screen_loc = "7,7", _slot_id = null, _icon = null, _icon_state = null, _parentmob = null)
	src.name = _name
//	src.screen_loc = _screen_loc
	src.icon = _icon
	src.slot_id = _slot_id
	src.icon_state = _icon_state
	src.parentmob = _parentmob

/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(!usr.can_click())
		return TRUE
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return TRUE
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return TRUE
	switch(name)
		if("hand")
			usr:swap_hand()
		else
			usr.attack_ui(slot_id)
	return TRUE

/obj/screen/inventory/hand
	name = "nonamehand"

/obj/screen/inventory/hand/New()
	..()
	ovrls["act_hand"] += new /image/no_recolor (icon = src.icon, icon_state ="act_hand[src.slot_id==slot_l_hand ? "-l" : "-r"]")
	update_icon()

/obj/screen/inventory/hand/Click()
	var/mob/living/carbon/C = parentmob
	if (src.slot_id == slot_l_hand)
		C.activate_hand("l")
	else
		C.activate_hand("r")

/obj/screen/inventory/hand/update_icon()
	src.overlays -= ovrls["act_hand"]
	if (src.slot_id == (parentmob.hand ? slot_l_hand : slot_r_hand))
		src.overlays += ovrls["act_hand"]
/*	if (src.slot_id == (parentmob.hand ? slot_l_hand : slot_r_hand)) // if display left
		src.icon_state = "act_hand[src.slot_id==slot_l_hand ? "-l" : "-r"]"
	else
		src.icon_state = "hand[src.slot_id==slot_l_hand ? "-l" : "-r"]"*/
//--------------------------------------------------inventory end---------------------------------------------------------

//--------------------------------------------------health---------------------------------------------------------
/obj/screen/health
	name = "health"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "health0"
	screen_loc = "15,7"
	process_flag = TRUE

/obj/screen/health/New()
	..()
	ovrls["health0"] += new /image (icon = src.icon, icon_state ="health0")
	ovrls["health1"] += new /image/no_recolor(icon = src.icon, icon_state ="health1")
	ovrls["health2"] += new /image/no_recolor(icon = src.icon, icon_state ="health2")
	ovrls["health3"] += new /image/no_recolor(icon = src.icon, icon_state ="health3")
	ovrls["health4"] += new /image/no_recolor(icon = src.icon, icon_state ="health4")
	ovrls["health5"] += new /image/no_recolor(icon = src.icon, icon_state ="health5")
	ovrls["health6"] += new /image/no_recolor(icon = src.icon, icon_state ="health6")
	ovrls["health7"] += new /image(icon = src.icon, icon_state ="health7")
	update_icon()

/obj/screen/health/Process()
	//var/mob/living/carbon/human/H = parentmob
	update_icon()

/obj/screen/health/update_icon()
	if(parentmob:stat != DEAD)
		overlays.Cut()
		if (parentmob:analgesic > 100)
//			icon_state = "health_numb"
			overlays += ovrls["health0"]
		else
			switch(100 - ((parentmob:species.flags & NO_PAIN) ? 0 : parentmob:traumatic_shock))
				if(100 to INFINITY)		overlays += ovrls["health0"]
				if(80 to 100)			overlays += ovrls["health1"]
				if(60 to 80)			overlays += ovrls["health2"]
				if(40 to 60)			overlays += ovrls["health3"]
				if(20 to 40)			overlays += ovrls["health4"]
				if(0 to 20)				overlays += ovrls["health5"]
				else					overlays += ovrls["health6"]

/obj/screen/health/DEADelize()
	overlays.Cut()
	overlays += ovrls["health7"]

/obj/screen/health/Click()
	if(ishuman(parentmob))
		var/mob/living/carbon/human/H = parentmob
		H.check_self_for_injuries()

//--------------------------------------------------health end---------------------------------------------------------

//--------------------------------------------------nutrition---------------------------------------------------------
/obj/screen/nutrition
	name = "nutrition"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	screen_loc = "15,6"
	process_flag = TRUE

/obj/screen/nutrition/New()
	..()
	ovrls["nutrition0"] += new /image (icon = src.icon, icon_state ="nutrition0")
	ovrls["nutrition1"] += new /image/no_recolor(icon = src.icon, icon_state ="nutrition1")
	ovrls["nutrition2"] += new /image/no_recolor(icon = src.icon, icon_state ="nutrition2")
	ovrls["nutrition3"] += new /image/no_recolor(icon = src.icon, icon_state ="nutrition3")
	ovrls["nutrition4"] += new /image/no_recolor(icon = src.icon, icon_state ="nutrition4")
	update_icon()

/obj/screen/nutrition/Process()
	//var/mob/living/carbon/human/H = parentmob
	update_icon()

/obj/screen/nutrition/update_icon()
	set src in usr.client.screen
	var/mob/living/carbon/human/H = parentmob
	overlays.Cut()
	switch(H.nutrition)
		if(450 to INFINITY)				overlays += ovrls["nutrition0"]
		if(350 to 450)					overlays += ovrls["nutrition1"]
		if(250 to 350)					overlays += ovrls["nutrition2"]
		if(150 to 250)					overlays += ovrls["nutrition3"]
		else							overlays += ovrls["nutrition4"]

/obj/screen/nutrition/DEADelize()
	overlays.Cut()
	overlays += ovrls["nutrition4"]
//--------------------------------------------------nutrition end---------------------------------------------------------

//--------------------------------------------------bodytemp---------------------------------------------------------
/obj/screen/bodytemp
	name = "bodytemp"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	screen_loc = "15,8"
	process_flag = TRUE


/obj/screen/bodytemp/New()
	..()
	ovrls["temp0"] += new /image/no_recolor (icon = src.icon, icon_state ="temp0")
	ovrls["temp1"] += new /image/no_recolor(icon = src.icon, icon_state ="temp1")
	ovrls["temp2"] += new /image/no_recolor(icon = src.icon, icon_state ="temp2")
	ovrls["temp3"] += new /image/no_recolor(icon = src.icon, icon_state ="temp3")
	ovrls["temp4"] += new /image/no_recolor(icon = src.icon, icon_state ="temp4")
	ovrls["temp-1"] += new /image/no_recolor(icon = src.icon, icon_state ="temp-1")
	ovrls["temp-2"] += new /image/no_recolor(icon = src.icon, icon_state ="temp-2")
	ovrls["temp-3"] += new /image/no_recolor(icon = src.icon, icon_state ="temp-3")
	ovrls["temp-4"] += new /image/no_recolor(icon = src.icon, icon_state ="temp-4")
	update_icon()

/obj/screen/bodytemp/Process()
	update_icon()


/obj/screen/bodytemp/update_icon()
	//TODO: precalculate all of this stuff when the species datum is created
	var/base_temperature = parentmob:species.body_temperature
	if(base_temperature == null) //some species don't have a set metabolic temperature
		base_temperature = (parentmob:species.heat_level_1 + parentmob:species.cold_level_1)/2

	var/temp_step
	overlays.Cut()
	if (parentmob:bodytemperature >= base_temperature)
		temp_step = (parentmob:species.heat_level_1 - base_temperature)/4

		if (parentmob:bodytemperature >= parentmob:species.heat_level_1)
			overlays += ovrls["temp4"]//icon_state = "temp4"
		else if (parentmob:bodytemperature >= base_temperature + temp_step*3)
			overlays += ovrls["temp3"]
		else if (parentmob:bodytemperature >= base_temperature + temp_step*2)
			overlays += ovrls["temp2"]
		else if (parentmob:bodytemperature >= base_temperature + temp_step*1)
			overlays += ovrls["temp1"]
		else
			overlays += ovrls["temp0"]

	else if (parentmob:bodytemperature < base_temperature)
		temp_step = (base_temperature - parentmob:species.cold_level_1)/4

		if (parentmob:bodytemperature <= parentmob:species.cold_level_1)
			overlays += ovrls["temp-4"]
		else if (parentmob:bodytemperature <= base_temperature - temp_step*3)
			overlays += ovrls["temp-3"]
		else if (parentmob:bodytemperature <= base_temperature - temp_step*2)
			overlays += ovrls["temp-2"]
		else if (parentmob:bodytemperature <= base_temperature - temp_step*1)
			overlays += ovrls["temp-1"]
		else
			overlays += ovrls["temp0"]

/obj/screen/bodytemp/DEADelize()
	overlays.Cut()
	overlays += ovrls["temp-4"]
//--------------------------------------------------bodytemp end---------------------------------------------------------


//--------------------------------------------------pressure---------------------------------------------------------
/obj/screen/pressure
	name = "pressure"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	screen_loc = "15,13"
	process_flag = TRUE

/obj/screen/pressure/New()
	..()
	ovrls["pressure2"] += new /image/no_recolor (icon = src.icon, icon_state ="pressure2")
	ovrls["pressure1"] += new /image/no_recolor(icon = src.icon, icon_state ="pressure1")
	ovrls["pressure0"] += new /image/no_recolor(icon = src.icon, icon_state ="pressure0")
	ovrls["pressure-1"] += new /image/no_recolor(icon = src.icon, icon_state ="pressure-1")
	ovrls["pressure-2"] += new /image/no_recolor(icon = src.icon, icon_state ="pressure-2")
	update_icon()


/obj/screen/pressure/Process()
	update_icon()

/obj/screen/pressure/update_icon()
	var/mob/living/carbon/human/H = parentmob
//	icon_state = "pressure[H.pressure_alert]"
	overlays.Cut()
	overlays += ovrls["pressure[H.pressure_alert]"]

/obj/screen/pressure/DEADelize()
	overlays.Cut()
	overlays += ovrls["pressure-2"]
//--------------------------------------------------pressure end---------------------------------------------------------

//--------------------------------------------------toxin---------------------------------------------------------
/obj/screen/toxin
	name = "toxin"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "tox0"
	screen_loc = "15,10"
	process_flag = 1

/obj/screen/toxin/New()
	..()
	ovrls["tox1"] += new /image/no_recolor(icon = src.icon, icon_state ="tox1")
	update_icon()

/obj/screen/toxin/Process()
	update_icon()

/obj/screen/toxin/update_icon()
	var/mob/living/carbon/human/H = parentmob
	overlays.Cut()
	if(H.plasma_alert)
		overlays += ovrls["tox1"]
//		icon_state = "tox1"
//	else
//		icon_state = "tox0"

/obj/screen/toxin/DEADelize()
	overlays.Cut()
	overlays += ovrls["tox1"]
//--------------------------------------------------toxin end---------------------------------------------------------

//--------------------------------------------------oxygen---------------------------------------------------------

/obj/screen/oxygen
	name = "oxygen"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "oxy0"
	screen_loc = "15,12"
	process_flag = TRUE

/obj/screen/oxygen/New()
	..()
	ovrls["oxy1"] += new /image/no_recolor(icon = src.icon, icon_state ="oxy1")
//	ovrls["oxy0"] += new /image/no_recolor(icon = src.icon, icon_state ="oxy0")
	update_icon()

/obj/screen/oxygen/Process()
	update_icon()

/obj/screen/oxygen/update_icon()
	var/mob/living/carbon/human/H = parentmob
	overlays.Cut()
	if(H.oxygen_alert)
		overlays += ovrls["oxy1"]
//		icon_state = "oxy1"
//	else
//		icon_state = "oxy0"

/obj/screen/oxygen/DEADelize()
	overlays.Cut()
	overlays += ovrls["oxy1"]
//--------------------------------------------------oxygen end---------------------------------------------------------

//--------------------------------------------------fire---------------------------------------------------------
/obj/screen/fire
	name = "fire"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	screen_loc = "15,9"
	process_flag = TRUE


/obj/screen/fire/New()
	..()
	ovrls["fire1"] += new /image/no_recolor(icon = src.icon, icon_state ="fire1")
	ovrls["fire0"] += new /image(icon = src.icon, icon_state ="fire0")
	ovrls["fire-1"] += new /image/no_recolor(icon = src.icon, icon_state ="fire-1")
	update_icon()
//	ovrl.appearance_flags = RESET_COLOR

/obj/screen/fire/Process()
	update_icon()

/obj/screen/fire/update_icon()
	var/mob/living/carbon/human/H = parentmob
	src.overlays.Cut()
//	if (H.fire_alert)
	overlays += ovrls["fire[H.fire_alert]"]
//	icon_state = "fire[H.fire_alert]"
	/*if(H.fire_alert)							icon_state = "fire[H.fire_alert]" //fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
	else										icon_state = "fire0"*/

obj/screen/fire/DEADelize()
	overlays.Cut()
	overlays += ovrls["fire-1"]
//--------------------------------------------------fire end---------------------------------------------------------
/*/obj/screen/slot_object
	name = "slot"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "block"
	screen_loc = ""*/
//-----------------------internal------------------------------
/obj/screen/internal
	name = "internal"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "internal0"
	screen_loc = "15,14"

/obj/screen/internal/New()
	..()
	ovrls["internal1"] += new /image/no_recolor(icon = src.icon, icon_state ="internal1")
	ovrls["internal2"] += new /image/no_recolor(icon = src.icon, icon_state ="internal2")

/obj/screen/internal/Click()
//	if("internal")
	if(iscarbon(parentmob))
		var/mob/living/carbon/C = parentmob
		if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
			if(C.internal)
				C.internal = null
				to_chat(C, SPAN_NOTICE("No longer running on internals."))
				overlays.Cut()
			else

				var/no_mask
				if(!(C.wear_mask && C.wear_mask.item_flags & AIRTIGHT))
					var/mob/living/carbon/human/H = C
					if(!(H.head && H.head.item_flags & AIRTIGHT))
						no_mask = 1

				if(no_mask)
					to_chat(C, SPAN_NOTICE("You are not wearing a suitable mask or helmet."))
					return TRUE
				else
					var/list/nicename = null
					var/list/tankcheck = null
					var/breathes = "oxygen"    //default, we'll check later
					var/list/contents = list()
					var/from = "on"

					if(ishuman(C))
						var/mob/living/carbon/human/H = C
						breathes = H.species.breath_type
						nicename = list ("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
						tankcheck = list (H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
					else
						nicename = list("right hand", "left hand", "back")
						tankcheck = list(C.r_hand, C.l_hand, C.back)

					// Rigs are a fucking pain since they keep an air tank in nullspace.
					if(istype(C.back,/obj/item/weapon/rig))
						var/obj/item/weapon/rig/rig = C.back
						if(rig.air_supply)
							from = "in"
							nicename |= "hardsuit"
							tankcheck |= rig.air_supply

					for(var/i=1, i<tankcheck.len+1, ++i)
						if(istype(tankcheck[i], /obj/item/weapon/tank))
							var/obj/item/weapon/tank/t = tankcheck[i]
							if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc, breathes))
								contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
								continue					//in it, so we're going to believe the tank is what it says it is
							switch(breathes)
																//These tanks we're sure of their contents
								if("nitrogen") 							//So we're a bit more picky about them.

									if(t.air_contents.gas["nitrogen"] && !t.air_contents.gas["oxygen"])
										contents.Add(t.air_contents.gas["nitrogen"])
									else
										contents.Add(0)

								if ("oxygen")
									if(t.air_contents.gas["oxygen"] && !t.air_contents.gas["plasma"])
										contents.Add(t.air_contents.gas["oxygen"])
									else if(istype(t, /obj/item/weapon/tank/onestar_regenerator))
										contents.Add(BREATH_MOLES*2)
									else
										contents.Add(0)

								// No races breath this, but never know about downstream servers.
								if ("carbon dioxide")
									if(t.air_contents.gas["carbon_dioxide"] && !t.air_contents.gas["plasma"])
										contents.Add(t.air_contents.gas["carbon_dioxide"])
									else
										contents.Add(0)


						else
							//no tank so we set contents to 0
							contents.Add(0)

					//Alright now we know the contents of the tanks so we have to pick the best one.

					var/best = 0
					var/bestcontents = 0
					for(var/i=1, i <  contents.len + 1 , ++i)
						if(!contents[i])
							continue
						if(contents[i] > bestcontents)
							best = i
							bestcontents = contents[i]


					//We've determined the best container now we set it as our internals

					if(best)
						to_chat(C, SPAN_NOTICE("You are now running on internals from [tankcheck[best]] [from] your [nicename[best]]."))
						playsound(usr, 'sound/effects/Custom_internals.ogg', 50, -5)
						C.internal = tankcheck[best]

					if(!C.internal)
						to_chat(C, "<span class='notice'>You don't have a[breathes=="oxygen" ? "n oxygen" : addtext(" ", breathes)] tank.</span>")
					update_icon()

/obj/screen/internal/update_icon()
	overlays.Cut()
	if(parentmob:internal)
		overlays += ovrls["internal1"]

/obj/screen/internal/DEADelize()
	overlays.Cut()
//-----------------------internal END------------------------------

//-----------------------Pull------------------------------

/obj/screen/pull
	name = "pull"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "pull0"
	screen_loc = "14,2"

/obj/screen/pull/New()
	..()
	update_icon()

/obj/screen/pull/Click()
	usr.stop_pulling()
	//update_icon()
	//icon_state = "pull0"

/obj/screen/pull/update_icon()
	if (parentmob.pulling)
		icon_state = "pull1"
	else
		icon_state = "pull0"

//-----------------------Pull end------------------------------
//-----------------------throw------------------------------
/obj/screen/HUDthrow
	name = "throw"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "act_throw_off"
	screen_loc = "15,2"

/obj/screen/HUDthrow/New()
	/*if(usr)
		//parentmob = usr
		//usr.verbs += /obj/screen/HUDthrow/verb/toggle_throw_mode()
		if(usr.client)
			usr.client.screen += src*/
	..()
	update_icon()

/obj/screen/HUDthrow/Click()
	parentmob.toggle_throw_mode()
	update_icon()
	return TRUE

/obj/screen/HUDthrow/update_icon()
	if (parentmob.in_throw_mode)
		icon_state = "act_throw_on"
	else
		icon_state = "act_throw_off"
//-----------------------throw END------------------------------

//-----------------------drop------------------------------
/obj/screen/drop
	name = "drop"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "act_drop"
	screen_loc = "15:-16,2"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/drop/Click()
	if(usr.client)
		usr.client.drop_item()
//-----------------------drop END------------------------------

//-----------------------resist------------------------------
/obj/screen/resist
	name = "resist"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "act_resist"
	screen_loc = "14:16,2"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/resist/Click()
	if(isliving(parentmob))
		var/mob/living/L = parentmob
		L.resist()


//-----------------------resist END------------------------------

//-----------------------mov_intent------------------------------
/obj/screen/mov_intent
	name = "mov_intent"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "running"
	screen_loc = "14,1"


/obj/screen/mov_intent/Click()
	var/move_intent_type = next_in_list(usr.move_intent.type, usr.move_intents)
	var/decl/move_intent/newintent = decls_repository.get_decl(move_intent_type)
	if (newintent.can_enter(parentmob, TRUE))
		parentmob.move_intent = newintent
		update_icon()

	update_icon()

/obj/screen/mov_intent/New()
	..()
	update_icon()

/obj/screen/mov_intent/update_icon()
	icon_state = parentmob.move_intent.hud_icon_state

//-----------------------mov_intent END------------------------------
/obj/screen/equip
	name = "equip"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "act_equip"
	screen_loc = "8,2"

/obj/screen/equip/Click()
	if (istype(parentmob.loc,/obj/mecha)) // stops inventory actions in a mech
		return TRUE
	if(ishuman(parentmob))
		var/mob/living/carbon/human/H = parentmob
		H.quick_equip()
//-----------------------swap------------------------------
/obj/screen/swap
	name = "swap hand"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "swap-l"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/swap/New()
	..()
	overlays += image(icon = src.icon, icon_state =  "swap-r", pixel_x = 32)

/obj/screen/swap/Click()
	parentmob.swap_hand()
//-----------------------swap END------------------------------

//-----------------------intent------------------------------
/obj/screen/intent
	name = "intent"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	screen_loc = "8,2"

/obj/screen/intent/New()
	..()
	ovrls["disarm"] += new /image/no_recolor (icon = src.icon, icon_state ="disarm")
	ovrls["harm"] += new /image/no_recolor (icon = src.icon, icon_state ="harm")
	ovrls["grab"] += new /image/no_recolor (icon = src.icon, icon_state ="grab")
	ovrls["help"] += new /image/no_recolor (icon = src.icon, icon_state ="help")
	update_icon()

/obj/screen/intent/Click()
	parentmob.a_intent_change("right")
//	update_icon()//update in a_intent_change, because macro

/obj/screen/intent/update_icon()
	src.overlays.Cut()
	switch (parentmob.a_intent)
/*		if(I_HELP)
			icon_state = "help"
		if(I_HURT)
			icon_state = "harm"
		if(I_GRAB)
			icon_state = "grab"
		if(I_DISARM)
			icon_state = "disarm"*/
		if(I_HELP)
			src.overlays += ovrls["help"]
		if(I_HURT)
			src.overlays += ovrls["harm"]
		if(I_GRAB)
			src.overlays += ovrls["grab"]
		if(I_DISARM)
			src.overlays += ovrls["disarm"]
//-----------------------intent END------------------------------

/obj/screen/fastintent
	name = "fastintent"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	var/target_intent

/obj/screen/fastintent/New()
	..()
	src.overlays += new /image/no_recolor(icon = src.icon, icon_state = src.icon_state)

/obj/screen/fastintent/Click()
	parentmob.a_intent_change(target_intent)

/obj/screen/fastintent/help
	target_intent = I_HELP
	icon_state = "intent_help"

/obj/screen/fastintent/harm
	target_intent = I_HURT
	icon_state = "intent_harm"

/obj/screen/fastintent/grab
	target_intent = I_GRAB
	icon_state = "intent_grab"

/obj/screen/fastintent/disarm
	target_intent = I_DISARM
	icon_state = "intent_disarm"



/obj/screen/drugoverlay
	icon_state = "blank"
	name = "drugs"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	mouse_opacity = 0
	process_flag = TRUE
	layer = 17 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.
	plane = HUD_PLANE
//	var/global/image/blind_icon = image('icons/mob/screen1_full.dmi', "blackimageoverlay")

/obj/screen/drugoverlay/Process()
	update_icon()

/obj/screen/drugoverlay/update_icon()
	underlays.Cut()
	if (parentmob.disabilities & NEARSIGHTED)
		var/obj/item/clothing/glasses/G = parentmob.get_equipped_item(slot_glasses)
		if(!G || !G.prescription)
			underlays += global_hud.vimpaired
	if (parentmob.eye_blurry)
		underlays += global_hud.blurry
	if (parentmob.druggy)
		underlays += global_hud.druggy


/obj/screen/full_1_tile_overlay
	name = "full_1_tile_overlay"
	icon_state = "blank"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	layer = 21
	plane = HUD_PLANE
	mouse_opacity = 0

/obj/screen/damageoverlay
	icon = 'icons/mob/screen1_full.dmi'
	icon_state = "oxydamageoverlay0"
	name = "dmg"
	screen_loc = "1,1"
	mouse_opacity = 0
	process_flag = TRUE
	layer = UI_DAMAGE_LAYER
	plane = HUD_PLANE
	var/global/image/blind_icon = image('icons/mob/screen1_full.dmi', "blackimageoverlay")


/obj/screen/damageoverlay/Process()
	update_icon()

/obj/screen/damageoverlay/update_icon()
	overlays.Cut()
	UpdateHealthState()

	underlays.Cut()
	UpdateVisionState()

/obj/screen/damageoverlay/proc/UpdateHealthState()
	var/mob/living/carbon/human/H = parentmob

	if(H.stat == UNCONSCIOUS)
		//Critical damage passage overlay
		if(H.health <= 0)
			var/image/I
			switch(H.health)
				if(-20 to -10)
					I = H.overlays_cache[1]
				if(-30 to -20)
					I = H.overlays_cache[2]
				if(-40 to -30)
					I = H.overlays_cache[3]
				if(-50 to -40)
					I = H.overlays_cache[4]
				if(-60 to -50)
					I = H.overlays_cache[5]
				if(-70 to -60)
					I = H.overlays_cache[6]
				if(-80 to -70)
					I = H.overlays_cache[7]
				if(-90 to -80)
					I = H.overlays_cache[8]
				if(-95 to -90)
					I = H.overlays_cache[9]
				if(-INFINITY to -95)
					I = H.overlays_cache[10]
			overlays += I
	else
		//Oxygen damage overlay
		if(H.oxyloss)
			var/image/I
			switch(H.oxyloss)
				if(10 to 20)
					I = H.overlays_cache[11]
				if(20 to 25)
					I = H.overlays_cache[12]
				if(25 to 30)
					I = H.overlays_cache[13]
				if(30 to 35)
					I = H.overlays_cache[14]
				if(35 to 40)
					I = H.overlays_cache[15]
				if(40 to 45)
					I = H.overlays_cache[16]
				if(45 to INFINITY)
					I = H.overlays_cache[17]
			overlays += I

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = H.getBruteLoss() + H.getFireLoss() + H.damageoverlaytemp
		H.damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/image/I
			switch(hurtdamage)
				if(10 to 25)
					I = H.overlays_cache[18]
				if(25 to 40)
					I = H.overlays_cache[19]
				if(40 to 55)
					I = H.overlays_cache[20]
				if(55 to 70)
					I = H.overlays_cache[21]
				if(70 to 85)
					I = H.overlays_cache[22]
				if(85 to INFINITY)
					I = H.overlays_cache[23]
			overlays += I

/obj/screen/damageoverlay/proc/UpdateVisionState()
	if(parentmob.eye_blind)
		underlays |= list(blind_icon)
//	else
//		underlays.Remove(list(blind_icon))
//	world << underlays.len

/obj/screen/frippery
	name = ""
	layer = HUD_LAYER

/obj/screen/frippery/New(_icon_state,_screen_loc = "7,7", mob/living/_parentmob)
	src.parentmob = _parentmob
	src.screen_loc = _screen_loc
	src.icon_state = _icon_state

/obj/screen/glasses_overlay
	icon = null
	name = "glasses"
	screen_loc = "1,1"
	mouse_opacity = 0
	process_flag = TRUE
	layer = 17 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.
	plane = HUD_PLANE


/obj/screen/glasses_overlay/Process()
	update_icon()
	return

/obj/screen/glasses_overlay/update_icon()
	overlays.Cut()
	var/mob/living/carbon/human/H = parentmob
	if(istype(H.glasses, /obj/item/clothing/glasses))
		var/obj/item/clothing/glasses/G = H.glasses
		if (G.active && G.overlay)//check here need if someone want call this func directly
			overlays |= G.overlay

	if(istype(H.wearing_rig,/obj/item/weapon/rig))
		var/obj/item/clothing/glasses/G = H.wearing_rig.getCurrentGlasses()
		if (G && H.wearing_rig.visor.active)
			overlays |= G.overlay

//-----------------------toggle_invetory------------------------------
/obj/screen/toggle_invetory
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "b-open"
	name = "toggle invetory"
	screen_loc = "1,0"

/obj/screen/toggle_invetory/proc/hideobjects()
	for (var/obj/screen/HUDelement in parentmob.HUDinventory)
		if (HUDelement.hideflag & TOGGLE_INVENTORY_FLAG)
			HUDelement.invisibility = 101
			hidden_inventory_update(HUDelement)
	for (var/obj/screen/HUDelement in parentmob.HUDfrippery)
		if (HUDelement.hideflag & TOGGLE_INVENTORY_FLAG)
			HUDelement.invisibility = 101

/obj/screen/toggle_invetory/proc/showobjects()
	for (var/obj/screen/HUDelement in parentmob.HUDinventory)
		HUDelement.invisibility = 0
		hidden_inventory_update(HUDelement)
	for (var/obj/screen/HUDelement in parentmob.HUDfrippery)
		HUDelement.invisibility = 0

/obj/screen/toggle_invetory/Click()

	if(parentmob.inventory_shown)
		parentmob.inventory_shown = FALSE
		hideobjects()
	else
		parentmob.inventory_shown = TRUE
		showobjects()

	//parentmob.hud_used.hidden_inventory_update()
	return





/obj/screen/toggle_invetory/proc/hidden_inventory_update(obj/screen/inventory/inv_elem)
	var/mob/living/carbon/human/H = parentmob
	switch (inv_elem.slot_id)
		if(slot_head)
			if(H.head)      H.head.screen_loc =     (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_shoes)
			if(H.shoes)     H.shoes.screen_loc =     (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_l_ear)
			if(H.l_ear)     H.l_ear.screen_loc =     (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_r_ear)
			if(H.r_ear)     H.r_ear.screen_loc =     (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_gloves)
			if(H.gloves)    H.gloves.screen_loc =    (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_glasses)
			if(H.glasses)   H.glasses.screen_loc =   (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_w_uniform)
			if(H.w_uniform) H.w_uniform.screen_loc = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_wear_suit)
			if(H.wear_suit) H.wear_suit.screen_loc = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_wear_mask)
			if(H.wear_mask) H.wear_mask.screen_loc = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
//-----------------------toggle_invetory End------------------------------
