//Sound environment defines. Reverb preset for sounds played in an area, see sound datum reference for more.
#define GENERIC 0
#define PADDED_CELL 1
#define ROOM 2
#define BATHROOM 3
#define LIVINGROOM 4
#define STONEROOM 5
#define AUDITORIUM 6
#define CONCERT_HALL 7
#define CAVE 8
#define ARENA 9
#define HANGAR 10
#define CARPETED_HALLWAY 11
#define HALLWAY 12
#define STONE_CORRIDOR 13
#define ALLEY 14
#define FOREST 15
#define CITY 16
#define MOUNTAINS 17
#define QUARRY 18
#define PLAIN 19
#define PARKING_LOT 20
#define SEWER_PIPE 21
#define UNDERWATER 22
#define DRUGGED 23
#define DIZZY 24
#define PSYCHOTIC 25

#define STANDARD_STATION STONEROOM
#define LARGE_ENCLOSED HANGAR
#define SMALL_ENCLOSED BATHROOM
#define TUNNEL_ENCLOSED CAVE
#define LARGE_SOFTFLOOR CARPETED_HALLWAY
#define MEDIUM_SOFTFLOOR LIVINGROOM
#define SMALL_SOFTFLOOR ROOM
#define ASTEROID CAVE
#define SPACE UNDERWATER

