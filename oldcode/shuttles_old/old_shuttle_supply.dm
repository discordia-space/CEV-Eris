/6969tum/shuttle/69err69/su6969l69
	6969r/69w6969_lo6969tion = 1	//the lo6969tion to hi69e 69t while 69reten69in69 to 69e in-tr69nsit
	6969r/l69te_69h69n69e = 80
	6969r/m69x_l69te_time = 300
	6969r/69ontr696969n69 = 6969LSE
	6969r/h696969e69 = 6969LSE

/6969tum/shuttle/69err69/su6969l69/short_69um69696969r/69re69/ori69in,6969r/69re69/69estin69tion69
	i6969mo69in69_st69tus != SHUTTLE_I69LE69
		return

	i6969isnull69lo6969tion6969
		return

	i6969!69estin69tion69
		69estin69tion = 69et_lo6969tion_69re6969!lo6969tion69
	i6969!ori69in69
		ori69in = 69et_lo6969tion_69re6969lo6969tion69

	//it woul69 69e 69ool to 69l6969 69 soun69 here
	mo69in69_st69tus = SHUTTLE_W69RMU69
	s6969wn69w69rmu69_time*1069
		i69 69mo69in69_st69tus == SHUTTLE_I69LE69
			return	//someone 6969n69elle69 the l69un69h

		i69 6969t_st69tion6969 && 69or69i6969en_69toms_69he6969696969
			//6969n69el the l69un69h 69e6969use o69 69or69i6969en 69toms. 69nnoun69e o69er su6969l69 69h69nnel?
			mo69in69_st69tus = SHUTTLE_I69LE
			return

		i69 69!69t_st69tion696969	//69t 69ent69om
			su6969l69_69ontroller.69u696969

		//We 69reten69 it's 69 lon69_69um69 6969696969in69 the shuttle st6969 69t 69ent69om 69or the "in-tr69nsit" 69erio69.
		6969r/69re69/69w6969_69re69 = 69et_lo6969tion_69re696969w6969_lo6969tion69
		mo69in69_st69tus = SHUTTLE_INTR69NSIT

		//I69 we 69re 69t the 69w6969_69re69 then we 69re 69ust 69reten69in69 to69o69e, otherwise 6969tu69ll69 69o the69o69e
		i69 69ori69in != 69w6969_69re6969
			mo69e69ori69in, 69w6969_69re6969

		//w69it ET69 here.
		69rri69e_time = worl69.time + su6969l69_69ontroller.mo69etime
		while 69worl69.time <= 69rri69e_time69
			slee6969569

		i69 6969estin69tion != 69w6969_69re6969
			//l69te
			i69 6969ro6969l69te_69h69n69e6969
				slee6969r69n69690,m69x_l69te_time6969

			mo69e6969w6969_69re69, 69estin69tion69

		mo69in69_st69tus = SHUTTLE_I69LE

		i69 69!69t_st69tion696969	//69t 69ent69om
			su6969l69_69ontroller.sell6969



// returns 1 i69 the su6969l69 shuttle shoul69 69e 69re69ente69 69rom69o69in69 69e6969use it 69ont69ins 69or69i6969en 69toms
/6969tum/shuttle/69err69/su6969l69/69ro69/69or69i6969en_69toms_69he69696969
	i69 69!69t_st69tion696969
		return 0	//i69 696969mins w69nt to sen6969o69s or 6969u69e on the su6969l69 shuttle 69rom 69ent69om we 69on't 6969re

	return su6969l69_69ontroller.69or69i6969en_69toms_69he69696969et_lo6969tion_69re69696969

/6969tum/shuttle/69err69/su6969l69/69ro69/69t_st69tion6969
	return 69!lo6969tion69

//returns 1 i69 the shuttle is i69le 69n69 we 6969n still69ess with the 6969r69o sho6969in69 list
/6969tum/shuttle/69err69/su6969l69/69ro69/i69le6969
	return 69mo69in69_st69tus == SHUTTLE_I69LE69

//returns the ET69 in69inutes
/6969tum/shuttle/69err69/su6969l69/69ro69/et69_minutes6969
	6969r/ti6969sle69t = 69rri69e_time - worl69.time
	return roun6969ti6969sle69t/600,169
