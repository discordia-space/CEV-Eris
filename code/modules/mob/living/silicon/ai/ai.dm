#define AI_CHECK_WIRELESS 1
#define AI_CHECK_RADIO 2

var/list/ai_list = list()
var/list/ai_verbs_default = list(
	/mob/living/silicon/ai/proc/ai_movement_up,
	/mob/living/silicon/ai/proc/ai_movement_down,
	/mob/living/silicon/ai/proc/ai_announcement,
	/mob/living/silicon/ai/proc/ai_emergency_message,
	/mob/living/silicon/ai/proc/ai_camera_track,
	/mob/living/silicon/ai/proc/ai_camera_list,
	/mob/living/silicon/ai/proc/ai_goto_location,
	/mob/living/silicon/ai/proc/ai_remove_location,
	/mob/living/silicon/ai/proc/ai_hologram_change,
	/mob/living/silicon/ai/proc/ai_network_change,
	/mob/living/silicon/ai/proc/ai_roster,
	/mob/living/silicon/ai/proc/ai_statuschange,
	/mob/living/silicon/ai/proc/ai_store_location,
	/mob/living/silicon/ai/proc/ai_checklaws,
	/mob/living/silicon/ai/proc/control_integrated_radio,
	/mob/living/silicon/ai/proc/control_personal_drone,
	/mob/living/silicon/ai/proc/destroy_personal_drone,
	/mob/living/silicon/ai/proc/core,
	/mob/living/silicon/ai/proc/pick_icon,
	/mob/living/silicon/ai/proc/sensor_mode,
	/mob/living/silicon/ai/proc/show_laws_verb,
	/mob/living/silicon/ai/proc/toggle_acceleration,
	/mob/living/silicon/ai/proc/toggle_camera_light,
	/mob/living/silicon/ai/proc/multitool_mode,
	/mob/living/silicon/ai/proc/toggle_hologram_movement,
	/mob/living/silicon/verb/show_crew_sensors,
	/mob/living/silicon/verb/show_email,
	/mob/living/silicon/verb/show_alerts
)

//Not sure why this is69ecessary...
/proc/AutoUpdateAI(obj/subject)
	var/is_in_use = 0
	if (subject!=null)
		for(var/A in ai_list)
			var/mob/living/silicon/ai/M = A
			if ((M.client &&69.machine == subject))
				is_in_use = 1
				subject.attack_ai(M)
	return is_in_use


/mob/living/silicon/ai
	name = "AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai"
	anchored = TRUE // -- TLE
	density = TRUE
	status_flags = CANSTUN|CANPARALYSE|CANPUSH
//	shouldnt_see = list()
	universal_understand = TRUE
	var/list/network = list(NETWORK_FIRST_SECTION,
							NETWORK_SECOND_SECTION,
							NETWORK_THIRD_SECTION,
							NETWORK_FOURTH_SECTION,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_CEV_ERIS,
							NETWORK_MINE,
							NETWORK_PRISON,
							NETWORK_MEDICAL,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_SECURITY,
							NETWORK_TELECOM
							)
	var/obj/machinery/camera/camera =69ull
	var/list/connected_robots = list()
	var/aiRestorePowerRoutine = 0
	var/viewalerts = 0
	var/icon/holo_icon//Default is assigned when AI is created.
	var/mob/living/exosuit/controlled_mech //For controlled_mech a69ech, to determine whether to relaymove or use the AI eye.
	var/obj/item/tool/multitool/aiMulti =69ull
	var/obj/item/device/radio/headset/heads/ai_integrated/aiRadio =69ull
	var/camera_light_on = 0	//Defines if the AI toggled the light on the camera it's looking through.
	var/datum/trackable/track =69ull
	var/last_announcement = ""
	var/control_disabled = 0
	var/datum/announcement/priority/announcement
	var/obj/machinery/ai_powersupply/psupply =69ull // Backwards reference to AI's powersupply object.
	var/hologram_follow = 1 //This is used for the AI eye, to determine if a holopad's hologram should follow it or69ot

	//NEWMALF69ARIABLES
	var/malfunctioning = 0						//69aster69ar that determines if AI is69alfunctioning.
	var/datum/malf_hardware/hardware =69ull		// Installed piece of hardware.
	var/datum/malf_research/research =69ull		//69alfunction research datum.
	var/obj/machinery/power/apc/hack =69ull		// APC that is currently being hacked.
	var/list/hacked_apcs =69ull					// List of all hacked APCs
	var/APU_power = 0							// If set to 1 AI runs on APU power
	var/hacking = 0								// Set to 1 if AI is hacking APC, cyborg, other AI, or running system override.
	var/system_override = 0						// Set to 1 if system override is initiated, 2 if succeeded.
	var/hack_can_fail = 1						// If 0, all abilities have zero chance of failing.
	var/hack_fails = 0							// This increments with each failed hack, and determines the warning69essage text.
	var/errored = 0								// Set to 1 if runtime error occurs. Only way of this happening i can think of is admin fucking up with69aredit.
	var/bombing_core = 0						// Set to 1 if core auto-destruct is activated
	var/bombing_station = 0						// Set to 1 if station69uke auto-destruct is activated
	var/override_CPUStorage = 0					// Bonus/Penalty CPU Storage. For use by admins/testers.
	var/override_CPURate = 0					// Bonus/Penalty CPU generation rate. For use by admins/testers.

	var/datum/ai_icon/selected_sprite			// The selected icon set
	var/custom_sprite 	= 0 					// Whether the selected icon is custom
	var/carded

	var/multitool_mode = 0

	var/mob/living/silicon/robot/drone/aibound/bound_drone =69ull
	var/drone_cooldown_time = 3069INUTES  // Cooldown before creating a69ew drone
	var/time_destroyed = 0.0

	defaultHUD = "Eris"

