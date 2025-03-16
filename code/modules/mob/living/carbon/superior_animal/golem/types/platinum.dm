#define PLATINUM_CHARGE_DAMAGE_OBSTACLES 50
#define PLATINUM_CHARGE_DAMAGE_TARGET 50
#define PLATINUM_CHARGE_CD 30 SECONDS
#define PLATINUM_CHARGE_WINDUP 1.5 SECONDS
#define PLATINUM_CHARGE_RANGE 5

/mob/living/carbon/superior_animal/golem/platinum // platinum golems charge at the player for heavy damage. the charge can be dodged.
	name = "platinum golem"
	desc = "A sleek-looking pile of rocks with platinum rings running through it."
	icon_state = "golem_platinum"
	icon_living = "golem_platinum"

	// Health related variables
	maxHealth = GOLEM_HEALTH_HIGH
	health = GOLEM_HEALTH_HIGH

	// Movement related variables
	move_to_delay = GOLEM_SPEED_SLUG
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_LOW
	melee_damage_upper = GOLEM_DMG_MED

	// Armor related variables
	armor = list(
		melee = 0,
		bullet = GOLEM_ARMOR_HIGH,
		energy = GOLEM_ARMOR_MED,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related variables
	mineral_name = ORE_PLATINUM

	var/charge_verbs = list("launches itself", "charges", "rams")
	var/charge_hit_verbs = list("crashes into", "smashes", "slams into")
	var/charge_cooldown = 0

/mob/living/carbon/superior_animal/golem/platinum/handle_ai() // half of this proc is just the visuals. the visuals are irritatingly difficult with this method of actually charging
	. = ..()

	if(target_mob && (world.time > charge_cooldown) && (get_dist_euclidian(src, target_mob) < PLATINUM_CHARGE_RANGE))
		charge_cooldown = world.time + PLATINUM_CHARGE_CD

		walk(src,0) // halt movement
		visible_message(SPAN_DANGER("<b>[src]</b> stops and prepares to charge at [target_mob]!"))
		var/list/passedturfs = getline(src, target_mob) // do this at the start of the windup, so that the golem's charge doesn't track the target (and it can be dodged)

		spawn(PLATINUM_CHARGE_WINDUP)
			var/turf/lastvalidturf
			var/turf/lineend = passedturfs[(passedturfs.len)]
			if(target_mob in lineend.contents) //if the target hasn't moved, cut off the end of the line so we don't end up on top of them
				passedturfs -= lineend

			var/vfxindex = passedturfs.len - 1
			var/vfxfalloff = 250 / max((passedturfs.len - 1),1)

			for(var/turf/targetturf in passedturfs)
				if(turf_clear_ignore_cables_and_mobs(targetturf))
					lastvalidturf = targetturf
					vfxindex--

					new /obj/effect/decal/cleanable/rubble(targetturf)

					if((vfxindex >= 0) && (passedturfs.len >= 1)) //every turf except the one we end on.
						var/obj/effect/temp_visual/long/charge_effect = new /obj/effect/temp_visual/long(targetturf)
						charge_effect.icon = icon
						charge_effect.icon_state = icon_state // copy over the icon and direction
						charge_effect.dir = dir
						charge_effect.alpha = 250 - (vfxfalloff * vfxindex) // todo: linear interpolation math so that this looks consistent at all distances
						animate(charge_effect, time = 25 - ((vfxfalloff * vfxindex) / 10), alpha = 0)

					for(var/mob/living/victim in targetturf.contents)
						if(victim != src)
							victim.adjustBruteLoss(PLATINUM_CHARGE_DAMAGE_OBSTACLES)
				else
					for(var/atom/victim in targetturf.contents)
						victim.explosion_act(PLATINUM_CHARGE_DAMAGE_OBSTACLES * 4) //TEAR THROUGH ALL THAT IMPEDES YOU
					break // if the turf is blocked (ie a wall/door/window), stop charging here

			visible_message(SPAN_DANGER("<b>[src]</b> [pick(charge_verbs)] at [target_mob]!"))
			forceMove(lastvalidturf)

			if(Adjacent(target_mob))
				target_mob.attack_generic(src, PLATINUM_CHARGE_DAMAGE_TARGET, pick(charge_hit_verbs), FALSE, FALSE, FALSE, 1)

			playsound(loc, 'sound/weapons/melee/blunthit.ogg', attack_sound_volume, 1)
			walk_to(src, target_mob, 1, move_to_delay) // continue moving towards the target once the charge is finished

#undef PLATINUM_CHARGE_DAMAGE_OBSTACLES
#undef PLATINUM_CHARGE_DAMAGE_TARGET
#undef PLATINUM_CHARGE_CD
#undef PLATINUM_CHARGE_WINDUP
#undef PLATINUM_CHARGE_RANGE
