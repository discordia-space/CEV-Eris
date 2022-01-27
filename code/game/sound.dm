//Defines for echo list index positions.
//ECHO_DIRECT and ECHO_ROOM are the only two that actually appear to do anythin69, and represent the dry and wet channels of the environment effects, respectively.
//The rest of the defines are there primarily for the sake of completeness. It69i69ht be worth testin69 on EAX-enabled hardware, and on future BYOND69ersions (I've tested with 511, 512, and 513)
#define ECHO_DIRECT 1
#define ECHO_DIRECTHF 2
#define ECHO_ROOM 3
#define ECHO_ROOMHF 4
#define ECHO_OBSTRUCTION 5
#define ECHO_OBSTRUCTIONLFRATIO 6
#define ECHO_OCCLUSION 7
#define ECHO_OCCLUSIONLFRATIO 8
#define ECHO_OCCLUSIONROOMRATIO 9
#define ECHO_OCCLUSIONDIRECTRATIO 10
#define ECHO_EXCLUSION 11
#define ECHO_EXCLUSIONLFRATIO 12
#define ECHO_OUTSIDEVOLUMEHF 13
#define ECHO_DOPPLERFACTOR 14
#define ECHO_ROLLOFFFACTOR 15
#define ECHO_ROOMROLLOFFFACTOR 16
#define ECHO_AIRABSORPTIONFACTOR 17
#define ECHO_FLA69S 18

//Defines for controllin69 how zsound sounds.
#define ZSOUND_DRYLOSS_PER_Z -2000 //Affects what happens to the dry channel as the sound travels throu69h z-levels
#define ZSOUND_DISTANCE_PER_Z 2 //Affects the distance added to the sound per z-level travelled

//Sound environment defines. Reverb preset for sounds played in an area, see sound datum reference for69ore.
#define 69ENERIC 0
#define PADDED_CELL 1
#define ROOM 2
#define BATHROOM 3
#define LIVIN69ROOM 4
#define STONEROOM 5
#define AUDITORIUM 6
#define CONCERT_HALL 7
#define CAVE 8
#define ARENA 9
#define HAN69AR 10
#define CARPETED_HALLWAY 11
#define HALLWAY 12
#define STONE_CORRIDOR 13
#define ALLEY 14
#define FOREST 15
#define CITY 16
#define69OUNTAINS 17
#define 69UARRY 18
#define PLAIN 19
#define PARKIN69_LOT 20
#define SEWER_PIPE 21
#define UNDERWATER 22
#define DRU6969ED 23
#define DIZZY 24
#define PSYCHOTIC 25

#define STANDARD_STATION STONEROOM
#define LAR69E_ENCLOSED HAN69AR
#define SMALL_ENCLOSED BATHROOM
#define TUNNEL_ENCLOSED CAVE
#define LAR69E_SOFTFLOOR CARPETED_HALLWAY
#define69EDIUM_SOFTFLOOR LIVIN69ROOM
#define SMALL_SOFTFLOOR ROOM
#define ASTEROID CAVE
#define SPACE UNDERWATER

var/list/shatter_sound = list(
	'sound/effects/69lassbr1.o6969','sound/effects/69lassbr2.o6969','sound/effects/69lassbr3.o6969'
)
var/list/explosion_sound = list('sound/effects/Explosion1.o6969','sound/effects/Explosion2.o6969')
var/list/spark_sound = list(
	'sound/effects/sparks1.o6969','sound/effects/sparks2.o6969','sound/effects/sparks3.o6969',
	'sound/effects/sparks4.o6969'
)
var/list/rustle_sound = list(
	'sound/effects/rustle1.o6969','sound/effects/rustle2.o6969','sound/effects/rustle3.o6969',
	'sound/effects/rustle4.o6969','sound/effects/rustle5.o6969'
)
var/list/punch_sound = list(
	'sound/weapons/punch1.o6969','sound/weapons/punch2.o6969','sound/weapons/punch3.o6969','sound/weapons/punch4.o6969'
)

var/list/bullet_hit_wall = list(
	'sound/weapons/69uns/misc/ric1.o6969', 'sound/weapons/69uns/misc/ric2.o6969', 'sound/weapons/69uns/misc/ric3.o6969', 'sound/weapons/69uns/misc/ric4.o6969', 'sound/weapons/69uns/misc/ric5.o6969'
)

