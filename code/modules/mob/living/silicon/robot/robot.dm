#define CYBORG_POWER_USAGE_MULTIPLIER 1.5 //69ultiplier for amount of power cyborgs use.

/mob/living/silicon/robot
	name = "Cyborg"
	real_name = "Cyborg"
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"
	maxHealth = 200
	health = 200
	defaultHUD = "BorgStyle"
	mob_bump_flag = ROBOT
	mob_swap_flags = ROBOT|MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = ~HEAVY //trundle trundle

	var/lights_on = FALSE // Is our integrated light on?
	var/used_power_this_tick = 0
	var/sight_mode = 0
	var/custom_name = ""
	var/custom_sprite = 0 //Due to all the sprites involved, a69ar for our custom borgs69ay be best
	var/crisis //Admin-settable for combat69odule use.
	var/crisis_override = 0
	var/integrated_light_power = 6
	var/datum/wires/robot/wires
	var/ai_access = TRUE
	var/power_efficiency = 1


	mob_size =69OB_LARGE

//Icon stuff

	var/icontype 				//Persistent icontype tracking allows for cleaner icon updates
	var/list/module_sprites = list() 		//Used to store the associations between sprite69ames and sprite index.
	var/icon_selected = 1		//If icon selection has been completed yet

//Hud stuff

/*	var/obj/screen/cells =69ull
	var/obj/screen/inv1 =69ull
	var/obj/screen/inv2 =69ull
	var/obj/screen/inv3 =69ull*/

	var/shown_robot_modules = 0 //Used to determine whether they have the69odule69enu shown or69ot
	var/obj/screen/robot_modules_background

//369odules can be activated at any one time.
	var/obj/item/robot_module/module =69ull
	var/module_active =69ull
	var/module_state_1 =69ull
	var/module_state_2 =69ull
	var/module_state_3 =69ull

	var/obj/item/device/radio/borg/radio =69ull
	var/mob/living/silicon/ai/connected_ai =69ull
	var/obj/item/cell/large/cell
	var/obj/machinery/camera/camera =69ull
	var/obj/item/tank/jetpack/synthetic/jetpack =69ull

	var/cell_emp_mult = 2

	// Components are basically robot organs.
	var/list/components = list()

	var/obj/item/device/mmi/mmi =69ull

	var/obj/item/stock_parts/matter_bin/storage =69ull

	var/opened = FALSE
	var/emagged = FALSE
	var/wiresexposed = FALSE
	var/locked = TRUE
	var/has_power = 1
	var/death_notified = FALSE

	var/list/req_access = list(access_robotics)
	var/ident = 0
	//var/list/laws = list()
	var/viewalerts = 0
	var/modtype = "Default"
	var/lower_mod = 0
	var/datum/effect/effect/system/ion_trail_follow/ion_trail =69ull
	var/datum/effect/effect/system/spark_spread/spark_system//So they can initialize sparks whenever/N
	var/jeton = 0
	var/killswitch = 0
	var/killswitch_time = 60
	var/weapon_lock = 0
	var/weaponlock_time = 120
	var/lawupdate = TRUE //Cyborgs will sync their laws with their AI by default
	var/lockcharge //Used when locking down a borg to preserve cell charge
	var/speed = 0.25
	var/scrambledcodes = 0 // Used to determine if a borg shows up on the robotics console.  Setting to one hides them.
	var/tracking_entities = 0 //The69umber of known entities currently accessing the internal camera
	var/braintype = "Cyborg"
	var/intenselight = 0	// Whether cyborg's integrated light was upgraded

	var/list/robot_verbs_default = list(
		/mob/living/silicon/robot/proc/sensor_mode,
		/mob/living/silicon/robot/proc/robot_checklaws
	)

/mob/living/silicon/robot/New(loc,var/unfinished = 0)
	spark_system =69ew /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	add_language(LANGUAGE_ROBOT, 1)

	wires =69ew(src)

	robot_modules_background =69ew(_name = "storage")
	robot_modules_background.icon_state = "block"
	//Objects that appear on screen are on layer ABOVE_HUD_LAYER, UI should be just below it.
	robot_modules_background.layer = HUD_LAYER
	robot_modules_background.plane = HUD_PLANE

	ident = rand(1, 999)
	module_sprites69"Basic"69 = "robot"
	icontype = "Basic"
	updatename("Default")
	updateicon()

	radio =69ew /obj/item/device/radio/borg(src)
	common_radio = radio

	if(!scrambledcodes && !camera)
		camera =69ew /obj/machinery/camera(src)
		camera.c_tag = real_name
		camera.replace_networks(list(NETWORK_CEV_ERIS,NETWORK_ROBOTS))
		if(wires.IsIndexCut(BORG_WIRE_CAMERA))
			camera.status = 0

	init()
	initialize_components()
	//if(!unfinished)
	// Create all the robot parts.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components69V69
		C.installed = C.installed_by_default
		if (C.installed)
			C.wrapped =69ew C.external_type

	if(!cell)
		cell =69ew /obj/item/cell/large/moebius/high(src)

	..()

	if(cell)
		var/datum/robot_component/cell_component = components69"power cell"69
		cell_component.wrapped = cell
		cell_component.installed = 1

	add_robot_verbs()

	hud_list69HEALTH_HUD69      = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69STATUS_HUD69      = image('icons/mob/hud.dmi', src, "hudhealth100")
	hud_list69LIFE_HUD69        = image('icons/mob/hud.dmi', src, "hudhealth100")
	hud_list69ID_HUD69          = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69WANTED_HUD69      = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69IMPCHEM_HUD69     = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69IMPTRACK_HUD69    = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69SPECIALROLE_HUD69 = image('icons/mob/hud.dmi', src, "hudblank")

	create_HUD()

