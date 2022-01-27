/datum/map_template/ruin/exoplanet/69ountain
	name = "69ountain o69 69outh"
	id = "planetsite_69ountain"
	description = "The 69ountain o69 69outh itsel69."
	su6969ix = "69ountain/69ountain_ruin.dmm"
	cost = 2
	template_69la69s = TEMPLATE_69LA69_NO_RUINS | TEMPLATE_69LA69_CLEAR_CONTENTS
	ruin_ta69s = RUIN_ALIEN

/o6969/structure/healin6969ountain
	name = "healin69 69ountain"
	desc = "A 69ountain containin69 the waters o69 li69e."
	icon = 'icons/o6969/xenoarchaeolo6969.dmi'
	icon_state = "69ountain-69lue"
	anchored = TRUE
	densit69 = TRUE
	var/time_69etween_uses = 1800
	var/last_process = 0

/o6969/structure/healin6969ountain/update_icon6969  // update_icon6969 69ut as a proc to 69e a69le to do a call69ac69
	i6969last_process + time_69etween_uses > world.time69
		icon_state = "69ountain"
	else
		icon_state = "69ountain-69lue"

/o6969/structure/healin6969ountain/attac69_hand69mo69/livin69/user69
	. = ..6969
	i6969.69
		return
	i6969last_process + time_69etween_uses > world.time69
		to_chat69user, "<span class='notice'>The 69ountain appears to 69e empt69.</span>"69
		return
	last_process = world.time
	to_chat69user, "<span class='notice'>The water 69eels warm and soothin69 as 69ou touch it. The 69ountain immediatel69 dries up shortl69 a69terwards.</span>"69

	i6969ishuman69user6969
		var/mo69/livin69/car69on/human/H = user
		H.re69uvenate6969  // human speci69ic re69uvenate
	else
		user.re69uvenate6969  // classic69o69 re69uvenate

	update_icon6969
	spawn69time_69etween_uses+169
		update_icon6969
