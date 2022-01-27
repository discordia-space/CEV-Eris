// Thanks to Burger from Burgerstation for the foundation for this.
// This code was written by Chinsky for69ebula, I just69ade it compatible with Eris. -69att
GLOBAL_LIST_INIT(floating_chat_colors, list())

/atom/movable
	var/list/stored_chat_text

/atom/movable/proc/animate_chat(message, datum/language/language, small, list/show_to, duration,69erb)
	set waitfor = FALSE

	var/style	//additional style params for the69essage
	var/fontsize = 6
	if(small)
		fontsize = 5
	var/limit = 50
	if(copytext(message, length(message) - 1) == "!!")
		fontsize = 8
		limit = 30
		style += "font-weight: bold;"

	if(length(message) > limit)
		message = "69copytext(message, 1, limit)69..."

	if(!GLOB.floating_chat_colors69name69)
		GLOB.floating_chat_colors69name69 = get_random_colour(0,160,230)
	style += "color: 69GLOB.floating_chat_colors69name6969;"

	// create 269essages, one that appears if you know the language, and one that appears when you don't know the language
	var/image/understood = generate_floating_text(src, capitalize(message), style, fontsize, duration, show_to)
	var/image/gibberish = language ? generate_floating_text(src, language.scramble(message), style, fontsize, duration, show_to) : understood

	for(var/client/C in show_to)
		if(!isdeaf(C.mob) && C.get_preference_value(/datum/client_preference/floating_messages) == GLOB.PREF_SHOW)
			if(C.mob.say_understands(null, language))
				C.images += understood
			else
				C.images += gibberish

/proc/generate_floating_text(atom/movable/holder,69essage, style, size, duration, show_to)
	var/image/I = image(null, holder)
	I.layer = FLY_LAYER
	I.alpha = 0
	I.maptext_width = 80
	I.maptext_height = 64
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	I.pixel_x = -round(I.maptext_width/2) + 16

	style = "font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 69size69px; 69style69"
	I.maptext = "<center><span style=\"69style69\">69message69</span></center>"
	animate(I, 1, alpha = 255, pixel_y = 16)

	for(var/image/old in holder.stored_chat_text)
		animate(old, 2, pixel_y = old.pixel_y + 8)
	LAZYADD(holder.stored_chat_text, I)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_floating_text, holder, I), duration)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_images_from_clients, I, show_to), duration + 2)

	return I

/proc/remove_floating_text(atom/movable/holder, image/I)
	animate(I, 2, pixel_y = I.pixel_y + 10, alpha = 0)
	LAZYREMOVE(holder.stored_chat_text, I)

/proc/remove_images_from_clients(image/I, list/show_to)
	for(var/client/C in show_to)
		C.images -= I
		qdel(I)