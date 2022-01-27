/mob/living/carbon/human/proc/check_ability(var/chem_cost = 0,69ar/needs_foundation,69ar/gene_cost = 0)
	if(stat == DEAD || (status_flags & FAKEDEATH))
		to_chat(src, SPAN_WARNING("You are dead"))
		return FALSE

	if(carrion_stored_chemicals < chem_cost)
		to_chat(src, SPAN_WARNING("You don't have enough chemicals stored to do that."))
		return FALSE

	if(needs_foundation)
		var/turf/T = get_turf(src)
		var/has_foundation = FALSE
		if(T)
			if(!(istype(T,/turf/space)))
				has_foundation = TRUE

		if(!has_foundation)
			to_chat(src, SPAN_WARNING("You69eed a solid foundation to do that on."))
			return FALSE

	if(gene_cost)
		var/obj/item/organ/internal/carrion/core/core = random_organ_by_process(BP_SPCORE)
		if(core?.geneticpoints < gene_cost)
			to_chat(src, SPAN_WARNING("You don't have enough genetic points stored to do that."))
			return FALSE
		else
			core.geneticpoints -= gene_cost

	carrion_stored_chemicals -= chem_cost
	return TRUE

/obj/item/organ/internal/carrion
	max_damage = 150 //resilient
	scanner_hidden = TRUE //sneaky

/obj/item/organ/internal/carrion/chemvessel
	name = "chemical69essel"
	parent_organ_base = BP_CHEST
	organ_efficiency = list(OP_CHEMICALS = 100)
	icon_state = "carrion_chemvessel"

/obj/item/organ/internal/carrion/core
	name = "spider core"
	parent_organ_base = BP_CHEST
	organ_efficiency = list(BP_SPCORE = 100)
	icon_state = "spider_core"
	unique_tag = BP_SPCORE
	max_damage = 400 //this really shouldn't die
	vital = 1
	specific_organ_size = 0
	var/list/absorbed_dna = list()
	var/list/purchasedpowers = list()
	var/list/spiderlist = list()
	var/list/active_spiders = list()
	var/geneticpoints = 10

	var/mob/living/simple_animal/spider_core/associated_spider =69ull

	owner_verbs = list(
		/obj/item/organ/internal/carrion/core/proc/carrion_transform,
		/obj/item/organ/internal/carrion/core/proc/EvolutionMenu,
		/obj/item/organ/internal/carrion/core/proc/carrion_fakedeath,
		/obj/item/organ/internal/carrion/core/proc/detatch,
		/obj/item/organ/internal/carrion/core/proc/make_spider,
		/obj/item/organ/internal/carrion/core/proc/spider_menu
	)

	var/list/associated_carrion_organs = list()

/obj/item/organ/internal/carrion/core/Destroy()
	owner =69ull //overrides removed() call
	. = ..()


/obj/item/organ/internal/carrion/core/proc/make_spider()
	set category = "Carrion"
	set69ame = "Spawn a spider"

	var/list/options = list()
	var/obj/item/implant/carrion_spider/S
	if (!spiderlist.len)
		to_chat(owner, SPAN_WARNING("You dont have any spiders evolved!"))
		return

	for(var/item in spiderlist)
		S = item
		options69"69initial(S.name)69(69initial(S.spider_price)69)"69 = S

	var/I = input(owner,"Select the spider you want to spawn: ", "Spider",69ull) as69ull|anything in options
	S = options69I69
	if(!S)
		return

	if(owner.check_ability(initial(S.spider_price),69ull, initial(S.gene_price)))
		var/obj/item/implant/carrion_spider/spider =69ew S(owner.loc)
		active_spiders += spider
		spider.owner_core = src
		spider.update_owner_mob()

		owner.put_in_active_hand(spider)

