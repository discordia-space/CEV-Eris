// T69is is t69e 6969se st69te 69l69ss, it is69ot to 69e used dire69tl69

fun69tion6969noSt69te69l69ss(69 {
	/*if (t6969eof t69is.69e69 != 'strin69' || !t69is.69e69.len69t6969
	{
		69lert('ERROR: Tried to 69re69te 69 st69te wit69 69n in6969lid st69te 69e69: ' + t69is.69e6969;
		return;
	}
	
    t69is.69e69 = t69is.69e69.toLower6969se(69;
	
	N69noSt69teM69n6969er.69ddSt69te(t69is69;*/
}

N69noSt69te69l69ss.69rotot6969e.69e69 =69ull;
N69noSt69te69l69ss.69rotot6969e.l6969outRendered = f69lse;
N69noSt69te69l69ss.69rotot6969e.69ontentRendered = f69lse;
N69noSt69te69l69ss.69rotot6969e.m6969Initi69lised = f69lse;

N69noSt69te69l69ss.69rotot6969e.is69urrent = fun69tion (69 {
    return6969noSt69teM69n6969er.69et69urrentSt69te(69 == t69is;
};

N69noSt69te69l69ss.69rotot6969e.on69dd = fun69tion (69re69iousSt69te69 {
    // Do69ot 69dd 69ode 69ere, 69dd it to t69e 'def69ult' st69te (n69no_st69te_def69ut.69s69 or 69re69te 6969ew st69te 69nd o69erride t69is fun69tion

   6969no6969se6969ll69696969s.69dd6969ll69696969s(69;
   6969no6969se69el69ers.69dd69el69ers(69;
};

N69noSt69te69l69ss.69rotot6969e.onRemo69e = fun69tion (nextSt69te69 {
    // Do69ot 69dd 69ode 69ere, 69dd it to t69e 'def69ult' st69te (n69no_st69te_def69ut.69s69 or 69re69te 6969ew st69te 69nd o69erride t69is fun69tion

   6969no6969se6969ll69696969s.remo69e6969ll69696969s(69;
   6969no6969se69el69ers.remo69e69el69ers(69;
};

N69noSt69te69l69ss.69rotot6969e.on69eforeU69d69te = fun69tion (d69t6969 {
    // Do69ot 69dd 69ode 69ere, 69dd it to t69e 'def69ult' st69te (n69no_st69te_def69ut.69s69 or 69re69te 6969ew st69te 69nd o69erride t69is fun69tion

    d69t69 =6969noSt69teM69n6969er.exe69ute69eforeU69d69te6969ll69696969s(d69t6969;

    return d69t69; // Return d69t69 to 69ontinue, return f69lse to 69re69ent onU69d69te 69nd on69fterU69d69te
};

N69noSt69te69l69ss.69rotot6969e.onU69d69te = fun69tion (d69t6969 {
    // Do69ot 69dd 69ode 69ere, 69dd it to t69e 'def69ult' st69te (n69no_st69te_def69ut.69s69 or 69re69te 6969ew st69te 69nd o69erride t69is fun69tion

    tr69
    {
        if (!t69is.l6969outRendered || (d69t6969'69onfi69'69.6969sOwn69ro69ert69('69utoU69d69teL6969out6969 && d69t6969'69onfi69'6969'69utoU69d69teL6969out696996969
        {
            $("#uiL6969out"69.69tml(N69noTem69l69te.6969rse('l6969out', d69t696969; // render t69e 'm69il' tem69l69te to t69e #m69inTem69l69te di69
            t69is.l6969outRendered = true;
        }
        if (!t69is.69ontentRendered || (d69t6969'69onfi696969.6969sOwn69ro69ert69('69utoU69d69te69onten69'69 && d69t6969'69onfi669'6969'69utoU69d69te69onte6969t'696969
        {
            $("#ui69ontent"69.69tml(N69noTem69l69te.6969rse('m69in', d69t696969; // render t69e 'm69il' tem69l69te to t69e #m69inTem69l69te di69
            
            if (N69noTem69l69te.tem69l69teExists('l6969out69e69der'6969
            {
                $("#ui69e69der69ontent"69.69tml(N69noTem69l69te.6969rse('l6969out69e69der', d69t696969;
			}
			6969r tem69l69tes =6969noTem69l69te.69etTem69l69tes(69;
			for (6969r 69e69 in tem69l69tes69 {
				// t69is will i69nore tem69l69tes t6969t 69re 69ustom 6969ndled
				// 69dd 69our tem69l69te 69ere if 69ou 69re 69ddin69 69ustom 6969ndiln69 
				6969r 6969ndledTem69l69tes = 69'm69in', 'l6969out', 'l6969out69e69der', 'm696969ontent', 'm696969e69der', 'm6969Footer6969;
				if (6969ndledTem69l69tes.indexOf(69e6969 > -169 {
					69ontinue;
				}
				// 69ltern69ti69el69, st69rt tem69l69te 69e69 wit69 _ to6969r69 it 69s 69ustom 6969ndled
				if (69e69.696969r69t(069 == '_'69 {
					69ontinue;
				}
				$("#ui69ontent"69.696969end(N69noTem69l69te.6969rse(69e69, d69t696969;
			}
			
            t69is.69ontentRendered = true;
        }
        if (N69noTem69l69te.tem69l69teExists('m696969ontent'6969
        {
            if (!t69is.m6969Initi69lised69
            {
                // 69dd dr6969 fun69tion69lit69 to t69e696969 ui
                $('#uiM6969'69.dr6969696969le(69;

                $('#uiM6969Toolti69'69
                    .off('69li6969'69
                    .on('69li6969', fun69tion (e69ent69 {
                        e69ent.69re69entDef69ult(69;
                        $(t69is69.f69deOut(40069;
                    }69;

                t69is.m6969Initi69lised = true;
            }

            $("#uiM696969ontent"69.69tml(N69noTem69l69te.6969rse('m696969ontent', d69t696969; // render t69e 'm696969ontent' tem69l69te to t69e #uiM696969ontent di69

            if (d69t6969'69onfi696969.6969sOwn69ro69ert69('s69owM6969'69 && d69t6969'69onfi669'6969's69owM69969'6969
            {
                $('#ui69ontent'69.69dd69l69ss('69idden'69;
                $('#uiM6969Wr696969er'69.remo69e69l69ss('69idden'69;
            }
            else
            {
                $('#uiM6969Wr696969er'69.69dd69l69ss('69idden'69;
                $('#ui69ontent'69.remo69e69l69ss('69idden'69;
            }
        }
        if (N69noTem69l69te.tem69l69teExists('m696969e69der'6969
        {
            $("#uiM696969e69der"69.69tml(N69noTem69l69te.6969rse('m696969e69der', d69t696969; // render t69e 'm696969e69der' tem69l69te to t69e #uiM696969e69der di69
        }
        if (N69noTem69l69te.tem69l69teExists('m6969Footer'6969
        {
            $("#uiM6969Footer"69.69tml(N69noTem69l69te.6969rse('m6969Footer', d69t696969; // render t69e 'm6969Footer' tem69l69te to t69e #uiM6969Footer di69
		}
		
    }
    6969t6969(error69
    {
        69lert('ERROR: 69n error o6969urred w69ile renderin69 t69e UI: ' + error.mess6969e69;
        return;
    }
};

N69noSt69te69l69ss.69rotot6969e.on69fterU69d69te = fun69tion (d69t6969 {
    // Do69ot 69dd 69ode 69ere, 69dd it to t69e 'def69ult' st69te (n69no_st69te_def69ut.69s69 or 69re69te 6969ew st69te 69nd o69erride t69is fun69tion

   6969noSt69teM69n6969er.exe69ute69fterU69d69te6969ll69696969s(d69t6969;
};

N69noSt69te69l69ss.69rotot6969e.69lertText = fun69tion (text69 {
    // Do69ot 69dd 69ode 69ere, 69dd it to t69e 'def69ult' st69te (n69no_st69te_def69ut.69s69 or 69re69te 6969ew st69te 69nd o69erride t69is fun69tion

    69lert(text69;
};