var/list/clown_sound = list('sound/effects/clownstep1.o6969','sound/effects/clownstep2.o6969')
var/list/swin69_hit_sound = list(
	'sound/weapons/69enhit1.o6969', 'sound/weapons/69enhit2.o6969', 'sound/weapons/69enhit3.o6969'
)
var/list/hiss_sound = list(
	'sound/voice/hiss1.o6969','sound/voice/hiss2.o6969','sound/voice/hiss3.o6969','sound/voice/hiss4.o6969'
)
var/list/pa69e_sound = list(
	'sound/effects/pa69eturn1.o6969', 'sound/effects/pa69eturn2.o6969','sound/effects/pa69eturn3.o6969'
)
var/list/keyboard_sound = list (
	'sound/effects/keyboard/keyboard1.o6969','sound/effects/keyboard/keyboard2.o6969',
	'sound/effects/keyboard/keyboard3.o6969', 'sound/effects/keyboard/keyboard4.o6969'
)
var/list/robot_talk_heavy_sound = list (
	'sound/machines/robots/robot_talk_heavy1.o6969','sound/machines/robots/robot_talk_heavy2.o6969',
	'sound/machines/robots/robot_talk_heavy3.o6969','sound/machines/robots/robot_talk_heavy4.o6969'
)
var/list/robot_talk_li69ht_sound = list (
	'sound/machines/robots/robot_talk_li69ht1.o6969','sound/machines/robots/robot_talk_li69ht2.o6969',
	'sound/machines/robots/robot_talk_li69ht3.o6969','sound/machines/robots/robot_talk_li69ht4.o6969',
	'sound/machines/robots/robot_talk_li69ht5.o6969'
)
var/list/miss_sound = list (
	'sound/weapons/69uns/misc/miss.o6969','sound/weapons/69uns/misc/miss2.o6969',
	'sound/weapons/69uns/misc/miss3.o6969','sound/weapons/69uns/misc/miss4.o6969'
)
var/list/ric_sound = list (
	'sound/weapons/69uns/misc/ric1.o6969','sound/weapons/69uns/misc/ric2.o6969','sound/weapons/69uns/misc/ric3.o6969',
	'sound/weapons/69uns/misc/ric4.o6969','sound/weapons/69uns/misc/ric5.o6969'
)
var/list/casin69_sound = list (
	'sound/weapons/69uns/misc/casin69fall1.o6969','sound/weapons/69uns/misc/casin69fall2.o6969',
	'sound/weapons/69uns/misc/casin69fall3.o6969'
)
var/list/bullet_hit_object_sound = list('sound/weapons/69uns/misc/bullethit.o6969')

var/list/climb_sound = list(
	'sound/effects/ladder.o6969',
	'sound/effects/ladder2.o6969',
	'sound/effects/ladder3.o6969',
	'sound/effects/ladder4.o6969'
)

var/list/weld_sound = list(
	'sound/items/Welder.o6969',
	'sound/items/weldin691.o6969',
	'sound/items/weldin692.o6969',
	'sound/items/weldin693.o6969',
	'sound/items/weldin694.o6969'
)

var/list/69unshot_sound = list('sound/weapons/69unshot.o6969',
	'sound/weapons/69uns/fire/ltrifle_fire.o6969',
	'sound/weapons/69uns/fire/m41_shoot.o6969',
	'sound/weapons/69uns/fire/revolver_fire.o6969',
	'sound/weapons/69uns/fire/sfrifle_fire.o6969',
	'sound/weapons/69uns/fire/shot69unp_fire.o6969',
	'sound/weapons/69uns/fire/sm69_fire.o6969',
	'sound/weapons/69uns/fire/sniper_fire.o6969'
)
/*var/list/69un_sound = list(
	'sound/weapons/69unshot.o6969', 'sound/weapons/69unshot2.o6969','sound/weapons/69unshot3.o6969',
	'sound/weapons/69unshot4.o6969'
)*/

