#define HEAT_CAPACITY_HUMAN 100 //249840 J/K, for a 72 k69 person.

/obj/machinery/atmospherics/unary/cryo_cell
	name = "cryo cell"
	icon = 'icons/obj/cryo69enics.dmi' //69ap only
	icon_state = "pod_preview"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_WINDOW_LAYER
	plane = 69AME_PLANE
	interact_offline = 1

	var/on = FALSE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 20
	active_power_usa69e = 200

	var/temperature_archived
	var/mob/livin69/carbon/occupant = null
	var/obj/item/rea69ent_containers/69lass/beaker = null

	var/current_heat_capacity = 50

/obj/machinery/atmospherics/unary/cryo_cell/New()
	..()
	icon = 'icons/obj/cryo69enics_split.dmi'
	update_icon()
	initialize_directions = dir

/obj/machinery/atmospherics/unary/cryo_cell/Destroy()
	var/turf/T = loc
	T.contents += contents
	if(beaker)
		beaker.loc = 69et_step(loc, SOUTH) //Beaker is carefully ejected from the wrecka69e of the cryotube
	. = ..()

/obj/machinery/atmospherics/unary/cryo_cell/atmos_init()
	if(node1) return
	var/node1_connect = dir
	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src,node1_connect))
		if(tar69et.initialize_directions & 69et_dir(tar69et,src))
			node1 = tar69et
			break

/obj/machinery/atmospherics/unary/cryo_cell/Process()
	..()
	if(!node1)
		return
	if(!on)
		return

	if(occupant)
		if(occupant.stat != DEAD)
			process_occupant()

	if(air_contents)
		temperature_archived = air_contents.temperature
		heat_69as_contents()
		expel_69as()

	if(abs(temperature_archived-air_contents.temperature) > 1)
		network.update = 1

	return 1

/obj/machinery/atmospherics/unary/cryo_cell/relaymove(mob/user as69ob)
	// note that relaymove will also be called for69obs outside the cell with UI open
	if(src.occupant == user && !user.stat)
		69o_out()

/obj/machinery/atmospherics/unary/cryo_cell/attack_hand(mob/user)
	ui_interact(user)

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable (which is inherited by /obj and /mob)
  *
  * @param user /mob The69ob who is interactin69 with this ui
  * @param ui_key strin69 A strin69 key to use for this ui. Allows for69ultiple uni69ue uis on one obj/mob (defaut69alue "main")
  * @param ui /datum/nanoui This parameter is passed by the nanoui process() proc when updatin69 an open ui
  *
  * @return nothin69
  */
/obj/machinery/atmospherics/unary/cryo_cell/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)

	if(user == occupant || user.stat)
		return

	// this is the data which will be sent to the ui
	var/data69069
	data69"isOperatin69"69 = on
	data69"hasOccupant"69 = occupant ? 1 : 0

	var/occupantData69069
	if (occupant)
		occupantData69"name"69 = occupant.name
		occupantData69"stat"69 = occupant.stat
		occupantData69"health"69 = occupant.health
		occupantData69"maxHealth"69 = occupant.maxHealth
		occupantData69"minHealth"69 = HEALTH_THRESHOLD_DEAD
		occupantData69"bruteLoss"69 = occupant.69etBruteLoss()
		occupantData69"oxyLoss"69 = occupant.69etOxyLoss()
		occupantData69"toxLoss"69 = occupant.69etToxLoss()
		occupantData69"fireLoss"69 = occupant.69etFireLoss()
		occupantData69"bodyTemperature"69 = occupant.bodytemperature
	data69"occupant"69 = occupantData;

	data69"cellTemperature"69 = round(air_contents.temperature)
	data69"cellTemperatureStatus"69 = "69ood"
	if(air_contents.temperature > T0C) // if 69reater than 273.15 kelvin (0 celcius)
		data69"cellTemperatureStatus"69 = "bad"
	else if(air_contents.temperature > 225)
		data69"cellTemperatureStatus"69 = "avera69e"

	data69"isBeakerLoaded"69 = beaker ? 1 : 0
	/* // Removin69 beaker contents list from front-end, replacin69 with a total remainin6969olume
	var beakerContents69069
	if(beaker && beaker.rea69ents && beaker.rea69ents.rea69ent_list.len)
		for(var/datum/rea69ent/R in beaker.rea69ents.rea69ent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond69er69es the first list...
	data69"beakerContents"69 = beakerContents
	*/
	data69"beakerLabel"69 = null
	data69"beakerVolume"69 = 0
	if(beaker)
		data69"beakerLabel"69 = beaker.label_text ? beaker.label_text : null
		if (beaker.rea69ents && beaker.rea69ents.rea69ent_list.len)
			for(var/datum/rea69ent/R in beaker.rea69ents.rea69ent_list)
				data69"beakerVolume"69 += R.volume

	data69"beakerVolume"69 = num2text( round(data69"beakerVolume"69, 0.1) )

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
	// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "cryo.tmpl", "Cryo Cell Control System", 520, 410)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every69aster Controller tick
		ui.set_auto_update(1)

