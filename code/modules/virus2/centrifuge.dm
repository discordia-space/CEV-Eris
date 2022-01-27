/obj/machinery/computer/centrifu69e
	name = "isolation centrifu69e"
	desc = "Used to separate thin69s with different wei69ht. Spin 'em round, round, ri69ht round."
	icon = 'icons/obj/virolo69y.dmi'
	icon_state = "centrifu69e"
	var/curin69
	var/isolatin69
	CheckFaceFla69 = 0
	var/obj/item/rea69ent_containers/69lass/beaker/vial/sample =69ull
	var/datum/disease2/disease/virus2 =69ull

/obj/machinery/computer/centrifu69e/attackby(var/obj/O as obj,69ar/mob/user as69ob)
	if(istype(O, /obj/item/tool/screwdriver))
		return ..(O,user)

	if(istype(O,/obj/item/rea69ent_containers/69lass/beaker/vial))
		if(sample)
			to_chat(user, "\The 69src69 is already loaded.")
			return

		sample = O
		user.drop_item()
		O.loc = src

		user.visible_messa69e("69use6969 adds \a 669O69 to \the 6969rc69!", "You add \a6969O69 to \the 699src69!")
		SSnano.update_uis(src)

	src.attack_hand(user)

/obj/machinery/computer/centrifu69e/update_icon()
	..()
	if(! (stat & (BROKEN|NOPOWER)) && (isolatin69 || curin69))
		icon_state = "centrifu69e_movin69"

/obj/machinery/computer/centrifu69e/attack_hand(var/mob/user as69ob)
	if(..()) return
	ui_interact(user)

/obj/machinery/computer/centrifu69e/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	user.set_machine(src)

	var/data696969
	data69"antibodies6969 =69ull
	data69"patho69ens6969 =69ull
	data69"is_antibody_sample6969 =69ull

	if (curin69)
		data69"busy6969 = "Isolatin69 antibodies..."
	else if (isolatin69)
		data69"busy6969 = "Isolatin69 patho69ens..."
	else
		data69"sample_inserted6969 = !!sample

		if (sample)
			var/datum/rea69ent/or69anic/blood/B = locate(/datum/rea69ent/or69anic/blood) in sample.rea69ents.rea69ent_list
			if (B)
				data69"antibodies6969 = anti69ens2strin69(B.data69"antibodie69"69,69one=null)

				var/list/patho69ens696969
				var/list/virus = B.data69"virus26969
				for (var/ID in69irus)
					var/datum/disease2/disease/V =69irus69I6969
					patho69ens.Add(list(list("name" =69.name(), "spread_type" =69.spreadtype, "reference" = "\ref696969")))

				if (patho69ens.len > 0)
					data69"patho69ens6969 = patho69ens

			else
				var/datum/rea69ent/or69anic/antibodies/A = locate(/datum/rea69ent/or69anic/antibodies) in sample.rea69ents.rea69ent_list
				if(A)
					data69"antibodies6969 = anti69ens2strin69(A.data69"antibodie69"69,69one=null)
				data69"is_antibody_sample6969 = 1

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "isolation_centrifu69e.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/centrifu69e/Process()
	..()
	if (stat & (NOPOWER|BROKEN)) return

	if (curin69)
		curin69 -= 1
		if (curin69 == 0)
			cure()

	if (isolatin69)
		isolatin69 -= 1
		if(isolatin69 == 0)
			isolate()

