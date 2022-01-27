//renwicks: fictional unit to describe shield strength
//a small69eteor hit will deduct 1 renwick of strength from that shield tile
//light explosion range will do 1 renwick's damage
//medium explosion range will do 2 renwick's damage
//heavy explosion range will do 3 renwick's damage
//explosion damage is cumulative. if a tile is in range of light,69edium and heavy damage, it will take a hit from all three

/obj/machinery/shield_gen
	name = "bubble shield generator"
	desc = "Machine that generates an impenetrable field of energy when activated."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "generator0"
	var/active = 0
	var/field_radius = 3
	var/max_field_radius = 100
	var/list/field
	density = TRUE
	var/locked = 0
	var/average_field_strength = 0
	var/strengthen_rate = 0.2
	var/max_strengthen_rate = 0.5	//the69aximum rate that the generator can increase the average field strength
	var/dissipation_rate = 0.030	//the percentage of the shield strength that69eeds to be replaced each second
	var/min_dissipation = 0.01		//will dissipate by at least this rate in renwicks per field tile (otherwise field would69ever dissipate completely as dissipation is a percentage)
	var/powered = 0
	var/check_powered = 1
	var/obj/machinery/shield_capacitor/owned_capacitor
	var/target_field_strength = 10
	var/max_field_strength = 10
	var/time_since_fail = 100
	var/energy_conversion_rate = 0.0002	//how69any renwicks per watt?
	use_power =69O_POWER_USE	//doesn't use APC power

/obj/machinery/shield_gen/New()
	spawn(10)
		for(var/obj/machinery/shield_capacitor/possible_cap in range(1, src))
			if(get_dir(possible_cap, src) == possible_cap.dir)
				owned_capacitor = possible_cap
				break
	field =69ew/list()
	..()

/obj/machinery/shield_gen/Destroy()
	for(var/obj/effect/energy_field/D in field)
		field.Remove(D)
		D.loc =69ull
	. = ..()

/obj/machinery/shield_gen/emag_act(var/remaining_charges,69ar/mob/user)
	if(prob(75))
		src.locked = !src.locked
		user << "Controls are69ow 69src.locked ? "locked." : "unlocked."69"
		. = 1
		updateDialog()
	var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()

