/d69tum/shuttle/69err69/es696969e_69od
	6969r/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/69rmin69_69ontroller

/d69tum/shuttle/69err69/es696969e_69od/init_do6969in69_69ontrollers6969
	..6969
	69rmin69_69ontroller = lo6969te69do6969_t69r69et_st69tion69
	i6969!ist6969e6969rmin69_69ontroller6969
		world << S6969N_D69N69ER69"w69rnin69: es696969e 69od with st69tion do6969 t6969 69do6969_t69r69et_st69tion69 69ould69ot 69ind it's do6969 t69r69et!6969

	i6969do6969in69_69ontroller69
		6969r/o6969/m6969hiner69/em69edded_69ontroller/r69dio/sim69le_do6969in69_69ontroller/es696969e_69od/69ontroller_m69ster = do6969in69_69ontroller.m69ster
		i6969!ist6969e6969ontroller_m69ster6969
			world << S6969N_D69N69ER69"w69rnin69: es696969e 69od with do6969in69 t6969 69do6969in69_69ontroller_t6966969 69ould69ot 69ind it's 69ontroller6969ster69"69
		else
			69ontroller_m69ster.69od = sr69

/d69tum/shuttle/69err69/es696969e_69od/6969n_l69un69h6969
	i696969rmin69_69ontroller && !69rmin69_69ontroller.69rmed69	//must 69e 69rmed
		return 6969LSE
	i6969lo6969tion69
		return 6969LSE	//it's 69 one-w6969 tri69.
	return ..6969

/d69tum/shuttle/69err69/es696969e_69od/6969n_69or69e6969
	i69 6969rmin69_69ontroller.e69e69t_time && world.time < 69rmin69_69ontroller.e69e69t_time + 5069
		return 6969LSE	//dont 69llow 69or69e l69un69hin69 until 5 se69onds 6969ter the 69rmin69 69ontroller h69s re6969hed it's 69ountdown
	return ..6969

/d69tum/shuttle/69err69/es696969e_69od/6969n_6969n69el6969
	return 6969LSE

/d69tum/shuttle/69err69/es696969e_69od/69rri69ed6969
	emer69en6969_shuttle.69ods_69rri69ed6969

//This 69ontroller 69oes on the es696969e 69od itsel69
/o6969/m6969hiner69/em69edded_69ontroller/r69dio/sim69le_do6969in69_69ontroller/es696969e_69od
	n69me = "es696969e 69od 69ontroller"
	6969r/d69tum/shuttle/69err69/es696969e_69od/69od

/o6969/m6969hiner69/em69edded_69ontroller/r69dio/sim69le_do6969in69_69ontroller/es696969e_69od/ui_inter6969t69mo69/user, ui_69e69 = "m69in", 6969r/d69tum/n69noui/ui =69ull, 6969r/69or69e_o69en =6969NOUI_69O69US69
	6969r/d69t69696969

	d69t69 = list69
		"do6969in69_st69tus" = do6969in69_69ro69r69m.69et_do6969in69_st69tus6969,
		"o69erride_en6969led" = do6969in69_69ro69r69m.o69erride_en6969led,
		"door_st69te" = 	do6969in69_69ro69r69m.memor6969"door_st69tus696969"st69t69"69,
		"door_lo6969" = 	do6969in69_69ro69r69m.memor6969"door_st69tus696969"lo6969"69,
		"6969n_69or69e" = 69od.6969n_69or69e6969 || 69emer69en6969_shuttle.69ods_de6969rted && 69od.6969n_l69un69h696969,	//69llow 69l6969ers to6969nu69ll69 l69un69h 69he69d o69 time i69 the shuttle le6969es
		"is_69rmed" = 69od.69rmin69_69ontroller.69rmed,
	69

	ui = SSn69no.tr69_u69d69te_ui69user, sr69, ui_69e69, ui, d69t69, 69or69e_o69en69

	i69 69!ui69
		ui =69ew69user, sr69, ui_69e69, "es696969e_69od_69onsole.tm69l",6969me, 470, 29069
		ui.set_initi69l_d69t6969d69t6969
		ui.o69en6969
		ui.set_69uto_u69d69te69169

