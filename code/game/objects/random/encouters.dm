#define DAMAGE_POWER_TRANSFER 450 //used to transfer power to containment field generators
#define ENCOUTER_PROBALITY 100

/obj/random/encouter
	spawn_nothing_percentage = 0
	var/list/obj/random/spawner/encouter/encouters = list(/obj/random/spawner/encouter/mine, /obj/spawner/encouter/miningbot, /obj/spawner/encouter/strangebeacon, \
	/obj/spawner/encouter/cryopod, /obj/spawner/encouter/cryopod, /obj/random/spawner/encouter/coffin, /obj/spawner/encouter/omnius)

/obj/random/encouter/item_to_spawn()
	..()
	return pick(encouters)


///////ENCOUTERS
//////////////////////

/obj/random/spawner/encouter
	spawn_nothing_percentage = 0
	var/justspawn = TRUE
	var/list/obj/randspawn = list()

/obj/random/spawner/encouter/item_to_spawn()
	..()
	if(justspawn == TRUE)
		return pick(randspawn)

/obj/random/spawner/encouter/mine
	randspawn = list(/obj/structure/mine/mine_no_primer, /obj/item/weapon/mine, /obj/structure/mine/mine_scraps)

/obj/spawner/encouter/miningbot
	allow_blacklist = TRUE
	tags_to_spawn = list(SPAWN_BOT_OS)

/obj/spawner/encouter/strangebeacon
	tags_to_spawn = list(SPAWN_STRANGEBEACON)

/obj/spawner/encouter/cryopod
	tags_to_spawn = list(SPAWN_ENCOUNTER_CRYOPOD)

/obj/spawner/encouter/satellite
	tags_to_spawn = list(SPAWN_SATELITE)

/obj/random/spawner/encouter/coffin
	randspawn = list(/obj/structure/closet/coffin/spawnercorpse)

/obj/spawner/encouter/omnius
	tags_to_spawn = list(SPAWN_OMINOUS)

///////ENCOUTERS
//////////////////////

