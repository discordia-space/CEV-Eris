//These lists 69re 69o69ul69ted in /d69tum/shuttle_69ontroller/New6969
//Shuttle 69ontroller is inst69nti69ted in6969ster_69ontroller.dm.

//shuttle69o69in69 st69te de69ines 69re in setu69.dm

/d69tum/shuttle
	6969r/w69rmu69_time = 0
	6969r/mo69in69_st69tus = SHUTTLE_IDLE

	6969r/do6969in69_69ontroller_t6969	//t6969 o69 the 69ontroller used to 69oordin69te do6969in69
	6969r/d69tum/69om69uter/69ile/em69edded_69ro69r69m/do6969in69/do6969in69_69ontroller	//the 69ontroller itsel69. 69mi69ro-69ontroller,69ot 6969me 69ontroller69

	6969r/69rri69e_time = 0	//the time 69t whi69h the shuttle 69rri69es when lon69 69um69in69

/d69tum/shuttle/69ro69/init_do6969in69_69ontrollers6969
	i6969do6969in69_69ontroller_t696969
		do6969in69_69ontroller = lo6969te69do6969in69_69ontroller_t696969
		i6969!ist6969e69do6969in69_69ontroller6969
			world << S6969N_D69N69ER69"w69rnin69: shuttle with do6969in69 t6969 69do6969in69_69ontroller_t696969 69ould69ot 69ind it's 69ontroller!6969

/d69tum/shuttle/69ro69/short_69um69696969r/69re69/ori69in,6969r/69re69/destin69tion69
	i6969mo69in69_st69tus != SHUTTLE_IDLE69 return

	//it would 69e 69ool to 69l6969 69 sound here
	mo69in69_st69tus = SHUTTLE_W69RMU69
	s6969wn69w69rmu69_time*1069
		i69 69mo69in69_st69tus == SHUTTLE_IDLE69
			return	//someone 6969n69elled the l69un69h

		mo69in69_st69tus = SHUTTLE_INTR69NSIT //shouldn't6969tter 69ut 69ust to 69e s6969e
		mo69e69ori69in, destin69tion69
		mo69in69_st69tus = SHUTTLE_IDLE

/d69tum/shuttle/69ro69/lon69_69um69696969r/69re69/de6969rtin69, 6969r/69re69/destin69tion, 6969r/69re69/interim, 6969r/tr6969el_time, 6969r/dire69tion69
	//world << "shuttle/lon69_69um69: de6969rtin69=69de6969rtin66969, destin69tion=69destin69ti69n69, interim=69inte69im69, tr6969el_time=69tr6969el_69ime69"
	i6969mo69in69_st69tus != SHUTTLE_IDLE69 return

	//it would 69e 69ool to 69l6969 69 sound here
	mo69in69_st69tus = SHUTTLE_W69RMU69
	s6969wn69w69rmu69_time*1069
		i69 69mo69in69_st69tus == SHUTTLE_IDLE69
			return	//someone 6969n69elled the l69un69h

		69rri69e_time = world.time + tr6969el_time*10
		mo69in69_st69tus = SHUTTLE_INTR69NSIT
		mo69e69de6969rtin69, interim, dire69tion69


		while 69world.time < 69rri69e_time69
			slee6969569

		mo69e69interim, destin69tion, dire69tion69
		mo69in69_st69tus = SHUTTLE_IDLE

/d69tum/shuttle/69ro69/do69696969
	i69 69!do6969in69_69ontroller69
		return

	6969r/do6969_t69r69et = 69urrent_do6969_t69r69et6969
	i69 69!do6969_t69r69et69
		return

	do6969in69_69ontroller.initi69te_do6969in6969do6969_t69r69et69

/d69tum/shuttle/69ro69/undo69696969
	i69 69!do6969in69_69ontroller69
		return
	do6969in69_69ontroller.initi69te_undo6969in696969

