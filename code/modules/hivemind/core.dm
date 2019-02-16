//Hivemind - is rogue AI, that use unknown nanotech
//Main goal of this machine is spread across the ship and annihilate so much stuff as he can
//We are actually don't know who created this ai, how much time it wanders in space or, maybe, any other way?
//We even don't know why this ai do it.


var/datum/hivemind/mind/hive_mind_ai

datum/hivemind/mind
	var/name
	var/surname
	var/evo_points = 0
	var/evo_points_max = 1000
	var/failure_chance = 55				//failure chance is lowers each 10 EP
	var/list/hives = list() 			//all functional hives stored here
	//i know, whitelist is bad, but it's required here
	var/list/restricted_machineries = list( /obj/machinery/light,					/obj/machinery/atmospherics,
											/obj/machinery/portable_atmospherics,	/obj/machinery/door,
											/obj/machinery/camera,					/obj/machinery/light_switch,
											/obj/machinery/disposal,				/obj/machinery/firealarm,
											/obj/machinery/alarm,					/obj/machinery/recharger,
											/obj/machinery/hologram,				/obj/machinery/holoposter,
											/obj/machinery/button,					/obj/machinery/ai_status_display,
											/obj/machinery/status_display,			/obj/machinery/requests_console,
											/obj/machinery/newscaster,				/obj/machinery/floor_light,
											/obj/machinery/nuclearbomb,				/obj/machinery/flasher,
											/obj/machinery/filler_object)
	//internals
	var/list/global_abilities_cooldown = list()
	var/list/EP_price_list = list()

	New()
		..()
		name = pick("Reworker", "Executor", "Annihilator",
					"Bugmerger", "Exploiter", "Builder", "Maker",
					"Connector", "Splicer", "Reproducer")

		surname = pick("ALPHA", "BETA", "GAMMA", "DELTA", "OMEGA", "UTOPIA",
						"SALVATION-X", "CHORUS", "ICARUS", "HEGEMONY", "HARMONY")
		var/list/all_machines = subtypesof(/obj/structure/hivemind_machine) - /obj/structure/hivemind_machine/node
		//price list building
		//here we create list with EP price to compare it at annihilation proc
		for(var/machine_path in all_machines)
			var/obj/structure/hivemind_machine/temporary_machine = new machine_path
			EP_price_list[machine_path] = temporary_machine.evo_points_required
			qdel(temporary_machine)
		message_admins("Hivemind [name] [surname] has been created.")


datum/hivemind/mind/proc/die()
	message_admins("Hivemind [name] [surname] is destroyed.")
	hive_mind_ai = null
	qdel(src)

datum/hivemind/mind/proc/get_points()
	if(evo_points < evo_points_max)
		evo_points++
		if(failure_chance > 10 && (evo_points % 10 == 0))
			failure_chance -= 1
