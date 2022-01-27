/obj/machinery/computer/curer
	name = "cure research69achine"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	li69ht_color = COLOR_LI69HTIN69_69REEN_MACHINERY
	circuit = /obj/item/electronics/circuitboard/curefab
	var/curin69
	var/virusin69
	CheckFaceFla69 = 0
	var/obj/item/rea69ent_containers/container =69ull

/obj/machinery/computer/curer/attackby(var/obj/I as obj,69ar/mob/user as69ob)
	if(istype(I,/obj/item/rea69ent_containers))
		var/mob/livin69/carbon/C = user
		if(!container)
			container = I
			C.drop_item()
			I.loc = src
		return
	if(istype(I,/obj/item/virusdish))
		if(virusin69)
			to_chat(user, "<b>The patho69en69aterializer is still rechar69in69..</b>")
			return
		var/obj/item/rea69ent_containers/69lass/beaker/product =69ew(src.loc)

		var/list/data = list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"virus2"=list(),"antibodies"=list())
		data69"virus2"69 |= I:virus2
		product.rea69ents.add_rea69ent("blood",30,data)

		virusin69 = 1
		spawn(1200)69irusin69 = 0

		state("The 69src.nam6969 Buzzes", "blue")
		return
	..()
	return

/obj/machinery/computer/curer/attack_hand(mob/user)
	if(..())
		return
	user.machine = src
	var/dat
	if(curin69)
		dat = "Antibody production in pro69ress"
	else if(virusin69)
		dat = "Virus production in pro69ress"
	else if(container)
		// see if there's any blood in the container
		var/datum/rea69ent/or69anic/blood/B = locate(/datum/rea69ent/or69anic/blood) in container.rea69ents.rea69ent_list

		if(B)
			dat = "Blood sample inserted."
			dat += "<BR>Antibodies: 69anti69ens2strin69(B.data69"antibodie69"69)69"
			dat += "<BR><A href='?src=\ref69sr6969;antibody=1'>Be69in antibody production</a>"
		else
			dat += "<BR>Please check container contents."
		dat += "<BR><A href='?src=\ref69sr6969;eject=1'>Eject container</a>"
	else
		dat = "Please insert a container."

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/curer/Process()
	..()

	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)

	if(curin69)
		curin69 -= 1
		if(curin69 == 0)
			if(container)
				createcure(container)
	return

/obj/machinery/computer/curer/Topic(href, href_list)
	if(..())
		return 1
	usr.machine = src

	if (href_list69"antibody6969)
		curin69 = 10
	else if(href_list69"eject6969)
		container.loc = src.loc
		container =69ull

	src.updateUsrDialo69()


/obj/machinery/computer/curer/proc/createcure(var/obj/item/rea69ent_containers/container)
	var/obj/item/rea69ent_containers/69lass/beaker/product =69ew(src.loc)

	var/datum/rea69ent/or69anic/blood/B = locate() in container.rea69ents.rea69ent_list

	var/list/data = list()
	data69"antibodies6969 = B.data69"antibodie69"69
	product.rea69ents.add_rea69ent("antibodies",30,data)

	state("\The 69src.nam6969 buzzes", "blue")
