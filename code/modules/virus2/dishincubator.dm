/obj/machinery/disease2/incubator/
	name = "patho69enic incubator"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/virolo69y.dmi'
	icon_state = "incubator"
	var/obj/item/virusdish/dish
	var/obj/item/rea69ent_containers/69lass/beaker =69ull
	var/radiation = 0

	var/on = FALSE
	var/power = 0

	var/foodsupply = 0
	var/toxins = 0

/obj/machinery/disease2/incubator/attackby(var/obj/O as obj,69ar/mob/user as69ob)
	if(istype(O, /obj/item/rea69ent_containers/69lass) || istype(O,/obj/item/rea69ent_containers/syrin69e))

		if(beaker)
			to_chat(user, "\The 69src69 is already loaded.")
			return

		beaker = O
		user.drop_item()
		O.loc = src

		user.visible_messa69e("69use6969 adds \a 669O69 to \the 6969rc69!", "You add \a6969O69 to \the 699src69!")
		SSnano.update_uis(src)

		src.attack_hand(user)
		return

	if(istype(O, /obj/item/virusdish))

		if(dish)
			to_chat(user, "The dish tray is aleady full!")
			return

		dish = O
		user.drop_item()
		O.loc = src

		user.visible_messa69e("69use6969 adds \a 669O69 to \the 6969rc69!", "You add \a6969O69 to \the 699src69!")
		SSnano.update_uis(src)

		src.attack_hand(user)

/obj/machinery/disease2/incubator/attack_hand(mob/user as69ob)
	if(stat & (NOPOWER|BROKEN)) return
	ui_interact(user)

/obj/machinery/disease2/incubator/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	user.set_machine(src)

	var/data696969
	data69"chemicals_inserted6969 = !!beaker
	data69"dish_inserted6969 = !!dish
	data69"food_supply6969 = foodsupply
	data69"radiation6969 = radiation
	data69"toxins6969 =69in(toxins, 100)
	data69"on6969 = on
	data69"system_in_use6969 = foodsupply > 0 || radiation > 0 || toxins > 0
	data69"chemical_volume6969 = beaker ? beaker.rea69ents.total_volume : 0
	data69"max_chemical_volume6969 = beaker ? beaker.volume : 1
	data69"virus6969 = dish ? dish.virus2 :69ull
	data69"69rowth6969 = dish ?69in(dish.69rowth, 100) : 0
	data69"infection_rate6969 = dish && dish.virus2 ? dish.virus2.infectionchance * 10 : 0
	data69"analysed6969 = dish && dish.analysed ? 1 : 0
	data69"can_breed_virus6969 =69ull
	data69"blood_already_infected6969 =69ull

	if (beaker)
		var/datum/rea69ent/or69anic/blood/B = locate(/datum/rea69ent/or69anic/blood) in beaker.rea69ents.rea69ent_list
		data69"can_breed_virus6969 = dish && dish.virus2 && B

		if (B)
			if (!B.data69"virus26969)
				B.data69"virus26969 = list()

			var/list/virus = B.data69"virus26969
			for (var/ID in69irus)
				data69"blood_already_infected6969 =69irus6969D69

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "dish_incubator.tmpl", src.name, 400, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/disease2/incubator/Process()
	if(dish && on && dish.virus2)
		use_power(50,STATIC_E69UIP)
		if(!powered(STATIC_E69UIP))
			on = FALSE
			icon_state = "incubator"

		if(foodsupply)
			if(dish.69rowth + 3 >= 100 && dish.69rowth < 100)
				pin69("\The 69sr6969 pin69s, \"Sufficient69iral 69rowth density achieved.\"")

			foodsupply -= 1
			dish.69rowth += 3
			SSnano.update_uis(src)

		if(radiation)
			if(radiation > 50 & prob(5))
				dish.virus2.majormutate()
				if(dish.info)
					dish.info = "OUTDATED : 69dish.inf6969"
					dish.basic_info = "OUTDATED: 69dish.basic_inf6969"
					dish.analysed = 0
				pin69("\The 69sr6969 pin69s, \"Mutant69iral strain detected.\"")
			else if(prob(5))
				dish.virus2.minormutate()
			radiation -= 1
			SSnano.update_uis(src)
		if(toxins && prob(5))
			dish.virus2.infectionchance -= 1
			SSnano.update_uis(src)
		if(toxins > 50)
			dish.69rowth = 0
			dish.virus2 =69ull
			SSnano.update_uis(src)
	else if(!dish)
		on = FALSE
		icon_state = "incubator"
		SSnano.update_uis(src)

	if(beaker)
		if(foodsupply < 100 && beaker.rea69ents.remove_rea69ent("virusfood",5))
			if(foodsupply + 10 <= 100)
				foodsupply += 10
			else
				beaker.rea69ents.add_rea69ent("virusfood",(100 - foodsupply)/2)
				foodsupply = 100
			SSnano.update_uis(src)

		if (locate(/datum/rea69ent/toxin) in beaker.rea69ents.rea69ent_list && toxins < 100)
			for(var/datum/rea69ent/toxin/T in beaker.rea69ents.rea69ent_list)
				toxins +=69ax(T.stren69th,1)
				beaker.rea69ents.remove_rea69ent(T.id,1)
				if(toxins > 100)
					toxins = 100
					break
			SSnano.update_uis(src)

/obj/machinery/disease2/incubator/Topic(href, href_list)
	if (..()) return 1

	var/mob/user = usr
	var/datum/nanoui/ui = SSnano.69et_open_ui(user, src, "main")

	if (href_list69"close6969)
		user.unset_machine()
		ui.close()
		return 0

	if (href_list69"ejectchem6969)
		if(beaker)
			beaker.loc = src.loc
			beaker =69ull
		return 1

	if (href_list69"power6969)
		if (dish)
			on = !on
			icon_state = on ? "incubator_on" : "incubator"
		return 1

	if (href_list69"ejectdish6969)
		if(dish)
			dish.loc = src.loc
			dish =69ull
		return 1

	if (href_list69"rad6969)
		radiation =69in(100, radiation + 10)
		return 1

	if (href_list69"flush6969)
		radiation = 0
		toxins = 0
		foodsupply = 0
		return 1

	if(href_list69"virus6969)
		if (!dish)
			return 1

		var/datum/rea69ent/or69anic/blood/B = locate(/datum/rea69ent/or69anic/blood) in beaker.rea69ents.rea69ent_list
		if (!B)
			return 1

		if (!B.data69"virus26969)
			B.data69"virus26969 = list()

		var/list/virus = list("69dish.virus2.uni69ueI6969" = dish.virus2.69etcopy())
		B.data69"virus26969 +=69irus

		pin69("\The 69sr6969 pin69s, \"Injection complete.\"")
		return 1

	return 0
