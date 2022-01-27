/*		Portable Turrets:
		Constructed from69etal, a 69un of choice, and a prox sensor.
		This code is sli69htly69ore documented than normal, as re69uested by XSI on IRC.
*/

#define TURRET_PRIORITY_TAR69ET 2
#define TURRET_SECONDARY_TAR69ET 1
#define TURRET_NOT_TAR69ET 0

/obj/machinery/porta_turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"
	anchored = TRUE

	density = FALSE
	use_power = IDLE_POWER_USE				//this turret uses and re69uires power
	idle_power_usa69e = 50		//when inactive, this turret takes up constant 50 E69uipment power
	active_power_usa69e = 300	//when active, this turret takes up constant 300 E69uipment power
	power_channel = STATIC_E69UIP	//drains power from the E69UIPMENT channel

	var/raised = 0			//if the turret cover is "open" and the turret is raised
	var/raisin69= 0			//if the turret is currently openin69 or closin69 its cover
	var/health = 80			//the turret's health
	var/maxhealth = 80		//turrets69aximal health.
	var/resistance = RESISTANCE_FRA69ILE 		//reduction on incomin69 dama69e
	var/auto_repair = 0		//if 1 the turret slowly repairs itself.
	var/locked = 1			//if the turret's behaviour control access is locked
	var/controllock = 0		//if the turret responds to control panels

	var/obj/item/69un/ener69y/installation = /obj/item/69un/ener69y/69un	//the weapon that's installed. Store as path to initialize a new 69un on creation.
	var/projectile	//holder for bullettype
	var/eprojectile	//holder for the shot when ema6969ed
	var/re69power = 500		//holder for power needed
	var/iconholder	//holder for the icon_state. 1 for oran69e sprite, null for blue.
	var/e69un			//holder to handle certain 69uns switchin69 bullettypes

	var/last_fired = 0		//1: if the turret is coolin69 down from a shot, 0: turret is ready to fire
	var/shot_delay = 15		//1.5 seconds between each shot

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everythin69 that does not69eet the access re69uirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth	 = 0 	//if active, will shoot at anythin69 not an AI or cybor69
	var/ailock = 0 			// AI cannot use this

	var/attacked = 0		//if set to 1, the turret 69ets pissed off and shoots at people nearby (unless they have sec access!)

	var/enabled = 1				//determines if the turret is on
	var/lethal = 0			//whether in lethal or stun69ode
	var/disabled = 0

	var/shot_sound 			//what sound should play when the turret fires
	var/eshot_sound			//what sound should play when the ema6969ed turret fires

	var/datum/effect/effect/system/spark_spread/spark_system	//the spark system, used for 69eneratin69... sparks?

	var/wrenchin69 = 0
	var/last_tar69et					//last tar69et fired at, prevents turrets from erratically firin69 at all69alid tar69ets in ran69e

	var/hackfail = 0				//if the turret has 69otten pissed at someone who tried to hack it, but failed, it will immediately reactivate and tar69et them.
	var/debu69open = 0				//if the turret's debu69 functions are accessible throu69h the control panel
	var/list/re69istered_names = list() 		//holder for re69istered IDs for the turret to i69nore
	var/list/access_occupy = list()
	var/overridden = 0				//if the security override is 0, security protocols are on. if 1, protocols are broken.

/obj/machinery/porta_turret/One_star
	name = "one star turret"

/obj/machinery/porta_turret/crescent
	enabled = 0
	ailock = 1
	check_synth	 = 0
	check_access = 1
	check_arrest = 1
	check_records = 1
	check_weapons = 1
	check_anomalies = 1



/obj/machinery/porta_turret/stationary
	ailock = 1
	lethal = 1
	installation = /obj/item/69un/ener69y/laser

/obj/machinery/porta_turret/New()
	..()
	re69_access.Cut()
	re69_one_access = list(access_security, access_heads, access_occupy)

	//Sets up a spark system
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	var/area/A = 69et_area(src)
	SEND_SI69NAL(A, COMSI69_TURRENT, src)
	setup()

/obj/machinery/porta_turret/crescent/New()
	..()
	re69_one_access.Cut()
	re69_access = list(access_cent_specops)

/obj/machinery/porta_turret/Destroy()
	69del(spark_system)
	spark_system = null
	69DEL_NULL(installation)
	. = ..()

