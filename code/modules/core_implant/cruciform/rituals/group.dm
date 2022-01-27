/datum/ritual/group/cruciform
	implant_type = /obj/item/implant/core_implant/cruciform
	success_message = "On the69erge of audibility you hear pleasant69usic, your69ind clears up and the spirit grows stronger. Your prayer was heard."
	fail_message = "The Cruciform feels cold against your chest."
	var/high_ritual = TRUE

/datum/ritual/group/cruciform/pre_check(mob/living/carbon/human/user, obj/item/implant/core_implant/C, targets)
	if(!..())
		return FALSE
	if(high_ritual && !C.get_module(CRUCIFORM_PRIEST) && !is_inquisidor(user))
		return FALSE
	return TRUE

/datum/ritual/group/cruciform/step_check(mob/living/carbon/human/H)
	for(var/obj/machinery/power/nt_obelisk/O in range(7,H))
		if(O.stat || !O.active || get_dist(H, O) > O.area_radius)
			continue
		return TRUE
	return FALSE

/datum/ritual/group/cruciform/stat//parent ritual
	effect_type = /datum/group_ritual_effect/cruciform/stat

/datum/ritual/group/cruciform/stat/step_check(mob/living/carbon/human/H)
	if(GLOB.miracle_points < 1)
		return FALSE
	return TRUE

/datum/group_ritual_effect/cruciform/stat
	var/stat_buff
	var/buff_value = 3
	var/aditional_value = 2

/datum/group_ritual_effect/cruciform/stat/trigger_success(var/mob/starter,69ar/list/participants)
	. = ..()
	GLOB.miracle_points--
	if(eotp)
		eotp.addObservation(25)

/datum/group_ritual_effect/cruciform/stat/success(var/mob/living/M,69ar/cnt)
	if(cnt < 3 || !stat_buff)
		to_chat(M, SPAN_NOTICE("Insufficient participants."))
		return FALSE
	M.stats.changeStat(stat_buff, buff_value + cnt * aditional_value)

