datum/sound_loop
	var/list/listeners = list()
	var/atom/source
	var/atom/source_loc

	var/file
	var/range = 3
	var/volume = 100
	var/frequency = 0
	var/falloff = 0

	var/playing = FALSE

	var/force_update = FALSE


datum/sound_loop/New(var/atom/source, soundname, vol as num, range as num, freq = 0, falloff = FALLOFF_SOUNDS)
	src.source = source
	src.source_loc = source.loc
	src.file = soundname
	src.volume = vol
	src.range = range
	src.frequency = freq
	src.falloff = falloff

datum/sound_loop/Destroy()
	for(var/mob/M in listeners)
		remove_listener(M)

datum/sound_loop/proc/play()
	playing = TRUE
	src.force_update = TRUE


datum/sound_loop/proc/stop()
	playing = FALSE
	src.force_update = TRUE


datum/sound_loop/proc/set_volume(var/new_vol)
	src.volume = new_vol
	src.force_update = TRUE


datum/sound_loop/proc/set_frequency(var/new_freq)
	src.frequency = new_freq
	src.force_update = TRUE


datum/sound_loop/proc/set_range(var/new_range)
	src.range = new_range
	src.force_update = TRUE

datum/sound_loop/proc/add_listener(var/mob/M)
	var/sound/S = new(file)
	S.repeat = TRUE
	S.channel = rand(256,1024)
	listeners[M] = S
	update_listener(M, S)
	M << S


datum/sound_loop/proc/remove_listener(var/mob/M)
	var/sound/S = listeners[M]
	var/sound/NS = new(null)
	NS.channel = S.channel
	M << NS
	qdel(S)
	listeners.Remove(M)


datum/sound_loop/proc/update_listeners_list()
	for(var/mob/M in listeners)
		var/sound/S = listeners[M]
		var/dx = source.x - M.x
		var/dz = source.y - M.y
		if(force_update || S.x != dx || S.z != dz)
			update_listener(M, S)

	for(var/mob/M in view(range,source))
		if(M in listeners || !M.client)
			continue
		add_listener(M)

	force_update = FALSE


datum/sound_loop/proc/update_listener(var/mob/M, var/sound/S)
	var/dx = source.x - M.x
	var/dz = source.y - M.y
	var/dist = get_dist(source,M)

	if(dist > range || !(M in view(range,source)))
		remove_listener(M)
		return

	S.status &= ~SOUND_UPDATE

	var/turf/T = get_turf(M)
	var/datum/gas_mixture/hearer_env = T.return_air()
	var/datum/gas_mixture/source_env = source_loc.return_air()
	var/pressure_factor = 1

	if(hearer_env && source_env)
		var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())

		if (pressure < ONE_ATMOSPHERE)
			pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
	else
		pressure_factor = 0

	if(dist <= 1)
		pressure_factor = max(pressure_factor, 0.15)

	S.x = dx
	S.z = dz
	S.volume = ((range-dist)/range*volume)*pressure_factor
	S.frequency = frequency

	if(istype(M,/mob/living/))
		var/mob/living/LM = M
		if (LM.hallucination)
			S.environment = PSYCHOTIC
		else if (LM.druggy)
			S.environment = DRUGGED
		else if (LM.drowsyness)
			S.environment = DIZZY
		else if (LM.confused)
			S.environment = DIZZY
		else if (LM.sleeping)
			S.environment = UNDERWATER
		else if (pressure_factor < 0.5)
			S.environment = SPACE
		else
			var/area/A = get_area(source)
			S.environment = A.sound_env
	else if (pressure_factor < 0.5)
		S.environment = SPACE
	else
		var/area/A = get_area(source)
		S.environment = A.sound_env

	if(!playing)
		S.status |= SOUND_PAUSED
	else
		S.status &= ~SOUND_PAUSED

	S.status |= SOUND_UPDATE

	M << S

datum/sound_loop/Process()
	if(source.loc != source_loc)
		force_update = TRUE
		source_loc = source.loc
	update_listeners_list()

