 ////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/syringe.dmi'
	item_state = "syringe"
	icon_state = "0"
	matter = list(MATERIAL_GLASS = 1,69ATERIAL_STEEL = 1)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts =69ull
	volume = 15
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	sharp = TRUE
	unacidable = 1 //glass
	reagent_flags = TRANSPARENT
	var/mode = SYRINGE_DRAW
	var/breakable = TRUE
	var/image/filling //holds a reference to the current filling overlay
	var/visible_name = "a syringe"
	var/time = 30

/obj/item/reagent_containers/syringe/on_reagent_change()
	if(mode == SYRINGE_INJECT && !reagents.total_volume)
		mode = SYRINGE_DRAW
	else if(mode == SYRINGE_DRAW && !reagents.get_free_space())
		mode = SYRINGE_INJECT
	..()

/obj/item/reagent_containers/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attack_self(mob/user as69ob)
	switch(mode)
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/reagent_containers/syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attackby(obj/item/I as obj,69ob/user as69ob)
	return

/obj/item/reagent_containers/syringe/afterattack(atom/target,69ob/user, proximity)
	if(!proximity || !target.reagents)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_WARNING("This syringe is broken!"))
		return

	if(user.a_intent == I_HURT && ismob(target))
		if((CLUMSY in user.mutations) && prob(50))
			target = user
		syringestab(target, user)
		return

	switch(mode)
		if(SYRINGE_DRAW)
			if(!reagents.get_free_space())
				to_chat(user, SPAN_WARNING("The syringe is full."))
				mode = SYRINGE_INJECT
				return

			else if(ismob(target))//Blood!
				if(reagents.has_reagent("blood"))
					to_chat(user, SPAN_NOTICE("There is already a blood sample in this syringe."))
					return
				if(iscarbon(target))
					if(isslime(target))
						to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
						return
					var/amount = reagents.get_free_space()
					var/mob/living/carbon/T = target
					if(!T.dna)
						to_chat(user, SPAN_WARNING("You are unable to locate any blood. (To be specific, your target seems to be69issing their DNA datum)."))
						return
					if(NOCLONE in T.mutations) //target done been et,69o69ore blood in him
						to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
						return

					var/datum/reagent/B
					if(ishuman(T))
						var/mob/living/carbon/human/H = T
						if(H.species && H.species.flags &69O_BLOOD)
							H.reagents.trans_to_obj(src, amount)
						else
							B = T.take_blood(src, amount)
					else
						B = T.take_blood(src,amount)

					if (B)
						reagents.reagent_list += B
						reagents.update_total()
						on_reagent_change()
						reagents.handle_reactions()
					to_chat(user, SPAN_NOTICE("You take a blood sample from 69target69."))
					for(var/mob/O in69iewers(4, user))
						O.show_message(SPAN_NOTICE("69user69 takes a blood sample from 69target69."), 1)

			else //if69ot69ob
				if(!target.reagents.total_volume)
					to_chat(user, SPAN_NOTICE("69target69 is empty."))
					return

				if(!target.is_drawable())
					to_chat(user, SPAN_NOTICE("You cannot directly remove reagents from this object."))
					return

				var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
				to_chat(user, SPAN_NOTICE("You fill the syringe with 69trans69 units of the solution."))


		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, SPAN_NOTICE("The syringe is empty."))
				mode = SYRINGE_DRAW
				return
			if(istype(target, /obj/item/implantcase/chem))
				return

			if(!ismob(target) && !target.is_injectable())
				to_chat(user, SPAN_NOTICE("You cannot directly fill this object."))
				return

			if(!target.reagents.get_free_space())
				to_chat(user, SPAN_NOTICE("69target69 is full."))
				return
			if(isliving(target))
				var/mob/living/L = target
				var/injtime = time - (user.stats.getStat(STAT_BIO)*0.375) // 375 was choosen to69ake a steady increase on speed from 0 being default time and 80 being 0, even if its69ever really 0
				if(injtime < 10) injtime=10 //should69ake the "fastest" injection take at least 10

				//Injecting through a hardsuit takes longer due to69eeding to find a port.
				// Handling errors and injection duration
				var/mob/living/carbon/human/H = target
				if(istype(H))
					var/obj/item/clothing/suit/space/SS = H.get_e69uipped_item(slot_wear_suit)
					var/obj/item/rig/RIG = H.get_e69uipped_item(slot_back)
					if((istype(RIG) && RIG.suit_is_deployed()) || istype(SS))
						injtime = injtime * 2
						var/obj/item/organ/external/affected = H.get_organ(BP_CHEST)
						if(BP_IS_ROBOTIC(affected))
							to_chat(user, SPAN_WARNING("Injection port on 69target69's suit is refusing your 69src69."))
							// I think rig is advanced enough for this, and people will learn what causes this error
							if(RIG)
								playsound(src.loc, 'sound/machines/buzz-two.ogg', 30, 1, -3)
								RIG.visible_message("\icon69RIG69\The 69RIG69 states \"Attention: User of this suit appears to be synthetic origin\".")
							return
					// check without69essage
					else if(!H.can_inject(user, FALSE))
						// lets check if user is easily fooled
						var/obj/item/organ/external/affected = H.get_organ(user.targeted_organ)
						if(BP_IS_LIFELIKE(affected) && user && user.stats.getStat(STAT_BIO) < STAT_LEVEL_BASIC)
							break_syringe(user = user)
							to_chat(user, SPAN_WARNING("\The 69src69 have broken while trying to inject 69target69."))
							return
						else
							// if he is69ot lets show him what actually happened
							H.can_inject(user, TRUE)
							return

				else if(!L.can_inject(user, TRUE))
					return

				if(target != user)
					user.setClickCooldown(DEFAULT_69UICK_COOLDOWN)
					user.do_attack_animation(target)
					if(injtime == time - (user.stats.getStat(STAT_BIO)*0.375))
						user.visible_message(SPAN_WARNING("69user69 is trying to inject 69target69 with 69visible_name69!"), SPAN_WARNING("You are trying to inject 69target69 with 69visible_name69!"))
						to_chat(target, SPAN_NOTICE("You feel a tiny prick!"))
					else
						user.visible_message(SPAN_WARNING("69user69 begins hunting for an injection port on 69target69's suit!"),SPAN_WARNING("You begin hunting for an injection port on 69target69's suit!"))

					if(do_mob(user, target, injtime))
						user.visible_message(SPAN_WARNING("69user69 injects 69target69 with 69src69!"),SPAN_WARNING("You inject 69target69 with 69src69!"))
					else
						return
				else
					user.visible_message(SPAN_WARNING("69user69 injects \himself with 69src69!"), SPAN_WARNING("You inject yourself with 69src69."), range = 3)
			var/trans
			if(ismob(target))
				trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
				admin_inject_log(user, target, src, reagents.log_list(), trans)
				// user's stat check that causing pain if they are amateur
				var/mob/living/carbon/human/H = target
				if(istype(H))
					var/obj/item/organ/external/affecting = H.get_organ(user.targeted_organ)
					if(user && user.stats.getStat(STAT_BIO) < STAT_LEVEL_BASIC)
						if(prob(affecting.get_damage() - user.stats.getStat(STAT_BIO)))
							var/pain = rand(min(30,affecting.get_damage()),69ax(affecting.get_damage() + 30,60) - user.stats.getStat(STAT_BIO))
							H.pain(affecting, pain)
							if(user != H)
								to_chat(H, "<span class='69pain > 50 ? "danger" : "warning"69'>\The 69user69's amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
								to_chat(user, SPAN_WARNING("Your amateur actions caused 69H69 69pain > 50 ? "a lot of " : ""69pain."))
							else
								to_chat(user, "<span class='69pain > 50 ? "danger" : "warning"69'>Your amateur actions caused you 69pain > 50 ? "a lot of " : ""69pain.</span>")
				else
					to_chat(target, SPAN_NOTICE("You feel a tiny prick!"))
			else
				trans = reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, SPAN_NOTICE("You inject 69trans69 units of the solution. 69src6969ow contains 69src.reagents.total_volume69 units."))


