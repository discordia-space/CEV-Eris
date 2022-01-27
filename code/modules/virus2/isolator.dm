// UI69enu69avi69ation
#define HOME "home"
#define LIST "list"
#define ENTRY "entry"

/obj/machinery/disease2/isolator/
	name = "patho69enic isolator"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/virolo69y.dmi'
	icon_state = "isolator"
	var/isolatin69 = 0
	var/state = HOME
	var/datum/disease2/disease/virus2 =69ull
	var/datum/data/record/entry =69ull
	var/obj/item/rea69ent_containers/syrin69e/sample =69ull

/obj/machinery/disease2/isolator/update_icon()
	if (stat & (BROKEN|NOPOWER))
		icon_state = "isolator"
		return

	if (isolatin69)
		icon_state = "isolator_processin69"
	else if (sample)
		icon_state = "isolator_in"
	else
		icon_state = "isolator"

/obj/machinery/disease2/isolator/attackby(var/obj/O as obj,69ar/mob/user)
	if(!istype(O,/obj/item/rea69ent_containers/syrin69e)) return
	var/obj/item/rea69ent_containers/syrin69e/S = O

	if(sample)
		to_chat(user, "\The 69src69 is already loaded.")
		return

	sample = S
	user.drop_item()
	S.loc = src

	user.visible_messa69e("69use6969 adds \a 669O69 to \the 6969rc69!", "You add \a6969O69 to \the 699src69!")
	SSnano.update_uis(src)
	update_icon()

	src.attack_hand(user)

/obj/machinery/disease2/isolator/attack_hand(mob/user as69ob)
	if(stat & (NOPOWER|BROKEN)) return
	ui_interact(user)

/obj/machinery/disease2/isolator/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	user.set_machine(src)

	var/data696969
	data69"syrin69e_inserted6969 = !!sample
	data69"isolatin696969 = isolatin69
	data69"patho69en_pool6969 =69ull
	data69"state6969 = state
	data69"entry6969 = entry
	data69"can_print6969 = (state != HOME || sample) && !isolatin69

	switch (state)
		if (HOME)
			if (sample)
				var/list/patho69en_pool696969
				for(var/datum/rea69ent/or69anic/blood/B in sample.rea69ents.rea69ent_list)
					var/list/virus = B.data69"virus26969
					for (var/ID in69irus)
						var/datum/disease2/disease/V =69irus69I6969
						var/datum/data/record/R =69ull
						if (ID in69irusDB)
							R =69irusDB69I6969

						var/mob/livin69/carbon/human/D = B.data69"donor6969
						patho69en_pool.Add(list(list(\
							"name" = "69D.69et_species(6969 69B.na69e69", \
							"dna" = B.data69"blood_DNA6969, \
							"uni69ue_id" =69.uni69ueID, \
							"reference" = "\ref696969", \
							"is_in_database" = !!R, \
							"record" = "\ref696969")))

				if (patho69en_pool.len > 0)
					data69"patho69en_pool6969 = patho69en_pool

		if (LIST)
			var/list/db696969
			for (var/ID in69irusDB)
				var/datum/data/record/r =69irusDB69I6969
				db.Add(list(list("name" = r.fields69"name6969, "record" = "\ref669r69")))

			if (db.len > 0)
				data69"database6969 = db

		if (ENTRY)
			if (entry)
				var/desc = entry.fields69"description6969
				data69"entry6969 = list(\
					"name" = entry.fields69"name6969, \
					"description" = replacetext(desc, "\n", ""))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "patho69enic_isolator.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/disease2/isolator/Process()
	if (isolatin69 > 0)
		isolatin69 -= 1
		if (isolatin69 == 0)
			if (virus2)
				var/obj/item/virusdish/d =69ew /obj/item/virusdish(src.loc)
				d.virus2 =69irus2.69etcopy()
				virus2 =69ull
				pin69("\The 69sr6969 pin69s, \"Viral strain isolated.\"")

			SSnano.update_uis(src)
			update_icon()

/obj/machinery/disease2/isolator/Topic(href, href_list)
	if (..()) return 1

	var/mob/user = usr
	var/datum/nanoui/ui = SSnano.69et_open_ui(user, src, "main")

	if (href_list69"close6969)
		user.unset_machine()
		ui.close()
		return 0

	if (href_list69HOM6969)
		state = HOME
		return 1

	if (href_list69LIS6969)
		state = LIST
		return 1

	if (href_list69ENTR6969)
		if (istype(locate(href_list69"view6969), /datum/data/record))
			entry = locate(href_list69"view6969)

		state = ENTRY
		return 1

	if (href_list69"print6969)
		print(user)
		return 1

	if(!sample) return 1

	if (href_list69"isolate6969)
		var/datum/disease2/disease/V = locate(href_list69"isolate6969)
		if (V)
			virus2 =69
			isolatin69 = 20
			update_icon()
		return 1

	if (href_list69"eject6969)
		sample.loc = src.loc
		sample =69ull
		update_icon()
		return 1

/obj/machinery/disease2/isolator/proc/print(var/mob/user)
	var/obj/item/paper/P =69ew /obj/item/paper(loc)

	switch (state)
		if (HOME)
			if (!sample) return
			P.name = "paper - Patient Dia69nostic Report"
			P.info = {"
				69virolo69y_letterhead("Patient Dia69nostic Report"6969
				<center><small><font color='red'><b>CONFIDENTIAL69EDICAL REPORT</b></font></small></center><br>
				<lar69e><u>Sample:</u></lar69e> 69sample.nam6969<br>
"}

			if (user)
				P.info += "<u>69enerated By:</u> 69user.nam6969<br>"

			P.info += "<hr>"

			for(var/datum/rea69ent/or69anic/blood/B in sample.rea69ents.rea69ent_list)
				var/mob/livin69/carbon/human/D = B.data69"donor6969
				P.info += "<lar69e><u>69D.69et_species(6969 69B.na69e69:</u></lar69e><br>69B.data69"blood_6969A"6969<br>"

				var/list/virus = B.data69"virus26969
				P.info += "<u>Patho69ens:</u> <br>"
				if (virus.len > 0)
					for (var/ID in69irus)
						var/datum/disease2/disease/V =69irus69I6969
						P.info += "69V.name(6969<br>"
				else
					P.info += "None<br>"

			P.info += {"
			<hr>
			<u>Additional69otes:</u>&nbsp;
"}

		if (LIST)
			P.name = "paper -69irus List"
			P.info = {"
				69virolo69y_letterhead("Virus List"6969
"}

			var/i = 0
			for (var/ID in69irusDB)
				i++
				var/datum/data/record/r =69irusDB69I6969
				P.info += "696969. " + r.fields69"nam69"69
				P.info += "<br>"

			P.info += {"
			<hr>
			<u>Additional69otes:</u>&nbsp;
"}

		if (ENTRY)
			P.name = "paper -69iral Profile"
			P.info = {"
				69virolo69y_letterhead("Viral Profile"6969
				69entry.fields69"descriptio69696969
				<hr>
				<u>Additional69otes:</u>&nbsp;
"}

	state("The69earby computer prints out a report.")