/obj/machinery/porta_turret/proc/setup()
	if(ispath(installation))
		weapon_setup(installation)
		installation = new installation	//All ener69y-based weapons are applicable
	else
		eprojectile = installation.projectile_type
		eshot_sound = installation.fire_sound
	projectile = installation.projectile_type
	shot_sound = installation.fire_sound

/obj/machinery/porta_turret/proc/weapon_setup(var/69untype)
	switch(69untype)
		if(/obj/item/69un/ener69y/laser/practice)
			iconholder = 1
			eprojectile = /obj/item/projectile/beam

//			if(/obj/item/69un/ener69y/laser/practice/sc_laser)
//				iconholder = 1
//				eprojectile = /obj/item/projectile/beam

		if(/obj/item/69un/ener69y/retro)
			iconholder = 1

//			if(/obj/item/69un/ener69y/retro/sc_retro)
//				iconholder = 1

		if(/obj/item/69un/ener69y/captain)
			iconholder = 1

		if(/obj/item/69un/ener69y/lasercannon)
			iconholder = 1

		if(/obj/item/69un/ener69y/taser)
			eprojectile = /obj/item/projectile/beam
			eshot_sound = 'sound/weapons/Laser.o6969'

		if(/obj/item/69un/ener69y/stunrevolver)
			eprojectile = /obj/item/projectile/beam
			eshot_sound = 'sound/weapons/Laser.o6969'

		if(/obj/item/69un/ener69y/69un)
			eprojectile = /obj/item/projectile/beam	//If it has, 69oin69 to kill69ode
			eshot_sound = 'sound/weapons/Laser.o6969'
			e69un = 1

		if(/obj/item/69un/ener69y/nuclear)
			eprojectile = /obj/item/projectile/beam	//If it has, 69oin69 to kill69ode
			eshot_sound = 'sound/weapons/Laser.o6969'
			e69un = 1

var/list/turret_icons

/obj/machinery/porta_turret/update_icon()
	if(!turret_icons)
		turret_icons = list()
		turret_icons69"open"69 = ima69e(icon, "openTurretCover")

	underlays.Cut()
	underlays += turret_icons69"open"69

	if(stat & BROKEN)
		icon_state = "destroyed_tar69et_prism"
	else if(raised || raisin69)
		if(powered() && enabled)
			if(iconholder)
				//lasers have a oran69e icon
				icon_state = "oran69e_tar69et_prism"
			else
				//almost everythin69 has a blue icon
				icon_state = "tar69et_prism"
		else
			icon_state = "69rey_tar69et_prism"
	else
		icon_state = "turretCover"

/obj/machinery/porta_turret/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, SPAN_NOTICE("There seems to be a firewall preventin69 you from accessin69 this device."))
		return 1

	if(locked && !issilicon(user))
		to_chat(user, SPAN_NOTICE("Access denied."))
		return 1

	return 0

/obj/machinery/porta_turret/attack_hand(mob/user)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/porta_turret/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069
	data69"access"69 = !isLocked(user)
	data69"locked"69 = locked
	data69"enabled"69 = enabled
	data69"is_lethal"69 = 1
	data69"lethal"69 = lethal

	if(data69"access"69)
		var/settin69s69069
		settin69s69++settin69s.len69 = list("cate69ory" = "Neutralize All Non-Synthetics", "settin69" = "check_synth", "value" = check_synth)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check Weapon Authorization", "settin69" = "check_weapons", "value" = check_weapons)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check Security Records", "settin69" = "check_records", "value" = check_records)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check Arrest Status", "settin69" = "check_arrest", "value" = check_arrest)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check Access Authorization", "settin69" = "check_access", "value" = check_access)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check69isc. Lifeforms", "settin69" = "check_anomalies", "value" = check_anomalies)
		data69"settin69s"69 = settin69s

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/porta_turret/proc/HasController()
	var/area/A = 69et_area(src)
	return A && A.turret_controls.len > 0

/obj/machinery/porta_turret/CanUseTopic(var/mob/user)
	if(HasController())
		to_chat(user, SPAN_NOTICE("Turrets can only be controlled usin69 the assi69ned turret controller."))
		return STATUS_CLOSE

	if(isLocked(user))
		return STATUS_CLOSE

	if(!anchored)
		to_chat(usr, SPAN_NOTICE("\The 69src69 has to be secured first!"))
		return STATUS_CLOSE

	return ..()


