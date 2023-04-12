// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "Mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	var/id = null
	var/range = 2 //this is roughly the size of brig cell
	var/disable = 0
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How weakened targets are when flashed.
	var/base_state = "mflash"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	flags = PROXMOVE
	var/_wifi_id
	var/datum/wifi/receiver/button/flasher/wifi_receiver

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	description_info = "Will flash people that run"
	icon_state = "pflash1"
	strength = 8
	anchored = FALSE
	base_state = "pflash"
	density = TRUE
	range = 3 //the eris' hallways are wider than other maps

/obj/machinery/flasher/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/flasher/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/flasher/power_change()
	..()
	if ( !(stat & NOPOWER) )
		icon_state = "[base_state]1"
//		src.sd_SetLuminosity(2)
	else
		icon_state = "[base_state]1-p"
//		src.sd_SetLuminosity(0)

//Don't want to render prison breaks impossible
/obj/machinery/flasher/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/tool/wirecutters))
		add_fingerprint(user)
		src.disable = !src.disable
		if (src.disable)
			user.visible_message(SPAN_WARNING("[user] has disconnected the [src]'s flashbulb!"), SPAN_WARNING("You disconnect the [src]'s flashbulb!"))
		if (!src.disable)
			user.visible_message(SPAN_WARNING("[user] has connected the [src]'s flashbulb!"), SPAN_WARNING("You connect the [src]'s flashbulb!"))

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if (src.anchored)
		return src.flash()
	else
		return

/obj/machinery/flasher/proc/flash()
	if (!(powered()))
		return

	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("[base_state]_flash", src)
	src.last_flash = world.time
	use_power(1500)

	for (var/mob/living/O in viewers(src, null))
		if (get_dist(src, O) > src.range)
			continue

		var/flash_time = strength
		if (ishuman(O))
			var/mob/living/carbon/human/H = O
			if(!H.eyecheck() <= 0)
				continue
			O.flash(strength, FALSE , TRUE , TRUE , 10)
		else
			if(isrobot(O))
				var/mob/living/silicon/robot/robo = O
				if(robo.HasTrait(CYBORG_TRAIT_FLASH_RESISTANT))
					continue
				else
					robo.flash(strength, FALSE, FALSE , FALSE)
					continue
			else
				if (istype(O,/mob/living/silicon/ai))
					return
				O.flash(strength , FALSE, FALSE ,FALSE)
			O.Weaken(flash_time)


/obj/machinery/flasher/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(prob(75/severity))
		flash()
	..(severity)

/obj/machinery/flasher/portable/HasProximity(atom/movable/AM as mob|obj)
	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	if(iscarbon(AM))
		var/mob/living/carbon/M = AM
		if ((MOVING_DELIBERATELY(M)) && (src.anchored))
			return
		else if (src.anchored)
			src.flash()

/obj/machinery/flasher/portable/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/tool/wrench))
		add_fingerprint(user)
		src.anchored = !src.anchored

		if (!src.anchored)
			user.show_message(text(SPAN_WARNING("[src] can now be moved.")))
			src.overlays.Cut()

		else if (src.anchored)
			user.show_message(text(SPAN_WARNING("[src] is now secured.")))
			src.overlays += "[base_state]-s"

/obj/machinery/button/flasher
	name = "flasher button"
	desc = "A remote control switch for a mounted flasher."

/obj/machinery/button/flasher/attack_hand(mob/user as mob)

	if(..())
		return

	use_power(5)

	active = 1
	icon_state = "launcher1"

	for(var/obj/machinery/flasher/M in GLOB.machines)
		if(M.id == src.id)
			M.flash()

	sleep(50)

	icon_state = "launcher0"
	active = 0

	return
