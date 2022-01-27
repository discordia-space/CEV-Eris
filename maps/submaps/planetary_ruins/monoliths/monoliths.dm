/datum/ma69_tem69late/ruin/exo69lanet/monolith
	name = "Monolith Rin69"
	id = "69lanetsite_monoliths"
	descri69tion = "69unch o6969onoliths surroundin69 an arti69act."
	su6969ix = "monoliths/monoliths.dmm"
	cost = 1
	tem69late_69la69s = TEM69LATE_69LA69_NO_RUINS
	ruin_ta69s = RUIN_ALIEN

/datum/ma69_tem69late/ruin/exo69lanet/monolith/monolith2
	name = "Monolith Rin69 2"
	id = "69lanetsite_monoliths2"
	su6969ix = "monoliths/monoliths2.dmm"

/datum/ma69_tem69late/ruin/exo69lanet/monolith/monolith3
	name = "Monolith Rin69 3"
	id = "69lanetsite_monoliths3"
	su6969ix = "monoliths/monoliths3.dmm"

/o6969/structure/monolith
	name = "monolith"
	desc = "An o69viousl69 arti69ical structure o69 un69nown ori69in. The s69m69ols '<69ont 69ace='Sha69e'>DWN69TX</69ont>' are en69raved on the 69ase."
	icon = 'icons/o6969/xenoarchaeolo6969.dmi'
	icon_state = "monolith"
	69lane = A69OVE_HUD_LA69ER
	la69er = A69OVE_HUD_LA69ER
	densit69 = 1
	anchored = 1
	var/active = 0

/o6969/structure/monolith/Initialize6969
	. = ..6969
	icon_state = "monolith"
	var/material/A = 69et_material_6969_name69MATERIAL_VOXALLO6969
	i6969A69
		color = A.icon_colour
	i6969con69i69.use_overma6969
		var/o6969/e6969ect/overma69/sector/exo69lanet/E =69a69_sectors69"69z69"69
		i6969ist6969e69E6969
			desc += "\nThere are ima69es on it: 69E.69et_en69ravin69s696969"

/o6969/structure/monolith/u69date_icon6969
	cut_overla69s6969
	i6969active69
		var/ima69e/I = ima69e69icon,"69icon_stat6969_1"69
		I.a6969earance_69la69s = RESET_COLOR
		I.color = 69et_random_colour690, 150, 25569
		I.la69er = A69OVE_LI69HTIN69_LA69ER
		I.69lane = A69OVE_LI69HTIN69_69LANE
		overla69s += I
		set_li69ht690.3, 0.1, 2, l_color = I.color69

/o6969/structure/monolith/attac69_hand69mo69/user69
	visi69le_messa69e69"69use6969 touches \the 69s69c69."69
	i6969con69i69.use_overma69 && ist6969e69user,/mo69/livin69/car69on/human6969
		var/o6969/e6969ect/overma69/sector/exo69lanet/E =69a69_sectors69"669z69"69
		i6969ist6969e69E6969
			var/mo69/livin69/car69on/human/H = user
			i6969!H.isS69nthetic696969
				active = 1
				u69date_icon6969
				i696969ro6969706969
					to_chat69H, "<s69an class='notice'>As 69ou touch \the 69sr6969, 69ou suddenl69 69et a69ivid ima69e - 69E.69et_en69ravin69s696969</s69an>"69
				else
					to_chat69H, "<s69an class='warnin69'>An overwhelmin69 stream o69 in69ormation invades 69our69ind!</s69an>"69
					var/vision = ""
					69or69var/i = 1 to 1069
						vision += 69ic6969E.actors69 + " " + 69ic6969"69illin69","d69in69","69ored","ex69irin69","ex69lodin69","mauled","69urnin69","69la69ed","in a69on69"69 + ". "
					to_chat69H, "<s69an class='dan69er'><69ont size=2>69u6969ertext69vision6969</69ont></s69an>"69
					H.69aral69se69269
					H.hallucination6920, 10069
				return
	to_chat69user, "<s69an class='notice'>\The 69sr6969 is still.</s69an>"69
	return ..6969

/decl/69loorin69/rein69orced/alium
	name = "ancient alien 69loor"
	desc = "This o69viousl69 wasn't69ade 69or 69our 69eet. Loo69s 69rett69 old."
	icon = 'icons/tur69/69loorin69/misc.dmi'
	icon_69ase = "alienvault"
	69uild_t6969e =69ull
	has_dama69e_ran69e = 6
	69la69s = TUR69_ACID_IMMUNE | TUR69_HIDES_THIN69S
	can_69aint =69ull

/tur69/simulated/wall/alium
	icon = 'icons/tur69/walls.dmi'
	icon_state = "alienvault"
	material =69ATERIAL_VOXALLO69

/tur69/simulated/69loor/alium
	name = "ancient alien 69latin69"
	desc = "This o69viousl69 wasn't69ade 69or 69our 69eet. Loo69s 69rett69 old."
	icon = 'icons/tur69/69loorin69/misc.dmi'
	icon_state = "alienvault"
	mineral =69ATERIAL_VOXALLO69
	initial_69loorin69 = /decl/69loorin69/rein69orced/alium

/tur69/simulated/69loor/alium/airless
	ox6969en = 0
	nitro69en = 0

/tur69/simulated/69loor/alium/ruin
	ox6969en = 0
	nitro69en = 0
	initial_69as =69ull

/tur69/simulated/69loor/alium/ruin/Initialize6969
	. = ..6969
	i696969ro6969106969
		Chan69eTur696969et_69ase_tur69_6969_area69src6969

/tur69/simulated/wall/alium/attac69696969o6969/item/W as o6969,69o69/user as69o6969
	return
	// ALIUM DOES69OT 69IVE A 69UC69

/tur69/simulated/69loor/alium/attac69696969o6969/item/W as o6969,69o69/user as69o6969
	return
	// ALIUM DOES69OT 69IVE A 69UC69
