var/global/excelsior_centor

/obj/machinery/centor
	name = "Excelsior \"Centor\" core"								// TODO consider changing a name just in case
	icon = 'icons/obj/machines/excelsior/corenode/centor.dmi'
	desc = "Metallic mind, it's silent thoughts reaching far away to the Haven."		// TODO ensure this is fine
	description_info = "Source of power for teleporters, very mortal"
	description_antag = "Repairable with welding tools. Pat it to receive regularly made nodes, or receive stash with KOMPAKS - one for each member of our team."
	icon_state = "static"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/electronics/circuitboard/centor
	health = 1200
	maxHealth = 1200
	shipside_only = TRUE
	var/list/obj/machinery/node/antennas_to_haven = list()
	var/timer_set			//world.time goes here :)
	layer = 5
	var/cutscene = FALSE // if false = add eye overlay
	var/damage_report_cooldown = FALSE
	var/list/excelsior_kpks = list()
	var/imgonnadie = list(
	"Protect me or it's over.",
	"I'm your only source of power.",
	"Do not leave me.",
	"I believe I'm getting shot at.",
	"Reminder: Higher circle won't send replacements for me.",
	"Don't let me die.",
	"The dream dies with me.",
	"Push them back.",
	"Flush them out.",
	"It's not over yet.",
	"Please stop them from killing me, thanks.",
	"Repair my dents with a torch after the fight.",
	"They're here with me.",
	"PLease assign a guard for me.",
	"My data is getting corrupted.",
	"I don't have combat capabilities.",
	"Construct a cover for me, if you can.",
	"Please shoot back.",
	"Respond with high lethality against these.",
	"We will lose, gather up at my room.",
	"They will come for you next.",)

// FLUFFY ANIMATION :3 //
/obj/machinery/centor/proc/start_cutscene()
	cutscene = TRUE
	update_icon()

/obj/machinery/centor/update_icon()
	overlays.Cut()
	if(!cutscene)
		overlays += "eye_static"
	else
		overlays.Cut()

/obj/machinery/centor/proc/deploy_animation()	// pop up from the hatch
	start_cutscene()
	icon_state = "static"
	flick("deployment", src)
	playsound(src, 'sound/machines/excelsior/centor_open.ogg', 100, 1, ignore_walls = FALSE)
	spawn(1 SECOND)
		end_cutscene()
		looking_around()

/obj/machinery/centor/proc/give_me_nodes_animation()
	var/i = 0
	var/many_nodes = contents.len + 1 SECOND
	if(!cutscene && contents)			// !cutscene is anti-spamclick
		start_cutscene()
		icon_state = "undeployed"
		flick("hide", src)
		playsound(src, 'sound/machines/excelsior/centor_close.ogg', 100, 1, ignore_walls = FALSE)	// yes you can crush my head legally speaking
		spawn(2 SECONDS)
			flick("open_hatch", src)
			icon_state = "hatch"
			spawn(1 SECOND)
				for(var/obj/item in contents)
					i++
					spawn(i)
						item.forceMove(loc)
						item.throw_at(get_edge_target_turf(item, rand(1, 10)), 2, 1)
			spawn(many_nodes)
				flick("close_hatch", src)
				icon_state = "undeployed"
				spawn(1 SECOND)
					deploy_animation()
		return 1
	return 0

/obj/machinery/centor/proc/looking_around()
	if(!cutscene)
		overlays += "idle_anim"
		spawn(12) update_icon()


/obj/machinery/centor/proc/investigating(atom/overhere)
	if(!cutscene)
		start_cutscene()
		overlays += image(icon, loc, "dirs", 5, get_dir(src, overhere))
		spawn(1 SECOND)
			end_cutscene()

/obj/machinery/centor/proc/die()
	start_cutscene()
	icon_state = "death_loop"
	sleep(5 SECONDS)
	icon_state = "death"
	sleep(1 SECOND)
	explosion(get_turf(src), 400, 100)
	Destroy()


/obj/machinery/centor/proc/end_cutscene()
	cutscene = FALSE
	update_icon()

// YOUR ANIMATIONS END HERE //


/obj/machinery/centor/Initialize(mapload, d)
	if(excelsior_centor)
		Destroy()
		return

	var/obj/item/storage/deferred/stash/sack/stash = new(src)
	new /obj/item/computer_hardware/hard_drive/portable/design/excelsior/core(stash)
	new /obj/item/computer_hardware/hard_drive/portable/design/excelsior/weapons(stash)
	new /obj/item/machinery_crate/excelsior/autolathe(stash)
	new /obj/item/machinery_crate/excelsior/excelsior_teleporter(stash)
	new /obj/item/storage/toolbox/mechanical(stash)

	contents.Add(stash)

	deploy_animation()
	excelsior_centor = src
	timer_set = world.time
	. = ..()
	load_network()





/obj/machinery/centor/Destroy()
	for(var/obj/machinery/node/node in excelsior_nodes)
		if(dist3D(src, node) <= EX_NODE_DISTANCE)
			node.spread_signal(null)
	excelsior_centor = null
	. = ..()





