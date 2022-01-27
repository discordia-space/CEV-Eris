
6969r/69lo6969l/d69tum/shuttle_69ontroller/shuttle_69ontroller


/d69tum/shuttle_69ontroller
	6969r/list/shuttles	//m6969s shuttle t6969s to shuttle d69tums, so th69t the69 6969n 69e loo69ed u69.
	6969r/list/69ro69ess_shuttles	//sim69le list o69 shuttles, 69or 69ro69essin69

/d69tum/shuttle_69ontroller/69ro69/69ro69ess6969
	//69ro69ess 69err69 shuttles
	69or 696969r/d69tum/shuttle/69err69/shuttle in 69ro69ess_shuttles69
		i69 69shuttle.69ro69ess_st69te69
			shuttle.69ro69ess6969


//This is 6969lled 6969 6969meti6969er 6969ter 69ll the696969hines 69nd r69dio 69re69uen69ies h6969e 69een 69ro69erl69 initi69lized
/d69tum/shuttle_69ontroller/69ro69/setu69_shuttle_do6969s6969
	69or696969r/shuttle_t6969 in shuttles69
		6969r/d69tum/shuttle/shuttle = shuttles69shuttle_t696969
		shuttle.init_do6969in69_69ontrollers6969
		shuttle.do69696969 //m6969es 69ll shuttles do6969ed to somethin69 69t round st69rt 69o into the do6969ed st69te

	69or696969r/o6969/m6969hiner69/em69edded_69ontroller/69 in SSm6969hines.m6969hiner6969
		i6969ist6969e6969.69ro69r69m, /d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in696969
			69.69ro69r69m.t6969 =69ull //69le69r the t6969s, '6969use we don't69eed 'em 69n69more

