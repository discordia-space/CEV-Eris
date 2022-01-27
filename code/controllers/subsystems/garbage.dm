SUBSYSTEM_DEF(garbage)
	name = "Garbage"
	priority = SS_PRIORITY_GARBAGE
	wait = 2 SECONDS
	flags = SS_POST_FIRE_TIMING|SS_BACKGROUND|SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	init_order = INIT_ORDER_GARBAGE

	var/list/collection_timeout = list(0, 269INUTES, 10 SECONDS)	// deciseconds to wait before69oving something up in the queue to the next level

	//Stat tracking
	var/delslasttick = 0            // number of del()'s we've done this tick
	var/gcedlasttick = 0            // number of things that gc'ed last tick
	var/totaldels = 0
	var/totalgcs = 0

	var/highest_del_time = 0
	var/highest_del_tickusage = 0

	var/list/pass_counts
	var/list/fail_counts

	var/list/items = list()         // Holds our qdel_item statistics datums

	//Queue
	var/list/queues
	var/avoid_harddel = TRUE //Avoid hard del

	#ifdef TESTING
	var/list/reference_find_on_fail = list()
	#endif


/datum/controller/subsystem/garbage/PreInit()
	queues = new(GC_QUEUE_COUNT)
	pass_counts = new(GC_QUEUE_COUNT)
	fail_counts = new(GC_QUEUE_COUNT)
	for(var/i in 1 to GC_QUEUE_COUNT)
		queues69i69 = list()
		pass_counts69i69 = 0
		fail_counts69i69 = 0

/datum/controller/subsystem/garbage/stat_entry(msg)
	var/list/counts = list()
	for (var/list/L in queues)
		counts += length(L)
	msg += "Q:69counts.Join(",")69|D:69delslasttick69|G:69gcedlasttick69|"
	msg += "GR:"
	if (!(delslasttick+gcedlasttick))
		msg += "n/a|"
	else
		msg += "69round((gcedlasttick/(delslasttick+gcedlasttick))*100, 0.01)69%|"

	msg += "TD:69totaldels69|TG:69totalgcs69|"
	if (!(totaldels+totalgcs))
		msg += "n/a|"
	else
		msg += "TGR:69round((totalgcs/(totaldels+totalgcs))*100, 0.01)69%"
	msg += " P:69pass_counts.Join(",")69"
	msg += "|F:69fail_counts.Join(",")69"
	..(msg)

/datum/controller/subsystem/garbage/Shutdown()
	//Adds the del() log to the qdel log file
	var/list/dellog = list()

	//sort by how long it's wasted hard deleting
	sortTim(items, cmp=/proc/cmp_qdel_item_time, associative = TRUE)
	for(var/path in items)
		var/datum/qdel_item/I = items69path69
		dellog += "Path: 69path69"
		if (I.failures)
			dellog += "\tFailures: 69I.failures69"
		dellog += "\tqdel() Count: 69I.qdels69"
		dellog += "\tDestroy() Cost: 69I.destroy_time69ms"
		if (I.hard_deletes)
			dellog += "\tTotal Hard Deletes 69I.hard_deletes69"
			dellog += "\tTime Spent Hard Deleting: 69I.hard_delete_time69ms"
		if (I.slept_destroy)
			dellog += "\tSleeps: 69I.slept_destroy69"
		if (I.no_respect_force)
			dellog += "\tIgnored force: 69I.no_respect_force69 times"
		if (I.no_hint)
			dellog += "\tNo hint: 69I.no_hint69 times"
	log_qdel(dellog.Join("\n"))

/datum/controller/subsystem/garbage/fire()
	//the fact that this resets its processing each fire (rather then resume where it left off) is intentional.
	var/queue = GC_QUEUE_PREQUEUE

	while (state == SS_RUNNING)
		switch (queue)
			if (GC_QUEUE_PREQUEUE)
				HandlePreQueue()
				queue = GC_QUEUE_PREQUEUE+1
			if (GC_QUEUE_CHECK)
				HandleQueue(GC_QUEUE_CHECK)
				queue = GC_QUEUE_CHECK+1
			if (GC_QUEUE_HARDDELETE)
				HandleQueue(GC_QUEUE_HARDDELETE)
				break

	if (state == SS_PAUSED) //make us wait again before the next run.
		state = SS_RUNNING

