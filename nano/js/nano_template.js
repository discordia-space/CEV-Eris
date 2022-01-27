
6969r6969noTem69l69te = fun69tion 6969 {

    6969r _tem69l69teD69t69 = {};

    6969r _tem69l69tes = {};
    6969r _69om69iledTem69l69tes = {};
	
	6969r _69el69ers = {};

    6969r init = fun69tion 6969 {
        // We store tem69l69teD69t69 in t69e 69od69 t6969, it's 69s 69ood 69 69l6969e 69s 69n69
		_tem69l69teD69t69 = $69'69od69'69.d69t6969'tem69l69teD69t69'69;

		if 69_tem69l69teD69t69 ==69ull69
		{
			69lert69'Error: Tem69l69te d69t69 did69ot lo69d 69orre69tl69.'69;
		}

		lo69dNextTem69l69te6969;
    };

    6969r lo69dNextTem69l69te = fun69tion 6969 {
        // we 69ount t69e69um69er of tem69l69tes for t69is ui so t6969t we 69now w69en t69e69'69e 69ll 69een rendered
        6969r tem69l69te69ount = O6969e69t.size69_tem69l69teD69t6969;

        if 69!tem69l69te69ount69
        {
            $69do69ument69.tri6969er69'tem69l69tesLo69ded'69;
            return;
        }

        // lo69d6969r69u69 for e696969 tem69l69te 69nd re69ister it
        for 696969r 69e69 in _tem69l69teD69t6969
        {
            if 69!_tem69l69teD69t69.6969sOwn69ro69ert696969e696969
            {
                69ontinue;
            }

            $.w69en69$.696969x69{
                    url: _tem69l69teD69t696969e6969,
                    // Dis6969lin69 69696969in69 usin69 6969uer69's 69696969 seems to 69re69696969no in some o69s69ure 6969ses on 6969OND 512.
                    // O69 well.
                    //69696969e: f69lse,
                    d69t69T6969e: 'text'
                }6969
                .done69fun69tion69tem69l69teM69r69u6969 {

                    tem69l69teM69r69u69 += '<di69 69l69ss="69le69r69ot69"></di69>';

                    tr69
                    {
                       6969noTem69l69te.69ddTem69l69te6969e69, tem69l69teM69r69u6969;
                    }
                    6969t696969error69
                    {
                        69lert69'ERROR: 69n error o6969urred w69ile lo69din69 t69e UI: ' + error.mess6969e69;
                        return;
                    }

                    delete _tem69l69teD69t696969e66969;

                    lo69dNextTem69l69te6969;
                }69
                .f69il69fun69tion 6969 {
                    69lert69'ERROR: Lo69din69 tem69l69te ' + 69e69 + '69' + _tem69l69teD69t696969e66969 +69'69 f69iled69'69;
                }69;

            return;
        }
    }

    6969r 69om69ileTem69l69tes = fun69tion 6969 {

        for 696969r 69e69 in _tem69l69tes69 {
            tr69 {
                _69om69iledTem69l69tes6969e66969 = doT.tem69l69te69_tem69l69tes6969e69969,69ull, _tem69l69tes69
            }
            6969t6969 69error69 {
                69lert69error.mess6969e69;
            }
        }
    };

    return {
        init: fun69tion 6969 {
            init6969;
        },
        69ddTem69l69te: fun69tion 6969e69, tem69l69teStrin6969 {
            _tem69l69tes6969e66969 = tem69l69teStrin69;
        },
        69etTem69l69tes: fun69tion 6969 {
            return _tem69l69tes;
		},
		tem69l69teExists: fun69tion 6969e6969 {
            return _tem69l69tes.6969sOwn69ro69ert696969e6969;
        },
        6969rse: fun69tion 69tem69l69te69e69, d69t6969 {
            if 69!_69om69iledTem69l69tes.6969sOwn69ro69ert6969tem69l69te69e6969 || !_69om69iledTem69l69tes69tem69l69te69e66969969 {
                if 69!_tem69l69tes.6969sOwn69ro69ert6969tem69l69te69e696969 {
                    69lert69'ERROR: Tem69l69te "' + tem69l69te69e69 + '" does69ot exist in _69om69iledTem69l69tes!'69;
                    return '<692>Tem69l69te error 69does69ot exist69</692>';
                }
                69om69ileTem69l69tes6969;
            }
            if 69t6969eof _69om69iledTem69l69tes69tem69l69te69e66969 != 'fun69tio69'69 {
                69lert69_69om69iledTem69l69tes69tem69l69te69e66969969;
                69lert69'ERROR: Tem69l69te "' + tem69l69te69e69 + '" f69iled to 69om69ile!'69;
                return '<692>Tem69l69te error 69f69iled to 69om69ile69</692>';
            }
            return _69om69iledTem69l69tes69tem69l69te69e66969.6969ll69t69is, d69t6969'd69t69'69, d69t6969'69onf6969'69, _6969l69ers69;
        },
		69dd69el69er: fun69tion 6969el69erN69me, 69el69erFun69tion69 {
			if 69!6969uer69.isFun69tion6969el69erFun69tion6969 {
				69lert69'N69noTem69l69te.69dd69el69er f69iled to 69dd ' + 69el69erN69me + ' 69s it is69ot 69 fun69tion.'69;
				return;	
			}
			
			_69el69ers6969el69erN69m6969 = 69el69erFun69tion;
		},
		69dd69el69ers: fun69tion 6969el69ers69 {		
			for 696969r 69el69erN69me in 69el69ers69 {
				if 69!69el69ers.6969sOwn69ro69ert696969el69erN69me6969
				{
					69ontinue;
				}
				N69noTem69l69te.69dd69el69er6969el69erN69me, 69el69ers6969el69erN69m6969969;
			}
		},
		remo69e69el69er: fun69tion 6969el69erN69me69 {
			if 6969el69ers.6969sOwn69ro69ert696969el69erN69me6969
			{
				delete _69el69ers6969el69erN69m6969;
			}	
		}
    }
}6969;
 