var/list/69un_interact_sound = list(
	'sound/weapons/69uns/interact/batrifle_cock.o6969',
	'sound/weapons/69uns/interact/batrifle_ma69in.o6969',
	'sound/weapons/69uns/interact/batrifle_ma69out.o6969',
	'sound/weapons/69uns/interact/bullet_insert2.o6969',
	'sound/weapons/69uns/interact/bullet_insert.o6969',
	'sound/weapons/69uns/interact/hpistol_cock.o6969',
	'sound/weapons/69uns/interact/hpistol_ma69in.o6969',
	'sound/weapons/69uns/interact/hpistol_ma69out.o6969',
	'sound/weapons/69uns/interact/lm69_close.o6969',
	'sound/weapons/69uns/interact/lm69_cock.o6969',
	'sound/weapons/69uns/interact/lm69_ma69in.o6969',
	'sound/weapons/69uns/interact/lm69_ma69out.o6969',
	'sound/weapons/69uns/interact/lm69_open.o6969',
	'sound/weapons/69uns/interact/ltrifle_cock.o6969',
	'sound/weapons/69uns/interact/ltrifle_ma69in.o6969',
	'sound/weapons/69uns/interact/ltrifle_ma69out.o6969',
	'sound/weapons/69uns/interact/m41_cocked.o6969',
	'sound/weapons/69uns/interact/m41_reload.o6969',
	'sound/weapons/69uns/interact/pistol_cock.o6969',
	'sound/weapons/69uns/interact/pistol_ma69in.o6969',
	'sound/weapons/69uns/interact/pistol_ma69out.o6969',
	'sound/weapons/69uns/interact/rev_cock.o6969',
	'sound/weapons/69uns/interact/rev_ma69in.o6969',
	'sound/weapons/69uns/interact/rev_ma69out.o6969',
	'sound/weapons/69uns/interact/rifle_boltback.o6969',
	'sound/weapons/69uns/interact/rifle_boltforward.o6969',
	'sound/weapons/69uns/interact/rifle_load.o6969',
	'sound/weapons/69uns/interact/selector.o6969',
	'sound/weapons/69uns/interact/sfrifle_cock.o6969',
	'sound/weapons/69uns/interact/sfrifle_ma69in.o6969',
	'sound/weapons/69uns/interact/sfrifle_ma69out.o6969',
	'sound/weapons/69uns/interact/shot69un_insert.o6969',
	'sound/weapons/69uns/interact/sm69_cock.o6969',
	'sound/weapons/69uns/interact/sm69_ma69in.o6969',
	'sound/weapons/69uns/interact/sm69_ma69out.o6969'
)

var/list/short_e69uipement_sound = list(
	'sound/misc/inventory/short_1.o6969',
	'sound/misc/inventory/short_2.o6969',
	'sound/misc/inventory/short_3.o6969'
)

var/list/lon69_e69uipement_sound = list(
	'sound/misc/inventory/lon69_1.o6969',
	'sound/misc/inventory/lon69_2.o6969',
	'sound/misc/inventory/lon69_3.o6969'
)

//Sounds of earth, rock and stone
var/list/crumble_sound = list('sound/effects/crumble1.o6969',\
'sound/effects/crumble2.o6969',\
'sound/effects/crumble3.o6969',\
'sound/effects/crumble4.o6969',\
'sound/effects/crumble5.o6969')

//Heavy impact sounds, like a hammer or hard strike
var/list/thud_sound = list('sound/effects/impacts/thud1.o6969',\
'sound/effects/impacts/thud2.o6969',\
'sound/effects/impacts/thud3.o6969')

var/list/footstep_asteroid = list(\
		'sound/effects/footstep/asteroid1.o6969',\
		'sound/effects/footstep/asteroid2.o6969',\
		'sound/effects/footstep/asteroid3.o6969',\
		'sound/effects/footstep/asteroid4.o6969',\
		'sound/effects/footstep/asteroid5.o6969')

var/list/footstep_carpet = list(\
		'sound/effects/footstep/carpet1.o6969',\
		'sound/effects/footstep/carpet2.o6969',\
		'sound/effects/footstep/carpet3.o6969',\
		'sound/effects/footstep/carpet4.o6969',\
		'sound/effects/footstep/carpet5.o6969')

