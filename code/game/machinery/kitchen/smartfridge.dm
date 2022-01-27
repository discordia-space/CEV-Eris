/* SmartFrid69e. 69uch todo
*/
/obj/machinery/smartfrid69e
	name = "\improper SmartFrid69e"
	icon = 'icons/obj/vendin69.dmi'
	icon_state = "smartfrid69e"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 5
	active_power_usa69e = 100
	rea69ent_fla69s = NO_REACT
	var/69lobal/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look thin69s over 1000.
	var/icon_on = "smartfrid69e"
	var/icon_off = "smartfrid69e-off"
	var/icon_panel = "smartfrid69e-panel"
	var/icon_fill10 = "smartfrid69e-fill10"
	var/icon_fill20 = "smartfrid69e-fill20"
	var/icon_fill30 = "smartfrid69e-fill30"
	var/list/item_69uants = list()
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0
	var/datum/wires/smartfrid69e/wires = null



/obj/machinery/smartfrid69e/secure
	name = "\improper Secure SmartFrid69e"
	is_secure = 1




/*******************
*   Seed Stora69e
********************/
/obj/machinery/smartfrid69e/seeds
	name = "\improper Refri69erated Seeds Stora69e"
	desc = "When you need seeds fast!"

/obj/machinery/smartfrid69e/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfrid69e/kitchen
	name = "\improper A69ro-Club Frid69e"
	desc = "The panel says it won't allow anyone without access to the kitchen or hydroponics."
	re69_one_access = list(access_hydroponics,access_kitchen)



/*******************
*   Xenobio Slime Frid69e
********************/
/obj/machinery/smartfrid69e/secure/extract
	name = "\improper Slime Extract Stora69e"
	desc = "A refri69erated stora69e unit for slime extracts"
	re69_access = list(access_moebius)

/obj/machinery/smartfrid69e/secure/extract/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/slime_extract))
		return 1
	return 0



/*******************
*   Chemistry69edicine Stora69e
********************/
/obj/machinery/smartfrid69e/secure/medbay
	name = "\improper Refri69erated69edicine Stora69e"
	desc = "A refri69erated stora69e unit for storin6969edicine and chemicals."
	re69_one_access = list(access_moebius,access_chemistry)

/obj/machinery/smartfrid69e/secure/medbay/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/rea69ent_containers/69lass/))
		return 1
	if(istype(O,/obj/item/stora69e/pill_bottle/))
		return 1
	if(istype(O,/obj/item/rea69ent_containers/pill/))
		return 1
	return 0


/*******************
*  69irus Stora69e
********************/
/obj/machinery/smartfrid69e/secure/virolo69y
	name = "\improper Refri69erated69irus Stora69e"
	desc = "A refri69erated stora69e unit for storin6969iral69aterial."
	re69_access = list(access_virolo69y)
	icon_state = "smartfrid69e_virolo69y"
	icon_on = "smartfrid69e_virolo69y"
	icon_off = "smartfrid69e_virolo69y-off"

/obj/machinery/smartfrid69e/secure/virolo69y/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/rea69ent_containers/69lass/beaker/vial/))
		return 1
	if(istype(O,/obj/item/virusdish/))
		return 1
	return 0

/obj/machinery/smartfrid69e/chemistry
	name = "\improper Smart Chemical Stora69e"
	desc = "A refri69erated stora69e unit for69edicine and chemical stora69e."

/obj/machinery/smartfrid69e/chemistry/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/stora69e/pill_bottle) || istype(O,/obj/item/rea69ent_containers))
		return 1
	return 0

/obj/machinery/smartfrid69e/chemistry/virolo69y
	name = "\improper Smart69irus Stora69e"
	desc = "A refri69erated stora69e unit for69olatile sample stora69e."



/*************************
*   Bar Drinks Showcase
**************************/
/obj/machinery/smartfrid69e/drinks
	name = "\improper Drink Showcase"
	desc = "A refri69erated stora69e unit for tasty tasty alcohol."
	icon_state = "showcase"
	icon_on = "showcase"
	icon_off = "showcase-off"
	icon_panel = "showcase-panel"
	var/icon_fill = "showcase-fill"

/obj/machinery/smartfrid69e/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/rea69ent_containers/69lass) || istype(O,/obj/item/rea69ent_containers/food/drinks) || istype(O,/obj/item/rea69ent_containers/food/condiment))
		return 1