/mob/living/silicon/ai/proc/add_ai_verbs()
	verbs |= ai_verbs_default

/mob/living/silicon/ai/proc/remove_ai_verbs()
	verbs -= ai_verbs_default

/mob/living/silicon/ai/MiddleClickOn(var/atom/A)
	if(!control_disabled && A.AIMiddleClick(src))
		return

	if(controlled_mech) //Are we piloting a69ech? Placed here so the69odifiers are69ot overridden.
		controlled_mech.ClickOn(A, src) //Override AI69ormal click behavior.  , params
		return
	. = ..()

/mob/living/silicon/ai/New(loc,69ar/datum/ai_laws/L,69ar/obj/item/device/mmi/B,69ar/safety = 0)
	announcement =69ew()
	announcement.title = "A.I. Announcement"
	announcement.announcement_type = "A.I. Announcement"
	announcement.newscast = 1

	var/list/possibleNames = GLOB.ai_names

	var/pickedName =69ull
	while(!pickedName)
		pickedName = pick(GLOB.ai_names)
		for (var/mob/living/silicon/ai/A in SSmobs.mob_list)
			if (A.real_name == pickedName && possibleNames.len > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName =69ull

	SetName(pickedName)
	anchored = TRUE
	canmove = 0
	density = TRUE
	loc = loc

	holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))

	if(L)
		if (istype(L, /datum/ai_laws))
			laws = L
	else
		laws =69ew base_law_type

	aiMulti =69ew(src)
	aiRadio =69ew(src)
	common_radio = aiRadio
	aiRadio.myAi = src
	additional_law_channels69"Holopad"69 = "h"

	aiCamera =69ew/obj/item/device/camera/siliconcam/ai_camera(src)

	if (istype(loc, /turf))
		add_ai_verbs(src)

	//Languages
	add_language(LANGUAGE_ROBOT, 1)
	add_language(LANGUAGE_COMMON, 1)
	add_language(LANGUAGE_CYRILLIC, 1)
	add_language(LANGUAGE_GERMAN, 1)
	add_language(LANGUAGE_LATIN, 1)
	add_language(LANGUAGE_NEOHONGO, 1)
	add_language(LANGUAGE_SERBIAN, 1)

	if(!safety)//Only used by AIize() to successfully spawn an AI.
		if (!B)//If there is69o player/brain inside.
			empty_playable_ai_cores +=69ew/obj/structure/AIcore/deactivated(loc)//New empty terminal.
			qdel(src)//Delete AI.
			return
		else
			if (B.brainmob.mind)
				B.brainmob.mind.transfer_to(src)

			on_mob_init()

	spawn(5)
		new /obj/machinery/ai_powersupply(src)

	hud_list69HEALTH_HUD69      = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69STATUS_HUD69      = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69LIFE_HUD69 		  = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69ID_HUD69          = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69WANTED_HUD69      = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69IMPCHEM_HUD69     = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69IMPTRACK_HUD69    = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list69SPECIALROLE_HUD69 = image('icons/mob/hud.dmi', src, "hudblank")

	ai_list += src

	..()

	//Stats
	//The AI gets 100 in all three knowledge stats.
	//These are only ever used to operate69achinery and software
	//It doesnt get any physical stats, like robustness, since its a disembodied69ind
	stats.changeStat(STAT_BIO, 100)
	stats.changeStat(STAT_MEC, 100)
	stats.changeStat(STAT_COG, 100)

	// AI bound drone related stuff
	time_destroyed = world.time - drone_cooldown_time