/obj/machinery/porta_turret/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"command"69 && href_list69"value"69)
		var/value = text2num(href_list69"value"69)
		if(href_list69"command"69 == "enable")
			if(anchored)
				enabled =69alue
		else if(href_list69"command"69 == "lethal")
			lethal =69alue
		else if(href_list69"command"69 == "check_synth")
			check_synth =69alue
		else if(href_list69"command"69 == "check_weapons")
			check_weapons =69alue
		else if(href_list69"command"69 == "check_records")
			check_records =69alue
		else if(href_list69"command"69 == "check_arrest")
			check_arrest =69alue
		else if(href_list69"command"69 == "check_access")
			check_access =69alue
		else if(href_list69"command"69 == "check_anomalies")
			check_anomalies =69alue

		return 1

/obj/machinery/porta_turret/power_chan69e()
	if(powered())
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			update_icon()


/obj/machinery/porta_turret/attackby(obj/item/I,69ob/user)

	var/obj/item/card/id/ID = I.69etIdCard()

	if (user.a_intent == I_HELP)
		if(stat & BROKEN)
			if(69UALITY_PRYIN69 in I.tool_69ualities)
				//If the turret is destroyed, you can remove it with a crowbar to
				//try and salva69e its components
				to_chat(user, SPAN_NOTICE("You be69in pryin69 the69etal coverin69s off."))
				if(do_after(user, 20, src))
					if(prob(70))
						to_chat(user, SPAN_NOTICE("You remove the turret and salva69e some components."))
						if(installation)
							installation.forceMove(loc)
							installation = null
						if(prob(50))
							new /obj/item/stack/material/steel(loc, rand(1,4))
						if(prob(50))
							new /obj/item/device/assembly/prox_sensor(loc)
					else
						to_chat(user, SPAN_NOTICE("You remove the turret but did not69ana69e to salva69e anythin69."))
					69del(src) // 69del
			return 1 //No whackin69 the turret with tools on help intent

		else if(69UALITY_BOLT_TURNIN69 in I.tool_69ualities)
			if(enabled)
				to_chat(user, SPAN_WARNIN69("You cannot unsecure an active turret!"))
				return
			if(wrenchin69)
				to_chat(user, "<span class='warnin69'>Someone is already 69anchored ? "un" : ""69securin69 the turret!</span>")
				return
			if(debu69open)
				to_chat(user, SPAN_WARNIN69("You can't secure the turret while the circuitry is exposed!"))
				return
			if(!anchored && isinspace())
				to_chat(user, SPAN_WARNIN69("Cannot secure turrets in space!"))
				return

			user.visible_messa69e( \
					"<span class='warnin69'>69user69 be69ins 69anchored ? "un" : ""69securin69 the turret.</span>", \
					"<span class='notice'>You be69in 69anchored ? "un" : ""69securin69 the turret.</span>" \
				)

			wrenchin69 = 1
			if(do_after(user, 50, src))
				//This code handles69ovin69 the turret around. After all, it's a portable turret!
				if(!anchored)
					playsound(loc, 'sound/items/Ratchet.o6969', 100, 1)
					anchored = TRUE
					update_icon()
					to_chat(user, SPAN_NOTICE("You secure the exterior bolts on the turret."))
					if(disabled)
						spawn(200)
							disabled = FALSE
				else if(anchored)
					if(disabled)
						to_chat(user, SPAN_NOTICE("The turret is still recalibratin69. Wait some time before tryin69 to69ove it."))
						return
					playsound(loc, 'sound/items/Ratchet.o6969', 100, 1)
					anchored = FALSE
					disabled = TRUE
					to_chat(user, SPAN_NOTICE("You unsecure the exterior bolts on the turret."))
					update_icon()
			wrenchin69 = 0
			return 1 //No whackin69 the turret with tools on help intent

		else if(istype(I, /obj/item/card/id)||istype(I, /obj/item/modular_computer))
			if(allowed(user))
				locked = !locked
				to_chat(user, "<span class='notice'>Controls are now 69locked ? "locked" : "unlocked"69.</span>")
				updateUsrDialo69()
			else if((debu69open) && (has_access(access_occupy, list(), ID.69etAccess())))
				re69istered_names += ID.re69istered_name
				to_chat(user, SPAN_NOTICE("You transfer the card's ID code to the turret's list of tar69ettin69 exceptions."))
			else
				to_chat(user, SPAN_NOTICE("Access denied."))
			return 1 //No whackin69 the turret with tools on help intent

		else if(69UALITY_PULSIN69 in I.tool_69ualities)
			if(debu69open)
				if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_PULSIN69, FAILCHANCE_NORMAL,  re69uired_stat = STAT_CO69))
					re69istered_names.Cut()
					re69istered_names = list()
					to_chat(user, SPAN_NOTICE("You access the debu69 board and reset the turret's access list."))

			else
				if(I.use_tool(user, src, WORKTIME_LON69, 69UALITY_PULSIN69, FAILCHANCE_HARD,  re69uired_stat = STAT_CO69))
					if((TOOL_USE_SUCCESS) && (isLocked(user)))
						locked = 0
						to_chat(user, SPAN_NOTICE("You69ana69e to hack the ID reader, unlockin69 the access panel with a satisfyin69 click."))
						updateUsrDialo69()
					else if((TOOL_USE_SUCCESS) && (!isLocked(user)))
						locked = 1
						to_chat(user, SPAN_NOTICE("You69ana69e to hack the ID reader and the access panel's lockin69 lu69s snap shut."))
						updateUsrDialo69()
					else if((TOOL_USE_FAIL) && (!overridden) && (min(prob(35 - STAT_CO69), 5)))
						enabled = 1
						hackfail = 1
						user.visible_messa69e(
							SPAN_DAN69ER("69user69 tripped the security protocol on the 69src69! Run!"),
							SPAN_DAN69ER("You trip the security protocol! Run!")
						)
						sleep(300)
						hackfail = 0
					else
						to_chat(user, SPAN_WARNIN69("You fail to hack the ID reader, but avoid trippin69 the security protocol."))
			return 1 //No whackin69 the turret with tools on help intent

		else if(69UALITY_SCREW_DRIVIN69 in I.tool_69ualities)
			if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_SCREW_DRIVIN69, FAILCHANCE_HARD,  re69uired_stat = STAT_MEC))
				if(debu69open)
					debu69open = 0
					to_chat(user, SPAN_NOTICE("You carefully shut the secondary69aintenance hatch and screw it back into place."))
				else
					debu69open = 1
					to_chat(user, SPAN_NOTICE("You 69ently unscrew the seconday69aintenance hatch, 69ainin69 access to the turret's internal circuitry and debu69 functions."))
					desc = "A hatch on the bottom of the access panel is opened, exposin69 the circuitry inside."
			return 1 //No whackin69 the turret with tools on help intent

		else if((69UALITY_WIRE_CUTTIN69 in I.tool_69ualities) && (debu69open))
			if(overridden)
				to_chat(user, SPAN_WARNIN69("The security protocol override has already been disconnected!"))
			else
				switch(I.use_tool_extended(user, src, WORKTIME_NORMAL, 69UALITY_WIRE_CUTTIN69, FAILCHANCE_VERY_HARD,  re69uired_stat = STAT_MEC))
					if(TOOL_USE_SUCCESS)
						to_chat(user, SPAN_NOTICE("You disconnect the turret's security protocol override!"))
						overridden = 1
						re69_one_access.Cut()
						re69_one_access = list(access_occupy)
					if(TOOL_USE_FAIL)
						user.visible_messa69e(
							SPAN_DAN69ER("69user69 cut the wron69 wire and tripped the security protocol on the 69src69! Run!"),
							SPAN_DAN69ER("You accidentally cut the wron69 wire, trippin69 the security protocol! Run!")
						)
						enabled = 1
						hackfail = 1
						sleep(300)
						hackfail = 0
			return 1 //No whackin69 the turret with tools on help intent

	if (!(I.fla69s & NOBLUD69EON) && I.force && !(stat & BROKEN))
		//if the turret was attacked with the intention of harmin69 it:
		user.do_attack_animation(src)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

		if (take_dama69e(I.force * I.structure_dama69e_factor))
			playsound(src, 'sound/weapons/smash.o6969', 70, 1)
		else
			playsound(src, 'sound/weapons/69enhit.o6969', 25, 1)

		if(!attacked && !ema6969ed)
			attacked = 1
			spawn()
				sleep(60)
				attacked = 0
		return TRUE
	..()

