
#define69ITROGEN_RETARDATION_FACTOR 0.15	//Higher ==692 slows reaction69ore
#define THERMAL_RELEASE_MODIFIER 10000		//Higher ==69ore heat released during reaction
#define PLASMA_RELEASE_MODIFIER 1500		//Higher == less plasma released by reaction
#define OXYGEN_RELEASE_MODIFIER 15000		//Higher == less oxygen released at high temperature/power
#define REACTION_POWER_MODIFIER 1.1			//Higher ==69ore overall power

/*
	How to tweak the SM

	POWER_FACTOR		directly controls how69uch power the SM puts out at a given level of excitation (power69ar).69aking this lower69eans you have to work the SM harder to get the same amount of power.
	CRITICAL_TEMPERATURE	The temperature at which the SM starts taking damage.

	CHARGING_FACTOR		Controls how69uch emitter shots excite the SM.
	DAMAGE_RATE_LIMIT	Controls the69aximum rate at which the SM will take damage due to high temperatures.
*/

//This is the69ain parameter for tweaking SM balance, as it basically controls how the power69ariable relates to the rest of the game.
#define POWER_FACTOR 1
#define DECAY_FACTOR 700			//Affects how fast the supermatter power decays
#define CRITICAL_TEMPERATURE 5000	//K
#define CHARGING_FACTOR 0.05
#define DAMAGE_RATE_LIMIT 3			//damage rate cap at power = 300, scales linearly with power

//Controls how69uch power is sent to each collector in range, in relation to SM power
#define COLLECTOR_TRANSFER_FACTOR 0.5

//These would be what you would get at point blank, decreases with distance
#define DETONATION_RADS 200
#define DETONATION_HALLUCINATION 600


#define WARNING_DELAY 20			//seconds between warnings.

/obj/machinery/power/supermatter
	name = "Supermatter"
	desc = "A strangely translucent and iridescent crystal. \red You get headaches just from looking at it."
	icon = 'icons/obj/engine.dmi'
	icon_state = "darkmatter"
	density = TRUE
	anchored = FALSE
	light_range = 4

	var/gasefficency = 0.25

	var/base_icon_state = "darkmatter"

	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystaline hyperstructure returning to safe operating levels."
	var/safe_warned = 0
	var/public_alert = 0 //Stick to Engineering frequency except for big warnings when integrity bad
	var/warning_point = 100
	var/warning_alert = "Danger! Crystal hyperstructure instability!"
	var/emergency_point = 700
	var/emergency_alert = "CRYSTAL DELAMINATION IMMINENT."
	var/explosion_point = 1000

	light_color = "#8A8A00"
	var/warning_color = "#B8B800"
	var/emergency_color = "#D9D900"

	var/grav_pulling = 0
	// Time in ticks between delamination ('exploding') and exploding (as in the actual boom)
	var/pull_time = 300
	var/explosion_power = 6

	var/emergency_issued = 0

	// Time in 1/10th of seconds since the last sent warning
	var/lastwarning = 0

	// This stops spawning redundand explosions. Also incidentally69akes supermatter unexplodable if set to 1.
	var/exploded = 0

	var/power = 0
	var/oxygen = 0

	//Temporary69alues so that we can optimize this
	//How69uch the bullets damage should be69ultiplied by when it is added to the internal69ariables
	var/config_bullet_energy = 2
	//How69uch of the power is left after processing is finished?
//       69ar/config_power_reduction_per_tick = 0.5
	//How69uch hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.1

	var/obj/item/device/radio/radio

	var/debug = 0

/obj/machinery/power/supermatter/Initialize()
	. = ..()
	radio =69ew /obj/item/device/radio{channels=list("Engineering")}(src)
	assign_uid()


/obj/machinery/power/supermatter/Destroy()
	qdel(radio)
	. = ..()

/obj/machinery/power/supermatter/ex_act(var/severity)
	switch(severity)
		if(1)
			explode()
		if(2)
			damage += 500
		if(3)
			damage += 200

/obj/machinery/power/supermatter/proc/explode()
	log_and_message_admins("Supermatter exploded at 69x69 69y69 69z69")
	anchored = TRUE
	grav_pulling = 1
	exploded = 1
	for(var/mob/living/mob in GLOB.living_mob_list)
		var/turf/T = get_turf(mob)
		if(T && (loc.z == T.z))
			if(ishuman(mob))
				//Hilariously enough, running into a closet should69ake you get hit the hardest.
				var/mob/living/carbon/human/H =69ob
				var/power =69in(300, DETONATION_HALLUCINATION * sqrt(1 / (get_dist(mob, src) + 1)) )
				H.adjust_hallucination(power, power)
			var/rads = DETONATION_RADS * sqrt( 1 / (get_dist(mob, src) + 1) )
			mob.apply_effect(rads, IRRADIATE)
	spawn(pull_time)
		explosion(get_turf(src), explosion_power, explosion_power * 1.25, explosion_power * 1.5, explosion_power * 1.75, 1)
		qdel(src)
		return