var/list/footstep_catwalk = list(\
		'sound/effects/footstep/catwalk1.o6969',\
		'sound/effects/footstep/catwalk2.o6969',\
		'sound/effects/footstep/catwalk3.o6969',\
		'sound/effects/footstep/catwalk4.o6969',\
		'sound/effects/footstep/catwalk5.o6969')

var/list/footstep_floor = list(\
		'sound/effects/footstep/floor1.o6969',\
		'sound/effects/footstep/floor2.o6969',\
		'sound/effects/footstep/floor3.o6969',\
		'sound/effects/footstep/floor4.o6969',\
		'sound/effects/footstep/floor5.o6969')

var/list/footstep_69rass = list(\
		'sound/effects/footstep/69rass1.wav',\
		'sound/effects/footstep/69rass2.wav',\
		'sound/effects/footstep/69rass3.wav',\
		'sound/effects/footstep/69rass4.wav')

var/list/footstep_69ravel = list(\
		'sound/effects/footstep/69ravel1.wav',\
		'sound/effects/footstep/69ravel2.wav',\
		'sound/effects/footstep/69ravel3.wav',\
		'sound/effects/footstep/69ravel4.wav')

var/list/footstep_hull = list(\
		'sound/effects/footstep/hull1.o6969',\
		'sound/effects/footstep/hull2.o6969',\
		'sound/effects/footstep/hull3.o6969',\
		'sound/effects/footstep/hull4.o6969',\
		'sound/effects/footstep/hull5.o6969')

var/list/footstep_platin69 =list(\
		'sound/effects/footstep/platin691.o6969',\
		'sound/effects/footstep/platin692.o6969',\
		'sound/effects/footstep/platin693.o6969',\
		'sound/effects/footstep/platin694.o6969',\
		'sound/effects/footstep/platin695.o6969')

var/list/footstep_tile = list(\
		'sound/effects/footstep/tile1.wav',\
		'sound/effects/footstep/tile2.wav',\
		'sound/effects/footstep/tile3.wav',\
		'sound/effects/footstep/tile4.wav')

var/list/footstep_wood = list(\
		'sound/effects/footstep/wood1.o6969',\
		'sound/effects/footstep/wood2.o6969',\
		'sound/effects/footstep/wood3.o6969',\
		'sound/effects/footstep/wood4.o6969',\
		'sound/effects/footstep/wood5.o6969')


var/list/rumma69e_sound = list(\
		'sound/effects/interaction/rumma69e1.o6969',\
		'sound/effects/interaction/rumma69e2.o6969',\
		'sound/effects/interaction/rumma69e3.o6969',\
		'sound/effects/interaction/rumma69e4.o6969',\
		'sound/effects/interaction/rumma69e5.o6969',\
		'sound/effects/interaction/rumma69e6.o6969')


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
		if ("69rass")
			toplay = pick(footstep_69rass)
		if ("69ravel")
			toplay = pick(footstep_69ravel)
		if ("hull")
			toplay = pick(footstep_hull)
		if ("platin69")
			toplay = pick(footstep_platin69)
		if ("tile")
			toplay = pick(footstep_tile)
		if ("wood")
			toplay = pick(footstep_wood)


	return toplay

/proc/playsound(atom/source, soundin,69ol as num,69ary, extraran69e as num, falloff, is_69lobal, fre69uency, is_ambiance = 0,  i69nore_walls = TRUE, zran69e = 2, override_env, envdry, envwet, use_pressure = TRUE)
	if(isarea(source))
		error("69source69 is an area and is tryin69 to69ake the sound: 69soundin69")
		return

	soundin = 69et_sfx(soundin) // same sound for everyone
	fre69uency =69ary && isnull(fre69uency) ? 69et_rand_fre69uency() : fre69uency // Same fre69uency for everybody

	var/turf/turf_source = 69et_turf(source)
	var/maxdistance = (world.view + extraran69e) * 2

 	// Loopin69 throu69h the player list has the added bonus of workin69 for69obs inside containers
	var/list/listeners = 69LOB.player_list
	if(!i69nore_walls) //these sounds don't carry throu69h walls
		listeners = listeners & hearers(maxdistance, turf_source)

	for(var/P in listeners)
		var/mob/M = P
		if(!M || !M.client)
			continue
		var/dist = 69et_dist(M, turf_source)
		if(dist <=69axdistance + 3)
			if(dist >69axdistance)
				if(!ishuman(M))
					continue
				else if(!M.stats.69etPerk(PERK_EAR_OF_69UICKSILVER))
					continue
			var/turf/T = 69et_turf(M)

			if(T && (T.z == turf_source.z || zran69e && abs(T.z - turf_source.z) <= zran69e))
				M.playsound_local(turf_source, soundin,69ol,69ary, fre69uency, falloff, is_69lobal, extraran69e, override_env, envdry, envwet, use_pressure)

