/*
//	Not works properly
*/

datum/sound_loop
	var/list/listeners = list()
	var/atom/source

	var/file
	var/range = 3
	var/volume = 100
	var/frequency = 0
	var/falloff = 0

	var/playing = FALSE

	var/force_update = FALSE


datum/sound_loop/New(var/atom/source, soundname, vol as num, range as num, freq = 0, falloff = FALLOFF_SOUNDS)
	src.source = source
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


datum/sound_loop/proc/set_volume(var/newvol)
	src.volume = newvol
	src.force_update = TRUE


datum/sound_loop/proc/set_frequency(var/newfreq)
	src.frequency = newfreq
	src.force_update = TRUE


datum/sound_loop/proc/set_range(var/newrange)
	src.range = newrange
	src.force_update = TRUE


datum/sound_loop/proc/add_listener(var/mob/M)
	var/sound/S = new(file)
	S.repeat = TRUE
	listeners[M] = S
	update_listener(M, S)
	M << S


datum/sound_loop/proc/remove_listener(var/mob/M)
	var/sound/S = listeners[M]
	S.status = SOUND_PAUSED | SOUND_UPDATE
	S.repeat = FALSE
	qdel(S)
	listeners -= M


datum/sound_loop/proc/update_listeners_list()
	for(var/mob/M in listeners)
		var/sound/S = listeners[M]
		var/dx = M.x - source.x
		var/dz = M.y - source.y
		if(force_update || S.x != dx || S.z != dz)
			update_listener(M, S)

	for(var/mob/M in view(range,source))
		if(M in listeners)
			continue
		add_listener(M)

	force_update = FALSE


datum/sound_loop/proc/update_listener(var/mob/M, var/sound/S)
	var/dx = M.x - source.x
	var/dz = M.y - source.y
	var/dist = get_dist(source,M)

	if(dist > range)
		remove_listener(M)
		return

	S.x = dx
	S.z = dz
	S.volume = volume - max(range-(range-dist), 0)*2
	S.frequency = frequency
	S.volume = volume

	if(!playing)
		S.status |= SOUND_PAUSED
	else
		S.status &= ~SOUND_PAUSED

	S.status |= SOUND_UPDATE

datum/sound_loop/proc/process()
	update_listeners_list()


/obj/item/loopsoundtest
	icon = 'icons/obj/items.dmi'
	icon_state = "gift"
	var/datum/sound_loop/SL

/obj/item/loopsoundtest/New()
	..()
	SL = new(src,'sound/items/drink.ogg',100,5)
	processing_objects += src
	SL.play()

/obj/item/loopsoundtest/process()
	SL.process()
