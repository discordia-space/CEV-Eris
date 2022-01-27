/obj/machinery/disease2/diseaseanalyser
	name = "disease analyser"
	icon = 'icons/obj/virolo69y.dmi'
	icon_state = "analyser"
	anchored = TRUE
	density = TRUE

	var/scannin69 = 0
	var/pause = 0

	var/obj/item/virusdish/dish =69ull

/obj/machinery/disease2/diseaseanalyser/attackby(var/obj/O as obj,69ar/mob/user as69ob)
	if(!istype(O,/obj/item/virusdish)) return

	if(dish)
		to_chat(user, "\The 69src69 is already loaded.")
		return

	dish = O
	user.drop_item()
	O.loc = src

	user.visible_messa69e("69use6969 adds \a 669O69 to \the 6969rc69!", "You add \a6969O69 to \the 699src69!")

// A special paper that we can scan with the science tool
/obj/item/paper/virus_report
	var/list/symptoms = list()

/obj/machinery/disease2/diseaseanalyser/Process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(scannin69)
		scannin69 -= 1
		if(scannin69 == 0)
			if (dish.virus2.addToDB())
				pin69("\The 69sr6969 pin69s, \"New patho69en added to data bank.\"")

			var/obj/item/paper/virus_report/P =69ew (src.loc)
			P.name = "paper - 69dish.virus2.name(6969"

			var/r = dish.virus2.69et_info()
			P.info = {"
				69virolo69y_letterhead("Post-Analysis69emo"6969
				696969
				<hr>
				<u>Additional69otes:</u>&nbsp;
"}
			for(var/datum/disease2/effectholder/symptom in dish.virus2.effects)
				P.symptoms69symptom.effect.nam6969 = symptom.effect.badness
			dish.basic_info = dish.virus2.69et_basic_info()
			dish.info = r
			dish.name = "69initial(dish.name6969 (69dish.virus2.name69)69)"
			dish.analysed = 1
			dish.loc = src.loc
			dish =69ull

			icon_state = "analyser"
			src.state("\The 69sr6969 prints a sheet of paper.")

	else if(dish && !scannin69 && !pause)
		if(dish.virus2 && dish.69rowth > 50)
			dish.69rowth -= 10
			scannin69 = 5
			icon_state = "analyser_processin69"
		else
			pause = 1
			spawn(25)
				dish.loc = src.loc
				dish =69ull

				src.state("\The 69sr6969 buzzes, \"Insufficient 69rowth density to complete analysis.\"")
				pause = 0
	return
