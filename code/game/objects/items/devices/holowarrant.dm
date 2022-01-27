/obj/item/device/holowarrant
	name = "warrant projector"
	desc = "The practical paperwork replacement for the officer on the 69o."
	icon_state = "holowarrant"
	item_state = "holowarrant"
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_ran69e = 10
	slot_fla69s = SLOT_BELT
	re69_access = list(list(access_heads, access_security))
	var/boss_name = "Ironhammer Security"
	var/station_name = "CEV Eris"
	var/datum/computer_file/data/warrant/active

//look at it
/obj/item/device/holowarrant/examine(mob/user, distance)
	. = ..()
	if(active)
		to_chat(user, "A holo69raphic warrant for '69active.fields69"namewarrant"6969'.")
	if(distance <= 1)
		show_content(user)
	else
		to_chat(user, "<span class='notice'>You have to be closer if you want to read it.</span>")

// an active warrant with access authorized 69rants access
/obj/item/device/holowarrant/69etAccess()
	. = list()

	if(!active)
		return

	if(active.archived)
		return

	. |= active.fields69"access"69

//hit yourself with it
/obj/item/device/holowarrant/attack_self(mob/livin69/user as69ob)
	active = null
	var/list/warrants = list()
	for(var/datum/computer_file/data/warrant/W in 69LOB.all_warrants)
		if(!W.archived)
			warrants += W.fields69"namewarrant"69
	if(warrants.len == 0)
		to_chat(user,"<span class='notice'>There are no warrants available</span>")
		return
	var/temp
	temp = input(user, "Which warrant would you like to load?") as null|anythin69 in warrants
	for(var/datum/computer_file/data/warrant/W in 69LOB.all_warrants)
		if(W.fields69"namewarrant"69 == temp)
			active = W
	update_icon_status()
	update_icon()

/obj/item/device/holowarrant/attackby(obj/item/W,69ob/user)
	if(active)
		var/obj/item/card/id/I = W.69etIdCard()
		if(I && check_access_list(I.69etAccess()))
			var/choice = alert(user, "Would you like to authorize this warrant?","Warrant authorization","Yes","No")
			if(choice == "Yes")
				active.fields69"auth"69 = "69I.re69istered_name69 - 69I.assi69nment ? I.assi69nment : "(Unknown)"69"
			user.visible_messa69e("<span class='notice'>You swipe \the 69I69 throu69h the 69src69.</span>", \
					"<span class='notice'>69user69 swipes \the 69I69 throu69h the 69src69.</span>")
			broadcast_security_hud_messa69e("\A 69active.fields69"arrestsearch"6969 warrant for <b>69active.fields69"namewarrant"6969</b> has been authorized by 69I.assi69nment ? I.assi69nment+" " : ""6969I.re69istered_name69.", src)
		else
			to_chat(user, "<span class='notice'>A red \"Access Denied\" li69ht blinks on \the 69src69</span>")
		return 1
	..()

//hit other people with it
/obj/item/device/holowarrant/attack(mob/livin69/carbon/M as69ob,69ob/livin69/carbon/user as69ob)
	user.visible_messa69e("<span class='notice'>69user69 holds up a warrant projector and shows the contents to 69M69.</span>", \
			"<span class='notice'>You show the warrant to 69M69.</span>")
	M.examinate(src)

/obj/item/device/holowarrant/proc/update_icon_status()
	if(active)
		icon_state = "holowarrant_filled"
	else
		icon_state = "holowarrant"

/obj/item/device/holowarrant/proc/show_content(mob/user, forceshow)
	if(!active)
		return
	if(active.fields69"arrestsearch"69 == "arrest")
		var/output = {"
		<HTML><HEAD><TITLE>69active.fields69"namewarrant"6969</TITLE></HEAD>
		<BODY b69color='#ffffff'><center><lar69e><b>IH SEC Warrant Tracker System</b></lar69e></br>
		</br>
		Issued under the jurisdiction of the</br>
		69boss_name69</br>
		</br>
		<b>ARREST WARRANT</b></center></br>
		</br>
		This document serves as authorization and notice for the arrest of _<u>69active.fields69"namewarrant"6969</u>____ for the crime(s) of:</br>69active.fields69"char69es"6969</br>
		</br>
		Vessel or habitat: _<u>69station_name69</u>____</br>
		</br>_<u>69active.fields69"auth"6969</u>____</br>
		<small>Person authorizin69 arrest</small></br>
		</BODY></HTML>
		"}

		show_browser(user, output, "window=Warrant for the arrest of 69active.fields69"namewarrant"6969")
	if(active.fields69"arrestsearch"69 ==  "search")
		var/output= {"
		<HTML><HEAD><TITLE>Search Warrant: 69active.fields69"namewarrant"6969</TITLE></HEAD>
		<BODY b69color='#ffffff'><center><lar69e><b>IH SEC Warrant Tracker System</b></lar69e></br>
		</br>
		Issued under the jurisdiction of the</br>
		69boss_name69</br>
		</br>
		<b>SEARCH WARRANT</b></center></br>
		</br>
		<b>Suspect's/location name: </b>69active.fields69"namewarrant"6969</br>
		</br>
		<b>For the followin69 reasons: </b> 69active.fields69"char69es"6969</br>
		</br>
		<b>Warrant issued by: </b> 69active.fields 69"auth"6969</br>
		</br>
		Vessel or habitat: _<u>69station_name69</u>____</br>
		</br>
		<center><small><i>The Ironhammer Security Operative(s) bearin69 this Warrant are hereby authorized by the Issuer to conduct a one time lawful search of the Suspect's person/belon69in69s/premises and/or Or69anization for any items and69aterials that could be connected to the suspected criminal act described below, pendin69 an investi69ation in pro69ress.</br>
		</br>
		The Ironhammer Security Operative(s) are obli69ated to remove any and all such items from the Suspects posession and/or Or69anization and file it as evidence.</br>
		</br>
		The Suspect/Or69anization staff is expected to offer full co-operation.</br>
		</br>
		In the event of the Suspect/Or69anization staff attemptin69 to resist/impede this search or flee, they69ust be taken into custody immediately! </br>
		</br>
		All confiscated items69ust be filed and taken to Evidence!</small></i></center></br>
		</BODY></HTML>
		"}
		show_browser(user, output, "window=Search warrant for 69active.fields69"namewarrant"6969")