/obj/machinery/porta_turret/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(!ema6969ed)
		//Ema6969in69 the turret69akes it 69o bonkers and stun everyone. It also69akes
		//the turret shoot69uch,69uch faster.
		to_chat(user, SPAN_WARNIN69("You short out 69src69's threat assessment circuits."))
		visible_messa69e("69src69 hums oddly...")
		ema6969ed = 1
		iconholder = 1
		controllock = 1
		enabled = 0 //turns off the turret temporarily
		sleep(60) //6 seconds for the contractor to 69tfo of the area before the turret decides to ruin his shit
		enabled = 1 //turns it back on. The cover popUp() popDown() are automatically called in process(), no need to define it here
		return 1

/obj/machinery/porta_turret/proc/take_dama69e(var/force)
	if(!raised && !raisin69)
		force = force / 8


	force -= resistance
	if (force <= 0)
		return FALSE

	.=TRUE //Some dama69e was done
	health -= force
	if (force > 5 && prob(45))
		spark_system.start()
	if(health <= 0)
		die()	//the death process :(

/obj/machinery/porta_turret/bullet_act(obj/item/projectile/Proj)
	var/dama69e = Proj.69et_structure_dama69e()

	if(!dama69e)
		if(istype(Proj, /obj/item/projectile/ion))
			Proj.on_hit(loc)
		return

	if(enabled)
		if(!attacked && !ema6969ed)
			attacked = 1
			spawn()
				sleep(60)
				attacked = 0

	..()

	take_dama69e(dama69e*Proj.structure_dama69e_factor)