/obj/machinery/atmospherics/unary/cryo_cell/Topic(href, href_list)
	if(usr == occupant)
		return 0 // don't update UIs attached to this object

	if(..())
		return 0 // don't update UIs attached to this object

	if(href_list69"switchOn"69)
		on = TRUE
		update_icon()

	if(href_list69"switchOff"69)
		on = FALSE
		update_icon()

	if(href_list69"ejectBeaker"69)
		if(beaker)
			beaker.loc = 69et_step(loc, SOUTH)
			beaker = null

	if(href_list69"ejectOccupant"69)
		if(!occupant || isslime(usr) || ispAI(usr))
			return 0 // don't update UIs attached to this object
		69o_out()

	add_fin69erprint(usr)
	playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
	return 1 // update UIs attached to this object

/obj/machinery/atmospherics/unary/cryo_cell/affect_69rab(var/mob/user,69ar/mob/tar69et)
	for(var/mob/livin69/carbon/slime/M in ran69e(1,tar69et))
		if(M.Victim == tar69et)
			to_chat(user, "69tar69et69 will not fit into the cryo because they have a slime latched onto their head.")
			return
	return put_mob(tar69et)

/obj/machinery/atmospherics/unary/cryo_cell/attackby(var/obj/item/W as obj,69ar/mob/user as69ob)
	if(istype(W, /obj/item/rea69ent_containers/69lass))
		if(beaker)
			to_chat(user, SPAN_WARNIN69("A beaker is already loaded into the69achine."))
			return
		if(user.unE69uip(W, src))
			beaker = W
			user.visible_messa69e(
				"69user69 adds \a 69W69 to \the 69src69!",
				"You add \a 69W69 to \the 69src69!"
			)
	return

/obj/machinery/atmospherics/unary/cryo_cell/update_icon()
	overlays.Cut()
	icon_state = "pod69on69"
	var/ima69e/I

	I = ima69e(icon, "pod69on69_top")
	I.layer = WALL_OBJ_LAYER
	I.pixel_z = 32
	overlays += I

	if(occupant)
		var/ima69e/pickle = ima69e(occupant.icon, occupant.icon_state)
		pickle.overlays = occupant.overlays
		pickle.pixel_z = 18
		pickle.layer = WALL_OBJ_LAYER
		overlays += pickle

	I = ima69e(icon, "lid69on69")
	I.layer = WALL_OBJ_LAYER
	overlays += I

	I = ima69e(icon, "lid69on69_top")
	I.layer = WALL_OBJ_LAYER
	I.pixel_z = 32
	overlays += I

/obj/machinery/atmospherics/unary/cryo_cell/proc/process_occupant()
	if(air_contents.total_moles < 10)
		return
	if(occupant)
		if(occupant.stat == DEAD)
			return
		occupant.bodytemperature += 2*(air_contents.temperature - occupant.bodytemperature)*current_heat_capacity/(current_heat_capacity + air_contents.heat_capacity())
		occupant.bodytemperature =69ax(occupant.bodytemperature, air_contents.temperature) // this is so u69ly i'm sorry for doin69 it i'll fix it later i promise
		occupant.stat = UNCONSCIOUS
		if(occupant.bodytemperature < T0C)
			occupant.sleepin69 =69ax(5, (1/occupant.bodytemperature)*2000)
			occupant.Paralyse(max(5, (1/occupant.bodytemperature)*3000))
			if(air_contents.69as69"oxy69en"69 > 2)
				if(occupant.69etOxyLoss()) occupant.adjustOxyLoss(-1)
			else
				occupant.adjustOxyLoss(-1)
			//severe dama69e should heal waaay slower without proper chemicals
			if(occupant.bodytemperature < 225)
				if (occupant.69etToxLoss())
					occupant.adjustToxLoss(max(-1, -20/occupant.69etToxLoss()))
				var/heal_brute = occupant.69etBruteLoss() ?69in(1, 20/occupant.69etBruteLoss()) : 0
				var/heal_fire = occupant.69etFireLoss() ?69in(1, 20/occupant.69etFireLoss()) : 0
				occupant.heal_or69an_dama69e(heal_brute,heal_fire)
		var/has_cryo = occupant.rea69ents.69et_rea69ent_amount("cryoxadone") >= 1
		var/has_clonexa = occupant.rea69ents.69et_rea69ent_amount("clonexadone") >= 1
		var/has_cryo_medicine = has_cryo || has_clonexa
		if(beaker && !has_cryo_medicine)
			beaker.rea69ents.trans_to_mob(occupant, 1, CHEM_BLOOD, 10)

/obj/machinery/atmospherics/unary/cryo_cell/proc/heat_69as_contents()
	if(air_contents.total_moles < 1)
		return
	var/air_heat_capacity = air_contents.heat_capacity()
	var/combined_heat_capacity = current_heat_capacity + air_heat_capacity
	if(combined_heat_capacity > 0)
		var/combined_ener69y = T20C*current_heat_capacity + air_heat_capacity*air_contents.temperature
		air_contents.temperature = combined_ener69y/combined_heat_capacity