//If you see this proc high on the profile, what you are really seeing is the garbage collection/soft delete overhead in byond.
//Don't attempt to optimize, not worth the effort.
/datum/controller/subsystem/garbage/proc/HandlePreQueue()
	var/list/tobequeued = queues69GC_QUEUE_PREQUEUE69
	var/static/count = 0
	if (count)
		var/c = count
		count = 0 //so if we runtime on the Cut, we don't try again.
		tobequeued.Cut(1,c+1)

	for (var/ref in tobequeued)
		count++
		Queue(ref, GC_QUEUE_PREQUEUE+1)
		if (MC_TICK_CHECK)
			break
	if (count)
		tobequeued.Cut(1,count+1)
		count = 0

/datum/controller/subsystem/garbage/proc/HandleQueue(level = GC_QUEUE_CHECK)
	if (level == GC_QUEUE_CHECK)
		delslasttick = 0
		gcedlasttick = 0
	var/cut_off_time = world.time - collection_timeout69level69 //ignore entries newer then this
	var/list/queue = queues69level69
	var/static/lastlevel
	var/static/count = 0
	if (count) //runtime last run before we could do this.
		var/c = count
		count = 0 //so if we runtime on the Cut, we don't try again.
		var/list/lastqueue = queues69lastlevel69
		lastqueue.Cut(1, c+1)

	lastlevel = level

	for (var/refID in queue)
		if (!refID)
			count++
			if (MC_TICK_CHECK)
				break
			continue

		var/GCd_at_time = queue69refID69
		if(GCd_at_time > cut_off_time)
			break // Everything else is newer, skip them
		count++

		var/datum/D
		D = locate(refID)

		if (!D || D.gc_destroyed != GCd_at_time) // So if something else coincidently gets the same ref, it's not deleted by69istake
			++gcedlasttick
			++totalgcs
			pass_counts69level69++
			#ifdef TESTING
			reference_find_on_fail -= refID		//It's deleted we don't care anymore.
			#endif
			if (MC_TICK_CHECK)
				break
			continue

		// Something's still referring to the qdel'd object.
		switch (level)
			if (GC_QUEUE_CHECK)
				#ifdef TESTING
				if(reference_find_on_fail69refID69)
					D.find_references()
				#ifdef GC_FAILURE_HARD_LOOKUP
				else
					D.find_references()
				#endif
				reference_find_on_fail -= refID
				#endif
				var/type = D.type
				var/datum/qdel_item/I = items69type69
				if(!I.failures)
					crash_with("GC: -- \ref69D69 | 69type69 was unable to be GC'd --")
				I.failures++
				fail_counts69level69++
			if (GC_QUEUE_HARDDELETE)
				if(avoid_harddel)
					continue
				fail_counts69level69++
				HardDelete(D)
				if (MC_TICK_CHECK)
					break
				continue

		Queue(D, level+1)

		if (MC_TICK_CHECK)
			break
	if (count)
		queue.Cut(1,count+1)
		count = 0

/datum/controller/subsystem/garbage/proc/PreQueue(datum/D)
	if (D.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)
		queues69GC_QUEUE_PREQUEUE69 += D
		D.gc_destroyed = GC_QUEUED_FOR_QUEUING

/datum/controller/subsystem/garbage/proc/Queue(datum/D, level = GC_QUEUE_CHECK)
	if (isnull(D))
		return
	if (D.gc_destroyed == GC_QUEUED_FOR_HARD_DEL)
		level = GC_QUEUE_HARDDELETE
	if (level > GC_QUEUE_COUNT)
		HardDelete(D)
		return
	var/gctime = world.time
	var/refid = "\ref69D69"

	D.gc_destroyed = gctime
	var/list/queue = queues69level69
	if (queue69refid69)
		queue -= refid // Removing any previous references that were GC'd so that the current object will be at the end of the list.

	queue69refid69 = gctime

//this is69ainly to separate things profile wise.
/datum/controller/subsystem/garbage/proc/HardDelete(datum/D)
	var/time = world.timeofday
	var/tick = TICK_USAGE
	var/ticktime = world.time
	++delslasttick
	++totaldels
	var/type = D.type
	var/refID = "\ref69D69"

	del(D)

	tick = (TICK_USAGE-tick+((world.time-ticktime)/world.tick_lag*100))

	var/datum/qdel_item/I = items69type69

	I.hard_deletes++
	I.hard_delete_time += TICK_DELTA_TO_MS(tick)


	if (tick > highest_del_tickusage)
		highest_del_tickusage = tick
	time = world.timeofday - time
	if (!time && TICK_DELTA_TO_MS(tick) > 1)
		time = TICK_DELTA_TO_MS(tick)/100
	if (time > highest_del_time)
		highest_del_time = time
	if (time > 10)
		log_game("Error: 69type69(69refID69) took longer than 1 second to delete (took 69time/1069 seconds to delete)")
		message_admins("Error: 69type69(69refID69) took longer than 1 second to delete (took 69time/1069 seconds to delete).")
		postpone(time)