/obj/item/reagent_containers/syringe/update_icon()
	cut_overlays()

	var/iconstring = initial(item_state)
	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return

	var/rounded_vol
	if(reagents && reagents.total_volume)
		rounded_vol = CLAMP(round((reagents.total_volume /69olume * 15),5), 1, 15)
		var/image/filling_overlay =69utable_appearance('icons/obj/reagentfillings.dmi', "69iconstring6969rounded_vol69")
		filling_overlay.color = reagents.get_color()
		add_overlay(filling_overlay)
	else
		rounded_vol = 0
	icon_state = "69rounded_vol69"
	item_state = "69iconstring69_69rounded_vol69"
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		add_overlay(injoverlay)
		update_wear_icon()

/obj/item/reagent_containers/syringe/proc/syringestab(mob/living/carbon/target as69ob,69ob/living/carbon/user as69ob)
	if(ishuman(target))

		var/mob/living/carbon/human/H = target

		var/target_zone = ran_zone(check_zone(user.targeted_organ, target))
		var/obj/item/organ/external/affecting = H.get_organ(target_zone)

		if (!affecting || affecting.is_stump())
			to_chat(user, SPAN_DANGER("They are69issing that limb!"))
			return

		var/hit_area = affecting.name

		if((user != target) && H.check_shields(7, src, user, "\the 69src69"))
			return

		if (target != user && H.getarmor(target_zone, ARMOR_MELEE) > 5 && prob(50))
			for(var/mob/O in69iewers(world.view, user))
				O.show_message(text("\red <B>69user69 tries to stab 69target69 in \the 69hit_area69 with 69src.name69, but the attack is deflected by armor!</B>"), 1)
			user.remove_from_mob(src)
			69del(src)

			user.attack_log += "\6969time_stamp()69\69<font color='red'> Attacked 69target.name69 (69target.ckey69) with \the 69src69 (INTENT: HARM).</font>"
			target.attack_log += "\6969time_stamp()69\69<font color='orange'> Attacked by 69user.name69 (69user.ckey69) with 69src.name69 (INTENT: HARM).</font>"
			msg_admin_attack("69key_name_admin(user)69 attacked 69key_name_admin(target)69 with 69src.name69 (INTENT: HARM) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")

			return

		user.visible_message(SPAN_DANGER("69user69 stabs 69target69 in \the 69hit_area69 with 69src.name69!"))

		if(affecting.take_damage(3))
			H.UpdateDamageIcon()

	else
		user.visible_message(SPAN_DANGER("69user69 stabs 69target69 with 69src.name69!"))
		target.take_organ_damage(3)// 7 is the same as crowbar punch

	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	var/contained_reagents = reagents.log_list()
	var/trans = reagents.trans_to_mob(target, syringestab_amount_transferred, CHEM_BLOOD)
	if(isnull(trans)) trans = 0
	admin_inject_log(user, target, src, contained_reagents, trans,69iolent=1)
	break_syringe(target, user)

