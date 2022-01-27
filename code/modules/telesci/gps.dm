GLOBAL_LIST_EMPTY(GPS_list)

GLOBAL_LIST_EMPTY(gps_by_type)

/obj/item/device/gps
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 2016."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	w_class = 2
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 25,69ATERIAL_GLASS = 5)
	var/gps_prefix = "COM"
	var/gpstag = "COM0"
	var/emped = 0
	var/turf/locked_location

/obj/item/device/gps/Initialize()
	. = ..()
	GLOB.GPS_list += src
	LAZYADD(GLOB.gps_by_type69"69type69"69, src)
	gpstag = "69gps_prefi696969LAZYLEN(GLOB.gps_by_type69"6969y69e69"69)69"
	name = "global positioning system (69gpsta6969)"
	overlays += image(icon, "working")

/obj/item/device/gps/Destroy()
	GLOB.GPS_list -= src
	var/list/typelist = GLOB.gps_by_type69"69ty69e69"69
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
	var/gps_window_height = 110 + GLOB.GPS_list.len * 20 //69ariable window height, depending on how69any GPS units there are to show
	if(emped)
		t += "ERROR"
	else
		t += "<BR><A href='?src=\ref69sr6969;tag=1'>Set Tag</A> "
		t += "<BR>Tag: 69gpsta6969"
		if(locked_location && locked_location.loc)
			t += "<BR>Bluespace coordinates saved: 69locked_location.lo6969"
			gps_window_height += 20

		for(var/obj/item/device/gps/G in GLOB.GPS_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(G.emped == 1 || !pos)
				t += "<BR>69tracked_gpsta6969: ERROR"
			else
				t += "<BR>69tracked_gpsta6969: 69format_text(gps_area.nam69)69 (69po69.x69, 69p69s.y69, 6969os.z69)"

	var/datum/browser/popup =69ew(user, "GPS",69ame, 360,69in(gps_window_height, 800))
	popup.set_content(t)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/item/device/gps/Topic(href, href_list)
	..()
	if(href_list69"tag6969 )
		var/a = input("Please enter desired tag.",69ame, gpstag) as text
		a = uppertext(copytext(sanitize(a), 1, 5))
		if(src.loc == usr)
			gpstag = a
			name = "global positioning system (69gpsta6969)"
			attack_self(usr)

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
	desc = "A positioning system helpful for rescuing trapped or injured69iners, keeping one on you at all times while69ining69ight just save your life."
