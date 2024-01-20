/obj/item/complicator
	name = "Reality Complicator"
	desc = "A weird device of unknown origin. A note on the side says \'Do not press.\'"
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "complicator"
	item_state = "complicator"
	commonLore = "The only known instance of an artifact which can condense bluespace power into physical matter. Further studies haven't been funded into finding out why."
	volumeClass = ITEM_SIZE_SMALL
	price_tag = 20000
	origin_tech = list(TECH_POWER = 7, TECH_BLUESPACE = 4, TECH_MAGNET = 9)
	spawn_frequency = 0
	spawn_blacklisted = TRUE
	var/last_summon = -20 MINUTES
	var/cooldown = 20 MINUTES

/obj/item/complicator/New()
	..()
	GLOB.all_faction_items[src] = GLOB.department_engineering

/obj/item/complicator/Destroy()
	for(var/mob/living/carbon/human/H in viewers(get_turf(src)))
		SEND_SIGNAL_OLD(H, COMSIG_OBJ_FACTION_ITEM_DESTROY, src)
	GLOB.all_faction_items -= src
	GLOB.technomancer_faction_item_loss++
	..()

/obj/item/complicator/attack_self()
	var/mob/living/carbon/human/user = src.loc
	if(world.time >= (last_summon + cooldown))
		var/mod = pick(EVENT_LEVEL_MUNDANE, EVENT_LEVEL_MODERATE, EVENT_LEVEL_MAJOR, EVENT_LEVEL_ROLESET)
		var/rand_points = rand(10, 120)
		GLOB.storyteller.points[mod] += rand_points
		last_summon = world.time
		visible_message(SPAN_DANGER("[user] pressed the big red button on [src]!"))
		user.apply_effect((rand_points/10),IRRADIATE)

	else
		to_chat(user, SPAN_WARNING("The [src] needs more time to recalibrate!"))

/obj/item/complicator/attackby(obj/item/I, mob/living/user, params)
	if(nt_sword_attack(I, user))
		return
	..()
