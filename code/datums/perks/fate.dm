/datum/perk/fate/paper_worm
	name = "Paper Worm"
	desc = "You were a clerk and bureaucrat for all your life. Cramped offices with angry people is where your personality was forged. \
			You have lower stats all around, but have a higher chance to have increased stat growth on level up."
	icon_state = "paper"

/datum/perk/fate/paper_worm/assign(mob/living/carbon/human/H)
	if(..())
		holder.sanity.positive_prob += 20

/datum/perk/fate/paper_worm/remove()
	if(holder)
		holder.sanity.positive_prob -= 20
	..()

/datum/perk/fate/freelancer
	name = "Freelancer"
	icon_state = "skills"
	desc = "Whatever was your job, you never stayed in one place for too long or had lasting contracts. \
			This perk checks your highest stat, lowers it by 10 and improves all others by 4."

/datum/perk/fate/freelancer/assign(mob/living/carbon/human/H)
	if(!..())
		return
	var/maxstat = -INFINITY
	var/maxstatname
	spawn(1)
		for(var/name in ALL_STATS)
			if(holder.stats.getStat(name, TRUE) > maxstat)
				maxstat = holder.stats.getStat(name, TRUE)
				maxstatname = name
		for(var/name in ALL_STATS)
			if(name != maxstatname)
				holder.stats.changeStat(name, 4)
			else
				holder.stats.changeStat(name, -10)

/datum/perk/fate/nihilist
	name = "Nihilist"
	desc = 	"You simply ran out of fucks to give at some point in your life. \
			This increases chance of positive breakdowns by 10% and negative breakdowns by 20%. Seeing someone die has a random effect on you: \
			sometimes you won’t take any sanity loss and you can even gain back sanity, or get a boost to your cognition."
	icon_state = "eye" //https://game-icons.net/1x1/lorc/tear-tracks.html

/datum/perk/fate/nihilist/assign(mob/living/carbon/human/H)
	if(..())
		holder.sanity.positive_prob += 10
		holder.sanity.negative_prob += 20

/datum/perk/fate/nihilist/remove()
	if(holder)
		holder.sanity.positive_prob -= 10
		holder.sanity.negative_prob -= 20
		holder.stats.removeTempStat(STAT_COG, "Fate Nihilist")
	..()

/datum/perk/fate/moralist
	name = "Moralist"
	icon_state = "moralist" //https://game-icons.net/
	desc = "A day may come when the courage of men fails, when we forsake our friends and break all bonds of fellowship. \
			But it is not this day. This day you fight! \
			Your Insight gain is faster when you are around sane people and they will recover sanity when around you. \
			When you are around people that are low on health or sanity, you will take sanity damage."

/datum/perk/fate/drug_addict
	name = "Drug Addict"
	icon_state = "medicine" //https://game-icons.net/1x1/delapouite/medicines.html
	desc = "For reasons you cannot remember, you decided to resort to major drug use. You have lost the battle, and now you suffer the consequences. \
			You start with a permanent addiction to a random stimulator, as well as a bottle of pills containing the drug. \
			Beware, if you get addicted to another stimulant, you will not get rid of the addiction."

/datum/perk/fate/drug_addict/assign(mob/living/carbon/human/H)
	if(!..() || !holder)
		return
	spawn(1)
		var/turf/T = get_turf(holder)
		var/drugtype = pick(subtypesof(/datum/reagent/stim))
		if(!(drugtype in holder.metabolism_effects.addiction_list))
			var/datum/reagent/drug = new drugtype
			holder.metabolism_effects.addiction_list.Add(drug)
			var/obj/item/storage/pill_bottle/PB = new /obj/item/storage/pill_bottle(T)
			PB.name = "[drug] (15 units)"
			for(var/i=1 to 12)
				var/obj/item/reagent_containers/pill/pill = new /obj/item/reagent_containers/pill(T)
				pill.reagents.add_reagent(drug.id, 15)
				pill.name = "[drug]"
				PB.handle_item_insertion(pill)
			holder.equip_to_storage_or_drop(PB)

