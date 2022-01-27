/mob/living/carbon/slime/regenerate_icons()
	if (stat == DEAD)
		icon_state = "69colour69 baby slime dead"
	else
		icon_state = "69colour69 69is_adult ? "adult" : "baby"69 slime69Victim ? "" : " eat"69"
	overlays.len = 0
	if (mood)
		overlays += image('icons/mob/slimes.dmi', icon_state = "aslime-69mood69")
	..()