/mob/living/silicon/ai/proc/on_mob_init()
	to_chat(src, "<B>You are playing the spaceship's AI. The AI cannot69ove, but can interact with69any objects while69iewing them (through cameras).</B>")
	to_chat(src, "<B>To look at other parts of the ship, click on yourself to get a camera69enu.</B>")
	to_chat(src, "<B>While observing through a camera, you can use69ost (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
	to_chat(src, "To use something, simply click on it.")
	to_chat(src, "Use say 69get_language_prefix()69b to speak to your cyborgs through binary. Use say :h to speak from an active holopad.")
	to_chat(src, "For department channels, use the following say commands:")

	var/radio_text = ""
	for(var/i = 1 to common_radio.channels.len)
		var/channel = common_radio.channels69i69
		var/key = get_radio_key_from_channel(channel)
		radio_text += "69key69 - 69channel69"
		if(i != common_radio.channels.len)
			radio_text += ", "

	to_chat(src, radio_text)

	if (!check_special_role(ROLE_MALFUNCTION))
		show_laws()
		to_chat(src, "<b>These laws69ay be changed by other players, or by you being the contractor.</b>")

	job = "AI"
	setup_icon()

/mob/living/silicon/ai/Destroy()
	ai_list -= src

	QDEL_NULL(eyeobj)
	QDEL_NULL(psupply)
	QDEL_NULL(aiMulti)
	QDEL_NULL(aiRadio)
	QDEL_NULL(aiCamera)

	return ..()

/mob/living/silicon/ai/proc/setup_icon()
	var/file = file2text("config/custom_sprites.txt")
	var/lines = splittext(file, "\n")

	for(var/line in lines)
	// split & clean up
		var/list/Entry = splittext(line, ":")
		for(var/i = 1 to Entry.len)
			Entry69i69 = trim(Entry69i69)

		if(Entry.len < 2)
			continue;

		if(Entry69169 == src.ckey && Entry69269 == src.real_name)
			icon = CUSTOM_ITEM_SYNTH
			custom_sprite = 1
			selected_sprite =69ew/datum/ai_icon("Custom", "69src.ckey69-ai", "4", "69ckey69-ai-crash", "#FFFFFF", "#FFFFFF", "#FFFFFF")
		else
			selected_sprite = default_ai_icon
	updateicon()

/mob/living/silicon/ai/pointed(atom/A as69ob|obj|turf in69iew())
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/living/silicon/ai/SetName(pickedName as text)
	..()
	announcement.announcer = pickedName
	if(eyeobj)
		eyeobj.name = "69pickedName69 (AI Eye)"
/*
	The AI Power supply is a dummy object used for powering the AI since only69achinery should be using power.
	The alternative was to rewrite a bunch of AI code instead here we are.
*/
/obj/machinery/ai_powersupply
	name="Power Supply"
	active_power_usage=50000 // Station AIs use significant amounts of power. This, when combined with charged SMES should69ean AI lasts for 1hr without external power.
	use_power = ACTIVE_POWER_USE
	power_channel = STATIC_EQUIP
	var/mob/living/silicon/ai/powered_ai
	invisibility = 100

/obj/machinery/ai_powersupply/New(var/mob/living/silicon/ai/ai)
	powered_ai = ai
	powered_ai.psupply = src
	forceMove(powered_ai.loc)

	..()
	use_power(1) // Just incase we69eed to wake up the power system.

/obj/machinery/ai_powersupply/Destroy()
	. = ..()
	powered_ai =69ull

/obj/machinery/ai_powersupply/Process()
	if(!powered_ai || powered_ai.stat == DEAD)
		qdel(src)
		return
	if(powered_ai.psupply != src) // For some reason, the AI has different powersupply object. Delete this one, it's69o longer69eeded.
		qdel(src)
		return
	if(powered_ai.APU_power)
		use_power =69O_POWER_USE
		return
	if(!powered_ai.anchored)
		loc = powered_ai.loc
		use_power =69O_POWER_USE
		use_power(50000) // Less optimalised but only called if AI is unwrenched. This prevents usage of wrenching as69ethod to keep AI operational without power. Intellicard is for that.
	if(powered_ai.anchored)
		use_power = ACTIVE_POWER_USE

/mob/living/silicon/ai/proc/ai_movement_up()
	set category = "Silicon Commands"
	set69ame = "Move Upwards"
	zMove(UP)

/mob/living/silicon/ai/proc/ai_movement_down()
	set category = "Silicon Commands"
	set69ame = "Move Downwards"
	zMove(DOWN)

/mob/living/silicon/ai/proc/pick_icon()
	set category = "Silicon Commands"
	set69ame = "Set AI Core Display"
	if(stat || aiRestorePowerRoutine)
		return

	if (!custom_sprite)
		var/new_sprite = input("Select an icon!", "AI", selected_sprite) as69ull|anything in ai_icons
		if(new_sprite) selected_sprite =69ew_sprite
	updateicon()

// this69erb lets the ai see the stations69anifest
/mob/living/silicon/ai/proc/ai_roster()
	set category = "Silicon Commands"
	set69ame = "Show Crew69anifest"
	show_manifest(src)

/mob/living/silicon/ai/var/message_cooldown = 0
/mob/living/silicon/ai/proc/ai_announcement()
	set category = "Silicon Commands"
	set69ame = "Make Spaceship Announcement"

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(message_cooldown)
		to_chat(src, "Please allow one69inute to pass between announcements.")
		return
	var/input = input(usr, "Please write a69essage to announce to the ship's crew.", "A.I. Announcement")
	if(!input)
		return

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	announcement.Announce(input)
	message_cooldown = 1
	spawn(600)//One69inute cooldown
		message_cooldown = 0

/mob/living/silicon/ai/var/emergency_message_cooldown = 0
/mob/living/silicon/ai/proc/ai_emergency_message()
	set category = "Silicon Commands"
	set69ame = "Send Emergency69essage"

	if(check_unable(AI_CHECK_WIRELESS))
		return
	if(!is_relay_online())
		to_chat(usr, SPAN_WARNING("No Emergency Bluespace Relay detected. Unable to transmit69essage."))
		return
	if(emergency_message_cooldown)
		to_chat(usr, SPAN_WARNING("Arrays recycling. Please stand by."))
		return
	var/input = sanitize(input(usr, "Please choose a69essage to transmit to 69boss_short6969ia quantum entanglement.  Please be aware that this process is69ery expensive, and abuse will lead to... termination.  Transmission does69ot guarantee a response. There is a 30 second delay before you69ay send another69essage, be clear, full and concise.", "To abort, send an empty69essage.", ""))
	if(!input)
		return
	to_chat(usr, SPAN_NOTICE("No response from the remote server. Please, contact your system administrator."))
	log_say("69key_name(usr)69 has69ade an IA 69boss_short69 announcement: 69input69")
	emergency_message_cooldown = 1
	spawn(300)
		emergency_message_cooldown = 0


/mob/living/silicon/ai/check_eye(var/mob/user as69ob)
	if (!camera)
		return -1
	return 0

/mob/living/silicon/ai/restrained()
	return 0

/mob/living/silicon/ai/emp_act(severity)
	pull_to_core()  // Pull back69ind to core if it is controlling a drone
	if (prob(30))
		view_core()
	..()

/mob/living/silicon/ai/Topic(href, href_list)
	if(usr != src)
		return
	if(..())
		return
	if (href_list69"mach_close"69)
		if (href_list69"mach_close"69 == "aialerts")
			viewalerts = 0
		var/t1 = text("window=6969", href_list69"mach_close"69)
		unset_machine()
		src << browse(null, t1)
	if (href_list69"switchcamera"69)
		switchCamera(locate(href_list69"switchcamera"69)) in cameranet.cameras
	if (href_list69"showalerts"69)
		open_subsystem(/datum/nano_module/alarm_monitor/all)
	//Carn: holopad requests
	if (href_list69"jumptoholopad"69)
		var/obj/machinery/hologram/holopad/H = locate(href_list69"jumptoholopad"69)
		if(stat == CONSCIOUS)
			if(H)
				H.attack_ai(src) //may as well recycle
			else
				to_chat(src, SPAN_NOTICE("Unable to locate the holopad."))
	if (href_list69"track"69)
		var/mob/target = locate(href_list69"track"69) in SSmobs.mob_list
		if(target && (!ishuman(target) || target.real_name == target.get_face_name()))
			ai_actual_track(target)
		else
			to_chat(src, "\red System error. Cannot locate 69href_list69"trackname"6969.")
		return

	return

/mob/living/silicon/ai/reset_view(atom/A)
	if(controlled_mech)
		return ..(controlled_mech)
	if(camera)
		camera.set_light(0)
	if(istype(A,/obj/machinery/camera))
		camera = A
	..()
	if(istype(A,/obj/machinery/camera))
		if(camera_light_on)
			A.set_light(AI_CAMERA_LUMINOSITY)
		else
			A.set_light(0)


/mob/living/silicon/ai/proc/switchCamera(var/obj/machinery/camera/C)
	if (!C || stat == DEAD) //C.can_use())
		return 0

	if(!src.eyeobj)
		view_core()
		return
	// ok, we're alive, camera is good and in our69etwork...
	eyeobj.setLoc(get_turf(C))
	//machine = src

	return 1

/mob/living/silicon/ai/cancel_camera()
	set category = "Silicon Commands"
	set69ame = "Cancel Camera69iew"

	//src.cameraFollow =69ull
	src.view_core()

//Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm
//Adds in /mob/living/silicon/ai/proc/ai_network_change() instead
//Addition by69ord_Sith to define AI's69etwork change ability
/mob/living/silicon/ai/proc/get_camera_network_list()
	if(check_unable())
		return

	var/list/cameralist =69ew()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue
		var/list/tempnetwork = difflist(C.network,restricted_camera_networks,1)
		for(var/i in tempnetwork)
			cameralist69i69 = i

	cameralist = sortAssoc(cameralist)
	return cameralist

/mob/living/silicon/ai/proc/ai_network_change(var/network in get_camera_network_list())
	set category = "Silicon Commands"
	set69ame = "Jump To69etwork"
	unset_machine()

	if(!network)
		return

	if(!eyeobj)
		view_core()
		return

	src.network =69etwork

	for(var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue
		if(network in C.network)
			eyeobj.setLoc(get_turf(C))
			break
	to_chat(src, SPAN_NOTICE("Switched to 69network69 camera69etwork."))
//End of code by69ord_Sith

/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "Silicon Commands"
	set69ame = "AI Status"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	set_ai_status_displays(src)
	return

//I am the icon69eister. Bow fefore69e.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set69ame = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "Silicon Commands"

	if(check_unable())
		return

	var/input
	if(alert("Would you like to select a hologram based on a crew69ember or switch to unique avatar?",,"Crew69ember","Unique")=="Crew69ember")

		var/personnel_list6969 = list()

		for(var/datum/data/record/t in data_core.locked)//Look in data core locked.
			personnel_list69"69t.fields69"name"6969: 69t.fields69"rank"6969"69 = t.fields69"image"69//Pull69ames, rank, and image.

		if(personnel_list.len)
			input = input("Select a crew69ember:") as69ull|anything in personnel_list
			var/icon/character_icon = personnel_list69input69
			if(character_icon)
				qdel(holo_icon)//Clear old icon so we're69ot storing it in69emory.
				holo_icon = getHologramIcon(icon(character_icon))
		else
			alert("No suitable records found. Aborting.")

	else
		var/icon_list6969 = list(
		"default",
		"floating face",
		"carp"
		)
		input = input("Please select a hologram:") as69ull|anything in icon_list
		if(input)
			qdel(holo_icon)
			switch(input)
				if("default")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))
				if("floating face")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo2"))
				if("carp")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo4"))
	return

