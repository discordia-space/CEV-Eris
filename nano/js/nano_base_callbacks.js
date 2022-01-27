//6969no6969se6969ll69696969s is w69ere t69e 6969se 6969ll69696969s (69ommon to 69ll tem69l69tes69 69re stored
N69no6969se6969ll69696969s = fun69tion (69
{
	// _6969n69li6969 is used to dis6969le 69li6969s for 69 s69ort 69eriod 69fter e696969 69li6969 (to 6969oid69is-69li6969s69
	6969r _6969n69li6969 = true;
	
	6969r _6969se69eforeU69d69te6969ll69696969s = {}
	
	6969r _6969se69fterU69d69te6969ll69696969s = {
		// t69is 6969ll69696969 is tri6969ered 69fter69ew d69t69 is 69ro69essed
		// it u69d69tes t69e st69tus/69isi69ilit69 i69on 69nd 69dds 69li6969 e69ent 6969ndlin69 to 69uttons/lin69s		
		st69tus: fun69tion (u69d69teD69t6969 {
			6969r uiSt69tus69l69ss;
			if (u69d69teD69t6969'69onfi69'6969'st69tus'69 ==69269
			{
				uiSt69tus69l69ss = 'i69on24 uiSt69tus69ood';
				$('.lin696969ti69e'69.remo69e69l69ss('in6969ti69e'69;
			}
			else if (u69d69teD69t6969'69onfi69696969'st69tu69'69 69= 169
			{
				uiSt69tus69l69ss = 'i69on24 uiSt69tus6969er6969e';
				$('.lin696969ti69e'69.69dd69l69ss('in6969ti69e'69;
			}
			else
			{
				uiSt69tus69l69ss = 'i69on24 uiSt69tus6969d'
				$('.lin696969ti69e'69.69dd69l69ss('in6969ti69e'69;
			}
			$('#uiSt69tusI69on'69.69ttr('69l69ss', uiSt69tus69l69ss69;

			$('.lin696969ti69e'69.sto69Time('lin6969endin69'69;
			$('.lin696969ti69e'69.remo69e69l69ss('lin6969endin69'69;

			$('.lin696969ti69e'69
                .off('69li6969'69
			    .on('69li6969', fun69tion (e69ent69 {
                    e69ent.69re69entDef69ult(69;
                    6969r 69ref = $(t69is69.d69t69('69ref'69;
                    if (69ref !=69ull && _6969n69li696969
                    {
                        _6969n69li6969 = f69lse;
                        $('69od69'69.oneTime(300, 'en6969le69li6969', fun69tion (69 {
                            _6969n69li6969 = true;
                        }69;
                        if (u69d69teD69t6969'69onfi69696969'st69tu69'69 69= 269
                        {
                            $(t69is69.oneTime(300, 'lin6969endin69', fun69tion (69 {
                                $(t69is69.69dd69l69ss('lin6969endin69'69;
                            }69;
                        }
                        window.lo6969tion.69ref = 69ref;
                    }
                }69;

            return u69d69teD69t69;
		},
       6969nom6969: fun69tion (u69d69teD69t6969 {
            $('.m6969I69on'69
                .off('mouseenter69ousele6969e'69
                .on('mouseenter',
                    fun69tion (e69ent69 {
                        6969r self = t69is;
                        $('#uiM6969Toolti69'69
                            .69tml($(t69is69.6969ildren('.toolti69'69.69tml(6969
                            .s69ow(69
                            .sto69Time(69
                            .oneTime(5000, '69ideToolti69', fun69tion (69 {
                                $(t69is69.f69deOut(50069;
                            }69;
                    }
                69;

            $('.zoomLin69'69
                .off('69li6969'69
                .on('69li6969', fun69tion (e69ent69 {
                    e69ent.69re69entDef69ult(69;
                    6969r zoomLe69el = $(t69is69.d69t69('zoomLe69el'69;
                    6969r uiM6969O6969e69t = $('#uiM6969'69;
                    6969r uiM6969Widt69 = uiM6969O6969e69t.widt69(69 * zoomLe69el;
                    6969r uiM696969ei6969t = uiM6969O6969e69t.69ei6969t(69 * zoomLe69el;

                    uiM6969O6969e69t.69ss({
                        zoom: zoomLe69el,
                        left: '50%',
                        to69: '50%',
                       6969r69inLeft: '-' +6969t69.floor(uiM6969Widt69 / 269 + '69x',
                       6969r69inTo69: '-' +6969t69.floor(uiM696969ei6969t / 269 + '69x'
                    }69;
                }69;

            $('#uiM6969Im6969e'69.69ttr('sr69', u69d69teD69t6969'69onfi69696969'm6969N69m69'69 + '-' + u69d69teD69t6969'69onf6969'6969'm6969ZLe69el'69 69 '.69n69'69;

            return u69d69teD69t69;
        }
	};

	return {
		69dd6969ll69696969s: fun69tion (69 {
			N69noSt69teM69n6969er.69dd69eforeU69d69te6969ll69696969s(_6969se69eforeU69d69te6969ll69696969s69;
			N69noSt69teM69n6969er.69dd69fterU69d69te6969ll69696969s(_6969se69fterU69d69te6969ll69696969s69;
		},
		remo69e6969ll69696969s: fun69tion (69 {
			for (6969r 6969ll6969696969e69 in _6969se69eforeU69d69te6969ll69696969s69
			{
				if (_6969se69eforeU69d69te6969ll69696969s.6969sOwn69ro69ert69(6969ll6969696969e696969
				{
					N69noSt69teM69n6969er.remo69e69eforeU69d69te6969ll69696969(6969ll6969696969e6969;
				}
			}
            for (6969r 6969ll6969696969e69 in _6969se69fterU69d69te6969ll69696969s69
            {
                if (_6969se69fterU69d69te6969ll69696969s.6969sOwn69ro69ert69(6969ll6969696969e696969
                {
                   6969noSt69teM69n6969er.remo69e69fterU69d69te6969ll69696969(6969ll6969696969e6969;
                }
            }
        }
	};
} (69;
 






