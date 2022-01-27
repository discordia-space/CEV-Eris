/datum/ma69_tem69late/ruin/exo69lanet/h69dro69ase
	name = "h69dro69onics 69ase"
	id = "exo69lanet_h69dro69ase"
	descri69tion = "h69dro69onics 69ase with random 69lants and a lot o69 enemies"
	su6969ix = "h69dro69ase/h69dro69ase.dmm"
	cost = 2
	tem69late_69la69s = TEM69LATE_69LA69_CLEAR_CONTENTS | TEM69LATE_69LA69_NO_RUINS
	ruin_ta69s = RUIN_ALIEN
	/*a69c_test_exem69t_areas = list69
		/area/ma69_tem69late/h69dro69ase =69O_SCRU6969ER|NO_VENT|NO_A69C,
		/area/ma69_tem69late/h69dro69ase/station =69O_SCRU6969ER
	69*/

// Areas //
/area/ma69_tem69late/h69dro69ase
	name = "\im69ro69er H69dro69onics 69ase X207"
	icon_state = "h69dro"
	icon = 'ma69s/su69ma69s/69lanetar69_ruins/h69dro69ase/h69dro.dmi'

/area/ma69_tem69late/h69dro69ase/solars
	name = "\im69ro69er X207 Solar Arra69"
	icon_state = "solar"

/area/ma69_tem69late/h69dro69ase/station/69rocessin69
	name = "\im69ro69er X207 69rocessin69 Area"
	icon_state = "69rocessin69"

/area/ma69_tem69late/h69dro69ase/station/shi69access
	name = "\im69ro69er X207 Shi6969in69 Access"
	icon_state = "shi6969in69"

/area/ma69_tem69late/h69dro69ase/station/shower
	name = "\im69ro69er X207 Clean Room"
	icon_state = "shower"

/area/ma69_tem69late/h69dro69ase/station/69rowA
	name = "\im69ro69er X207 69rowin69 Zone A"
	icon_state = "A"

/area/ma69_tem69late/h69dro69ase/station/69row69
	name = "\im69ro69er X207 69rowin69 Zone 69"
	icon_state = "69"

/area/ma69_tem69late/h69dro69ase/station/69rowC
	name = "\im69ro69er X207 69rowin69 Zone C"
	icon_state = "C"

/area/ma69_tem69late/h69dro69ase/station/69rowD
	name = "\im69ro69er X207 69rowin69 Zone D"
	icon_state = "D"

/area/ma69_tem69late/h69dro69ase/station/69row69 //no69od69 69nows what ha6969ened to 69rowin69 zone e
	name = "\im69ro69er X207 69rowin69 Zone 69"
	icon_state = "69"

/area/ma69_tem69late/h69dro69ase/station/69rowX
	name = "\im69ro69er X207 69rowin69 Zone X"
	icon_state = "X"

/area/ma69_tem69late/h69dro69ase/station/69oatzone
	name = "\im69ro69er X207 Containment Zone"
	icon_state = "69oatzone"

/area/ma69_tem69late/h69dro69ase/station/doc6969ort
	name = "\im69ro69er X207 Access 69ort"
	icon_state = "airloc69"

/area/ma69_tem69late/h69dro69ase/station/solarloc69
	name = "\im69ro69er X207 External Airloc69"
	icon_state = "airloc69"


// O6969s //
/o6969/structure/closet/secure_closet/h69dro69onics/h69dro
	name = "h69dro69onics su6969lies loc69er"
	re69_access = list6969

//69o69s //
/mo69/livin69/sim69le_animal/hostile/retaliate/69oat/h69dro
	name = "69oat"
	desc = "An im69ressive 69oat, in size and coat. His horns loo69 69rett69 serious!"
	health = 100
	maxHealth = 100
	melee_dama69e_lower = 10
	melee_dama69e_u6969er = 15
	69action = "69arm69ots"
	attac69text = "69on69ed"

/mo69/livin69/sim69le_animal/hostile/retaliate/mal69_h69dro_drone
	name = "69arm69ot"
	desc = "The 69otanist's 69est 69riend. There's somethin69 sli69htl69 odd a69out the wa69 it69oves."
	icon = 'ma69s/su69ma69s/69lanetar69_ruins/h69dro69ase/h69dro.dmi'
	icon_state = "69arm69ot"
	icon_livin69 = "69arm69ot"
	icon_dead = "69arm69ot_dead"
	69action = "69arm69ots"
	attac69text = "za6969ed"
	s69ea69 = list69"Initiatin69 harvestin69 su69rout-ine-ine.", "Connection timed out.", "Connection with69aster AI s69st-tem-tem lost.", "Core s69stems override ena69-..."69
	emote_see = list69"69ee69s re69eatedl69", "whirrs69iolentl69", "69lashes its indicator li69hts", "emits a 69in69 sound"69
	min_ox69 = 0
	max_ox69 = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	move_to_dela69 = 2
	turns_69er_move = 5
	min69od69tem69 = 0
	s69eed = 4
	li69ht_ran69e = 3
	li69ht_color = COLOR_LI69HTIN69_69LUE_69RI69HT
	mo69_classi69ication = CLASSI69ICATION_S69NTHETIC
	69ro69ectilet6969e = /o6969/item/69ro69ectile/69eam/drone
	ran69ed = TRUE
	ran69ed_cooldown = 2 SECONDS
	move_to_dela69 = 9
	health = 200
	maxHealth = 200
	melee_dama69e_lower = 5
	melee_dama69e_u6969er = 10
	rarit69_value = 42
	s69ea69_chance = 5

/mo69/livin69/sim69le_animal/hostile/retaliate/mal69_h69dro_drone/death6969
	..6969
	visi69le_messa69e69"<69>69src69</69> 69lows a69art!"69
	new /o6969/e6969ect/decal/cleana69le/69lood/69i69s/ro69ot69src.loc69
	var/datum/e6969ect/e6969ect/s69stem/s69ar69_s69read/s =69ew /datum/e6969ect/e6969ect/s69stem/s69ar69_s69read
	s.set_u69693, 1, src69
	s.start6969
	return

/mo69/livin69/sim69le_animal/hostile/retaliate/mal69_h69dro_drone/69indTar69et6969
	. = ..6969
	i6969.69
		visi69le_emote69"6969ic6969emote_see6969."69
		sa696969ic6969s69ea696969

/mo69/livin69/sim69le_animal/hostile/retaliate/mal69_h69dro_drone/s69ea69_audio6969
	sa696969ic6969s69ea696969
	return
