
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Miscellaneous xenoarchaeology tools
GLOBAL_LIST_EMPTY(GPS_list)

GLOBAL_LIST_EMPTY(gps_by_type)

/obj/item/device/gps
	name = "relay positioning device"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	//item_state = "locator"

	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 1)

	var/gps_prefix = "COM"
	var/gpstag = "COM0"
	var/emped = 0
	var/turf/locked_location

/obj/item/device/gps/proc/get_coordinates()
	var/turf/T = get_turf(src)
	return T ? "[T.x].[rand(0,9)]:[T.y].[rand(0,9)]:[T.z].[rand(0,9)]" : "N/A"

/obj/item/device/gps/Initialize()
	. = ..()
	GLOB.GPS_list += src
	LAZYADD(GLOB.gps_by_type["[type]"], src)
	gpstag = "[gps_prefix][LAZYLEN(GLOB.gps_by_type["[type]"])]"
	name = "global positioning system ([gpstag])"
	overlays += image(icon, "working")

/obj/item/device/gps/Destroy()
	GLOB.GPS_list -= src
	var/list/typelist = GLOB.gps_by_type["[type]"]
	LAZYREMOVE(typelist, src)
	return ..()

/obj/item/device/gps/emp_act(severity)
	emped = 1
	overlays.Cut()
	overlays += image(icon, "emp")
	addtimer(CALLBACK(src, .proc/post_emp), 300)

/obj/item/device/gps/proc/post_emp()
	emped = 0
	overlays.Cut()
	overlays += image(icon, "working")

/obj/item/device/gps/attack_self(mob/user)

	var/obj/item/device/gps/t = ""
	var/gps_window_height = 110 + GLOB.GPS_list.len * 20 // Variable window height, depending on how many GPS units there are to show
	if(emped)
		t += "ERROR"
	else
		t += "<BR><A href='?src=\ref[src];tag=1'>Set Tag</A> "
		t += "<BR>Tag: [gpstag]"
		if(locked_location && locked_location.loc)
			t += "<BR>Bluespace coordinates saved: [locked_location.loc]"
			gps_window_height += 20

		for(var/obj/item/device/gps/G in GLOB.GPS_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(G.emped == 1 || !pos)
				t += "<BR>[tracked_gpstag]: ERROR"
			else
				t += "<BR>[tracked_gpstag]: [format_text(gps_area.name)] ([get_coordinates()])"

	var/datum/browser/popup = new(user, "GPS", name, 360, min(gps_window_height, 800))
	popup.set_content(t)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/item/device/gps/Topic(href, href_list)
	..()
	if(href_list["tag"] )
		var/a = input("Please enter desired tag.", name, gpstag) as text
		a = uppertext(copytext(sanitize(a), 1, 5))
		if(src.loc == usr)
			gpstag = a
			name = "global positioning system ([gpstag])"
			attack_self(usr)

/obj/item/device/gps/examine(var/mob/user)
	..()
	to_chat(user, "<span class='notice'>\The [src]'s screen shows: <i>[get_coordinates()]</i>.</span>")

/*/obj/item/device/gps/attack_self(var/mob/user as mob)
	to_chat(user, "<span class='notice'>\icon[src] \The [src] flashes <i>[get_coordinates()]</i>.</span>")*/

/obj/item/device/gps/science
	icon_state = "gps-s"
	gps_prefix = "SCI"
	gpstag = "SCI0"

/obj/item/device/gps/engineering
	icon_state = "gps-e"
	gps_prefix = "ENG"
	gpstag = "ENG0"

/obj/item/device/gps/mining
	icon_state = "gps-m"
	gps_prefix = "MIN"
	gpstag = "MIN0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."


/obj/item/device/measuring_tape
	name = "measuring tape"
	desc = "A coiled metallic tape used to check dimensions and lengths."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "measuring"
	w_class = ITEM_SIZE_SMALL

//todo: dig site tape

/obj/item/weapon/storage/bag/fossils
	name = "Fossil Satchel"
	desc = "Transports delicate fossils in suspension so they don't break during transit."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEM_SIZE_NORMAL
	max_storage_space = 100
	max_w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/weapon/fossil)
