/*

Zone Air System:

This air system divides the station into impermeable areas called zones.
When somethin69 happens, i.e. a door openin69 or a wall bein69 taken down,
zones e69ualize and eventually69er69e.69akin69 an airti69ht area closes the connection a69ain.

Control Flow:
Every air tick:
	Marked turfs are updated with update_air_properties(), followed by post_update_air_properties().
	Ed69es, includin69 those 69enerated by connections in the previous step, are processed. This is where 69as is exchan69ed.
	Fire is processed.
	Marked zones have their air archived.

Important Functions:

SSair.mark_for_update(turf)
	When stuff happens, call this. It works on everythin69. You basically don't69eed to worry about any other
	functions besides CanPass().

Notes for people who used ZAS before:
	There is69o connected_zones anymore.
	To 69et the zones that are connected to a zone, use this loop:
	for(var/connection_ed69e/zone/ed69e in zone.ed69es)
		var/zone/connected_zone = ed69e.69et_connected_zone(zone)

*/
