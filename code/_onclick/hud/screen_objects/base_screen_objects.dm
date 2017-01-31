 /*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name = ""
	icon = 'icons/mob/screen1.dmi'
	layer = 20.0
	unacidable = 1
	var/obj/master = null //A reference to the object in the slot. Grabs or items, generally.
	var/mob/living/parentmob
	var/process_flag = 0
	var/hideflag = 0

/obj/screen/New(_name = "unnamed", _screen_loc = "7,7", mob/living/_parentmob)
	src.parentmob = _parentmob
	src.name = _name
	src.screen_loc = _screen_loc

///obj/screen/New()
//	set in usr.client.screen
//screen_loc = "[x_pos],[y_pos]"
//	world << "usr:[usr] src:[src]"
//	if(usr)
//		parentmob = usr
//		return 1
//	else
//		return 0

//	usr << hud_state
	//world << "src: [src], parent [parentmob]"

/obj/screen/process()
	return

/obj/screen/Destroy()
	master = null
	return ..()

/obj/screen/Click(location, control, params)
	if(!usr)	return 1
	switch(name)
/*		if("toggle")
			//if(usr.hud_used.inventory_shown)
			//	usr.hud_used.inventory_shown = 0
			//	usr.client.screen -= usr.hud_used.other
			//else
			//	usr.hud_used.inventory_shown = 1
			//	usr.client.screen += usr.hud_used.other

			//usr.hud_used.hidden_inventory_update()
			return*/

		if("equip")
			if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
				return 1
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()

		if("Reset Machine")
			usr.unset_machine()
//		if("act_intent")
//			usr.a_intent_change("right")
		/*if(I_HELP)
			usr.a_intent = I_HELP
			usr.hud_used.action_intent.icon_state = "intent_help"
		if(I_HURT)
			usr.a_intent = I_HURT
			usr.hud_used.action_intent.icon_state = "intent_harm"
		if(I_GRAB)
			usr.a_intent = I_GRAB
			usr.hud_used.action_intent.icon_state = "intent_grab"
		if(I_DISARM)
			usr.a_intent = I_DISARM
			usr.hud_used.action_intent.icon_state = "intent_disarm"*/

/*		if("module")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
//				if(R.module)
//					R.hud_used.toggle_show_robot_modules()
//					return 1
				R.pick_module()

		if("inventory")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
//					R.hud_used.toggle_show_robot_modules()
					return 1
				else
					R << "You haven't selected a module yet."*/

/*		if("radio")
			if(issilicon(usr))
				usr:radio_menu()
		if("panel")
			if(issilicon(usr))
				usr:installed_modules()

		if("store")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.uneq_active()
//					R.hud_used.update_robot_modules_display()
				else
					R << "You haven't selected a module yet."

		if("module1")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(1)

		if("module2")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(2)

		if("module3")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(3)*/
		else
			return 0
	return 1

/*/obj/screen/resist
	name = "resist"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "act_resist"
	screen_loc = "1,10"

/obj/screen/resist/Click(location, control, params)
	..(location, control, params)
	if(isliving(usr))
		var/mob/living/L = usr
		L.resist()*/

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
	return 1
//--------------------------------------------------close end---------------------------------------------------------


//--------------------------------------------------GRAB---------------------------------------------------------
/obj/screen/grab
	name = "grab"

/obj/screen/grab/Click()
	var/obj/item/weapon/grab/G = master
	G.s_click(src)
	return 1

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return
//-----------------------------------------------GRAB END---------------------------------------------------------





//-----------------------------------------------ITEM ACTION---------------------------------------------------------
/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Destroy()
	..()
	owner = null

/obj/screen/item_action/Click()
	if(!usr || !owner)
		return 1
	if(!usr.canClick())
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return 1

	if(!(owner in usr))
		return 1

	owner.ui_action_click()
	return 1
//-----------------------------------------------ITEM ACTION END---------------------------------------------------------



//--------------------------------------------------ZONE SELECT---------------------------------------------------------
/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel

/obj/screen/zone_sel/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/old_selecting = parentmob.targeted_organ //We're only going to update_icon() if there's been a change

	switch(icon_y)
		if(1 to 3) //Feet
			switch(icon_x)
				if(10 to 15)
					parentmob.targeted_organ = "r_foot"
				if(17 to 22)
					parentmob.targeted_organ = "l_foot"
				else
					return 1
		if(4 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					parentmob.targeted_organ = "r_leg"
				if(17 to 22)
					parentmob.targeted_organ = "l_leg"
				else
					return 1
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					parentmob.targeted_organ = "r_hand"
				if(12 to 20)
					parentmob.targeted_organ = "groin"
				if(21 to 24)
					parentmob.targeted_organ = "l_hand"
				else
					return 1
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					parentmob.targeted_organ = "r_arm"
				if(12 to 20)
					parentmob.targeted_organ = "chest"
				if(21 to 24)
					parentmob.targeted_organ = "l_arm"
				else
					return 1
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				parentmob.targeted_organ = "head"
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							parentmob.targeted_organ = "mouth"
					/*if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							selecting = "eyes"
					if(25 to 27)
						if(icon_x in 15 to 17)
							selecting = "eyes"*/
					if(25 to 27)
						if(icon_x in 14 to 18)
							parentmob.targeted_organ = "eyes"

	if(old_selecting != parentmob.targeted_organ)
		update_icon()
	return 1

/obj/screen/zone_sel/New()
	..()
	update_icon()

/obj/screen/zone_sel/update_icon()
	overlays.Cut()
	overlays += image('icons/mob/zone_sel.dmi', "[parentmob.targeted_organ]")
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

/obj/screen/storage/Click()
	if(!usr.canClick())
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return 1
	if(master)
		var/obj/item/I = usr.get_active_hand()
		if(I)
			usr.ClickOn(master)
	return 1

//--------------------------------------------------inventory---------------------------------------------------------
/obj/screen/inventory
	var/slot_id //The indentifier for the slot. It has nothing to do with ID cards.
	icon = 'icons/mob/screen/ErisStyle.dmi'
	layer = 19

/obj/screen/inventory/New(_name = "unnamed", _screen_loc = "7,7", _slot_id = null, _icon = null, _icon_state = null, _parentmob = null)
	src.name = _name
	src.screen_loc = _screen_loc
	src.icon = _icon
	src.slot_id = _slot_id
	src.icon_state = _icon_state
	src.parentmob = _parentmob

/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(!usr.canClick())
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return 1
	switch(name)
/*		if("r_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("r")
		if("l_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("l")*/
		if("hand")
			usr:swap_hand()
		else
			if(usr.attack_ui(slot_id))
				usr.update_inv_l_hand(0)
				usr.update_inv_r_hand(0)
	return 1

/obj/screen/inventory/hand
	name = "nonamehand"

/obj/screen/inventory/hand/New()
	..()
	update_icon()

/obj/screen/inventory/hand/Click()
	var/mob/living/carbon/C = parentmob
	if (src.slot_id == slot_l_hand)
		C.activate_hand("l")
	else
		C.activate_hand("r")

/obj/screen/inventory/hand/update_icon()
	if (src.slot_id == (parentmob.hand ? slot_l_hand : slot_r_hand)) //Если данный элемент ХУДа отображает левую
		src.icon_state = "act_hand[src.slot_id==slot_l_hand ? "-l" : "-r"]"
	else
		src.icon_state = "hand[src.slot_id==slot_l_hand ? "-l" : "-r"]"
//--------------------------------------------------inventory end---------------------------------------------------------

//--------------------------------------------------health---------------------------------------------------------
/obj/screen/health
	name = "health"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "health0"
	screen_loc = "15,7"
	process_flag = 1

/obj/screen/health/process()
	//var/mob/living/carbon/human/H = parentmob
	if(parentmob:stat != DEAD) // They are dead, let death() handle their hud update on this.
		if (parentmob:analgesic > 100)
			icon_state = "health_numb"
		else
			switch(parentmob:hal_screwyhud)
				if(1)	icon_state = "health6"
				if(2)	icon_state = "health7"
				else
				//switch(health - halloss)
					switch(100 - ((parentmob:species.flags & NO_PAIN) ? 0 : parentmob:traumatic_shock))
					//switch(100 - parentmob.traumatic_shock)
						if(100 to INFINITY)		icon_state = "health0"
						if(80 to 100)			icon_state = "health1"
						if(60 to 80)			icon_state = "health2"
						if(40 to 60)			icon_state = "health3"
						if(20 to 40)			icon_state = "health4"
						if(0 to 20)				icon_state = "health5"
						else					icon_state = "health6"

/*/obj/screen/health/New()
	if(usr.client)
		usr.client.screen += src
		parentmob = usr
*/
//--------------------------------------------------health end---------------------------------------------------------

//--------------------------------------------------nutrition---------------------------------------------------------
/obj/screen/nutrition
	name = "nutrition"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "nutrition1"
	screen_loc = "15,6"
	process_flag = 1

/obj/screen/nutrition/process()
	//var/mob/living/carbon/human/H = parentmob
	update_icon()

/obj/screen/nutrition/update_icon()
	set src in usr.client.screen
	var/mob/living/carbon/human/H = parentmob
	switch(H.nutrition)
		if(450 to INFINITY)				icon_state = "nutrition0"
		if(350 to 450)					icon_state = "nutrition1"
		if(250 to 350)					icon_state = "nutrition2"
		if(150 to 250)					icon_state = "nutrition3"
		else							icon_state = "nutrition4"
//--------------------------------------------------nutrition end---------------------------------------------------------

//--------------------------------------------------bodytemp---------------------------------------------------------
/obj/screen/bodytemp
	name = "bodytemp"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "temp0"
	screen_loc = "15,8"
	process_flag = 1

/obj/screen/bodytemp/process()
	update_icon()
	//var/mob/living/carbon/human/H = parentmob
	/*if (!parentmob:species)
		switch(parentmob:bodytemperature) //310.055 optimal body temp
			if(370 to INFINITY)		icon_state = "temp4"
			if(350 to 370)			icon_state = "temp3"
			if(335 to 350)			icon_state = "temp2"
			if(320 to 335)			icon_state = "temp1"
			if(300 to 320)			icon_state = "temp0"
			if(295 to 300)			icon_state = "temp-1"
			if(280 to 295)			icon_state = "temp-2"
			if(260 to 280)			icon_state = "temp-3"
			else					icon_state = "temp-4"
	else*/


/obj/screen/bodytemp/update_icon()
	//TODO: precalculate all of this stuff when the species datum is created
	var/base_temperature = parentmob:species.body_temperature
	if(base_temperature == null) //some species don't have a set metabolic temperature
		base_temperature = (parentmob:species.heat_level_1 + parentmob:species.cold_level_1)/2

	var/temp_step
	if (parentmob:bodytemperature >= base_temperature)
		temp_step = (parentmob:species.heat_level_1 - base_temperature)/4

		if (parentmob:bodytemperature >= parentmob:species.heat_level_1)
			icon_state = "temp4"
		else if (parentmob:bodytemperature >= base_temperature + temp_step*3)
			icon_state = "temp3"
		else if (parentmob:bodytemperature >= base_temperature + temp_step*2)
			icon_state = "temp2"
		else if (parentmob:bodytemperature >= base_temperature + temp_step*1)
			icon_state = "temp1"
		else
			icon_state = "temp0"

	else if (parentmob:bodytemperature < base_temperature)
		temp_step = (base_temperature - parentmob:species.cold_level_1)/4

		if (parentmob:bodytemperature <= parentmob:species.cold_level_1)
			icon_state = "temp-4"
		else if (parentmob:bodytemperature <= base_temperature - temp_step*3)
			icon_state = "temp-3"
		else if (parentmob:bodytemperature <= base_temperature - temp_step*2)
			icon_state = "temp-2"
		else if (parentmob:bodytemperature <= base_temperature - temp_step*1)
			icon_state = "temp-1"
		else
			icon_state = "temp0"
//--------------------------------------------------bodytemp end---------------------------------------------------------


//--------------------------------------------------pressure---------------------------------------------------------
/obj/screen/pressure
	name = "pressure"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "pressure0"
	screen_loc = "15,13"
	process_flag = 1

/obj/screen/pressure/process()
	update_icon()

/obj/screen/pressure/update_icon()
	var/mob/living/carbon/human/H = parentmob
	icon_state = "pressure[H.pressure_alert]"
//--------------------------------------------------pressure end---------------------------------------------------------

//--------------------------------------------------toxin---------------------------------------------------------
/obj/screen/toxin
	name = "toxin"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "tox0"
	screen_loc = "15,10"
	process_flag = 1

/obj/screen/toxin/process()
	update_icon()

/obj/screen/toxin/update_icon()
	var/mob/living/carbon/human/H = parentmob
	if(H.hal_screwyhud == 4 || H.phoron_alert)
		icon_state = "tox1"
	else
		icon_state = "tox0"
//--------------------------------------------------toxin end---------------------------------------------------------

//--------------------------------------------------oxygen---------------------------------------------------------

/obj/screen/oxygen
	name = "oxygen"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "oxy0"
	screen_loc = "15,12"
	process_flag = 1

/obj/screen/oxygen/process()
	update_icon()

/obj/screen/oxygen/update_icon()
	var/mob/living/carbon/human/H = parentmob
	if(H.hal_screwyhud == 3 || H.oxygen_alert)
		icon_state = "oxy1"
	else
		icon_state = "oxy0"
//--------------------------------------------------oxygen end---------------------------------------------------------

//--------------------------------------------------fire---------------------------------------------------------
/obj/screen/fire
	name = "fire"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "fire0"
	screen_loc = "15,9"
	process_flag = 1

/obj/screen/fire/process()
	update_icon()

/obj/screen/fire/update_icon()
	var/mob/living/carbon/human/H = parentmob
	icon_state = "fire[H.fire_alert]"
	/*if(H.fire_alert)							icon_state = "fire[H.fire_alert]" //fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
	else										icon_state = "fire0"*/
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

/obj/screen/internal/Click()
//	if("internal")
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
			if(C.internal)
				C.internal = null
				C << "<span class='notice'>No longer running on internals.</span>"
				icon_state = "internal0"
			else

				var/no_mask
				if(!(C.wear_mask && C.wear_mask.item_flags & AIRTIGHT))
					var/mob/living/carbon/human/H = C
					if(!(H.head && H.head.item_flags & AIRTIGHT))
						no_mask = 1

				if(no_mask)
					C << "<span class='notice'>You are not wearing a suitable mask or helmet.</span>"
					return 1
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
							if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
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
									if(t.air_contents.gas["oxygen"] && !t.air_contents.gas["phoron"])
										contents.Add(t.air_contents.gas["oxygen"])
									else
										contents.Add(0)

								// No races breath this, but never know about downstream servers.
								if ("carbon dioxide")
									if(t.air_contents.gas["carbon_dioxide"] && !t.air_contents.gas["phoron"])
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
						C << "<span class='notice'>You are now running on internals from [tankcheck[best]] [from] your [nicename[best]].</span>"
						playsound(usr, 'sound/effects/Custom_internals.ogg', 50, -5)
						C.internal = tankcheck[best]


					if(C.internal)
						icon_state = "internal1"
					else
						C << "<span class='notice'>You don't have a[breathes=="oxygen" ? "n oxygen" : addtext(" ",breathes)] tank.</span>"
//-----------------------internal END------------------------------

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
//	if(iscarbon(parentmob))
	var/mob/living/carbon/C = parentmob
	if(C.legcuffed)
		C << "<span class='notice'>You are legcuffed! You cannot run until you get [C.legcuffed] removed!</span>"
		C.m_intent = "walk"	//Just incase
		update_icon()
		return 1
	switch(C.m_intent)
		if("run")
			C.m_intent = "walk"
		if("walk")
			C.m_intent = "run"
	update_icon()

/obj/screen/mov_intent/New()
	..()
	update_icon()

/obj/screen/mov_intent/update_icon()
	var/mob/living/carbon/C = parentmob
	switch(C.m_intent)
		if("run")
			icon_state = "running"
		if("walk")
			icon_state = "walking"

//-----------------------mov_intent END------------------------------
/obj/screen/equip
	name = "equip"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "act_equip"
	screen_loc = "8,2"

/obj/screen/equip/Click()
	if (istype(parentmob.loc,/obj/mecha)) // stops inventory actions in a mech
		return 1
	if(ishuman(parentmob))
		var/mob/living/carbon/human/H = parentmob
		H.quick_equip()
//-----------------------swap------------------------------
/obj/screen/swap
	name = "swap hand"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	icon_state = "swap-l"

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
	icon_state = "help"
	screen_loc = "8,2"

/obj/screen/intent/New()
	..()
	update_icon()

/obj/screen/intent/Click()
	parentmob.a_intent_change("right")
//	update_icon()//update in a_intent_change, because macro

/obj/screen/intent/update_icon()
	switch (parentmob.a_intent)
		if(I_HELP)
			icon_state = "help"
		if(I_HURT)
			icon_state = "harm"
		if(I_GRAB)
			icon_state = "grab"
		if(I_DISARM)
			icon_state = "disarm"
//-----------------------intent END------------------------------
/obj/screen/fastintent
	name = "fastintent"
	icon = 'icons/mob/screen/ErisStyle.dmi'
//update in a_intent_change, because macro
/*/obj/screen/fastintent/Click()
	if (parentmob.HUDneed.Find("intent"))
		var/obj/screen/intent/I = parentmob.HUDneed["intent"]
		I.update_icon()*/


/obj/screen/fastintent/help
	icon_state = "intent_help"

/obj/screen/fastintent/help/Click()
	parentmob.a_intent_change(I_HELP)
//	..()

/obj/screen/fastintent/harm
	icon_state = "intent_harm"

/obj/screen/fastintent/harm/Click()
	parentmob.a_intent_change(I_HURT)
//	..()

/obj/screen/fastintent/grab
	icon_state = "intent_grab"

/obj/screen/fastintent/grab/Click()
	parentmob.a_intent_change(I_GRAB)
//	..()

/obj/screen/fastintent/disarm
	icon_state = "intent_disarm"

/obj/screen/fastintent/disarm/Click()
	parentmob.a_intent_change(I_DISARM)
//	..()

/obj/screen/drugoverlay
	icon = 'icons/mob/screen1_full.dmi'
	icon_state = "blank"
	name = "drugs"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	mouse_opacity = 0
	process_flag = 1
	layer = 18.1 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.
//	var/global/image/blind_icon = image('icons/mob/screen1_full.dmi', "blackimageoverlay")

/obj/screen/drugoverlay/process()
	update_icon()

/obj/screen/drugoverlay/update_icon()
	underlays.Cut()
	if (parentmob.disabilities & NEARSIGHTED)
		underlays += global_hud.vimpaired
	if (parentmob.eye_blurry)
		underlays += global_hud.blurry
	if (parentmob.druggy)
		underlays += global_hud.druggy

/obj/screen/damageoverlay
	icon = 'icons/mob/screen1_full.dmi'
	icon_state = "oxydamageoverlay0"
	name = "dmg"
	screen_loc = "1,1"
	mouse_opacity = 0
	process_flag = 1
	layer = 18.1 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.
	var/global/image/blind_icon = image('icons/mob/screen1_full.dmi', "blackimageoverlay")

/obj/screen/damageoverlay/process()
	update_icon()
	return

/obj/screen/damageoverlay/update_icon()
	overlays.Cut()
	UpdateHealthState()

	underlays.Cut()
	UpdateVisionState()
	return

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

/obj/screen/frippery/New(_icon_state,_screen_loc = "7,7",_dir, mob/living/_parentmob)
	src.parentmob = _parentmob
	src.screen_loc = _screen_loc
	src.icon_state = _icon_state
	src.dir = _dir

/obj/screen/camera
	icon = 'icons/mob/screen1_full.dmi'
	icon_state = "camera0"
	name = "cam"
	screen_loc = "1,1"
	mouse_opacity = 0
	process_flag = 0
	layer = 18.1



/*	if(owner.gun_move_icon)
		if(!(target_permissions & TARGET_CAN_MOVE))
			owner.gun_move_icon.icon_state = "no_walk0"
			owner.gun_move_icon.name = "Allow Movement"
		else
			owner.gun_move_icon.icon_state = "no_walk1"
			owner.gun_move_icon.name = "Disallow Movement"

	if(owner.item_use_icon)
		if(!(target_permissions & TARGET_CAN_CLICK))
			owner.item_use_icon.icon_state = "no_item0"
			owner.item_use_icon.name = "Allow Item Use"
		else
			owner.item_use_icon.icon_state = "no_item1"
			owner.item_use_icon.name = "Disallow Item Use"

	if(owner.radio_use_icon)
		if(!(target_permissions & TARGET_CAN_RADIO))
			owner.radio_use_icon.icon_state = "no_radio0"
			owner.radio_use_icon.name = "Allow Radio Use"
		else
			owner.radio_use_icon.icon_state = "no_radio1"
			owner.radio_use_icon.name = "Disallow Radio Use"*/
//-----------------------Gun Mod------------------------------
/obj/screen/gun
	name = "gun"
	icon = 'icons/mob/screen/ErisStyle.dmi'
	master = null
	dir = 2

/obj/screen/gun/Click(location, control, params)
	if(!usr)
		return
	return 1

/obj/screen/gun/New()
	..()
	if(!parentmob.aiming)
		parentmob.aiming = new(parentmob)
	update_icon()

/obj/screen/gun/mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"
	screen_loc = "15,2"


/obj/screen/gun/mode/Click(location, control, params)
	if(..())
		var/mob/living/user = parentmob
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_active()
			update_icon()
		return 1
	return 0

/obj/screen/gun/mode/update_icon()
	icon_state = "gun[parentmob.aiming.active]"

/obj/screen/gun/move
	name = "Allow Movement"
	icon_state = "no_walk0"
	screen_loc = "15,3"

/obj/screen/gun/move/Click(location, control, params)
	if(..())
		var/mob/living/user = parentmob
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_permission(TARGET_CAN_MOVE)
			update_icon()
		return 1
	return 0

/obj/screen/gun/move/update_icon()
	if(!(parentmob.aiming.target_permissions & TARGET_CAN_MOVE))
		icon_state = "no_walk0"
//			owner.gun_move_icon.name = "Allow Movement"
	else
		icon_state = "no_walk1"
//			owner.gun_move_icon.name = "Disallow Movement"

/obj/screen/gun/item
	name = "Allow Item Use"
	icon_state = "no_items0"
	screen_loc = "14,2"

/obj/screen/gun/item/Click(location, control, params)
	if(..())
		var/mob/living/user = parentmob
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_permission(TARGET_CAN_CLICK)
			update_icon()
		return 1
	return 0

/obj/screen/gun/item/update_icon()
	if(!(parentmob.aiming.target_permissions & TARGET_CAN_CLICK))
		icon_state = "no_items0"
//			owner.item_use_icon.name = "Allow Item Use"
	else
		icon_state = "no_items1"
//			owner.item_use_icon.name = "Disallow Item Use"

/obj/screen/gun/radio
	name = "Allow Radio Use"
	icon_state = "no_radio0"
	screen_loc = "14,3"

/obj/screen/gun/radio/Click(location, control, params)
	if(..())
		var/mob/living/user = parentmob
		if(istype(user))
			if(!user.aiming) user.aiming = new(user)
			user.aiming.toggle_permission(TARGET_CAN_RADIO)
			update_icon()
		return 1
	return 0

/obj/screen/gun/radio/update_icon()
	if(!(parentmob.aiming.target_permissions & TARGET_CAN_RADIO))
		icon_state = "no_radio0"
//			owner.radio_use_icon.name = "Allow Radio Use"
	else
		icon_state = "no_radio1"
//			owner.radio_use_icon.name = "Disallow Radio Use"
//-----------------------Gun Mod End------------------------------

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
		parentmob.inventory_shown = 0
		hideobjects()
	else
		parentmob.inventory_shown = 1
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
/*	for(var/obj/screen/inventory/inv_elem in parentmob.HUDinventory)
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
				if(H.wear_mask) H.wear_mask.screen_loc = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc*/

/*//	if(!mymob) return
//	if(ishuman(mymob))
	var/mob/living/carbon/human/H = parentmob
	for(var/gear_slot in H.species.hud.gear)
		var/list/hud_data = H.species.hud.gear[gear_slot]
		if(H.inventory_shown)
			switch(hud_data["slot"])
				if(slot_head)
					if(H.head)      H.head.screen_loc =      hud_data["loc"]
				if(slot_shoes)
					if(H.shoes)     H.shoes.screen_loc =     hud_data["loc"]
				if(slot_l_ear)
					if(H.l_ear)     H.l_ear.screen_loc =     hud_data["loc"]
				if(slot_r_ear)
					if(H.r_ear)     H.r_ear.screen_loc =     hud_data["loc"]
				if(slot_gloves)
					if(H.gloves)    H.gloves.screen_loc =    hud_data["loc"]
				if(slot_glasses)
					if(H.glasses)   H.glasses.screen_loc =   hud_data["loc"]
				if(slot_w_uniform)
					if(H.w_uniform) H.w_uniform.screen_loc = hud_data["loc"]
				if(slot_wear_suit)
					if(H.wear_suit) H.wear_suit.screen_loc = hud_data["loc"]
				if(slot_wear_mask)
					if(H.wear_mask) H.wear_mask.screen_loc = hud_data["loc"]
		else
			switch(hud_data["slot"])
				if(slot_head)
					if(H.head)      H.head.screen_loc =      null
				if(slot_shoes)
					if(H.shoes)     H.shoes.screen_loc =     null
				if(slot_l_ear)
					if(H.l_ear)     H.l_ear.screen_loc =     null
				if(slot_r_ear)
					if(H.r_ear)     H.r_ear.screen_loc =     null
				if(slot_gloves)
					if(H.gloves)    H.gloves.screen_loc =    null
				if(slot_glasses)
					if(H.glasses)   H.glasses.screen_loc =   null
				if(slot_w_uniform)
					if(H.w_uniform) H.w_uniform.screen_loc = null
				if(slot_wear_suit)
					if(H.wear_suit) H.wear_suit.screen_loc = null
				if(slot_wear_mask)
					if(H.wear_mask) H.wear_mask.screen_loc = null
	update_inv_w_uniform(0)
	update_inv_wear_id(0)
	update_inv_gloves(0)
	update_inv_glasses(0)
	update_inv_ears(0)
	update_inv_shoes(0)
	update_inv_s_store(0)
	update_inv_wear_mask(0)
	update_inv_head(0)
	update_inv_belt(0)
	update_inv_back(0)
	update_inv_wear_suit(0)
	update_inv_r_hand(0)
	update_inv_l_hand(0)
	update_inv_handcuffed(0)
	update_inv_legcuffed(0)
	update_inv_pockets(0)
	update_fire(0)
	update_surgery(0)
*/
//-----------------------toggle_invetory End------------------------------
