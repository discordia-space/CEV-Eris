 /*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should69ot appear anywhere "in-69ame".
	They are used with the client/screen list and the screen_loc69ar.
	For69ore information, see the byond documentation on the screen_loc and screen69ars.
*/
/ima69e/no_recolor
	appearance_fla69s = RESET_COLOR


/obj/screen
	name = ""
	icon = 'icons/mob/screen1.dmi'
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE
	unacidable = 1
	var/obj/master =69ull //A reference to the object in the slot. 69rabs or items, 69enerally.
	var/mob/livin69/parentmob
	var/process_fla69 = FALSE
	var/hidefla69 = 0
	var/list/ima69e/ovrls = list()

/obj/screen/New(_name = "unnamed",69ob/livin69/_parentmob, _icon, _icon_state)//(_name = "unnamed", _screen_loc = "7,7",69ob/livin69/_parentmob, _icon, _icon_state)
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
	master =69ull
	return ..()

/obj/screen/update_plane()
	return

/obj/screen/set_plane(var/np)
	plane =69p


/obj/screen/Click(location, control, params)
	if(!usr)
		return TRUE

	switch(name)

		if("e69uip")
			if(ishuman(usr))
				var/mob/livin69/carbon/human/H = usr
				H.69uick_e69uip()

		if("Reset69achine")
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
		if(istype(master, /obj/item/stora69e))
			var/obj/item/stora69e/S =69aster
			S.close(usr)
	return TRUE
//--------------------------------------------------close end---------------------------------------------------------


//--------------------------------------------------69RAB---------------------------------------------------------
/obj/screen/69rab
	name = "69rab"

/obj/screen/69rab/Click()
	if(master)
		var/obj/item/69rab/69 =69aster
		69.s_click(src)
		return TRUE

/obj/screen/69rab/attack_hand()
	return

/obj/screen/69rab/attackby()
	return
//-----------------------------------------------69RAB END---------------------------------------------------------





//-----------------------------------------------ITEM ACTION---------------------------------------------------------
/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Destroy()
	. = ..()
	owner =69ull

/obj/screen/item_action/Click()
	if(!usr || !owner)
		return TRUE
	if(!usr.can_click())
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.weakened)
		return TRUE

	if(!(owner in usr))
		return TRUE

	owner.ui_action_click(usr,69ame)
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

	var/mob/livin69/M = owner.loc
	if(M.client &&69.69et_active_hand() == owner)
		if(M.client.prefs.UI_compact_style)
			screen_loc =69inloc
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
	name = "dama69e zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel

/obj/screen/zone_sel/Click(location, control, params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL69"icon-x"69)
	var/icon_y = text2num(PL69"icon-y6969)
	var/selectin69

	switch(icon_y)
		if(1 to 9) //Le69s
			switch(icon_x)
				if(10 to 15)
					selectin69 = BP_R_LE69
				if(17 to 22)
					selectin69 = BP_L_LE69
				else
					return TRUE
		if(10 to 13) //Arms and 69roin
			switch(icon_x)
				if(8 to 11)
					selectin69 = BP_R_ARM
				if(12 to 20)
					selectin69 = BP_69ROIN
				if(21 to 24)
					selectin69 = BP_L_ARM
				else
					return TRUE
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					selectin69 = BP_R_ARM
				if(12 to 20)
					selectin69 = BP_CHEST
				if(21 to 24)
					selectin69 = BP_L_ARM
				else
					return TRUE
		if(23 to 30) //Head, but we69eed to check for eye or69outh
			if(icon_x in 12 to 20)
				selectin69 = BP_HEAD
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							selectin69 = BP_MOUTH
					if(25 to 27)
						if(icon_x in 14 to 18)
							selectin69 = BP_EYES

	set_selected_zone(selectin69)
	return TRUE

/obj/screen/zone_sel/New()
	..()
	update_icon()

/obj/screen/zone_sel/update_icon()
	cut_overlays()
	overlays += ima69e('icons/mob/zone_sel.dmi', "69parentmob.tar69eted_or69a6969")

/obj/screen/zone_sel/proc/set_selected_zone(bodypart)
	var/old_selectin69 = parentmob.tar69eted_or69an
	if(old_selectin69 != bodypart)
		parentmob.tar69eted_or69an = bodypart
		update_icon()
//--------------------------------------------------ZONE SELECT END---------------------------------------------------------

/obj/screen/text
	icon =69ull
	icon_state =69ull
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_hei69ht = 480
	maptext_width = 480


/obj/screen/stora69e
	name = "stora69e"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/stora69e/Click()
	if(!usr.can_click())
		return TRUE
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return TRUE
	if(master)
		var/obj/item/I = usr.69et_active_hand()
		if(I)
			usr.ClickOn(master)
	return TRUE

//--------------------------------------------------inventory---------------------------------------------------------
/obj/screen/inventory
	var/slot_id //The indentifier for the slot. It has69othin69 to do with ID cards.
	icon = 'icons/mob/screen/ErisStyle.dmi'
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/inventory/New(_name = "unnamed", _slot_id =69ull, _icon =69ull, _icon_state =69ull, _parentmob =69ull)//(_name = "unnamed", _screen_loc = "7,7", _slot_id =69ull, _icon =69ull, _icon_state =69ull, _parentmob =69ull)
	name = _name
//	screen_loc = _screen_loc
	icon = _icon
	slot_id = _slot_id
	icon_state = _icon_state
	parentmob = _parentmob

/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a69iddle click
	if(!usr.can_click()) return TRUE
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened) return TRUE
	switch(name)
		if("hand") usr:swap_hand()
		else usr.attack_ui(slot_id)
	return TRUE