var/list/shatter_sound = list(
	'sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg'
)
var/list/explosion_sound = list('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg')
var/list/spark_sound = list(
	'sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg',
	'sound/effects/sparks4.ogg'
)
var/list/rustle_sound = list(
	'sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg',
	'sound/effects/rustle4.ogg','sound/effects/rustle5.ogg'
)
var/list/punch_sound = list(
	'sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'
)
var/list/clown_sound = list('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
var/list/swing_hit_sound = list(
	'sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'
)
var/list/hiss_sound = list(
	'sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg'
)
var/list/page_sound = list(
	'sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg'
)
var/list/keyboard_sound = list (
	'sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg',
	'sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg'
)
var/list/robot_talk_heavy_sound = list (
	'sound/machines/robots/robot_talk_heavy1.ogg','sound/machines/robots/robot_talk_heavy2.ogg',
	'sound/machines/robots/robot_talk_heavy3.ogg','sound/machines/robots/robot_talk_heavy4.ogg'
)
var/list/robot_talk_light_sound = list (
	'sound/machines/robots/robot_talk_light1.ogg','sound/machines/robots/robot_talk_light2.ogg',
	'sound/machines/robots/robot_talk_light3.ogg','sound/machines/robots/robot_talk_light4.ogg',
	'sound/machines/robots/robot_talk_light5.ogg'
)
var/list/miss_sound = list (
	'sound/weapons/guns/misc/miss.ogg','sound/weapons/guns/misc/miss2.ogg',
	'sound/weapons/guns/misc/miss3.ogg','sound/weapons/guns/misc/miss4.ogg'
)
var/list/ric_sound = list (
	'sound/weapons/guns/misc/ric1.ogg','sound/weapons/guns/misc/ric2.ogg','sound/weapons/guns/misc/ric3.ogg',
	'sound/weapons/guns/misc/ric4.ogg','sound/weapons/guns/misc/ric5.ogg'
)
var/list/casing_sound = list (
	'sound/weapons/guns/misc/casingfall1.ogg','sound/weapons/guns/misc/casingfall2.ogg',
	'sound/weapons/guns/misc/casingfall3.ogg'
)
var/list/bullet_hit_object_sound = list('sound/weapons/guns/misc/bullethit.ogg')

var/list/climb_sound = list(
	'sound/effects/ladder.ogg',
	'sound/effects/ladder2.ogg',
	'sound/effects/ladder3.ogg',
	'sound/effects/ladder4.ogg'
)

var/list/weld_sound = list(
	'sound/items/Welder.ogg',
	'sound/items/welding1.ogg',
	'sound/items/welding2.ogg',
	'sound/items/welding3.ogg',
	'sound/items/welding4.ogg'
)

var/list/gunshot_sound = list('sound/weapons/Gunshot.ogg',
	'sound/weapons/guns/fire/ltrifle_fire.ogg',
	'sound/weapons/guns/fire/m41_shoot.ogg',
	'sound/weapons/guns/fire/revolver_fire.ogg',
	'sound/weapons/guns/fire/sfrifle_fire.ogg',
	'sound/weapons/guns/fire/shotgunp_fire.ogg',
	'sound/weapons/guns/fire/smg_fire.ogg',
	'sound/weapons/guns/fire/sniper_fire.ogg'
)
/*var/list/gun_sound = list(
	'sound/weapons/Gunshot.ogg', 'sound/weapons/Gunshot2.ogg','sound/weapons/Gunshot3.ogg',
	'sound/weapons/Gunshot4.ogg'
)*/

var/list/short_equipement_sound = list(
	'sound/misc/inventory/short_1.ogg',
	'sound/misc/inventory/short_2.ogg',
	'sound/misc/inventory/short_3.ogg'
)

var/list/long_equipement_sound = list(
	'sound/misc/inventory/long_1.ogg',
	'sound/misc/inventory/long_2.ogg',
	'sound/misc/inventory/long_3.ogg'
)

//Sounds of earth, rock and stone
var/list/crumble_sound = list('sound/effects/crumble1.ogg',\
'sound/effects/crumble2.ogg',\
'sound/effects/crumble3.ogg',\
'sound/effects/crumble4.ogg',\
'sound/effects/crumble5.ogg')

//Heavy impact sounds, like a hammer or hard strike
var/list/thud_sound = list('sound/effects/impacts/thud1.ogg',\
'sound/effects/impacts/thud2.ogg',\
'sound/effects/impacts/thud3.ogg')

var/list/footstep_asteroid = list(\
		'sound/effects/footstep/asteroid1.ogg',\
		'sound/effects/footstep/asteroid2.ogg',\
		'sound/effects/footstep/asteroid3.ogg',\
		'sound/effects/footstep/asteroid4.ogg',\
		'sound/effects/footstep/asteroid5.ogg')

var/list/footstep_carpet = list(\
		'sound/effects/footstep/carpet1.ogg',\
		'sound/effects/footstep/carpet2.ogg',\
		'sound/effects/footstep/carpet3.ogg',\
		'sound/effects/footstep/carpet4.ogg',\
		'sound/effects/footstep/carpet5.ogg')

var/list/footstep_catwalk = list(\
		'sound/effects/footstep/catwalk1.ogg',\
		'sound/effects/footstep/catwalk2.ogg',\
		'sound/effects/footstep/catwalk3.ogg',\
		'sound/effects/footstep/catwalk4.ogg',\
		'sound/effects/footstep/catwalk5.ogg')

var/list/footstep_floor = list(\
		'sound/effects/footstep/floor1.ogg',\
		'sound/effects/footstep/floor2.ogg',\
		'sound/effects/footstep/floor3.ogg',\
		'sound/effects/footstep/floor4.ogg',\
		'sound/effects/footstep/floor5.ogg')

var/list/footstep_grass = list(\
		'sound/effects/footstep/grass1.wav',\
		'sound/effects/footstep/grass2.wav',\
		'sound/effects/footstep/grass3.wav',\
		'sound/effects/footstep/grass4.wav')

var/list/footstep_gravel = list(\
		'sound/effects/footstep/gravel1.wav',\
		'sound/effects/footstep/gravel2.wav',\
		'sound/effects/footstep/gravel3.wav',\
		'sound/effects/footstep/gravel4.wav')

var/list/footstep_hull = list(\
		'sound/effects/footstep/hull1.ogg',\
		'sound/effects/footstep/hull2.ogg',\
		'sound/effects/footstep/hull3.ogg',\
		'sound/effects/footstep/hull4.ogg',\
		'sound/effects/footstep/hull5.ogg')

var/list/footstep_plating =list(\
		'sound/effects/footstep/plating1.ogg',\
		'sound/effects/footstep/plating2.ogg',\
		'sound/effects/footstep/plating3.ogg',\
		'sound/effects/footstep/plating4.ogg',\
		'sound/effects/footstep/plating5.ogg')

var/list/footstep_tile = list(\
		'sound/effects/footstep/tile1.wav',\
		'sound/effects/footstep/tile2.wav',\
		'sound/effects/footstep/tile3.wav',\
		'sound/effects/footstep/tile4.wav')

var/list/footstep_wood = list(\
		'sound/effects/footstep/wood1.ogg',\
		'sound/effects/footstep/wood2.ogg',\
		'sound/effects/footstep/wood3.ogg',\
		'sound/effects/footstep/wood4.ogg',\
		'sound/effects/footstep/wood5.ogg')


var/list/rummage_sound = list(\
		'sound/effects/interaction/rummage1.ogg',\
		'sound/effects/interaction/rummage2.ogg',\
		'sound/effects/interaction/rummage3.ogg',\
		'sound/effects/interaction/rummage4.ogg',\
		'sound/effects/interaction/rummage5.ogg',\
		'sound/effects/interaction/rummage6.ogg')


/proc/footstep_sound(var/sound)
	var/toplay
	switch (sound)
		if ("asteroid")
			toplay = pick(footstep_asteroid)
		if ("carpet")
			toplay = pick(footstep_carpet)
		if ("catwalk")
			toplay = pick(footstep_catwalk)
		if ("floor")
			toplay = pick(footstep_floor)
		if ("grass")
			toplay = pick(footstep_grass)
		if ("gravel")
			toplay = pick(footstep_gravel)
		if ("hull")
			toplay = pick(footstep_hull)
		if ("plating")
			toplay = pick(footstep_plating)
		if ("tile")
			toplay = pick(footstep_tile)
		if ("wood")
			toplay = pick(footstep_wood)


	return toplay

/proc/playsound(var/atom/source, soundin, vol as num, vary, extrarange as num, falloff, var/is_global, var/use_pressure = TRUE)

	soundin = get_sfx(soundin) // same sound for everyone

	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return

	var/frequency = get_rand_frequency() // Same frequency for everybody
	var/turf/turf_source = get_turf(source)

 	// Looping through the player list has the added bonus of working for mobs inside containers
	for (var/P in GLOB.player_list)
		var/mob/M = P
		if(!M || !M.client)
			continue

		var/distance = get_dist(M, turf_source)
		if(distance <= (world.view + extrarange) * 3)
			var/turf/T = get_turf(M)

			var/z_dist = abs(T.z - turf_source.z)
			z_dist *= 0.5 //The reduction in volume over zlevels was too much
			if(T && z_dist <= 1)
				M.playsound_local(turf_source, soundin, vol/(1+z_dist), vary, extrarange, frequency, falloff, is_global, use_pressure)

var/const/FALLOFF_SOUNDS = 0.5

//turf_source = our_turf, soundin = 'sound/effects/alert.ogg', vol = 100, vary = 1, extrarange = 0.5
/mob/proc/playsound_local(var/turf/turf_source, soundin, vol as num, vary, extrarange as num, frequency, falloff, is_global, use_pressure = TRUE)
	if(!src.client || ear_deaf > 0)	return
	soundin = get_sfx(soundin)

	var/sound/S = sound(soundin)
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol
	S.environment = -1
	if (vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	//sound volume falloff with pressure
	var/pressure_factor = 1.0

	// 3D sounds, the technology is here!
	var/turf/T = get_turf(src)

	if(T)
		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)
		S.volume -= max(distance - (world.view + extrarange), 0) * 2 //multiplicative falloff to add on top of natural audio falloff.

		var/datum/gas_mixture/hearer_env = T.return_air()
		var/datum/gas_mixture/source_env = turf_source.return_air()

		//Use pressure flag allows you to ignore the normal environment based checks, allowing sounds that can be heard in/from space
		if (use_pressure)
			if (hearer_env && source_env)
				var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
				if (pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //in space
				pressure_factor = 0

			if (distance <= 1)
				pressure_factor = max(pressure_factor, 0.15)	//hearing through contact

			S.volume *= pressure_factor

		if (S.volume <= 0)
			return	//no volume means no sound

		var/dx = turf_source.x - T.x // Hearing from the right/left
		S.x = dx
		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = dz
		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	if(!is_global)

		if(istype(src,/mob/living/))
			var/mob/living/M = src
			var/mob/living/carbon/C = src
			if (istype(C) && C.hallucination_power > 50 && C.chem_effects[CE_MIND] < 1)
				S.environment = PSYCHOTIC
			else if (M.druggy)
				S.environment = DRUGGED
			else if (M.drowsyness)
				S.environment = DIZZY
			else if (M.confused)
				S.environment = DIZZY
			else if (M.sleeping)
				S.environment = UNDERWATER
			else if (pressure_factor < 0.5)
				S.environment = SPACE
			else
				var/area/A = get_area(src)
				if(istype(A))
					S.environment = A.sound_env

		else if (pressure_factor < 0.5)
			S.environment = SPACE
		else
			var/area/A = get_area(src)
			if(istype(A))
				S.environment = A.sound_env

	src << S

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick(shatter_sound)
			if ("explosion") soundin = pick(explosion_sound)
			if ("sparks") soundin = pick(spark_sound)
			if ("rustle") soundin = pick(rustle_sound)
			if ("punch") soundin = pick(punch_sound)
			if ("clownstep") soundin = pick(clown_sound)
			if ("swing_hit") soundin = pick(swing_hit_sound)
			if ("hiss") soundin = pick(hiss_sound)
			if ("pageturn") soundin = pick(page_sound)
			if ("keyboard") soundin = pick(keyboard_sound)
			if ("robot_talk_heavy") soundin = pick(robot_talk_heavy_sound)
			if ("robot_talk_light") soundin = pick(robot_talk_light_sound)
			if ("miss_sound") soundin = pick(miss_sound)
			if ("ric_sound") soundin = pick(ric_sound)
			if ("casing_sound") soundin = pick(casing_sound)
			if ("hitobject") soundin = pick(bullet_hit_object_sound)
			if ("climb")soundin = pick(climb_sound)
			if ("catwalk")soundin = pick(footstep_catwalk)
			if ("crumble") soundin = pick(crumble_sound)
			if ("thud") soundin = pick(thud_sound)
			if ("weld") soundin = pick(weld_sound)
			if ("rummage") soundin = pick(rummage_sound)
			//if ("gunshot") soundin = pick(gun_sound)
	return soundin




//Repeating sound support
//This datum is intended to play a sound repeatedly at a given interval over a given duration
//It is not intended for looping audio seamlessly

/*
	Usage:
	To start and immediately play
	var/datum/repeating_sound/mysound = new(30,100,0.15, src, soundfile, 80, 1)

	to stop
	mysound.stop()
	mysound = null (It will qdel itself)
*/
/datum/repeating_sound
	//The atom we play the sound from, but we'll use a weak reference instead of holding it in memory
	//To prevent GC issues
	var/source

	//Past this time we will no longer loop and delete ourselves
	var/end_time

	//How often to play
	var/interval

	//Should be in the range 0..1. 0 disables the feature, 1 allows interval to be anywhere from 0-2x the norm
	var/variance

	var/soundin
	var/vol
	var/vary
	var/extrarange
	var/falloff
	var/is_global
	var/use_pressure
	//Used to stop it early
	var/timer_handle

	var/self_id

/datum/repeating_sound/New(var/_interval, var/duration, var/interval_variance = 0, var/atom/_source, var/_soundin, var/_vol, var/_vary, var/_extrarange, var/_falloff, var/_is_global, var/_use_pressure = TRUE)
	end_time = world.time + duration
	source = "\ref[_source]"
	interval = _interval
	variance = interval_variance
	soundin = _soundin
	vol = _vol
	vary = _vary
	extrarange = _extrarange
	falloff = _falloff
	is_global = _is_global
	use_pressure = _use_pressure
	self_id = "\ref[src]"

	//When created we do our first sound immediately
	//If you want the first sound delayed, wrap it in a spawn call or something
	do_sound()


/datum/repeating_sound/proc/do_sound()
	timer_handle = null //This has been successfully called, that handle is no use now

	var/atom/playfrom = locate(source)
	if (QDELETED(playfrom))
		//Our source atom is gone, no more sounds
		stop()
		return

	//We're past the end time, no more sounds
	if (world.time > end_time)
		stop()
		return

	//Actually play the sound
	playsound(playfrom, soundin, vol, vary, extrarange, falloff, is_global, use_pressure)

	//Setup the next sound
	var/nextinterval = interval
	if (variance)
		nextinterval *= rand_decimal(1-variance, 1+variance)

	//Set the next timer handle
	timer_handle = addtimer(CALLBACK(src, .proc/do_sound, TRUE), nextinterval, TIMER_STOPPABLE)



/datum/repeating_sound/proc/stop()
	if (timer_handle)
		deltimer(timer_handle)
	qdel(src)