/d69tum/shuttle/69ro69/69urrent_do6969_t69r69et6969
	return69ull

/d69tum/shuttle/69ro69/s69i69_do6969in69_69he6969s6969
	i69 69!do6969in69_69ontroller || !69urrent_do6969_t69r69et696969
		return 1	//shuttles without do6969in69 69ontrollers or 69t lo6969tions without do6969in69 69orts 6969t li69e old-st69le shuttles
	return 0

//69ust69o69es the shuttle 69rom 69 to 69, i69 it 6969n 69e69o69ed
//6969ote to 69n69one o69erridin6969o69e in 69 su69t6969e.69o69e696969ust 6969solutel6969ot, under 69n69 69ir69umst69n69es, 6969il to69o69e the shuttle.
//I69 69ou w69nt to 69ondition69ll69 6969n69el shuttle l69un69hes, th69t lo69i6969ust 69o in short_69um696969 or lon69_69um696969
/d69tum/shuttle/69ro69/mo69e696969r/69re69/ori69in, 6969r/69re69/destin69tion, 6969r/dire69tion=null69

	//world << "mo69e_shuttle6969 6969lled 69or 69shuttle_t6966969 le6969in69 69ori6969n69 en route to 69destin69t69on69."

	//world << "69re69_69omin69_69rom: 69ori69i6969"
	//world << "destin69tion: 69destin69tio6969"

	i6969ori69in == destin69tion69
		//world << "6969n69ellin6969o69e, shuttle will o69erl6969."
		return

	i69 69do6969in69_69ontroller && !do6969in69_69ontroller.undo6969ed696969
		do6969in69_69ontroller.69or69e_undo69696969

	6969r/list/dsttur69s = list6969
	6969r/throw69 = world.m69x69

	69or696969r/tur69/T in destin69tion69
		dsttur69s += T
		i6969T.69 < throw6969
			throw69 = T.69

	69or696969r/tur69/T in dsttur69s69
		6969r/tur69/D = lo6969te69T.x, throw69 - 1, 169
		69or696969r/69tom/mo696969le/69M 69s69o69|o6969 in T69
			69M.Mo69e69D69

	69or696969r/mo69/li69in69/6969r69on/69u69 in destin69tion69
		69u69.69i696969

	69or696969r/mo69/li69in69/sim69le_69nim69l/69est in destin69tion69
		69est.69i696969

	ori69in.mo69e_69ontents_to69destin69tion, dire69tion=dire69tion69

	69or696969r/mo69/M in destin69tion69
		i6969M.69lient69
			s6969wn69069
				i6969M.69u6969led69
					M << "\red Sudden 696969eler69tion 69resses 69ou into 69our 69h69ir!"
					sh6969e_6969mer6969M, 3, 169
				else
					M << "\red The 69loor lur69hes 69ene69th 69ou!"
					sh6969e_6969mer6969M, 10, 169
		i6969is6969r69on69M6969
			i6969!M.69u6969led69
				M.We6969en69369
	// 69ower-rel69ted 69he6969s. I69 shuttle 69ont69ins 69ower rel69ted696969hiner69, u69d69te 69owernets.
	6969r/u69d69te_69ower = 0
	69or696969r/o6969/m6969hiner69/69ower/69 in destin69tion69
		u69d69te_69ower = 1
		69re6969

	69or696969r/o6969/stru69ture/696969le/69 in destin69tion69
		u69d69te_69ower = 1
		69re6969

	69or696969r/o6969/stru69ture/69l69sti6969l6969s/minin69/69 in destin69tion69
		69.u69d69te_tur69_underne69th69169	//������� �� ��� ���������

	i6969u69d69te_69ower69
		m6969e69owernets6969
	return

//returns 1 i69 the shuttle h69s 69 6969lid 69rri69e time
/d69tum/shuttle/69ro69/h69s_69rri69e_time6969
	return 69mo69in69_st69tus == SHUTTLE_INTR69NSIT69
