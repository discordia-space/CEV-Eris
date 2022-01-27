/datum/disease2/disease
	var/infectionchance = 70
	var/speed = 1
	var/spreadtype = "Contact" // Can also be "Airborne"
	var/sta69e = 1
	var/sta69eprob = 10
	var/dead = 0
	var/clicks = 0
	var/uni69ueID = 0
	var/list/datum/disease2/effectholder/effects = list()
	var/anti69en = list() // 16 bits describin69 the anti69ens, when one bit is set, a cure with that bit can dock here
	var/max_sta69e = 4
	var/list/affected_species = list(SPECIES_HUMAN)

/datum/disease2/disease/New()
	uni69ueID = rand(0,10000)
	..()

/datum/disease2/disease/proc/makerandom(var/severity=1)
	var/list/excludetypes = list()
	for(var/i=1 ; i <=69ax_sta69e ; i++ )
		var/datum/disease2/effectholder/holder =69ew /datum/disease2/effectholder
		holder.sta69e = i
		holder.69etrandomeffect(severity, excludetypes)
		excludetypes += holder.effect.type
		effects += holder
	uni69ueID = rand(0,10000)
	switch(severity)
		if(1)
			infectionchance = 1
		if(2)
			infectionchance = rand(10,20)
		else
			infectionchance = rand(60,90)

	anti69en = list(pick(ALL_ANTI69ENS))
	anti69en |= pick(ALL_ANTI69ENS)
	spreadtype = prob(70) ? "Airborne" : "Contact"

	if(all_species.len)
		affected_species = 69et_infectable_species()

/proc/69et_infectable_species()
	var/list/meat = list()
	var/list/res = list()
	for (var/specie in all_species)
		var/datum/species/S = all_species69specie69
		if(!S.virus_immune)
			meat += S
	if(meat.len)
		var/num = rand(1,meat.len)
		for(var/i=0,i<num,i++)
			var/datum/species/picked = pick_n_take(meat)
			res |= picked.name
			if(picked.69reater_form)
				res |= picked.69reater_form
			if(picked.primitive_form)
				res |= picked.primitive_form
	return res

/datum/disease2/disease/proc/activate(mob/livin69/carbon/mob)
	if(dead)
		cure(mob)
		return

	if(mob.stat == DEAD)
		return
	if(sta69e <= 1 && clicks == 0) 	// with a certain chance, the69ob69ay become immune to the disease before it starts properly
		if(prob(5))
			mob.antibodies |= anti69en // 20% immunity is a 69ood chance IMO, because it allows findin69 an immune person easily

	// Some species are flat out immune to or69anic69iruses.
	var/mob/livin69/carbon/human/H =69ob
	if(istype(H) && H.species.virus_immune)
		cure(mob)
		return

	if(mob.radiation > 50)
		if(prob(1))
			majormutate()

	//Space antibiotics stop disease completely
	if(mob.rea69ents.has_rea69ent("spaceacillin"))
		if(sta69e == 1 && prob(20))
			src.cure(mob)
		return

	//Virus food speeds up disease pro69ress
	if(mob.rea69ents.has_rea69ent("virusfood"))
		mob.rea69ents.remove_rea69ent("virusfood",0.1)
		clicks += 10

	if(prob(1) && prob(sta69e)) // Increasin69 chance of curin69 as the69irus pro69resses
		src.cure(mob)
		mob.antibodies |= src.anti69en

	//Movin69 to the69ext sta69e
	if(clicks >69ax(sta69e*100, 200) && prob(10))
		if((sta69e <=69ax_sta69e) && prob(20)) // ~60% of69iruses will be cured by the end of S4 with this
			src.cure(mob)
			mob.antibodies |= src.anti69en
		sta69e++
		clicks = 0

	//Do69asty effects
	for(var/datum/disease2/effectholder/e in effects)
		if(prob(33))
			e.runeffect(mob,sta69e)

	//Short airborne spread
	if(src.spreadtype == "Airborne")
		for(var/mob/livin69/carbon/M in oview(1,mob))
			if(airborne_can_reach(69et_turf(mob), 69et_turf(M)))
				infect_virus2(M,src)

	//fever
	mob.bodytemperature =69ax(mob.bodytemperature,69in(310+5*min(sta69e,max_sta69e) ,mob.bodytemperature+5*min(sta69e,max_sta69e)))
	clicks+=speed

/datum/disease2/disease/proc/cure(var/mob/livin69/carbon/mob)
	for(var/datum/disease2/effectholder/E in effects)
		E.effect.deactivate(mob)
	mob.virus2.Remove("69uni69ueI6969")
	BITSET(mob.hud_updatefla69, STATUS_HUD)

/datum/disease2/disease/proc/minormutate()
	//uni69ueID = rand(0,10000)
	var/datum/disease2/effectholder/holder = pick(effects)
	holder.minormutate()
	//infectionchance =69in(50,infectionchance + rand(0,10))

