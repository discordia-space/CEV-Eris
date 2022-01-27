69LOBAL_LIST_EMPTY(wed69e_icon_cache)

/obj/machinery/door/airlock
	name = "Airlock"
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door_closed"
	power_channel = STATIC_ENVIRON

	explosion_resistance = 10
	maxhealth = 400

	var/aiControlDisabled = 0
	//If 1, AI control is disabled until the AI hacks back in and disables the lock.
	//If 2, the AI has bypassed the lock.
	//If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled a69ain the AI would have no trouble 69ettin69 back in.

	var/hackProof = 0 // if 1, this door can't be hacked by the AI
	var/electrified_until = 0			//World time when the door is no lon69er electrified. -1 if it is permanently electrified until someone fixes it.
	var/main_power_lost_until = 0	 	//World time when69ain power is restored.
	var/backup_power_lost_until = -1	//World time when backup power is restored.
	var/next_beep_at = 0				//World time when we69ay next beep due to doors bein69 blocked by69obs
	var/spawnPowerRestoreRunnin69 = 0

	var/locked = 0
	var/li69hts = 1 // bolt li69hts show by default
	var/aiDisabledIdScanner = 0
	var/aiHackin69 = 0
	var/obj/machinery/door/airlock/closeOther
	var/closeOtherId
	var/lockdownbyai = 0
	autoclose = 1
	var/assembly_type = /obj/structure/door_assembly
	var/mineral
	var/justzap = 0
	var/safe = 1
	normalspeed = 1
	var/obj/item/electronics/airlock/electronics
	var/hasShocked = 0 //Prevents69ultiple shocks from happenin69
	var/secured_wires = 0
	var/datum/wires/airlock/wires
	var/open_sound_powered = 'sound/machines/airlock_open.o6969'
	var/close_sound = 'sound/machines/airlock_close.o6969'
	var/open_sound_unpowered = 'sound/machines/airlock_creakin69.o6969'
	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver
	var/obj/item/wed69ed_item

	dama69e_smoke = TRUE


/obj/machinery/door/airlock/attack_69eneric(var/mob/user,69ar/dama69e)
	if(stat & (BROKEN|NOPOWER))
		if(dama69e >= 10)
			if(src.density)
				visible_messa69e(SPAN_DAN69ER("\The 69user69 forces \the 69src69 open!"))
				open(1)
			else
				visible_messa69e(SPAN_DAN69ER("\The 69user69 forces \the 69src69 closed!"))
				close(1)
		else
			visible_messa69e("<span class='notice'>\The 69user69 strains fruitlessly to force \the 69src69 69density ? "open" : "closed"69.</span>")
		return
	..()

/obj/machinery/door/airlock/69et_material()
	if(mineral)
		return 69et_material_by_name(mineral)
	return 69et_material_by_name(MATERIAL_STEEL)

/obj/machinery/door/airlock/command
	name = "Airlock"
	icon = 'icons/obj/doors/Doorcom.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_com

/obj/machinery/door/airlock/security
	name = "Airlock"
	icon = 'icons/obj/doors/Doorsec.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	resistance = RESISTANCE_ARMOURED

/obj/machinery/door/airlock/en69ineerin69
	name = "Airlock"
	icon = 'icons/obj/doors/Dooren69.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_en69

/obj/machinery/door/airlock/medical
	name = "Airlock"
	icon = 'icons/obj/doors/Doormed.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_med

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	icon = 'icons/obj/doors/Doormaint.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_mai

/obj/machinery/door/airlock/external
	name = "External Airlock"
	icon = 'icons/obj/doors/Doorext.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	opacity = 0
	69lass = 1

/obj/machinery/door/airlock/69lass
	name = "69lass Airlock"
	icon = 'icons/obj/doors/Door69lass.dmi'
	hitsound = 'sound/effects/69lasshit.o6969'
	maxhealth = 300
	resistance = RESISTANCE_AVERA69E
	explosion_resistance = 5
	opacity = 0
	69lass = 1

/obj/machinery/door/airlock/centcom
	name = "Airlock"
	icon = 'icons/obj/doors/Doorele.dmi'
	opacity = 1

/obj/machinery/door/airlock/vault
	name = "Vault"
	icon = 'icons/obj/doors/vault.dmi'
	explosion_resistance = RESISTANCE_ARMOURED
	resistance = RESISTANCE_VAULT
	opacity = 1
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hi69hsecurity //Until somebody69akes better sprites.

/obj/machinery/door/airlock/vault/bolted
	icon_state = "door_locked"
	locked = 1

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	icon = 'icons/obj/doors/Doorfreezer.dmi'
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_fre

/obj/machinery/door/airlock/hatch
	name = "Airti69ht Hatch"
	icon = 'icons/obj/doors/Doorhatchele.dmi'
	explosion_resistance = RESISTANCE_ARMOURED
	resistance = RESISTANCE_ARMOURED
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch

/obj/machinery/door/airlock/maintenance_hatch
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorhatchmaint2.dmi'
	explosion_resistance = RESISTANCE_ARMOURED
	resistance = RESISTANCE_ARMOURED
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_mhatch

/obj/machinery/door/airlock/69lass_command
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorcom69lass.dmi'
	hitsound = 'sound/effects/69lasshit.o6969'
	maxhealth = 300
	resistance = RESISTANCE_AVERA69E
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	69lass = 1

/obj/machinery/door/airlock/69lass_en69ineerin69
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Dooren6969lass.dmi'
	hitsound = 'sound/effects/69lasshit.o6969'
	maxhealth = 300
	resistance = RESISTANCE_AVERA69E
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_en69
	69lass = 1

/obj/machinery/door/airlock/69lass_security
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorsec69lass.dmi'
	hitsound = 'sound/effects/69lasshit.o6969'
	maxhealth = 300
	resistance = RESISTANCE_AVERA69E
	bullet_resistance = RESISTANCE_AVERA69E
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	69lass = 1

/obj/machinery/door/airlock/69lass_medical
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormed69lass.dmi'
	hitsound = 'sound/effects/69lasshit.o6969'
	maxhealth = 300
	resistance = RESISTANCE_AVERA69E
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	69lass = 1

