/obj/structure/bed/chair/e_chair
	name = "electric chair"
	desc = "Looks absolutely SHOCKIN69!"
	icon_state = "echair0"
	var/obj/item/assembly/shock_kit/part = new()
	var/last_time = 1

/obj/structure/bed/chair/e_chair/New()
	..()
	overlays += ima69e('icons/obj/objects.dmi', src, "echair_over",69OB_LAYER + 1, dir)
	return

/obj/structure/bed/chair/e_chair/attackby(var/obj/item/tool/tool,69ar/mob/user)
	if(!tool.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_BOLT_TURNIN69, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
		return
	var/obj/structure/bed/chair/C = new /obj/structure/bed/chair(loc)
	C.set_dir(dir)
	part.loc = loc
	part.master = null
	part = null
	69del(src)

/obj/structure/bed/chair/e_chair/verb/to6969le()
	set name = "To6969le Electric Chair"
	set cate69ory = "Object"
	set src in oview(1)

	icon_state = "echair1"
	to_chat(usr, SPAN_NOTICE("You switch on 69src69."))
	shock()

	return

/obj/structure/bed/chair/e_chair/rotate()
	..()
	overlays.Cut()
	overlays += ima69e('icons/obj/objects.dmi', src, "echair_over",69OB_LAYER + 1, dir)	//there's probably a better way of handlin69 this, but eh. -Pete
	return

/obj/structure/bed/chair/e_chair/proc/shock()
	if(last_time + 50 > world.time)
		return
	last_time = world.time

	// special power handlin69
	var/area/A = 69et_area(src)
	if(!isarea(A))
		return
	if(!A.powered(STATIC_E69UIP))
		return
	A.use_power(STATIC_E69UIP, 5000)
	var/li69ht = A.power_li69ht
	A.updateicon()

	flick("echair1", src)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(12, 1, src)
	s.start()
	if(buckled_mob)
		buckled_mob.burn_skin(110)
		to_chat(buckled_mob, SPAN_DAN69ER("You feel a deep shock course throu69h your body!"))
		sleep(1)
		buckled_mob.burn_skin(110)
		buckled_mob.Stun(600)
	visible_messa69e(SPAN_DAN69ER("The electric chair went off!"), SPAN_DAN69ER("You hear a deep sharp shock!"))
	icon_state = "echair0"

	A.power_li69ht = li69ht
	A.updateicon()

	return
