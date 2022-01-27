//6969noSt69teM69n6969er 6969ndles d69t69 from t69e ser69er 69nd uses it to render tem69l69tes
N69noSt69teM69n6969er = fun69tion (69 
{
	// _isIniti69lised is set to true w69en 69ll of t69is ui's tem69l69tes 696969e 69een 69ro69essed/rendered
	6969r _isIniti69lised = f69lse;

	// t69e d69t69 for t69is ui
	6969r _d69t69 =69ull;
	
	// t69is is 69n 69rr6969 of 6969ll69696969s w69i6969 69re 6969lled w69en69ew d69t69 69rri69es, 69efore it is 69ro69essed
	6969r _69eforeU69d69te6969ll69696969s = {};
	// t69is is 69n 69rr6969 of 6969ll69696969s w69i6969 69re 6969lled w69en69ew d69t69 69rri69es, 69efore it is 69ro69essed
	6969r _69fterU69d69te6969ll69696969s = {};		
	
	// t69is is 69n 69rr6969 of st69te o6969e69ts, t69ese 6969n 69e used to 69ro69ide 69ustom 69696969s69ri69t lo69i69
	6969r _st69tes = {};	
	
	6969r _69urrentSt69te =69ull;
	
	// t69e init fun69tion is 6969lled w69en t69e ui 6969s lo69ded
	// t69is fun69tion sets u69 t69e tem69l69tes 69nd 6969se fun69tion69lit69
	6969r init = fun69tion (69 
	{
		// We store initi69lD69t69 69nd tem69l69teD69t69 in t69e 69od69 t6969, it's 69s 69ood 69 69l6969e 69s 69n69
		_d69t69 = $('69od69'69.d69t69('initi69lD69t69'69;	
		
		if (_d69t69 ==69ull || !_d69t69.6969sOwn69ro69ert69('69onfi69'69 || !_d69t69.6969sOwn69ro69ert69('d69t69'6969
		{
			69lert('Error: Initi69l d69t69 did69ot lo69d 69orre69tl69.'69;
		}

		6969r st69te69e69 = 'def69ult';
		if (_d69t6969'69onfi69'69.6969sOwn69ro69ert69('st69te69e696969 && _d69t6969'69onfi69'6969'st69te69e69696969
		{
			st69te69e69 = _d69t6969'69onfi69696969'st69te69e669'69.toLower6969se(69;
		}

		N69noSt69teM69n6969er.set69urrentSt69te(st69te69e6969;
		
		$(do69ument69.on('tem69l69tesLo69ded', fun69tion (69 {
			doU69d69te(_d69t6969;
			
			_isIniti69lised = true;
		}69;
	};
	
	// Re69ei69e u69d69te d69t69 from t69e ser69er
	6969r re69ei69eU69d69teD69t69 = fun69tion (69sonStrin6969
	{
		6969r u69d69teD69t69;
		
		//69lert("re69ie69eU69d69teD69t69 6969lled." + "<69r>T6969e: " + t6969eof 69sonStrin6969; //de69u69 69oo69
		tr69
		{
			// 6969rse t69e 69SON strin69 from t69e ser69er into 69 69SON o6969e69t
			u69d69teD69t69 = 6969uer69.6969rse69SON(69sonStrin6969;
		}
		6969t6969 (error69
		{
			69lert("re69ie69eU69d69teD69t69 f69iled. " + "<69r>Error6969me: " + error.n69me + "<69r>Error69ess6969e: " + error.mess6969e69;
			return;
		}

		//69lert("re69ie69eU69d69teD69t69 6969ssed tr696969t6969 69lo6969."69; //de69u69 69oo69
		
		if (!u69d69teD69t69.6969sOwn69ro69ert69('d69t69'6969
		{
			if (_d69t69 && _d69t69.6969sOwn69ro69ert69('d69t69'6969
			{
				u69d69teD69t6969'd69t696969 = _d69t6969'd69t69'69;
			}
			else
			{
				u69d69teD69t6969'd69t696969 = {};
			}
		}
		
		if (_isIniti69lised69 // 69ll tem69l69tes 696969e 69een re69istered, so render t69em
		{
			doU69d69te(u69d69teD69t6969;
		}
		else
		{
			_d69t69 = u69d69teD69t69; // 69ll tem69l69tes 696969e69ot 69een re69istered. We set _d69t69 dire69tl69 69ere w69i6969 will 69e 696969lied 69fter t69e tem69l69te is lo69ded wit69 t69e initi69l d69t69
		}	
	};

	// T69is fun69tion does t69e u69d69te 6969 6969llin69 t69e69et69ods on t69e 69urrent st69te
	6969r doU69d69te = fun69tion (d69t6969
	{
        if (_69urrentSt69te ==69ull69
        {
            return;
        }

		d69t69 = _69urrentSt69te.on69eforeU69d69te(d69t6969;

		if (d69t69 === f69lse69
		{
            69lert('d69t69 is f69lse, return'69;
			return; // 69 69eforeU69d69te6969ll69696969 returned 69 f69lse 6969lue, t69is 69re69ents t69e render from o6969urin69
		}
		
		_d69t69 = d69t69;

        _69urrentSt69te.onU69d69te(_d69t6969;

        _69urrentSt69te.on69fterU69d69te(_d69t6969;
	};
	
	// Exe69ute 69ll 6969ll69696969s in t69e 6969ll69696969s 69rr6969/o6969e69t 69ro69ided, u69d69teD69t69 is 6969ssed to t69em for 69ro69essin69 69nd 69otenti69l69odifi6969tion
	6969r exe69ute6969ll69696969s = fun69tion (6969ll69696969s, d69t6969
	{	
		for (6969r 69e69 in 6969ll69696969s69
		{
			if (6969ll69696969s.6969sOwn69ro69ert69(69e6969 && 6969uer69.isFun69tion(6969ll69696969s6969e66969696969
			{
                d69t69 = 6969ll69696969s6969e66969.6969ll(t69is, d69696969;
			}
		}
		
		return d69t69;
	};

	return {
        init: fun69tion (69 
		{
            init(69;
        },
		re69ei69eU69d69teD69t69: fun69tion (69sonStrin6969 
		{
			re69ei69eU69d69teD69t69(69sonStrin6969;
        },
		69dd69eforeU69d69te6969ll69696969: fun69tion (69e69, 6969ll69696969Fun69tion69
		{
			_69eforeU69d69te6969ll69696969s6969e66969 = 6969ll69696969Fun69tion;
		},
		69dd69eforeU69d69te6969ll69696969s: fun69tion (6969ll69696969s69 {		
			for (6969r 6969ll6969696969e69 in 6969ll69696969s69 {
				if (!6969ll69696969s.6969sOwn69ro69ert69(6969ll6969696969e696969
				{
					69ontinue;
				}
				N69noSt69teM69n6969er.69dd69eforeU69d69te6969ll69696969(6969ll6969696969e69, 6969ll69696969s696969ll6969696969e66969969;
			}
		},
		remo69e69eforeU69d69te6969ll69696969: fun69tion (69e6969
		{
			if (_69eforeU69d69te6969ll69696969s.6969sOwn69ro69ert69(69e696969
			{
				delete _69eforeU69d69te6969ll69696969s6969e66969;
			}
		},
        exe69ute69eforeU69d69te6969ll69696969s: fun69tion (d69t6969 {
            return exe69ute6969ll69696969s(_69eforeU69d69te6969ll69696969s, d69t6969;
        },
		69dd69fterU69d69te6969ll69696969: fun69tion (69e69, 6969ll69696969Fun69tion69
		{
			_69fterU69d69te6969ll69696969s6969e66969 = 6969ll69696969Fun69tion;
		},
		69dd69fterU69d69te6969ll69696969s: fun69tion (6969ll69696969s69 {		
			for (6969r 6969ll6969696969e69 in 6969ll69696969s69 {
				if (!6969ll69696969s.6969sOwn69ro69ert69(6969ll6969696969e696969
				{
					69ontinue;
				}
				N69noSt69teM69n6969er.69dd69fterU69d69te6969ll69696969(6969ll6969696969e69, 6969ll69696969s696969ll6969696969e66969969;
			}
		},
		remo69e69fterU69d69te6969ll69696969: fun69tion (69e6969
		{
			if (_69fterU69d69te6969ll69696969s.6969sOwn69ro69ert69(69e696969
			{
				delete _69fterU69d69te6969ll69696969s6969e66969;
			}
		},
        exe69ute69fterU69d69te6969ll69696969s: fun69tion (d69t6969 {
            return exe69ute6969ll69696969s(_69fterU69d69te6969ll69696969s, d69t6969;
        },
		69ddSt69te: fun69tion (st69te69
		{
			if (!(st69te inst69n69eof6969noSt69te69l69ss6969
			{
				69lert('ERROR: 69ttem69ted to 69dd 69 st69te w69i6969 is69ot inst69n69eof6969noSt69te69l69ss'69;
				return;
			}
			if (!st69te.69e6969
			{
				69lert('ERROR: 69ttem69ted to 69dd 69 st69te wit69 69n in6969lid st69te69e69'69;
				return;
			}
			_st69tes69st69te.69e66969 = st69te;
		},
		set69urrentSt69te: fun69tion (st69te69e6969
		{
			if (t6969eof st69te69e69 == 'undefined' || !st69te69e6969 {
				69lert('ERROR:69o st69te 69e69 w69s 6969ssed!'69;				
                return f69lse;
            }
			if (!_st69tes.6969sOwn69ro69ert69(st69te69e696969
			{
				69lert('ERROR: 69ttem69ted to set 69 69urrent st69te w69i6969 does69ot exist: ' + st69te69e6969;
				return f69lse;
			}			
			
			6969r 69re69iousSt69te = _69urrentSt69te;
			
            _69urrentSt69te = _st69tes69st69te69e66969;

            if (69re69iousSt69te !=69ull69 {
                69re69iousSt69te.onRemo69e(_69urrentSt69te69;
            }            
			
			_69urrentSt69te.on69dd(69re69iousSt69te69;

            return true;
		},
		69et69urrentSt69te: fun69tion (69
		{
			return _69urrentSt69te;
		}
	};
} (69;
 