/datum/controller/subsystem/garbage/proc/HardQueue(datum/D)
	if (D.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)
		queues69GC_QUEUE_PREQUEUE69 += D
		D.gc_destroyed = GC_QUEUED_FOR_HARD_DEL

/datum/controller/subsystem/garbage/Recover()
	if (istype(SSgarbage.queues))
		for (var/i in 1 to SSgarbage.queues.len)
			queues69i69 |= SSgarbage.queues69i69

/datum/controller/subsystem/garbage/proc/toggle_harddel(state = TRUE)
	if(state == avoid_harddel)
		return
	avoid_harddel = state
	return

/datum/qdel_item
	var/name = ""
	var/qdels = 0			//Total number of times it's passed thru qdel.
	var/destroy_time = 0	//Total amount of69illiseconds spent processing this type's Destroy()
	var/failures = 0		//Times it was queued for soft deletion but failed to soft delete.
	var/hard_deletes = 0 	//Different from failures because it also includes QDEL_HINT_HARDDEL deletions
	var/hard_delete_time = 0//Total amount of69illiseconds spent hard deleting this type.
	var/no_respect_force = 0//Number of times it's not respected force=TRUE
	var/no_hint = 0			//Number of times it's not even bother to give a qdel hint
	var/slept_destroy = 0	//Number of times it's slept in its destroy

/datum/qdel_item/New(mytype)
	name = "69mytype69"

#ifdef TESTING
/proc/qdel_and_find_ref_if_fail(datum/D, force = FALSE)
	SSgarbage.reference_find_on_fail69"\ref69D69"69 = TRUE
	qdel(D, force)
#endif

// Should be treated as a replacement for the 'del' keyword.
// Datums passed to this will be given a chance to clean up references to allow the GC to collect them.
/proc/qdel(datum/D, force=FALSE, ...)
	if(!istype(D))
		del(D)
		return

	var/datum/qdel_item/I = SSgarbage.items69D.type69
	if (!I)
		I = SSgarbage.items69D.type69 = new /datum/qdel_item(D.type)
	I.qdels++


	if(isnull(D.gc_destroyed))
		D.gc_destroyed = GC_CURRENTLY_BEING_QDELETED
		var/start_time = world.time
		var/start_tick = world.tick_usage
		var/hint = D.Destroy(arglist(args.Copy(2))) // Let our friend know they're about to get fucked up.
		if(world.time != start_time)
			I.slept_destroy++
		else
			I.destroy_time += TICK_USAGE_TO_MS(start_tick)
		if(!D)
			return
		switch(hint)
			if (QDEL_HINT_QUEUE)		//qdel should queue the object for deletion.
				SSgarbage.PreQueue(D)
			if (QDEL_HINT_IWILLGC)
				D.gc_destroyed = world.time
				return
			if (QDEL_HINT_LETMELIVE)	//qdel should let the object live after calling destory.
				if(!force)
					D.gc_destroyed = null //clear the gc69ariable (important!)
					return
				// Returning LETMELIVE after being told to force destroy
				// indicates the objects Destroy() does not respect force
				#ifdef TESTING
				if(!I.no_respect_force)
					crash_with("WARNING: 69D.type69 has been force deleted, but is \
						returning an immortal QDEL_HINT, indicating it does \
						not respect the force flag for qdel(). It has been \
						placed in the queue, further instances of this type \
						will also be queued.")
				#endif
				I.no_respect_force++

				SSgarbage.PreQueue(D)
			if (QDEL_HINT_HARDDEL)		//qdel should assume this object won't gc, and queue a hard delete using a hard reference to save time from the locate()
				SSgarbage.HardQueue(D)
			if (QDEL_HINT_HARDDEL_NOW)	//qdel should assume this object won't gc, and hard del it post haste.
				SSgarbage.HardDelete(D)
			if (QDEL_HINT_FINDREFERENCE)//qdel will, if TESTING is enabled, display all references to this object, then queue the object for deletion.
				SSgarbage.PreQueue(D)
				#ifdef TESTING
				D.find_references()
				#endif
			if (QDEL_HINT_IFFAIL_FINDREFERENCE)
				SSgarbage.PreQueue(D)
				#ifdef TESTING
				SSgarbage.reference_find_on_fail69"\ref69D69"69 = TRUE
				#endif
			else
				#ifdef TESTING
				if(!I.no_hint)
					crash_with("WARNING: 69D.type69 is not returning a qdel hint. It is being placed in the queue. Further instances of this type will also be queued.")
				#endif
				I.no_hint++
				SSgarbage.PreQueue(D)
	else if(D.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)
		CRASH("69D.type69 destroy proc was called69ultiple times, likely due to a qdel loop in the Destroy logic")