/obj/machinery/centor/Process()
	if(prob(25))
		looking_around()
	collect_tax()	// this is where we get energy :]
	increase_node_amount()




/obj/machinery/centor/proc/collect_tax()
	for(var/obj/machinery/complant_teleporter/tele in excelsior_teleporters)
		tele.old_energy = excelsior_energy
	for(var/obj/machinery/node/node in antennas_to_haven)
		excelsior_energy += (node.activemarkerlist.len / node.localmarkerlist.len)	// +1 energy if all markers (influence) are active, see more at [node.dm]
	for(var/route in excelsior_junctions)
		excelsior_energy += 0.25
	if(excelsior_energy >= excelsior_max_energy)
		excelsior_energy = excelsior_max_energy
		return

/obj/machinery/centor/proc/increase_node_amount()
	if(world.time >= timer_set + EX_NODE_SPAWN_COOLDOWN)
		contents.Add(new /obj/item/machinery_crate/excelsior/node)
		timer_set = world.time
		playsound(loc, 'sound/machines/vending_drop.ogg', 100, 1, ignore_walls = FALSE)




/obj/machinery/centor/attack_hand(mob/user)
//	. = ..()		//uncomment to give power consumption :)	(I dont want it...)
	if(!(user in excelsior_kpks) && is_excelsior(user))
		contents.Add(new /obj/item/centor_kpk(src))
		excelsior_kpks.Add(user)
	load_network()
	spawn_compact_node(user)
	//nano_ui_interact(user)




/obj/machinery/centor/proc/load_network()
	antennas_to_haven = list()
	for(var/obj/machinery/node/node in excelsior_nodes)
		node.core = null
		node.update_icon()
	for(var/obj/machinery/node/node in excelsior_nodes)
		if(dist3D(src, node) <= EX_NODE_DISTANCE)
			node.spread_signal(src)


/obj/machinery/centor/proc/spawn_compact_node(mob/user)
	if(is_excelsior(user))
		if(cutscene)
			to_chat(user, SPAN_WARNING("Please, wait. Centor can't pay attention now."))
			return
		if(LAZYLEN(contents) <= 0)
			if(world.time >= timer_set + EX_NODE_SPAWN_COOLDOWN)
				to_chat(user, SPAN_WARNING("<h1>Come on, come on, give me the damn thing already!</h1>"))	// resolves a bug with timer :)
			else
				to_chat(user, SPAN_WARNING("A new node will be ready in [time2text(timer_set + EX_NODE_SPAWN_COOLDOWN-world.time, "mm:ss")] minutes."))
				investigating(user)
//		else
//
		else
			to_chat(user, SPAN_NOTICE("You pat Centor - it understands, and goes away to give you equipment..."))
			visible_message()
			give_me_nodes_animation()
	else
		to_chat(user, SPAN_NOTICE ("It doesn't want me harm."))
		investigating(user)



/obj/machinery/centor/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(user.stat || user.restrained() || stat & (BROKEN|NOPOWER))
		return
	var/list/data = nano_ui_data()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "excelsior_node.tmpl", name, 390, 450)
		ui.set_initial_data(data)
		ui.open()





/obj/machinery/centor/nano_ui_data()		// TODO check this at the finishing line, there's test stuff
	var/list/data = list()
	var/list/node_list = list()
	for(var/obj/machinery/node/node in excelsior_nodes)
		node_list += list(
			list(
				"name" = node.name,
				"x" = node.loc.x,
				"y" = node.loc.y,
				"z" = node.loc.z

		)
		)
	data["test"] = "ITS WORKING"
	data["node_list"] = node_list

	return data



/obj/machinery/centor/attackby(obj/item/I, mob/user)
	investigating(user)
	if(user.a_intent == I_HELP)
		if((QUALITY_WELDING in I.tool_qualities) && (health < maxHealth))
			if(I.use_tool(user, src, WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
				health += 200
				if(health > maxHealth)
					health = maxHealth
				update_icon()
		return 1
	if (!(I.flags & NOBLUDGEON) && I.force)
		//if the turret was attacked with the intention of harming it:
		user.do_attack_animation(src)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

		/* Commented at the time for the lack of better sounds
		if (take_damage(I.force * I.structure_damage_factor))
			playsound(src, 'sound/weapons/smash.ogg', 70, 1)
		else
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
		*/
		take_damage(I.force * I.structure_damage_factor)

	..()



/obj/machinery/centor/bullet_act(obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()
	..()
	take_damage(damage*Proj.structure_damage_factor)

/obj/machinery/centor/take_damage(amount)
	if(!damage_report_cooldown)
		talk("CENTOR :: Centor lost integrity. [pick(imgonnadie)]")
		damage_report_cooldown = TRUE
		spawn(1 MINUTE)
			if(src)
				damage_report_cooldown = FALSE
	if(!amount)
		return FALSE	//No damage done. Used in attackby()
	health -= amount
	if(health <= 0)
		die()
	return TRUE			//Actual damage delt. Used in attackby()