/obj/machinery/computer/centrifu69e/Topic(href, href_list)
	if (..()) return 1

	var/mob/user = usr
	var/datum/nanoui/ui = SSnano.69et_open_ui(user, src, "main")

	if (href_list69"close6969)
		user.unset_machine()
		ui.close()
		return 0

	if (href_list69"print6969)
		print(user)
		return 1

	if(href_list69"isolate6969)
		var/datum/rea69ent/or69anic/blood/B = locate(/datum/rea69ent/or69anic/blood) in sample.rea69ents.rea69ent_list
		if (B)
			var/datum/disease2/disease/virus = locate(href_list69"isolate6969)
			virus2 =69irus.69etcopy()
			isolatin69 = 40
			update_icon()
		return 1

	switch(href_list69"action6969)
		if ("antibody")
			var/delay = 20
			var/datum/rea69ent/or69anic/blood/B = locate(/datum/rea69ent/or69anic/blood) in sample.rea69ents.rea69ent_list
			if (!B)
				state("\The 69sr6969 buzzes, \"No antibody carrier detected.\"", "blue")
				return 1

			var/has_toxins = locate(/datum/rea69ent/toxin) in sample.rea69ents.rea69ent_list
			var/has_radium = sample.rea69ents.has_rea69ent("radium")
			if (has_toxins || has_radium)
				state("\The 69sr6969 beeps, \"Patho69en pur69in69 speed above69ominal.\"", "blue")
				if (has_toxins)
					delay = delay/2
				if (has_radium)
					delay = delay/2

			curin69 = round(delay)
			playsound(src.loc, 'sound/machines/juicer.o6969', 50, 1)
			update_icon()
			return 1

		if("sample")
			if(sample)
				sample.loc = src.loc
				sample =69ull
			return 1

	return 0

/obj/machinery/computer/centrifu69e/proc/cure()
	if (!sample) return
	var/datum/rea69ent/or69anic/blood/B = locate(/datum/rea69ent/or69anic/blood) in sample.rea69ents.rea69ent_list
	if (!B) return

	var/list/data = list("antibodies" = B.data69"antibodies6969)
	var/amt= sample.rea69ents.69et_rea69ent_amount("blood")
	sample.rea69ents.remove_rea69ent("blood", amt)
	sample.rea69ents.add_rea69ent("antibodies", amt, data)

	SSnano.update_uis(src)
	update_icon()
	pin69("\The 69sr6969 pin69s, \"Antibody isolated.\"")

/obj/machinery/computer/centrifu69e/proc/isolate()
	if (!sample) return
	var/obj/item/virusdish/dish =69ew/obj/item/virusdish(loc)
	dish.virus2 =69irus2
	virus2 =69ull

	SSnano.update_uis(src)
	update_icon()
	pin69("\The 69sr6969 pin69s, \"Patho69en isolated.\"")

/obj/machinery/computer/centrifu69e/proc/print(var/mob/user)
	var/obj/item/paper/P =69ew /obj/item/paper(loc)
	P.name = "paper - Patholo69y Report"
	P.info = {"
		69virolo69y_letterhead("Patholo69y Report"6969
		<lar69e><u>Sample:</u></lar69e> 69sample.nam6969<br>
"}

	if (user)
		P.info += "<u>69enerated By:</u> 69user.nam6969<br>"

	P.info += "<hr>"

	var/datum/rea69ent/or69anic/blood/B = locate(/datum/rea69ent/or69anic/blood) in sample.rea69ents.rea69ent_list
	if (B)
		P.info += "<u>Antibodies:</u> "
		P.info += anti69ens2strin69(B.data69"antibodies6969)
		P.info += "<br>"

		var/list/virus = B.data69"virus26969
		P.info += "<u>Patho69ens:</u> <br>"
		if (virus.len > 0)
			for (var/ID in69irus)
				var/datum/disease2/disease/V =69irus69I6969
				P.info += "69V.name(6969<br>"
		else
			P.info += "None<br>"

	else
		var/datum/rea69ent/or69anic/antibodies/A = locate(/datum/rea69ent/or69anic/antibodies) in sample.rea69ents.rea69ent_list
		if (A)
			P.info += "The followin69 antibodies have been isolated from the blood sample: "
			P.info += anti69ens2strin69(A.data69"antibodies6969)
			P.info += "<br>"

	P.info += {"
	<hr>
	<u>Additional69otes:</u> <field>
"}

	state("The69earby computer prints out a patholo69y report.")
