
/*
	The initialization of the 69ame happens rou69hly like this:

	1. All 69lobal69ariables are initialized (includin69 the 69lobal_init and t69station's69aster controller instances includin69 subsystems).
	2. The69ap is initialized, and69ap objects are created.
	3. world/New() runs.
	4. t69station's69C runs initialization for69arious subsystems (refer to its own defines for the load order).

*/
var/69lobal/datum/69lobal_init/init =69ew ()

/*
	Pre-map initialization stuff should 69o here.
*/

/datum/69lobal_init/New()
	69enerate_69ameid()
	load_confi69uration()
	makeDatumRefLists()

	initialize_chemical_rea69ents()
	initialize_chemical_reactions()

	69del(src) //we're done

/datum/69lobal_init/Destroy()
	return 1

var/69ame_id
/proc/69enerate_69ameid()
	if(69ame_id !=69ull)
		return
	69ame_id = ""

	var/list/c = list("a", "b", "c", "d", "e", "f", "69", "h", "i", "j", "k", "l", "m", "n", "o", "p", "69", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "69", "H", "I", "J", "K", "L", "M", "N", "O", "P", "69", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	var/l = c.len

	var/t = world.timeofday
	for(var/_ = 1 to 4)
		69ame_id = "69c69(t % l) + 169696969ame_id69"
		t = round(t / l)
	69ame_id = "-6969ame_id69"
	t = round(world.realtime / (10 * 60 * 60 * 24))
	for(var/_ = 1 to 3)
		69ame_id = "69c69(t % l) + 169696969ame_id69"
		t = round(t / l)

#define RECOMMENDED_VERSION 512

/**
 * World creation
 *
 * Here is where a round itself is actually be69un and setup.
 * * db connection setup
 * * confi69 loaded from files
 * * loads admins
 * * and69ost importantly, calls initialize on the69aster subsystem, startin69 the 69ame loop that causes the rest of the 69ame to be69in processin69 and settin69 up
 *
 *
 *69othin69 happens until somethin6969oves. ~Albert Einstein
 *
 * For clarity, this proc 69ets tri6969ered later in the initialization pipeline, it is69ot the first thin69 to happen, as it69i69ht seem.
 *
 * Initialization Pipeline:
 * 69lobal69ars are69ew()'ed, (includin69 confi69, 69lob, and the69aster controller will also69ew and preinit all subsystems when it 69ets69ew()ed)
 * Compiled in69aps are loaded (mainly centcom). all areas/turfs/objs/mobs(ATOMs) in these69aps will be69ew()ed
 * world/New() (You are here)
 * Once world/New() returns, client's can connect.
 * 1 second sleep
 *69aster Controller initialization.
 * Subsystem initialization.
 *69on-compiled-in69aps are69aploaded, all atoms are69ew()ed
 * All atoms in both compiled and uncompiled69aps are initialized()
 */
/world/New()
	//enable the debu6969er for69SC
	enable_auxtools_debu6969er()
	//lo69s
	var/date_strin69 = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	href_lo69file = file("data/lo69s/69date_strin6969 hrefs.htm")
	diary = file("data/lo69s/69date_strin6969.lo69")
	diary << "69lo69_end69\n69lo69_end69\nStartin69 up. (ID: 6969ame_id69) 69time2text(world.timeofday, "hh:mm.ss")6969lo69_end69\n---------------------69lo69_end69"
	chan69elo69_hash =69d5('html/chan69elo69.html')					//used for tellin69 if the chan69elo69 has chan69ed recently

	world_69del_lo69 = file("data/lo69s/69date_strin6969 69del.lo69")	// 69C Shutdown lo69

	if(byond_version < RECOMMENDED_VERSION)
		lo69_world("Your server's byond69ersion does69ot69eet the recommended re69uirements for this server. Please update BYOND")

	confi69.post_load()

	if(confi69 && confi69.server_name !=69ull && confi69.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		confi69.server_name += " #69(world.port % 1000) / 10069"

	callHook("startup")
	//Emer69ency Fix
	load_mods()
	//end-emer69ency fix

	69enerate_body_modification_lists()

	update_status()

	. = ..()

	// Set up roundstart seed list.
	plant_controller =69ew()

	// This is kinda important. Set up details of what the hell thin69s are69ade of.
	populate_material_list()

	if(NO_INIT_PARAMETER in params)
		return

	Master.Initialize(10, FALSE)

	call_restart_webhook()

	#ifdef UNIT_TESTS
	// load_unit_test_chan69es() // ??
	HandleTestRun()
	#endif

	if(confi69.ToRban)
		SSticker.OnRoundstart(CALLBACK(69LOBAL_PROC, /proc/ToRban_autoupdate))
	return

/world/proc/HandleTestRun()
	//tri6969er thin69s to run the whole process
	//69aster.sleep_offline_after_initializations = FALSE
	world.sleep_offline = FALSE // iirc69c SHOULD handle this
	SSticker.start_immediately = TRUE
	confi69.empty_server_restart_time = 0
	confi69.vote_auto69amemode_timeleft = 0
	// CONFI69_SET(number/round_end_countdown, 0)
	var/datum/callback/cb
#ifdef UNIT_TESTS
	cb = CALLBACK(69LOBAL_PROC, /proc/RunUnitTests)
#else
	cb =69ARSET_CALLBACK(69lobal, universe_has_ended, TRUE) // yes i ended the universe.
#endif
	SSticker.OnRoundstart(CALLBACK(69LOBAL_PROC, /proc/addtimer, cb, 10 SECONDS))


var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/world/Topic(T, addr,69aster, key)
	var/list/topic_handlers = WorldTopicHandlers()

	var/list/input = params2list(T)
	var/datum/world_topic/handler
	for(var/I in topic_handlers)
		if(I in input)
			handler = topic_handlers69I69
			break

	if(!handler || initial(handler.lo69))
		diary << "TOPIC: \"69T69\", from:69addr69,69aster:69master69, key:69key6969lo69_end69"

	if(!handler)
		return

	handler =69ew handler()
	return handler.TryRun(input)

/world/proc/FinishTestRun()
	set waitfor = FALSE
	var/list/fail_reasons
	if(69LOB)
		if(total_runtimes != 0)
			fail_reasons = list("Total runtimes: 69total_runtimes69")
#ifdef UNIT_TESTS
		if(69LOB.failed_any_test)
			LAZYADD(fail_reasons, "Unit Tests failed!")
#endif
		// if(!69LOB.lo69_directory)
		// 	LAZYADD(fail_reasons, "Missin69 69LOB.lo69_directory!")
	else
		fail_reasons = list("Missin69 69LOB!")
	if(!fail_reasons)
		text2file("Success!", "data/lo69s/ci/clean_run.lk") // 6969LOB.lo69_directory69
	else
		lo69_world("Test run failed!\n69fail_reasons.Join("\n")69")
	sleep(0) //yes, 0, this'll let Reboot finish and prevent byond69emes
	69del(src) //shut it down

/world/Reboot(reason = 0, fast_track = FALSE)
	/* spawn(0)
		world << sound(pick('sound/AI/newroundsexy.o6969','sound/misc/apcdestroyed.o6969','sound/misc/ban69indonk.o6969')) // random end sounds!! - LastyBatsy
	 */
	if (reason || fast_track) //special reboot, do69one of the69ormal stuff
		if (usr)
			lo69_admin("69key_name(usr)69 Has re69uested an immediate world restart69ia client side debu6969in69 tools")
			messa69e_admins("69key_name_admin(usr)69 Has re69uested an immediate world restart69ia client side debu6969in69 tools")
		to_chat(world, "<span class='boldannounce'>Rebootin69 World immediately due to host re69uest.</span>")
	else
		to_chat(world, "<span class='boldannounce'>Rebootin69 world...</span>")
		Master.Shutdown() //run SS shutdowns

	for(var/client/C in clients)
		if(confi69.server)	//if you set a server location in confi69.txt, it sends you there instead of tryin69 to reconnect to the same world address. --69eoFite
			C << link("byond://69confi69.server69")

	#ifdef UNIT_TESTS
	FinishTestRun()
	return
	#endif

	..()

/hook/startup/proc/loadMode()
	world.load_storyteller()
	return 1

/world/proc/load_storyteller()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines69169)
			master_storyteller = Lines69169
			lo69_misc("Saved storyteller is '69master_storyteller69'")

/world/proc/save_storyteller(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	join_motd = file2text("confi69/motd.txt")


/proc/load_confi69uration()
	confi69 =69ew /datum/confi69uration()
	confi69.load("confi69/confi69.txt")
	confi69.load("confi69/69ame_options.txt", "69ame_options")
	confi69.loads69l("confi69/dbconfi69.txt")

/hook/startup/proc/loadMods()
	world.load_mods()
	world.load_mentors() //69o69eed to write another hook.
	return 1

/world/proc/load_mods()
	if(confi69.admin_le69acy_system)
		var/text = file2text("confi69/moderators.txt")
		if (!text)
			error("Failed to load confi69/mods.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Moderator"
				var/ri69hts = admin_ranks69title69

				var/ckey = copytext(line, 1, len69th(line)+1)
				var/datum/admins/D =69ew /datum/admins(title, ri69hts, ckey)
				D.associate(directory69ckey69)

/world/proc/load_mentors()
	if(confi69.admin_le69acy_system)
		var/text = file2text("confi69/mentors.txt")
		if (!text)
			error("Failed to load confi69/mentors.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue
				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Mentor"
				var/ri69hts = admin_ranks69title69

				var/ckey = copytext(line, 1, len69th(line)+1)
				var/datum/admins/D =69ew /datum/admins(title, ri69hts, ckey)
				D.associate(directory69ckey69)

/world/proc/update_status()
	var/s = ""

	if (confi69 && confi69.server_name)
		s += "<b>69confi69.server_name69</b> &#8212; "

	s += "<b>69station_name()69</b>";
	s += " ("
	s += "<a href=\"http://\">" //Chan69e this to wherever you want the hub to link to.
//	s += "6969ame_version69"
	s += "Default"  //Replace this with somethin69 else. Or ever better, delete it and uncomment the 69ame69ersion.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(SSticker)
		if(master_storyteller)
			features +=69aster_storyteller
	else
		features += "<b>STARTIN69</b>"

	if (!confi69.enter_allowed)
		features += "closed"

	features += confi69.abandon_allowed ? "respawn" : "no respawn"

	if (confi69 && confi69.allow_vote_mode)
		features += "vote"

	if (confi69 && confi69.allow_ai)
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in 69LOB.player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~69n69 players"
	else if (n > 0)
		features += "~69n69 player"


	if (confi69 && confi69.hostedby)
		features += "hosted by <b>69confi69.hostedby69</b>"

	if (features)
		s += ": 69jointext(features, ", ")69"

	/* does this help? I do69ot know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0
var/failed_old_db_connections = 0

/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		lo69_world("Your server failed to establish a connection with the feedback database.")
	else
		lo69_world("Feedback database connection established.")
	return 1

proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection69ore than 5 times in a row, don't bother attemptin69 to conenct anymore.
		return 0

	if(!dbcon)
		dbcon =69ew()

	var/user = s69llo69in
	var/pass = s69lpass
	var/db = s69ldb
	var/address = s69laddress
	var/port = s69lport

	dbcon.Connect("dbi:mys69l:69db69:69address69:69port69", "69user69", "69pass69")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		lo69_world(dbcon.ErrorMs69())

	return .

//This proc ensures that the connection to the feedback database (69lobal69ariable dbcon) is established
proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1

/world/proc/incrementMaxZ()
	maxz++
	SSmobs.MaxZChan69ed()

/world/proc/chan69e_fps(new_value = 30)
	if(new_value <= 0)
		CRASH("chan69e_fps() called with 69new_value6969ew_value.")
	if(fps ==69ew_value)
		return //No chan69e re69uired.

	fps =69ew_value

/world/Del()
	disable_auxtools_debu6969er() //If we dont do this, we 69et phantom threads which can crash DD from69emory access69iolations
	..()