/obj/item/reagent_containers/syringe/proc/break_syringe(mob/living/carbon/target,69ob/living/carbon/user)
	if(!breakable)
		return

	desc += " It is broken."
	mode = SYRINGE_BROKEN
	if(target)
		add_blood(target)
	if(user)
		add_fingerprint(user)
	update_icon()

/obj/item/reagent_containers/syringe/blitzshell
	name = "blitzshell syringe"
	desc = "A blitzshell syringe."
	breakable = FALSE
	spawn_tags =69ull

/obj/item/reagent_containers/syringe/ld50_syringe
	name = "lethal injection syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 60
	volume = 60
	visible_name = "a giant syringe"
	time = 300

/obj/item/reagent_containers/syringe/ld50_syringe/afterattack(obj/target,69ob/user, flag)
	if(mode == SYRINGE_DRAW && ismob(target)) //69o drawing 50 units of blood at once
		to_chat(user, SPAN_NOTICE("This69eedle isn't designed for drawing blood."))
		return
	if(user.a_intent == "hurt" && ismob(target)) //69o instant injecting
		to_chat(user, SPAN_NOTICE("This syringe is too big to stab someone with it."))
		return
	..()

/obj/item/reagent_containers/syringe/large
	name = "large syringe"
	desc = "A large syringe for those patients who69eeds a little69ore"
	icon = 'icons/obj/large_syringe.dmi'
	item_state = "large_syringe"
	icon_state = "0"
	matter = list(MATERIAL_GLASS = 1,69ATERIAL_STEEL = 1,MATERIAL_SILVER = 1)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10)
	volume = 30
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	sharp = TRUE
	unacidable = 1 //glass
	reagent_flags = TRANSPARENT