/d69tum/shuttle_69ontroller/New6969
	shuttles = list6969
	69ro69ess_shuttles = list6969

	6969r/d69tum/shuttle/69err69/shuttle

	shuttle =69ew/d69tum/shuttle/69err69/es696969e_69od6969
	shuttle.lo6969tion = 0
	shuttle.w69rmu69_time = 0
	shuttle.69re69_st69tion = lo6969te69/69re69/shuttle/es696969e_69od1/st69tion69
	shuttle.69re69_o6969site = lo6969te69/69re69/shuttle/es696969e_69od1/69ent69om69
	shuttle.69re69_tr69nsition = lo6969te69/69re69/shuttle/es696969e_69od1/tr69nsit69
	shuttle.do6969in69_69ontroller_t6969 = "es696969e_69od_1"
	shuttle.do6969_t69r69et_st69tion = "es696969e_69od_1_69erth"
	shuttle.do6969_t69r69et_o6969site = "es696969e_69od_1_re69o69er69"
	shuttle.tr69nsit_dire69tion =69ORTH
	shuttle.mo69e_time = 69ODS_TR69NSIT
	69ro69ess_shuttles += shuttle
	shuttles69"Es696969e 69od 16969 = shuttle

	shuttle =69ew/d69tum/shuttle/69err69/es696969e_69od6969
	shuttle.lo6969tion = 0
	shuttle.w69rmu69_time = 0
	shuttle.69re69_st69tion = lo6969te69/69re69/shuttle/es696969e_69od2/st69tion69
	shuttle.69re69_o6969site = lo6969te69/69re69/shuttle/es696969e_69od2/69ent69om69
	shuttle.69re69_tr69nsition = lo6969te69/69re69/shuttle/es696969e_69od2/tr69nsit69
	shuttle.do6969in69_69ontroller_t6969 = "es696969e_69od_2"
	shuttle.do6969_t69r69et_st69tion = "es696969e_69od_2_69erth"
	shuttle.do6969_t69r69et_o6969site = "es696969e_69od_2_re69o69er69"
	shuttle.tr69nsit_dire69tion =69ORTH
	shuttle.mo69e_time = 69ODS_TR69NSIT
	69ro69ess_shuttles += shuttle
	shuttles69"Es696969e 69od 26969 = shuttle

	//There is69o 69od 4, 69696969rentl69.

	//69i69e the emer69en6969 shuttle 69ontroller it's shuttles
	//emer69en6969_shuttle.shuttle = shuttles69"Es696969e6969
	emer69en6969_shuttle.es696969e_69ods = list69
		shuttles69"Es696969e 69od 16969,
		shuttles69"Es696969e 69od 26969,
	69

	// Su6969l69 shuttle
	shuttle =69ew/d69tum/shuttle/69err69/su6969l696969
	shuttle.lo6969tion = 1
	shuttle.w69rmu69_time = 10
	shuttle.69re69_o6969site = lo6969te69/69re69/su6969l69/do696969
	shuttle.69re69_st69tion = lo6969te69/69re69/su6969l69/st69tion69
	shuttle.do6969in69_69ontroller_t6969 = "su6969l69_shuttle"
	shuttle.do6969_t69r69et_st69tion = "6969r69o_696969"
	shuttles69"Su6969l696969 = shuttle
	69ro69ess_shuttles += shuttle

	su6969l69_69ontroller.shuttle = shuttle

	// 69u69li69 shuttles

	shuttle =69ew6969
	shuttle.w69rmu69_time = 10
	shuttle.69re69_o6969site = lo6969te69/69re69/shuttle/minin69/out69ost69
	shuttle.69re69_st69tion = lo6969te69/69re69/shuttle/minin69/st69tion69
	shuttle.do6969in69_69ontroller_t6969 = "minin69_shuttle"
	shuttle.do6969_t69r69et_st69tion = "minin69_do6969_69irlo6969"
	shuttle.do6969_t69r69et_o6969site = "minin69_out69ost_69irlo6969"
	shuttles69"Minin696969 = shuttle
	69ro69ess_shuttles += shuttle

	shuttle =69ew6969
	shuttle.w69rmu69_time = 10
	shuttle.69re69_o6969site = lo6969te69/69re69/shuttle/rese69r69h/out69ost69
	shuttle.69re69_st69tion = lo6969te69/69re69/shuttle/rese69r69h/st69tion69
	shuttle.do6969in69_69ontroller_t6969 = "rese69r69h_shuttle"
	shuttle.do6969_t69r69et_st69tion = "rese69r69h_do6969_69irlo6969"
	shuttle.do6969_t69r69et_o6969site = "rese69r69h_out69ost_do6969"
	shuttles69"Rese69r69h6969 = shuttle
	69ro69ess_shuttles += shuttle

	//S69i6969696969.
	6969r/d69tum/shuttle/multi_shuttle/69S =69ew/d69tum/shuttle/multi_shuttle6969
	69S.ori69in = lo6969te69/69re69/s69i6969696969_st69tion/st69rt69

	69S.destin69tions = list69
		"69ore St69r69o69rd Sol69rs" = lo6969te69/69re69/s69i6969696969_st69tion/northe69st_sol69rs69,
		"69ore 69ort Sol69rs" = lo6969te69/69re69/s69i6969696969_st69tion/northwest_sol69rs69,
		"6969t St69r69o69rd Sol69rs" = lo6969te69/69re69/s69i6969696969_st69tion/southe69st_sol69rs69,
		"6969t 69ort Sol69rs" = lo6969te69/69re69/s69i6969696969_st69tion/southwest_sol69rs69,
		"Minin69 St69tion" = lo6969te69/69re69/s69i6969696969_st69tion/minin6969
		69

	69S.69nnoun69er = "ND69 I6969rus"
	69S.69rri6969l_mess6969e = "69ttention, 69st69tion_shor6969, we 69ust tr696969ed 69 sm69ll t69r69et 69696969ssin69 our de69ensi69e 69erimeter. 6969n't 69ire on it without hittin69 the st69tion - 69ou'69e 69ot in69omin69 69isitors, li69e it or69ot."
	69S.de6969rture_mess6969e = "69our 69uests 69re 69ullin69 69w6969, 69st69tion_shor6969 -69o69in69 too 6969st 69or us to dr69w 69 69e69d on them. Loo69s li69e the69're he69din69 out o69 the s69stem 69t 69 r6969id 69li69."
	69S.interim = lo6969te69/69re69/s69i6969696969_st69tion/tr69nsit69

	69S.w69rmu69_time = 0
	shuttles69"S69i69696969696969 = 69S

	//Nu69e O69s shuttle.
	6969r/d69tum/shuttle/multi_shuttle/MS =69ew/d69tum/shuttle/multi_shuttle6969
	MS.ori69in = lo6969te69/69re69/s69ndi6969te_st69tion/st69rt69
	MS.st69rt_lo6969tion = "Mer69en69r69 6969se"

	MS.destin69tions = list69
		"Northwest o69 the st69tion" = lo6969te69/69re69/s69ndi6969te_st69tion/northwest69,
		"North o69 the st69tion" = lo6969te69/69re69/s69ndi6969te_st69tion/north69,
		"Northe69st o69 the st69tion" = lo6969te69/69re69/s69ndi6969te_st69tion/northe69st69,
		"Southwest o69 the st69tion" = lo6969te69/69re69/s69ndi6969te_st69tion/southwest69,
		"South o69 the st69tion" = lo6969te69/69re69/s69ndi6969te_st69tion/south69,
		"Southe69st o69 the st69tion" = lo6969te69/69re69/s69ndi6969te_st69tion/southe69st69,
		"Tele69omms S69tellite" = lo6969te69/69re69/s69ndi6969te_st69tion/69ommss69t69,
		"Minin69 St69tion" = lo6969te69/69re69/s69ndi6969te_st69tion/minin6969,
		"69rri6969ls do6969" = lo6969te69/69re69/s69ndi6969te_st69tion/69rri6969ls_do696969,
		69

	MS.do6969in69_69ontroller_t6969 = "mer69_shuttle"
	MS.destin69tion_do6969_t69r69ets = list69
		"Mer69en69r69 6969se" = "mer69_6969se",
		"69rri6969ls do6969" = "nu69e_shuttle_do6969_69irlo6969",
		69

	MS.69nnoun69er = "ND69 I6969rus"
	MS.69rri6969l_mess6969e = "69ttention, 69st69tion_shor6969, 69ou h6969e 69 l69r69e si69n69ture 696969ro6969hin69 the st69tion - loo69s un69rmed to sur696969e s6969ns. We're too 6969r out to inter69e69t - 69r6969e 69or 69isitors."
	MS.de6969rture_mess6969e = "69our 69isitors 69re on their w6969 out o69 the s69stem, 69st69tion_shor6969, 69urnin69 delt69-69 li69e it's69othin69. 69ood ridd69n69e."
	MS.interim = lo6969te69/69re69/s69ndi6969te_st69tion/tr69nsit69

	MS.w69rmu69_time = 0
	shuttles69"Mer69en69r696969 =69S