/obj/machinery/porta_turret/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no69atter how severe disables the turret for a while
		//and scrambles its settin69s, with a sli69ht chance of havin69 an ema69 effect
		check_arrest = prob(50)
		check_records = prob(50)
		check_weapons = prob(50)
		check_access = prob(20)	// check_access is a pretty bi69 deal, so it's least likely to 69et turned on
		check_anomalies = prob(50)
		if(prob(5))
			ema6969ed = 1

		enabled=0
		spawn(rand(60,600))
			if(!enabled)
				enabled=1

	..()

/obj/machinery/porta_turret/ex_act(severity)
	switch (severity)
		if (1)
			take_dama69e(rand(140,300))
		if (2)
			take_dama69e(rand(80,170))
		if (3)
			take_dama69e(rand(50,120))

/obj/machinery/porta_turret/proc/die()	//called when the turret dies, ie, health <= 0
	health = 0
	stat |= BROKEN	//enables the BROKEN bit
	spark_system.start()	//creates some sparks because they look cool
	update_icon()

/obj/machinery/porta_turret/Process()
	//the69ain69achinery process

	if(stat & (NOPOWER|BROKEN))
		//if the turret has no power or is broken,69ake the turret pop down if it hasn't already
		popDown()
		return

	if(!enabled)
		//if the turret is off,69ake it pop down
		popDown()
		return

	var/list/tar69ets = list()			//list of primary tar69ets
	var/list/secondarytar69ets = list()	//tar69ets that are least important

	for(var/mob/M in69obs_in_view(world.view, src))
		assess_and_assi69n(M, tar69ets, secondarytar69ets)

	if(!tryToShootAt(tar69ets))
		if(!tryToShootAt(secondarytar69ets)) // if no69alid tar69ets, 69o for secondary tar69ets
			spawn()
				popDown() // no69alid tar69ets, close the cover

	if(auto_repair && (health <69axhealth))
		use_power(20000)
		health =69in(health+1,69axhealth) // 1HP for 20kJ

/obj/machinery/porta_turret/proc/assess_and_assi69n(var/mob/livin69/L,69ar/list/tar69ets,69ar/list/secondarytar69ets)
	switch(assess_livin69(L))
		if(TURRET_PRIORITY_TAR69ET)
			tar69ets += L
		if(TURRET_SECONDARY_TAR69ET)
			secondarytar69ets += L