/obj/machinery/smartfrid69e/drinks/update_icon()
	cut_overlays()
	if(stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else
		icon_state = icon_on

	if(panel_open && icon_panel)
		overlays += ima69e(icon, icon_panel)

	if(contents.len && !(stat & NOPOWER))
		overlays += ima69e(icon, icon_fill)


/***************************
*   Hydroponics Dryin69 Rack
****************************/
/obj/machinery/smartfrid69e/dryin69_rack
	name = "\improper Dryin69 Rack"
	desc = "A69achine for dryin69 plants."
	icon_state = "dryin69_rack"
	icon_on = "dryin69_rack_on"
	icon_off = "dryin69_rack"
	var/dryin69_power = 0.1 //should take a bit but. why69ake people wait a lifetime to DRY PLANTS
	var/currently_dryin69 = FALSE

/obj/machinery/smartfrid69e/dryin69_rack/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/rea69ent_containers/food/snacks/))
		var/obj/item/rea69ent_containers/food/snacks/S = O
		if (S.dried_type)
			return 1
	return 0

/obj/machinery/smartfrid69e/dryin69_rack/Process()
	..()
	if(inoperable())
		return
	if(contents.len)
		dry()

/obj/machinery/smartfrid69e/dryin69_rack/update_icon()
	cut_overlays()
	if(inoperable())
		icon_state = icon_off
	else
		icon_state = icon_on
	if(contents.len)
		overlays += "dryin69_rack_filled"
		if(!inoperable() && currently_dryin69)
			overlays += "dryin69_rack_dryin69"

/obj/machinery/smartfrid69e/dryin69_rack/proc/dry()
	var/dryin69_somethin69 = FALSE //While we're here, check if anythin69 is undried and still processin69
	for(var/obj/item/rea69ent_containers/food/snacks/S in contents)
		if(S.dry)
			continue
		S.dryness += dryin69_power
		if (S.dryness >= 1)
			if(S.dried_type == S.type || !S.dried_type)
				S.dry = TRUE
				S.name = "dried 69S.name69"
				S.color = "#AAAAAA"
			else
				var/D = S.dried_type
				D = new D(src)
				if (istype(D, /obj/item/rea69ent_containers/food/snacks))
					var/obj/item/rea69ent_containers/food/snacks/SD = D
					SD.dry = TRUE //So we dont 69et stuck in an endless loop of dryin69, transformin69 and dryin69 a69ain
				69del(S)
			update_contents()
		else
			dryin69_somethin69 = TRUE

	if (dryin69_somethin69 != currently_dryin69)
		currently_dryin69 = dryin69_somethin69
		update_icon() //Only update the icon if we have to
	currently_dryin69 = dryin69_somethin69
	return












/obj/machinery/smartfrid69e/New()
	..()
	if(is_secure)
		wires = new/datum/wires/smartfrid69e/secure(src)
	else
		wires = new/datum/wires/smartfrid69e(src)

/obj/machinery/smartfrid69e/Destroy()
	69del(wires)
	wires = null
	return ..()

/obj/machinery/smartfrid69e/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/rea69ent_containers/food/snacks/69rown/) || istype(O,/obj/item/seeds/) || istype(O,/obj/item/rea69ent_containers/food/snacks/meat/) || istype(O,/obj/item/rea69ent_containers/food/snacks/e6969/))
		return 1
	return 0


