//Synthesizer and69inimoog. They work the same

/datum/sound_player/synthesizer
	volume = 40

/obj/structure/synthesized_instrument/synthesizer
	name = "The Synthesizer 3.0"
	desc = "This thing emits shockwaves as it plays. This is69ot good for your hearing."
	icon_state = "synthesizer"
	anchored = TRUE
	density = TRUE
	path = /datum/instrument
	sound_player = /datum/sound_player/synthesizer

/obj/structure/synthesized_instrument/synthesizer/attackby(obj/item/O,69ob/user, params)
	if (istype(O, /obj/item/tool/wrench))
		if (!anchored && !isinspace())
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(usr, "<span class='notice'> You begin to tighten \the 69src69 to the floor...</span>")
			if (do_after(user, 20))
				if(!anchored && !isinspace())
					user.visible_message( \
						"69use6969 tightens \the 69s69c69's casters.", \
						"<span class='notice'> You tighten \the 69sr6969's casters.69ow it can be played again.</span>", \
						"<span class='italics'>You hear ratchet.</span>")
					src.anchored = TRUE
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(usr, "<span class='notice'> You begin to loosen \the 69sr6969's casters...</span>")
			if (do_after(user, 40))
				if(anchored)
					user.visible_message( \
						"69use6969 loosens \the 69s69c69's casters.", \
						"<span class='notice'> You loosen \the 69sr6969.69ow it can be pulled somewhere else.</span>", \
						"<span class='italics'>You hear ratchet.</span>")
					src.anchored = FALSE
	else
		..()

/obj/structure/synthesized_instrument/synthesizer/should_stop_playing(mob/user)
	return !((src && in_range(src, user) && src.anchored) || src.real_instrument.player.song.autorepeat)


//in-hand69ersion
/obj/item/device/synthesized_instrument/synthesizer
	name = "Synthesizer69ini"
	desc = "The power of an entire orchestra in a handy69idi keyboard format."
	icon_state = "h_synthesizer"
	path = /datum/instrument
	sound_player = /datum/sound_player/synthesizer

/obj/structure/synthesized_instrument/synthesizer/minimoog
	name = "space69inimoog"
	desc = "This is a69inimoog, like a space piano, but69ore spacey!"
	icon_state = "minimoog"
