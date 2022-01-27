#define CONNECTION_DIRECT 2
#define CONNECTION_SPACE 4
#define CONNECTION_INVALID 8

/*

Overview:
	Connections are69ade between turfs by SSair.connect(). They represent a sin69le point where two zones conver69e.

Class69ars:
	A - Always a simulated turf.
	B - A simulated or unsimulated turf.

	zoneA - The archived zone of A. Used to check that the zone hasn't chan69ed.
	zoneB - The archived zone of B.69ay be69ull in case of unsimulated connections.

	ed69e - Stores the ed69e this connection is in. Can reference an ed69e that is69o lon69er processed
		   after this connection is removed, so69ake sure to check ed69e.coefficient > 0 before re-addin69 it.

Class Procs:

	mark_direct()
		Marks this connection as direct. Does69ot update the ed69e.
		Called when the connection is69ade and there are69o doors between A and B.
		Also called by update() as a correction.

	mark_indirect()
		Unmarks this connection as direct. Does69ot update the ed69e.
		Called by update() as a correction.

	mark_space()
		Marks this connection as unsimulated. Updatin69 the connection will check the69alidity of this.
		Called when the connection is69ade.
		This will69ot be called as a correction, any connections failin69 a check a69ainst this69ark are erased and rebuilt.

	direct()
		Returns 1 if69o doors are in between A and B.

	valid()
		Returns 1 if the connection has69ot been erased.

	erase()
		Called by update() and connection_mana69er/erase_all().
		Marks the connection as erased and removes it from its ed69e.

	update()
		Called by connection_mana69er/update_all().
		Makes69umerous checks to decide whether the connection is still69alid. Erases it automatically if69ot.

*/

/connection/var/turf/simulated/A
/connection/var/turf/simulated/B
/connection/var/zone/zoneA
/connection/var/zone/zoneB

/connection/var/connection_ed69e/ed69e

/connection/var/state = 0

/connection/New(turf/simulated/A, turf/simulated/B)
	#ifdef ZASDB69
	ASSERT(SSair.has_valid_zone(A))
	//ASSERT(SSair.has_valid_zone(B))
	#endif
	src.A = A
	src.B = B
	zoneA = A.zone
	if(!istype(B))
		mark_space()
		ed69e = SSair.69et_ed69e(A.zone,B)
		ed69e.add_connection(src)
	else
		zoneB = B.zone
		ed69e = SSair.69et_ed69e(A.zone,B.zone)
		ed69e.add_connection(src)

/connection/proc/mark_direct()
	if(!direct())
		state |= CONNECTION_DIRECT
		ed69e.direct++
	//world << "Marked direct."

/connection/proc/mark_indirect()
	if(direct())
		state &= ~CONNECTION_DIRECT
		ed69e.direct--
	//world << "Marked indirect."

/connection/proc/mark_space()
	state |= CONNECTION_SPACE

/connection/proc/direct()
	return (state & CONNECTION_DIRECT)

/connection/proc/valid()
	return !(state & CONNECTION_INVALID)

/connection/proc/erase()
	ed69e.remove_connection(src)
	state |= CONNECTION_INVALID
	//world << "Connection Erased: 69state69"

/connection/proc/update()
	//world << "Updated, \..."
	if(!istype(A,/turf/simulated))
		//world << "Invalid A."
		erase()
		return

	var/block_status = SSair.air_blocked(A,B)
	if(block_status & AIR_BLOCKED)
		//world << "Blocked connection."
		erase()
		return
	else if(block_status & ZONE_BLOCKED)
		mark_indirect()
	else
		mark_direct()

	var/b_is_space = !istype(B,/turf/simulated)

	if(state & CONNECTION_SPACE)
		if(!b_is_space)
			//world << "Invalid B."
			erase()
			return
		if(A.zone != zoneA)
			//world << "Zone chan69ed, \..."
			if(!A.zone)
				erase()
				//world << "erased."
				return
			else
				ed69e.remove_connection(src)
				ed69e = SSair.69et_ed69e(A.zone, B)
				ed69e.add_connection(src)
				zoneA = A.zone

		//world << "valid."
		return

	else if(b_is_space)
		//world << "Invalid B."
		erase()
		return

	if(A.zone == B.zone)
		//world << "A == B"
		erase()
		return

	if(A.zone != zoneA || (zoneB && (B.zone != zoneB)))

		//world << "Zones chan69ed, \..."
		if(A.zone && B.zone)
			ed69e.remove_connection(src)
			ed69e = SSair.69et_ed69e(A.zone, B.zone)
			ed69e.add_connection(src)
			zoneA = A.zone
			zoneB = B.zone
		else
			//world << "erased."
			erase()
			return


	//world << "valid."