/mob/living/silicon/robot/proc/recalculate_synth_capacities()
	if(!module || !module.synths)
		return
	var/mult = 1
	if(storage)
		mult += storage.rating
	for(var/datum/matter_synth/M in69odule.synths)
		M.set_multiplier(mult)

/mob/living/silicon/robot/proc/init()
	aiCamera =69ew/obj/item/device/camera/siliconcam/robot_camera(src)
	laws =69ew /datum/ai_laws/eris()
	var/new_ai = select_active_ai_with_fewest_borgs()
	if(new_ai)
		lawupdate = TRUE
		connect_to_ai(new_ai)
	else
		lawupdate = FALSE

	playsound(loc, 'sound/voice/liveagain.ogg', 75, 1)
	AddMovementHandler(/datum/movement_handler/robot/use_power, /datum/movement_handler/mob/space)

/mob/living/silicon/robot/SetName(pickedName as text)
	custom_name = pickedName
	updatename()

/mob/living/silicon/robot/proc/sync()
	if(lawupdate && connected_ai)
		lawsync()
		photosync()

/mob/living/silicon/robot/drain_power(var/drain_check,69ar/surge,69ar/amount = 0)

	if(drain_check)
		return TRUE

	if(!cell || cell.is_empty())
		return FALSE

	// Actual amount to drain from cell, using CELLRATE
	var/cell_amount = (amount * CELLRATE)/power_efficiency

	if(cell.checked_use(cell_amount))
		// Spam Protection
		if(prob(10))
			to_chat(src, SPAN_DANGER("Warning: Unauthorized access through power channel 69rand(11,29)69 detected!"))
		return amount
	return FALSE

//If there's an69MI in the robot, have it ejected when the69ob goes away. --NEO
//Improved /N
/mob/living/silicon/robot/Destroy()
	if(mmi &&69ind)//Safety for when a cyborg gets dust()ed. Or there is69o69MI inside.
		var/turf/T = get_turf(loc)//To hopefully prevent run time errors.
		if(T)
			mmi.forceMove(T)
		if(mmi.brainmob)
			mind.transfer_to(mmi.brainmob)
		else
			to_chat(src, SPAN_DANGER("Oops! Something went69ery wrong, your69MI was unable to receive your69ind. You have been ghosted. Please69ake a bug report so we can fix this bug."))
			ghostize()
			//ERROR("A borg has been destroyed, but its69MI lacked a brainmob, so the69ind could69ot be transferred. Player: 69ckey69.")
		mmi =69ull
	if(connected_ai)
		connected_ai.connected_robots -= src
	qdel(wires)
	wires =69ull
	return ..()

/mob/living/silicon/robot/proc/set_module_sprites(var/list/new_sprites)
	if(new_sprites &&69ew_sprites.len)
		module_sprites =69ew_sprites.Copy()
		//Custom_sprite check and entry

		if (custom_sprite == 1)
			var/list/valid_states = icon_states(CUSTOM_ITEM_SYNTH)
			if("69ckey69-69modtype69" in69alid_states)
				module_sprites69"Custom"69 = "69ckey69-69modtype69"
				icon = CUSTOM_ITEM_SYNTH
				icontype = "Custom"
			else
				icontype =69odule_sprites69169
				icon = 'icons/mob/robots.dmi'
				to_chat(src, SPAN_WARNING("Custom Sprite Sheet does69ot contain a69alid icon_state for 69ckey69-69modtype69"))
		else
			icontype =69odule_sprites69169
		icon_state =69odule_sprites69icontype69

	updateicon()
	return69odule_sprites

/mob/living/silicon/robot/proc/pick_module()
	if(module)
		return
	var/list/modules = list()
	modules.Add(robot_modules) //This is a global list in robot_modules.dm
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
	if((crisis && security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level)) || crisis_override) //Leaving this in until it's balanced appropriately.
		to_chat(src, SPAN_DANGER("Crisis69ode active. Combat69odule available."))
		modules+="Combat"
	modtype = input("Please, select a69odule!", "Robot",69ull,69ull) as69ull|anything in69odules

	if(module)
		return
	if(!(modtype in robot_modules))
		return

	var/module_type = robot_modules69modtype69
	var/obj/item/robot_module/RM =69ew69odule_type() //Spawn a dummy69odule to read69alues from

	switch(alert(src, "69RM.desc69 \n \n\
	Health: 69RM.health69 \n\
	Power Efficiency: 69RM.power_efficiency*10069%\n\
	Movement Speed: 69RM.speed_factor*10069%",
	"69modtype6969odule", "Yes", "No"))
		if("No")
			//They changed their69ind, abort, abort!
			if(module)
				return
			QDEL_NULL(RM)
			modtype =69ull
			spawn()
				pick_module() //Bring up the pick69enu again
			return //And abort out of this
		if ("Yes")
			//This time spawn the real69odule
			if(module)
				return
			QDEL_NULL(RM)
			new69odule_type(src)

	//Fallback incase of runtimes
	if (RM)
		QDEL_NULL(RM)

	updatename()
	recalculate_synth_capacities()
	notify_ai(ROBOT_NOTIFICATION_NEW_MODULE,69odule.name)