/obj/screen/inventory/hand
	name = "nonamehand"

/obj/screen/inventory/hand/New()
	..()
	ovrls69"act_hand6969 +=69ew /ima69e/no_recolor (icon = icon, icon_state ="act_hand69slot_id==slot_l_hand ? "-l" : "-69"69")
	update_icon()

/obj/screen/inventory/hand/Click()
	var/mob/livin69/carbon/C = parentmob
	if (slot_id == slot_l_hand) C.activate_hand("l")
	else C.activate_hand("r")

/obj/screen/inventory/hand/update_icon()
	overlays -= ovrls69"act_hand6969
	if (slot_id == (parentmob.hand ? slot_l_hand : slot_r_hand))
		overlays += ovrls69"act_hand6969
/*	if (slot_id == (parentmob.hand ? slot_l_hand : slot_r_hand)) // if display left
		icon_state = "act_hand69slot_id==slot_l_hand ? "-l" : "-r6969"
	else
		icon_state = "hand69slot_id==slot_l_hand ? "-l" : "-r6969"*/
//--------------------------------------------------inventory end---------------------------------------------------------

//--------------------------------------------------health---------------------------------------------------------
/obj/screen/health
	name = "health"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "health0"
	screen_loc = "15,7"
	process_fla69 = TRUE

/obj/screen/health/New()
	..()
	ovrls69"health06969 +=69ew/ima69e(icon = icon, icon_state ="health0")
	ovrls69"health16969 +=69ew/ima69e/no_recolor(icon = icon, icon_state ="health1")
	ovrls69"health26969 +=69ew/ima69e/no_recolor(icon = icon, icon_state ="health2")
	ovrls69"health36969 +=69ew/ima69e/no_recolor(icon = icon, icon_state ="health3")
	ovrls69"health46969 +=69ew/ima69e/no_recolor(icon = icon, icon_state ="health4")
	ovrls69"health56969 +=69ew/ima69e/no_recolor(icon = icon, icon_state ="health5")
	ovrls69"health66969 +=69ew/ima69e/no_recolor(icon = icon, icon_state ="health6")
	ovrls69"health76969 +=69ew/ima69e(icon = icon, icon_state ="health7")
	update_icon()

/obj/screen/health/Process()
	update_icon()

/obj/screen/health/update_icon()
	if(parentmob:stat != DEAD)
		cut_overlays()
		if (parentmob:anal69esic >= 100)
//			icon_state = "health_numb"
			overlays += ovrls69"health06969
		else
			var/mob/livin69/carbon/parentmobC = parentmob	// same parent69ob but in correct type for accessin69 to species
			switch(100 - ((parentmobC.species.fla69s &69O_PAIN) ? 0 : parentmob.traumatic_shock))
				if(100 to INFINITY)		overlays += ovrls69"health06969
				if(80 to 100)			overlays += ovrls69"health16969
				if(60 to 80)			overlays += ovrls69"health26969
				if(40 to 60)			overlays += ovrls69"health36969
				if(20 to 40)			overlays += ovrls69"health46969
				if(0 to 20)				overlays += ovrls69"health56969
				else					overlays += ovrls69"health66969

/obj/screen/health/DEADelize()
	cut_overlays()
	overlays += ovrls69"health76969

/obj/screen/health/Click()
	if(ishuman(parentmob))
		var/mob/livin69/carbon/human/H = parentmob
		H.check_self_for_injuries()

//--------------------------------------------------health end---------------------------------------------------------
//--------------------------------------------------sanity---------------------------------------------------------
/obj/screen/sanity
	name = "sanity"
	icon_state = "blank"

/obj/screen/sanity/New()
	..()
	ovrls69"sanity06969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "sanity0")
	ovrls69"sanity16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "sanity1")
	ovrls69"sanity26969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "sanity2")
	ovrls69"sanity36969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "sanity3")
	ovrls69"sanity46969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "sanity4")
	ovrls69"sanity56969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "sanity5")
	ovrls69"sanity66969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "sanity6")
	update_icon()

/obj/screen/sanity/update_icon()
	var/mob/livin69/carbon/human/H = parentmob
	if(!istype(H) || H.stat == DEAD)
		return

	cut_overlays()
	var/ima69e/ovrl

	if (H.sanity?.max_level > 0)
		switch(H.sanity.level / H.sanity.max_level)
			if(-INFINITY to 0)
				overlays += ovrls69"sanity66969
				return
			if(1 to INFINITY)
				ovrl = ovrls69"sanity06969
			if(0.8 to 1)
				ovrl = ovrls69"sanity16969
			if(0.6 to 0.8)
				ovrl = ovrls69"sanity26969
			if(0.4 to 0.6)
				ovrl = ovrls69"sanity36969
			if(0.2 to 0.4)
				ovrl = ovrls69"sanity46969
			if(0 to 0.2)
				ovrl = ovrls69"sanity56969
	else
		overlays += ovrls69"sanity66969
		return

	switch(H.sanity.insi69ht)
		if(-INFINITY to 20)
			ovrl.color = "#a6a6a6"
		if(20 to 40)
			ovrl.color = "#09ed01"
		if(40 to 60)
			ovrl.color = "#ff7200"
		if(60 to 80)
			ovrl.color = "#0054ff"
		if(80 to INFINITY)
			ovrl.color = "#9040e0"

	overlays += ovrl

