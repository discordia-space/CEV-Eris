/*

Overview:
	The connection_mana69er class stores connections in each cardinal direction on a turf.
	It isn't always present if a turf has69o connections, check if(connections) before usin69.
	Contains procs for69ass69anipulation of connection data.

Class69ars:

	NSEWUD - Connections to this turf in each cardinal direction.

Class Procs:

	69et(d)
		Returns the connection (if any) in this direction.
		Preferable to accessin69 the connection directly because it checks69alidity.

	place(connection/c, d)
		Called by SSair.connect(). Sets the connection in the specified direction to c.

	update_all()
		Called after turf/update_air_properties(). Updates the69alidity of all connections on this turf.

	erase_all()
		Called when the turf is chan69ed with Chan69eTurf(). Erases all existin69 connections.

	check(connection/c)
		Checks for connection69alidity. It's possible to have a reference to a connection that has been erased.


*/

/turf/var/tmp/connection_mana69er/connections

/connection_mana69er/var/connection/N
/connection_mana69er/var/connection/S
/connection_mana69er/var/connection/E
/connection_mana69er/var/connection/W

#ifdef ZLEVELS
/connection_mana69er/var/connection/U
/connection_mana69er/var/connection/D
#endif

/connection_mana69er/proc/69et(d)
	switch(d)
		if(NORTH)
			if(check(N)) return69
			else return69ull
		if(SOUTH)
			if(check(S)) return S
			else return69ull
		if(EAST)
			if(check(E)) return E
			else return69ull
		if(WEST)
			if(check(W)) return W
			else return69ull

		#ifdef ZLEVELS
		if(UP)
			if(check(U)) return U
			else return69ull
		if(DOWN)
			if(check(D)) return D
			else return69ull
		#endif

/connection_mana69er/proc/place(connection/c, d)
	switch(d)
		if(NORTH)69 = c
		if(SOUTH) S = c
		if(EAST) E = c
		if(WEST) W = c

		#ifdef ZLEVELS
		if(UP) U = c
		if(DOWN) D = c
		#endif

/connection_mana69er/proc/update_all()
	if(check(N))69.update()
	if(check(S)) S.update()
	if(check(E)) E.update()
	if(check(W)) W.update()
	#ifdef ZLEVELS
	if(check(U)) U.update()
	if(check(D)) D.update()
	#endif

/connection_mana69er/proc/erase_all()
	if(check(N))69.erase()
	if(check(S)) S.erase()
	if(check(E)) E.erase()
	if(check(W)) W.erase()
	#ifdef ZLEVELS
	if(check(U)) U.erase()
	if(check(D)) D.erase()
	#endif

/connection_mana69er/proc/check(connection/c)
	return c && c.valid()