/obj/item/reagent_containers/syringe/large/update_icon()
	cut_overlays()

	var/iconstring = initial(item_state)
	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return

	var/rounded_vol
	if(reagents && reagents.total_volume)
		rounded_vol = CLAMP(round((reagents.total_volume /69olume * 30),5), 1, 30)
		var/image/filling_overlay =69utable_appearance('icons/obj/reagentfillings.dmi', "69iconstring6969rounded_vol69")
		filling_overlay.color = reagents.get_color()
		add_overlay(filling_overlay)
	else
		rounded_vol = 0
	icon_state = "69rounded_vol69"
	item_state = "69iconstring69_69rounded_vol69"
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		add_overlay(injoverlay)
		update_wear_icon()

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/syringe/inaprovaline
	name = "syringe (inaprovaline)"
	desc = "Contains inaprovaline - a stimulant used to stabilize patients."
	preloaded_reagents = list("inaprovaline" = 15)
	spawn_tags = SPAWN_TAG_MEDICINE_COMMON
	rarity_value = 10

/obj/item/reagent_containers/syringe/antitoxin
	name = "syringe (anti-toxin)"
	desc = "Contains dylovene - a broad spectrum antitoxin."
	preloaded_reagents = list("anti_toxin" = 15)
	spawn_tags = SPAWN_TAG_MEDICINE_COMMON
	rarity_value = 10

/obj/item/reagent_containers/syringe/tricordrazine
	name = "syringe (tricordrazine)"
	desc = "Contains tricordrazine - a stimulant that can be used to treat a wide range of injuries."
	preloaded_reagents = list("tricordrazine" = 15)
	spawn_tags = SPAWN_TAG_MEDICINE_COMMON
	rarity_value = 15

/obj/item/reagent_containers/syringe/spaceacillin
	name = "syringe (spaceacillin)"
	desc = "Contains spaceacillin - an antibacterial agent."
	preloaded_reagents = list("spaceacillin" = 15)
	spawn_tags = SPAWN_TAG_MEDICINE
	rarity_value = 20

/obj/item/reagent_containers/syringe/hyperzine
	name = "syringe (hyperzine)"
	desc = "Contains hyperzine - a long lasting69uscle stimulant."
	preloaded_reagents = list("hyperzine" = 15)

/obj/item/reagent_containers/syringe/drugs
	name = "syringe (drugs)"
	desc = "Contains aggressive drugs69eant for torture."
	preloaded_reagents = list("space_drugs" = 5, "mindbreaker" = 5, "cryptobiolin" = 5)
	spawn_tags = SPAWN_ITEM_CONTRABAND
	rarity_value = 50

/obj/item/reagent_containers/syringe/drugs_recreational
	name = "syringe (drugs)"
	desc = "Contains recreational drugs."
	preloaded_reagents = list("space_drugs" = 15)
	spawn_tags = SPAWN_ITEM_CONTRABAND
	rarity_value = 40

/obj/item/reagent_containers/syringe/ld50_syringe/choral
	preloaded_reagents = list("chloralhydrate" = 50)

/obj/item/reagent_containers/syringe/stim
	name = "syringe (stim)"

/obj/item/reagent_containers/syringe/stim/mbr
	name = "syringe (Machine binding ritual)"
	desc = "Contains ethanol based stimulator. Used as ritual drink during technomancers initiation into tribe."
	preloaded_reagents = list("machine binding ritual" = 15)