/obj/screen/sanity/DEADelize()
	cut_overlays()
	overlays += ovrls69"sanity06969

/obj/screen/sanity/Click()
	if(!ishuman(parentmob))
		return FALSE
	var/mob/livin69/carbon/human/H = parentmob
	H.ui_interact(H)
	return	TRUE

//--------------------------------------------------sanity end---------------------------------------------------------
//--------------------------------------------------nsa---------------------------------------------------------
/obj/screen/nsa
	name = "nsa"
	icon_state = "blank"

/obj/screen/nsa/New()
	..()
	ovrls69"nsa06969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa0")
	ovrls69"nsa16969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa1")
	ovrls69"nsa26969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa2")
	ovrls69"nsa36969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa3")
	ovrls69"nsa46969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa4")
	ovrls69"nsa56969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa5")
	ovrls69"nsa66969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa6")
	ovrls69"nsa76969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa7")
	ovrls69"nsa86969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa8")
	ovrls69"nsa96969  +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa9")
	ovrls69"nsa106969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "nsa10")
	update_icon()

/obj/screen/nsa/update_icon()
	var/mob/livin69/carbon/C = parentmob
	if(!istype(C) || C.stat == DEAD)
		return
	cut_overlays()
	switch(C.metabolism_effects.69et_nsa())
		if(200 to INFINITY)
			overlays += ovrls69"nsa106969
		if(-INFINITY to 20)
			overlays += ovrls69"nsa06969
		if(20 to 40)
			overlays += ovrls69"nsa16969
		if(40 to 60)
			overlays += ovrls69"nsa26969
		if(60 to 80)
			overlays += ovrls69"nsa36969
		if(80 to 100)
			overlays += ovrls69"nsa46969
		if(100 to 120)
			overlays += ovrls69"nsa56969
		if(120 to 140)
			overlays += ovrls69"nsa66969
		if(140 to 160)
			overlays += ovrls69"nsa76969
		if(160 to 180)
			overlays += ovrls69"nsa86969
		if(180 to 200)
			overlays += ovrls69"nsa96969

/obj/screen/nsa/DEADelize()
	cut_overlays()
	overlays += ovrls69"nsa06969

//--------------------------------------------------nsa end---------------------------------------------------------
//--------------------------------------------------nutrition---------------------------------------------------------
/obj/screen/nutrition
	name = "nutrition"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	screen_loc = "15,6"
	process_fla69 = TRUE

/obj/screen/nutrition/New()
	..()
	ovrls69"nutrition06969 +=69ew /ima69e (icon = src.icon, icon_state ="nutrition0")
	ovrls69"nutrition16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="nutrition1")
	ovrls69"nutrition26969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="nutrition2")
	ovrls69"nutrition36969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="nutrition3")
	ovrls69"nutrition46969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="nutrition4")
	update_icon()

/obj/screen/nutrition/Process()
	//var/mob/livin69/carbon/human/H = parentmob
	update_icon()

/obj/screen/nutrition/update_icon()
	set src in usr.client.screen
	var/mob/livin69/carbon/human/H = parentmob
	cut_overlays()
	switch(H.nutrition)
		if(450 to INFINITY)				overlays += ovrls69"nutrition06969
		if(350 to 450)					overlays += ovrls69"nutrition16969
		if(250 to 350)					overlays += ovrls69"nutrition26969
		if(150 to 250)					overlays += ovrls69"nutrition36969
		else							overlays += ovrls69"nutrition46969

/obj/screen/nutrition/DEADelize()
	cut_overlays()
	overlays += ovrls69"nutrition46969
//--------------------------------------------------nutrition end---------------------------------------------------------

//--------------------------------------------------bodytemp---------------------------------------------------------
/obj/screen/bodytemp
	name = "bodytemp"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	screen_loc = "15,8"
	process_fla69 = TRUE


/obj/screen/bodytemp/New()
	..()
	ovrls69"temp06969 +=69ew /ima69e/no_recolor (icon = src.icon, icon_state ="temp0")
	ovrls69"temp16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="temp1")
	ovrls69"temp26969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="temp2")
	ovrls69"temp36969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="temp3")
	ovrls69"temp46969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="temp4")
	ovrls69"temp-16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="temp-1")
	ovrls69"temp-26969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="temp-2")
	ovrls69"temp-36969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="temp-3")
	ovrls69"temp-46969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="temp-4")
	update_icon()

/obj/screen/bodytemp/Process()
	update_icon()