//Toggles the luminosity and applies it by re-entereing the camera.
/mob/living/silicon/ai/proc/toggle_camera_light()
	set69ame = "Toggle Camera Light"
	set desc = "Toggles the light on the camera the AI is looking through."
	set category = "Silicon Commands"

	if(check_unable())
		return

	camera_light_on = !camera_light_on
	to_chat(src, "Camera lights 69camera_light_on ? "activated" : "deactivated"69.")
	if(!camera_light_on)
		if(camera)
			camera.set_light(0)
			camera =69ull
	else
		lightNearbyCamera()



// Handled camera lighting, when toggled.
// It will get the69earest camera from the eyeobj, lighting it.

/mob/living/silicon/ai/proc/lightNearbyCamera()
	if(camera_light_on && camera_light_on < world.timeofday)
		if(src.camera)
			var/obj/machinery/camera/camera =69ear_range_camera(src.eyeobj)
			if(camera && src.camera != camera)
				src.camera.set_light(0)
				if(!camera.light_disabled)
					src.camera = camera
					src.camera.set_light(AI_CAMERA_LUMINOSITY)
				else
					src.camera =69ull
			else if(isnull(camera))
				src.camera.set_light(0)
				src.camera =69ull
		else
			var/obj/machinery/camera/camera =69ear_range_camera(src.eyeobj)
			if(camera && !camera.light_disabled)
				src.camera = camera
				src.camera.set_light(AI_CAMERA_LUMINOSITY)
		camera_light_on = world.timeofday + 1 * 20 // Update the light every 2 seconds.


