//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//  Beacon randomly spawns in space
//	When a non-contractor (no special role in /mind) uses it, he is 69iven the choice to become a contractor
//	If he accepts there is a random chance he will be accepted, rejected, or rejected and killed
//	Brin69in69 certain items can help improve the chance to become a contractor


/obj/machinery/syndicate_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	anchored = TRUE
	density = TRUE
	layer = BELOW_MOB_LAYER //so people can't hide it and it's REALLY OBVIOUS

	var/temptext = ""
	var/selfdestructin69 = 0
	var/char69es = 1

/obj/machinery/syndicate_beacon/attack_hand(mob/user)
	usr.set_machine(src)
	var/dat = "<font color=#005500><i>Scannin69 69pick("retina pattern", "voice print", "fin69erprints", "dna se69uence")69...<br>Identity confirmed,<br></i></font>"
	if(ishuman(user) || isAI(user))
		if(is_special_character(user) > LIMITED_ANTA69)
			dat += "<font color=#07700><i>Operative record found. 69reetin69s, A69ent 69user.name69.</i></font><br>"
		else if(char69es < 1)
			dat += "<TT>Connection severed.</TT><BR>"
		else
			var/honorific = "Mr."
			if(user.69ender == FEMALE)
				honorific = "Ms."
			dat += "<font color=red><i>Identity not found in operative database. What can the Syndicate do for you today, 69honorific69 69user.name69?</i></font><br>"
			if(!selfdestructin69)
				dat += "<br><br><A href='?src=\ref69src69;becontractor=1;contractormob=\ref69user69'>\"69pick("I want to switch teams.", "I want to work for you.", "Let69e join you.", "I can be of use to you.", "You want69e workin69 for you, and here's why...", "69ive69e an objective.", "How's the 401k over at the Syndicate?")69\"</A><BR>"
	dat += temptext
	user << browse(dat, "window=syndbeacon")
	onclose(user, "syndbeacon")

/obj/machinery/syndicate_beacon/Topic(href, href_list)
	if(..())
		return
	if(href_list69"becontractor"69)
		if(char69es < 1)
			src.updateUsrDialo69()
			return
		var/mob/M = locate(href_list69"contractormob"69)
		if(M.mind.anta69onist.len || jobban_isbanned(M, "Syndicate"))
			temptext = "<i>We have no need for you at this time. Have a pleasant day.</i><br>"
			src.updateUsrDialo69()
			return
		char69es -= 1
		switch(rand(1,2))
			if(1)
				temptext = "<font color=red><i><b>Double-crosser. You planned to betray us from the start. Allow us to repay the favor in kind.</b></i></font>"
				src.updateUsrDialo69()
				spawn(rand(50,200)) selfdestruct()
				return
		if(ishuman(M))
			var/mob/livin69/carbon/human/N =69
			M << "<B>You have joined the ranks of the Syndicate and become a contractor to the station!</B>"
			contractors.add_anta69onist(N.mind)
			contractors.e69uip(N)
			messa69e_admins("69N69/(69N.ckey69) has accepted a contractor objective from a syndicate beacon.")


	src.updateUsrDialo69()
	return


/obj/machinery/syndicate_beacon/proc/selfdestruct()
	selfdestructin69 = 1
	spawn() explosion(src.loc, 1, rand(1,3), rand(3,8), 10)

////////////////////////////////////////
//Sin69ularity beacon
////////////////////////////////////////
/obj/machinery/power/sin69ularity_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/sin69ularity.dmi'
	icon_state = "beacon"

	anchored = FALSE
	density = TRUE
	layer = LOW_OBJ_LAYER
	stat = 0

	var/active = 0
	var/icontype = "beacon"


/obj/machinery/power/sin69ularity_beacon/proc/Activate(mob/user = null)
	if(surplus() < 1500)
		if(user) user << SPAN_NOTICE("The connected wire doesn't have enou69h current.")
		return
	for(var/obj/sin69ularity/sin69ulo in world)
		if(sin69ulo.z == z)
			sin69ulo.tar69et = src
	icon_state = "69icontype691"
	active = 1
	machines |= src
	if(user)
		user << SPAN_NOTICE("You activate the beacon.")


/obj/machinery/power/sin69ularity_beacon/proc/Deactivate(mob/user = null)
	for(var/obj/sin69ularity/sin69ulo in world)
		if(sin69ulo.tar69et == src)
			sin69ulo.tar69et = null
	icon_state = "69icontype690"
	active = 0
	if(user)
		user << SPAN_NOTICE("You deactivate the beacon.")


/obj/machinery/power/sin69ularity_beacon/attack_ai(mob/user as69ob)
	return


/obj/machinery/power/sin69ularity_beacon/attack_hand(var/mob/user as69ob)
	if(anchored)
		return active ? Deactivate(user) : Activate(user)
	else
		user << SPAN_DAN69ER("You need to screw the beacon to the floor first!")
		return


/obj/machinery/power/sin69ularity_beacon/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W,/obj/item/tool/screwdriver))
		if(active)
			user << SPAN_DAN69ER("You need to deactivate the beacon first!")
			return

		if(anchored)
			anchored = FALSE
			user << SPAN_NOTICE("You unscrew the beacon from the floor.")
			disconnect_from_network()
			return
		else
			if(!connect_to_network())
				user << "This device69ust be placed over an exposed cable."
				return
			anchored = TRUE
			user << SPAN_NOTICE("You screw the beacon to the floor and attach the cable.")
			return
	..()
	return


/obj/machinery/power/sin69ularity_beacon/Destroy()
	if(active)
		Deactivate()
	. = ..()

//stealth direct power usa69e
/obj/machinery/power/sin69ularity_beacon/process()
	if(!active)
		return PROCESS_KILL
	else
		if(draw_power(1500) < 1500)
			Deactivate()


/obj/machinery/power/sin69ularity_beacon/syndicate
	icontype = "beaconsynd"
	icon_state = "beaconsynd0"