/datum/perk/fate/alcoholic
	name = "Alcoholic"
	icon_state = "beer" //https://game-icons.net/1x1/delapouite/beer-bottle.html
	desc = "You imagined the egress from all your trouble and pain at the bottom of the bottle, but the way only led to a labyrinth. \
			You never stopped from coming back to it, trying again and again, poisoning your mind until you lost control. Now your face bears witness to your self-destruction. \
			There is only one key to survival, and it is the liquid that has shown you the way down. \
			You have a permanent alcohol addiction, which gives you a boost to combat stats while under the influence and lowers your cognition permanently."

/datum/perk/fate/alcoholic/assign(mob/living/carbon/human/H)
	if(..() && !(/datum/reagent/ethanol in holder.metabolism_effects.addiction_list))
		var/datum/reagent/R = new /datum/reagent/ethanol
		holder.metabolism_effects.addiction_list.Add(R)

/datum/perk/fate/alcoholic_active
	name = "Alcoholic - active"
	icon_state = "drinking" //https://game-icons.net
	desc = "Combat stats increased."

/datum/perk/fate/alcoholic_active/assign(mob/living/carbon/human/H)
	if(..())
		holder.stats.addTempStat(STAT_ROB, 15, INFINITY, "Fate Alcoholic")
		holder.stats.addTempStat(STAT_TGH, 15, INFINITY, "Fate Alcoholic")
		holder.stats.addTempStat(STAT_VIG, 15, INFINITY, "Fate Alcoholic")

/datum/perk/fate/alcoholic_active/remove()
	if(holder)
		holder.stats.removeTempStat(STAT_ROB, "Fate Alcoholic")
		holder.stats.removeTempStat(STAT_TGH, "Fate Alcoholic")
		holder.stats.removeTempStat(STAT_VIG, "Fate Alcoholic")
	..()

/datum/perk/fate/noble
	name = "Noble"
	icon_state = "family" //https://game-icons.net
	desc = "You are a descendant of a long-lasting family, bearing a name of high status that can be traced back to the early civilization of your domain. \
			Start with an heirloom weapon, higher chance to be on contractor contracts and removed sanity cap. Stay clear of filth and danger."

/datum/perk/fate/noble/assign(mob/living/carbon/human/H)
	if(!..())
		return
	holder.sanity.environment_cap_coeff -= 1
	if(!holder.last_name)
		holder.stats.removePerk(src.type)
		return
	var/turf/T = get_turf(holder)
	var/obj/item/W
	if(is_neotheology_disciple(holder) && prob(50))
		W = pickweight(list(
				/obj/item/tool/sword/nt/longsword = 0.5,
				/obj/item/tool/sword/nt/shortsword = 0.5,
				/obj/item/tool/sword/nt/scourge = 0.1,
				/obj/item/tool/knife/dagger/nt = 0.5,
				/obj/item/gun/energy/nt_svalinn = 0.4,
				/obj/item/gun/energy/stunrevolver = 0.1))
	else
		W = pickweight(list(
				/obj/item/tool/hammer/mace = 0.2,
				/obj/item/tool/hammer/mace/makeshift/baseballbat = 0.1,
				/obj/item/tool/knife/ritual = 0.5,
				/obj/item/tool/knife/switchblade = 0.5,
				/obj/item/tool/sword = 0.2,
				/obj/item/tool/sword/katana = 0.2,
				/obj/item/tool/knife/dagger = 0.5,
				/obj/item/gun/projectile/colt = 0.2,
				/obj/item/gun/projectile/revolver/havelock = 0.1,
				/obj/item/tool/knife/dagger/ceremonial = 0.4,
				/obj/item/gun/projectile/revolver = 0.4))
	holder.sanity.valid_inspirations += W
	W = new W(T)
	W.desc += " It has been inscribed with the \"[holder.last_name]\" family name."
	W.name = "[W] of [holder.last_name]"
	var/oddities = rand(2,4)
	var/list/stats = ALL_STATS
	var/list/final_oddity = list()
	for(var/i = 0 to oddities)
		var/stat = pick(stats)
		stats.Remove(stat)
		final_oddity += stat
		final_oddity[stat] = rand(1,7)
	W.AddComponent(/datum/component/inspiration, final_oddity, get_oddity_perk())
	W.AddComponent(/datum/component/atom_sanity, 1, "") //sanity gain by area
	W.sanity_damage -= 1 //damage by view
	W.price_tag += rand(1000, 2500)
	spawn(1)
		holder.equip_to_storage_or_drop(W)

