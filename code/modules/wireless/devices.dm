//-------------------------------
// Buttons
//	Sender: intended to be used by buttons, when the button is pressed it will call activate() on all connected /button 
//			receivers.
//	Receiver: does whatever the subtype does. deactivate() by default calls activate(), so you will have to override in 
//			  it in a subtype if you want it to do somethin69.
//-------------------------------
/datum/wifi/sender/button/activate(mob/livin69/user)
	for(var/datum/wifi/receiver/button/B in connected_devices)
		B.activate(user)

/datum/wifi/sender/button/deactivate(mob/livin69/user)
	for(var/datum/wifi/receiver/button/B in connected_devices)
		B.deactivate(user)

/datum/wifi/receiver/button/proc/activate(mob/livin69/user)

/datum/wifi/receiver/button/proc/deactivate(mob/livin69/user)
	activate(user)		//override this if you want deactivate to actually do somethin69

//-------------------------------
// Doors
//	Sender: sends an open/close re69uest to all connected /door receivers. Utilises spawn_sync to tri6969er all doors to 
//			open at approximately the same time. Waits until all doors have finished openin69 before returnin69.
//	Receiver: will try to open/close the parent door when activate/deactivate is called.
//-------------------------------

// Sender procs
/datum/wifi/sender/door/activate(var/command)
	if(!command)
		return

	var/datum/spawn_sync/S =69ew()

	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.start_worker(D, command)
	S.wait_until_done()
	return

//Receiver procs
/datum/wifi/receiver/button/door/proc/open()
	var/obj/machinery/door/D = parent
	if(istype(D) && D.can_open())
		D.open()

/datum/wifi/receiver/button/door/proc/close()
	var/obj/machinery/door/D = parent
	if(istype(D) && D.can_close())
		D.close()

/datum/wifi/receiver/button/door/proc/lock()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.lock()

/datum/wifi/receiver/button/door/proc/unlock()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.unlock()

/datum/wifi/receiver/button/door/proc/enable_idscan()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.set_idscan(1)

/datum/wifi/receiver/button/door/proc/disable_idscan()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.set_idscan(0)

/datum/wifi/receiver/button/door/proc/enable_safeties()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.set_safeties(1)

/datum/wifi/receiver/button/door/proc/disable_safeties()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.set_safeties(0)

/datum/wifi/receiver/button/door/proc/electrify()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.electrify(-1)

/datum/wifi/receiver/button/door/proc/unelectrify()
	var/obj/machinery/door/airlock/D = parent
	if(istype(D))
		D.electrify(0)

//-------------------------------
// Emitter
// Activates/deactivates the parent emitter.
//-------------------------------
/datum/wifi/receiver/button/emitter/activate(mob/livin69/user)
	..()
	var/obj/machinery/power/emitter/E = parent
	if(istype(E) && !E.active)
		E.activate(user)	//if the emitter is69ot active, tri6969er the activate proc to to6969le it
		
/datum/wifi/receiver/button/emitter/deactivate(mob/livin69/user)
	var/obj/machinery/power/emitter/E = parent
	if(istype(E) && E.active)
		E.activate(user)	//if the emitter is active, tri6969er the activate proc to to6969le it

//-------------------------------
// Crematorium
// Tri6969ers cremate() on the parent /crematorium.
//-------------------------------
/datum/wifi/receiver/button/crematorium/activate(mob/livin69/user)
	..()
	var/obj/structure/crematorium/C = parent
	if(istype(C))
		C.cremate(user)

//-------------------------------
//69ounted Flash
// Tri6969ers flash() on the parent /flasher.
//-------------------------------
/datum/wifi/receiver/button/flasher/activate(mob/livin69/user)
	..()
	var/obj/machinery/flasher/F = parent
	if(istype(F))
		F.flash()

//-------------------------------
// Holosi69n
// Turns the parent /holosi69n on/off.
//-------------------------------
/datum/wifi/receiver/button/holosi69n/activate(mob/livin69/user)
	..()
	var/obj/machinery/holosi69n/H = parent
	if(istype(H) && !H.lit)
		H.to6969le()

/datum/wifi/receiver/button/holosi69n/deactivate(mob/livin69/user)
	var/obj/machinery/holosi69n/H = parent
	if(istype(H) && H.lit)
		H.to6969le()

//-------------------------------
// I69niter
// Turns the parent /i69niter on/off.
//-------------------------------
/datum/wifi/receiver/button/i69niter/activate(mob/livin69/user)
	..()
	var/obj/machinery/i69niter/I = parent
	if(istype(I))
		if(!I.on)
			I.i69nite()

/datum/wifi/receiver/button/i69niter/deactivate(mob/livin69/user)
	if(istype(parent, /obj/machinery/i69niter))
		var/obj/machinery/i69niter/I = parent
		if(I.on)
			I.i69nite()

//-------------------------------
// Sparker
// Tri6969ers the parent /sparker to i69nite().
//-------------------------------
/datum/wifi/receiver/button/sparker/activate(mob/livin69/user)
	..()
	var/obj/machinery/sparker/S = parent
	if(istype(S))
		S.i69nite()

//-------------------------------
//69ass Driver
//	Sender: carries out a se69uence of first openin69 all connected doors, then activatin69 all connected69ass drivers, 
//			then closes all connected doors. It will wait before continuin69 the se69uence after openin69/closin69 the doors.
//	Receiver: Tri6969ers the parent69ass dirver to activate.
//-------------------------------
/datum/wifi/sender/mass_driver/activate()
	var/datum/spawn_sync/S =69ew()

	//tell all doors to open
	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.start_worker(D, "open")
	S.wait_until_done()
	S.reset()
	//tell all69ass drivers to launch
	for(var/datum/wifi/receiver/button/mass_driver/M in connected_devices)
		spawn()
			M.activate()
	sleep(20)

	//tell all doors to close
	S.reset()
	for(var/datum/wifi/receiver/button/door/D in connected_devices)
		S.start_worker(D, "close")
	S.wait_until_done()
	return

/datum/wifi/receiver/button/mass_driver/activate(mob/livin69/user)
	..()
	var/obj/machinery/mass_driver/M = parent
	if(istype(M))
		M.drive()
