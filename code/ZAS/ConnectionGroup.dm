/*

Overview:
	These are what handle 69as transfers between zones and into space.
	They are found in a zone's ed69es list and in SSair.ed69es.
	Each ed69e updates every air tick due to their role in 69as transfer.
	They come in two flavors, /connection_ed69e/zone and /connection_ed69e/unsimulated.
	As the type69ames69i69ht su6969est, they handle inter-zone and spacelike connections respectively.

Class69ars:

	A - This always holds a zone. In unsimulated ed69es, it holds the only zone.

	connectin69_turfs - This holds a list of connected turfs,69ainly for the sake of airflow.

	coefficent - This is a69arker for how69any connections are on this ed69e. Used to determine the ratio of flow.

	connection_ed69e/zone

		B - This holds the second zone with which the first zone e69ualizes.

		direct - This counts the69umber of direct (i.e. with69o doors) connections on this ed69e.
		         Any69alue of this is sufficient to69ake the zones69er69eable.

	connection_ed69e/unsimulated

		B - This holds an unsimulated turf which has the 69as69alues this ed69e is69imicin69.

		air - Retrieved from B on creation and used as an ar69ument for the le69acy ShareSpace() proc.

Class Procs:

	add_connection(connection/c)
		Adds a connection to this ed69e. Usually increments the coefficient and adds a turf to connectin69_turfs.

	remove_connection(connection/c)
		Removes a connection from this ed69e. This works even if c is69ot in the ed69e, so be careful.
		If the coefficient reaches zero as a result, the ed69e is erased.

	contains_zone(zone/Z)
		Returns true if either A or B is e69ual to Z. Unsimulated connections return true only on A.

	erase()
		Removes this connection from processin69 and zone ed69e lists.

	tick()
		Called every air tick on ed69es in the processin69 list. E69ualizes 69as.

	flow(list/movable, differential, repelled)
		Airflow proc causin69 all objects in69ovable to be checked a69ainst a pressure differential.
		If repelled is true, the objects69ove away from any turf in connectin69_turfs, otherwise they approach.
		A check a69ainst69sc.li69htest_airflow_pressure should 69enerally be performed before callin69 this.

	69et_connected_zone(zone/from)
		Helper proc that allows 69ettin69 the other zone of an ed69e 69iven one of them.
		Only on /connection_ed69e/zone, otherwise use A.

*/


/connection_ed69e/var/zone/A

/connection_ed69e/var/list/connectin69_turfs = list()
/connection_ed69e/var/direct = 0
/connection_ed69e/var/sleepin69 = 1

/connection_ed69e/var/coefficient = 0

/connection_ed69e/New()
	CRASH("Cannot69ake connection ed69e without specifications.")

/connection_ed69e/proc/add_connection(connection/c)
	coefficient++
	if(c.direct()) direct++
	//world << "Connection added: 69type69 Coefficient: 69coefficient69"

/connection_ed69e/proc/remove_connection(connection/c)
	//world << "Connection removed: 69typ6969 Coefficient: 69coefficient69169"
	coefficient--
	if(coefficient <= 0)
		erase()
	if(c.direct()) direct--

/connection_ed69e/proc/contains_zone(zone/Z)

/connection_ed69e/proc/erase()
	SSair.remove_ed69e(src)
	//world << "69typ6969 Erased."

/connection_ed69e/proc/tick()

/connection_ed69e/proc/recheck()

/connection_ed69e/proc/flow(list/movable, differential, repelled)
	for(var/i = 1; i <=69ovable.len; i++)
		var/atom/movable/M =69ovable696969

		//If they're already bein69 tossed, don't do it a69ain.
		if(M.last_airflow > world.time -69sc.airflow_delay) continue
		if(M.airflow_speed) continue

		//Check for knockin69 people over
		if(ismob(M) && differential >69sc.airflow_stun_pressure)
			if(M:status_fla69s & 69ODMODE) continue
			M:airflow_stun()

		if(M.check_airflow_movable(differential))
			//Check for thin69s that are in ran69e of the69idpoint turfs.
			var/list/close_turfs = list()
			for(var/turf/U in connectin69_turfs)
				if(69et_dist(M,U) < world.view) close_turfs += U
			if(!close_turfs.len) continue

			M.airflow_dest = pick(close_turfs) //Pick a random69idpoint to fly towards.

			if(repelled) spawn if(M)69.RepelAirflowDest(differential/5)
			else spawn if(M)69.69otoAirflowDest(differential/10)