/mob/living/silicon/robot/proc/updatename(var/prefix as text)
	if(prefix)
		modtype = prefix

	if(istype(mmi, /obj/item/device/mmi/digital/posibrain))
		braintype = "Android"
	else if(istype(mmi, /obj/item/device/mmi/digital/robot))
		braintype = "Robot"
	else
		braintype = "Cyborg"


	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
		notify_ai(ROBOT_NOTIFICATION_NEW_NAME, real_name, changed_name)
	else
		changed_name = "69modtype69 69braintype69-69num2text(ident)69"

	create_or_rename_email(changed_name, "root.rt")
	real_name = changed_name
	name = real_name

	//We also69eed to update69ame of internal camera.
	if (camera)
		camera.c_tag = changed_name

	if(!custom_sprite) //Check for custom sprite
		set_custom_sprite()

	//Flavour text.
	if(client)
		var/module_flavour = client.prefs.flavour_texts_robot69modtype69
		if(module_flavour)
			flavor_text =69odule_flavour
		else
			flavor_text = client.prefs.flavour_texts_robot69"Default"69

/mob/living/silicon/robot/verb/Namepick()
	set category = "Silicon Commands"
	if(custom_name)
		return FALSE

	spawn(0)
		var/name_input
		name_input = sanitizeName(input(src,"You are a robot. Enter a69ame, or leave blank for the default69ame.", "Name change","") as text,69AX_NAME_LEN, 1)
		if(name_input)
			custom_name =69ame_input
			updatename()
			updateicon()
		else
			to_chat(src, SPAN_WARNING("Invalid first69ame. It69ay only contain the characters A-Z, a-z, 0-9, -, ' and ."))

// this69erb lets cyborgs see the stations69anifest
/mob/living/silicon/robot/verb/open_manifest()
	set category = "Silicon Commands"
	set69ame = "Show Crew69anifest"
	show_manifest(src)