/datum/ritual/group/cruciform/stat/mechanical
	name = "Pounding Whisper"
	desc = "Boosts69echanical stat to 3 + 2 for each participant."
	phrase = "Omnia haec tractavi in corde69eo ut curiose intellegerem sunt iusti atque sapientes et opera eorum in69anu Dei et tamen nescit homo utrum amore an odio dignus sit."
	phrases = list(
		"Omnia haec tractavi in corde69eo ut curiose intellegerem sunt iusti atque sapientes et opera eorum in69anu Dei et tamen nescit homo utrum amore an odio dignus sit.",
		"Sed omnia in futuro servantur incerta eo quod universa aeque eveniant iusto et impio bono et69alo69undo et inmundo immolanti69ictimas et sacrificia contemnenti sicut bonus sic et peccator ut periurus ita et ille qui69erum deierat.",
		"Hoc est pessimum inter omnia quae sub sole fiunt quia eadem cunctis eveniunt unde et corda filiorum hominum implentur69alitia et contemptu in69ita sua et post haec ad inferos deducentur.",
		"Nemo est qui semper69ivat et qui huius rei habeat fiduciam69elior est canis69ivens leone69ortuo.",
		"Viventes enim sciunt se esse69orituros69ortui69ero nihil noverunt amplius nec habent ultra69ercedem quia oblivioni tradita est69emoria eorum.",
		"Amor quoque et odium et invidia simul perierunt nec habent partem in hoc saeculo et in opere quod sub sole geritur.",
		"Vade ergo et comede in laetitia panem tuum et bibe cum gaudio69inum tuum quia Deo placent opera tua.",
		"Omni tempore sint69estimenta tua candida et oleum de capite tuo non deficiat.",
		"Perfruere69ita cum uxore quam diligis cunctis diebus69itae instabilitatis tuae qui dati sunt tibi sub sole omni tempore69anitatis tuae haec est enim pars in69ita et in labore tuo quod laboras sub sole.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/stat/mechanical

/datum/group_ritual_effect/cruciform/stat/mechanical
	stat_buff = STAT_MEC


/datum/ritual/group/cruciform/stat/cognition
	name = "Revelation of Secrets"
	desc = "Boosts Cognition stat to 3 + 2 for each participant."
	phrase = "Dedit quoque Deus sapientiam Salomoni et prudentiam69ultam nimis et latitudinem cordis quasi harenam quae est in litore69aris."
	phrases = list(
		"Dedit quoque Deus sapientiam Salomoni et prudentiam69ultam nimis et latitudinem cordis quasi harenam quae est in litore69aris.",
		"Et praecedebat sapientia Salomonis sapientiam omnium Orientalium et Aegyptiorum.",
		"Et erat sapientior cunctis hominibus sapientior Aethan Ezraita et Heman et Chalcal et Dorda filiis69aol et erat nominatus in universis gentibus per circuitum.",
		"Locutus est quoque Salomon tria69ilia parabolas et fuerunt carmina eius quinque et69ille.",
		"Et disputavit super lignis a cedro quae est in Libano usque ad hysopum quae egreditur de pariete et disseruit de iumentis et69olucribus et reptilibus et piscibus.",
		"Et69eniebant de cunctis populis ad audiendam sapientiam Salomonis et ab universis regibus terrae qui audiebant sapientiam eius.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/stat/cognition

/datum/group_ritual_effect/cruciform/stat/cognition
	stat_buff = STAT_COG



/datum/ritual/group/cruciform/stat/biology
	name = "Lisp of69itae"
	desc = "Boosts Biology stat to 3 + 2 for each participant."
	phrase = "Convocatis autem duodecim apostolis dedit illis69irtutem et potestatem super omnia daemonia et ut languores curarent."
	phrases = list(
		"Convocatis autem duodecim apostolis dedit illis69irtutem et potestatem super omnia daemonia et ut languores curarent.",
		"Et69isit illos praedicare regnum Dei et sanare infirmos.",
		"Et ait ad illos nihil tuleritis in69ia neque69irgam neque peram neque panem neque pecuniam neque duas tunicas habeatis.",
		"Et in quamcumque domum intraveritis ibi69anete et inde ne exeatis.",
		"Et quicumque non receperint69os exeuntes de civitate illa etiam pulverem pedum69estrorum excutite in testimonium supra illos.",
		"Egressi autem circumibant per castella evangelizantes et curantes ubique.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/stat/biology

/datum/group_ritual_effect/cruciform/stat/biology
	stat_buff = STAT_BIO


/datum/ritual/group/cruciform/stat/robustness
	name = "Canto of Courage"
	desc = "Boosts Robustness stat to 3 + 2 for each participant."
	phrase = "Audi Israhel tu transgredieris hodie Iordanem ut possideas nationes69aximas et fortiores te civitates ingentes et ad caelum usque69uratas."
	phrases = list(
		"Audi Israhel tu transgredieris hodie Iordanem ut possideas nationes69aximas et fortiores te civitates ingentes et ad caelum usque69uratas.",
		"Populum69agnum atque sublimem filios Enacim quos ipse69idisti et audisti quibus nullus potest ex adverso resistere.",
		"Scies ergo hodie quod Dominus Deus tuus ipse transibit ante te ignis devorans atque consumens qui conterat eos et deleat atque disperdat ante faciem tuam69elociter sicut locutus est tibi.",
		"Ne dicas in corde tuo cum deleverit eos Dominus Deus tuus in conspectu tuo propter iustitiam69eam introduxit69e Dominus ut terram hanc possiderem cum propter impietates suas istae deletae sint nationes.",
		"Neque enim propter iustitias tuas et aequitatem cordis tui ingredieris ut possideas terras eorum sed quia illae egerunt impie te introeunte deletae sunt et ut conpleret69erbum suum Dominus quod sub iuramento pollicitus est patribus tuis Abraham Isaac et Iacob.",
		"Scito igitur quod non propter iustitias tuas Dominus Deus tuus dederit tibi terram hanc optimam in possessionem cum durissimae cervicis sis populus.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/stat/robustness

/datum/group_ritual_effect/cruciform/stat/robustness
	stat_buff = STAT_ROB

/datum/ritual/group/cruciform/stat/vigilance
	name = "Canto of Courage"
	desc = "Boosts69igilance stat to 3 + 2 for each participant."
	phrase = "Vigilia exemplum imitari debemus."
	phrases = list(
		"Vigilia exemplum imitari debemus.",
		"Pater nos tuetur ac curae.",
		"Novit Patrem nos dirigit in69iam rectam.",
		"Patris nostri et benedicet tuetur.",
		"Pater amat et tuetur.",
		"Patrem tuetur et protegit.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/stat/vigilance

/datum/group_ritual_effect/cruciform/stat/vigilance
	stat_buff = STAT_VIG


/datum/ritual/group/cruciform/stat/toughness
	name = "Reclamation of Endurance"
	desc = "Boosts Toughness stat to 3 + 2 for each participant."
	phrase = "In finem psalmus David."
	phrases = list(
		"In finem psalmus David.",
		"Caeli enarrant gloriam Dei et opera69anuum eius adnuntiat firmamentum.",
		"Dies diei eructat69erbum et nox nocti indicat scientiam.",
		"Non sunt loquellae neque sermones quorum non audiantur69oces eorum.",
		"In omnem terram exivit sonus eorum et in fines orbis terrae69erba eorum.",
		"In sole posuit tabernaculum suum et ipse tamquam sponsus procedens de thalamo suo exultavit ut gigans ad currendam69iam.",
		"A summo caeli egressio eius et occursus eius usque ad summum eius nec est qui se abscondat a calore eius.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/stat/toughness

/datum/group_ritual_effect/cruciform/stat/toughness
	stat_buff = STAT_TGH


/datum/ritual/group/cruciform/crusade
	name = "Crusade"
	desc = "Reveal crusade litanies to disciples. Depends on participants amount."
	phrase = "Locutus est Dominus ad69osen dicens."
	phrases = list(
		"Locutus est Dominus ad69osen dicens.",
		"Fac tibi duas tubas argenteas ductiles quibus convocare possis69ultitudinem quando69ovenda sunt castra.",
		"Cumque increpueris tubis congregabitur ad te omnis turba ad ostium foederis tabernaculi.",
		"Si semel clangueris69enient ad te principes et capita69ultitudinis Israhel.",
		"Sin autem prolixior atque concisus clangor increpuerit69ovebunt castra primi qui sunt ad orientalem plagam.",
		"In secundo autem sonitu et pari ululatu tubae levabunt tentoria qui habitant ad69eridiem et iuxta hunc69odum reliqui facient ululantibus tubis in profectione.",
		"Quando autem congregandus est populus simplex tubarum clangor erit et non concise ululabunt.",
		"Filii Aaron sacerdotes clangent tubis eritque hoc legitimum sempiternum in generationibus69estris.",
		"Si exieritis ad bellum de terra69estra contra hostes qui dimicant adversum69os clangetis ululantibus tubis et erit recordatio69estri coram Domino Deo69estro ut eruamini de69anibus inimicorum69estrorum."
	)
	effect_type = /datum/group_ritual_effect/cruciform/crusade

/atom/movable/var/crusade_effect = FALSE

/atom/movable/proc/crusade_activated()
	if(crusade_effect)
		return FALSE
	crusade_effect = TRUE
	return TRUE

/datum/group_ritual_effect/cruciform/crusade/trigger_success(mob/starter, list/participants)
	..()
	for(var/atom/movable/A in GLOB.all_faction_items)
		A.crusade_activated()

/datum/group_ritual_effect/cruciform/crusade/success(var/mob/living/M,69ar/cnt)
	if(cnt < 6)
		return
	var/obj/item/implant/core_implant/CI =69.get_core_implant(/obj/item/implant/core_implant/cruciform)
	if(CI)
		var/datum/ritual/cruciform/crusader/C = /datum/ritual/cruciform/crusader/brotherhood
		CI.known_rituals |= initial(C.name)
		C = /datum/ritual/cruciform/crusader/battle_call
		CI.known_rituals |= initial(C.name)
		C = /datum/ritual/cruciform/crusader/flash
		CI.known_rituals |= initial(C.name)

/datum/ritual/group/cruciform/sanctify
	name = "Sanctify"
	desc = "Sanctify the land you tread."
	phrase = "Benedicite loco isto."
	phrases = list(
		"Benedicite loco isto.",
		"Benedic hoc petimus Patris.",
		"Nos obsecro te removere percula huius loci.",
		"Ne69alorum tangere terram",
		"Frase quinta",
		"Frase sexta",
		"Frase septima"
	)
	effect_type = /datum/group_ritual_effect/cruciform/sanctify
	high_ritual = FALSE

/datum/ritual/group/cruciform/sanctify/step_check(mob/living/carbon/human/H)
	return TRUE

/datum/group_ritual_effect/cruciform/sanctify/trigger_success(mob/starter, list/participants)
	..()
	var/area/A = get_area(starter)
	A?.sanctify()
	for(var/obj/machinery/power/nt_obelisk/O in GLOB.all_obelisk)
		O.force_active =69ax(60, O.force_active)

/area/proc/sanctify()
	SEND_SIGNAL(src, COMSIG_AREA_SANCTIFY)
	return
