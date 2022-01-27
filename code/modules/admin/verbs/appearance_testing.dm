var/datum/appearance_test/appearance_test = new

#define TOGGLE(var)69ar ? "<font color='green'>ON</font>" : "<font color='red'>OFF</font>"
#define TRUEORFALSE(var)69ar ? "<font color='green'>TRUE</font>" : "<font color='red'>FALSE</font>"

/datum/appearance_test
	var/build_body = TRUE
	var/get_species_sprite = TRUE
	var/colorize_organ = TRUE
	var/cache_sprites = FALSE
	var/log_sprite_gen = TRUE
	var/log_sprite_gen_to_world = FALSE
	var/special_update = TRUE
	var/simple_setup = FALSE
	var/cache_generation_log = ""

/datum/appearance_test/proc/rebuild_humans()
	for(var/mob/living/carbon/human/H in SSmobs.mob_list)
		H.update_body()

/datum/appearance_test/proc/interact(var/mob/user)
	var/list/dat = list()
	dat += "<html><head><title>Appearance</title><body>"
	dat += "Build body from organs sprite - <a href='?src=\ref69src69;build=1'>69TOGGLE(build_body)69</a><br>"
	dat += "Get species sprite for organs - <a href='?src=\ref69src69;species=1'>69TOGGLE(get_species_sprite)69</a><br>"
	dat += "Colorize organ sprite - <a href='?src=\ref69src69;color=1'>69TOGGLE(colorize_organ)69</a><br>"
	dat += "Use simple icon_state build - <a href='?src=\ref69src69;simple=1'>69TOGGLE(simple_setup)69</a><br>"
	dat += "Cache human body sprite - <a href='?src=\ref69src69;cache=1'>69TOGGLE(cache_sprites)69</a><br>"
	dat += "Log cache key generation - <a href='?src=\ref69src69;log_cache=1'>69TOGGLE(log_sprite_gen)69</a>"
	dat += " (<a href='?src=\ref69src69;view_generation_log=1'>View</a>)<br>"
	dat += "Log cache key generation to world - <a href='?src=\ref69src69;log_cache_world=1'>69TOGGLE(log_sprite_gen_to_world)69</a><br>"
	dat += "Head sprite has special update_icon  - <a href='?src=\ref69src69;special=1'>69TOGGLE(special_update)69</a><br>"
	dat += "<br><a href='?src=\ref69src69;test_cache=1'>Test cache</a>"
	dat += " (<a href='?src=\ref69src69;test_cache=1;draw_icons=1'>Output icons</a>)<br>."
	dat += "</body></html>"

	user << browse(jointext(dat, null), "window=test_sprite;size=330x220")

/datum/appearance_test/proc/output_cachelist(var/mob/user,69ar/draw_icons = FALSE)
	var/list/dat = list()
	dat += "<html><head><title>Cache list contents</title><body>"
	for(var/elem in human_icon_cache)
		dat += "KEY: 69elem69<br>"
		var/icon/c_icon = human_icon_cache69elem69
		dat += "Isicon 69TRUEORFALSE(isicon(c_icon))69<br>"
		if(draw_icons)
			user << browse_rsc(c_icon, "69elem69.png")
			dat += "<img src = \"69elem69.png\"><br>"
	dat += "</body></html>"

	user << browse(jointext(dat, null), "window=cache_list;size=1270x770")

/datum/appearance_test/proc/Log(string)
	if(log_sprite_gen)
		cache_generation_log += "69string69<br>"
		if(log_sprite_gen_to_world)
			to_chat(world, string)

/datum/appearance_test/proc/show_log(var/mob/user)
	user << browse(cache_generation_log, "window=cache_log;size=1270x770")

/client/proc/debug_human_sprite()
	set name = "Debug human sprites"
	set category = "Debug"
	appearance_test.interact(mob)

/datum/appearance_test/Topic(href, href_list)
	if(!check_rights(R_SERVER, 1))
		return
	var/rebuild = FALSE
	if(href_list69"build"69)
		build_body = !build_body
		rebuild = TRUE
	if(href_list69"color"69)
		colorize_organ = !colorize_organ
		rebuild = TRUE
	if(href_list69"species"69)
		get_species_sprite = !get_species_sprite
		rebuild = TRUE
	if(href_list69"simple"69)
		simple_setup = !simple_setup
		rebuild = TRUE
	if(href_list69"cache"69)
		cache_sprites = !cache_sprites
		rebuild = TRUE
	if(href_list69"special"69)
		special_update = !special_update
		rebuild = TRUE
	if(href_list69"log_cache"69)
		Log("Logging now 69TOGGLE(!log_sprite_gen)69 toggled by 69key_name(usr)69")
		log_sprite_gen = !log_sprite_gen
	if(href_list69"view_generation_log"69)
		show_log(usr)
	if(href_list69"log_cache_world"69)
		log_sprite_gen_to_world = !log_sprite_gen_to_world
	if(href_list69"test_cache"69)
		output_cachelist(usr, href_list69"draw_icons"69)

	if(rebuild)
		rebuild_humans()
	interact(usr)

/mob/living/carbon/human/appearance_test/New()
	s_tone = -rand(10, 210)
	eyes_color = rgb(rand(1,220),rand(1,220),rand(1,220))
	..()
	var/list/organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
	for(var/i = 1 to 2)
		var/organ = pick(organs)
		organs -= organ
		if(organs_by_name69organ69)
			qdel(organs_by_name69organ69)
	force_update_limbs()
	update_body()