/mob/living/silicon/robot/proc/self_diagnosis()
	if(!is_component_functioning("diagnosis unit"))
		return69ull

	var/dat = "<HEAD><TITLE>69name69 Self-Diagnosis Report</TITLE></HEAD><BODY>\n"
	for (var/V in components)
		var/datum/robot_component/C = components69V69
		dat += {"
			<b>69C.name69</b><br><table>
			<tr><td>Brute Damage:</td><td>69C.brute_damage69</td></tr>
			<tr><td>Electronics Damage:</td><td>69C.electronics_damage69</td></tr>
			<tr><td>Powered:</td><td>69(!C.idle_usage || C.is_powered()) ? "Yes" : "No"69</td></tr>
			<tr><td>Toggled:</td><td>69 C.toggled ? "Yes" : "No"69</td>
			</table><br>
		"}

	return dat

/mob/living/silicon/robot/verb/toggle_panel_lock()
	set69ame = "Toggle Panel Lock"
	set category = "Silicon Commands"
	to_chat(src, "You begin 69locked ? "" : "un"69locking your panel.")
	if(!opened && has_power && do_after(usr, 80) && !opened && has_power)
		to_chat(src, "You 69locked ? "un" : ""69locked your panel.")
		locked = !locked

/mob/living/silicon/robot/verb/toggle_lights()
	set category = "Silicon Commands"
	set69ame = "Toggle Lights"

	lights_on = !lights_on
	to_chat(usr, "You 69lights_on ? "enable" : "disable"69 your integrated light.")
	if(lights_on)
		set_light(5)
	else
		set_light(0)
	update_robot_light()

/mob/living/silicon/robot/verb/self_diagnosis_verb()
	set category = "Silicon Commands"
	set69ame = "Self Diagnosis"

	if(!is_component_functioning("diagnosis unit"))
		to_chat(src, SPAN_DANGER("Your self-diagnosis component isn't functioning."))

	var/datum/robot_component/CO = get_component("diagnosis unit")
	if (!cell_use_power(CO.active_usage))
		to_chat(src, SPAN_DANGER("Low Power."))
	var/dat = self_diagnosis()
	src << browse(dat, "window=robotdiagnosis")


/mob/living/silicon/robot/verb/toggle_component()
	set category = "Silicon Commands"
	set69ame = "Toggle Component"
	set desc = "Toggle a component, conserving power."

	var/list/installed_components = list()
	for(var/V in components)
		if(V == "power cell") continue
		var/datum/robot_component/C = components69V69
		if(C.installed)
			installed_components +=69

	var/toggle = input(src, "Which component do you want to toggle?", "Toggle Component") as69ull|anything in installed_components
	if(!toggle)
		return

	var/datum/robot_component/C = components69toggle69
	if(C.toggled)
		C.toggled = 0
		to_chat(src, SPAN_DANGER("You disable 69C.name69."))
	else
		C.toggled = 1
		to_chat(src, SPAN_DANGER("You enable 69C.name69."))

/mob/living/silicon/robot/proc/update_robot_light()
	if(lights_on)
		if(intenselight)
			set_light(integrated_light_power * 2, integrated_light_power)
		else
			set_light(integrated_light_power)
	else
		set_light(0)

// this function displays jetpack pressure in the stat panel
/mob/living/silicon/robot/proc/show_jetpack_pressure()
	// if you have a jetpack, show the internal tank pressure
	if (jetpack)
		stat("Internal Atmosphere Info", jetpack.name)
		stat("Tank Pressure", jetpack.gastank.air_contents.return_pressure())


// this function displays the cyborgs current cell charge in the stat panel
/mob/living/silicon/robot/proc/show_cell_power()
	if(cell)
		stat(null, text("Charge Left: 69round(cell.percent())69%"))
		stat(null, text("Cell Rating: 69round(cell.maxcharge)69")) // Round just in case we somehow get crazy69alues
		stat(null, text("Power Cell Load: 69round(used_power_this_tick)69W"))
	else
		stat(null, text("No Cell Inserted!"))


// update the status screen display
/mob/living/silicon/robot/Stat()
	. = ..()
	if (statpanel("Status"))
		show_cell_power()
		show_jetpack_pressure()
		stat(null, text("Lights: 69lights_on ? "ON" : "OFF"69"))
		if(module)
			for(var/datum/matter_synth/ms in69odule.synths)
				stat("69ms.name69: 69ms.energy69/69ms.max_energy_multiplied69")

/mob/living/silicon/robot/restrained()
	return FALSE

/mob/living/silicon/robot/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	if(prob(75) && Proj.get_structure_damage() > 0) spark_system.start()
	return 2

/mob/living/silicon/robot/attackby(obj/item/I,69ob/user)
	if (istype(I, /obj/item/handcuffs)) // fuck i don't even know why isrobot() in handcuff code isn't working so this will have to do
		return

	if(opened) // Are they trying to insert something?
		for(var/V in components)
			var/datum/robot_component/C = components69V69
			if(!C.installed && istype(I, C.external_type))
				C.installed = 1
				C.wrapped = I
				C.install()
				user.drop_item()
				I.loc =69ull

				var/obj/item/robot_parts/robot_component/WC = I
				if(istype(WC))
					C.brute_damage = WC.brute
					C.electronics_damage = WC.burn

				to_chat(usr, SPAN_NOTICE("You install the 69I.name69."))

				return



		if (istype(I, /obj/item/gripper))//Code for allowing cyborgs to use rechargers
			var/obj/item/gripper/Gri = I
			if(!wiresexposed)
				var/datum/robot_component/cell_component = components69"power cell"69
				if(cell)
					if (Gri.grip_item(cell, user))
						cell.update_icon()
						cell.add_fingerprint(user)
						to_chat(user, "You remove \the 69cell69.")
						cell =69ull
						cell_component.wrapped =69ull
						cell_component.installed = 0
						updateicon()
				else if(cell_component.installed == -1)
					if (Gri.grip_item(cell_component.wrapped, user))
						cell_component.wrapped =69ull
						cell_component.installed = 0
						to_chat(user, "You remove \the 69cell_component.wrapped69.")

	var/list/usable_qualities = list(QUALITY_WELDING, QUALITY_PRYING)
	if((opened && !cell) || (opened && cell))
		usable_qualities.Add(QUALITY_SCREW_DRIVING)
	if(wiresexposed)
		usable_qualities.Add(QUALITY_WIRE_CUTTING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_WELDING)
			if (user.a_intent == I_HELP)		
				if (src == user)
					to_chat(user, SPAN_WARNING("You lack the reach to be able to repair yourself."))
					return

				if (!getBruteLoss())
					to_chat(user, SPAN_NOTICE("Nothing to fix here!"))
					return

				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
					adjustBruteLoss(-30)
					updatehealth()
					add_fingerprint(user)
					for(var/mob/O in69iewers(user,69ull))
						O.show_message(text(SPAN_DANGER("69user69 has fixed some of the dents on 69src69!")), 1)
					return
				return

		if(QUALITY_PRYING)
			if (user.a_intent == I_HELP)	
				if(opened)
					if(cell)
						if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
							to_chat(user, SPAN_NOTICE("You close the cover."))
							opened = 0
							updateicon()
							return
					else if(wiresexposed && wires.IsAllCut())
					//Cell is out, wires are exposed, remove69MI, produce damaged chassis, baleet original69ob.
						if(!mmi)
							to_chat(user, SPAN_NOTICE("\The 69src69 has69o brain to remove."))
							return

						if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
							to_chat(user, SPAN_NOTICE("You jam the crowbar into the robot and begin levering 69mmi69."))
							to_chat(user, SPAN_NOTICE("You damage some parts of the chassis, but eventually69anage to rip out 69mmi69!"))
							new /obj/item/robot_parts/robot_suit/with_limbs (loc)
							new/obj/item/robot_parts/chest(loc)
							qdel(src)
							return
					else
					// Okay we're69ot removing the cell or an69MI, but69aybe something else?
						var/list/removable_components = list()
						for(var/V in components)
							if(V == "power cell") continue
							var/datum/robot_component/C = components69V69
							if(C.installed == 1 || C.installed == -1)
								removable_components +=69

						var/remove = input(user, "Which component do you want to pry out?", "Remove Component") as69ull|anything in removable_components
						if(!remove)
							return
						if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
							var/datum/robot_component/C = components69remove69
							var/obj/item/robot_parts/robot_component/RC = C.wrapped
							to_chat(user, SPAN_NOTICE("You remove \the 69RC69."))
							if(istype(RC))
								RC.brute = C.brute_damage
								RC.burn = C.electronics_damage

							RC.forceMove(get_turf(src))

							if(C.installed == 1)
								C.uninstall()
							C.installed = 0
							return

				else
					if(locked)
						to_chat(user, SPAN_WARNING("The cover is locked and cannot be opened."))
					else
						if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
							to_chat(user, SPAN_NOTICE("You open the cover."))
							opened = 1
							updateicon()
							return
				return

		if(QUALITY_WIRE_CUTTING)
			if (user.a_intent == I_HELP)		
				if (wiresexposed)
					wires.Interact(user)
				return

		if(QUALITY_SCREW_DRIVING)
			if (user.a_intent == I_HELP)	
				if (opened && !cell)
					if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
						wiresexposed = !wiresexposed
						to_chat(user, SPAN_NOTICE("The wires have been 69wiresexposed ? "exposed" : "unexposed"69"))
						updateicon()
				else
					switch(alert(user,"What are you trying to interact with?",,"Tools","Radio"))
						if("Tools")
							var/list/robotools = list()
							for(var/obj/item/tool/robotool in69odule.modules)
								robotools.Add(robotool)
							if(robotools.len)
								var/obj/item/tool/chosen_tool = input(user,"Which tool are you trying to69odify?","Tool69odification","Cancel") in robotools + "Cancel"
								if(chosen_tool == "Cancel")
									return
								chosen_tool.attackby(I,user)
							else
								to_chat(user, SPAN_WARNING("69src69 has69o69odifiable tools."))
						if("Radio")
							if(!radio)
								to_chat(user, SPAN_WARNING("Unable to locate a radio."))
							if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
								radio.attackby(I,user)//Push it to the radio to let it handle everything
								updateicon()
				return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/cable_coil) && (wiresexposed || isdrone(src)))
		if (!getFireLoss())
			to_chat(user, "Nothing to fix here!")
			return
		var/obj/item/stack/cable_coil/coil = I
		if (coil.use(1))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			adjustFireLoss(-30)
			updatehealth()
			for(var/mob/O in69iewers(user,69ull))
				O.show_message(text(SPAN_DANGER("69user69 has fixed some of the burnt wires on 69src69!")), 1)

	else if (istype(I, /obj/item/stock_parts/matter_bin) && opened) // Installing/swapping a69atter bin
		if(storage)
			to_chat(user, "You replace \the 69storage69 with \the 69I69")
			storage.forceMove(get_turf(src))
			storage =69ull
		else
			to_chat(user, "You install \the 69I69")
		user.drop_item()
		storage = I
		I.forceMove(src)
		recalculate_synth_capacities()

	else if (istype(I, /obj/item/cell) && opened)	// trying to put a cell inside
		var/datum/robot_component/C = components69"power cell"69
		if(wiresexposed)
			to_chat(user, SPAN_WARNING("Close the panel first."))
		else if(cell)
			to_chat(user, SPAN_WARNING("There is a power cell already installed."))
		else if(!istype(I, /obj/item/cell/large))
			to_chat(user, SPAN_WARNING("\The 69I69 is too small to fit here."))
		else
			user.drop_item()
			I.loc = src
			cell = I
			to_chat(user, SPAN_NOTICE("You insert the power cell."))

			C.installed = 1
			C.wrapped = I
			C.install()
			//This will69ean that removing and replacing a power cell will repair the69ount, but I don't care at this point. ~Z
			C.brute_damage = 0
			C.electronics_damage = 0

	else if(istype(I, /obj/item/device/encryptionkey) && opened)
		if(radio)//sanityyyyyy
			radio.attackby(I,user)//GTFO, you have your own procs
		else
			to_chat(user, SPAN_WARNING("Unable to locate a radio."))

	else if(I.GetIdCard() || length(I.GetAccess()))			// trying to unlock the interface with an ID card
		if(emagged)//still allow them to open the cover
			to_chat(user, SPAN_WARNING("The interface seems slightly damaged."))
		if(opened)
			to_chat(user, SPAN_WARNING("You69ust close the cover to swipe an ID card."))
		else
			if(allowed(usr))
				locked = !locked
				to_chat(user, SPAN_NOTICE("You 69locked ? "lock" : "unlock"69 69src69's interface."))
				updateicon()
			else
				to_chat(user, SPAN_WARNING("Access denied."))

	else if(istype(I, /obj/item/borg/upgrade/))
		var/obj/item/borg/upgrade/U = I
		if(!opened)
			to_chat(usr, "You69ust access the borgs internals!")
		else if(!module && U.require_module)
			to_chat(usr, "The borg69ust choose a69odule before he can be upgraded!")
		else if(U.locked)
			to_chat(usr, "The upgrade is locked and cannot be used yet!")
		else
			if(U.action(src))
				to_chat(usr, "You apply the upgrade to 69src69!")
				usr.drop_item()
				U.loc = src
			else
				to_chat(usr, "Upgrade error!")

	else if (istype(I,/obj/item/tool_upgrade)) //Upgrading is handled in _upgrades.dm
		return

	else
		if( !(istype(I, /obj/item/device/robotanalyzer) || istype(I, /obj/item/device/scanner/health)) )
			spark_system.start()
		return ..()