//Changes color and luminosity of the light to these69alues if they were69ot already set
/obj/machinery/power/supermatter/proc/shift_light(var/lum,69ar/clr)
	if(lum != light_range || clr != light_color)
		set_light(lum, l_color = clr)

/obj/machinery/power/supermatter/proc/get_integrity()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity


/obj/machinery/power/supermatter/proc/announce_warning()
	var/integrity = get_integrity()
	var/alert_msg = " Integrity at 69integrity69%"

	if(damage > emergency_point)
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(damage >= damage_archived) // The damage is still going up
		safe_warned = 0
		alert_msg = warning_alert + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1 // We are safe, warn only once
		alert_msg = safe_alert
		lastwarning = world.timeofday
	else
		alert_msg =69ull
	if(alert_msg)
		radio.autosay(alert_msg, "Supermatter69onitor", "Engineering")
		//Public alerts
		if((damage > emergency_point) && !public_alert)
			radio.autosay("WARNING: SUPERMATTER CRYSTAL DELAMINATION IMMINENT!", "Supermatter69onitor")
			public_alert = 1
		else if(safe_warned && public_alert)
			radio.autosay(alert_msg, "Supermatter69onitor")
			public_alert = 0


/obj/machinery/power/supermatter/get_transit_zlevel()
	//don't send it back to the station --69ost of the time
	if(prob(99))
		var/list/candidates = GLOB.maps_data.accessable_levels.Copy()
		for(var/zlevel in GLOB.maps_data.station_levels)
			candidates.Remove("69zlevel69")
		candidates.Remove("69src.z69")

		if(candidates.len)
			return text2num(pickweight(candidates))

	return ..()

/obj/machinery/power/supermatter/Process()
	var/turf/L = loc

	if(isnull(L))		// We have a69ull turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for69ow.
		return  //Yeah just stop.

	if(damage > explosion_point)
		if(!exploded)
			if(!istype(L, /turf/space))
				announce_warning()
			explode()
	else if(damage > warning_point) // while the core is still damaged and it's still worth69oting its status
		shift_light(5, warning_color)
		if(damage > emergency_point)
			shift_light(7, emergency_color)
		if(!istype(L, /turf/space) && (world.timeofday - lastwarning) >= WARNING_DELAY * 10)
			announce_warning()
	else
		shift_light(4,initial(light_color))
	if(grav_pulling)
		supermatter_pull()

	//Ok, get the air from the turf
	var/datum/gas_mixture/removed =69ull
	var/datum/gas_mixture/env =69ull

	//ensure that damage doesn't increase too quickly due to super high temperatures resulting from69o coolant, for example. We dont want the SM exploding before anyone can react.
	//We want the cap to scale linearly with power (and explosion_point). Let's aim for a cap of 5 at power = 300 (based on testing, equals roughly 5% per SM alert announcement).
	var/damage_inc_limit = (power/300)*(explosion_point/1000)*DAMAGE_RATE_LIMIT

	if(!istype(L, /turf/space))
		env = L.return_air()
		removed = env.remove(gasefficency * env.total_moles)	//Remove gas from surrounding area

	if(!env || !removed || !removed.total_moles)
		damage +=69ax((power - 15*POWER_FACTOR)/10, 0)
	else if (grav_pulling) //If supermatter is detonating, remove all air from the zone
		env.remove(env.total_moles)
	else
		damage_archived = damage

		damage =69ax( damage +69in( ( (removed.temperature - CRITICAL_TEMPERATURE) / 150 ), damage_inc_limit ) , 0 )
		//Ok, 100% oxygen atmosphere = best reaction
		//Maxes out at 100% oxygen pressure
		oxygen =69ax(min((removed.gas69"oxygen"69 - (removed.gas69"nitrogen"69 *69ITROGEN_RETARDATION_FACTOR)) / removed.total_moles, 1), 0)

		//calculate power gain for oxygen reaction
		var/temp_factor
		var/equilibrium_power
		if (oxygen > 0.8)
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 400
			equilibrium_power = 400
			icon_state = "69base_icon_state69_glow"
		else
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 250
			equilibrium_power = 250
			icon_state = base_icon_state

		temp_factor = ( (equilibrium_power/DECAY_FACTOR)**3 )/800
		power =69ax( (removed.temperature * temp_factor) * oxygen + power, 0)

		//We've generated power,69ow let's transfer it to the collectors for storing/usage
		transfer_energy()

		var/device_energy = power * REACTION_POWER_MODIFIER

		//Release reaction gasses
		var/heat_capacity = removed.heat_capacity()
		removed.adjust_multi("plasma",69ax(device_energy / PLASMA_RELEASE_MODIFIER, 0), \
		                     "oxygen",69ax((device_energy + removed.temperature - T0C) / OXYGEN_RELEASE_MODIFIER, 0))

		var/thermal_power = THERMAL_RELEASE_MODIFIER * device_energy
		if (debug)
			var/heat_capacity_new = removed.heat_capacity()
			visible_message("69src69: Releasing 69round(thermal_power)69 W.")
			visible_message("69src69: Releasing additional 69round((heat_capacity_new - heat_capacity)*removed.temperature)69 W with exhaust gasses.")

		removed.add_thermal_energy(thermal_power)
		removed.temperature = between(0, removed.temperature, 10000)

		env.merge(removed)

	for(var/mob/living/carbon/human/H in69iew(src,69in(7, round(sqrt(power/6))))) // If they can see it without69esons on.  Bad on them.
		if(!istype(H.glasses, /obj/item/clothing/glasses/powered/meson))
			if (!(istype(H.wearing_rig, /obj/item/rig) && istype(H.wearing_rig.getCurrentGlasses(), /obj/item/clothing/glasses/powered/meson)))
				var/effect =69ax(0,69in(200, power * config_hallucination_power * sqrt( 1 /69ax(1,get_dist(H, src)))) )
				H.adjust_hallucination(effect, 0.25*effect)
				H.add_side_effect("Headache", 11)

	//adjusted range so that a power of 170 (pretty high) results in 9 tiles, roughly the distance from the core to the engine69onitoring room.
	//note that the rads given at the69aximum range is a constant 0.2 - as power increases the69aximum range69erely increases.
	for(var/mob/living/l in range(src, round(sqrt(power / 2) / 2)))
		var/radius =69ax(get_dist(l, src), 1)
		var/rads = (power / 10) * ( 1 / (radius**2) )
		l.apply_effect(rads, IRRADIATE)

	power -= (power/DECAY_FACTOR)**3		//energy losses due to radiation

	return 1