/datum/perk/fate/noble/remove()
	if(holder)
		holder.sanity.environment_cap_coeff += 1
	..()

/datum/perk/fate/rat
	name = "Rat"
	desc = "For all you know, taking what isn't yours is what you were best at. Be that roguery, theft or murder. It’s all the same no matter how you name it, after all. \
			You start with a +10 to Mechanical stat and -10 to Vigilance. You will have a -10 to overall sanity health, meaning you will incur a breakdown faster than most. \
			Additionally you have more quiet footsteps and a chance to not trigger traps on the ground."
	icon_state = "rat" //https://game-icons.net/

/datum/perk/fate/rat/assign(mob/living/carbon/human/H)
	if(..())
		holder.sanity.max_level -= 10

/datum/perk/fate/rat/remove()
	if(holder)
		holder.sanity.max_level += 10
	..()

/datum/perk/fate/rejected_genius
	name = "Rejected Genius"
	desc = "You see the world in different shapes and colors. \
			Your sanity loss cap is removed, so stay clear of corpses or filth. You have less maximum sanity and no chance to have positive breakdowns. \
			As tradeoff, you have 50% faster insight gain."
	icon_state = "knowledge" //https://game-icons.net/

/datum/perk/fate/rejected_genius/assign(mob/living/carbon/human/H)
	if(..())
		holder.sanity.environment_cap_coeff -= 1
		holder.sanity.positive_prob_multiplier -= 1
		holder.sanity.insight_passive_gain_multiplier *= 1.5
		holder.sanity.max_level -= 20

/datum/perk/fate/rejected_genius/remove()
	if(holder)
		holder.sanity.environment_cap_coeff += 1
		holder.sanity.positive_prob_multiplier += 1
		holder.sanity.insight_passive_gain_multiplier /= 1.5
		holder.sanity.max_level += 20
	..()

/datum/perk/fate/oborin_syndrome
	name = "Oborin Syndrome"
	icon_state = "prism" //https://game-icons.net/1x1/delapouite/prism.html
	desc = "A condition manifested at some recent point in human history. \
			It’s origin and prevalence are unknown, but it is speculated to be a psionic phenomenom.\
			Your sanity pool is higher than that of others at the cost of the colors of the world."

/datum/perk/fate/oborin_syndrome/assign(mob/living/carbon/human/H)
	if(..())
		holder.sanity.max_level += 20
		if(!get_active_mutation(holder, MUTATION_OBORIN))
			var/datum/mutation/M = new MUTATION_OBORIN
			M.imprint(holder)
		spawn(1)
			holder?.update_client_colour() //Handle the activation of the colourblindness on the mob.

/datum/perk/fate/oborin_syndrome/remove()
	if(holder)
		holder.sanity.max_level -= 20
		var/datum/mutation/M = get_active_mutation(holder, MUTATION_OBORIN)
		M?.cleanse(holder)
		spawn(1)
			holder?.update_client_colour()
	..()

/datum/perk/fate/lowborn
	name = "Lowborn"
	icon_state = "ladder" //https://game-icons.net/1x1/delapouite/hole-ladder.html
	desc = "You are the bottom of society. The dirt and grime on the heel of a boot. You had one chance. You took it. \
			You cannot be a person of authority. Additionally, you have the ability to have a name without a last name and have an increased sanity pool."

/datum/perk/fate/lowborn/assign(mob/living/carbon/human/H)
	if(..())
		holder.sanity.max_level += 10

/datum/perk/fate/lowborn/remove()
	if(holder)
		holder.sanity.max_level -= 10
	..()