/obj/item/organ/internal/carrion/core/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = list()

	var/list/spiders_in_list = list()
	for(var/item in active_spiders)
		var/obj/item/implant/carrion_spider/S = item
		var/turf/T = get_turf(S)
		var/spider_location = "Unknown location"
		if(T)
			spider_location = "69S.loc69(69T.x69:69T.y69:69T.z69)"
		spiders_in_list += list(
			list(
				"name" = initial(S.name),
				"location" = "69spider_location69",
				"spider" = "\ref69item69",
				"implanted" = S.wearer
			)
		)

	data69"list_of_spiders"69 = spiders_in_list

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui =69ew(user, src, ui_key, "carrion_spiders.tmpl", "Carrion Spiders", 400, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/organ/internal/carrion/core/Topic(href, href_list)
	if(href_list69"activate_spider"69)
		var/obj/item/implant/carrion_spider/activated_spider = locate(href_list69"activate_spider"69) in active_spiders
		if(activated_spider)
			activated_spider.activate()
	
	if(href_list69"pop_out_spider"69)
		var/obj/item/implant/carrion_spider/activated_spider = locate(href_list69"pop_out_spider"69) in active_spiders
		if(activated_spider)
			activated_spider.uninstall()

	if(href_list69"activate_all"69)
		for(var/spider in active_spiders)
			var/obj/item/implant/carrion_spider/CS = spider
			if(istype(CS))
				CS.activate()

	if(href_list69"P"69)
		purchasePower(href_list69"P"69)
		EvolutionMenu()
	..()

/obj/item/organ/internal/carrion/core/proc/detatch()
	set category = "Carrion"
	set69ame = "Detatch"

	if(owner.status_flags & FAKEDEATH)
		to_chat(owner, SPAN_WARNING("We are regenerating our body!"))
		return

	if(alert("Are you sure you want to detach? You will lose your old body and half of your evolved abilities and gene points.",,"Yes","No") == "No")
		return

	gibs(owner.loc,69ull, /obj/effect/gibspawner/generic, "#666600", "#666600")
	visible_message(SPAN_DANGER("Something bursts out of 69owner69's chest!"))
	removed() //removed() does all of the work

/obj/item/organ/internal/carrion/core/proc/spider_menu()
	set category = "Carrion"
	set69ame = "Open spider69enu"

	ui_interact(owner)

/obj/item/organ/internal/carrion/core/removed(mob/living/user)
	if(!associated_spider && owner)
		for(var/obj/item/implant/carrion_spider/control/CS in active_spiders)
			CS.return_mind()

		owner.faction = initial(owner.faction)
		associated_spider =69ew /mob/living/simple_animal/spider_core(owner.loc)
		owner.mind?.transfer_to(associated_spider)
		..()
		forceMove(associated_spider)

/obj/item/organ/internal/carrion/core/proc/GetDNA(var/dna_owner)
	var/datum/dna/chosen_dna
	for(var/datum/dna/DNA in absorbed_dna)
		if(dna_owner == DNA.real_name)
			chosen_dna = DNA
			break
	return chosen_dna

/obj/item/organ/internal/carrion/core/proc/carrion_transform()
	set category = "Carrion"
	set69ame = "Transform(5)"

	if (owner.transforming)
		return

	var/list/names = list()

	if (!owner)
		return

	for(var/datum/dna/DNA in absorbed_dna)
		names += "69DNA.real_name69"

	var/S = input("Select the target DNA: ", "Target DNA",69ull) as69ull|anything in69ames
	if(!absorbed_dna.len)
		to_chat(owner, SPAN_WARNING("You have69o DNA absorbed!"))
		return

	var/datum/dna/chosen_dna = GetDNA(S)
	if(!chosen_dna)
		return

	if(!owner.check_ability(5))
		return

	if(HUSK in owner.mutations)
		owner.mutations -= HUSK
		if(istype(owner))
			owner.update_body(0)

	owner.visible_message(SPAN_WARNING("69owner69 transforms!"))
	owner.dna = chosen_dna.Clone()
	owner.real_name = chosen_dna.real_name
	owner.flavor_text = ""
	owner.UpdateAppearance()
	domutcheck(owner,69ull)

	return 1

/obj/item/organ/internal/carrion/core/proc/carrion_fakedeath()
	set category = "Carrion"
	set69ame = "Regenerative Stasis (20)"

	if(!owner.stat && alert("Are we sure we wish to fake our death?",,"Yes","No") == "No")
		return

	if(!(owner.check_ability(20)))
		return

	to_chat(owner, SPAN_NOTICE("We will attempt to regenerate our form."))

	owner.status_flags |= FAKEDEATH
	owner.update_lying_buckled_and_verb_status()
	owner.emote("gasp")
	owner.timeofdeath = world.time

	addtimer(CALLBACK(src, .proc/carrion_revive), rand(169INUTES, 369INUTES))

/obj/item/organ/internal/carrion/core/proc/carrion_revive()
	if(!owner)
		return

	owner.rejuvenate()
	for(var/limb_tag in owner.species.has_limbs)
		var/obj/item/organ/external/E = owner.get_organ(limb_tag)
		if(E.is_stump())
			qdel(E)
			var/datum/organ_description/OD = owner.species.has_limbs69limb_tag69
			OD.create_organ(owner)
	owner.status_flags &= ~FAKEDEATH
	owner.update_lying_buckled_and_verb_status()
	owner.update_body()
	owner.update_icons()
	to_chat(owner, SPAN_NOTICE("You have regenerated."))

/obj/item/organ/internal/carrion/core/proc/add_to_associated_organs(obj/item/organ/internal/carrion/I)
	if(istype(I))
		associated_carrion_organs += I
	return

/obj/item/organ/internal/carrion/maw
	name = "carrion69aw"
	parent_organ_base = BP_HEAD
	icon_state = "carrion_maw"
	organ_efficiency = list(OP_MAW = 100)
	var/last_call = -569INUTES
	var/tearing = FALSE

	owner_verbs = list(
		/obj/item/organ/internal/carrion/maw/proc/consume_flesh,
		/obj/item/organ/internal/carrion/maw/proc/toxic_puddle,
		/obj/item/organ/internal/carrion/maw/proc/spider_call
	)

/obj/item/organ/internal/carrion/maw/proc/consume_flesh()
	set category = "Carrion"
	set69ame = "Consume the flesh"

	var/food = owner.get_active_hand()

	if(!food)
		to_chat(owner, SPAN_WARNING("You can't eat69othing."))
		return

	if(istype(food, /obj/item/grab))
		var/obj/item/grab/grab = food
		var/mob/living/carbon/human/H = grab.affecting
		if (grab.state < GRAB_AGGRESSIVE)
			to_chat(owner, SPAN_WARNING("Your grip upon 69H.name69 is too weak."))
			return
		if(istype(H))
			var/obj/item/organ/external/E = H.get_organ(owner.targeted_organ)
			if (tearing) // one at a time, thank you.
				to_chat(owner, SPAN_WARNING("Your69aw is already focused on something."))
				return

			if(E.is_stump())
				to_chat(owner, SPAN_WARNING("There is69othing there!"))
				return
			tearing = TRUE

			visible_message(SPAN_DANGER("69owner69 bites into 69H.name69's 69E.name69 and starts tearing it apart!"))
			if(do_after(owner, 5 SECONDS, H))
				tearing = FALSE
				E.take_damage(30)
				var/blacklist = list()
				for (var/obj/item/organ/internal/to_blacklist in E.internal_organs)
					if (istype(to_blacklist, /obj/item/organ/internal/bone/))
						blacklist += to_blacklist
						continue
					if (istype(to_blacklist, /obj/item/organ/internal/brain/))
						blacklist += to_blacklist// removing bones from a69alid_organs list based on			
				var/list/valid_organs = E.internal_organs - blacklist// E.internal_organs gibs the69ictim.
				if (!valid_organs.len)
					visible_message(SPAN_DANGER("69owner69 tears up 69H69's 69E.name69!"))
					return
				var/obj/item/organ/internal/organ_to_remove = pick(valid_organs)
				organ_to_remove.removed(owner)
				visible_message(SPAN_DANGER("69owner69 tears \a 69organ_to_remove69 out of 69H.name69's 69E.name69!"))
				playsound(loc, 'sound/voice/shriek1.ogg', 50)
				return
			else
				tearing = FALSE
		else
			to_chat(owner, SPAN_WARNING("You can only tear flesh out of humanoids!"))	
			return

	if(istype(food, /obj/item/organ) || istype(food, /obj/item/reagent_containers/food/snacks/meat))
		var/geneticpointgain = 0
		var/chemgain = 0
		var/taste_description = ""

		if(owner.carrion_hunger < 1)
			to_chat(owner, SPAN_WARNING("You are69ot hungry."))
			return

		var/obj/item/organ/O = food
		if(istype(O))
			if(BP_IS_ROBOTIC(O))
				to_chat(owner, SPAN_WARNING("This organ is robotic, you can't eat it."))
				return
			else if(istype(O, /obj/item/organ/internal/carrion))
				var/obj/item/organ/internal/carrion/core/G = owner.random_organ_by_process(BP_SPCORE)
				if(O in G.associated_carrion_organs)
					taste_description = "albeit delicious, your own organs carry69o69ew genetic69aterial"
				else
					owner.carrion_hunger += 3
					geneticpointgain = 4
					chemgain = 50
					taste_description = "carrion organs taste heavenly, you69eed69ore!"
			else if(istype(O, /obj/item/organ/internal))
				var/organ_rotten = FALSE
				if (O.status & ORGAN_DEAD)
					organ_rotten = TRUE
				if(O.species != all_species69SPECIES_HUMAN69)
					chemgain = 5
					taste_description = "this69on-human organ is69ery bland." //69o removal of hunger here, getting and storing a ton of69onkey organs isn't too easy, and 5 chem points isn't terribly69uch.
				else
					geneticpointgain = organ_rotten ? 1 : 3
					chemgain = organ_rotten ? 4 : 10
					taste_description = "internal organs are delicious69organ_rotten ? ", but rotten ones less so." : "."69"
			else
				geneticpointgain = 2
				chemgain = 5
				taste_description = "limbs are satisfying."

		else if(istype(food, /obj/item/reagent_containers/food/snacks/meat/human))
			geneticpointgain = 2
			chemgain = 5
			taste_description = "human69eat is satisfying."

		else
			chemgain = 5
			owner.carrion_hunger -= 1 //Prevents69eat eating spam for infinate chems
			taste_description = "this69eat is bland."

		var/obj/item/organ/internal/carrion/core/C = owner.random_organ_by_process(BP_SPCORE)
		if(C)
			C.geneticpoints +=69in(geneticpointgain, owner.carrion_hunger)

		owner.carrion_hunger =69ax(owner.carrion_hunger - geneticpointgain, 0)
		owner.ingested.add_reagent("nutriment", chemgain)

		var/chemvessel_efficiency = owner.get_organ_efficiency(OP_CHEMICALS)
		if(chemvessel_efficiency > 1)
			owner.carrion_stored_chemicals =69in(owner.carrion_stored_chemicals + 0.01 * chemvessel_efficiency , 0.5 * chemvessel_efficiency)

		to_chat(owner, SPAN_NOTICE("You consume \the 69food69, 69taste_description69."))
		visible_message(SPAN_DANGER("69owner69 devours \the 69food69!"))
		qdel(food)

	else
		to_chat(owner, SPAN_WARNING("You can't eat this!"))

/obj/item/organ/internal/carrion/maw/proc/spider_call()
	set category = "Carrion"
	set69ame = "Spider call (30)"

	if(last_call + 569INUTES > world.time)
		to_chat(owner, SPAN_WARNING("Your69aw is tired, you can only call for help every 569inutes."))
		return

	if(owner.check_ability(30))
		playsound(loc, 'sound/voice/shriek1.ogg', 100, 1, 8, 8)
		spawn(2)
			playsound(loc, 'sound/voice/shriek1.ogg', 100, 1, 8, 8) //Same trick as with the fuhrer
		visible_message(SPAN_DANGER("69owner69 emits a frightening screech as you feel the ground tramble!"))
		for (var/obj/structure/burrow/B in find_nearby_burrows())
			for(var/i = 1, i <= 4 ,i++) //4 per burrow
				var/obj/structure/burrow/origin = SSmigration.choose_burrow_target(null, TRUE, 100)
				var/spider_to_spawn = pickweight(list(/mob/living/carbon/superior_animal/giant_spider = 4,\
					/mob/living/carbon/superior_animal/giant_spider/nurse = 2,\
					/mob/living/carbon/superior_animal/giant_spider/hunter = 2))
				new spider_to_spawn(B)
				origin.migrate_to(B, 3 SECONDS, 0)
		last_call = world.time

/obj/item/organ/internal/carrion/maw/proc/toxic_puddle()
	set category = "Carrion"
	set69ame = "Toxic puddle (10)"

	var/turf/T = get_turf(owner)
	if(locate(/obj/effect/decal/cleanable/carrion_puddle) in T)
		to_chat(owner, SPAN_WARNING("There is already a toxic puddle here."))
		return

	if(owner.check_ability(10, TRUE))
		playsound(src, 'sound/effects/blobattack.ogg', 50, 1)
		new /obj/effect/decal/cleanable/carrion_puddle(T)
		to_chat(owner, SPAN_NOTICE("You69omit a toxic puddle"))

/obj/effect/decal/cleanable/carrion_puddle
	name = "toxic puddle"
	icon = 'icons/effects/effects.dmi'
	desc = "It emits an abhorrent smell, you shouldn't step anywhere69ear it."
	icon_state = "toxic_puddle"
	anchored = TRUE
	spawn_blacklisted = TRUE

/obj/effect/decal/cleanable/carrion_puddle/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/effect/decal/cleanable/carrion_puddle/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/effect/decal/cleanable/carrion_puddle/Process()
	for(var/mob/living/creature in69obs_in_view(1, src))
		if(creature.faction == "spiders")
			continue
		toxin_attack(creature, rand(1, 3))

/obj/effect/decal/cleanable/solid_biomass/attackby(var/obj/item/I,69ar/mob/user)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		to_chat(user, SPAN_NOTICE("You started cleaning this 69src69."))
		if(do_after(user, 3 SECONDS, src))
			to_chat(user, SPAN_NOTICE("You clean \The 69src69."))
			qdel(src)

/obj/item/organ/internal/carrion/spinneret
	name = "carrion spinneret"
	parent_organ_base = BP_GROIN
	icon_state = "carrion_spinneret"
	organ_efficiency = list(OP_SPINNERET = 100)
	owner_verbs = list(
		/obj/item/organ/internal/carrion/spinneret/proc/make_nest,
		/obj/item/organ/internal/carrion/spinneret/proc/bloodpurge,
		/obj/item/organ/internal/carrion/spinneret/proc/make_stickyweb
	)

/obj/item/organ/internal/carrion/spinneret/proc/make_stickyweb()
	set category = "Carrion"
	set69ame = "Make a web (5)"

	if(locate(/obj/effect/spider/stickyweb) in get_turf(src))
		to_chat(owner, SPAN_WARNING("There is alredy web on the floor!"))
		return

	if(owner.check_ability(5,TRUE))
		visible_message(SPAN_NOTICE("\The 69owner69 begins to secrete a sticky substance."))
		new /obj/effect/spider/stickyweb(get_turf(src))
		update_openspace()

/obj/item/organ/internal/carrion/spinneret/proc/bloodpurge()
	set category = "Carrion"
	set69ame = "Blood Purge (25)"


	if (owner.check_ability(25))
		to_chat(owner, SPAN_NOTICE("You cleanse your blood of all chemicals and poisons."))
		owner.adjustToxLoss(-100)
		owner.radiation = 0
		owner.reagents.update_total()
		owner.reagents.trans_to_turf(owner.loc, owner.reagents.total_volume)

/obj/item/organ/internal/carrion/spinneret/proc/make_nest()
	set category = "Carrion"
	set69ame = "Make a spider69est (30, 1)"

	if (owner.check_ability(30,TRUE, 1))
		new /obj/structure/spider_nest(owner.loc)

/obj/structure/spider_nest
	name = "spider69est"
	desc = "A69est that periodicaly produces spiders"
	icon_state = "spider_nest"
	anchored = TRUE
	density = FALSE
	breakable = TRUE
	var/spider_spawns

/obj/structure/spider_nest/New()
	. = ..()
	spider_spawns = rand(3,8)
	addtimer(CALLBACK(src, .proc/spawn_spider), 30 SECONDS)

/obj/structure/spider_nest/attackby(obj/item/I,69ob/living/user)
	..()
	if(I.force >= WEAPON_FORCE_PAINFUL)
		playsound(loc, 'sound/voice/shriek1.ogg', 85, 1, 8, 8)
		spawn_spider()
		attack_animation(user)
		visible_message(SPAN_WARNING("\The 69src69 bursts open!"))
		qdel(src)

/obj/structure/spider_nest/bullet_act(obj/item/projectile/P, def_zone)
	playsound(loc, 'sound/voice/shriek1.ogg', 85, 1, 8, 8)
	spawn_spider()
	visible_message(SPAN_WARNING("69src69 bursts open!"))
	qdel(src)
	..()

/obj/structure/spider_nest/proc/spawn_spider()
	var/spider_to_spawn = pickweight(list(/mob/living/carbon/superior_animal/giant_spider = 4,\
		/mob/living/carbon/superior_animal/giant_spider/nurse = 2,\
		/mob/living/carbon/superior_animal/giant_spider/hunter = 2))
	new spider_to_spawn(loc)
	visible_message(SPAN_WARNING("A spider spews out of \The 69src69"))
	spider_spawns--
	if(spider_spawns)
		addtimer(CALLBACK(src, .proc/spawn_spider), 169INUTES)

/mob/proc/make_carrion()
	var/mob/living/carbon/human/user = src
	if(istype(user))
		var/obj/item/organ/external/chest = user.get_organ(BP_CHEST)
		if(chest)
			var/obj/item/organ/internal/carrion/core/C =69ew /obj/item/organ/internal/carrion/core
			C.replaced(chest)
		user.faction = "spiders"
