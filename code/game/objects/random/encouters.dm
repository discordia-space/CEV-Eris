#define DAMA69E_POWER_TRANSFER 450 //used to transfer power to containment field 69enerators
#define ENCOUTER_PROBALITY 100

/obj/spawner/encouter
	exclusion_paths = list(/obj/spawner/encouter)
	spawn_ta69s = SPAWN_TA69_SPAWNER_ENCOUNER
	ta69s_to_spawn = list(SPAWN_SPAWNER_ENCOUNER)

///////ENCOUTERS
//////////////////////

/obj/spawner/encouter/mine
	ta69s_to_spawn = list(SPAWN_MINE)

/obj/spawner/encouter/minin69bot
	allow_blacklist = TRUE
	ta69s_to_spawn = list(SPAWN_BOT_OS)

/obj/spawner/encouter/stran69ebeacon
	ta69s_to_spawn = list(SPAWN_STRAN69EBEACON)

/obj/spawner/encouter/cryopod
	ta69s_to_spawn = list(SPAWN_ENCOUNTER_CRYOPOD)

/obj/spawner/encouter/satellite
	ta69s_to_spawn = list(SPAWN_SATELITE)

/obj/spawner/encouter/coffin
	allow_blacklist = TRUE
	ta69s_to_spawn = list(SPAWN_CLOSET_COFFIN)

/obj/spawner/encouter/omnius
	ta69s_to_spawn = list(SPAWN_OMINOUS)

///////ENCOUTERS
//////////////////////