//SOJ-ERIS perks

/datum/perk/rezsickness
	name = "Revival Sickness"
	desc = "You've recently died and have been brought back to life, the experience leaving you weakened and thus unfit for fighting for a while. You better find a bed or chair to rest into until you've fully recuperated."
	icon_state = "revivalsickness"
	gain_text = "Your body aches from the pain of returning from death, you better find a chair or bed to rest in so you can heal properly."
	lose_text = "You finally feel like you recovered from the ravages of your body."
	var/initial_time


/datum/perk/rezsickness/assign(mob/living/L)
	..()
	initial_time = world.time
	src.cooldown_time = world.time + 30 MINUTES
	holder.brute_mod_perk *= 1.10
	holder.burn_mod_perk *= 1.10
	holder.oxy_mod_perk *= 1.10
	holder.toxin_mod_perk *= 1.10
	holder.stats.changeStat(STAT_ROB, -10)
	holder.stats.changeStat(STAT_TGH, -10)
	holder.stats.changeStat(STAT_VIG, -10)

/datum/perk/rezsickness/remove()
	holder.brute_mod_perk /= 1.10
	holder.burn_mod_perk /= 1.10
	holder.oxy_mod_perk /= 1.10
	holder.toxin_mod_perk /= 1.10
	holder.stats.changeStat(STAT_ROB, 10)
	holder.stats.changeStat(STAT_TGH, 10)
	holder.stats.changeStat(STAT_VIG, 10)
	..()

/datum/perk/rezsickness/on_process()
	if(!..())
		return
	if(src.cooldown_time <= world.time)
		holder.stats.removePerk(type)
		to_chat(holder, SPAN_NOTICE("[lose_text]"))
		return
	if(holder.buckled)
		src.cooldown_time -= 2 SECONDS





//////////////HUMAN PERKS

/datum/perk/racial/human //Perk datum for the race. Assigned as a perk, defined in perks.dm under _DEFINES. Ping Bam if you have any questions regarding code maintenance.
	name = "Indomitable Spirit"
	desc = "The unbreakable human will has carried your kind to the stars. It will keep carrying you onwards."
	icon_state = "willtosurvive"
	var/list/human_perks = list(
		/mob/living/carbon/human/proc/willtosurvive,
		/mob/living/carbon/human/proc/battlecry) //The active racial ability procs that are associated with the perk datum.

/datum/perk/racial/human/assign(mob/living/carbon/human/H) //Assigns the perk datum to a mob.
	if(..())
		add_verb(holder, human_perks)

/datum/perk/racial/human/remove() //Removes the perk datum from a mob.
	if(holder)
		remove_verb(holder, human_perks)
	..()

/mob/living/carbon/human/proc/willtosurvive() //The proc itself, this is where the action to the body is applied, aswell as where cooldowns are handled.
	set category = "Human Perks"
	set name = "Indomitable Spirit"
	var/mob/living/carbon/human/user = usr
	var/perk_id = "spirit"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return 
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("The human body can only take so much, you'll need more time before you've recovered enough to use this again."))
		return FALSE
	else 
		perk_cooldown_list[perk_id] = world.time + 25 //25 ticks, swap to 15 MINUTES after testing. //TODO: Figure out a way to make cooldowns work properly.
		user.visible_message("[user] grits their teeth and begins breathing slowly.", "You grit your teeth and remind yourself you ain't got time to bleed!")
		log_and_message_admins("([src]) used their indomitable spirit perk.")
		user.reagents.add_reagent("adrenol", 5)
		return