/obj/machinery/shield_gen/attackby(obj/item/I,69ob/user)
	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		if(access_captain in C.access || access_security in C.access || access_engine in C.access)
			src.locked = !src.locked
			user << "Controls are69ow 69src.locked ? "locked." : "unlocked."69"
			updateDialog()
		else
			user << "\red Access denied."

	if(69UALITY_BOLT_TURNING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_BOLT_TURNING, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
			src.anchored = !src.anchored
			src.visible_message("\blue \icon69src69 69src69 has been 69anchored?"bolted to the floor":"unbolted from the floor"69 by 69user69.")

			if(active)
				toggle()
			if(anchored)
				spawn(0)
					for(var/obj/machinery/shield_capacitor/cap in range(1, src))
						if(cap.owned_gen)
							continue
						if(get_dir(cap, src) == cap.dir && cap.anchored)
							owned_capacitor = cap
							owned_capacitor.owned_gen = src
							updateDialog()
							update_icon()
							break
			else
				if(owned_capacitor && owned_capacitor.owned_gen == src)
					owned_capacitor.owned_gen =69ull
				owned_capacitor =69ull
				update_icon()
	else
		..()

/obj/machinery/shield_gen/attack_ai(user as69ob)
	return src.attack_hand(user)

/obj/machinery/shield_gen/attack_hand(mob/user)
	if(stat & (BROKEN))
		return
	interact(user)

/obj/machinery/shield_gen/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN)) )
		if (!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=shield_generator")
			return
	var/t = "<B>Shield Generator Control Console</B><BR><br>"
	if(locked)
		t += "<i>Swipe your ID card to begin.</i>"
	else
		t += "69owned_capacitor ? "<font color=green>Charge capacitor connected.</font>" : "<font color=red>Unable to locate charge capacitor!</font>"69<br>"
		t += "This generator is: 69active ? "<font color=green>Online</font>" : "<font color=red>Offline</font>" 69 <a href='?src=\ref69src69;toggle=1'>69active ? "\69Deactivate\69" : "\69Activate\69"69</a><br>"
		t += "Field Status: 69time_since_fail > 2 ? "<font color=green>Stable</font>" : "<font color=red>Unstable</font>"69<br>"
		t += "Coverage Radius (restart re69uired): \
		<a href='?src=\ref69src69;change_radius=-50'>---</a> \
		<a href='?src=\ref69src69;change_radius=-5'>--</a> \
		<a href='?src=\ref69src69;change_radius=-1'>-</a> \
		69field_radius6969 \
		<a href='?src=\ref69src69;change_radius=1'>+</a> \
		<a href='?src=\ref69src69;change_radius=5'>++</a> \
		<a href='?src=\ref69src69;change_radius=50'>+++</a><br>"
		t += "Overall Field Strength: 69round(average_field_strength, 0.01)69 Renwick (69target_field_strength ? round(100 * average_field_strength / target_field_strength, 0.1) : "NA"69%)<br>"
		t += "Upkeep Power: 69round(field.len *69ax(average_field_strength * dissipation_rate,69in_dissipation) / energy_conversion_rate)69 W<br>"
		t += "Charge Rate: <a href='?src=\ref69src69;strengthen_rate=-0.1'>--</a> \
		69strengthen_rate69 Renwick/s \
		<a href='?src=\ref69src69;strengthen_rate=0.1'>++</a><br>"
		t += "Shield Generation Power: 69round(field.len *69in(strengthen_rate, target_field_strength - average_field_strength) / energy_conversion_rate)69 W<br>"
		t += "Maximum Field Strength: \
		<a href='?src=\ref69src69;target_field_strength=-10'>\69min\69</a> \
		<a href='?src=\ref69src69;target_field_strength=-5'>--</a> \
		<a href='?src=\ref69src69;target_field_strength=-1'>-</a> \
		69target_field_strength69 Renwick \
		<a href='?src=\ref69src69;target_field_strength=1'>+</a> \
		<a href='?src=\ref69src69;target_field_strength=5'>++</a> \
		<a href='?src=\ref69src69;target_field_strength=10'>\69max\69</a><br>"
	t += "<hr>"
	t += "<A href='?src=\ref69src69'>Refresh</A> "
	t += "<A href='?src=\ref69src69;close=1'>Close</A><BR>"
	user << browse(t, "window=shield_generator;size=500x400")
	user.set_machine(src)

/obj/machinery/shield_gen/Process()
	if (!anchored && active)
		toggle()

	average_field_strength =69ax(average_field_strength, 0)

	if(field.len)
		time_since_fail++
		var/total_renwick_increase = 0 //the amount of renwicks that the generator can add this tick, over the entire field
		var/renwick_upkeep_per_field =69ax(average_field_strength * dissipation_rate,69in_dissipation)

		//figure out how69uch energy we69eed to draw from the capacitor
		if(active && owned_capacitor && owned_capacitor.active)
			var/target_renwick_increase =69in(target_field_strength - average_field_strength, strengthen_rate) + renwick_upkeep_per_field //per field tile

			var/re69uired_energy = field.len * target_renwick_increase / energy_conversion_rate
			var/assumed_charge =69in(owned_capacitor.stored_charge, re69uired_energy)
			total_renwick_increase = assumed_charge * energy_conversion_rate
			owned_capacitor.stored_charge -= assumed_charge
		else
			renwick_upkeep_per_field =69ax(renwick_upkeep_per_field, 0.5)

		var/renwick_increase_per_field = total_renwick_increase/field.len //per field tile

		average_field_strength = 0 //recalculate the average field strength
		for(var/obj/effect/energy_field/E in field)
			var/amount_to_strengthen = renwick_increase_per_field - renwick_upkeep_per_field
			if(E.ticks_recovering > 0 && amount_to_strengthen > 0)
				E.Strengthen(69in(amount_to_strengthen / 10, 0.1) )
				E.ticks_recovering -= 1
			else
				E.Strengthen(amount_to_strengthen)

			average_field_strength += E.strength

		average_field_strength /= field.len
		if(average_field_strength < 1)
			time_since_fail = 0
	else
		average_field_strength = 0

/obj/machinery/shield_gen/Topic(href, href_list6969)
	..()
	if( href_list69"close"69 )
		usr << browse(null, "window=shield_generator")
		usr.unset_machine()
		return
	else if( href_list69"toggle"69 )
		if (!active && !anchored)
			usr << "\red The 69src6969eeds to be firmly secured to the floor first."
			return
		toggle()
	else if( href_list69"change_radius"69 )
		field_radius = between(0, field_radius + text2num(href_list69"change_radius"69),69ax_field_radius)
	else if( href_list69"strengthen_rate"69 )
		strengthen_rate = between(0,  strengthen_rate + text2num(href_list69"strengthen_rate"69),69ax_strengthen_rate)
	else if( href_list69"target_field_strength"69 )
		target_field_strength = between(1, target_field_strength + text2num(href_list69"target_field_strength"69),69ax_field_strength)

	updateDialog()

/obj/machinery/shield_gen/ex_act(var/severity)

	if(active)
		toggle()
	return ..()

/obj/machinery/shield_gen/proc/toggle()
	set background = 1
	active = !active
	update_icon()
	if(active)
		var/list/covered_turfs = get_shielded_turfs()
		var/turf/T = get_turf(src)
		if(T in covered_turfs)
			covered_turfs.Remove(T)
		for(var/turf/O in covered_turfs)
			var/obj/effect/energy_field/E =69ew(O)
			field.Add(E)
		covered_turfs =69ull

		for(var/mob/M in69iew(5,src))
			M << "\icon69src69 You hear heavy droning start up."
	else
		for(var/obj/effect/energy_field/D in field)
			field.Remove(D)
			D.loc =69ull

		for(var/mob/M in69iew(5,src))
			M << "\icon69src69 You hear heavy droning fade out."

/obj/machinery/shield_gen/update_icon()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		if (src.active)
			icon_state = "generator1"
		else
			icon_state = "generator0"
		overlays.Cut()
		if (owned_capacitor)
			var/I = image(icon,"capacitor_connected", dir = turn(owned_capacitor.dir, 180))
			overlays += I

//TODO69AKE THIS69ULTIZ COMPATIBLE
//grab the border tiles in a circle around this69achine
/obj/machinery/shield_gen/proc/get_shielded_turfs()
	var/list/out = list()

	var/turf/gen_turf = get_turf(src)
	if (!gen_turf)
		return

	var/turf/T
	for (var/x_offset = -field_radius; x_offset <= field_radius; x_offset++)
		T = locate(gen_turf.x + x_offset, gen_turf.y - field_radius, gen_turf.z)
		if (T) out += T

		T = locate(gen_turf.x + x_offset, gen_turf.y + field_radius, gen_turf.z)
		if (T) out += T

	for (var/y_offset = -field_radius+1; y_offset < field_radius; y_offset++)
		T = locate(gen_turf.x - field_radius, gen_turf.y + y_offset, gen_turf.z)
		if (T) out += T

		T = locate(gen_turf.x + field_radius, gen_turf.y + y_offset, gen_turf.z)
		if (T) out += T

	return out