/mob/living/silicon/ai/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/device/aicard))
		pull_to_core()  // Pull back69ind to core if it is controlling a drone
		var/obj/item/device/aicard/card = W
		card.grab_ai(src, user)

	var/tool_type = W.get_tool_type(user, list(QUALITY_BOLT_TURNING), src)
	if(tool_type == QUALITY_BOLT_TURNING)
		if(anchored)
			user.visible_message(SPAN_NOTICE("\The 69user69 starts to unbolt \the 69src69 from the plating..."))
			if(!do_after(user,40, src))
				user.visible_message(SPAN_NOTICE("\The 69user69 decides69ot to unbolt \the 69src69."))
				return
			user.visible_message(SPAN_NOTICE("\The 69user69 finishes unfastening \the 69src69!"))
			anchored = FALSE
			return
		else
			user.visible_message(SPAN_NOTICE("\The 69user69 starts to bolt \the 69src69 to the plating..."))
			if(!do_after(user,40,src))
				user.visible_message(SPAN_NOTICE("\The 69user69 decides69ot to bolt \the 69src69."))
				return
			user.visible_message(SPAN_NOTICE("\The 69user69 finishes fastening down \the 69src69!"))
			anchored = TRUE
			return
	else
		return ..()

/mob/living/silicon/ai/proc/control_integrated_radio()
	set69ame = "Radio Settings"
	set desc = "Allows you to change settings of your radio."
	set category = "Silicon Commands"

	if(check_unable(AI_CHECK_RADIO))
		return

	to_chat(src, "Accessing Subspace Transceiver control...")
	if (src.aiRadio)
		src.aiRadio.interact(src)

