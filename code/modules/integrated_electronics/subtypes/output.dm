/obj/item/integrated_circuit/output
	category_text = "Output"

/obj/item/integrated_circuit/output/screen
	name = "small screen"
	extended_desc = " use &lt;br&gt; to start a new line"
	desc = "Takes any data type as an input, and displays it to the user upon examining."
	icon_state = "screen"
	inputs = list("displayed data" = IC_PINTYPE_ANY)
	outputs = list()
	activators = list("load data" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 10
	var/eol = "&lt;br&gt;"
	var/stuff_to_display = null

/obj/item/integrated_circuit/output/screen/disconnect_all()
	..()
	stuff_to_display = null

/obj/item/integrated_circuit/output/screen/any_examine(mob/user)
	var/shown_label = ""
	if(displayed_name && displayed_name != name)
		shown_label = " labeled '[displayed_name]'"

	to_chat(user, "There is \a [src][shown_label], which displays [!isnull(stuff_to_display) ? "'[stuff_to_display]'" : "nothing"].")

/obj/item/integrated_circuit/output/screen/get_topic_data()
	return stuff_to_display ? list(stuff_to_display) : list()

/obj/item/integrated_circuit/output/screen/do_work()
	var/datum/integrated_io/I = inputs[1]
	if(isweakref(I.data))
		var/datum/d = I.data_as_type(/datum)
		if(d)
			stuff_to_display = "[d]"
	else
		stuff_to_display = replacetext("[I.data]", eol , "\n")

/obj/item/integrated_circuit/output/screen/large
	name = "large screen"
	desc = "Takes any data type as an input and displays it to anybody near the device when pulsed. \
	It can also be examined to see the last thing it displayed."
	icon_state = "screen_medium"
	power_draw_per_use = 20

/obj/item/integrated_circuit/output/screen/large/do_work()
	..()

	if(isliving(assembly.loc))//this whole block just returns if the assembly is neither in a mobs hands or on the ground
		var/mob/living/H = assembly.loc
		if(H.get_active_hand() != assembly && H.get_inactive_hand() != assembly && istype(H))
			return
	else
		if(!isturf(assembly.loc))
			return

	var/list/nearby_things = range(0, get_turf(src))
	for(var/mob/M in nearby_things)
		var/obj/O = assembly ? assembly : src
		to_chat(M, SPAN("notice", "[icon2html(O.icon, world, O.icon_state)] [stuff_to_display]"))
	if(assembly)
		assembly.investigate_log("displayed \"[html_encode(stuff_to_display)]\" with [type].", INVESTIGATE_CIRCUIT)
	else
		investigate_log("displayed \"[html_encode(stuff_to_display)]\" as [type].", INVESTIGATE_CIRCUIT)

/obj/item/integrated_circuit/output/light
	name = "light"
	desc = "A basic light which can be toggled on/off when pulsed."
	icon_state = "light"
	complexity = 4
	max_allowed = 4
	inputs = list()
	outputs = list()
	activators = list("toggle light" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/light_toggled = FALSE
	var/light_brightness = 6
	var/light_rgb = "#FFFFFF"
	power_draw_idle = 0 // Adjusted based on brightness.

/obj/item/integrated_circuit/output/light/do_work()
	light_toggled = !light_toggled
	update_lighting()

/obj/item/integrated_circuit/output/light/proc/update_lighting()
	if(light_toggled)
		if(assembly)
			assembly.set_light(1, light_brightness/4, light_brightness, 2, light_rgb)
	else
		if(assembly)
			assembly.set_light(0)
	power_draw_idle = light_toggled ? light_brightness * 2 : 0

/obj/item/integrated_circuit/output/light/power_fail() // Turns off the flashlight if there's no power left.
	light_toggled = FALSE
	update_lighting()

/obj/item/integrated_circuit/output/light/advanced
	name = "advanced light"
	desc = "A light that takes a hexadecimal color value and a brightness value, and can be toggled on/off by pulsing it."
	icon_state = "light_adv"
	complexity = 8
	inputs = list(
		"color" = IC_PINTYPE_COLOR,
		"brightness" = IC_PINTYPE_NUMBER
	)
	outputs = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/output/light/advanced/on_data_written()
	update_lighting()

/obj/item/integrated_circuit/output/light/advanced/update_lighting()
	var/new_color = get_pin_data(IC_INPUT, 1)
	var/brightness = get_pin_data(IC_INPUT, 2)

	if(new_color && isnum_safe(brightness))
		brightness = clamp(brightness, 0, 4)
		light_rgb = new_color
		light_brightness = brightness

	..()

/obj/item/integrated_circuit/output/sound
	name = "speaker circuit"
	desc = "A miniature speaker is attached to this component."
	icon_state = "speaker"
	complexity = 8
	cooldown_per_use = 4 SECONDS
	inputs = list(
		"sound ID" = IC_PINTYPE_STRING,
		"volume" = IC_PINTYPE_NUMBER,
		"frequency" = IC_PINTYPE_BOOLEAN
	)
	max_allowed = 5
	outputs = list()
	activators = list("play sound" = IC_PINTYPE_PULSE_IN)
	power_draw_per_use = 10
	var/volume
	var/list/sounds = list()

/obj/item/integrated_circuit/output/sound/Initialize()
	.= ..()
	extended_desc = list()
	extended_desc += "The first input pin determines which sound is used. The choices are; "
	extended_desc += jointext(sounds, ", ")
	extended_desc += ". The second pin determines the volume of sound that is played"
	extended_desc += ", and the third determines if the frequency of the sound will vary with each activation."
	extended_desc = jointext(extended_desc, null)

/obj/item/integrated_circuit/output/sound/do_work()
	var/ID = get_pin_data(IC_INPUT, 1)
	var/vol = volume
	var/freq = get_pin_data(IC_INPUT, 3)
	if(!isnull(ID) && !isnull(vol))
		var/selected_sound = sounds[ID]
		if(!selected_sound)
			return
		vol = clamp(vol, 0, 100)
		playsound(src, selected_sound, vol, freq, -1)
		var/atom/A = get_object()
		A.investigate_log("played a sound ([selected_sound]) as [type].", INVESTIGATE_CIRCUIT)

/obj/item/integrated_circuit/output/sound/on_data_written()
	volume = get_pin_data(IC_INPUT, 2)
	volume = clamp(volume, 0, 100)
	power_draw_per_use =  volume * 15

/obj/item/integrated_circuit/output/sound/beeper
	name = "beeper circuit"
	desc = "Takes a sound name as an input, and will play said sound when pulsed. This circuit has a variety of beeps, boops, and buzzes to choose from."
	sounds = list(
		"beep"			= 'sound/machines/twobeep.ogg',
		"chime"			= 'sound/machines/chime.ogg',
		"buzz_sigh"		= 'sound/machines/buzz-sigh.ogg',
		"buzz_twice"	= 'sound/machines/buzz-two.ogg',
		"ping"			= 'sound/machines/ping.ogg',
		"synth_yes"		= 'sound/machines/synth_yes.ogg',
		"synth_no"		= 'sound/machines/synth_no.ogg',
		"warning_buzz"	= 'sound/machines/warning-buzzer.ogg'
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/output/sound/hev
	name = "HEV sound circuit"
	desc = "Takes a sound name as an input, and will play said sound when pulsed. This circuit is similar to those used in some old RIG suit"
	sounds = list(
		"bio_warn"						= 'sound/voice/Hevsounds/biohazard_detected.wav',
		"chem_warn" 					= 'sound/voice/Hevsounds/chemical_detected.wav',
		"rad_warn" 						= 'sound/voice/Hevsounds/radiation_detected.wav',
		"near_death"					= 'sound/voice/Hevsounds/near_death.wav',
		"seek_medic"					= 'sound/voice/Hevsounds/seek_medic.wav',
		"shock_damage"					= 'sound/voice/Hevsounds/shock_damage.wav',
		"blood_loss"					= 'sound/voice/Hevsounds/blood_loss.wav',
		"blood_plasma"					= 'sound/voice/Hevsounds/blood_plasma.wav',
		"blood_toxins"					= 'sound/voice/Hevsounds/blood_toxins.wav',
		"health_critical"				= 'sound/voice/Hevsounds/health_critical.wav',
		"health_dropping"				= 'sound/voice/Hevsounds/health_dropping.wav',
		"health_dropping2"				= 'sound/voice/Hevsounds/health_dropping2.wav',
		"minor_fracture"				= 'sound/voice/Hevsounds/minor_fracture.wav',
		"minor_lacerations"				= 'sound/voice/Hevsounds/minor_lacerations.wav',
		"major_fracture"				= 'sound/voice/Hevsounds/major_fracture.wav',
		"major_lacerations"				= 'sound/voice/Hevsounds/major_lacerations.wav',
		"wound_sterilized"				= 'sound/voice/Hevsounds/wound_sterilized.wav'
		)
	spawn_flags = IC_SPAWN_RESEARCH|IC_SPAWN_DEFAULT

/obj/item/integrated_circuit/output/sound/augmented
	name = "Augmented sound circuit"
	desc = "Takes a sound name as an input, and will play said sound when pulsed. This circuit is similar to those used in some old AI core"
	sounds = list(
		"rad_warn" 				= 'sound/voice/augmented/BB02.wav',
		"toxin_warn" 			= 'sound/voice/augmented/BB12.wav',
		"low_health" 			= 'sound/voice/augmented/BB03.wav',
		"chemical_need" 		= 'sound/voice/augmented/BB05.wav',
		"power_drain" 			= 'sound/voice/augmented/BB07.wav',
		"ammunition_drain" 		= 'sound/voice/augmented/BB08.wav',
		"access_needed" 		= 'sound/voice/augmented/BB13.wav',
		"affinity_activated" 	= 'sound/voice/augmented/BBCYBA_A.wav',
		"affinity_deactivated" 	= 'sound/voice/augmented/BBCYBA_D.wav',
		"login" 				= 'sound/voice/augmented/LOGIN.wav',
		"medscan" 				= 'sound/voice/augmented/medscan.wav'
	)
	spawn_flags = IC_SPAWN_RESEARCH|IC_SPAWN_DEFAULT

/obj/item/integrated_circuit/output/sound/beepsky
	name = "securitron sound circuit"
	desc = "Takes a sound name as an input, and will play said sound when pulsed. This circuit is similar to those used in Securitrons."
	sounds = list(
		"creep"			= 'sound/voice/bcreep.ogg',
		"criminal"		= 'sound/voice/bcriminal.ogg',
		"freeze"		= 'sound/voice/bfreeze.ogg',
		"god"			= 'sound/voice/bgod.ogg',
		"i am the law"	= 'sound/voice/biamthelaw.ogg',
		"radio"			= 'sound/voice/bradio.ogg',
		"secure day"	= 'sound/voice/bsecureday.ogg',
		// lol didn't know we have that funny sound
		"insult"		= 'sound/voice/binsult.ogg',
		)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/output/text_to_speech
	name = "text-to-speech circuit"
	desc = "Takes any string as an input and will make the device say the string when pulsed."
	extended_desc = "This unit is more advanced than the plain speaker circuit, able to transpose any valid text to speech."
	icon_state = "speaker"
	cooldown_per_use = 10
	complexity = 12
	inputs = list("text" = IC_PINTYPE_STRING)
	outputs = list()
	activators = list("to speech" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 60

/obj/item/integrated_circuit/output/text_to_speech/do_work()
	text = get_pin_data(IC_INPUT, 1)
	if(!isnull(text))
		var/atom/movable/A = get_object()
		var/sanitized_text = sanitize(html_decode(text))
		A.audible_message("\The [A] states, \"[sanitized_text]\"")
		if(assembly)
			log_say("[assembly] [ref(assembly)] : [sanitized_text]")
		else
			log_say("[name] ([type]) : [sanitized_text]")

/obj/item/integrated_circuit/output/text_to_speech/direct_message
	name = "personal message circuit"
	desc = "Takes any string as an input and will connect to brain/borg brain via antennas in body to sends message to person, if they are near"
	extended_desc = "This unit is more advanced than the plain speaker circuit, able to transpose any valid text to speech, but person need to have cruciform inside his head"
	complexity = 14
	inputs = list(
		"to speech" = IC_PINTYPE_STRING,
		"target" = IC_PINTYPE_REF
	)
	activators = list(
		"to speech" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT
	)
	power_draw_per_use = 90

/obj/item/integrated_circuit/output/text_to_speech/direct_message/do_work()
	var/text_to_speech = get_pin_data(IC_INPUT, 1)
	var/mob/living/L = get_pin_data(IC_INPUT, 2)
	var/message_before_tts = "" // for cool text
	if(!istype(L) && !istext(text_to_speech))
		activate_pin(3)
		return
	var/dist = get_dist(get_object(), L)
	if(dist == -1 || dist > 3)
		activate_pin(3)
		return
	if(isrobot(L))
		message_before_tts = "Your antenna reciving signal: "
	if(ishuman(L))
		var/mob/living/carbon/human/h = L
		var/obj/item/implant/core_implant/cruciform/S = h.get_core_implant(/obj/item/implant/core_implant/cruciform)
		if(S)
			message_before_tts = "Your [S] reciving signal: "
	if(istext(message_before_tts))
		text_to_speech = sanitize(text_to_speech)
		to_chat(L, SPAN_NOTICE("[message_before_tts][text_to_speech]"))
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/output/video_camera
	name = "video camera circuit"
	desc = "Takes a string as a name and a boolean to determine whether it is on, and uses this to be a camera linked to a list of networks you choose."
	extended_desc = "The camera is linked to a list of camera networks of your choosing. Common choices are 'rd' for the research network, 'ss13' for the main station network (visible to AI), 'mine' for the mining network, and 'thunder' for the thunderdome network (viewable from bar)."
	icon_state = "video_camera"
	w_class = ITEM_SIZE_SMALL
	complexity = 10
	inputs = list(
		"camera name" = IC_PINTYPE_STRING,
		"camera active" = IC_PINTYPE_BOOLEAN,
		"camera network" = IC_PINTYPE_LIST
		)
	inputs_default = list("1" = "video camera circuit", "3" = list(NETWORK_RESEARCH))
	outputs = list()
	activators = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE
	power_draw_idle = 0 // Raises to 20 when on.
	var/obj/machinery/camera/camera
	var/updating = FALSE

/obj/item/integrated_circuit/output/video_camera/Initialize()
	. = ..()
	camera = new(src)
	camera.network = list(NETWORK_RESEARCH)
	on_data_written()

/obj/item/integrated_circuit/output/video_camera/Destroy()
	QDEL_NULL(camera)
	return ..()

/obj/item/integrated_circuit/output/video_camera/proc/set_camera_status(status)
	if(camera)
		camera.set_status(status)
		power_draw_idle = camera.status ? 20 : 0
		if(camera.status) // Ensure that there's actually power.
			if(!draw_idle_power())
				power_fail()

/obj/item/integrated_circuit/output/video_camera/on_data_written()
	if(camera)
		var/cam_name = get_pin_data(IC_INPUT, 1)
		var/cam_active = get_pin_data(IC_INPUT, 2)
		var/list/new_network = get_pin_data(IC_INPUT, 3)
		if(!isnull(cam_name))
			camera.c_tag = cam_name
		if(!isnull(new_network))
			camera.replace_networks(new_network)
		set_camera_status(cam_active)

/obj/item/integrated_circuit/output/video_camera/power_fail()
	if(camera)
		set_camera_status(0)
		set_pin_data(IC_INPUT, 2, FALSE)

/obj/item/integrated_circuit/output/move_detector
	name = "movement detection"
	desc = "It's have a complicit gyroscope system, that activates pin if assembly moved"
	category_text = "Output"
	complexity = 4
	inputs = list()
	outputs = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	activators = list("moved" = IC_PINTYPE_PULSE_OUT)
	power_draw_idle = 10
	ext_moved_triggerable = TRUE
	var/turf/last_location

/obj/item/integrated_circuit/output/move_detector/ext_moved()
	var/turf/T = get_turf(get_object())
	if(last_location != T)
		activate_pin(1)
	last_location = T

/obj/item/integrated_circuit/output/led
	name = "light-emitting diode"
	desc = "RGB LED. Takes a boolean value in, and if the boolean value is 'true-equivalent', the LED will be marked as lit on examine."
	extended_desc = "TRUE-equivalent values are: Non-empty strings, non-zero numbers, and valid refs."
	complexity = 0.1
	max_allowed = 4
	icon_state = "led"
	inputs = list(
		"lit" = IC_PINTYPE_BOOLEAN,
		"color" = IC_PINTYPE_COLOR
	)
	outputs = list()
	activators = list()
	inputs_default = list(
		"2" = "#FF0000"
	)
	power_draw_idle = 0 // Raises to 1 when lit.
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/led_color = "#FF0000"

/obj/item/integrated_circuit/output/led/get_topic_data()
	return list("\An [initial(name)] that is currently [get_pin_data(IC_INPUT, 1) ? "lit" : "unlit."]")

/obj/item/integrated_circuit/output/led/on_data_written()
	power_draw_idle = get_pin_data(IC_INPUT, 1) ? 1 : 0
	led_color = get_pin_data(IC_INPUT, 2)

/obj/item/integrated_circuit/output/led/power_fail()
	set_pin_data(IC_INPUT, 1, FALSE)

/obj/item/integrated_circuit/output/led/external_examine(mob/user)
	var/text_output = "There is "

	if(name == displayed_name)
		text_output += "\an [name]"
	else
		text_output += "\an ["\improper[name]"] labeled '[displayed_name]'"
	text_output += " which is currently [get_pin_data(IC_INPUT, 1) ? "lit <font color=[led_color]>*</font>" : "unlit"]."
	to_chat(user, text_output)

/obj/item/integrated_circuit/output/screen/large
	name = "medium screen"

/obj/item/integrated_circuit/output/screen/extralarge // the subtype is called "extralarge" because tg brought back medium screens and they named the subtype /screen/large
	name = "large screen"
	desc = "Takes any data type as an input and displays it to the user upon examining, and to all nearby beings when pulsed."
	icon_state = "screen_large"
	power_draw_per_use = 40
	cooldown_per_use = 10

/obj/item/integrated_circuit/output/screen/extralarge/do_work()
	..()
	var/obj/O = assembly ? get_turf(assembly) : loc
	O.visible_message(SPAN("notice", "[icon2html(O.icon, world, O.icon_state)]  [stuff_to_display]"))
	if(assembly)
		assembly.investigate_log("displayed \"[html_encode(stuff_to_display)]\" with [type].", INVESTIGATE_CIRCUIT)
	else
		investigate_log("displayed \"[html_encode(stuff_to_display)]\" as [type].", INVESTIGATE_CIRCUIT)