/obj/machinery/smartfrid69e/Process()
	if(stat & (BROKEN|NOPOWER))
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/machinery/smartfrid69e/power_chan69e()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/smartfrid69e/update_icon()
	cut_overlays()
	if(stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else
		icon_state = icon_on

	if(panel_open && icon_panel)
		overlays += ima69e(icon, icon_panel)

	if(contents.len)
		if(contents.len <= 10)
			overlays += ima69e(icon, icon_fill10)
		else if(contents.len <= 20)
			overlays += ima69e(icon, icon_fill20)
		else
			overlays += ima69e(icon, icon_fill30)

/*******************
*   Item Addin69
********************/

/obj/machinery/smartfrid69e/attackby(var/obj/item/O as obj,69ar/mob/user as69ob)
	if(istype(O, /obj/item/tool/screwdriver))
		panel_open = !panel_open
		user.visible_messa69e("69user69 69panel_open ? "opens" : "closes"69 the69aintenance panel of \the 69src69.", "You 69panel_open ? "open" : "close"69 the69aintenance panel of \the 69src69.")
		update_icon()
		SSnano.update_uis(src)
		return

	if(istype(O, /obj/item/tool/multitool)||istype(O, /obj/item/tool/wirecutters))
		if(panel_open)
			attack_hand(user)
		return

	if(stat & NOPOWER)
		to_chat(user, SPAN_NOTICE("\The 69src69 is unpowered and useless."))
		return

	if(accept_check(O))
		if(contents.len >=69ax_n_of_items)
			to_chat(user, SPAN_NOTICE("\The 69src69 is full."))
			return 1
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			update_contents()
			user.visible_messa69e(SPAN_NOTICE("69user69 has added \the 69O69 to \the 69src69."), SPAN_NOTICE("You add \the 69O69 to \the 69src69."))
			update_icon()
			SSnano.update_uis(src)

	else if(istype(O, /obj/item/stora69e/ba69))
		var/obj/item/stora69e/ba69/P = O
		var/plants_loaded = 0
		for(var/obj/69 in P.contents)
			if(accept_check(69))
				if(contents.len >=69ax_n_of_items)
					to_chat(user, SPAN_NOTICE("\The 69src69 is full."))
					return 1
				else
					P.remove_from_stora69e(69,src)
					plants_loaded++
		if(plants_loaded)
			update_contents()
			update_icon()
			user.visible_messa69e(SPAN_NOTICE("69user69 loads \the 69src69 with \the 69P69."), SPAN_NOTICE("You load \the 69src69 with \the 69P69."))
			if(P.contents.len > 0)
				to_chat(user, SPAN_NOTICE("Some items are refused."))

		SSnano.update_uis(src)

	else
		to_chat(user, SPAN_NOTICE("\The 69src69 smartly refuses 69O69."))
		return 1

/obj/machinery/smartfrid69e/secure/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(!ema6969ed)
		ema6969ed = 1
		locked = -1
		to_chat(user, "You short out the product lock on 69src69.")
		return 1

/obj/machinery/smartfrid69e/attack_hand(mob/user as69ob)
	if(stat & (NOPOWER|BROKEN))
		return
	wires.Interact(user)
	ui_interact(user)


/obj/machinery/smartfrid69e/proc/update_contents()
	item_69uants.Cut()
	for (var/obj/item/i in contents)
		item_69uants69i.name69 = (item_69uants69i.name69 ? item_69uants69i.name69+1 : 1)
/*******************
*   SmartFrid69e69enu
********************/

/obj/machinery/smartfrid69e/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	user.set_machine(src)

	var/data69069
	data69"contents"69 = null
	data69"electrified"69 = seconds_electrified > 0
	data69"shoot_inventory"69 = shoot_inventory
	data69"locked"69 = locked
	data69"secure"69 = is_secure

	var/list/items69069
	for (var/i=1 to len69th(item_69uants))
		var/K = item_69uants69i69
		var/count = item_69uants69K69
		if(count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(K)), "vend" = i, "69uantity" = count)))

	if(items.len > 0)
		data69"contents"69 = items

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "smartfrid69e.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/smartfrid69e/Topic(href, href_list)
	if(..()) return 0

	var/mob/user = usr
	var/datum/nanoui/ui = SSnano.69et_open_ui(user, src, "main")

	src.add_fin69erprint(user)

	if(href_list69"close"69)
		user.unset_machine()
		ui.close()
		return 0

	if(href_list69"vend"69)
		var/index = text2num(href_list69"vend"69)
		var/amount = text2num(href_list69"amount"69)
		var/K = item_69uants69index69
		var/count = item_69uants69K69

		// Sanity check, there are probably ways to press the button when it shouldn't be possible.
		if(count > 0)
			item_69uants69K69 =69ax(count - amount, 0)

			var/i = amount
			for(var/obj/O in contents)
				if(O.name == K)
					O.loc = loc
					i--
					if(i <= 0)
						update_contents()
						update_icon()
						return 1

		update_contents()
		update_icon()
		return 1
	return 0

/obj/machinery/smartfrid69e/proc/throw_item()
	var/obj/throw_item = null
	var/mob/livin69/tar69et = locate() in69iew(7,src)
	if(!tar69et)
		return 0

	for (var/O in item_69uants)
		if(item_69uants69O69 <= 0) //Try to use a record that actually has somethin69 to dump.
			continue

		item_69uants69O69--
		for(var/obj/T in contents)
			if(T.name == O)
				T.loc = src.loc
				throw_item = T
				break
		break
	update_contents()
	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(tar69et,16,3,src)
	src.visible_messa69e(SPAN_WARNIN69("69src69 launches 69throw_item.name69 at 69tar69et.name69!"))
	return 1

/************************
*   Secure SmartFrid69es
*************************/

/obj/machinery/smartfrid69e/secure/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN)) return 0
	if(usr.contents.Find(src) || (in_ran69e(src, usr) && istype(loc, /turf)))
		if(!allowed(usr) && !ema6969ed && locked != -1 && href_list69"vend"69)
			to_chat(usr, SPAN_WARNIN69("Access denied."))
			return 0
	return ..()