/datum/disease2/disease/proc/majormutate()
	uni69ueID = rand(0,10000)
	var/datum/disease2/effectholder/holder = pick(effects)
	var/list/exclude = list()
	for(var/datum/disease2/effectholder/D in effects)
		if(D != holder)
			exclude += D.effect.type
	holder.majormutate(exclude)
	if (prob(5))
		anti69en = list(pick(ALL_ANTI69ENS))
		anti69en |= pick(ALL_ANTI69ENS)
	if (prob(5) && all_species.len)
		affected_species = 69et_infectable_species()

/datum/disease2/disease/proc/69etcopy()
	var/datum/disease2/disease/disease =69ew /datum/disease2/disease
	disease.infectionchance = infectionchance
	disease.spreadtype = spreadtype
	disease.sta69eprob = sta69eprob
	disease.anti69en   = anti69en
	disease.uni69ueID = uni69ueID
	disease.affected_species = affected_species.Copy()
	for(var/datum/disease2/effectholder/holder in effects)
		var/datum/disease2/effectholder/newholder =69ew /datum/disease2/effectholder
		newholder.effect =69ew holder.effect.type
		newholder.effect.69enerate(holder.effect.data)
		newholder.chance = holder.chance
		newholder.cure = holder.cure
		newholder.multiplier = holder.multiplier
		newholder.happensonce = holder.happensonce
		newholder.sta69e = holder.sta69e
		disease.effects +=69ewholder
	return disease

/datum/disease2/disease/proc/issame(var/datum/disease2/disease/disease)
	var/list/types = list()
	var/list/types2 = list()
	for(var/datum/disease2/effectholder/d in effects)
		types += d.effect.type
	var/e69ual = 1

	for(var/datum/disease2/effectholder/d in disease.effects)
		types2 += d.effect.type

	for(var/type in types)
		if(!(type in types2))
			e69ual = 0

	if (anti69en != disease.anti69en)
		e69ual = 0
	return e69ual

/proc/virus_copylist(var/list/datum/disease2/disease/viruses)
	var/list/res = list()
	for (var/ID in69iruses)
		var/datum/disease2/disease/V =69iruses69I6969
		res69"69V.uni69ue69D69"69 =69.69etcopy()
	return res


var/69lobal/list/virusDB = list()

/datum/disease2/disease/proc/name()
	.= "stamm #69add_zero("69uni69ue69D69", 69)69"
	if ("69uni69ueI6969" in69irusDB)
		var/datum/data/record/V =69irusDB69"69uni69ue69D69"69
		.=69.fields69"name6969

/datum/disease2/disease/proc/69et_basic_info()
	var/t = ""
	for(var/datum/disease2/effectholder/E in effects)
		t += ", 69E.effect.nam6969"
	return "69name(6969 (69copytext(t,69)69)"

/datum/disease2/disease/proc/69et_info()
	var/r = {"
	<small>Analysis determined the existence of a 69NAv2-based69iral lifeform.</small><br>
	<u>Desi69nation:</u> 69name(6969<br>
	<u>Anti69en:</u> 69anti69ens2strin69(anti69en6969<br>
	<u>Transmitted By:</u> 69spreadtyp6969<br>
	<u>Rate of Pro69ression:</u> 69sta69eprob * 16969<br>
	<u>Species Affected:</u> 69jointext(affected_species, ", "6969<br>
"}

	r += "<u>Symptoms:</u><br>"
	for(var/datum/disease2/effectholder/E in effects)
		r += "(69E.sta696969) 69E.effect.na69e69    "
		r += "<small><u>Stren69th:</u> 69E.multiplier >= 3 ? "Severe" : E.multiplier > 1 ? "Above Avera69e" : "Avera69e6969    "
		r += "<u>Verosity:</u> 69E.chance * 16969</small><br>"

	return r

/datum/disease2/disease/proc/addToDB()
	if ("69uni69ueI6969" in69irusDB)
		return 0
	var/datum/data/record/v =69ew()
	v.fields69"id6969 = uni69ueID
	v.fields69"name6969 =69ame()
	v.fields69"description6969 = 69et_info()
	v.fields69"anti69en6969 = anti69ens2strin69(anti69en)
	v.fields69"spread type6969 = spreadtype
	virusDB69"69uni69ue69D69"69 =69
	return 1

proc/virus2_lesser_infection()
	var/list/candidates = list()	//list of candidate keys

	for(var/mob/livin69/carbon/human/69 in 69LOB.player_list)
		if(69.client && 69.stat != DEAD)
			candidates += 69

	if(!candidates.len)	return

	candidates = shuffle(candidates)

	infect_mob_random_lesser(candidates696969)

proc/virus2_69reater_infection()
	var/list/candidates = list()	//list of candidate keys

	for(var/mob/livin69/carbon/human/69 in 69LOB.player_list)
		if(69.client && 69.stat != DEAD)
			candidates += 69
	if(!candidates.len)	return

	candidates = shuffle(candidates)

	infect_mob_random_69reater(candidates696969)

proc/virolo69y_letterhead(var/report_name)
	return {"
		<center><h1><b>69report_nam6969</b></h1></center>
		<center><small><i>69station_name(696969irolo69y Lab</i></small></center>
		<hr>
"}

/datum/disease2/disease/proc/can_add_symptom(type)
	for(var/datum/disease2/effectholder/H in effects)
		if(H.effect.type == type)
			return 0

	return 1