/obj/machinery/door/airlock/minin69
	name = "Minin69 Airlock"
	icon = 'icons/obj/doors/Doorminin69.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_min

/obj/machinery/door/airlock/atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Dooratmo.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo

/obj/machinery/door/airlock/research
	name = "Airlock"
	icon = 'icons/obj/doors/Doorresearch.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_research

/obj/machinery/door/airlock/69lass_research
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorresearch69lass.dmi'
	hitsound = 'sound/effects/69lasshit.o6969'
	maxhealth = 300
	resistance = RESISTANCE_AVERA69E
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	69lass = 1
	heat_proof = 1

/obj/machinery/door/airlock/69lass_minin69
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorminin6969lass.dmi'
	hitsound = 'sound/effects/69lasshit.o6969'
	maxhealth = 300
	resistance = RESISTANCE_AVERA69E
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	69lass = 1

/obj/machinery/door/airlock/69lass_atmos
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Dooratmo69lass.dmi'
	hitsound = 'sound/effects/69lasshit.o6969'
	maxhealth = 300
	resistance = RESISTANCE_AVERA69E
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	69lass = 1

/* NEW AIRLOCKS BLOCK */

/obj/machinery/door/airlock/maintenance_car69o
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormaint_car69o.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_maint_car69o

/obj/machinery/door/airlock/maintenance_command
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormaint_command.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_maint_command

/obj/machinery/door/airlock/maintenance_en69ineerin69
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormaint_en69i.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_maint_en69i

/obj/machinery/door/airlock/maintenance_medical
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormaint_med.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_maint_med

/obj/machinery/door/airlock/maintenance_rnd
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormaint_rnd.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_maint_rnd

/obj/machinery/door/airlock/maintenance_security
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormaint_sec.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_maint_sec

/obj/machinery/door/airlock/maintenance_common
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormaint_common.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_maint_common

/obj/machinery/door/airlock/maintenance_interior
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormaint_int.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_maint_int

/* NEW AIRLOCKS BLOCK END */

/obj/machinery/door/airlock/69old
	name = "69old Airlock"
	icon = 'icons/obj/doors/Door69old.dmi'
	mineral =69ATERIAL_69OLD

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	icon = 'icons/obj/doors/Doorsilver.dmi'
	mineral =69ATERIAL_SILVER

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	icon = 'icons/obj/doors/Doordiamond.dmi'
	mineral =69ATERIAL_DIAMOND
	resistance = RESISTANCE_UNBREAKABLE
	bullet_resistance = RESISTANCE_VAULT

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	icon = 'icons/obj/doors/Dooruranium.dmi'
	mineral =69ATERIAL_URANIUM
	var/last_event = 0

/obj/machinery/door/airlock/Process()
	return PROCESS_KILL

/obj/machinery/door/airlock/uranium/Process()
	if(world.time > last_event+20)
		if(prob(50))
			radiate()
		last_event = world.time
	..()

/obj/machinery/door/airlock/uranium/proc/radiate()
	for(var/mob/livin69/L in ran69e (3,src))
		L.apply_effect(15,IRRADIATE,0)
	return

/obj/machinery/door/airlock/plasma
	name = "Plasma Airlock"
	desc = "No way this can end badly."
	icon = 'icons/obj/doors/Doorplasma.dmi'
	mineral = "plasma"

/obj/machinery/door/airlock/plasma/fire_act(datum/69as_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/obj/machinery/door/airlock/plasma/proc/i69nite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/obj/machinery/door/airlock/plasma/proc/PlasmaBurn(temperature)
	for(var/turf/simulated/floor/tar69et_tile in RAN69E_TURFS(2,loc))
		tar69et_tile.assume_69as("plasma", 35, 400+T0C)
		spawn (0) tar69et_tile.hotspot_expose(temperature, 400)
	for(var/turf/simulated/wall/W in RAN69E_TURFS(3,src))
		W.burn((temperature/4))//Added so that you can't set off a69assive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/plasma/D in ran69e(3,src))
		D.i69nite(temperature/4)
	new/obj/structure/door_assembly( src.loc )
	69del(src)

/obj/machinery/door/airlock/sandstone
	name = "Sandstone Airlock"
	icon = 'icons/obj/doors/Doorsand.dmi'
	mineral =69ATERIAL_SANDSTONE

/obj/machinery/door/airlock/science
	name = "Airlock"
	icon = 'icons/obj/doors/Doorsci.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_science

/obj/machinery/door/airlock/69lass_science
	name = "69lass Airlocks"
	icon = 'icons/obj/doors/Doorsci69lass.dmi'
	maxhealth = 300
	resistance = RESISTANCE_AVERA69E
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	69lass = 1

/obj/machinery/door/airlock/hi69hsecurity
	name = "Secure Airlock"
	icon = 'icons/obj/doors/hi69htechsecurity.dmi'
	explosion_resistance = 20
	resistance = RESISTANCE_ARMOURED
	bullet_resistance = RESISTANCE_ARMOURED
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hi69hsecurity

/*
About the new airlock wires panel:
*An airlock wire dialo69 can be accessed by the normal way or by usin69 wirecutters or a69ultitool on the door while the wire-panel is open.
This would show the followin69 wires, which you can either wirecut/mend or send a69ultitool pulse throu69h.
There are 9 wires.
*	one wire from the ID scanner.
		Sendin69 a pulse throu69h this flashes the red li69ht on the door (if the door has power).
		If you cut this wire, the door will stop reco69nizin6969alid IDs.
		(If the door has 0000 access, it still opens and closes, thou69h)
*	two wires for power.
		Sendin69 a pulse throu69h either one causes a breaker to trip,
		disablin69 the door for 10 seconds if backup power is connected,
		or 169inute if not (or until backup power comes back on, whichever is shorter).
		Cuttin69 either one disables the69ain door power, but unless backup power is also cut,
		the backup power re-powers the door in 10 seconds.
		While unpowered, the door69ay be open, but bolts-raisin69 will not work.
		Cuttin69 these wires69ay electrocute the user.
*	one wire for door bolts.
		Sendin69 a pulse throu69h this drops door bolts (whether the door is powered or not) or raises them (if it is).
		Cuttin69 this wire also drops the door bolts, and69endin69 it does not raise them. If the wire is cut, tryin69 to raise the door bolts will not work.
*	two wires for backup power.
		Sendin69 a pulse throu69h either one causes a breaker to trip,
		but this does not disable it unless69ain power is down too
		(in which case it is disabled for 169inute or however lon69 it takes69ain power to come back, whichever is shorter).
		Cuttin69 either one disables the backup door power (allowin69 it to be crowbarred open, but disablin69 bolts-raisin69), but69ay electocute the user.
*	one wire for openin69 the door.
		Sendin69 a pulse throu69h this while the door has power69akes it open the door if no access is re69uired.
*	one wire for AI control.
		Sendin69 a pulse throu69h this blocks AI control for a second or so (which is enou69h to see the AI control li69ht on the panel dialo69 69o off and back on a69ain).
		Cuttin69 this prevents the AI from controllin69 the door unless it has hacked the door throu69h the power connection (which takes about a69inute).
		If both69ain and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
*	one wire for electrifyin69 the door.
		Sendin69 a pulse throu69h this electrifies the door for 30 seconds.
		Cuttin69 this wire electrifies the door, so that the next person to touch the door without insulated 69loves 69ets electrocuted.
		(Currently it is also STAYIN69 electrified until someone69ends the wire)
*	one wire for controlin69 door safetys.
		When active, door does not close on someone.  When cut, door will ruin someone's shit.
		When pulsed, door will immedately ruin someone's shit.
*	one wire for controllin69 door speed.
		When active, dor closes at normal rate.  When cut, door does not close69anually.
		When pulsed, door attempts to close every tick.
*/



/obj/machinery/door/airlock/bumpopen(mob/livin69/user) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(usr))
		if(src.isElectrified())
			if(!src.justzap)
				if(src.shock(user, 100))
					src.justzap = 1
					spawn (10)
						src.justzap = 0
					return FALSE
			else /*if(src.justzap)*/
				return FALSE
		else if(prob(10) && src.operatin69 == 0)
			var/mob/livin69/carbon/C = user
			if(istype(C) && C.hallucination_power > 25)
				to_chat(user, "<span class='dan69er'>You feel a powerful shock course throu69h your body!</span>")
				user.adjustHalLoss(10)
				user.Stun(10)
				return FALSE
	..()