/mob/living/carbon/human/proc/battlecry()
	set category = "Human Perks"
	set name = "Inspiring Battlecry"
	var/mob/living/carbon/human/user = usr
	var/list/people_around = list()
	var/perk_id = "battlecry"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("You cannot muster the willpower to have a heroic moment just yet."))
		return FALSE
	log_and_message_admins("([src]) used their battlecry perk.")
	for(var/mob/living/carbon/human/H in view(user))
		if(H != user && !isdeaf(H))
			people_around.Add(H)
	if(people_around.len > 0)
		for(var/mob/living/carbon/human/participant in people_around)
			to_chat(participant, SPAN_NOTICE("You feel inspired by a heroic shout!"))
			give_boost(participant)
	give_boost(usr)
	user.visible_message("[user] lets out a guttural scream of inspiration!", "You yell with all your suppressed primality, your heart beats drums of war.")
	perk_cooldown_list[perk_id] = world.time + 45 //45 ticks, swap to 15 MINUTES after testing. //TODO: Figure out a way to make cooldowns work properly.
	return

/mob/living/carbon/human/proc/give_boost(mob/living/carbon/human/participant)
	var/effect_time = 2 MINUTES
	var/amount = 10
	var/list/stats_to_boost = list(STAT_ROB = 10, STAT_TGH = 10, STAT_VIG = 10)
	for(var/stat in stats_to_boost)
		participant.stats.changeStat(stat, amount)
		addtimer(CALLBACK(src, PROC_REF(take_boost), participant, stat, amount), effect_time)

/mob/living/carbon/human/proc/take_boost(mob/living/carbon/human/participant, stat, amount)
	participant.stats.changeStat(stat, -amount)




//////////////MAR'QUA PERKS

/datum/perk/racial/marqua 
	name = "Cautious Curiosity"
	desc = "Curiosity is an innate trait of your species, and you prefer to approach things cautiously."
	var/list/marqua_perks = list(
		/mob/living/carbon/human/proc/cautiousbrilliance) 

/datum/perk/racial/marqua/assign(mob/living/carbon/human/H) 
	if(..())
		add_verb(holder, marqua_perks)

/datum/perk/racial/marqua/remove() 
	if(holder)
		remove_verb(holder, marqua_perks)
	..()

/mob/living/carbon/human/proc/cautiousbrilliance()
	var/mob/living/carbon/human/user = usr
	set category = "Mar'Qua Perks"
	set name = "Cautious Brilliance"
	var/perk_id = "cautiousbrilliance"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return ..()
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("You are mentally exhausted, you'll need more rest before you can attempt greater thought."))
		return FALSE
	perk_cooldown_list[perk_id] = world.time + 45 
	user.visible_message("[user] suddenly looks lost in thought, their focus elsewhere for a moment.", "You clear your mind and feel your thoughts focusing into a single stream of brilliance.", "You hear the calming silence, as if someone nearby is thinking deeply.")
	log_and_message_admins("[src] used their cautious brilliance perk.")
	user.reagents.add_reagent("marquatol", 10)
	return ..()

/datum/perk/alien_nerves
	name = "Adapted Nervous System"
	desc = "The Mar'Quaran nervous system has long since adapted to the use of stimulants, chemicals, and different toxins. Unlike lesser races, you can handle a wide variety of chemicals before showing any side effects and you'll never become addicted."

/datum/perk/alien_nerves/assign(mob/living/L)
	..()
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		H.metabolism_effects.addiction_chance_multiplier = -1

/datum/perk/alien_nerves/remove()
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		H.metabolism_effects.addiction_chance_multiplier = 1
	..()




//////////////SABLEKYNE PERKS

/datum/perk/racial/sablekyne
	name = "Last Stand"
	desc = "As a sablekyne, your body is a living tank. Through a combination of willpower and biology alone you can ignore pain entirely for a short amount of time."
	var/list/sablekyne_perks = list(
		/mob/living/carbon/human/proc/laststand) 

/datum/perk/racial/sablekyne/assign(mob/living/carbon/human/H)
	if(..())
		add_verb(holder, sablekyne_perks)

/datum/perk/racial/sablekyne/remove() 
	if(holder)
		remove_verb(holder, sablekyne_perks)
	..()