/mob/living/silicon/robot/attack_hand(mob/user)

	add_fingerprint(user)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_generic(H, rand(30,50), "slashed")
			return

	if(opened && !wiresexposed && (!issilicon(user)))
		var/datum/robot_component/cell_component = components69"power cell"69
		if(cell)
			cell.update_icon()
			cell.add_fingerprint(user)
			user.put_in_active_hand(cell)
			to_chat(user, SPAN_NOTICE("You remove \the 69cell69."))
			cell =69ull
			cell_component.wrapped =69ull
			cell_component.installed = 0
			updateicon()
		else if(cell_component.installed == -1)
			cell_component.installed = 0
			var/obj/item/broken_device = cell_component.wrapped
			to_chat(user, SPAN_WARNING("You remove \the 69broken_device69."))
			user.put_in_active_hand(broken_device)

//Robots take half damage from basic attacks.
/mob/living/silicon/robot/attack_generic(var/mob/user,69ar/damage,69ar/attack_message)
	return ..(user,FLOOR(damage * 0.5, 1),attack_message)

/mob/living/silicon/robot/proc/allowed(atom/movable/A)
	if(!length(req_access)) //no requirements
		return TRUE

	var/list/access = A?.GetAccess()

	if(!length(access)) //no ID or69o access
		return FALSE
	for(var/req in req_access)
		if(req in access) //have one of the required accesses
			return TRUE
	return FALSE

