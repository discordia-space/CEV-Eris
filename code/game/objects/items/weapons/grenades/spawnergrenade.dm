/obj/item/grenade/spawnergrenade
	desc = "It is set to detonate in 5 seconds. It will unleash unleash an unspecified anomaly into the69icinity."
	name = "delivery grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "delivery"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4)
	var/banglet = 0
	var/spawner_type = null //69ust be an object path
	var/deliveryamt = 1 // amount of type to deliver

/obj/item/grenade/spawnergrenade/prime()	// Prime now just handles the two loops that 69uery for people in lockers and people who can see it.

	if(spawner_type && deliveryamt)
		//69ake a 69uick flash
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/human/M in69iewers(T, null))
			if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
				if (M.HUDtech.Find("flash"))
					flick("e_flash",69.HUDtech69"flash"69)

		for(var/i=1, i<=deliveryamt, i++)
			var/atom/movable/x = new spawner_type
			x.loc = T
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(x, pick(NORTH,SOUTH,EAST,WEST))

			// Spawn some hostile syndicate critters

	69del(src)
	return

/obj/item/grenade/spawnergrenade/manhacks
	name = "manhack delivery grenade"
	desc = "Deploys a swarm of floating robots that will attack anything nearby."
	spawner_type = /mob/living/simple_animal/hostile/viscerator
	deliveryamt = 5
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_COVERT = 4)


/obj/item/grenade/spawnergrenade/blob
	name = "bioweapon sample"
	desc = "Contains an absurdly dangerous bioweapon in suspended animation. It will expand rapidly upon release. Once deployed, run like hell."
	spawner_type = /obj/effect/blob/core
	deliveryamt = 1
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_COVERT = 4)