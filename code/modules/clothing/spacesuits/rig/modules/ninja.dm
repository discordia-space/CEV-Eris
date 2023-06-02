/*
 * Contains
 * /obj/item/rig_module/stealth_field
 * /obj/item/rig_module/teleporter
 * /obj/item/rig_module/fabricator/energy_net
 * /obj/item/rig_module/self_destruct
 */

/obj/item/rig_module/stealth_field
	name = "active camouflage module"
	desc = "A robust hardsuit-integrated stealth module."
	icon_state = "cloak"

	origin_tech = list(TECH_POWER = 6, TECH_MAGNET = 6, TECH_ENGINEERING = 6)

	toggleable = 1
	disruptable = 1
	disruptive = 0

	// Fully charged RIG have 0.5 KILOWATTS
	use_power_cost = 0.1 KILOWATTS
	active_power_cost = 0.01 KILOWATTS
	passive_power_cost = 0
	module_cooldown = 3 SECONDS

	activate_string = "Enable Cloak"
	deactivate_string = "Disable Cloak"

	interface_name = "integrated stealth system"
	interface_desc = "An integrated active camouflage system."

	spawn_blacklisted = TRUE

/obj/item/rig_module/stealth_field/activate()
	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	H.visible_message(SPAN_WARNING("\The [H] seems to disappear before your eyes!"), SPAN_NOTICE("You feel completely invisible."))

	H.invisibility = INVISIBILITY_LEVEL_TWO
	H.alpha = 0
	H.mouse_opacity = 0

	anim(get_turf(H), H, 'icons/mob/mob.dmi', , "cloak", , H.dir)
	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity", null, 20, null)

/obj/item/rig_module/stealth_field/deactivate()
	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	H.visible_message(SPAN_WARNING("\The [src] appears from thin air!"), SPAN_NOTICE("You have re-appeared."))

	H.invisibility = initial(H.invisibility)
	H.alpha = initial(H.alpha)
	H.mouse_opacity = initial(H.mouse_opacity)

	anim(get_turf(H), H,'icons/mob/mob.dmi',,"uncloak",,H.dir)
	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity", null, 20, null)

	playsound(get_turf(H), 'sound/effects/stealthoff.ogg', 75, 1)


/obj/item/rig_module/teleporter

	name = "teleportation module"
	desc = "A complex, sleek-looking, hardsuit-integrated teleportation module."
	icon_state = "teleporter"
	use_power_cost = 40
	redundant = 1
	usable = 1
	selectable = 1

	engage_string = "Emergency Leap"

	interface_name = "VOID-shift phase projector"
	interface_desc = "An advanced teleportation system. It is capable of pinpoint precision or random leaps forward."
	spawn_blacklisted = TRUE

/obj/item/rig_module/teleporter/proc/phase_in(var/mob/M,var/turf/T)

	if(!M || !T)
		return

	holder.spark_system.start()
	playsound(T, 'sound/effects/phasein.ogg', 25, 1)
	playsound(T, 'sound/effects/sparks2.ogg', 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phasein",,M.dir)

/obj/item/rig_module/teleporter/proc/phase_out(var/mob/M,var/turf/T)

	if(!M || !T)
		return

	playsound(T, "sparks", 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phaseout",,M.dir)

/obj/item/rig_module/teleporter/engage(atom/target, notify_ai)

	if(!..()) return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!istype(H.loc, /turf))
		to_chat(H, SPAN_WARNING("You cannot teleport out of your current location."))
		return 0

	var/turf/T
	if(target)
		T = get_turf(target)
	else
		T = get_teleport_loc(get_turf(H), H, rand(5, 9))

	if(!T || T.density)
		to_chat(H, SPAN_WARNING("You cannot teleport into solid walls."))
		return 0

	if(isAdminLevel(T.z))
		to_chat(H, SPAN_WARNING("You cannot use your teleporter on this Z-level."))
		return 0

	if(T.contains_dense_objects())
		to_chat(H, SPAN_WARNING("You cannot teleport to a location with solid objects."))
		return 0

	if(T.z != H.z || get_dist(T, get_turf(H)) > world.view)
		to_chat(H, SPAN_WARNING("You cannot teleport to such a distant object."))
		return 0

	phase_out(H,get_turf(H))
	go_to_bluespace(get_turf(H), 3, TRUE, H, T)
	phase_in(H,get_turf(H))

	for(var/obj/item/grab/G in H.contents)
		if(G.affecting)
			phase_out(G.affecting,get_turf(G.affecting))
			go_to_bluespace(get_turf(H), 3, TRUE, G.affecting, locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z))
			phase_in(G.affecting,get_turf(G.affecting))

	return 1

/obj/item/rig_module/fabricator/energy_net
	name = "net projector"
	desc = "Some kind of complex energy projector with a hardsuit mount."
	icon_state = "enet"

	interface_name = "energy net launcher"
	interface_desc = "An advanced energy-patterning projector used to capture targets."

	engage_string = "Fabricate Net"

	fabrication_type = /obj/item/energy_net
	use_power_cost = 70
	rarity_value = 50

/obj/item/rig_module/fabricator/energy_net/engage(atom/target)

	if(holder && holder.wearer)
		if(..(target) && target)
			holder.wearer.Beam(target,"n_beam",,10)
		return 1
	return 0

/obj/item/rig_module/self_destruct
	name = "self-destruct module"
	desc = "Oh my God, Captain. A bomb."
	icon_state = "deadman"
	usable = 1
	active = 1
	permanent = 1

	engage_string = "Detonate"

	interface_name = "dead man's switch"
	interface_desc = "An integrated self-destruct module. When the wearer dies, so does the surrounding area. Do not press this button."
	rarity_value = 20
	var/explosion_power = 800
	var/explosion_falloff = 200
	var/explosion_flags = EFLAG_ADDITIVEFALLOFF

/obj/item/rig_module/self_destruct/small
	explosion_power = 400

/obj/item/rig_module/self_destruct/activate()
	return

/obj/item/rig_module/self_destruct/deactivate()
	return

/obj/item/rig_module/self_destruct/Process()

	// Not being worn, leave it alone.
	if(!holder || !holder.wearer || !holder.wearer.wear_suit == holder)
		return 0

	//OH SHIT.
	if(holder.wearer.stat == 2)
		engage(1)

/obj/item/rig_module/self_destruct/engage(var/skip_check)
	if(!skip_check && usr && alert(usr, "Are you sure you want to push that button?", "Self-destruct", "No", "Yes") == "No")
		return
	explosion(get_turf(src), explosion_power, explosion_falloff, explosion_flags)
	if(holder && holder.wearer)
		holder.wearer.drop_from_inventory(src)
		qdel(holder)
	qdel(src)
