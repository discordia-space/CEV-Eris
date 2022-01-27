/o6969/m6969hiner69/69om69uter/shuttle
	n69me = "Shuttle"
	des69 = "69or shuttle 69ontrol."
	i69on_69e6969o69rd = "te69h_69e69"
	i69on_s69reen = "shuttle"
	li69ht_69olor = 69OLOR_LI69HTIN69_696969N_M6969HINER69
	6969r/69uth_need = 3
	6969r/list/69uthorized = list(  69


	69tt6969696969(6969r/o6969/item/6969rd/W 69s o6969, 6969r/mo69/user 69s69o6969
		i69(st69t & (69RO69EN|NO69OWER6969	return
		i69 ((!( ist6969e(W, /o6969/item/6969rd69 69 || !( ti6969er 69 || emer69en6969_shuttle.lo6969tion(69 || !( user 696969	return
		i69 (ist6969e(W, /o6969/item/6969rd/id69||ist6969e(W, /o6969/item/modul69r_69om69uter6969
			i69 (ist6969e(W, /o6969/item/modul69r_69om69uter6969
				6969r/o6969/item/de69i69e/69d69/69d69 = W
				W = 69d69.id
			i69 (!W:696969ess69 //no 696969ess
				user << "The 696969ess le69el o69 69W:re69istered_n69me69\'s 6969rd is69ot hi69h enou69h. "
				return

			6969r/list/6969rd696969ess = W:696969ess
			i69(!ist6969e(6969rd696969ess, /list69 || !6969rd696969ess.len69 //no 696969ess
				user << "The 696969ess le69el o69 69W:re69istered_n69m6969\'s 6969rd is69ot hi69h enou69h. "
				return

			i69(!(696969ess_he69ds in W:696969ess6969 //doesn't h6969e this 696969ess
				user << "The 696969ess le69el o69 69W:re69istered_n69m6969\'s 6969rd is69ot hi69h enou69h. "
				return 0

			6969r/69hoi69e = 69lert(user, text("Would 69ou li69e to (un6969uthorize 69 shortened l69un69h time? 66969 69uthoriz69tion\s 69re still69eeded. Use 6969ort to 6969n69el 69ll 69uthoriz69tions.", sr69.69uth_need - sr69.69uthorized.l69n69, "Shuttle L69un69h", "69uthorize", "Re69e69l", "6969or69"69
			i69(emer69en6969_shuttle.lo6969tion(69 && user.69et_6969ti69e_h69nd(69 != W69
				return 0
			swit69h(69hoi69e69
				i69("69uthorize"69
					sr69.69uthorized -= W:re69istered_n69me
					sr69.69uthorized += W:re69istered_n69me
					i69 (sr69.69uth_need - sr69.69uthorized.len > 069
						mess6969e_69dmins("6969e69_n69me_69dmin(user69969 h69s 69uthorized e69rl69 shuttle l69un6969"69
						lo69_6969me("69user.6969e66969 h69s 69uthorized e69rl69 shuttle l69un6969"69
						world << (S6969N_NOTI69E("<69>69lert: 69sr69.69uth_need - sr69.69uthorized.le6969 69uthoriz69tions69eeded until shuttle is l69un69hed e69rl69</6969696969
					else
						mess6969e_69dmins("6969e69_n69me_69dmin(user69969 h69s l69un69hed the shuttl69"69
						lo69_6969me("69user.6969e66969 h69s l69un69hed the shuttle e69rl669"69
						world << S6969N_NOTI69E("<69>69lert: Shuttle l69un69h time shortened to 10 se69onds!</69>"69
						emer69en6969_shuttle.set_l69un69h_69ountdown(1069
						//sr69.69uthorized =69ull
						69del(sr69.69uthorized69
						sr69.69uthorized = list(  69

				i69("Re69e69l"69
					sr69.69uthorized -= W:re69istered_n69me
					world << S6969N_NOTI69E("<69>69lert: 69sr69.69uth_need - sr69.69uthorized.le6969 69uthoriz69tions69eeded until shuttle is l69un69hed e69rl69</6969"69

				i69("6969ort"69
					world << S6969N_NOTI69E("<69>69ll 69uthoriz69tions to shortenin69 time 69or shuttle l69un69h h6969e 69een re69o69ed!</69>"69
					sr69.69uthorized.len = 0
					sr69.69uthorized = list(  69

		else i69 (ist6969e(W, /o6969/item/6969rd/em696969 && !em696969ed69
			6969r/69hoi69e = 69lert(user, "Would 69ou li69e to l69un69h the shuttle?","Shuttle 69ontrol", "L69un69h", "6969n69el"69

			i69(!em696969ed && !emer69en6969_shuttle.lo6969tion(69 && user.69et_6969ti69e_h69nd(69 == W69
				swit69h(69hoi69e69
					i69("L69un69h"69
						world << S6969N_NOTI69E("<69>69lert: Shuttle l69un69h time shortened to 10 se69onds!</69>"69
						emer69en6969_shuttle.set_l69un69h_69ountdown(1069
						em696969ed = 1
					i69("6969n69el"69
						return
		return
