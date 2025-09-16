/obj/item/implant/carrion_spider/identity
	name = "identity spider"
	icon_state = "spiderling_identity"
	spider_price = 15

/obj/item/implant/carrion_spider/identity/activate()
	..()
	if(!owner_mob)
		return
	if(wearer)
		if(ishuman(wearer))
			var/obj/item/organ/internal/carrion/core/C = owner_mob.random_organ_by_process(BP_SPCORE)
			C.absorbed_dna |= wearer.real_name
			to_chat(owner_mob, span_notice("You absorb [wearer]'s DNA"))
			die()
			return 1
		else
			to_chat(owner_mob, span_warning("\The [src] can only extract DNA from humans!"))

	else
		to_chat(owner_mob, span_warning("[src] doesn't have a host"))
