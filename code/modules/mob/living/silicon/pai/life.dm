/mob/living/silicon/pai/Life()
	if (src.stat == DEAD)
		return

	if(src.cable)
		if(get_dist(src, src.cable) > 1)
			var/turf/T = get_turf_or_move(src.loc)
			for (var/mob/M in69iewers(T))
				M.show_message("\red The data cable rapidly retracts back into its spool.", 3, "\red You hear a click and the sound of wire spooling rapidly.", 2)
			qdel(src.cable)
			src.cable =69ull

	handle_regular_hud_updates()

	if(src.secHUD)
		process_sec_hud(src, 1)

	if(src.medHUD)
		process_med_hud(src, 1)

	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time =69ull
			to_chat(src, "<font color=green>Communication circuit reinitialized. Speech and69essaging functionality restored.</font>")

	handle_statuses()

	if(health <= 0)
		death(null,"gives one shrill beep before falling lifeless.")

/mob/living/silicon/pai/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else
		health = 100 - getBruteLoss() - getFireLoss()