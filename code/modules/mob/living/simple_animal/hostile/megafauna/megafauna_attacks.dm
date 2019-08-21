/datum/boss_attack
	var/range = 1

	var/req_target_amount = 1
	var/req_target_type = null
	var/req_target_stat = list(CONSCIOUS, UNCONSCIOUS)

	var/req_owner_max_health = 0

	var/telegraph_delay = 0		// Big attacks are telegraphed - message, animation, etc. This is the delay between telegraph and an actual attack.
	var/recovery_time = 10		// The amount of time boss wouldn't act after executing this attack. Big attacks make for big openings.
	var/cooldown = 20			// Attack-specific cooldown time. Makes sure the boss doesn't spam the biggest attacks nonstop.
	var/max_uses = -1			// Max amount of uses for the attack. -1 for unlimited. Limit the amount of "utter BS" attacks a boss can pull.

	var/use_amount = 0			// The amount of times this attack was used by the boss. Used for max_uses.
	var/next_use = 0			// Timestamp. The next time this attack would be usable. Used for cooldown.

	var/flick_icon = null

	var/mob/living/simple_animal/hostile/megafauna/owner

/datum/boss_attack/New(owner)
	..()
	src.owner = owner

/datum/boss_attack/proc/check_target(atom/target)
	if(req_target_type && !istype(target, req_target_type))
		return FALSE

	var/mob/living/L
	if(isliving(target))
		L = target

	if(req_target_stat && (!L || !(L.stat in req_target_stat)))
		return FALSE

	return special_check_target(target)

// Put attack-specific checks here
/datum/boss_attack/proc/special_check_target(atom/target)
	return TRUE


/datum/boss_attack/proc/filter_targets(list/potential_targets)
	var/list/targets = list()

	for(var/target in potential_targets)
		if(check_target(target))
			targets += target

	return targets

/datum/boss_attack/proc/get_targets()
	return filter_targets(view(range, owner))


/datum/boss_attack/proc/can_execute()
	// Cooldown check
	if(world.time < next_use)
		return FALSE

	// Uses check
	if(max_uses != -1 && use_amount > max_uses)
		return FALSE

	// Owner health check
	if((owner.health / owner.getMaxHealth()) > req_owner_max_health)
		return FALSE

	// Generate list of targets
	var/list/targets = get_targets()

	if(length(targets) < req_target_amount)
		return FALSE

	// Return a list of targets for the attack to work on
	return targets



/datum/boss_attack/proc/execute(list/targets)
	pre_attack()

	if(telegraph_delay)
		telegraph_attack(targets)

		sleep(telegraph_delay)

		// Time has passed - get a new set of targets before attacking
		attack(get_targets())
	else
		attack(targets)

	post_attack()


/datum/boss_attack/proc/pre_attack()
	owner.current_attack = src


/datum/boss_attack/proc/telegraph_attack(list/targets)
	return


/datum/boss_attack/proc/attack(list/targets)
	for(var/atom/target in targets)
		attack_target(target)

/datum/boss_attack/proc/attack_target(atom/target)
	return

/datum/boss_attack/proc/post_attack()
	owner.recovery_time = max(world.time + recovery_time, owner.recovery_time)
	owner.current_attack = null

	use_amount++
	next_use = world.time + cooldown


// Basic attack types

// Firing projectiles
/datum/boss_attack/projectile
	var/projectile
	var/fire_sound

/datum/boss_attack/projectile/proc/make_projectile()
	return new projectile(owner.loc)

/datum/boss_attack/projectile/proc/fire(atom/target, target_zone)
	if(fire_sound)
		playsound(owner, fire_sound, 100, 1)

	var/obj/item/projectile/A = make_projectile()
	if(!A)	return

	var/def_zone = target_zone
	if(!target_zone)
		def_zone = get_exposed_defense_zone(target)

	A.launch(target, def_zone)


// Projectiles with casings
// Fires the projectile, drops the casing on the floor
/datum/boss_attack/projectile/casing
	var/casing_type
	var/casing_sound
	var/obj/item/ammo_casing/chambered

/datum/boss_attack/projectile/casing/make_projectile()
	// Make a new casing and return its projectile
	chambered = new casing_type()
	return chambered.BB

/datum/boss_attack/projectile/casing/fire(atom/target, target_zone)
	..()
	// Expend and drop the casing now
	chambered.expend()

	if(chambered.is_caseless)
		qdel(chambered)
	else
		chambered.forceMove(get_turf(owner))
		chambered.on_ejection()

		if(casing_sound)
			playsound(owner, casing_sound, 50, 1)

	chambered = null




// Gib the target, use target's HP to heal self.
/datum/boss_attack/devour
	req_target_type = /mob/living/carbon
	req_target_stat = list(DEAD)

	req_owner_max_health = 0.8	// Only attempt that when damaged

	cooldown = 80
	recovery_time = 20

/datum/boss_attack/devour/attack_target(atom/target)
	var/mob/living/carbon/C = target

	owner.visible_message(
		SPAN_DANGER("[owner] devours [C]!"),
		"<span class='userdanger'>You consume [C], restoring your health!</span>"
		)

	owner.adjustBruteLoss(-C.maxHealth/2)
	C.gib()

