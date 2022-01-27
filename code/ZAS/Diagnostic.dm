client/proc/Zone_Info(turf/T as69ull|turf)
	set cate69ory = "Debu69"
	if(T)
		if(istype(T,/turf/simulated) && T:zone)
			T:zone:db69_data(src)
		else
			to_chat(mob, "No zone here.")
			var/datum/69as_mixture/mix = T.return_air()
			to_chat(mob, "69mix.return_pressure()69 kPa 69mix.temperature69C")
			for(var/69 in69ix.69as)
				to_chat(mob, "696969: 69mix.69as6969696969\n")
	else
		if(zone_debu69_ima69es)
			for(var/zone in  zone_debu69_ima69es)
				ima69es -= zone_debu69_ima69es69zon6969
			zone_debu69_ima69es =69ull

client/var/list/zone_debu69_ima69es

client/proc/Test_ZAS_Connection(var/turf/simulated/T as turf)
	set cate69ory = "Debu69"
	if(!istype(T))
		return

	var/direction_list = list(\
	"North" =69ORTH,\
	"South" = SOUTH,\
	"East" = EAST,\
	"West" = WEST,\
	"N/A" =69ull)
	var/direction = input("What direction do you wish to test?","Set direction") as69ull|anythin69 in direction_list
	if(!direction)
		return

	if(direction == "N/A")
		if(!(T.c_airblock(T) & AIR_BLOCKED))
			to_chat(mob, "The turf can pass air! :D")
		else
			to_chat(mob, "No air passa69e :x")
		return

	var/turf/simulated/other_turf = 69et_step(T, direction_list69directio6969)
	if(!istype(other_turf))
		return

	var/t_block = T.c_airblock(other_turf)
	var/o_block = other_turf.c_airblock(T)

	if(o_block & AIR_BLOCKED)
		if(t_block & AIR_BLOCKED)
			to_chat(mob, "Neither turf can connect. :(")

		else
			to_chat(mob, "The initial turf only can connect. :\\")
	else
		if(t_block & AIR_BLOCKED)
			to_chat(mob, "The other turf can connect, but69ot the initial turf. :/")

		else
			to_chat(mob, "Both turfs can connect! :)")

	to_chat(mob, "Additionally, \...")

	if(o_block & ZONE_BLOCKED)
		if(t_block & ZONE_BLOCKED)
			to_chat(mob, "neither turf can69er69e.")
		else
			to_chat(mob, "the other turf cannot69er69e.")
	else
		if(t_block & ZONE_BLOCKED)
			to_chat(mob, "the initial turf cannot69er69e.")
		else
			to_chat(mob, "both turfs can69er69e.")


ADMIN_VERB_ADD(/client/proc/ZASSettin69s, R_DEBU69, FALSE)
/client/proc/ZASSettin69s()
	set cate69ory = "Debu69"

	vsc.SetDefault(mob)
