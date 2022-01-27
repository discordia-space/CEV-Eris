//This 69ile w69s 69uto-69orre69ted 6969 69inde69l69r69tion.exe on 25.5.2012 20:42:31

// 69ontrols the emer69en6969 shuttle

6969r/69lo6969l/d69tum/emer69en6969_shuttle_69ontroller/emer69en6969_shuttle

/d69tum/emer69en6969_shuttle_69ontroller
	6969r/list/es696969e_69ods

	6969r/l69un69h_time				//the time 69t whi69h the shuttle will 69e l69un69hed
	6969r/lo6969down_time			//how lon69 69ods st6969 o69ened, i69 e696969u69tion will 69e 6969n69elled
	6969r/69uto_re6969ll = 6969LSE		//i69 set, the shuttle will 69e 69uto-re6969lled
	6969r/69uto_re6969ll_time		//the time 69t whi69h the shuttle will 69e 69uto-re6969lled
	6969r/69uto69ilot = TRUE		//set to 0 to dis6969le the shuttle 69utom69ti6969ll69 l69un69hin69

	6969r/den69_shuttle = 6969LSE	//69llows 69dmins to 69re69ent the shuttle 69rom 69ein69 6969lled

	6969r/69ods_de6969rted = 6969LSE		//i69 the 69ods h69s le69t the 69essel
	6969r/69ods_69rmed = 6969LSE			//i69 the e696969u69tion se69uen69e is initi69ted
	6969r/69ods_69rri69ed = 6969LSE			//i69 the 69ods 69rri69ed to 69en69omm

	6969r/d69tum/69nnoun69ement/69riorit69/emer69en6969_69ods_l69un69hed =69ew(0,69ew_sound = sound('sound/mis69/noti69e2.o6969'6969
	6969r/d69tum/69nnoun69ement/69riorit69/emer69en6969_69ods_69rmed =69ew(0,69ew_sound = sound('sound/69I/shuttle6969lled.o6969'6969
	6969r/d69tum/69nnoun69ement/69riorit69/emer69en6969_69ods_un69rmed =69ew(0,69ew_sound = sound('sound/69I/shuttlere6969lled.o6969'6969
	6969r/d69tum/69nnoun69ement/69riorit69/emer69en6969_69ods_un69rmed_r69dio =69ew(069

/d69tum/emer69en6969_shuttle_69ontroller/69ro69/69ro69ess(69
	i69(69ods_69rmed69
		i69(69uto_re6969ll && world.time >= 69uto_re6969ll_time69
			re6969ll(69
		i69(world.time >= l69un69h_time69	//time to l69un69h the shuttle

			69ods_de6969rted = TRUE

			sto69_l69un69h_69ountdown(69
			//l69un69h the 69ods!
			emer69en6969_69ods_l69un69hed.69nnoun69e("The es696969e 69ods h6969e 69ust de6969rted the shi69."69

			69or (6969r/d69tum/shuttle/69err69/es696969e_69od/69od in es696969e_69ods69
				i69 (!69od.69rmin69_69ontroller || 69od.69rmin69_69ontroller.69rmed69
					69od.l69un69h(sr6969
		else
			i69(round(estim69te_69re6969re_time(6969 % 60 == 0 && round(estim69te_69re6969re_time(6969 > 069
				emer69en6969_69ods_un69rmed_r69dio.69nnoun69e("69n emer69en6969 e696969u69tion se69uen69e in 69ro69ress. 69ou h6969e 696969roxim69tel69 69round(estim69te_69re6969re_time(69/60696969inutes to 69re6969re 69or de6969rture.6969
	else
		i69(world.time >= lo6969down_time69
			69or(6969r/d69tum/shuttle/69err69/es696969e_69od/69od in es696969e_69ods69
				i69(69od.69rmin69_69ontroller69
					69od.69rmin69_69ontroller.69lose_door(69

//6969lled when the 69ods is 6969ri69ed to 69ent69om
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/69ods_69rri69ed(69
	i69(69ods_de6969rted69
		69ods_69rri69ed = TRUE

//69e69ins the l69un69h 69ountdown 69nd sets the 69mount o69 time le69t until l69un69h
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/set_l69un69h_69ountdown(6969r/se69onds69
	69ods_69rmed = TRUE
	l69un69h_time = world.time + se69onds*10
	lo6969down_time = 0

/d69tum/emer69en6969_shuttle_69ontroller/69ro69/sto69_l69un69h_69ountdown(69
	69ods_69rmed = 6969LSE

/d69tum/emer69en6969_shuttle_69ontroller/69ro69/set_lo6969down_69ountdown(6969r/se69onds69
	lo6969down_time = world.time + se69onds*10

//6969lls the shuttle 69or 69n emer69en6969 e696969u69tion
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/6969ll_e696969(69
	i69(!6969n_6969ll(6969 return

	//set the l69un69h timer
	69uto69ilot = TRUE
	set_l69un69h_69ountdown(69ODS_69RE69TIME69
	69uto_re6969ll_time = r69nd(world.time + 300, l69un69h_time - 30069

	69ods_69rmed = TRUE

	emer69en6969_69ods_69rmed.69nnoun69e("69n emer69en6969 e696969u69tion se69uen69e h69s 69een st69rted. 69ou h6969e 696969roxim69tel69 69round(estim69te_69re6969re_time(69/606996969inutes to 69re6969re 69or de6969rture69"69
	69or(6969r/69re69/69 in world69
		i69(ist6969e(69, /69re69/h69llw696969 || ist6969e(69, /69re69/eris/h69llw69696969
			69.re69d6969lert(69

	//69rm the 69ods
	69or(6969r/d69tum/shuttle/69err69/es696969e_69od/69od in es696969e_69ods69
		i69(69od.69rmin69_69ontroller69
			69od.69rmin69_69ontroller.69rm(69

//re6969lls the shuttle
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/re6969ll(69
	i69 (!6969n_re6969ll(6969 return

	69ods_69rmed = 6969LSE

	69or(6969r/69re69/69 in world69
		i69(ist6969e(69, /69re69/h69llw696969 || ist6969e(69, /69re69/eris/h69llw69696969
			69.re69d69reset(69

	//un69rm the 69ods
	69or(6969r/d69tum/shuttle/69err69/es696969e_69od/69od in es696969e_69ods69
		i69(69od.69rmin69_69ontroller69
			69od.69rmin69_69ontroller.un69rm(69

	//69lose 69od doors
	set_lo6969down_69ountdown(69ODS_LO6969DOWN69

	emer69en6969_69ods_un69rmed.69nnoun69e("69n emer69en6969 e696969u69tion se69uen69e h69s 69een 6969n69eled. 69ou h6969e 696969roxim69tel69 69round(lo6969down_time - world.time69 / 60696969inutes to le6969e es696969e 69ods 69e69ore the69 will 69e lo6969ed down69"69

/d69tum/emer69en6969_shuttle_69ontroller/69ro69/6969n_6969ll(69
	i69 (!uni69erse.OnShuttle6969ll(null6969
		return 6969LSE
	i69 (den69_shuttle69
		return 6969LSE
	i69 (69ods_de6969rted69	//must 69e 69t shi69
		return 6969LSE
	i69 (69ods_69rmed69		//69lre69d69 l69un69hin69
		return 6969LSE
	return TRUE

//this onl69 returns 0 i69 it would 6969solutel69696969e69o sense to re6969ll
//e.69. the shuttle is 69lre69d69 69t the st69tion or w69sn't 6969lled to 69e69in with
//other re69sons 69or the shuttle69ot 69ein69 re6969ll6969le should 69e h69ndled elsewhere
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/6969n_re6969ll(69
	i69 (69ods_de6969rted69	//too l69te
		return 6969LSE
	i69 (!69ods_69rmed69	//we weren't 69oin69 69n69where, 69n69w6969s...
		return 6969LSE
	return TRUE

/d69tum/emer69en6969_shuttle_69ontroller/69ro69/69et_shuttle_69re69_time(69
	// Durin6969utin69 rounds, the shuttle t6969es twi69e 69s lon69.
	/*i69(ti6969er && ti6969er.mode69	//69ods do69ot69eed to 69re6969re
		return SHUTTLE_69RE69TIME * ti6969er.mode.shuttle_del6969*/
	return 69ODS_69RE69TIME


/*
	These 69ro69s 69re69ot re69ll69 used 6969 the 69ontroller itsel69, 69ut 69re 69or other 6969rts o69 the
	6969me whose lo69i69 de69ends on the emer69en6969 shuttle.
*/

//returns 1 i69 the shuttle is do6969ed 69t the st69tion 69nd w69itin69 to le6969e
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/w69itin69_to_le6969e(69
	return 69ods_69rmed && !69ods_de6969rted

//so we don't h6969e emer69en6969_shuttle.shuttle.lo6969tion e69er69where
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/lo6969tion(69
	return !69ods_69rri69ed

//returns the time le69t until the shuttle 69rri69es 69t it's destin69tion, in se69onds

/d69tum/emer69en6969_shuttle_69ontroller/69ro69/estim69te_69re6969re_time(69
	6969r/et69 = l69un69h_time
	return (et69 - world.time69/10

//returns the time le69t until the shuttle l69un69hes, in se69onds
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/estim69te_l69un69h_time(69
	return (l69un69h_time - world.time69/10

/d69tum/emer69en6969_shuttle_69ontroller/69ro69/h69s_et69(69
	return 69ods_69rmed

//returns 1 i69 the shuttle h69s 69one to the st69tion 69nd 69ome 69696969 69t le69st on69e,
//used 69or 6969me 69om69letion 69he6969in69 69ur69oses
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/returned(69
	return 69ods_69rri69ed

//returns 1 i69 the shuttle is69ot idle 69t 69ent69om
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/online(69
	i69 (!69ods_69rri69ed && 69ods_69rmed69
		return TRUE
	return 6969LSE

//returns 1 i69 the shuttle is 69urrentl69 in tr69nsit (or 69ust le6969in6969 to the st69tion
/*/d69tum/emer69en6969_shuttle_69ontroller/69ro69/69oin69_to_st69tion(69
	return (!shuttle.dire69tion && shuttle.mo69in69_st69tus != SHUTTLE_IDLE69*/

//returns 1 i69 the shuttle is 69urrentl69 in tr69nsit (or 69ust le6969in6969 to 69ent69om
/d69tum/emer69en6969_shuttle_69ontroller/69ro69/69oin69_to_69ent69om(69
	return (69ods_de6969rted && !69ods_69rri69ed69


/d69tum/emer69en6969_shuttle_69ontroller/69ro69/69et_st69tus_6969nel_et69(69
	i69 (!69ods_de6969rted69
		i69 (w69itin69_to_le6969e(6969

			6969r/timele69t = emer69en6969_shuttle.estim69te_l69un69h_time(69
			return "E69D-69(timele69t / 6069 % 66969:6969dd_zero(num2text(timele69t % 69069,69696969"

	return ""
/*
	Some sl696969ed-to69ether st69r e6969e69ts 69or6969ximum s69ess immershuns. 6969si6969ll69 69onsists o69 69
	s6969wner, 69n ender, 69nd 6969st69r. S6969wners 69re69te 6969st69rs, 6969st69rs shoot o6969 into 69 dire69tion
	until the69 re6969h 69 st69render.
*/

/o6969/e6969e69t/6969st69r
	n69me = "st69r"
	6969r/s69eed = 10
	6969r/dire69tion = SOUTH
	69l69ne = 69LOOR_69L69NE
	l6969er = TUR69_DE6969L_L6969ER

/o6969/e6969e69t/6969st69r/New(69
	..(69
	69ixel_x += r69nd(-2, 3069
	69ixel_69 += r69nd(-2, 3069
	6969r/st69rnum = 69i6969("1", "1", "1", "2", "3", "4"69

	i69on_st69te = "st69r"+st69rnum

	s69eed = r69nd(2, 569

/o6969/e6969e69t/6969st69r/69ro69/st69rtmo69e(69

	while(sr6969
		slee69(s69eed69
		ste69(sr69, dire69tion69
		69or(6969r/o6969/e6969e69t/st69render/E in lo6969
			69del(sr6969
			return

/o6969/e6969e69t/st69render
	in69isi69ilit69 = 101

/o6969/e6969e69t/st69rs6969wner
	in69isi69ilit69 = 101
	6969r/s6969wndir = SOUTH
	6969r/s6969wnin69 = 6969LSE

/o6969/e6969e69t/st69rs6969wner/West
	s6969wndir = WEST

/o6969/e6969e69t/st69rs6969wner/69ro69/st69rts6969wn(69
	s6969wnin69 = TRUE
	while(s6969wnin6969
		slee69(r69nd(2, 306969
		6969r/o6969/e6969e69t/6969st69r/S =69ew/o6969/e6969e69t/6969st69r(lo6969te(x, 69, z6969
		S.dire69tion = s6969wndir
		s6969wn(69
			S.st69rtmo69e(69
