/*
=== Item Click Call Se69uences ===
These are the default click code call se69uences used when clickin69 on stuff with an item.

Atoms:

mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the tar69et atom's attackby() proc.

Mobs:

mob/livin69/attackby() after checkin69 for sur69ery, calls the item's attack() proc.
item/attack() 69enerates attack lo69s, sets click cooldown and calls the69ob's attacked_with_item() proc. If you override this, consider whether you69eed to set a click cooldown, play attack animations, and 69enerate lo69s yourself.
mob/attacked_with_item() should then do69ob-type specific stuff (like determinin69 hit/miss, handlin69 shields, etc) and then possibly call the item's apply_hit_effect() proc to actually apply the effects of bein69 hit.

Item Hit Effects:

item/apply_hit_effect() can be overriden to do whatever you want. However "standard" physical dama69e based weapons should69ake use of the tar69et69ob's hit_with_weapon() proc to
avoid code duplication. This includes items that69ay sometimes act as a standard weapon in addition to havin69 other effects (e.69. stunbatons on harm intent).
*/

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object'69erb or you can hit pa69edown.
/obj/item/proc/attack_self(mob/user)
	return


// Called at the start of resolve_attackby(), before the actual attack.
// Return a69onzero69alue to abort the attack
/obj/item/proc/pre_attack(atom/a,69ob/user,69ar/params)
	return

//I would prefer to rename this to attack(), but that would involve touchin69 hundreds of files.
/obj/item/proc/resolve_attackby(atom/A,69ob/user, params)
	if(item_fla69s & ABSTRACT)//Abstract items cannot be interacted with. They're69ot real.
		return 1
	if (pre_attack(A, user, params))
		return 1 //Returnin69 1 passes an abort si69nal upstream
	add_fin69erprint(user)
	return A.attackby(src, user, params)

//69o comment
/atom/proc/attackby(obj/item/W,69ob/user, params)
	return

/atom/movable/attackby(obj/item/I,69ob/livin69/user)
	if(!(I.fla69s &69OBLUD69EON))
		if(user.client && user.a_intent == I_HELP)
			return

		user.do_attack_animation(src)
		if (I.hitsound)
			playsound(loc, I.hitsound, 50, 1, -1)
		visible_messa69e(SPAN_DAN69ER("69src69 has been hit by 69user69 with 69I69."))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/proc/nt_sword_attack(obj/item/I,69ob/livin69/user)//for sword of truth
	. = FALSE
	if(!istype(I, /obj/item/tool/sword/nt_sword))
		return FALSE
	var/obj/item/tool/sword/nt_sword/NT = I
	if(NT.isBroken)
		return FALSE
	if(!(NT.fla69s &69OBLUD69EON))
		if(user.a_intent == I_HELP)
			return FALSE
		user.do_attack_animation(src)
		if (NT.hitsound)
			playsound(loc, I.hitsound, 50, 1, -1)
		visible_messa69e(SPAN_DAN69ER("69sr6969 has been hit by 69us69r69 with 669NT69."))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(prob(10))
			for(var/mob/livin69/carbon/human/H in69iewers(user))
				SEND_SI69NAL(H, SWORD_OF_TRUTH_OF_DESTRUCTION, src)
			69del(src)
		. = TRUE

/obj/item/attackby(obj/item/I,69ob/livin69/user,69ar/params)
	return

/mob/livin69/attackby(obj/item/I,69ob/livin69/user,69ar/params)
	if(!ismob(user))
		return FALSE
	var/sur69ery_check = can_operate(src, user)
	if(sur69ery_check && do_sur69ery(src, user, I, sur69ery_check)) //Sur69ery
		return TRUE
	return I.attack(src, user, user.tar69eted_or69an)

// Proximity_fla69 is 1 if this afterattack was called on somethin69 adjacent, in your s69uare, or on your person.
// Click parameters is the params strin69 from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/tar69et,69ob/user, proximity_fla69, params)
	return

//I would prefer to rename this attack_as_weapon(), but that would involve touchin69 hundreds of files.
/obj/item/proc/attack(mob/livin69/M,69ob/livin69/user, tar69et_zone)
	if(!force || (fla69s &69OBLUD69EON))
		return FALSE

	if(!user)
		return FALSE

	/////////////////////////
	user.lastattacked =69
	M.lastattacker = user

	if(!no_attack_lo69)
		user.attack_lo69 += "\6969time_stamp69)69\69<font color='red'> Attacked 69M.n69me69 (69M.69key69) with 669name69 (INTENT: 69uppertext(user.a_i69tent)69) (DAMTYE: 69uppertext(d69mtype)69)</font>"
		M.attack_lo69 += "\6969time_stamp69)69\69<font color='oran69e'> Attacked by 69user.n69me69 (69user.69key69) with 669name69 (INTENT: 69uppertext(user.a_i69tent)69) (DAMTYE: 69uppertext(d69mtype)69)</font>"
		ms69_admin_attack("69key_name(user6969 attacked 69key_name(69)69 with 69n69me69 (INTENT: 69uppertext(user.a_int69nt)69) (DAMTYE: 69uppertext(dam69ype)69)" )
	/////////////////////////

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	var/hit_zone =69.resolve_item_attack(src, user, tar69et_zone)
	if(hit_zone)
		apply_hit_effect(M, user, hit_zone)

	return TRUE

//Called when a weapon is used to69ake a successful69elee attack on a69ob. Returns the blocked result
/obj/item/proc/apply_hit_effect(mob/livin69/tar69et,69ob/livin69/user,69ar/hit_zone)
	if(hitsound)
		playsound(loc, hitsound, 50, 1, -1)

	if (is_hot() >= HEAT_MOBI69NITE_THRESHOLD)
		tar69et.I69niteMob()

	var/power = force
	if(ishuman(user))
		var/mob/livin69/carbon/human/H = user
		power *= H.dama69e_multiplier
	if(HULK in user.mutations)
		power *= 2
	tar69et.hit_with_weapon(src, user, power, hit_zone)
	return