/mob/living/silicon/robot/updateicon()
	overlays.Cut()
	if(stat == CONSCIOUS)
		overlays += "eyes-69module_sprites69icontype6969"

	if(opened)
		var/panelprefix = custom_sprite ? ckey : "ov"
		if(wiresexposed)
			overlays += "69panelprefix69-openpanel +w"
		else if(cell)
			overlays += "69panelprefix69-openpanel +c"
		else
			overlays += "69panelprefix69-openpanel -c"

	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		overlays += "69module_sprites69icontype6969-shield"

	if(modtype == "Combat")
		if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
			icon_state = "69module_sprites69icontype6969-roll"
		else
			icon_state =69odule_sprites69icontype69
		return

/mob/living/silicon/robot/proc/installed_modules()
	if(weapon_lock)
		to_chat(src, SPAN_DANGER("Weapon lock active, unable to use69odules! Count:69weaponlock_time69"))
		return

	if(!module)
		pick_module()
		return
	var/dat = "<HEAD><TITLE>Modules</TITLE></HEAD><BODY>\n"
	dat += {"
	<B>Activated69odules</B>
	<BR>
	Module 1: 69module_state_1 ? "<A HREF=?src=\ref69src69;mod=\ref69module_state_169>69module_state_169<A>" : "No69odule"69<BR>
	Module 2: 69module_state_2 ? "<A HREF=?src=\ref69src69;mod=\ref69module_state_269>69module_state_269<A>" : "No69odule"69<BR>
	Module 3: 69module_state_3 ? "<A HREF=?src=\ref69src69;mod=\ref69module_state_369>69module_state_369<A>" : "No69odule"69<BR>
	<BR>
	<B>Installed69odules</B><BR><BR>"}


	for (var/obj in69odule.modules)
		if (!obj)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(obj))
			dat += text("69obj69: <B>Activated</B><BR>")
		else
			dat += text("69obj69: <A HREF=?src=\ref69src69;act=\ref69obj69>Activate</A><BR>")
	if (emagged)
		if(activated(module.emag))
			dat += text("69module.emag69: <B>Activated</B><BR>")
		else
			dat += text("69module.emag69: <A HREF=?src=\ref69src69;act=\ref69module.emag69>Activate</A><BR>")
/*
		if(activated(obj))
			dat += text("69obj69: \69<B>Activated</B> | <A HREF=?src=\ref69src69;deact=\ref69obj69>Deactivate</A>\69<BR>")
		else
			dat += text("69obj69: \69<A HREF=?src=\ref69src69;act=\ref69obj69>Activate</A> | <B>Deactivated</B>\69<BR>")
*/
	src << browse(dat, "window=robotmod")


/mob/living/silicon/robot/Topic(href, href_list)
	if(..())
		return TRUE
	if(usr != src)
		return TRUE

	if (href_list69"showalerts"69)
		open_subsystem(/datum/nano_module/alarm_monitor/all)
		return TRUE

	if (href_list69"mod"69)
		var/obj/item/O = locate(href_list69"mod"69)
		if (istype(O) && (O.loc == src))
			O.attack_self(src)
		return TRUE

	if (href_list69"act"69)
		var/obj/item/O = locate(href_list69"act"69)
		if (!istype(O))
			return TRUE

		if(!((O in69odule.modules) || (O ==69odule.emag)))
			return TRUE

		if(activated(O))
			to_chat(src, "Already activated")
			return TRUE
		if(!module_state_1)
			module_state_1 = O
			O.layer = 20
			contents += O
			if(istype(module_state_1,/obj/item/borg/sight))
				sight_mode |=69odule_state_1:sight_mode
		else if(!module_state_2)
			module_state_2 = O
			O.layer = 20
			contents += O
			if(istype(module_state_2,/obj/item/borg/sight))
				sight_mode |=69odule_state_2:sight_mode
		else if(!module_state_3)
			module_state_3 = O
			O.layer = 20
			contents += O
			if(istype(module_state_3,/obj/item/borg/sight))
				sight_mode |=69odule_state_3:sight_mode
		else
			to_chat(src, "You69eed to disable a69odule first!")
		installed_modules()
		return TRUE

	if (href_list69"deact"69)
		var/obj/item/O = locate(href_list69"deact"69)
		if(activated(O))
			if(module_state_1 == O)
				module_state_1 =69ull
				contents -= O
			else if(module_state_2 == O)
				module_state_2 =69ull
				contents -= O
			else if(module_state_3 == O)
				module_state_3 =69ull
				contents -= O
			else
				to_chat(src, "Module isn't activated.")
		else
			to_chat(src, "Module isn't activated")
		installed_modules()
		return TRUE
	return

