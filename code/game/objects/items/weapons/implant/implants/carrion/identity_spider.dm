/obj/item/implant/carrion_spider/identity
	name = "identity spider"
	icon_state = "spiderling_identity"
	spider_price = 15

/obj/item/implant/carrion_spider/identity/activate()
	..()
	if(!owner_mob)
		return
	if(wearer)
		if(wearer.type == /mob/living/carbon/human)
			var/obj/item/organ/internal/carrion/core/C = owner_mob.random_organ_by_process(BP_SPCORE)
			// if there is already one it just updates
			C.absorbed_dna[wearer.real_name] = list(
				"name" = wearer.real_name,
				"voice" = wearer.tts_seed,
				"hair_color" = wearer.hair_color,
				"hair_style" = wearer.h_style,
				"beard_color" = wearer.facial_color,
				"beard_style" = wearer.f_style,
				"skin_color" = wearer.skin_color,
				"skin_tone" = wearer.s_tone,
				"eye_color" = wearer.eyes_color,
				"flavor_text" = wearer.flavor_text
			)
			to_chat(owner_mob, SPAN_NOTICE("You absorb [wearer]'s DNA"))
			die()
			return 1
		else
			to_chat(owner_mob, SPAN_WARNING("\The [src] can only extract DNA from humans!"))

	else
		to_chat(owner_mob, SPAN_WARNING("[src] doesn't have a host"))