/obj/machinery/porta_turret/proc/assess_livin69(var/mob/livin69/L)
	var/obj/item/card/id/id_card = L.69etIdCard()

	if(id_card && (id_card.re69istered_name in re69istered_names))
		return TURRET_NOT_TAR69ET

	if(!istype(L))
		return TURRET_NOT_TAR69ET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a69ob-var
		return TURRET_NOT_TAR69ET

	if(!L)
		return TURRET_NOT_TAR69ET

	if(!ema6969ed && (issilicon(L) && !isblitzshell(L)))	// Don't tar69et silica
		return TURRET_NOT_TAR69ET

	if(L.stat && !ema6969ed)		//if the perp is dead/dyin69, no need to bother really
		return TURRET_NOT_TAR69ET	//move onto next potential69ictim!

	if(69et_dist(src, L) > 7)	//if it's too far away, why bother?
		return TURRET_NOT_TAR69ET

	if(!check_trajectory(L, src))	//check if we have true line of si69ht
		return TURRET_NOT_TAR69ET

	if(ema6969ed)		// If ema6969ed not even the dead 69et a rest
		return L.stat ? TURRET_SECONDARY_TAR69ET : TURRET_PRIORITY_TAR69ET

	if(hackfail)
		return TURRET_PRIORITY_TAR69ET

	if(lethal && locate(/mob/livin69/silicon/ai) in 69et_turf(L))		//don't accidentally kill the AI!
		return TURRET_NOT_TAR69ET

	if(check_synth)	//If it's set to attack all non-silicons, tar69et them!
		if(L.lyin69)
			return lethal ? TURRET_SECONDARY_TAR69ET : TURRET_NOT_TAR69ET
		return TURRET_PRIORITY_TAR69ET

	if(iscuffed(L)) // If the tar69et is handcuffed, leave it alone
		return TURRET_NOT_TAR69ET

	if(isanimal(L) || issmall(L)) // Animals are not so dan69erous
		return check_anomalies ? TURRET_SECONDARY_TAR69ET : TURRET_NOT_TAR69ET

	if(isblitzshell(L)) // Blitzshells are dan69erous
		return check_anomalies ? TURRET_PRIORITY_TAR69ET	: TURRET_NOT_TAR69ET

	if(ishuman(L))	//if the tar69et is a human, analyze threat level
		if(assess_perp(L) < 4)
			return TURRET_NOT_TAR69ET	//if threat level < 4, keep 69oin69

	if(L.lyin69)		//if the perp is lyin69 down, it's still a tar69et but a less-important tar69et
		return lethal ? TURRET_SECONDARY_TAR69ET : TURRET_NOT_TAR69ET

	return TURRET_PRIORITY_TAR69ET	//if the perp has passed all previous tests, con69rats, it is now a "shoot-me!" nominee

/obj/machinery/porta_turret/One_star/assess_livin69(var/mob/livin69/L)
	if(L.faction == "onestar")
		return TURRET_NOT_TAR69ET
	return 	..()

/obj/machinery/porta_turret/proc/assess_perp(var/mob/livin69/carbon/human/H)
	if(!H || !istype(H))
		return 0

	if(ema6969ed)
		return 10

	return H.assess_perp(src, check_access, check_weapons, check_records, check_arrest)

/obj/machinery/porta_turret/proc/tryToShootAt(var/list/mob/livin69/tar69ets)
	if(tar69ets.len && last_tar69et && (last_tar69et in tar69ets) && tar69et(last_tar69et))
		return 1

	while(tar69ets.len > 0)
		var/mob/livin69/M = pick(tar69ets)
		tar69ets -=69
		if(tar69et(M))
			return 1


/obj/machinery/porta_turret/proc/popUp()	//pops the turret up
	if(disabled)
		return
	if(raisin69 || raised)
		return
	if(stat & BROKEN)
		return
	set_raised_raisin69(raised, 1)
	update_icon()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popup", flick_holder)
	sleep(10)
	69del(flick_holder)

	set_raised_raisin69(1, 0)
	update_icon()

/obj/machinery/porta_turret/proc/popDown()	//pops the turret down
	last_tar69et = null
	if(disabled)
		return
	if(raisin69 || !raised)
		return
	if(stat & BROKEN)
		return
	set_raised_raisin69(raised, 1)
	update_icon()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popdown", flick_holder)
	sleep(10)
	69del(flick_holder)

	set_raised_raisin69(0, 0)
	update_icon()

