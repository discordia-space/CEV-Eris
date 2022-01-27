//A 'wound' system for space suits.
//Breaches greatly increase the amount of lost gas and decrease the armour rating of the suit.
//They can be healed with plastic or69etal sheeting.

/datum/breach
	var/class = 0                           // Size. Lower is smaller. Uses floating point69alues!
	var/descriptor                          // 'gaping hole' etc.
	var/damtype = BURN                      // Punctured or69elted
	var/obj/item/clothing/suit/space/holder // Suit containing the list of breaches holding this instance.

/obj/item/clothing/suit/space
	bad_type = /obj/item/clothing/suit/space
	var/can_breach = 1                      // Set to 0 to disregard all breaching.
	var/list/breaches = list()              // Breach datum container.
	var/resilience = 0.1                    //69ultiplier that turns damage into breach class. 1 is 100% of damage to breach, 0.1 is 10%. 0.2 -> 50 brute/burn damage to cause 10 breach damage
	var/breach_threshold = 3                //69in attack damage before a breach is possible. Damage is subtracted by this amount, it determines the "hardness" of the suit.
	var/damage = 0                          // Current total damage
	var/brute_damage = 0                    // Specifically brute damage.
	var/burn_damage = 0                     // Specifically burn damage.
	var/base_name                           // Used to keep the original name safe while we apply69odifiers.
	var/syle = 0

/obj/item/clothing/suit/space/Initialize(mapload, ...)
	. = ..()
	base_name = "69name69"

//Some simple descriptors for breaches. Global because lazy, TODO: work out a better way to do this.

var/global/list/breach_brute_descriptors = list(
	"tiny puncture",
	"ragged tear",
	"large split",
	"huge tear",
	"gaping wound"
	)

var/global/list/breach_burn_descriptors = list(
	"small burn",
	"melted patch",
	"sizable burn",
	"large scorched area",
	"huge scorched area"
	)

/datum/breach/proc/update_descriptor()
	//Sanity...
	class = between(1, round(class), 5)
	//Apply the correct descriptor.
	if(damtype == BURN)
		descriptor = breach_burn_descriptors69class69
	else if(damtype == BRUTE)
		descriptor = breach_brute_descriptors69class69

//Repair a certain amount of brute or burn damage to the suit.
/obj/item/clothing/suit/space/proc/repair_breaches(var/damtype,69ar/amount,69ar/mob/user)

	if(!can_breach || !breaches || !breaches.len || !damage)
		to_chat(user, "There are no breaches to repair on \the 69src69.")
		return

	var/list/valid_breaches = list()

	for(var/datum/breach/B in breaches)
		if(B.damtype == damtype)
			valid_breaches += B

	if(!valid_breaches.len)
		to_chat(user, "There are no breaches to repair on \the 69src69.")
		return

	var/amount_left = amount
	for(var/datum/breach/B in69alid_breaches)
		if(!amount_left) break

		if(B.class <= amount_left)
			amount_left -= B.class
			valid_breaches -= B
			breaches -= B
		else
			B.class	-= amount_left
			amount_left = 0
			B.update_descriptor()

	user.visible_message("<b>69user69</b> patches some of the damage on \the 69src69.")
	calc_breach_damage()

