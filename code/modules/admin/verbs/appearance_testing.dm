var/datum/appearance_test/appearance_test = new

#define TOGGLE(var) var ? "<font color='green'>ON</font>" : "<font color='red'>OFF</font>"

/datum/appearance_test
	var/build_body = FALSE
	var/get_species_sprite = FALSE
	var/colorize_organ = FALSE
	var/cache_sprites = TRUE
	var/special_update = TRUE
	var/simple_setup = FALSE

/datum/appearance_test/proc/rebuild_humans()
	for(var/mob/living/carbon/human/H in mob_list)
		H.update_body()

/datum/appearance_test/proc/interact(var/mob/user)
	var/list/dat = list()
	dat += "<html><head><title>Appearance</title><body>"
	dat += "Build body from organs sprite - <a href='?src=\ref[src];build=1'>[TOGGLE(build_body)]</a><br>"
	dat += "Get species sprite for organs - <a href='?src=\ref[src];species=1'>[TOGGLE(get_species_sprite)]</a><br>"
	dat += "Colorize organ sprite - <a href='?src=\ref[src];color=1'>[TOGGLE(colorize_organ)]</a><br>"
	dat += "Use simple icon_state build - <a href='?src=\ref[src];simple=1'>[TOGGLE(simple_setup)]</a><br>"
	dat += "Cache human body sprite - <a href='?src=\ref[src];cache=1'>[TOGGLE(cache_sprites)]</a><br>"
	dat += "Head sprite has special update_icon  - <a href='?src=\ref[src];special=1'>[TOGGLE(special_update)]</a><br>"
	dat += "</body></html>"

	user << browse(jointext(dat, null), "window=test_sprite;size=330x220")

/mob/verb/debug_human_sprite_build()
	if(!appearance_test)
		appearance_test = new()
	appearance_test.interact(src)

/datum/appearance_test/Topic(href, href_list)
	if(!check_rights(R_SERVER, 1))
		return
	var/rebuild = FALSE
	if(href_list["build"])
		build_body = !build_body
		rebuild = TRUE
	if(href_list["color"])
		colorize_organ = !colorize_organ
		rebuild = TRUE
	if(href_list["species"])
		get_species_sprite = !get_species_sprite
		rebuild = TRUE
	if(href_list["simple"])
		simple_setup = !simple_setup
		rebuild = TRUE
	if(href_list["cache"])
		cache_sprites = !cache_sprites
		rebuild = TRUE
	if(href_list["special"])
		special_update = !special_update
		rebuild = TRUE

	if(rebuild)
		rebuild_humans()
		interact(usr)

/mob/living/carbon/human/appearance_test/New()
	s_tone = -rand(10, 210)
	eyes_color = rgb(rand(1,220),rand(1,220),rand(1,220))
	..()
	var/list/organs = list(BP_L_ARM, BP_R_ARM, BP_R_HAND, BP_L_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	for(var/i = 1 to 2)
		var/organ = pick(organs)
		organs -= organ
		if(organs_by_name[organ])
			qdel(organs_by_name[organ])
	force_update_limbs()
	update_body()