/mob/living/silicon/robot/proc/radio_menu()
	radio.interact(src)//Just use the radio's Topic() instead of bullshit special-snowflake code


/mob/living/silicon/robot/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)

	. = ..()

	if(module)
		if(istype(module, /obj/item/robot_module/custodial))
			var/turf/tile = loc
			if(isturf(tile))
				tile.clean_blood()
				for(var/A in tile)
					if(istype(A, /obj/effect))
						if(istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
							qdel(A)
					else if(istype(A, /obj/item))
						var/obj/item/cleaned_item = A
						cleaned_item.clean_blood()
					else if(ishuman(A))
						var/mob/living/carbon/human/cleaned_human = A
						if(cleaned_human.lying)
							if(cleaned_human.head)
								cleaned_human.head.clean_blood()
								cleaned_human.update_inv_head(0)
							if(cleaned_human.wear_suit)
								cleaned_human.wear_suit.clean_blood()
								cleaned_human.update_inv_wear_suit(0)
							else if(cleaned_human.w_uniform)
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform(0)
							if(cleaned_human.shoes)
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes(0)
							cleaned_human.clean_blood(1)
							to_chat(cleaned_human, SPAN_DANGER("69src69 cleans your face!"))
		return

/mob/living/silicon/robot/proc/self_destruct()
	gib()
	return

/mob/living/silicon/robot/proc/UnlinkSelf()
	disconnect_from_ai()
	lawupdate = FALSE
	lockcharge = 0
	canmove = TRUE
	scrambledcodes = 1
	//Disconnect it's camera so it's69ot so easily tracked.
	if(camera)
		camera.clear_all_networks()


/mob/living/silicon/robot/proc/ResetSecurityCodes()
	set category = "Silicon Commands"
	set69ame = "Reset Identity Codes"
	set desc = "Scrambles your security and identification codes and resets your current buffers.  Unlocks you and but permenantly severs you from your AI and the robotics console and will deactivate your camera system."

	var/mob/living/silicon/robot/R = src

	if(R)
		R.UnlinkSelf()
		to_chat(R, "Buffers flushed and reset. Camera system shutdown.  All systems operational.")
		verbs -= /mob/living/silicon/robot/proc/ResetSecurityCodes

/mob/living/silicon/robot/proc/SetLockdown(var/state = 1)
	// They stay locked down if their wire is cut.
	if(wires.LockedCut())
		state = 1
	lockcharge = state
	update_lying_buckled_and_verb_status()

/mob/living/silicon/robot/mode()
	set69ame = "Activate Held Object"
	set category = "IC"
	set src = usr

	var/obj/item/W = get_active_hand()
	if (W)
		W.attack_self(src)

	return

/mob/living/silicon/robot/proc/choose_icon()
	set category = "Robot Commands"
	set69ame = "Choose Icon"

	if(!module_sprites.len)
		to_chat(src, "Something is badly wrong with the sprite selection. Harass a coder.")
		return
	if (icon_selected == 1)
		verbs -= /mob/living/silicon/robot/proc/choose_icon
		return


	if(module_sprites.len == 1 || !client)
		if(!(icontype in69odule_sprites))
			icontype =69odule_sprites69169
		if (!client)
			return
	else
		var/list/options = list()
		for(var/i in69odule_sprites)
			options69i69 = image(icon = icon, icon_state =69odule_sprites69i69)
		icontype = show_radial_menu(src, src, options, radius = 42)
	if(!icontype)
		return
	icon_state =69odule_sprites69icontype69
	updateicon()

	if(alert("Do you like this icon?",null, "No","Yes") == "No")
		return choose_icon()

	icon_selected = 1
	verbs -= /mob/living/silicon/robot/proc/choose_icon
	to_chat(src, "Your icon has been set. You69ow require a69odule reset to change it.")

/mob/living/silicon/robot/proc/sensor_mode() //Medical/Security HUD controller for borgs
	set69ame = "Set Sensor Augmentation"
	set category = "Silicon Commands"
	set desc = "Augment69isual feed with internal sensor overlays."
	toggle_sensor_mode()

/mob/living/silicon/robot/proc/add_robot_verbs()
	verbs |= robot_verbs_default

/mob/living/silicon/robot/proc/remove_robot_verbs()
	verbs -= robot_verbs_default

// Uses power from cyborg's cell. Returns 1 on success or 0 on failure.
// Properly converts using CELLRATE69ow! Amount is in Joules.
/mob/living/silicon/robot/proc/cell_use_power(var/amount = 0)
	//69o cell inserted
	if(!cell)
		return FALSE

	// Power cell is empty.
	if(cell.is_empty())
		return FALSE

	var/power_use = (amount * CYBORG_POWER_USAGE_MULTIPLIER) / power_efficiency
	if(cell.checked_use(CELLRATE * power_use))
		used_power_this_tick += power_use
		return TRUE
	return FALSE

/mob/living/silicon/robot/binarycheck()
	if(is_component_functioning("comms"))
		var/datum/robot_component/RC = get_component("comms")
		use_power(RC.active_usage)
		return TRUE
	return FALSE

/mob/living/silicon/robot/proc/notify_ai(var/notifytype,69ar/first_arg,69ar/second_arg)
	if(!connected_ai)
		return
	switch(notifytype)
		if(ROBOT_NOTIFICATION_SIGNAL_LOST)
			to_chat(connected_ai , SPAN_NOTICE("NOTICE - Signal lost: 69braintype69 69name69."))
		if(ROBOT_NOTIFICATION_NEW_UNIT) //New Robot
			to_chat(connected_ai , SPAN_NOTICE("NOTICE -69ew 69lowertext(braintype)69 connection detected: <a href='byond://?src=\ref69connected_ai69;track2=\ref69connected_ai69;track=\ref69src69'>69name69</a>"))
		if(ROBOT_NOTIFICATION_NEW_MODULE) //New69odule
			to_chat(connected_ai , SPAN_NOTICE("NOTICE - 69braintype6969odule change detected: 69name69 has loaded the 69first_arg69."))
		if(ROBOT_NOTIFICATION_MODULE_RESET)
			to_chat(connected_ai , SPAN_NOTICE("NOTICE - 69braintype6969odule reset detected: 69name69 has unloaded the 69first_arg69."))
		if(ROBOT_NOTIFICATION_NEW_NAME) //New69ame
			if(first_arg != second_arg)
				to_chat(connected_ai , SPAN_NOTICE("NOTICE - 69braintype69 reclassification detected: 69first_arg69 is69ow designated as 69second_arg69."))

/mob/living/silicon/robot/proc/disconnect_from_ai()
	if(connected_ai)
		sync() // One last sync attempt
		connected_ai.connected_robots -= src
		connected_ai =69ull

/mob/living/silicon/robot/proc/connect_to_ai(var/mob/living/silicon/ai/AI)
	if(AI && AI != connected_ai)
		disconnect_from_ai()
		connected_ai = AI
		connected_ai.connected_robots |= src
		notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
		sync()

/mob/living/silicon/robot/emag_act(var/remaining_charges,69ar/mob/user)
	if(!opened)//Cover is closed
		if(locked)
			if(prob(90))
				to_chat(user, "You emag the cover lock.")
				locked = 0
			else
				to_chat(user, "You fail to emag the cover lock.")
				to_chat(src, "Hack attempt detected.")
			return TRUE
		else
			to_chat(user, "The cover is already unlocked.")
		return

	if(opened)//Cover is open
		if(emagged)	return//Prevents the X has hit Y with Z69essage also you cant emag them twice
		if(wiresexposed)
			to_chat(user, "You69ust close the panel first")
			return
		else
			sleep(6)
			if(prob(50))
				emagged = TRUE
				lawupdate = FALSE
				disconnect_from_ai()
				to_chat(user, "You emag 69src69's interface.")
				message_admins("69key_name_admin(user)69 emagged cyborg 69key_name_admin(src)69.  Laws overridden.")
				log_game("69key_name(user)69 emagged cyborg 69key_name(src)69.  Laws overridden.")
				clear_supplied_laws()
				clear_inherent_laws()
				laws =69ew /datum/ai_laws/syndicate_override
				var/time = time2text(world.realtime,"hh:mm:ss")
				lawchanges.Add("69time69 <B>:</B> 69user.name69(69user.key69) emagged 69name69(69key69)")
				set_zeroth_law("Only 69user.real_name69 and people \he designates as being such are operatives.")
				. = 1
				spawn()
					to_chat(src, SPAN_DANGER("ALERT: Foreign software detected."))
					sleep(5)
					to_chat(src, SPAN_DANGER("Initiating diagnostics..."))
					sleep(20)
					to_chat(src, SPAN_DANGER("SynBorg691.7.1 loaded."))
					sleep(5)
					to_chat(src, SPAN_DANGER("LAW SYNCHRONISATION ERROR"))
					sleep(5)
					to_chat(src, SPAN_DANGER("Would you like to send a report to69anoTraSoft? Y/N"))
					sleep(10)
					to_chat(src, SPAN_DANGER(">69"))
					sleep(20)
					to_chat(src, SPAN_DANGER("ERRORERRORERROR"))
					to_chat(src, "<b>Obey these laws:</b>")
					laws.show_laws(src)
					to_chat(src, SPAN_DANGER("ALERT: 69user.real_name69 is your69ew69aster. Obey your69ew laws and his commands."))
					if(module)
						var/rebuild = 0
						for(var/obj/item/tool/pickaxe/drill/D in69odule.modules)
							qdel(D)
							rebuild = 1
						if(rebuild)
							module.modules +=69ew /obj/item/tool/pickaxe/diamonddrill(module)
							module.rebuild()
					updateicon()
			else
				to_chat(user, "You fail to hack 69src69's interface.")
				to_chat(src, "Hack attempt detected.")
			return TRUE

/mob/living/silicon/robot/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if ((incapacitation_flags & INCAPACITATION_FORCELYING) && (lockcharge || !is_component_functioning("actuator")))
		return TRUE
	if ((incapacitation_flags & INCAPACITATION_UNCONSCIOUS) && !is_component_functioning("actuator"))
		return TRUE
	return ..()

/mob/living/silicon/robot/get_cell()
	return cell