/obj/item/clothing/suit/space/proc/create_breaches(var/damtype,69ar/amount)
	amount -= src.breach_threshold
	amount *= src.resilience

	if(!can_breach || amount <= 0)
		return

	if(!breaches)
		breaches = list()

	if(damage > 25) return //We don't need to keep tracking it when it's at 250% pressure loss, really.

	if(!loc) return
	var/turf/T = get_turf(src)
	if(!T) return

	//Increase existing breaches.
	for(var/datum/breach/existing in breaches)

		if(existing.damtype != damtype)
			continue

		//keep in69ind that 10 breach damage == full pressure loss.
		//a breach can have at69ost 5 breach damage
		if (existing.class < 5)
			var/needs = 5 - existing.class
			if(amount < needs)
				existing.class += amount
				amount = 0
			else
				existing.class = 5
				amount -= needs

			if(existing.damtype == BRUTE)
				T.visible_message("<span class = 'warning'>\The 69existing.descriptor69 on 69src69 gapes wider!</span>")
			else if(existing.damtype == BURN)
				T.visible_message("<span class = 'warning'>\The 69existing.descriptor69 on 69src69 widens!</span>")

	if (amount)
		//Spawn a new breach.
		var/datum/breach/B = new()
		breaches += B

		B.class =69in(amount,5)

		B.damtype = damtype
		B.update_descriptor()
		B.holder = src

		if(B.damtype == BRUTE)
			T.visible_message("<span class = 'warning'>\A 69B.descriptor69 opens up on 69src69!</span>")
		else if(B.damtype == BURN)
			T.visible_message("<span class = 'warning'>\A 69B.descriptor6969arks the surface of 69src69!</span>")

	calc_breach_damage()

//Calculates the current extent of the damage to the suit.
/obj/item/clothing/suit/space/proc/calc_breach_damage()

	damage = 0
	brute_damage = 0
	burn_damage = 0

	if(!can_breach || !breaches || !breaches.len)
		name = base_name
		return 0

	for(var/datum/breach/B in breaches)
		if(!B.class)
			src.breaches -= B
			qdel(B)
		else
			damage += B.class
			if(B.damtype == BRUTE)
				brute_damage += B.class
			else if(B.damtype == BURN)
				burn_damage += B.class

	if(damage >= 3)
		if(brute_damage >= 3 && brute_damage > burn_damage)
			name = "punctured 69base_name69"
		else if(burn_damage >= 3 && burn_damage > brute_damage)
			name = "scorched 69base_name69"
		else
			name = "damaged 69base_name69"
	else
		name = "69base_name69"

	return damage

//Handles repairs (and also upgrades).

/obj/item/clothing/suit/space/attackby(obj/item/I,69ob/user)

	//Using duct tape, you can repair both types of breaches while still wearing the suit!
	if(I.has_quality(QUALITY_SEALING))
		if(!damage && !burn_damage)
			to_chat(user, "There is no surface damage on \the 69src69 to repair.")
			return

		user.visible_message("69user69 starts repairing breaches on their 69src69 with the 69I69", "You start repairing breaches on the 69src69 with the 69I69")
		if (I.use_tool(user, src, 60 + (damage*10), QUALITY_SEALING, 0, STAT_MEC))
			to_chat(user, "There we go, that should hold nicely!")
			repair_breaches(BURN, burn_damage, user)
			repair_breaches(BRUTE, damage, user)
		return

	if(istype(I,/obj/item/stack/material))
		var/repair_power = 0
		switch(I.get_material_name())
			if(MATERIAL_STEEL)
				repair_power = 2
			if("plastic")
				repair_power = 1

		if(!repair_power)
			return

		if(isliving(loc))
			to_chat(user, SPAN_WARNING("How do you intend to patch a hardsuit while someone is wearing it?"))
			return

		if(!brute_damage && !burn_damage)
			to_chat(user, "There is no surface damage on \the 69src69 to repair.")
			return

		var/obj/item/stack/P = I
		var/use_amt =69in(P.get_amount(), 3)
		if(use_amt && P.use(use_amt))
			repair_breaches(BURN, use_amt * repair_power, user)
		return

	else if(QUALITY_WELDING in I.tool_qualities)

		if(isliving(loc))
			to_chat(user, SPAN_WARNING("How do you intend to patch a hardsuit while someone is wearing it?"))
			return

		if (!damage && ! brute_damage)
			to_chat(user, SPAN_WARNING("There is no structural damage on \the 69src69 to repair."))
			return

		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			repair_breaches(BRUTE, 3, user)
			to_chat(user, SPAN_NOTICE("You repair the damage on the 69src69."))
			return

		return

	..()

/obj/item/clothing/suit/space/examine(mob/user)
	..(user)
	if(can_breach && breaches && breaches.len)
		for(var/datum/breach/B in breaches)
			to_chat(user, "\red <B>It has \a 69B.descriptor69.</B>")