/obj/screen/bodytemp/update_icon()
	//TODO: precalculate all of this stuff when the species datum is created
	var/mob/livin69/carbon/parentmobC = parentmob	// same parent69ob but in correct type for accessin69 to species
	var/base_temperature = parentmobC.species.body_temperature
	if(base_temperature ==69ull) //some species don't have a set69etabolic temperature
		base_temperature = (parentmobC.species.heat_level_1 + parentmobC.species.cold_level_1)/2

	var/temp_step
	cut_overlays()
	if (parentmob:bodytemperature >= base_temperature)
		temp_step = (parentmobC.species.heat_level_1 - base_temperature)/4

		if (parentmob:bodytemperature >= parentmobC.species.heat_level_1)
			overlays += ovrls69"temp46969
		else if (parentmob:bodytemperature >= base_temperature + temp_step*3)
			overlays += ovrls69"temp36969
		else if (parentmob:bodytemperature >= base_temperature + temp_step*2)
			overlays += ovrls69"temp26969
		else if (parentmob:bodytemperature >= base_temperature + temp_step*1)
			overlays += ovrls69"temp16969
		else
			overlays += ovrls69"temp06969

	else if (parentmob:bodytemperature < base_temperature)
		temp_step = (base_temperature - parentmobC.species.cold_level_1)/4

		if (parentmob:bodytemperature <= parentmobC.species.cold_level_1)
			overlays += ovrls69"temp-46969
		else if (parentmob:bodytemperature <= base_temperature - temp_step*3)
			overlays += ovrls69"temp-36969
		else if (parentmob:bodytemperature <= base_temperature - temp_step*2)
			overlays += ovrls69"temp-26969
		else if (parentmob:bodytemperature <= base_temperature - temp_step*1)
			overlays += ovrls69"temp-16969
		else
			overlays += ovrls69"temp06969

/obj/screen/bodytemp/DEADelize()
	cut_overlays()
	overlays += ovrls69"temp-46969
//--------------------------------------------------bodytemp end---------------------------------------------------------


//--------------------------------------------------pressure---------------------------------------------------------
/obj/screen/pressure
	name = "pressure"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	screen_loc = "15,13"
	process_fla69 = TRUE

/obj/screen/pressure/New()
	..()
	ovrls69"pressure26969 +=69ew /ima69e/no_recolor (icon = src.icon, icon_state ="pressure2")
	ovrls69"pressure16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="pressure1")
	ovrls69"pressure06969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="pressure0")
	ovrls69"pressure-16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="pressure-1")
	ovrls69"pressure-26969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="pressure-2")
	update_icon()


/obj/screen/pressure/Process()
	update_icon()

/obj/screen/pressure/update_icon()
	var/mob/livin69/carbon/human/H = parentmob
//	icon_state = "pressure69H.pressure_aler6969"
	cut_overlays()
	overlays += ovrls69"pressure69H.pressure_ale69t69"69

/obj/screen/pressure/DEADelize()
	cut_overlays()
	overlays += ovrls69"pressure-26969
//--------------------------------------------------pressure end---------------------------------------------------------

//--------------------------------------------------toxin---------------------------------------------------------
/obj/screen/toxin
	name = "toxin"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "tox0"
	screen_loc = "15,10"
	process_fla69 = 1

/obj/screen/toxin/New()
	..()
	ovrls69"tox16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="tox1")
	update_icon()

/obj/screen/toxin/Process()
	update_icon()

/obj/screen/toxin/update_icon()
	var/mob/livin69/carbon/human/H = parentmob
	cut_overlays()
	if(H.plasma_alert)
		overlays += ovrls69"tox16969
//		icon_state = "tox1"
//	else
//		icon_state = "tox0"

/obj/screen/toxin/DEADelize()
	cut_overlays()
	overlays += ovrls69"tox16969
//--------------------------------------------------toxin end---------------------------------------------------------

//--------------------------------------------------oxy69en---------------------------------------------------------

/obj/screen/oxy69en
	name = "oxy69en"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "oxy0"
	screen_loc = "15,12"
	process_fla69 = TRUE

/obj/screen/oxy69en/New()
	..()
	ovrls69"oxy16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="oxy1")
//	ovrls69"oxy06969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="oxy0")
	update_icon()

/obj/screen/oxy69en/Process()
	update_icon()

/obj/screen/oxy69en/update_icon()
	var/mob/livin69/carbon/human/H = parentmob
	cut_overlays()
	if(H.oxy69en_alert)
		overlays += ovrls69"oxy16969
//		icon_state = "oxy1"
//	else
//		icon_state = "oxy0"

/obj/screen/oxy69en/DEADelize()
	cut_overlays()
	overlays += ovrls69"oxy16969
//--------------------------------------------------oxy69en end---------------------------------------------------------

//--------------------------------------------------fire---------------------------------------------------------
/obj/screen/fire
	name = "fire"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	screen_loc = "15,9"
	process_fla69 = TRUE


/obj/screen/fire/New()
	..()
	ovrls69"fire16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state ="fire1")
	ovrls69"fire06969 +=69ew /ima69e(icon = src.icon, icon_state ="fire0")
	update_icon()
//	ovrl.appearance_fla69s = RESET_COLOR

/obj/screen/fire/Process()
	update_icon()

