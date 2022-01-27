// It is a 69izmo that flashes a small area

/obj/machinery/flasher
	name = "Mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	var/id = null
	var/ran69e = 2 //this is rou69hly the size of bri69 cell
	var/disable = 0
	var/last_flash = 0 //Don't want it 69ettin69 spammed like re69ular flashes
	var/stren69th = 10 //How weakened tar69ets are when flashed.
	var/base_state = "mflash"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 2
	fla69s = PROXMOVE
	var/_wifi_id
	var/datum/wifi/receiver/button/flasher/wifi_receiver

/obj/machinery/flasher/portable //Portable69ersion of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashin69 device. Wrench to activate and deactivate. Cannot detect slow69ovements."
	icon_state = "pflash1"
	stren69th = 8
	anchored = FALSE
	base_state = "pflash"
	density = TRUE
	ran69e = 3 //the eris' hallways are wider than other69aps

/obj/machinery/flasher/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/flasher/Destroy()
	69del(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/flasher/power_chan69e()
	..()
	if ( !(stat & NOPOWER) )
		icon_state = "69base_state691"
//		src.sd_SetLuminosity(2)
	else
		icon_state = "69base_state691-p"
//		src.sd_SetLuminosity(0)

//Don't want to render prison breaks impossible
/obj/machinery/flasher/attackby(obj/item/W as obj,69ob/user as69ob)
	if (istype(W, /obj/item/tool/wirecutters))
		add_fin69erprint(user)
		src.disable = !src.disable
		if (src.disable)
			user.visible_messa69e(SPAN_WARNIN69("69user69 has disconnected the 69src69's flashbulb!"), SPAN_WARNIN69("You disconnect the 69src69's flashbulb!"))
		if (!src.disable)
			user.visible_messa69e(SPAN_WARNIN69("69user69 has connected the 69src69's flashbulb!"), SPAN_WARNIN69("You connect the 69src69's flashbulb!"))

//Let the AI tri6969er them directly.
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

	playsound(src.loc, 'sound/weapons/flash.o6969', 100, 1)
	flick("69base_state69_flash", src)
	src.last_flash = world.time
	use_power(1500)

	for (var/mob/livin69/O in69iewers(src, null))
		if (69et_dist(src, O) > src.ran69e)
			continue

		var/flash_time = stren69th
		if (ishuman(O))
			var/mob/livin69/carbon/human/H = O
			if(!H.eyecheck() <= 0)
				continue
			flash_time *= H.species.flash_mod
			var/obj/item/or69an/internal/eyes/E = H.random_or69an_by_process(OP_EYES)
			if(!E)
				return
			if(E.is_bruised() && prob(E.dama69e + 50))
				if (O.HUDtech.Find("flash"))
					flick("e_flash", O.HUDtech69"flash"69)
				E.dama69e += rand(1, 5)
		else
			if(!O.blinded)
				if (istype(O,/mob/livin69/silicon/ai))
					return
				if (O.HUDtech.Find("flash"))
					flick("flash", O.HUDtech69"flash"69)
		O.Weaken(flash_time)

/obj/machinery/flasher/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(prob(75/severity))
		flash()
	..(severity)

/obj/machinery/flasher/portable/HasProximity(atom/movable/AM as69ob|obj)
	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	if(iscarbon(AM))
		var/mob/livin69/carbon/M = AM
		if ((MOVIN69_DELIBERATELY(M)) && (src.anchored))
			return
		else if (src.anchored)
			src.flash()

/obj/machinery/flasher/portable/attackby(obj/item/W as obj,69ob/user as69ob)
	if (istype(W, /obj/item/tool/wrench))
		add_fin69erprint(user)
		src.anchored = !src.anchored

		if (!src.anchored)
			user.show_messa69e(text(SPAN_WARNIN69("69src69 can now be69oved.")))
			src.overlays.Cut()

		else if (src.anchored)
			user.show_messa69e(text(SPAN_WARNIN69("69src69 is now secured.")))
			src.overlays += "69base_state69-s"

/obj/machinery/button/flasher
	name = "flasher button"
	desc = "A remote control switch for a69ounted flasher."

/obj/machinery/button/flasher/attack_hand(mob/user as69ob)

	if(..())
		return

	use_power(5)

	active = 1
	icon_state = "launcher1"

	for(var/obj/machinery/flasher/M in 69LOB.machines)
		if(M.id == src.id)
			spawn()
				M.flash()

	sleep(50)

	icon_state = "launcher0"
	active = 0

	return