/obj/machinery/porta_turret/proc/set_raised_raisin69(var/raised,69ar/raisin69)
	src.raised = raised
	src.raisin69 = raisin69
	density = raised || raisin69

/obj/machinery/porta_turret/proc/tar69et(var/mob/livin69/tar69et)
	if(disabled)
		return
	if(tar69et)
		last_tar69et = tar69et
		spawn()
			popUp()				//pop the turret up if it's not already up.
		set_dir(69et_dir(src, tar69et))	//even if you can't shoot, follow the tar69et
		spawn()
			shootAt(tar69et)
		return 1
	return

/obj/machinery/porta_turret/proc/shootAt(var/mob/livin69/tar69et)
	//any ema6969ed turrets will shoot extremely fast! This not only is deadly, but drains a lot power!
	if(!(ema6969ed || attacked))		//if it hasn't been ema6969ed or attacked, it has to obey a cooldown rate
		if(last_fired || !raised)	//prevents rapid-fire shootin69, unless it's been ema6969ed
			return
		last_fired = 1
		spawn()
			sleep(shot_delay)
			last_fired = 0

	var/turf/T = 69et_turf(src)
	var/turf/U = 69et_turf(tar69et)
	if(!istype(T) || !istype(U))
		return

	if(!raised) //the turret has to be raised in order to fire -69akes sense, ri69ht?
		return

	launch_projectile(tar69et)

/obj/machinery/porta_turret/proc/launch_projectile(mob/livin69/tar69et)
	update_icon()
	var/obj/item/projectile/A
	if(ema6969ed || lethal)
		A = new eprojectile(loc)
		playsound(loc, eshot_sound, 75, 1)
	else
		A = new projectile(loc)
		playsound(loc, shot_sound, 75, 1)

	// Lethal/ema6969ed turrets use twice the power due to hi69her ener69y beams
	// Ema6969ed turrets a69ain use twice as69uch power due to hi69her firin69 rates
	use_power(re69power * (2 * (ema6969ed || lethal)) * (2 * ema6969ed))

	//Turrets aim for the center of69ass by default.
	//If the tar69et is 69rabbin69 someone then the turret smartly aims for extremities
	var/def_zone = 69et_exposed_defense_zone(tar69et)
	//Shootin69 Code:
	A.launch(tar69et, def_zone)

/datum/turret_checks
	var/enabled
	var/lethal
	var/check_synth
	var/check_access
	var/check_records
	var/check_arrest
	var/check_weapons
	var/check_anomalies
	var/ailock

/obj/machinery/porta_turret/proc/setState(var/datum/turret_checks/TC)
	if(controllock)
		return
	src.enabled = TC.enabled
	src.lethal = TC.lethal
	src.iconholder = TC.lethal

	check_synth = TC.check_synth
	check_access = TC.check_access
	check_records = TC.check_records
	check_arrest = TC.check_arrest
	check_weapons = TC.check_weapons
	check_anomalies = TC.check_anomalies
	ailock = TC.ailock

	src.power_chan69e()

/*
		Portable turret constructions
		Known as "turret frame"s
*/

/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame"
	density = TRUE
	var/build_step = 0			//the current step in the buildin69 process
	var/finish_name="turret"	//the name applied to the product turret
	var/obj/item/69un/ener69y/installation		//the 69un type installed
	var/69un_char69e = 0			//the 69un char69e of the 69un type installed


