/datum/ritual/group/cruciform
	implant_type = /obj/item/weapon/implant/core_implant/cruciform
	success_message = "On the verge of audibility you hear pleasant music, your mind clears up and the spirit grows stronger. Your prayer was heard."
	fail_message = "Cruciform on your chest is getting cold and pricks your skin."
	cooldown = FALSE

/datum/ritual/group/cruciform/mechanical
	name = "Mechanical"
	desc = "Boosts Mechanical stat to 3 + 1 for each participant."
	phrase = "Omnia haec tractavi in corde meo ut curiose intellegerem sunt iusti atque sapientes et opera eorum in manu Dei et tamen nescit homo utrum amore an odio dignus sit."
	phrases = list(
		"Omnia haec tractavi in corde meo ut curiose intellegerem sunt iusti atque sapientes et opera eorum in manu Dei et tamen nescit homo utrum amore an odio dignus sit.",
		"Sed omnia in futuro servantur incerta eo quod universa aeque eveniant iusto et impio bono et malo mundo et inmundo immolanti victimas et sacrificia contemnenti sicut bonus sic et peccator ut periurus ita et ille qui verum deierat.",
		"Hoc est pessimum inter omnia quae sub sole fiunt quia eadem cunctis eveniunt unde et corda filiorum hominum implentur malitia et contemptu in vita sua et post haec ad inferos deducentur.",
		"Nemo est qui semper vivat et qui huius rei habeat fiduciam melior est canis vivens leone mortuo.",
		"Viventes enim sciunt se esse morituros mortui vero nihil noverunt amplius nec habent ultra mercedem quia oblivioni tradita est memoria eorum.",
		"Amor quoque et odium et invidia simul perierunt nec habent partem in hoc saeculo et in opere quod sub sole geritur.",
		"Vade ergo et comede in laetitia panem tuum et bibe cum gaudio vinum tuum quia Deo placent opera tua.",
		"Omni tempore sint vestimenta tua candida et oleum de capite tuo non deficiat.",
		"Perfruere vita cum uxore quam diligis cunctis diebus vitae instabilitatis tuae qui dati sunt tibi sub sole omni tempore vanitatis tuae haec est enim pars in vita et in labore tuo quod laboras sub sole.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/mechanical

/datum/group_ritual_effect/cruciform/mechanical/success(var/mob/living/M, var/cnt)
	var/stat = M.stats.getStat(STAT_MEC)
	stat += 3 + cnt
	M.stats.changeStat(STAT_MEC, stat)


/datum/ritual/group/cruciform/cognition
	name = "Cognition"
	desc = "Boosts Cognition stat to 3 + 1 for each participant."
	phrase = "Dedit quoque Deus sapientiam Salomoni et prudentiam multam nimis et latitudinem cordis quasi harenam quae est in litore maris."
	phrases = list(
		"Dedit quoque Deus sapientiam Salomoni et prudentiam multam nimis et latitudinem cordis quasi harenam quae est in litore maris.",
		"Et praecedebat sapientia Salomonis sapientiam omnium Orientalium et Aegyptiorum.",
		"Et erat sapientior cunctis hominibus sapientior Aethan Ezraita et Heman et Chalcal et Dorda filiis Maol et erat nominatus in universis gentibus per circuitum.",
		"Locutus est quoque Salomon tria milia parabolas et fuerunt carmina eius quinque et mille.",
		"Et disputavit super lignis a cedro quae est in Libano usque ad hysopum quae egreditur de pariete et disseruit de iumentis et volucribus et reptilibus et piscibus.",
		"Et veniebant de cunctis populis ad audiendam sapientiam Salomonis et ab universis regibus terrae qui audiebant sapientiam eius.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/cognition

/datum/group_ritual_effect/cruciform/cognition/success(var/mob/living/M, var/cnt)
	var/stat = M.stats.getStat(STAT_COG)
	stat += 3 + cnt
	M.stats.changeStat(STAT_COG, stat)



/datum/ritual/group/cruciform/biology
	name = "Biology"
	desc = "Boosts Biology stat to 3 + 1 for each participant."
	phrase = "Convocatis autem duodecim apostolis dedit illis virtutem et potestatem super omnia daemonia et ut languores curarent."
	phrases = list(
		"Convocatis autem duodecim apostolis dedit illis virtutem et potestatem super omnia daemonia et ut languores curarent.",
		"Et misit illos praedicare regnum Dei et sanare infirmos.",
		"Et ait ad illos nihil tuleritis in via neque virgam neque peram neque panem neque pecuniam neque duas tunicas habeatis.",
		"Et in quamcumque domum intraveritis ibi manete et inde ne exeatis.",
		"Et quicumque non receperint vos exeuntes de civitate illa etiam pulverem pedum vestrorum excutite in testimonium supra illos.",
		"Egressi autem circumibant per castella evangelizantes et curantes ubique.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/biology

/datum/group_ritual_effect/cruciform/biology/success(var/mob/living/M, var/cnt)
	var/stat = M.stats.getStat(STAT_BIO)
	stat += 3 + cnt
	M.stats.changeStat(STAT_BIO, stat)


/datum/ritual/group/cruciform/robustness
	name = "Robustness"
	desc = "Boosts Robustness stat to 3 + 1 for each participant."
	phrase = "Audi Israhel tu transgredieris hodie Iordanem ut possideas nationes maximas et fortiores te civitates ingentes et ad caelum usque muratas."
	phrases = list(
		"Audi Israhel tu transgredieris hodie Iordanem ut possideas nationes maximas et fortiores te civitates ingentes et ad caelum usque muratas.",
		"Populum magnum atque sublimem filios Enacim quos ipse vidisti et audisti quibus nullus potest ex adverso resistere.",
		"Scies ergo hodie quod Dominus Deus tuus ipse transibit ante te ignis devorans atque consumens qui conterat eos et deleat atque disperdat ante faciem tuam velociter sicut locutus est tibi.",
		"Ne dicas in corde tuo cum deleverit eos Dominus Deus tuus in conspectu tuo propter iustitiam meam introduxit me Dominus ut terram hanc possiderem cum propter impietates suas istae deletae sint nationes.",
		"Neque enim propter iustitias tuas et aequitatem cordis tui ingredieris ut possideas terras eorum sed quia illae egerunt impie te introeunte deletae sunt et ut conpleret verbum suum Dominus quod sub iuramento pollicitus est patribus tuis Abraham Isaac et Iacob.",
		"Scito igitur quod non propter iustitias tuas Dominus Deus tuus dederit tibi terram hanc optimam in possessionem cum durissimae cervicis sis populus.",
		"Amen.",
	)
	effect_type = /datum/group_ritual_effect/cruciform/robustness

/datum/group_ritual_effect/cruciform/robustness/success(var/mob/living/M, var/cnt)
	var/stat = M.stats.getStat(STAT_ROB)
	stat += 3 + cnt
	M.stats.changeStat(STAT_ROB, stat)


/datum/ritual/group/cruciform/toughness
	name = "Toughness"
	desc = "Boosts Toughness stat to 3 + 1 for each participant."
	phrase = "In finem psalmus David."
	phrases = list(
		"In finem psalmus David.",
		"Caeli enarrant gloriam Dei et opera manuum eius adnuntiat firmamentum.",
		"Dies diei eructat verbum et nox nocti indicat scientiam.",
		"Non sunt loquellae neque sermones quorum non audiantur voces eorum.",
		"In omnem terram exivit sonus eorum et in fines orbis terrae verba eorum.",
		"In sole posuit tabernaculum suum et ipse tamquam sponsus procedens de thalamo suo exultavit ut gigans ad currendam viam.",
		"A summo caeli egressio eius et occursus eius usque ad summum eius nec est qui se abscondat a calore eius.",
		"Amen."
	)
	effect_type = /datum/group_ritual_effect/cruciform/toughness

/datum/group_ritual_effect/cruciform/toughness/success(var/mob/living/M, var/cnt)
	var/stat = M.stats.getStat(STAT_TGH)
	stat += 3 + cnt
	M.stats.changeStat(STAT_TGH, stat)



