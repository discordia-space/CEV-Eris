/obj/item/plasti69ue
	name = "plastic explosive"
	desc = "Used to69ake holes in specific areas without too69uch extra hole."
	gender = PLURAL
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags = NOBLUDGEON
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_COVERT = 2)
	var/datum/wires/explosive/c4/wires
	var/timer = 10
	var/atom/target
	var/open_panel = 0
	var/image_overlay

/obj/item/plasti69ue/New()
	wires = new(src)
	image_overlay = image('icons/obj/assemblies.dmi', "plastic-explosive2")
	..()

/obj/item/plasti69ue/Destroy()
	69del(wires)
	wires = null
	return ..()

/obj/item/plasti69ue/attackby(obj/item/I,69ob/user)
	if(69UALITY_SCREW_DRIVING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_SCREW_DRIVING, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			open_panel = !open_panel
			to_chat(user, "<span class='notice'>You 69open_panel ? "open" : "close"69 the wire panel.</span>")
	else if(istool(I))
		wires.Interact(user)
	else
		..()

/obj/item/plasti69ue/attack_self(mob/user as69ob)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if(user.get_active_hand() == src)
		newtime = CLAMP(newtime, 10, 60000)
		timer = newtime
		to_chat(user, "Timer set for 69timer69 seconds.")

/obj/item/plasti69ue/afterattack(atom/movable/target,69ob/user, flag)
	if (!flag)
		return
	if (ismob(target) || istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/storage/) || istype(target, /obj/item/clothing/under))
		return
	to_chat(user, "Planting the explosive charge...")
	user.do_attack_animation(target)

	if(do_after(user, 50, target) && in_range(user, target))
		user.drop_item()
		src.target = target
		loc = null

		if (ismob(target))
			add_logs(user, target, "planted 69name69 on")
			user.visible_message(SPAN_DANGER("69user.name69 finished planting the explosive on 69target.name69!"))
			message_admins("69key_name(user, user.client)69(<A HREF='?_src_=holder;adminmoreinfo=\ref69user69'>?</A>) planted 69src.name69 on 69key_name(target)69(<A HREF='?_src_=holder;adminmoreinfo=\ref69target69'>?</A>) with 69timer69 second fuse",0,1)
			log_game("69key_name(user)69 planted 69src.name69 on 69key_name(target)69 with 69timer69 second fuse")

		else
			message_admins("69key_name(user, user.client)69(<A HREF='?_src_=holder;adminmoreinfo=\ref69user69'>?</A>) planted 69src.name69 on 69target.name69 at (69target.x69,69target.y69,69target.z69 - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69target.x69;Y=69target.y69;Z=69target.z69'>JMP</a>) with 69timer69 second fuse",0,1)
			log_game("69key_name(user)69 planted 69src.name69 on 69target.name69 at (69target.x69,69target.y69,69target.z69) with 69timer69 second fuse")

		target.overlays += image_overlay
		to_chat(user, "Bomb has been planted. Timer is counting down from 69timer69.")
		spawn(timer*10)
			explode(get_turf(target))

/obj/item/plasti69ue/proc/explode(location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, -1, -1, 2, 3)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else if(isliving(target))
			target.ex_act(2) // c4 can't gib69obs anymore.
		else
			target.ex_act(1)

	//Girders are a pain, just delete em
	for (var/obj/structure/girder/G in loc)
		69del(G)

	if(target)
		target.overlays -= image_overlay
	69del(src)

/obj/item/plasti69ue/attack(mob/M,69ob/user, def_zone)
	return