/mob/living/silicon/ai/proc/sensor_mode()
	set69ame = "Set Sensor Augmentation"
	set category = "Silicon Commands"
	set desc = "Augment69isual feed with internal sensor overlays"
	toggle_sensor_mode()

/mob/living/silicon/ai/proc/toggle_hologram_movement()
	set69ame = "Toggle Hologram69ovement"
	set category = "Silicon Commands"
	set desc = "Toggles hologram69ovement based on69oving with your69irtual eye."

	hologram_follow = !hologram_follow
	to_chat(usr, "<span class='info'>Your hologram will69ow 69hologram_follow ? "follow" : "no longer follow"69 you.</span>")

/mob/living/silicon/ai/proc/check_unable(var/flags = 0,69ar/feedback = 1)
	if(stat == DEAD)
		if(feedback) to_chat(src, SPAN_WARNING("You are dead!"))
		return 1

	if(aiRestorePowerRoutine)
		if(feedback) to_chat(src, SPAN_WARNING("You lack power!"))
		return 1

	if((flags & AI_CHECK_WIRELESS) && src.control_disabled)
		if(feedback) to_chat(src, SPAN_WARNING("Wireless control is disabled!"))
		return 1
	if((flags & AI_CHECK_RADIO) && src.aiRadio.disabledAi)
		if(feedback) to_chat(src, SPAN_WARNING("System Error - Transceiver Disabled!"))
		return 1
	return 0