/obj/machinery/power/supermatter/bullet_act(var/obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0	// This stops people from being able to really power up the supermatter
				// Then bring it inside to explode instantly upon landing on a69alid turf.


	var/proj_damage = Proj.get_structure_damage()
	if(istype(Proj, /obj/item/projectile/beam))
		power += proj_damage * config_bullet_energy	* CHARGING_FACTOR / POWER_FACTOR
	else
		damage += proj_damage * config_bullet_energy
	return 0

/obj/machinery/power/supermatter/attack_robot(mob/user as69ob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		ui_interact(user)
	return

/obj/machinery/power/supermatter/attack_ai(mob/user as69ob)
	ui_interact(user)

/obj/machinery/power/supermatter/attack_hand(mob/user as69ob)
	user.visible_message("<span class=\"warning\">\The 69user69 reaches out and touches \the 69src69, inducing a resonance... \his body starts to glow and bursts into flames before flashing into ash.</span>",\
		"<span class=\"danger\">You reach out and touch \the 69src69. Everything starts burning and all you can hear is ringing. Your last thought is \"That was69ot a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")

	Consume(user)

// This is purely informational UI that69ay be accessed by AIs or robots
/obj/machinery/power/supermatter/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/data69069

	data69"integrity_percentage"69 = round(get_integrity())
	var/datum/gas_mixture/env =69ull
	if(!istype(src.loc, /turf/space))
		env = src.loc.return_air()

	if(!env)
		data69"ambient_temp"69 = 0
		data69"ambient_pressure"69 = 0
	else
		data69"ambient_temp"69 = round(env.temperature)
		data69"ambient_pressure"69 = round(env.return_pressure())
	data69"detonating"69 = grav_pulling
	data69"energy"69 = power

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "supermatter_crystal.tmpl", "Supermatter Crystal", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)



/obj/machinery/power/supermatter/proc/transfer_energy()
	var/transfer_energy = power * POWER_FACTOR * COLLECTOR_TRANSFER_FACTOR
	for(var/obj/machinery/power/rad_collector/R in GLOB.rad_collectors)
		var/distance = get_dist(R, src)
		if(distance <= 15)
			//for collectors using standard plasma tanks at 1013 kPa, the actual power generated will be this transfer_energy*20*29 = transfer_energy*580
			R.receive_pulse(transfer_energy * (min(3/(distance != 0 ? distance : 1), 1))**2)


/obj/machinery/power/supermatter/attackby(obj/item/W as obj,69ob/living/user as69ob)

	/*
		Repairing the supermatter with duct tape, for69eme69alue
		If you can get this close to a damaged crystal its probably too late for it anyway,
		this is unlikely to do anything but prolong the inevitable
	*/
	if (W.has_quality(QUALITY_SEALING) && damage > 0)
		user.visible_message("69user69 starts sealing up cracks in 69src69 with the 69W69", "You start sealing up cracks in 69src69 with the 69W69")
		if (W.use_tool(user, src, 140, QUALITY_SEALING, FAILCHANCE_VERY_HARD, STAT_MEC))
			to_chat(user, SPAN_NOTICE("Your insane actions are somehow paying off."))
			user.apply_effect(100, IRRADIATE)
			damage = 0
			return
		//If you fail the above, your tape will be eaten by the code below

	user.visible_message(
		"<span class=\"warning\">\The 69user69 touches \a 69W69 to \the 69src69 as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the 69W69 to \the 69src69 when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The 69W69 flashes into dust as you flinch away from \the 69src69.</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>"
	)

	user.drop_from_inventory(W)
	Consume(W)

	user.apply_effect(150, IRRADIATE)


/obj/machinery/power/supermatter/Bumped(atom/AM as69ob|obj)
	if(istype(AM, /obj/effect))
		return
	if(isliving(AM))
		AM.visible_message("<span class=\"warning\">\The 69AM69 slams into \the 69src69 inducing a resonance... \his body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the 69src69 as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")
	else if(!grav_pulling) //To prevent spam, detonating supermatter does69ot indicate69on-mobs being destroyed
		AM.visible_message("<span class=\"warning\">\The 69AM69 smacks into \the 69src69 and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	Consume(AM)


/obj/machinery/power/supermatter/proc/Consume(var/mob/living/user)
	if(istype(user))
		user.dust()
		power += 200
	else
		qdel(user)

	power += 200

		//Some poor sod got eaten, go ahead and irradiate people69earby.
	for(var/mob/living/l in range(10))
		if(l in69iew())
			l.show_message("<span class=\"warning\">As \the 69src69 slowly stops resonating, you find your skin covered in69ew radiation burns.</span>", 1,\
				"<span class=\"warning\">The unearthly ringing subsides and you69otice you have69ew radiation burns.</span>", 2)
		else
			l.show_message("<span class=\"warning\">You hear an uneartly ringing and69otice your skin is covered in fresh radiation burns.</span>", 2)
		var/rads = 500 * sqrt( 1 / (get_dist(l, src) + 1) )
		l.apply_effect(rads, IRRADIATE)


/obj/machinery/power/supermatter/proc/supermatter_pull()
	for(var/atom/A in range(255, src))
		A.singularity_pull(src, STAGE_FIVE)
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(!H.lying)
				to_chat(H, SPAN_DANGER("A strong gravitational force slams you to the ground!"))
				H.Weaken(20)


/obj/machinery/power/supermatter/GotoAirflowDest(n) //Supermatter69ot pushed around by airflow
	return

/obj/machinery/power/supermatter/RepelAirflowDest(n)
	return

/obj/machinery/power/supermatter/shard //Small subtype, less efficient and69ore sensitive, but less boom.
	name = "Supermatter Shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. \red You get headaches just from looking at it."
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

	warning_point = 50
	emergency_point = 400
	explosion_point = 600

	gasefficency = 0.125

	pull_time = 150
	explosion_power = 3

/obj/machinery/power/supermatter/shard/announce_warning() //Shards don't get announcements
	return

/obj/machinery/power/supermatter/proc/get_status()
	var/turf/T = get_turf(src)
	if(!T)
		return SUPERMATTER_ERROR
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return SUPERMATTER_ERROR

	if(grav_pulling || exploded)
		return SUPERMATTER_DELAMINATING

	if(get_integrity() < 25)
		return SUPERMATTER_EMERGENCY

	if(get_integrity() < 50)
		return SUPERMATTER_DANGER

	if((get_integrity() < 100) || (air.temperature > CRITICAL_TEMPERATURE))
		return SUPERMATTER_WARNING

	if(air.temperature > (CRITICAL_TEMPERATURE * 0.8))
		return SUPERMATTER_NOTIFY

	if(power > 5)
		return SUPERMATTER_NORMAL
	return SUPERMATTER_INACTIVE

/obj/machinery/power/supermatter/proc/get_epr()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return 0
	return round((air.total_moles / air.group_multiplier) / 23.1, 0.01)
