//The Hivemind is a rogue AI using nanites.
//The objective of this AI is to spread across the ship and destroy as much as possible.

#define HIVE_FACTION 			"hive"
#define MAX_NODES_AMOUNT 	10
#define MIN_NODES_RANGE		15
#define ishivemindmob(A) 	istype(A, /mob/living/simple_animal/hostile/hivemind)

var/datum/hivemind/hive_mind_ai

/datum/hivemind
	var/name
	var/surname
	var/evo_points = 0
	var/evo_points_max = 1000
	var/evo_level = 0					//level of hivemind in general. This is our progress of EP, since they are resets after new node creation
	var/failure_chance = 25				//how often will be created dummy machines. This chance reduces by 1 each 10 EP //Changed from 45 to 25 -Wouju
	var/list/hives = list() 			//all functional hives stored here
	//i know, whitelist is bad, but it's required here
	var/list/restricted_machineries = list( /obj/machinery/light,			/obj/machinery/atmospherics,
						/obj/machinery/door,			/obj/machinery/meter,
						/obj/machinery/camera,			/obj/machinery/light_switch,	/obj/machinery/firealarm,
						/obj/machinery/alarm,			/obj/machinery/recharger,
						/obj/machinery/hologram,		/obj/machinery/holoposter,
						/obj/machinery/button,			/obj/machinery/status_display,
						/obj/machinery/floor_light,		/obj/machinery/flasher,
						/obj/machinery/filler_object,		/obj/machinery/hivemind_machine,
						/obj/machinery/cryopod,			/obj/machinery/portable_atmospherics/hydroponics/soil,
						/obj/machinery/power/supermatter,	/obj/machinery/portable_atmospherics/canister)

	var/list/global_abilities_cooldown = list()
	var/list/EP_price_list = list()

// more names would be interesting. It's just names afterall so nothing game changing
/datum/hivemind/New(_name, _surname)
	..()
	name	= _name		? _name		: pick(GLOB.hive_names)
	surname	= _surname	? _surname	: pick(GLOB.hive_surnames)

	var/list/all_machines = subtypesof(/obj/machinery/hivemind_machine) - /obj/machinery/hivemind_machine/node
	//price list building
	//here we create list with EP price to compare it at annihilation proc
	for(var/machine_path in all_machines)
		var/obj/machinery/hivemind_machine/temporary_machine = new machine_path
		EP_price_list[machine_path] = list("level" = temporary_machine.evo_level_required, "weight" = temporary_machine.spawn_weight)
		qdel(temporary_machine)
	message_admins("Hivemind [name] [surname] has been created.")


/datum/hivemind/proc/die()
	message_admins("Hivemind [name] [surname] is destroyed.")
	hive_mind_ai = null
	qdel(src)
	level_eight_beta_announcement()

/datum/hivemind/proc/get_points()
	if(evo_points < evo_points_max)
		evo_points += 1/hives.len
		if(failure_chance > 10 && (evo_points % 10 == 0))
			failure_chance -= 1

/datum/hivemind/proc/level_up()
	evo_points = 0
	if(evo_level < hives.len)
		evo_level++
	if(failure_chance <= 70)
		failure_chance += 10