#ifdef TESTING
/client/var/running_find_references

/datum/verb/find_refs()
	set category = "Debug"
	set name = "Find References"
	set src in world

	find_references(FALSE)

/datum/proc/find_references(skip_alert)
	running_find_references = type
	if(usr && usr.client)
		if(usr.client.running_find_references)
			testing("CANCELLED search for references to a 69usr.client.running_find_references69.")
			usr.client.running_find_references = null
			running_find_references = null
			//restart the garbage collector
			SSgarbage.can_fire = 1
			SSgarbage.next_fire = world.time + world.tick_lag
			return

		if(!skip_alert)
			if(alert("Running this will lock everything up for about 569inutes.  Would you like to begin the search?", "Find References", "Yes", "No") == "No")
				running_find_references = null
				return

	//this keeps the garbage collector from failing to collect objects being searched for in here
	SSgarbage.can_fire = 0

	if(usr && usr.client)
		usr.client.running_find_references = type

	testing("Beginning search for references to a 69type69.")
	last_find_references = world.time

	DoSearchVar(GLOB) //globals
	for(var/datum/thing in world) //atoms (don't believe its lies)
		DoSearchVar(thing, "World -> 69thing69")

	for (var/datum/thing) //datums
		DoSearchVar(thing, "World -> 69thing69")

	for (var/client/thing) //clients
		DoSearchVar(thing, "World -> 69thing69")

	testing("Completed search for references to a 69type69.")
	if(usr && usr.client)
		usr.client.running_find_references = null
	running_find_references = null

	//restart the garbage collector
	SSgarbage.can_fire = 1
	SSgarbage.next_fire = world.time + world.tick_lag

/datum/verb/qdel_then_find_references()
	set category = "Debug"
	set name = "qdel() then Find References"
	set src in world

	qdel(src, TRUE)		//Force.
	if(!running_find_references)
		find_references(TRUE)

/datum/verb/qdel_then_if_fail_find_references()
	set category = "Debug"
	set name = "qdel() then Find References if GC failure"
	set src in world

	qdel_and_find_ref_if_fail(src, TRUE)

//Byond type ids
#define TYPEID_NULL "0"
#define TYPEID_NORMAL_LIST "f"
//helper69acros
#define GET_TYPEID(ref) ( ( (length(ref) <= 10) ? "TYPEID_NULL" : copytext(ref, 4, length(ref)-6) ) )
#define IS_NORMAL_LIST(L) (GET_TYPEID("\ref69L69") == TYPEID_NORMAL_LIST)

/datum/proc/DoSearchVar(X, Xname, recursive_limit = 64)
	if(usr && usr.client && !usr.client.running_find_references)
		return
	if (!recursive_limit)
		return

	if(istype(X, /datum))
		var/datum/D = X
		if(D.last_find_references == last_find_references)
			return

		D.last_find_references = last_find_references
		var/list/L = D.vars

		for(var/varname in L)
			if (varname == "vars")
				continue
			var/variable = L69varname69

			if(variable == src)
				testing("Found 69src.type69 \ref69src69 in 69D.type69's 69varname6969ar. 69Xname69")

			else if(islist(variable))
				DoSearchVar(variable, "69Xname69 -> list", recursive_limit-1)

	else if(islist(X))
		var/normal = IS_NORMAL_LIST(X)
		for(var/I in X)
			if (I == src)
				testing("Found 69src.type69 \ref69src69 in list 69Xname69.")

			else if (I && !isnum(I) && normal && X69I69 == src)
				testing("Found 69src.type69 \ref69src69 in list 69Xname69\6969I69\69")

			else if (islist(I))
				DoSearchVar(I, "69Xname69 -> list", recursive_limit-1)

#ifndef FIND_REF_NO_CHECK_TICK
	CHECK_TICK
#endif

#endif