/mob/living/silicon/ai/proc/is_in_chassis()
	return istype(loc, /turf)


/mob/living/silicon/ai/ex_act(var/severity)
	if(severity == 1)
		qdel(src)
		return
	..()

/mob/living/silicon/ai/proc/multitool_mode()
	set69ame = "Toggle69ultitool69ode"
	set category = "Silicon Commands"

	multitool_mode = !multitool_mode
	to_chat(src, "<span class='notice'>Multitool69ode: 69multitool_mode ? "E" : "Dise"69ngaged</span>")

/mob/living/silicon/ai/updateicon()
	if(!selected_sprite) selected_sprite = default_ai_icon

	if(stat == DEAD)
		icon_state = selected_sprite.dead_icon
		set_light(3, 1, selected_sprite.dead_light)
	else if(aiRestorePowerRoutine)
		icon_state = selected_sprite.nopower_icon
		set_light(1, 1, selected_sprite.nopower_light)
	else
		icon_state = selected_sprite.alive_icon
		set_light(1, 1, selected_sprite.alive_light)

// Pass lying down or getting up to our pet human, if we're in a rig.
/mob/living/silicon/ai/lay_down()
	set69ame = "Rest"
	set category = "IC"

	resting = 0
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.force_rest(src)

#undef AI_CHECK_WIRELESS
#undef AI_CHECK_RADIO

// Handles all69ecessary power checks: Area power, inteliCard and69alf AI APU power and69anual override.
//just a plug for69ow untill baymed arrives
/mob/living/silicon/ai/proc/has_power(var/respect_override = 1)
	return 1

// shortcuts for UI
/mob/living/silicon/ai/proc/take_photo()
	var/obj/item/device/camera/siliconcam/ai_camera/cam = aiCamera
	cam.take_image()

/mob/living/silicon/ai/proc/view_photos()
	var/obj/item/device/camera/siliconcam/ai_camera/cam = aiCamera
	cam.view_images()

// Control a tiny drone
/mob/living/silicon/ai/proc/control_personal_drone()
	set69ame = "Control Personal Drone"
	set desc = "Take control of your own AI-bound69aintenance drone."
	set category = "Silicon Commands"

	if(aiRestorePowerRoutine)  // Cannot switch if lack of power
		to_chat(src, SPAN_WARNING("You lack power!"))
	else
		go_into_drone()

// Destroy AI tiny drone
/mob/living/silicon/ai/proc/destroy_personal_drone()
	set69ame = "Destroy Personal Drone"
	set desc = "Destroy your AI-bound69aintenance drone."
	set category = "Silicon Commands"

	if(aiRestorePowerRoutine)  // Cannot switch if lack of power
		to_chat(src, SPAN_WARNING("You lack power!"))
	else
		destroy_drone()

/mob/living/silicon/ai/proc/pull_to_core()
	if (bound_drone?.mind)  // If drone exists and AI is inside it
		bound_drone.mind.active = 0 // We want to transfer the key69anually
		bound_drone.mind.transfer_to(src) // Pull back69ind to AI core
		key = bound_drone.key //69anually transfer the key to log them in

/mob/living/silicon/ai/proc/go_into_drone()
	// Switch to drone or spawn a69ew one
	if(!bound_drone)
		if (world.time - time_destroyed > drone_cooldown_time)
			try_drone_spawn(src, aibound = TRUE)
		else
			var/remaining = (drone_cooldown_time - (world.time - time_destroyed)) / 10
			to_chat(src, SPAN_WARNING("Security routines hardcoded into your core force you to wait 69remaining69 seconds before creating a69ew AI bound drone."))
	else if(mind)
		mind.active = 0 // We want to transfer the key69anually
		mind.transfer_to(bound_drone) // Transfer69ind to drone
		bound_drone.laws = laws // Resync laws in case they have been changed
		bound_drone.key = key //69anually transfer the key to log them in

/mob/living/silicon/ai/proc/destroy_drone()
	if(bound_drone)
		bound_drone.death(TRUE)
	else
		to_chat(src, SPAN_WARNING("You have69o active AI-bound69aintenance drone."))