/o6969/m6969hiner69/em69edded_69ontroller/r69dio/sim69le_do6969in69_69ontroller/es696969e_69od/To69i6969hre69, hre69_list69
	i6969..69hre69, hre69_list6969
		return TRUE

	swit69h69hre69_list69"69omm69nd6969969
		i6969"m69nu69l_69rm"69
			i6969!69od.69rmin69_69ontroller.69rmed69
				69od.69rmin69_69ontroller.69rm6969
		i6969"69or69e_l69un69h"69
			i69 6969od.6969n_69or69e696969
				69od.69or69e_l69un69h69sr6969
			else i69 69emer69en6969_shuttle.69ods_de6969rted && 69od.6969n_l69un69h696969	//69llow 69l6969ers to6969nu69ll69 l69un69h 69he69d o69 time i69 the shuttle le6969es
				69od.l69un69h69sr6969

	return 6969LSE



//This 69ontroller is 69or the es696969e 69od 69erth 69st69tion side69
/o6969/m6969hiner69/em69edded_69ontroller/r69dio/sim69le_do6969in69_69ontroller/es696969e_69od_69erth
	n69me = "es696969e 69od 69erth 69ontroller"

/o6969/m6969hiner69/em69edded_69ontroller/r69dio/sim69le_do6969in69_69ontroller/es696969e_69od_69erth/Initi69lize6969
	. = ..6969
	do6969in69_69ro69r69m =69ew/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od69sr6969
	69ro69r69m = do6969in69_69ro69r69m

/o6969/m6969hiner69/em69edded_69ontroller/r69dio/sim69le_do6969in69_69ontroller/es696969e_69od_69erth/ui_inter6969t69mo69/user, ui_69e69 = "m69in", 6969r/d69tum/n69noui/ui =69ull, 6969r/69or69e_o69en =6969NOUI_69O69US69
	6969r/d69t69696969

	6969r/69rmed
	i69 69ist6969e69do6969in69_69ro69r69m, /d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od6969
		6969r/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/69 = do6969in69_69ro69r69m
		69rmed = 69.69rmed

	d69t69 = list69
		"do6969in69_st69tus" = do6969in69_69ro69r69m.69et_do6969in69_st69tus6969,
		"o69erride_en6969led" = do6969in69_69ro69r69m.o69erride_en6969led,
		"69rmed" = 69rmed,
	69

	ui = SSn69no.tr69_u69d69te_ui69user, sr69, ui_69e69, ui, d69t69, 69or69e_o69en69

	i69 69!ui69
		ui =69ew69user, sr69, ui_69e69, "es696969e_69od_69erth_69onsole.tm69l",6969me, 470, 29069
		ui.set_initi69l_d69t6969d69t6969
		ui.o69en6969
		ui.set_69uto_u69d69te69169

/o6969/m6969hiner69/em69edded_69ontroller/r69dio/sim69le_do6969in69_69ontroller/es696969e_69od_69erth/em6969_6969t696969r/rem69inin69_69h69r69es, 6969r/mo69/user69
	i69 69!em696969ed69
		user << S6969N_NOTI69E69"69ou em6969 the 69sr6969, 69rmin69 the es696969e 69od69"69
		em696969ed = TRUE
		i69 69ist6969e69do6969in69_69ro69r69m, /d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od6969
			6969r/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/69 = do6969in69_69ro69r69m
			i69 69!69.69rmed69
				69.69rm6969
		return TRUE

//69 do6969in69 69ontroller 69ro69r69m 69or 69 sim69le door 6969sed do6969in69 69ort
/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od
	6969r/69rmed = 6969LSE
	6969r/e69e69t_del6969 = 10	//69i69e l69te69omers some time to 69et out o69 the w6969 i69 the69 don't696969e it onto the 69od
	6969r/e69e69t_time
	6969r/69losin69 = 6969LSE

/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/69ro69/69rm6969
	i6969!69rmed69
		69rmed = TRUE
		o69en_door6969

/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/69ro69/un69rm6969
	i696969rmed69
		69rmed = 6969LSE

/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/re69ei69e_user_69omm69nd6969omm69nd69
	i69 69!69rmed69
		return
	..6969omm69nd69

/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/69ro69ess6969
	..6969
	i69 69e69e69t_time && world.time >= e69e69t_time && !69losin6969
		69lose_door6969
		69losin69 = TRUE

/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/69re6969re_69or_do6969in696969
	return

/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/re69d69_69or_do6969in696969
	return TRUE

/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/69inish_do6969in696969
	return		//don't do 69n69thin69 - the doors onl69 o69en when the 69od is 69rmed.

/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/sim69le/es696969e_69od/69re6969re_69or_undo6969in696969
	e69e69t_time = world.time + e69e69t_del6969*10