/obj/machinery/door/airlock/proc/isElectrified()
	if(src.electrified_until != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/isWireCut(var/wireIndex)
	// You can find the wires in the datum folder.
	return wires.IsIndexCut(wireIndex)

/obj/machinery/door/airlock/proc/canAIControl()
	return ((src.aiControlDisabled!=1) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/canAIHack()
	return ((src.aiControlDisabled==1) && (!hackProof) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	if (stat & (NOPOWER|BROKEN))
		return 0
	return (src.main_power_lost_until==0 || src.backup_power_lost_until==0)

/obj/machinery/door/airlock/re69uiresID()
	return !(src.isWireCut(AIRLOCK_WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerLoss()
	if(stat & (NOPOWER|BROKEN))
		return 1
	if(mainPowerCablesCut() && backupPowerCablesCut())
		return 1
	return 0

/obj/machinery/door/airlock/proc/mainPowerCablesCut()
	return src.isWireCut(AIRLOCK_WIRE_MAIN_POWER1) || src.isWireCut(AIRLOCK_WIRE_MAIN_POWER2)

/obj/machinery/door/airlock/proc/backupPowerCablesCut()
	return src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER1) || src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER2)

/obj/machinery/door/airlock/proc/loseMainPower()
	main_power_lost_until =69ainPowerCablesCut() ? -1 : SecondsToTicks(60)
	if(main_power_lost_until > 0)
		addtimer(CALLBACK(src, .proc/re69ainMainPower),69ain_power_lost_until)

	// If backup power is permanently disabled then activate in 10 seconds if possible, otherwise it's already enabled or a timer is already runnin69
	if(backup_power_lost_until == -1 && !backupPowerCablesCut())
		backup_power_lost_until = SecondsToTicks(10)
		addtimer(CALLBACK(src, .proc/re69ainBackupPower), backup_power_lost_until)

	// Disable electricity if re69uired
	if(electrified_until && isAllPowerLoss())
		electrify(0)

/obj/machinery/door/airlock/proc/loseBackupPower()
	backup_power_lost_until = backupPowerCablesCut() ? -1 : SecondsToTicks(60)
	if(backup_power_lost_until > 0)
		addtimer(CALLBACK(src, .proc/re69ainBackupPower), backup_power_lost_until)

	// Disable electricity if re69uired
	if(electrified_until && isAllPowerLoss())
		electrify(0)

/obj/machinery/door/airlock/proc/re69ainMainPower()
	if(!mainPowerCablesCut())
		main_power_lost_until = 0
		// If backup power is currently active then disable, otherwise let it count down and disable itself later
		if(!backup_power_lost_until)
			backup_power_lost_until = -1

/obj/machinery/door/airlock/proc/re69ainBackupPower()
	if(!backupPowerCablesCut())
		// Restore backup power only if69ain power is offline, otherwise permanently disable
		backup_power_lost_until =69ain_power_lost_until == 0 ? -1 : 0

/obj/machinery/door/airlock/proc/electrify(var/duration,69ar/feedback = 0)
	var/messa69e = ""
	if(isWireCut(AIRLOCK_WIRE_ELECTRIFY) && arePowerSystemsOn())
		messa69e = text("The electrification wire is cut - Door permanently electrified.")
		electrified_until = -1
	else if(duration && !arePowerSystemsOn())
		messa69e = text("The door is unpowered - Cannot electrify the door.")
		electrified_until = 0
	else if(!duration && electrified_until != 0)
		messa69e = "The door is now un-electrified."
		electrified_until = 0
	else if(duration)	//electrify door for the 69iven duration seconds
		if(usr)
			shockedby += text("\6969time_stamp()69\69 - 69usr69(ckey:69usr.ckey69)")
			usr.attack_lo69 += text("\6969time_stamp()69\69 <font color='red'>Electrified the 69name69 at 69x69 69y69 69z69</font>")
		else
			shockedby += text("\6969time_stamp()69\69 - EMP)")
		messa69e = "The door is now electrified 69duration == -1 ? "permanently" : "for 69duration69 second\s"69."
		electrified_until = duration == -1 ? -1 : SecondsToTicks(duration)
		if(electrified_until > 0)
			addtimer(CALLBACK(src, .proc/electrify), electrified_until)

	if(feedback &&69essa69e)
		to_chat(usr,69essa69e)

/obj/machinery/door/airlock/proc/set_idscan(var/activate,69ar/feedback = 0)
	var/messa69e = ""
	if(isWireCut(AIRLOCK_WIRE_IDSCAN))
		messa69e = "The IdScan wire is cut - IdScan feature permanently disabled."
	else if(activate && aiDisabledIdScanner)
		aiDisabledIdScanner = 0
		messa69e = "IdScan feature has been enabled."
	else if(!activate && !aiDisabledIdScanner)
		aiDisabledIdScanner = 1
		messa69e = "IdScan feature has been disabled."

	if(feedback &&69essa69e)
		to_chat(usr,69essa69e)

/obj/machinery/door/airlock/proc/set_safeties(var/activate,69ar/feedback = 0)
	var/messa69e = ""
	// Safeties!  We don't need no stinkin69 safeties!
	if (isWireCut(AIRLOCK_WIRE_SAFETY))
		messa69e = text("The safety wire is cut - Cannot enable safeties.")
	else if (!activate && safe)
		safe = 0
	else if (activate && !safe)
		safe = 1

	if(feedback &&69essa69e)
		to_chat(usr,69essa69e)

// shock user with probability prb (if all connections & power are workin69)
// returns 1 if shocked, 0 otherwise
// The precedin69 comment was borrowed from the 69rille's shock script
/obj/machinery/door/airlock/shock(mob/user, prb)
	if(!arePowerSystemsOn())
		return 0
	if(hasShocked)
		return 0	//Already shocked someone recently?
	if(..())
		hasShocked = 1
		sleep(10)
		hasShocked = 0
		return 1
	else
		return 0

/obj/machinery/door/airlock/proc/force_wed69e_item(obj/item/tool/T)
	T.forceMove(src)
	wed69ed_item = T
	update_icon()
	verbs -= /obj/machinery/door/airlock/proc/try_wed69e_item
	verbs += /obj/machinery/door/airlock/proc/take_out_wed69ed_item

/obj/machinery/door/airlock/proc/try_wed69e_item()
	set name = "Wed69e item"
	set cate69ory = "Object"
	set src in69iew(1)

	if(!islivin69(usr))
		to_chat(usr, SPAN_WARNIN69("You can't do this."))
		return
	var/obj/item/tool/T = usr.69et_active_hand()
	if(istype(T) && T.w_class >= ITEM_SIZE_NORMAL) // We do the checks before proc call, because see "proc overhead".
		if(!density)
			usr.drop_item()
			force_wed69e_item(T)
			to_chat(usr, SPAN_NOTICE("You wed69e 69T69 into 69src69."))
		else
			to_chat(usr, SPAN_NOTICE("69T69 can't be wed69ed into 69src69, while 69src69 is closed."))

/obj/machinery/door/airlock/proc/take_out_wed69ed_item()
	set name = "Remove Blocka69e"
	set cate69ory = "Object"
	set src in69iew(1)

	if(!islivin69(usr) || !CanUseTopic(usr))
		return

	if(wed69ed_item)
		wed69ed_item.forceMove(drop_location())
		if(usr)
			usr.put_in_hands(wed69ed_item)
			to_chat(usr, SPAN_NOTICE("You took 69wed69ed_item69 out of 69src69."))
		wed69ed_item = null
		verbs -= /obj/machinery/door/airlock/proc/take_out_wed69ed_item
		verbs += /obj/machinery/door/airlock/proc/try_wed69e_item
		update_icon()

/obj/machinery/door/airlock/AltClick(mob/user)
	if(Adjacent(user))
		wed69ed_item ? take_out_wed69ed_item() : try_wed69e_item()

/obj/machinery/door/airlock/MouseDrop(obj/over_object)
	if(ishuman(usr) && usr == over_object && !usr.incapacitated() && Adjacent(usr))
		take_out_wed69ed_item(usr)
		return
	return ..()

/obj/machinery/door/airlock/examine(mob/user)
	..()
	if(wed69ed_item)
		to_chat(user, "You can see \icon69wed69ed_item69 69wed69ed_item69 wed69ed into it.")

/obj/machinery/door/airlock/proc/69enerate_wed69e_overlay()
	var/cache_strin69 = "69wed69ed_item.icon69||69wed69ed_item.icon_state69||69wed69ed_item.overlays.len69||69wed69ed_item.underlays.len69"

	if(!69LOB.wed69e_icon_cache69cache_strin6969)
		var/icon/I = 69etFlatIcon(wed69ed_item, SOUTH, always_use_defdir = TRUE)

		// #define COOL_LOOKIN69_SHIFT_USIN69_CROWBAR_RI69HT 14, #define COOL_LOOKIN69_SHIFT_USIN69_CROWBAR_DOWN 6 - throw a rock at69e if this looks less69a69ic.
		I.Shift(SOUTH, 6) // These numbers I 69ot by stickin69 the crowbar in and lookin69 what will look 69ood.
		I.Shift(EAST, 14)
		I.Turn(45)

		69LOB.wed69e_icon_cache69cache_strin6969 = I
		underlays += I
	else
		underlays += 69LOB.wed69e_icon_cache69cache_strin6969

/obj/machinery/door/airlock/update_icon()
	set_li69ht(0)
	if(overlays.len)
		cut_overlays()
	if(underlays.len)
		underlays.Cut()
	if(density)
		if(locked && li69hts && arePowerSystemsOn())
			icon_state = "door_locked"
			set_li69ht(1.5, 0.5, COLOR_RED_LI69HT)
		else
			icon_state = "door_closed"
		if(p_open || welded)
			overlays = list()
			if(p_open)
				overlays += ima69e(icon, "panel_open")
			if (!(stat & NOPOWER))
				if(stat & BROKEN)
					overlays += ima69e(icon, "sparks_broken")
				else if (health <69axhealth * 3/4)
					overlays += ima69e(icon, "sparks_dama69ed")
			if(welded)
				overlays += ima69e(icon, "welded")
		else if (health <69axhealth * 3/4 && !(stat & NOPOWER))
			overlays += ima69e(icon, "sparks_dama69ed")
	else
		icon_state = "door_open"
		if((stat & BROKEN) && !(stat & NOPOWER))
			overlays += ima69e(icon, "sparks_open")
	if(wed69ed_item)
		69enerate_wed69e_overlay()

/obj/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("openin69")
			if(overlays.len)
				overlays.Cut()
			if(p_open)
				flick("o_door_openin69", src)  //can not use flick due to BYOND bu69 updatin69 overlays ri69ht before flickin69
				update_icon()
			else
				flick("door_openin69", src)//69stat ? "_stat":69
				update_icon()
		if("closin69")
			if(overlays.len)
				overlays.Cut()
			if(p_open)
				flick("o_door_closin69", src)
				update_icon()
			else
				flick("door_closin69", src)
				update_icon()
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && src.arePowerSystemsOn())
				flick("door_deny", src)
				playsound(src.loc, 'sound/machines/Custom_deny.o6969', 50, 1, -2)
	return

/obj/machinery/door/airlock/attack_ai(mob/user as69ob)
	if(!isblitzshell(user))
		ui_interact(user)

/obj/machinery/door/airlock/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS,69ar/datum/topic_state/state = 69LOB.default_state)
	var/data69069

	data69"main_power_loss"69		= round(main_power_lost_until 	> 0 ?69ax(main_power_lost_until - world.time,	0) / 10 :69ain_power_lost_until,	1)
	data69"backup_power_loss"69	= round(backup_power_lost_until	> 0 ?69ax(backup_power_lost_until - world.time,	0) / 10 : backup_power_lost_until,	1)
	data69"electrified"69 		= round(electrified_until		> 0 ?69ax(electrified_until - world.time, 	0) / 10 	: electrified_until,		1)
	data69"open"69 = !density

	var/commands69069
	commands69++commands.len69 = list(
		"name" = "IdScan",
		"command" = "idscan",
		"active" = !aiDisabledIdScanner,
		"enabled" = "Enabled",
		"disabled" = "Disable",
		"dan69er" = 0,
		"act" = 1
	)
	commands69++commands.len69 = list(
		"name" = "Bolts",
		"command" = "bolts",
		"active" = !locked,
		"enabled" = "Raised ",
		"disabled" = "Dropped",
		"dan69er" = 0,
		"act" = 0
	)
	commands69++commands.len69 = list(
		"name" = "Bolt Li69hts",
		"command" = "li69hts",
		"active" = li69hts,
		"enabled" = "Enabled",
		"disabled" = "Disable",
		"dan69er" = 0,
		"act" = 1
	)
	commands69++commands.len69 = list(
		"name" = "Safeties",
		"command"= "safeties",
		"active" = safe,
		"enabled" = "Nominal",
		"disabled" = "Overridden",
		"dan69er" = 1,
		"act" = 0
	)
	commands69++commands.len69 = list(
		"name" = "Timin69",
		"command" = "timin69",
		"active" = normalspeed,
		"enabled" = "Nominal",
		"disabled" = "Overridden",
		"dan69er" = 1,
		"act" = 0
	)
	commands69++commands.len69 = list(
		"name" = "Door State",
		"command" = "open",
		"active" = density,
		"enabled" = "Closed",
		"disabled" = "Opened",
		"dan69er" = 0,
		"act" = 0
	)

	data69"commands"69 = commands

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "door_control.tmpl", "Door Controls", 450, 350, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/door/airlock/proc/hack(mob/user as69ob)
	if(aiHackin69 == 0)
		aiHackin69 = 1
		spawn(20)
			//TODO:69ake this take a69inute
			to_chat(user, "Airlock AI control has been blocked. Be69innin69 fault-detection.")
			sleep(50)
			if(canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				aiHackin69 = 0
				return
			else if(!canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				aiHackin69 = 0
				return
			to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
			sleep(20)
			to_chat(user, "Attemptin69 to hack into airlock. This69ay take some time.")
			sleep(200)
			if(canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				aiHackin69 = 0
				return
			else if(!canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				aiHackin69 = 0
				return
			to_chat(user, "Upload access confirmed. Loadin69 control pro69ram into airlock software.")
			sleep(170)
			if(canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				aiHackin69 = 0
				return
			else if(!canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				aiHackin69 = 0
				return
			to_chat(user, "Transfer complete. Forcin69 airlock to execute pro69ram.")
			sleep(50)
			//disable blocked control
			aiControlDisabled = 2
			to_chat(user, "Receivin69 control information from airlock.")
			sleep(10)
			//brin69 up airlock dialo69
			aiHackin69 = 0
			if(user)
				attack_ai(user)

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	if(isElectrified())
		if(istype(mover, /obj/item))
			var/obj/item/i =69over
			if(i.matter && (MATERIAL_STEEL in i.matter) && i.matter69MATERIAL_STEEL69 > 0)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
	return ..()

/obj/machinery/door/airlock/attack_hand(mob/user as69ob)
	if(!issilicon(user) && isElectrified() && shock(user, 100))
		return

	// Why did they comment this out this is comedy 69old
	if(ishuman(user) && prob(40) && density)
		var/mob/livin69/carbon/human/H = user
		if(H.69etBrainLoss() >= 60)
			playsound(loc, 'sound/effects/ban69.o6969', 25, 1)
			if(!istype(H.head, /obj/item/clothin69/head/armor/helmet))
				visible_messa69e(SPAN_WARNIN69("69user69 headbutts the airlock."))
				var/obj/item/or69an/external/affectin69 = H.69et_or69an(BP_HEAD)
				H.Weaken(5)
				if(affectin69.take_dama69e(10, 0))
					H.UpdateDama69eIcon()
			else
				visible_messa69e(SPAN_WARNIN69("69user69 headbutts the airlock. 69ood thin69 they're wearin69 a helmet."))
			return


	if(user.a_intent == I_69RAB && wed69ed_item && !user.69et_active_hand())
		take_out_wed69ed_item(user)
		return

	if(p_open)
		user.set_machine(src)
		wires.Interact(user)
	else
		..(user)
	return

/obj/machinery/door/airlock/CanUseTopic(var/mob/user)
	if(operatin69 < 0) //ema6969ed
		to_chat(user, SPAN_WARNIN69("Unable to interface: Internal error."))
		return STATUS_CLOSE
	if(issilicon(user) && !canAIControl())
		if(canAIHack(user))
			hack(user)
		else
			if (isAllPowerLoss()) //don't really like how this 69ets checked a second time, but not sure how else to do it.
				to_chat(user, SPAN_WARNIN69("Unable to interface: Connection timed out."))
			else
				to_chat(user, SPAN_WARNIN69("Unable to interface: Connection refused."))
		return STATUS_CLOSE

	return ..()

/obj/machinery/door/airlock/Topic(href, href_list)
	if(..())
		return 1

	var/activate = text2num(href_list69"activate"69)
	switch (href_list69"command"69)
		if("idscan")
			set_idscan(activate, 1)
		if("main_power")
			if(!main_power_lost_until)
				loseMainPower()
		if("backup_power")
			if(!backup_power_lost_until)
				loseBackupPower()
		if("bolts")
			if(isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
				to_chat(usr, "The door bolt control wire is cut - Door bolts permanently dropped.")
			else if(activate && lock())
				to_chat(usr, "The door bolts have been dropped.")
			else if(!activate && unlock())
				to_chat(usr, "The door bolts have been raised.")
		if("electrify_temporary")
			electrify(30 * activate, 1)
		if("electrify_permanently")
			electrify(-1 * activate, 1)
		if("open")
			if(welded)
				to_chat(usr, text("The airlock has been welded shut!"))
			else if(locked)
				to_chat(usr, text("The door bolts are down!"))
			else if(activate && density)
				open()
			else if(!activate && !density)
				close()
		if("safeties")
			set_safeties(!activate, 1)
		if("timin69")
			// Door speed control
			if(isWireCut(AIRLOCK_WIRE_SPEED))
				to_chat(usr, text("The timin69 wire is cut - Cannot alter timin69."))
			else if (activate && normalspeed)
				normalspeed = 0
			else if (!activate && !normalspeed)
				normalspeed = 1
		if("li69hts")
			// Bolt li69hts
			if(isWireCut(AIRLOCK_WIRE_LI69HT))
				to_chat(usr, "The bolt li69hts wire is cut - The door bolt li69hts are permanently disabled.")
			else if (!activate && li69hts)
				li69hts = 0
				to_chat(usr, "The door bolt li69hts have been disabled.")
			else if (activate && !li69hts)
				li69hts = 1
				to_chat(usr, "The door bolt li69hts have been enabled.")

	update_icon()
	return 1

/obj/machinery/door/airlock/attackby(obj/item/I,69ob/user)
	if(!issilicon(usr))
		if(isElectrified())
			if(shock(user, 75))
				return
	if(istype(I, /obj/item/taperoll))
		return
	add_fin69erprint(user)

	//Harm intent overrides other actions
	if(density && user.a_intent == I_HURT && !I.69etIdCard())
		hit(user, I)
		return

	var/tool_type = I.69et_tool_type(user, list(69UALITY_PRYIN69, 69UALITY_SCREW_DRIVIN69, 69UALITY_WELDIN69, p_open ? 69UALITY_PULSIN69 : null), src)
	switch(tool_type)
		if(69UALITY_PRYIN69)
			if(!repairin69)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY,  re69uired_stat = list(STAT_MEC, STAT_ROB)))
					if(p_open && (operatin69 < 0 || (!operatin69 && welded && !arePowerSystemsOn() && density && (!locked || (stat & BROKEN)))) )
						to_chat(user, SPAN_NOTICE("You removed the airlock electronics!"))

						var/obj/structure/door_assembly/da = new assembly_type(loc)
						if (istype(da, /obj/structure/door_assembly/multi_tile))
							da.set_dir(dir)

		 				da.anchored = TRUE
						if(mineral)
							da.69lass =69ineral
						else if(69lass && !da.69lass)
							da.69lass = 1
						da.state = 1
						da.created_name = name
						da.update_state()

						if(operatin69 == -1 || (stat & BROKEN))
							new /obj/item/electronics/circuitboard/broken(loc)
							operatin69 = 0
						else
							if (!electronics) create_electronics()

							electronics.loc = loc
							electronics = null

						69del(src)
						return
					else if(arePowerSystemsOn())
						to_chat(user, SPAN_NOTICE("The airlock's69otors resist your efforts to force it."))
					else if(locked)
						to_chat(user, SPAN_NOTICE("The airlock's bolts prevent it from bein69 forced."))
					else
						if(density)
							spawn(0)	open(I)
						else
							spawn(0)	close(I)
			else
				..()
			return

		if(69UALITY_SCREW_DRIVIN69)
			var/used_sound = p_open ? 'sound/machines/Custom_screwdriveropen.o6969' :  'sound/machines/Custom_screwdriverclose.o6969'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
				if (p_open)
					if (stat & BROKEN)
						to_chat(usr, SPAN_WARNIN69("The panel is broken and cannot be closed."))
					else
						p_open = 0
				else
					p_open = 1
				update_icon()
			return

		if(69UALITY_WELDIN69)
			if(!repairin69 && !(operatin69 > 0) && density)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					if(!welded)
						welded = 1
					else
						welded = null
					update_icon()
			else
				..()
			return


		if(ABORT_CHECK)
			return

	if(istool(I))
		return attack_hand(user)
	else if(istype(I, /obj/item/device/assembly/si69naler))
		return attack_hand(user)
	else if(istype(I, /obj/item/pai_cable))	// -- TLE
		var/obj/item/pai_cable/cable = I
		cable.plu69in(src, user)

	else
		..()
	return

/obj/machinery/door/airlock/plasma/attackby(C as obj,69ob/user)
	if(C)
		i69nite(is_hot(C))
	..()

/obj/machinery/door/airlock/set_broken()
	p_open = 1
	stat |= BROKEN

	//If the door has been69iolently smashed open
	if (health <= 0)
		visible_messa69e("<span class = 'warnin69'>\The 69name69 breaks open!</span>")
		unlock() //Then it is open
		open(TRUE)
	else if (secured_wires)
		lock()

	for (var/mob/O in69iewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_messa69e("69name69's control panel bursts open, sparks spewin69 out!")

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()

	update_icon()
	return

/obj/machinery/door/airlock/open(forced=0)
	if(!can_open(forced))
		return 0
	use_power(360)	//360 W seems69uch69ore appropriate for an actuator69ovin69 an industrial door capable of crushin69 people

	//if the door is unpowered then it doesn't69ake sense to hear the woosh of a pneumatic actuator
	if(arePowerSystemsOn())
		playsound(loc, open_sound_powered, 70, 1, -2)
	else
		var/obj/item/tool/T = forced
		if (istype(T) && T.item_fla69s & SILENT)
			playsound(loc, open_sound_unpowered, 3, 1, -5) //Silenced tools can force open airlocks silently
		else if (istype(T) && T.item_fla69s & LOUD)
			playsound(loc, open_sound_unpowered, 500, 1, 10) //Loud tools can force open airlocks LOUDLY
		else
			playsound(loc, open_sound_unpowered, 70, 1, -1)

	var/obj/item/tool/T = forced
	if (istype(T) && T.item_fla69s & HONKIN69)
		playsound(loc, WORKSOUND_HONK, 70, 1, -2)

	if(closeOther != null && istype(closeOther, /obj/machinery/door/airlock/) && !closeOther.density)
		closeOther.close()
	return ..()

/obj/machinery/door/airlock/can_open(forced=0)
	if(!forced && (!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR)) || locked || welded)
		return FALSE

	return ..()

/obj/machinery/door/airlock/can_close(forced=0)
	if(locked || welded)
		return FALSE

	if(wed69ed_item)
		shake_animation(12)
		wed69ed_item.airlock_crush(DOOR_CRUSH_DAMA69E)
		return FALSE

	if(!forced && (!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR)))
		return FALSE

	return ..()

/atom/movable/proc/blocks_airlock()
	return density

/obj/machinery/door/blocks_airlock()
	return FALSE

/obj/structure/window/blocks_airlock()
	return FALSE

/obj/machinery/mech_sensor/blocks_airlock()
	return FALSE

/mob/livin69/blocks_airlock()
	return TRUE

/mob/livin69/simple_animal/blocks_airlock() //Airlocks crush cockroahes and69ouses.
	return69ob_size >69OB_SMALL

/atom/movable/proc/airlock_crush(crush_dama69e)
	return FALSE

/obj/structure/window/airlock_crush(crush_dama69e)
	ex_act(2)//Smashin windows

/obj/machinery/portable_atmospherics/canister/airlock_crush(crush_dama69e)
	. = ..()
	health -= crush_dama69e
	healthcheck()

/obj/structure/closet/airlock_crush(var/crush_dama69e)
	..()
	dama69e(crush_dama69e)
	for(var/atom/movable/AM in src)
		AM.airlock_crush()
	return TRUE

/obj/item/tool/airlock_crush(crush_dama69e)
	. = ..()
	health += crush_dama69e * de69radation * (1 - 69et_tool_69uality(69UALITY_PRYIN69) * 0.01) * 0.4

/mob/livin69/airlock_crush(var/crush_dama69e)
	. = ..()

	dama69e_throu69h_armor(0.7 * crush_dama69e, BRUTE, BP_HEAD, ARMOR_MELEE)
	dama69e_throu69h_armor(0.7 * crush_dama69e, BRUTE, BP_CHEST, ARMOR_MELEE)
	dama69e_throu69h_armor(0.5 * crush_dama69e, BRUTE, BP_L_LE69, ARMOR_MELEE)
	dama69e_throu69h_armor(0.5 * crush_dama69e, BRUTE, BP_R_LE69, ARMOR_MELEE)
	dama69e_throu69h_armor(0.5 * crush_dama69e, BRUTE, BP_L_ARM, ARMOR_MELEE)
	dama69e_throu69h_armor(0.5 * crush_dama69e, BRUTE, BP_R_ARM, ARMOR_MELEE)

	SetWeakened(5)
	var/turf/T = 69et_turf(src)
	T.add_blood(src)

/mob/livin69/carbon/airlock_crush(var/crush_dama69e)
	. = ..()
	if (!(species && (species.fla69s & NO_PAIN)))
		emote("scream")

/mob/livin69/silicon/robot/airlock_crush(var/crush_dama69e)
	adjustBruteLoss(crush_dama69e)
	return 0

/obj/machinery/door/airlock/close(var/forced=0)
	if(!can_close(forced))
		return 0

	if(safe)
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				if(AM.blocks_airlock())
					if(autoclose && tryin69ToLock)
						addtimer(CALLBACK(src, .proc/close), 30 SECONDS)
					if(world.time > next_beep_at)
						playsound(loc, 'sound/machines/buzz-two.o6969', 30, 1, -1)
						next_beep_at = world.time + SecondsToTicks(10)
					return
				if(istool(AM))
					var/obj/item/tool/T = AM
					if(T.w_class >= ITEM_SIZE_NORMAL)
						operatin69 = TRUE
						density = TRUE
						do_animate("closin69")
						sleep(7)
						force_wed69e_item(AM)
						playsound(loc, 'sound/machines/airlock_creakin69.o6969', 75, 1)
						shake_animation(12)
						sleep(7)
						playsound(loc, 'sound/machines/buzz-two.o6969', 30, 1, -1)
						density = FALSE
						do_animate("openin69")
						operatin69 = FALSE
						return

	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(DOOR_CRUSH_DAMA69E))
				take_dama69e(DOOR_CRUSH_DAMA69E)

	use_power(360)	//360 W seems69uch69ore appropriate for an actuator69ovin69 an industrial door capable of crushin69 people
	tryin69ToLock = FALSE
	if(arePowerSystemsOn())
		playsound(src.loc, close_sound, 70, 1, -2)
	else
		var/obj/item/tool/T = forced
		if (istype(T) && T.item_fla69s & SILENT)
			playsound(src.loc, open_sound_unpowered, 3, 1, -5) //Silenced tools can force airlocks silently
		else if (istype(T) && T.item_fla69s & LOUD)
			playsound(src.loc, open_sound_unpowered, 500, 1, 10) //Loud tools can force open airlocks LOUDLY
		else
			playsound(src.loc, open_sound_unpowered, 70, 1, -2)

	var/obj/item/tool/T = forced
	if (istype(T) && T.item_fla69s & HONKIN69)
		playsound(src.loc, WORKSOUND_HONK, 70, 1, -2)

	..()

/obj/machinery/door/airlock/proc/lock(var/forced=0)
	if(locked)
		return 0

	if (operatin69 && !forced) return 0

	src.locked = 1
	playsound(src.loc, 'sound/machines/Custom_bolts.o6969', 40, 1, 5)
	for(var/mob/M in ran69e(1,src))
		M.show_messa69e("You hear a click from the bottom of the door.", 2)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/unlock(var/forced=0)
	if(!src.locked)
		return

	if (!forced)
		if(operatin69 || !src.arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_DOOR_BOLTS)) return

	src.locked = 0
	playsound(src.loc, 'sound/machines/Custom_boltsup.o6969', 40, 1, 5)
	for(var/mob/M in ran69e(1,src))
		M.show_messa69e("You hear a click from the bottom of the door.", 2)
	update_icon()
	return 1

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked)
		return 0
	return ..(M)

/obj/machinery/door/airlock/New(var/newloc,69ar/obj/structure/door_assembly/assembly=null)
	..()

	//if assembly is 69iven, create the new door from the assembly
	if (assembly && istype(assembly))
		assembly_type = assembly.type

		electronics = assembly.electronics
		electronics.loc = src

		//update the door's access to69atch the electronics'
		secured_wires = electronics.secure
		if(electronics.one_access)
			re69_access.Cut()
			re69_one_access = src.electronics.conf_access
		else
			re69_one_access.Cut()
			re69_access = src.electronics.conf_access

		//69et the name from the assembly
		if(assembly.created_name)
			name = assembly.created_name
		else
			name = "69istext(assembly.69lass) ? "69assembly.69lass69 airlock" : assembly.base_name69"

		//69et the dir from the assembly
		set_dir(assembly.dir)

	//wires
	if(isOnAdminLevel(newloc))
		secured_wires = 1
	if (secured_wires)
		wires = new/datum/wires/airlock/secure(src)
	else
		wires = new/datum/wires/airlock(src)

/obj/machinery/door/airlock/Initialize()
	if(src.closeOtherId != null)
		for (var/obj/machinery/door/airlock/A in world)
			if(A.closeOtherId == src.closeOtherId && A != src)
				src.closeOther = A
				break
	verbs += /obj/machinery/door/airlock/proc/try_wed69e_item
	. = ..()

/obj/machinery/door/airlock/Destroy()
	69del(wires)
	wires = null
	69del(wifi_receiver)
	wifi_receiver = null
	return ..()

//69ost doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/airlock/proc/create_electronics()
	//create new electronics
	if (secured_wires)
		src.electronics = new/obj/item/electronics/airlock/secure( src.loc )
	else
		src.electronics = new/obj/item/electronics/airlock( src.loc )

	//update the electronics to69atch the door's access
	if(!src.re69_access)
		src.check_access()
	if(src.re69_access.len)
		electronics.conf_access = src.re69_access
	else if (src.re69_one_access.len)
		electronics.conf_access = src.re69_one_access
		electronics.one_access = 1

/obj/machinery/door/airlock/emp_act(var/severity)
	if(prob(20/severity))
		spawn(0)
			open()
	if(prob(40/severity))
		var/duration = SecondsToTicks(30 / severity)
		if(electrified_until > -1 && (duration + world.time) > electrified_until)
			electrify(duration)
	..()

/obj/machinery/door/airlock/power_chan69e() //puttin69 this is obj/machinery/door itself69akes non-airlock doors turn invisible for some reason
	..()
	if(stat & NOPOWER)
		// If we lost power, disable electrification
		// Keepin69 door li69hts on, runs on internal battery or somethin69.
		electrified_until = 0
	update_icon()

/obj/machinery/door/airlock/proc/prison_open()
	if(arePowerSystemsOn())
		src.unlock()
		src.open()
		src.lock()
	return


//Override to check locked69ar
/obj/machinery/door/airlock/hit(var/mob/user,69ar/obj/item/I)
	var/obj/item/W = I
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*1.5)
	var/calc_dama69e = W.force*W.structure_dama69e_factor
	var/69uiet = FALSE
	if (istool(I))
		var/obj/item/tool/T = I
		69uiet = T.item_fla69s & SILENT

	if (locked)
		calc_dama69e *= 0.66
	calc_dama69e -= resistance
	user.do_attack_animation(src)
	if(calc_dama69e <= 0)
		user.visible_messa69e(SPAN_DAN69ER("\The 69user69 hits \the 69src69 with \the 69W69 with no69isible effect."))
		69uiet ? null : playsound(src.loc, hitsound, 20, 1)
	else
		user.visible_messa69e(SPAN_DAN69ER("\The 69user69 forcefully strikes \the 69src69 with \the 69W69!"))
		playsound(src.loc, hitsound, 69uiet? 3: calc_dama69e*2, 1, 3,69uiet?-5 :2)
		take_dama69e(W.force)


/obj/machinery/door/airlock/take_dama69e(var/dama69e)
	if (isnum(dama69e) && locked)
		dama69e *= 0.66 //The bolts reinforce the door, reducin69 dama69e taken

	return ..(dama69e)

