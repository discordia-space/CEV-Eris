
/obj/item/implant/carrion_spider/cyber_spider
	name = "brain-tech interface spider"
	desc = "A small spider with lots of dangling nerve terminations. They seek something to connect to"
	icon = 'icons/obj/neuralink.dmi'
	icon_state = "carrion"
	cruciform_resist = TRUE
	hidden = TRUE
	spider_price = 45

/obj/item/implant/carrion_spider/cyber_spider/install(mob/living/carbon/human/target, organ, mob/user)
	if(!istype(target))
		return FALSE
	if(organ && target.has_organ(organ))
		var/obj/item/organ/external/bodypart = target.organs_by_name[organ]
		var/obj/item/organ/internal/vital/brain/brainz = locate() in target
		var/obj/item/implant/cyberinterface/anyInterface = locate() in bodypart.implants
		if(anyInterface)
			to_chat(user, SPAN_NOTICE("\The [target] already has a interface installed!"))
			return FALSE
		if(brainz && brainz.parent == bodypart)
			var/obj/item/implant/cyberinterface/carrion/spiderInterface = new(NULLSPACE)
			spiderInterface.install(target, organ, user)
			qdel(src)
			return TRUE
		else
			to_chat(user, SPAN_NOTICE("\The [target] has no brain here to link with! Try aiming for the head."))
			return FALSE