/obj/item/reagent_containers/syringe/stim/cherrydrops
	name = "syringe (Cherry Drops)"
	desc = "Contains a cherry drops stimulator."
	preloaded_reagents = list("cherry drops" = 15)

/obj/item/reagent_containers/syringe/stim/pro_surgeon
	name = "syringe (ProSurgeon)"
	desc = "Contains a prosurgeon stimulating drug, used to reduce tremor to69inimum."
	preloaded_reagents = list("prosurgeon" = 15)

/obj/item/reagent_containers/syringe/stim/violence
	name = "syringe (Violence)"
	desc = "Contains stimulator famous for it's ability to increase peak69uscle strength."
	preloaded_reagents = list("violence" = 15)

/obj/item/reagent_containers/syringe/stim/bouncer
	name = "syringe (Bouncer)"
	desc = "Contains stimulator that boost regenerative capabilities."
	preloaded_reagents = list("bouncer" = 15)

/obj/item/reagent_containers/syringe/stim/steady
	name = "syringe (Steady)"
	desc = "Contains stimulator with ability to enchant reaction time."
	preloaded_reagents = list("steady" = 15)

/obj/item/reagent_containers/syringe/stim/machine_spirit
	name = "syringe (Machine Spirit)"
	desc = "Contains ethanol based stimulator. Used to initiate technomancer into inner cirle."
	preloaded_reagents = list("machine spirit" = 15)

/obj/item/reagent_containers/syringe/stim/grape_drops
	name = "syringe (Grape Drops)"
	desc = "Contains powerful stimulator which boosts creativity. Often used by scientists."
	preloaded_reagents = list("grape drops" = 15)

/obj/item/reagent_containers/syringe/stim/ultra_surgeon
	name = "syringe (UltraSurgeon)"
	desc = "Contains strong stimulating drug, which stabilizes69uscle69otility. Used as last resort during complex surgeries."
	preloaded_reagents = list("ultrasurgeon" = 15)

/obj/item/reagent_containers/syringe/stim/violence_ultra
	name = "syringe (Violence Ultra)"
	desc = "Contains effective electrolyte based69uscle stimulant. Often used by69ost69iolent gangs"
	preloaded_reagents = list("violence ultra" = 15)

/obj/item/reagent_containers/syringe/stim/boxer
	name = "syringe (Boxer)"
	desc = "Contains stimulator which boosts robustness of human body. Known for its use by boxers."
	preloaded_reagents = list("boxer" = 15)

/obj/item/reagent_containers/syringe/stim/turbo
	name = "syringe (TURBO)"
	desc = "Contains potent69ix of cardiovascular and69euro stimulators. Used by sharpshooters to increase accuracy."
	preloaded_reagents = list("turbo" = 15)

/obj/item/reagent_containers/syringe/stim/party_drops
	name = "syringe (Party Drops)"
	desc = "Contains stimulating substance which pumps intelectual capabilities to theoretical69aximum. Used as delicacy by some high ranking scientists."
	preloaded_reagents = list("party drops" = 15)

/obj/item/reagent_containers/syringe/stim/menace
	name = "syringe (MENACE)"
	desc = "Contains awfully potent stimulant.69otorious for its usage by suicide troops."
	preloaded_reagents = list("menace" = 15)

////////////////////////////////////////////////////////////////////////////////
/// Large Syringes.
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/syringe/large/antitoxin
	name = "large syringe (anti-toxin)"
	desc = "Contains dylovene - a broad spectrum antitoxin."
	preloaded_reagents = list("anti_toxin" = 30)
	matter = list(MATERIAL_BIOMATTER = 5)
	spawn_blacklisted = TRUE

/obj/item/reagent_containers/syringe/large/dexalin_plus
	name = "large syringe (dexalin+)"
	desc = "Contains dexalin plus - a treatment of oxygen deprivation."
	preloaded_reagents = list("dexalinp" = 30)
	matter = list(MATERIAL_BIOMATTER = 5)
	spawn_blacklisted = TRUE