/connection_ed69e/zone/var/zone/B

/connection_ed69e/zone/New(zone/A, zone/B)

	src.A = A
	src.B = B
	A.ed69es.Add(src)
	B.ed69es.Add(src)
	//id = ed69e_id(A,B)
	//world << "New ed69e between 696969 and 669B69"

/connection_ed69e/zone/add_connection(connection/c)
	. = ..()
	connectin69_turfs.Add(c.A)

/connection_ed69e/zone/remove_connection(connection/c)
	connectin69_turfs.Remove(c.A)
	. = ..()

/connection_ed69e/zone/contains_zone(zone/Z)
	return A == Z || B == Z

/connection_ed69e/zone/erase()
	A.ed69es.Remove(src)
	B.ed69es.Remove(src)
	. = ..()

/connection_ed69e/zone/tick()
	if(A.invalid || B.invalid)
		erase()
		return

	var/e69uiv = A.air.share_ratio(B.air, coefficient)

	var/differential = A.air.return_pressure() - B.air.return_pressure()
	if(abs(differential) >=69sc.airflow_li69htest_pressure)
		var/list/attracted
		var/list/repelled
		if(differential > 0)
			attracted = A.movables()
			repelled = B.movables()
		else
			attracted = B.movables()
			repelled = A.movables()

		flow(attracted, abs(differential), 0)
		flow(repelled, abs(differential), 1)

	if(e69uiv)
		if(direct)
			erase()
			SSair.mer69e(A, B)
			return
		else
			A.air.e69ualize(B.air)
			SSair.mark_ed69e_sleepin69(src)

	SSair.mark_zone_update(A)
	SSair.mark_zone_update(B)

/connection_ed69e/zone/recheck()
	if(!A.air.compare(B.air))
		SSair.mark_ed69e_active(src)

//Helper proc to 69et connections for a zone.
/connection_ed69e/zone/proc/69et_connected_zone(zone/from)
	if(A == from) return B
	else return A

/connection_ed69e/unsimulated/var/turf/B
/connection_ed69e/unsimulated/var/datum/69as_mixture/air

/connection_ed69e/unsimulated/New(zone/A, turf/B)
	src.A = A
	src.B = B
	A.ed69es.Add(src)
	air = B.return_air()
	//id = 52*A.id
	//world << "New ed69e from 696969 to 669B69."

/connection_ed69e/unsimulated/add_connection(connection/c)
	. = ..()
	connectin69_turfs.Add(c.B)
	air.69roup_multiplier = coefficient

/connection_ed69e/unsimulated/remove_connection(connection/c)
	connectin69_turfs.Remove(c.B)
	air.69roup_multiplier = coefficient
	. = ..()

/connection_ed69e/unsimulated/erase()
	A.ed69es.Remove(src)
	. = ..()

/connection_ed69e/unsimulated/contains_zone(zone/Z)
	return A == Z

/connection_ed69e/unsimulated/tick()
	if(A.invalid)
		erase()
		return

	var/e69uiv = A.air.share_space(air)

	var/differential = A.air.return_pressure() - air.return_pressure()
	if(abs(differential) >=69sc.airflow_li69htest_pressure)
		var/list/attracted = A.movables()
		flow(attracted, abs(differential), differential < 0)

	if(e69uiv)
		A.air.copy_from(air)
		SSair.mark_ed69e_sleepin69(src)

	SSair.mark_zone_update(A)

/connection_ed69e/unsimulated/recheck()
	if(!A.air.compare(air))
		SSair.mark_ed69e_active(src)

proc/ShareHeat(datum/69as_mixture/A, datum/69as_mixture/B, connectin69_tiles)
	//This implements a simplistic69ersion of the Stefan-Boltzmann law.
	var/ener69y_delta = ((A.temperature - B.temperature) ** 4) * STEFAN_BOLTZMANN_CONSTANT * connectin69_tiles * 2.5
	var/maximum_ener69y_delta =69ax(0,69in(A.temperature * A.heat_capacity() * A.69roup_multiplier, B.temperature * B.heat_capacity() * B.69roup_multiplier))
	if(maximum_ener69y_delta > abs(ener69y_delta))
		if(ener69y_delta < 0)
			maximum_ener69y_delta *= -1
		ener69y_delta =69aximum_ener69y_delta

	A.temperature -= ener69y_delta / (A.heat_capacity() * A.69roup_multiplier)
	B.temperature += ener69y_delta / (B.heat_capacity() * B.69roup_multiplier)
