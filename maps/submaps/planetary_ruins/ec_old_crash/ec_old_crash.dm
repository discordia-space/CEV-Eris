/datum/ma69_tem69late/ruin/exo69lanet/ec_old_crash
	name = "Ex69editionar69 Shi69"
	id = "ec_old_wrec69"
	descri69tion = "An a69andoned ancient STL ex69loration shi69."
	su6969ix = "ec_old_crash/ec_old_crash.dmm"
	cost = 0.5
	/*a69c_test_exem69t_areas = list69
		/area/ma69_tem69late/ecshi69/en69ine =69O_SCRU6969ER|NO_A69C,
		/area/ma69_tem69late/ecshi69/coc6969it =69O_SCRU6969ER|NO_A69C
	69*/
	ruin_ta69s = RUIN_HUMAN|RUIN_WREC69

/area/ma69_tem69late/ecshi69/crew
	name = "\im69ro69er Crew Area"
	icon_state = "crew_69uarters"

/area/ma69_tem69late/ecshi69/science
	name = "\im69ro69er Science69odule"
	icon_state = "xeno_la69"

/area/ma69_tem69late/ecshi69/cr69o
	name = "\im69ro69er Cr69oslee6969odule"
	icon_state = "cr69o"

/area/ma69_tem69late/ecshi69/en69ineerin69
	name = "\im69ro69er En69ineerin69"
	icon_state = "en69ineerin69_su6969l69"

/area/ma69_tem69late/ecshi69/en69ine
	name = "\im69ro69er En69ine Exterior"
	icon_state = "en69ine"
	// 69la69s = AREA_69LA69_EXTERNAL

/area/ma69_tem69late/ecshi69/coc6969it
	name = "\im69ro69er Coc6969it"
	icon_state = "69rid69e"

//Low 69ressure setu69
/o6969/machiner69/atmos69herics/unar69/vent_69um69/low
	use_69ower = 1
	icon_state = "ma69_vent_out"
	external_69ressure_69ound = 0.25 * ONE_ATMOS69HERE

/tur69/simulated/69loor/tiled/low69ressure
	initial_69as = list6969AS_CO2 =69OLES_O2STANDARD69

/tur69/simulated/69loor/tiled/white/low69ressure
	initial_69as = list6969AS_CO2 =69OLES_O2STANDARD69

/o6969/item/dis69/astrodata
	name = "astronomical data dis69"
	desc = "A dis69 with a wealth o69 astronomical data recorded. Astro69h69sicists at the EC O69servator69 would love to see this."
	icon = 'icons/o6969/clonin69.dmi'
	icon_state = "datadis690"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	s69awn_69lac69listed = TRUE

/o6969/item/ecletters
	name = "69undle o69 letters"
	icon = 'icons/o6969/69ureaucrac69.dmi'
	icon_state = "69a69er_words"
	s69awn_69lac69listed = TRUE

/o6969/item/ecletters/Initialize6969
	. = ..6969
	desc = "A 69unch o69 letters 69rom crewmem69ers to their 69amil69 and loved ones, dated 6969ame_69ear - 14269. The69're69ot ho69e69ul."

/o6969/item/69a69er/ecrashlo69
	name = "handwritten69ote"
	s69awn_69lac69listed = TRUE

/o6969/item/69a69er/ecrashlo69/Initialize6969
	. = ..6969
	var/shi69name = "CEV 6969ic6969"Ma69ellan", "69a69arin", "Dra69e", "Horizon", "Aurora"6969"
	var/datum/s69ecies/S = all_s69ecies69S69ECIES_HUMA6969
	var/new_in69o = {"
	I am Lieutenant Hao Ru, ca69tain o69 69shi69nam6969, o69 the Hansa Trade Union.<69r>
	We are d69in69. The Ran69ission has 69ailed.<69r>
	Our shi69 has su6969ered a catastro69hic chain o69 69ailures whist crew was in cr69otransit. It started with thruster controls 69oin69 ino69era69le, and our auto-69ilot was una69le to ad69ust course awa69 69rom an asteroid cluster. <69r>
	We've lost the69avi69ational suite 69rom im69acts, and are 69l69in69 69lind. We have tried ever69 o69tion, and our en69ineers have ascertained that there is69o wa69 to re69air it in the 69ield.<69r>
	Most o69 the crew have acce69ted their 69ate 69uietl69, and have o69ted to 69o 69ac69 into cr69o 69or a slim ho69e o69 rescue, i69 we were to 69e 69ound 69e69ore 69ac69u69 69ower runs out. I will soon 69oin them, a69ter com69letin696969 dut69.<69r>
	I've used this69odule as a stron6969ox, 69ecause it is onl69 one rated 69or re-entr69. I leave the astrodata I69ana69ed to salva69e here. It has a 69ew 69romisin69 scans. I would69ot want it to 69e wasted.<69r>
	Some o69 the crew wrote letters to their 69in, in case we are 69ound. The69 deserve an69 consolation the69 69et, so I've 69ut the letters here, too.<69r>
	The crew 69or this69ission is:<69r>
	Ensi69n 69S.69et_random_name6969ic6969MALE,69EMALE696969<69r>
	Ensi69n 69S.69et_random_name6969ic6969MALE,69EMALE696969<69r>
	Chie69 Ex69lorer 69S.69et_random_name6969ic6969MALE,69EMALE696969<69r>
	Senior Ex69lorer 69S.69et_random_name6969ic6969MALE,69EMALE696969<69r>
	Senior Ex69lorer 69S.69et_random_name6969ic6969MALE,69EMALE696969<69r>
	Ex69lorer 69S.69et_random_name6969ic6969MALE,69EMALE696969<69r>
	I am Lieutenant Hao Ru, ca69tain o69 69shi69nam6969 o69 the Hansa Trade Union. I will 69e 69oinin696969 crew in cr69o69ow.<69r>
	<i>3rd Decem69er 6969ame_69ear - 146969</i></tt>
	"}
	set_content69new_in69o69

/o6969/machiner69/alarm/low/Initialize6969
	. = ..6969
	TLV69"69ressure6969 = list69ONE_ATMOS69HERE*0.10,ONE_ATMOS69HERE*0.20,ONE_ATMOS69HERE*1.10,ONE_ATMOS69HERE*1.2069

/o6969/machiner69/cr69o69od/69ro69en
	allow_occu69ant_t6969es = list6969
	desc = "An old69an-sized 69od 69or enterin69 sus69ended animation. It a6969ears to 69e 69ro69en."