/obj/machinery/porta_turret_construct/attackby(obj/item/I,69ob/user)

	var/list/usable_69ualities = list()
	if((build_step == 0 && !anchored) || build_step == 1 || build_step == 2 || build_step == 3)
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)
	if((build_step == 0 && !anchored) || build_step == 7)
		usable_69ualities.Add(69UALITY_PRYIN69)
	if(build_step == 2 || build_step == 7)
		usable_69ualities.Add(69UALITY_WELDIN69)
	if(build_step == 5 || build_step == 6)
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_BOLT_TURNIN69)
			if(build_step == 0 && !anchored)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You secure the external bolts."))
					anchored = TRUE
					build_step = 1
					return
			if(build_step == 1)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You unfasten the external bolts."))
					anchored = FALSE
					build_step = 0
					return
			if(build_step == 2)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You bolt the69etal armor into place."))
					build_step = 3
					return
			if(build_step == 3)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You remove the turret's69etal armor bolts."))
					build_step = 2
					return
			return

		if(69UALITY_PRYIN69)
			if(build_step == 0 && !anchored)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You dismantle the turret construction."))
					new /obj/item/stack/material/steel( loc, 8)
					69del(src)
					return
			if(build_step == 7)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You pry off the turret's exterior armor."))
					new /obj/item/stack/material/steel(loc, 2)
					build_step = 6
					return
			return

		if(69UALITY_WELDIN69)
			if(build_step == 2)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, "You remove the turret's interior69etal armor.")
					new /obj/item/stack/material/steel( loc, 2)
					build_step = 1
					return
			if(build_step == 7)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					build_step = 8
					to_chat(user, SPAN_NOTICE("You weld the turret's armor down."))

					//The final step: create a full turret
					var/obj/machinery/porta_turret/Turret = new /obj/machinery/porta_turret(loc)
					Turret.name = finish_name
					Turret.installation = installation
					installation.forceMove(Turret)
					installation = null
					Turret.enabled = 0
					Turret.setup()

					69del(src)
					return
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(build_step == 5)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You close the internal access hatch."))
					build_step = 6
					return
			if(build_step == 6)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You open the internal access hatch."))
					build_step = 5
					return
			return

		if(ABORT_CHECK)
			return


	switch(build_step)
		if(1)
			if(istype(I, /obj/item/stack/material) && I.69et_material_name() ==69ATERIAL_STEEL)
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, SPAN_NOTICE("You add some69etal armor to the interior frame."))
					build_step = 2
					icon_state = "turret_frame2"
				else
					to_chat(user, SPAN_WARNIN69("You need two sheets of69etal to continue construction."))
				return

		if(3)
			if(istype(I, /obj/item/69un/ener69y)) //the 69un installation part

				if(isrobot(user))
					return
				if(!user.unE69uip(I))
					to_chat(user, SPAN_NOTICE("\the 69I69 is stuck to your hand, you cannot put it in \the 69src69"))
					return
				installation = I //We store the 69un for the turret to use
				installation.forceMove(src) //We physically store it inside of us until the construction is complete.
				to_chat(user, SPAN_NOTICE("You add 69I69 to the turret."))
				build_step = 4
				return

			//attack_hand() removes the 69un

		if(4)
			if(is_proximity_sensor(I))
				build_step = 5
				if(!user.unE69uip(I))
					to_chat(user, SPAN_NOTICE("\the 69I69 is stuck to your hand, you cannot put it in \the 69src69"))
					return
				to_chat(user, SPAN_NOTICE("You add the prox sensor to the turret."))
				69del(I)
				return

			//attack_hand() removes the prox sensor

		if(6)
			if(istype(I, /obj/item/stack/material) && I.69et_material_name() ==69ATERIAL_STEEL)
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, SPAN_NOTICE("You add some69etal armor to the exterior frame."))
					build_step = 7
				else
					to_chat(user, SPAN_WARNIN69("You need two sheets of69etal to continue construction."))
				return

	if(istype(I, /obj/item/pen))	//you can rename turrets like bots!
		var/t = sanitizeSafe(input(user, "Enter new turret name", name, finish_name) as text,69AX_NAME_LEN)
		if(!t)
			return
		if(!in_ran69e(src, usr) && loc != usr)
			return

		finish_name = t
		return

	..()


/obj/machinery/porta_turret_construct/attack_hand(mob/user)
	switch(build_step)
		if(4)
			if(!installation)
				return
			build_step = 3
			installation.forceMove(loc)
			installation = null
			to_chat(user, SPAN_NOTICE("You remove 69installation69 from the turret frame."))
		if(5)
			to_chat(user, SPAN_NOTICE("You remove the prox sensor from the turret frame."))
			new /obj/item/device/assembly/prox_sensor(loc)
			build_step = 4

/obj/machinery/porta_turret_construct/Destroy()
	69DEL_NULL(installation)
	.=..()

/obj/machinery/porta_turret_construct/attack_ai()
	return

/atom/movable/porta_turret_cover
	icon = 'icons/obj/turrets.dmi'


#undef TURRET_PRIORITY_TAR69ET
#undef TURRET_SECONDARY_TAR69ET
#undef TURRET_NOT_TAR69ET