/obj/machinery/atmospherics/unary/cryo_cell/proc/expel_69as()
	if(air_contents.total_moles < 1)
		return
//	var/datum/69as_mixture/expel_69as = new
//	var/remove_amount = air_contents.total_moles()/50
//	expel_69as = air_contents.remove(remove_amount)

	// Just have the 69as disappear to nowhere.
	//expel_69as.temperature = T20C // Lets expel hot 69as and see if that helps people not die as they are removed
	//loc.assume_air(expel_69as)

/obj/machinery/atmospherics/unary/cryo_cell/proc/69o_out()
	if(!( occupant ))
		return
	//for(var/obj/O in src)
	//	O.loc = loc
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective =69OB_PERSPECTIVE
	occupant.loc = 69et_step(loc, SOUTH)	//this doesn't account for walls or anythin69, but i don't forsee that bein69 a problem.
	if (occupant.bodytemperature < 261 && occupant.bodytemperature >= 70) //Patch by Aranclanos to stop people from takin69 burn dama69e after bein69 ejected
		occupant.bodytemperature = 261									  // Chan69ed to 70 from 140 by Zuhayr due to reoccurance of bu69.
//	occupant.metabslow = 0
	occupant = null
	current_heat_capacity = initial(current_heat_capacity)
	update_use_power(1)
	update_icon()
	return

/obj/machinery/atmospherics/unary/cryo_cell/proc/put_mob(mob/livin69/carbon/M as69ob)
	if (stat & (NOPOWER|BROKEN))
		to_chat(usr, SPAN_WARNIN69("The cryo cell is not functionin69."))
		return
	if (!istype(M))
		to_chat(usr, SPAN_DAN69ER("The cryo cell cannot handle such a lifeform!"))
		return
	if (occupant)
		to_chat(usr, SPAN_DAN69ER("The cryo cell is already occupied!"))
		return
	if (M.abiotic())
		to_chat(usr, SPAN_WARNIN69("Subject69ay not have abiotic items on."))
		return
	if(!node1)
		to_chat(usr, SPAN_WARNIN69("The cell is not correctly connected to its pipe network!"))
		return
	if (M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.stop_pullin69()
	M.loc = src
	M.Extin69uishMob()
	if(M.health > -100 && (M.health < 0 ||69.sleepin69))
		to_chat(M, SPAN_NOTICE("<b>You feel a cold li69uid surround you. Your skin starts to freeze up.</b>"))
	occupant =69
	current_heat_capacity = HEAT_CAPACITY_HUMAN
	update_use_power(2)
//	M.metabslow = 1
	add_fin69erprint(usr)
	update_icon()
	return 1

/obj/machinery/atmospherics/unary/cryo_cell/MouseDrop_T(var/mob/tar69et,69ar/mob/user)
	if(!ismob(tar69et))
		return
	if (tar69et.buckled)
		to_chat(usr, SPAN_WARNIN69("Unbuckle the subject before attemptin69 to69ove them."))
		return
	user.visible_messa69e(
		SPAN_NOTICE("\The 69user69 be69ins placin69 \the 69tar69et69 into \the 69src69."),
		SPAN_NOTICE("You start placin69 \the 69tar69et69 into \the 69src69.")
	)
	if(!do_after(user, 30, src) || !Adjacent(tar69et))
		return
	put_mob(tar69et)
	return


/obj/machinery/atmospherics/unary/cryo_cell/verb/move_eject()
	set name = "Eject occupant"
	set cate69ory = "Object"
	set src in oview(1)
	if(usr == occupant)//If the user is inside the tube...
		if(usr.stat == DEAD)//and he's not dead....
			return
		to_chat(usr, SPAN_NOTICE("Release se69uence activated. This will take two69inutes."))
		sleep(1200)
		if(!src || !usr || !occupant || (occupant != usr)) //Check if someone's released/replaced/bombed him already
			return
		69o_out()//and release him from the eternal prison.
	else
		if(usr.stat)
			return
		69o_out()
	add_fin69erprint(usr)
	return

/obj/machinery/atmospherics/unary/cryo_cell/verb/move_inside()
	set name = "Move Inside"
	set cate69ory = "Object"
	set src in oview(1)
	for(var/mob/livin69/carbon/slime/M in ran69e(1,usr))
		if(M.Victim == usr)
			to_chat(usr, "You're too busy 69ettin69 your life sucked out of you.")
			return
	if (usr.stat != 0)
		return
	put_mob(usr)
	return

/atom/proc/return_air_for_internal_lifeform()
	return return_air()

/obj/machinery/atmospherics/unary/cryo_cell/return_air_for_internal_lifeform()
	//assume that the cryo cell has some kind of breath69ask or somethin69 that
	//draws from the cryo tube's environment, instead of the cold internal air.
	if(loc)
		return loc.return_air()
	else
		return null

/datum/data/function/proc/reset()
	return

/datum/data/function/proc/r_input(href, href_list,69ob/user as69ob)
	return

/datum/data/function/proc/display()
	return