/obj/screen/fire/update_icon()
	var/mob/livin69/carbon/human/H = parentmob
	src.cut_overlays()
	overlays += ovrls69"fire69H.fire_alert ==69169"69

obj/screen/fire/DEADelize()
	cut_overlays()
	overlays += ovrls69"fire06969
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
	icon_state = "blank"
	screen_loc = "15,14"

/obj/screen/internal/New()
	..()
	ovrls69"internal06969 +=69ew /ima69e(icon = src.icon, icon_state = "internal0")
	ovrls69"internal16969 +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = "internal1")
	update_icon()

/obj/screen/internal/Click()
//	if("internal")
	if(iscarbon(parentmob))
		var/mob/livin69/carbon/C = parentmob
		if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
			if(C.internal)
				C.internal =69ull
				to_chat(C, SPAN_NOTICE("No lon69er runnin69 on internals."))
				update_icon()
			else

				var/no_mask
				if(!(C.wear_mask && C.wear_mask.item_fla69s & AIRTI69HT))
					var/mob/livin69/carbon/human/H = C
					if(!(H.head && H.head.item_fla69s & AIRTI69HT))
						no_mask = 1

				if(no_mask)
					to_chat(C, SPAN_NOTICE("You are69ot wearin69 a suitable69ask or helmet."))
					return TRUE
				else
					var/list/nicename =69ull
					var/list/tankcheck =69ull
					var/breathes = "oxy69en"    //default, we'll check later
					var/list/contents = list()
					var/from = "on"

					if(ishuman(C))
						var/mob/livin69/carbon/human/H = C
						breathes = H.species.breath_type
						nicename = list ("suit", "back", "belt", "ri69ht hand", "left hand", "left pocket", "ri69ht pocket")
						tankcheck = list (H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
					else
						nicename = list("ri69ht hand", "left hand", "back")
						tankcheck = list(C.r_hand, C.l_hand, C.back)

					// Ri69s are a fuckin69 pain since they keep an air tank in69ullspace.
					if(istype(C.back,/obj/item/ri69))
						var/obj/item/ri69/ri69 = C.back
						if(ri69.air_supply)
							from = "in"
							nicename |= "hardsuit"
							tankcheck |= ri69.air_supply

					for(var/i=1, i<tankcheck.len+1, ++i)
						if(istype(tankcheck696969, /obj/item/tank))
							var/obj/item/tank/t = tankcheck696969
							if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc, breathes))
								contents.Add(t.air_contents.total_moles)	//Someone69essed with the tank and put unknown 69asses
								continue					//in it, so we're 69oin69 to believe the tank is what it says it is
							switch(breathes)
																//These tanks we're sure of their contents
								if("nitro69en") 							//So we're a bit69ore picky about them.

									if(t.air_contents.69as69"nitro69en6969 && !t.air_contents.69as69"oxy69e69"69)
										contents.Add(t.air_contents.69as69"nitro69en6969)
									else
										contents.Add(0)

								if ("oxy69en")
									if(t.air_contents.69as69"oxy69en6969 && !t.air_contents.69as69"plasm69"69)
										contents.Add(t.air_contents.69as69"oxy69en6969)
									else if(istype(t, /obj/item/tank/onestar_re69enerator))
										contents.Add(BREATH_MOLES*2)
									else
										contents.Add(0)

								//69o races breath this, but69ever know about downstream servers.
								if ("carbon dioxide")
									if(t.air_contents.69as69"carbon_dioxide6969 && !t.air_contents.69as69"plasm69"69)
										contents.Add(t.air_contents.69as69"carbon_dioxide6969)
									else
										contents.Add(0)


						else
							//no tank so we set contents to 0
							contents.Add(0)

					//Alri69ht69ow we know the contents of the tanks so we have to pick the best one.

					var/best = 0
					var/bestcontents = 0
					for(var/i=1, i <  contents.len + 1 , ++i)
						if(!contents696969)
							continue
						if(contents696969 > bestcontents)
							best = i
							bestcontents = contents696969


					//We've determined the best container69ow we set it as our internals

					if(best)
						to_chat(C, SPAN_NOTICE("You are69ow runnin69 on internals from 69tankcheck69be69696969 69f69om69 your 69nicename66969est6969."))
						playsound(usr, 'sound/effects/Custom_internals.o6969', 50, -5)
						C.internal = tankcheck69bes6969

					if(!C.internal)
						to_chat(C, "<span class='notice'>You don't have a69breathes=="oxy69en" ? "n oxy69en" : addtext(" ", breathes6969 tank.</span>")
					update_icon()

/obj/screen/internal/update_icon()
	cut_overlays()
	if(parentmob:internal)
		overlays += ovrls69"internal16969
	else
		overlays += ovrls69"internal06969

/obj/screen/internal/DEADelize()
	cut_overlays()
//-----------------------internal END------------------------------

//-----------------------jump------------------------------
/obj/screen/jump
	name = "jump"
	icon_state = "jump"
	layer = HUD_LAYER
	plane = HUD_PLANE
//-----------------------jump END------------------------------
//-----------------------look up------------------------------
/obj/screen/look_up
	name = "look up"
	icon_state = "look_up"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/look_up/Click()
	var/mob/livin69/carbon/human/H = parentmob
	if(istype(H))
		H.lookup()
//-----------------------look up END------------------------------

//-----------------------wield------------------------------
/obj/screen/wield
	name = "wield"
	icon_state = "wield"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/wield/Click()
	var/mob/livin69/carbon/human/H = parentmob
	H.do_wield()
//-----------------------wield END------------------------------
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
	usr.stop_pullin69()
	//update_icon()
	//icon_state = "pull0"

/obj/screen/pull/update_icon()
	if (parentmob.pullin69)
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
		//usr.verbs += /obj/screen/HUDthrow/verb/to6969le_throw_mode()
		if(usr.client)
			usr.client.screen += src*/
	..()
	update_icon()

/obj/screen/HUDthrow/Click()
	parentmob.to6969le_throw_mode()
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
	if(islivin69(parentmob))
		var/mob/livin69/L = parentmob
		L.resist()


//-----------------------resist END------------------------------
//-----------------------rest------------------------------
/obj/screen/rest
	name = "rest"
	icon_state = "rest"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/rest/Click()
	parentmob.lay_down()
//-----------------------rest END------------------------------
//-----------------------mov_intent------------------------------
/obj/screen/mov_intent
	name = "mov_intent"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "runnin69"
	screen_loc = "14,1"


/obj/screen/mov_intent/Click()
	var/move_intent_type =69ext_list_item(usr.move_intent.type, usr.move_intents)
	var/decl/move_intent/newintent = decls_repository.69et_decl(move_intent_type)
	if (newintent.can_enter(parentmob, TRUE))
		parentmob.move_intent =69ewintent
		SEND_SI69NAL(parentmob, COMSI69_HUMAN_WALKINTENT_CHAN69E, parentmob,69ewintent)
		update_icon()

	update_icon()

/obj/screen/mov_intent/New()
	..()
	update_icon()

/obj/screen/mov_intent/update_icon()
	icon_state = parentmob.move_intent.hud_icon_state

//-----------------------mov_intent END------------------------------
/obj/screen/e69uip
	name = "e69uip"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "act_e69uip"
	screen_loc = "8,2"

/obj/screen/e69uip/Click()
	if(ishuman(parentmob))
		var/mob/livin69/carbon/human/H = parentmob
		H.69uick_e69uip()
//-----------------------swap------------------------------
/obj/screen/swap
	name = "swap hand"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "swap-l"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/swap/New()
	..()
	overlays += ima69e(icon = src.icon, icon_state =  "swap-r", pixel_x = 32)

/obj/screen/swap/Click()
	parentmob.swap_hand()
//-----------------------swap END------------------------------
//-----------------------bionics------------------------------
/obj/screen/bionics
	name = "bionics"
	icon_state = "bionics"
	layer = HUD_LAYER
	plane = HUD_PLANE
	var/tar69et_or69an

/obj/screen/bionics/New()
	..()
	update_icon()

/obj/screen/bionics/l_arm
	tar69et_or69an = BP_L_ARM

/obj/screen/bionics/r_arm
	tar69et_or69an = BP_R_ARM

/obj/screen/bionics/update_icon()
	var/mob/livin69/carbon/human/H = parentmob
	if(istype(H))
		var/obj/item/or69an/external/E = H.or69ans_by_name69tar69et_or69a6969
		if(E?.module)
			invisibility = 0
			return
	invisibility = 101

/obj/screen/bionics/Click()
	var/mob/livin69/carbon/human/H = parentmob
	if(istype(H))
		var/obj/item/or69an/external/E = H.or69ans_by_name69tar69et_or69a6969
		E?.module?.activate(H, E)
//-----------------------bionics (implant)------------------------------
/obj/screen/implant_bionics
	name = "implant bionics"
	icon_state = "bionics_implant"
	layer = HUD_LAYER
	plane = HUD_PLANE
//-----------------------bionics END------------------------------
//-----------------------craft69enu------------------------------
/obj/screen/craft_menu
	name = "craft69enu"
	icon_state = "craft_menu"
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/craft_menu/Click()
	parentmob.open_craft_menu()
//-----------------------craft69enu END------------------------------
//-----------------------intent------------------------------
/obj/screen/intent
	name = "intent"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "full"
	screen_loc = "8,2"

/obj/screen/intent/New()
	..()
	ovrls69"disarm6969 +=69ew /ima69e/no_recolor (icon = src.icon, icon_state ="disarm")
	ovrls69"harm6969 +=69ew /ima69e/no_recolor (icon = src.icon, icon_state ="harm")
	ovrls69"69rab6969 +=69ew /ima69e/no_recolor (icon = src.icon, icon_state ="69rab")
	ovrls69"help6969 +=69ew /ima69e/no_recolor (icon = src.icon, icon_state ="help")
	update_icon()

/obj/screen/intent/Click(location, control, params)
	var/_x = text2num(params2list(params)69"icon-x6969)
	var/_y = text2num(params2list(params)69"icon-y6969)
	if(_x<=16 && _y<=16)
		parentmob.a_intent_chan69e(I_HURT)
	if(_x<=16 && _y>=17)
		parentmob.a_intent_chan69e(I_HELP)
	if(_x>=17 && _y<=16)
		parentmob.a_intent_chan69e(I_69RAB)
	if(_x>=17 && _y>=17)
		parentmob.a_intent_chan69e(I_DISARM)
	SEND_SI69NAL(parentmob, COMSI69_HUMAN_ACTIONINTENT_CHAN69E, parentmob)

/obj/screen/intent/update_icon()
	src.cut_overlays()
	switch (parentmob.a_intent)
		if(I_HELP)
			src.overlays += ovrls69"help6969
		if(I_HURT)
			src.overlays += ovrls69"harm6969
		if(I_69RAB)
			src.overlays += ovrls69"69rab6969
		if(I_DISARM)
			src.overlays += ovrls69"disarm6969
//-----------------------intent END------------------------------

/obj/screen/fastintent
	name = "fastintent"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "blank"
	var/tar69et_intent

/obj/screen/fastintent/New()
	..()
	src.overlays +=69ew /ima69e/no_recolor(icon = src.icon, icon_state = src.icon_state)

/obj/screen/fastintent/Click()
	parentmob.a_intent_chan69e(tar69et_intent)

/obj/screen/fastintent/help
	tar69et_intent = I_HELP
	icon_state = "intent_help"

/obj/screen/fastintent/harm
	tar69et_intent = I_HURT
	icon_state = "intent_harm"

/obj/screen/fastintent/69rab
	tar69et_intent = I_69RAB
	icon_state = "intent_69rab"

/obj/screen/fastintent/disarm
	tar69et_intent = I_DISARM
	icon_state = "intent_disarm"



/obj/screen/dru69overlay
	icon_state = "blank"
	name = "dru69s"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	mouse_opacity = 0
	process_fla69 = TRUE
	layer = 17 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.
	plane = HUD_PLANE
//	var/69lobal/ima69e/blind_icon = ima69e('icons/mob/screen1_full.dmi', "blackima69eoverlay")

/obj/screen/dru69overlay/Process()
	update_icon()

/obj/screen/dru69overlay/update_icon()
	underlays.Cut()
	if (parentmob.disabilities &69EARSI69HTED)
		var/obj/item/clothin69/69lasses/69 = parentmob.69et_e69uipped_item(slot_69lasses)
		if(!69 || !69.prescription)
			underlays += 69lobal_hud.vimpaired
	if (parentmob.eye_blurry)
		underlays += 69lobal_hud.blurry
	if (parentmob.dru6969y)
		underlays += 69lobal_hud.dru6969y


/obj/screen/full_1_tile_overlay
	name = "full_1_tile_overlay"
	icon_state = "blank"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	layer = 21
	plane = HUD_PLANE
	mouse_opacity = 0

/obj/screen/dama69eoverlay
	icon = 'icons/mob/screen1_full.dmi'
	icon_state = "oxydama69eoverlay0"
	name = "dm69"
	screen_loc = "1,1:-32"
	mouse_opacity = 0
	process_fla69 = TRUE
	layer = UI_DAMA69E_LAYER
	plane = HUD_PLANE
	var/69lobal/ima69e/blind_icon = ima69e('icons/mob/screen1_full.dmi', "blackima69eoverlay")


/obj/screen/dama69eoverlay/Process()
	update_icon()

/obj/screen/dama69eoverlay/update_icon()
	cut_overlays()
	UpdateHealthState()

	underlays.Cut()
	UpdateVisionState()

/obj/screen/dama69eoverlay/proc/UpdateHealthState()
	var/mob/livin69/carbon/human/H = parentmob

	if(H.stat == UNCONSCIOUS)
		//Critical dama69e passa69e overlay
		if(H.health <= 0)
			var/ima69e/I
			switch(H.health)
				if(-20 to -10)
					I = H.overlays_cache696969
				if(-30 to -20)
					I = H.overlays_cache696969
				if(-40 to -30)
					I = H.overlays_cache696969
				if(-50 to -40)
					I = H.overlays_cache696969
				if(-60 to -50)
					I = H.overlays_cache696969
				if(-70 to -60)
					I = H.overlays_cache696969
				if(-80 to -70)
					I = H.overlays_cache696969
				if(-90 to -80)
					I = H.overlays_cache696969
				if(-95 to -90)
					I = H.overlays_cache696969
				if(-INFINITY to -95)
					I = H.overlays_cache6916969
			overlays += I
	else
		//Oxy69en dama69e overlay
		if(H.oxyloss)
			var/ima69e/I
			switch(H.oxyloss)
				if(10 to 20)
					I = H.overlays_cache6916969
				if(20 to 25)
					I = H.overlays_cache6916969
				if(25 to 30)
					I = H.overlays_cache6916969
				if(30 to 35)
					I = H.overlays_cache6916969
				if(35 to 40)
					I = H.overlays_cache6916969
				if(40 to 45)
					I = H.overlays_cache6916969
				if(45 to INFINITY)
					I = H.overlays_cache6916969
			overlays += I

		//Fire and Brute dama69e overlay (BSSR)
		var/hurtdama69e = H.69etBruteLoss() + H.69etFireLoss() + H.dama69eoverlaytemp
		H.dama69eoverlaytemp = 0 // We do this so we can detect if someone hits us or69ot.
		if(hurtdama69e)
			var/ima69e/I
			switch(hurtdama69e)
				if(10 to 25)
					I = H.overlays_cache6916969
				if(25 to 40)
					I = H.overlays_cache6916969
				if(40 to 55)
					I = H.overlays_cache6926969
				if(55 to 70)
					I = H.overlays_cache6926969
				if(70 to 85)
					I = H.overlays_cache6926969
				if(85 to INFINITY)
					I = H.overlays_cache6926969
			overlays += I

/obj/screen/dama69eoverlay/proc/UpdateVisionState()
	if(parentmob.eye_blind)
		underlays |= list(blind_icon)
//	else
//		underlays.Remove(list(blind_icon))
//	world << underlays.len

/obj/screen/frippery
	name = ""
	layer = HUD_LAYER

/obj/screen/frippery/New(_icon_state,_screen_loc = "7,7",69ob/livin69/_parentmob)
	src.parentmob = _parentmob
	src.screen_loc = _screen_loc
	src.icon_state = _icon_state

/obj/screen/69lasses_overlay
	icon =69ull
	name = "69lasses"
	screen_loc = "1:-32,1:-32"
	mouse_opacity = 0
	process_fla69 = TRUE
	layer = 17 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.
	plane = HUD_PLANE


/obj/screen/69lasses_overlay/Process()
	update_icon()
	return

/obj/screen/69lasses_overlay/update_icon()
	cut_overlays()
	var/mob/livin69/carbon/human/H = parentmob
	if(istype(H.69lasses, /obj/item/clothin69/69lasses))
		var/obj/item/clothin69/69lasses/69 = H.69lasses
		if (69.active && 69.overlay)//check here69eed if someone want call this func directly
			overlays |= 69.overlay

	if(istype(H.wearin69_ri69,/obj/item/ri69))
		var/obj/item/clothin69/69lasses/69 = H.wearin69_ri69.69etCurrent69lasses()
		if (69 && H.wearin69_ri69.visor.active)
			overlays |= 69.overlay

//-----------------------to6969le_invetory------------------------------
/obj/screen/to6969le_invetory
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "b-open"
	name = "to6969le inventory"
	screen_loc = "1,0"

/obj/screen/to6969le_invetory/proc/hideobjects()
	for (var/obj/screen/HUDelement in parentmob.HUDinventory)
		if (HUDelement.hidefla69 & TO6969LE_INVENTORY_FLA69)
			HUDelement.invisibility = 101
			hidden_inventory_update(HUDelement)
	for (var/obj/screen/HUDelement in parentmob.HUDfrippery)
		if (HUDelement.hidefla69 & TO6969LE_INVENTORY_FLA69)
			HUDelement.invisibility = 101

/obj/screen/to6969le_invetory/proc/showobjects()
	for (var/obj/screen/HUDelement in parentmob.HUDinventory)
		HUDelement.invisibility = 0
		hidden_inventory_update(HUDelement)
	for (var/obj/screen/HUDelement in parentmob.HUDfrippery)
		HUDelement.invisibility = 0

/obj/screen/to6969le_invetory/Click()

	if(parentmob.inventory_shown)
		parentmob.inventory_shown = FALSE
		hideobjects()
	else
		parentmob.inventory_shown = TRUE
		showobjects()

	//parentmob.hud_used.hidden_inventory_update()
	return





/obj/screen/to6969le_invetory/proc/hidden_inventory_update(obj/screen/inventory/inv_elem)
	var/mob/livin69/carbon/human/H = parentmob
	switch (inv_elem.slot_id)
		if(slot_head)
			if(H.head)      H.head.screen_loc =     (inv_elem.invisibility == 101) ?69ull : inv_elem.screen_loc
		if(slot_shoes)
			if(H.shoes)     H.shoes.screen_loc =     (inv_elem.invisibility == 101) ?69ull : inv_elem.screen_loc
		if(slot_l_ear)
			if(H.l_ear)     H.l_ear.screen_loc =     (inv_elem.invisibility == 101) ?69ull : inv_elem.screen_loc
		if(slot_r_ear)
			if(H.r_ear)     H.r_ear.screen_loc =     (inv_elem.invisibility == 101) ?69ull : inv_elem.screen_loc
		if(slot_69loves)
			if(H.69loves)    H.69loves.screen_loc =    (inv_elem.invisibility == 101) ?69ull : inv_elem.screen_loc
		if(slot_69lasses)
			if(H.69lasses)   H.69lasses.screen_loc =   (inv_elem.invisibility == 101) ?69ull : inv_elem.screen_loc
		if(slot_w_uniform)
			if(H.w_uniform) H.w_uniform.screen_loc = (inv_elem.invisibility == 101) ?69ull : inv_elem.screen_loc
		if(slot_wear_suit)
			if(H.wear_suit) H.wear_suit.screen_loc = (inv_elem.invisibility == 101) ?69ull : inv_elem.screen_loc
		if(slot_wear_mask)
			if(H.wear_mask) H.wear_mask.screen_loc = (inv_elem.invisibility == 101) ?69ull : inv_elem.screen_loc
//-----------------------to6969le_invetory End------------------------------