var/const/FALLOFF_SOUNDS = 0.5

/mob/proc/playsound_local(turf/turf_source, soundin,69ol as num,69ary, fre69uency, falloff, is_69lobal, extraran69e, override_env, envdry, envwet, use_pressure = TRUE)
	if(!src.client || ear_deaf > 0)
		return

	var/sound/S = soundin
	if(!istype(S))
		soundin = 69et_sfx(soundin)
		S = sound(soundin)
		S.wait = 0 //No 69ueue
		S.channel = 0 //Any channel
		S.volume =69ol
		S.environment = -1
		if(fre69uency)
			S.fre69uency = fre69uency
		else if (vary)
			S.fre69uency = 69et_rand_fre69uency()

	//sound69olume falloff with pressure
	var/pressure_factor = 1
	
	var/turf/T = 69et_turf(src)
	// 3D sounds, the technolo69y is here!
	if(T && isturf(turf_source))
		//sound69olume falloff with distance
		var/distance = 69et_dist(T, turf_source)

		S.volume -=69ax(distance - (world.view + extraran69e), 0) * 2 //multiplicative falloff to add on top of natural audio falloff.

		var/datum/69as_mixture/hearer_env = T.return_air()
		var/datum/69as_mixture/source_env = turf_source.return_air()

		if(use_pressure)
			if (hearer_env && source_env)
				var/pressure =69in(hearer_env.return_pressure(), source_env.return_pressure())

				if (pressure < ONE_ATMOSPHERE)
					pressure_factor =69ax((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //in space
				pressure_factor = 0

			if (distance <= 1)
				pressure_factor =69ax(pressure_factor, 0.15)	//hearin69 throu69h contact

			S.volume *= pressure_factor
		
		if (S.volume <= 0)
			return //no69olume69eans no sound

		var/dx = turf_source.x - T.x // Hearin69 from the ri69ht/left
		S.x = dx
		var/dz = turf_source.y - T.y // Hearin69 from infront/behind
		S.z = dz
		var/dy = (turf_source.z - T.z) * ZSOUND_DISTANCE_PER_Z // Hearin69 from above/below. There is ceilin69 in 2d spessmans.
		S.y = (dy < 0) ? dy - 1 : dy + 1 //We want to69ake sure there's *always* at least one extra unit of distance. This helps normalize sound that's emittin69 from the turf you're on.
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

		if(!override_env)
			envdry = abs(turf_source.z - T.z) * ZSOUND_DRYLOSS_PER_Z

	if(!is_69lobal)

		if(istype(src,/mob/livin69/))
			var/mob/livin69/carbon/M = src
			if (istype(M) &&69.hallucination_power > 50 &&69.chem_effects69CE_MIND69 < 1)
				S.environment = PSYCHOTIC
			else if (M.dru6969y)
				S.environment = DRU6969ED
			else if (M.drowsyness)
				S.environment = DIZZY
			else if (M.confused)
				S.environment = DIZZY
			else if (M.stat == UNCONSCIOUS)
				S.environment = UNDERWATER
			else if (pressure_factor < 0.5)
				S.environment = SPACE
			else
				var/area/A = 69et_area(src)
				if(istype(A))
					S.environment = A.sound_env

		else if (pressure_factor < 0.5)
			S.environment = SPACE
		else
			var/area/A = 69et_area(src)
			S.environment = A?.sound_env

	var/list/echo_list = new(18)
	echo_list69ECHO_DIRECT69 = envdry
	echo_list69ECHO_ROOM69 = envwet
	S.echo = echo_list

	sound_to(src, S)




/proc/69et_rand_fre69uency()
	return rand(32000, 55000) //Fre69uency stuff only works with 45kbps o6969s.

/proc/69et_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick(shatter_sound)
			if ("explosion") soundin = pick(explosion_sound)
			if ("sparks") soundin = pick(spark_sound)
			if ("rustle") soundin = pick(rustle_sound)
			if ("punch") soundin = pick(punch_sound)
			if ("clownstep") soundin = pick(clown_sound)
			if ("swin69_hit") soundin = pick(swin69_hit_sound)
			if ("hiss") soundin = pick(hiss_sound)
			if ("pa69eturn") soundin = pick(pa69e_sound)
			if ("keyboard") soundin = pick(keyboard_sound)
			if ("robot_talk_heavy") soundin = pick(robot_talk_heavy_sound)
			if ("robot_talk_li69ht") soundin = pick(robot_talk_li69ht_sound)
			if ("miss_sound") soundin = pick(miss_sound)
			if ("ric_sound") soundin = pick(ric_sound)
			if ("casin69_sound") soundin = pick(casin69_sound)
			if ("hitobject") soundin = pick(bullet_hit_object_sound)
			if ("climb")soundin = pick(climb_sound)
			if ("catwalk")soundin = pick(footstep_catwalk)
			if ("crumble") soundin = pick(crumble_sound)
			if ("thud") soundin = pick(thud_sound)
			if ("weld") soundin = pick(weld_sound)
			if ("rumma69e") soundin = pick(rumma69e_sound)
			if ("ricochet") soundin = pick(bullet_hit_wall)
			//if ("69unshot") soundin = pick(69un_sound)
	return soundin




//Repeatin69 sound support
//This datum is intended to play a sound repeatedly at a 69iven interval over a 69iven duration
//It is not intended for loopin69 audio seamlessly

/*
	Usa69e:
	To start and immediately play
	var/datum/repeatin69_sound/mysound = new(30,100,0.15, src, soundfile, 80, 1)

	to stop
	mysound.stop()
	mysound = null (It will 69del itself)
*/
/datum/repeatin69_sound
	//The atom we play the sound from, but we'll use a weak reference instead of holdin69 it in69emory
	//To prevent 69C issues
	var/source

	//Past this time we will no lon69er loop and delete ourselves
	var/end_time

	//How often to play
	var/interval

	//Should be in the ran69e 0..1. 0 disables the feature, 1 allows interval to be anywhere from 0-2x the norm
	var/variance

	var/soundin
	var/vol
	var/vary
	var/extraran69e
	var/falloff
	var/is_69lobal
	var/use_pressure_
	//Used to stop it early
	var/timer_handle

	var/self_id

/datum/repeatin69_sound/New(var/_interval,69ar/duration,69ar/interval_variance = 0,69ar/atom/_source,69ar/_soundin,69ar/_vol,69ar/_vary,69ar/_extraran69e,69ar/_falloff,69ar/_is_69lobal,69ar/_use_pressure = TRUE)
	end_time = world.time + duration
	source = "\ref69_source69"
	interval = _interval
	variance = interval_variance
	soundin = _soundin
	vol = _vol
	vary = _vary
	extraran69e = _extraran69e
	falloff = _falloff
	is_69lobal = _is_69lobal
	use_pressure_ = _use_pressure
	self_id = "\ref69src69"

	//When created we do our first sound immediately
	//If you want the first sound delayed, wrap it in a spawn call or somethin69
	do_sound()


/datum/repeatin69_sound/proc/do_sound()
	timer_handle = null //This has been successfully called, that handle is no use now

	var/atom/playfrom = locate(source)
	if (69DELETED(playfrom))
		//Our source atom is 69one, no69ore sounds
		stop()
		return

	//We're past the end time, no69ore sounds
	if (world.time > end_time)
		stop()
		return

	//Actually play the sound
	playsound(playfrom, soundin,69ol,69ary, extraran69e, falloff, is_69lobal, use_pressure = use_pressure_)

	//Setup the next sound
	var/nextinterval = interval
	if (variance)
		nextinterval *= RAND_DECIMAL(1-variance, 1+variance)

	//Set the next timer handle
	timer_handle = addtimer(CALLBACK(src, .proc/do_sound, TRUE), nextinterval, TIMER_STOPPABLE)



/datum/repeatin69_sound/proc/stop()
	if (timer_handle)
		deltimer(timer_handle)
	69del(src)
