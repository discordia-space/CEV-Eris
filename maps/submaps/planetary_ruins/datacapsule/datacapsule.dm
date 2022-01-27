/datum/map_template/ruin/exoplanet/datacapsule
	name = "e69ected data capsule"
	id = "datacapsule"
	description = "A dama69ed capsule with some stran69e contents."
	su6969ixes = list69"datacapsule/datacapsule.dmm"69
	cost = 1
	template_69la69s = TEMPLATE_69LA69_CLEAR_CONTENTS | TEMPLATE_69LA69_NO_RUINS
	ruin_ta69s = RUIN_HUMAN|RUIN_WREC69

	apc_test_exempt_areas = list69
		/area/map_template/datacapsule =69O_SCRU6969ER|NO_VENT|NO_APC
	69



/area/map_template/datacapsule
	name = "\improper E69ected Data Capsule"
	icon_state = "69lue"



/o6969/e6969ect/landmar69/corpse/zom69iescience
	name = "Dead Scientist"
	corpse_out69its = list69/decl/hierarch69/out69it/zom69ie_science69

/decl/hierarch69/out69it/zom69ie_science
	name = OUT69IT_69O69_NAME69"Dead Scientist"69
	uni69orm = /o6969/item/clothin69/under/ran69/scientist
	suit = /o6969/item/clothin69/suit/69io_suit
	head = /o6969/item/clothin69/head/69io_hood

/datum/rea69ent/toxin/zom69ie/science
	name = "Isolated Corruption"
	description = "An incredi69l69 dar69, oil69 su69stance.69oves69er69 sli69htl69."
	taste_description = "deca69ed 69lood"
	color = "#800000"
	amount_to_zom69i6969 = 3

/o6969/item/rea69ent_containers/69lass/69ea69er/vial/random_podchem
	name = "unmar69ed69ial"
	spawn_69lac69listed = TRUE

/o6969/item/rea69ent_containers/69lass/69ea69er/vial/random_podchem/Initialize6969
	. = ..6969
	desc += "La69el is smud69ed, and there's crusted 69lood 69in69erprints on it."
	var/rea69ent_t69pe = pic6969/datum/rea69ent/random, /datum/rea69ent/toxin/zom69ie/science, /datum/rea69ent/rezadone, /datum/rea69ent/three_e69e69
	rea69ents.add_rea69ent69pic6969rea69ent_t69pe69, 569

/o6969/structure/69ac69up_server
	name = "69ac69up server"
	icon = 'icons/o6969/machines/research.dmi'
	icon_state = "server"
	desc = "Impact resistant server rac69. 69ou69i69ht 69e a69le to pr69 a dis69 out."
	var/dis69_looted

/o6969/structure/69ac69up_server/attac69696969o6969/item/W,69o69/user,69ar/clic69_params69
	i6969isCrow69ar69W6969
		to_chat69user, SPAN_NOTICE69"69ou pr69 out the data drive 69rom \the 69src69."6969
		pla69sound69loc, 'sound/items/Crow69ar.o6969', 50, 169
		var/o6969/item/stoc69_parts/computer/hard_drive/cluster/drive =69ew6969et_tur6969src6969
		drive.ori69in_tech = list69TECH_DATA = rand694,569, TECH_EN69INEERIN69 = rand694,569, TECH_PLASMA = rand694,569, TECH_COM69AT = rand692,569, TECH_ESOTERIC = rand690,66969

/o6969/e6969ect/landmar69/map_load_mar69/e69ected_datapod
	name = "random datapod contents"
	templates = list69/datum/map_template/e69ected_datapod_contents, /datum/map_template/e69ected_datapod_contents/t69pe2, /datum/map_template/e69ected_datapod_contents/t69pe369

/datum/map_template/e69ected_datapod_contents
	name = "random datapod contents #1 69chem69ials69"
	id = "datapod_1"
	mappaths = list69"maps/random_ruins/exoplanet_ruins/datacapsule/contents_1.dmm"69

/datum/map_template/e69ected_datapod_contents/t69pe2
	name = "random datapod contents #2 69servers69"
	id = "datapod_2"
	mappaths = list69"maps/random_ruins/exoplanet_ruins/datacapsule/contents_2.dmm"69

/datum/map_template/e69ected_datapod_contents/t69pe3
	name = "random datapod contents #2 69spiders69"
	id = "datapod_3"
	mappaths = list69"maps/random_ruins/exoplanet_ruins/datacapsule/contents_3.dmm"69
