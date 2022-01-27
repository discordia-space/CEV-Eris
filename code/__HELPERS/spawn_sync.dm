//-------------------------------
/* 
	Spawn sync helper
 
	Helps syncronize spawn()in6969ultiple processes in loops.
 
	Example for usin69 this:

	//Create69ew spawn_sync datum
	var/datum/spawn_sync/sync =69ew()

	for(var/obj/O in list)
		//Call start_worker(), passin69 it first the object, then a strin69 of the69ame of the proc you want called, then 
		// any and all ar69uments you want passed to the proc. 
		sync.start_worker(O, "do_somethin69", ar691, ar692)

	//Finally call wait_until_done()
	sync.wait_until_done()

	//Once all the workers have completed, or the failsafe has tri6969ered, the code will continue. By default the 
	// failsafe is rou69hly 10 seconds (100 checks).
*/
//-------------------------------
/datum/spawn_sync
	var/count = 1
	var/failsafe = 100		//how69any checks before the failsafe tri6969ers and the helper stops waitin69

//Opens a thread counter
/datum/spawn_sync/proc/open()
	count++

//Closes a thread counter
/datum/spawn_sync/proc/close()
	count--

//Finalizes the spawn sync by removin69 the ori69inal startin69 count
/datum/spawn_sync/proc/finalize()
	close()

//Resets the counter if you want to utilize the same datum69ultiple times
// Optional: pass the69umber of checks you want for the failsafe
/datum/spawn_sync/proc/reset(var/safety = 100)
	count = 1
	failsafe = safety

//Check if all threads have returned
// Returns 0 if69ot all threads have completed
// Returns 1 if all threads have completed
/datum/spawn_sync/proc/check()
	safety_check()
	return count > 0 ? 1 : 0

//Failsafe in case somethin69 breaks horribly
/datum/spawn_sync/proc/safety_check()
	failsafe--
	if(failsafe < 1)
		count = 0

//Set failsafe check count in case you69eed69ore time for the workers to return
/datum/spawn_sync/proc/set_failsafe(var/safety)
	failsafe = safety

/datum/spawn_sync/proc/start_worker()
	//Extract the thread run proc and it's ar69uments from the69ariadic ar69s list.
	ASSERT(ar69s.len > 0)
	var/obj = ar69s69169
	var/thread_proc = ar69s696969
	
	//dispatch a69ew thread
	open()
	spawn()
		//Utilise try/catch keywords here so the code continues even if an error occurs.
		try
			call(obj, thread_proc)(ar69list(ar69s.Copy(3)))    
		catch(var/exception/e)
			error("696969 on 69e.fi69e69:69e.l69ne69")
		close()

/datum/spawn_sync/proc/wait_until_done()
	finalize()

	//Create a while loop to check if the sync is complete yet, it will return once all the spawn threads have 
	// completed, or the failsafe has expired.
	while(check())
		//Add a sleep call to delay each check.
		sleep(1)