/mob/living/carbon/human/proc/laststand()
	var/mob/living/carbon/human/user = usr
	set category = "Sablekyne Perks"
	set name = "Last Stand"
	var/perk_id = "laststand"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return ..()
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("Your nerves are shot, you'll need to recover before you can withstand greater pain again."))
		return FALSE
	perk_cooldown_list[perk_id] = world.time + 45 
	user.visible_message("<b><font color='red'>[user] begins growling as their muscles tighten!</font><b>", "<b><font color='red'>You feel a comfortable warmth as your body steels itself against all pain.</font><b>", "<b><font color='red'>You hear something growling!</font><b>")
	log_and_message_admins("[src] used their last stand perk.")
	user.reagents.add_reagent("sabledone", 10)
	return ..()




/////////////////KRIOSAN PERKS

/datum/perk/racial/kriosan
	name = "Predatory Sense"
	desc = "You're a predator at heart and have the senses to match, for a short time your body toughens and your aim improves drastically as your senses enhance."
	var/list/kriosan_perks = list(
		/mob/living/carbon/human/proc/enhancedsenses) 

/datum/perk/racial/kriosan/assign(mob/living/carbon/human/H)
	if(..())
		add_verb(holder, kriosan_perks)

/datum/perk/racial/kriosan/remove() 
	if(holder)
		remove_verb(holder, kriosan_perks)
	..()

/mob/living/carbon/human/proc/enhancedsenses()
	var/mob/living/carbon/human/user = usr
	set category = "Kriosan Perks"
	set name = "Eyes on Prey"
	var/perk_id = "enhancedsenses"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return ..()
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("You haven't quite recovered yet, your senses need more time before you may do this again."))
		return FALSE
	perk_cooldown_list[perk_id] = world.time + 45 
	user.visible_message("<b><font color='red'>[user] sneers lightly as their pupils dilate and tension builds in their body!</font><b>", "<b><font color='red'>You feel your senses focusing, sound becomes crystal clear and your reflexes as fluid as water.</font><b>")
	log_and_message_admins("[src] used their enhanced senses perk.")
	user.reagents.add_reagent("kriotol", 5)
	return ..()



///////////////////AKULA PERK

/datum/perk/racial/akula
	name = "Reckless Abandon"
	desc = "You're a predator at heart and have the senses to match, for a short time your body toughens and your aim improves drastically as your senses enhance."
	var/list/akula_perks = list(
		/mob/living/carbon/human/proc/recklessness) 

/datum/perk/racial/akula/assign(mob/living/carbon/human/H)
	if(..())
		add_verb(holder, akula_perks)

/datum/perk/racial/akula/remove() 
	if(holder)
		remove_verb(holder, akula_perks)
	..()

/mob/living/carbon/human/proc/recklessness()
	var/mob/living/carbon/human/user = usr
	set category = "Akula Perks"
	set name = "Recklessness"
	var/perk_id = "recklessness"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return ..()
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("Your body has been taxed to its limits, you need more time to recover before doing this again."))
		return FALSE
	perk_cooldown_list[perk_id] = world.time + 45 
	user.visible_message("<b><font color='red'>[user] lets out deep guttural growl as their eyes glaze over!</font><b>", "<b><font size='3px'><font color='red'>You abandon all reason as your sink into a blood thirsty frenzy!</font><b>", "<b><font color='red'>You hear a terrifying roar!</font><b>")
	//TODO: add noise
	log_and_message_admins("[src] used their recklessness perk.")
	user.reagents.add_reagent("robustitol", 5)
	return ..()




///////////////////NARAMAD PERKS

/datum/perk/racial/naramad
	name = "Naramadism"
	desc = "Naramads are built for extreme speed, be it for bravely charging forth or running away at break-neck velocities."
	var/list/naramad_perks = list(
		/mob/living/carbon/human/proc/adrenalburst) 

/datum/perk/racial/naramad/assign(mob/living/carbon/human/H)
	if(..())
		add_verb(holder, naramad_perks)

/datum/perk/racial/naramad/remove() 
	if(holder)
		remove_verb(holder, naramad_perks)
	..()

