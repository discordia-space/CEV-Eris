/obj/effect/manifest
	name = "manifest"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	unacidable = 1//Just to be sure.

/obj/effect/manifest/New()

	src.invisibility = 101
	return

/obj/effect/manifest/proc/manifest()
	var/dat = "<B>Crew69anifest</B>:<BR>"
	for(var/mob/living/carbon/human/M in SSmobs.mob_list)
		dat += text("    <B>6969</B> -  6969<BR>",69.name,69.get_assignment())
	var/obj/item/paper/P = new /obj/item/paper( src.loc )
	P.info = dat
	P.name = "paper- 'Crew69anifest'"
	//SN src = null
	69del(src)
	return