/mob/living/carbon/human/proc/adrenalburst()
	var/mob/living/carbon/human/user = usr
	set category = "Naramad Perks"
	set name = "Breakneck Velocity"
	var/perk_id = "recklessness"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return ..()
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("Your legs ache, you'll need more time to recover before doing this again."))
		return FALSE
	perk_cooldown_list[perk_id] = world.time + 45 
	user.visible_message("[user] begins breathing much quicker!", "You feel your heart rate increasing rapidly as everything seems to slow down around you!")
	//TODO: add noise
	log_and_message_admins("[src] used their adrenal burst perk.")
	user.reagents.add_reagent("naratonin", 5)
	return ..()





///////////////////CINDARITE PERKS

/datum/perk/racial/cindarite
	name = "Canny Resilience"
	desc = "The Cindarite body is extremely adept at countering and preventing toxins from doing damage to it."
	var/list/cindarite_perks = list(
		/mob/living/carbon/human/proc/purge_toxins,
		/mob/living/carbon/human/proc/purge_infections) 

/datum/perk/racial/cindarite/assign(mob/living/carbon/human/H)
	if(..())
		add_verb(holder, cindarite_perks)

/datum/perk/racial/cindarite/remove() 
	if(holder)
		remove_verb(holder, cindarite_perks)
	..()

/mob/living/carbon/human/proc/purge_toxins()
	var/mob/living/carbon/human/user = usr
	set category = "Cindarite Perks"
	set name = "Toxin-core"
	var/perk_id = "toxicity"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return ..()
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("Your body aches with the pain of its recent purge, you'll need more rest before doing this again."))
		return FALSE
	perk_cooldown_list[perk_id] = world.time + 45 
	user.visible_message("[user] shivers slightly as they begin to slow down.", "You start to feel quite chilly and tired as your body begins purging toxins within your blood.")
	//TODO: add noise
	log_and_message_admins("[src] used their toxin purge perk.")
	user.reagents.add_reagent("cindpetamol", 5)
	return ..()

/mob/living/carbon/human/proc/purge_infections()
	var/mob/living/carbon/human/user = usr
	set category = "Cindarite Perks"
	set name = "Canny Resilience"
	var/perk_id = "deinfect"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return ..()
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("Your chemical sacks have not refilled yet, you'll need more rest before doing this again."))
		return FALSE
	perk_cooldown_list[perk_id] = world.time + 45 
	user.visible_message("[user] shivers slightly before taking a deep breath.", "You shiver slightly and take a deep breath before willing your bodies chemical sacks to open and begin purging infections.")
	//TODO: add noise
	log_and_message_admins("[src] used their infection purge perk.")
	user.reagents.add_reagent("cindicillin", 5)
	return ..()




///////////////////OPIFEX PERKS

/datum/perk/racial/opifex
	name = "Technocracy"
	desc = "You retrieve your smuggled tools hidden on your person somewhere, along with the opifex-made webbing vest that holds them."
	var/list/opifex_perks = list(
		/mob/living/carbon/human/proc/smuggled_tools) 

/datum/perk/racial/opifex/assign(mob/living/carbon/human/H)
	if(..())
		add_verb(holder, opifex_perks)

/datum/perk/racial/opifex/remove() 
	if(holder)
		remove_verb(holder, opifex_perks)
	..()

/mob/living/carbon/human/proc/smuggled_tools()
	var/mob/living/carbon/human/user = usr
	set category = "Opifex Perks"
	set name = "Handi-bird"
	var/perk_id = "handibird"
	var/cooldown_end = perk_cooldown_list[perk_id] || 0
	if(!istype(user))
		return ..()
	if(world.time < cooldown_end)
		to_chat(usr, SPAN_NOTICE("You've already retrieved your set of back up tools. You didn't lose them, did you?"))
		return FALSE
	perk_cooldown_list[perk_id] = world.time + 12 HOURS
	to_chat(usr, SPAN_NOTICE("You discreetly and stealthily slip your back-up tools out from their hiding place, the belt unfolds as it quietly flops to the floor."))
	//TODO: add noise
	log_and_message_admins("[src] used their smuggled tool perk.")
	new /obj/item/storage/belt/utility/full(usr.loc)
	return ..()

//TODO: add other, NON-OP  and ORIGINAL kits.
