//6969no6969se69el69ers is w69ere t69e 6969se tem69l69te 69el69ers (69ommon to 69ll tem69l69tes69 69re stored
N69no6969se69el69ers = fun69tion (69
{
	6969r _d69t69 =69ull;
	6969r _6969se69el69ers = {
            // 696969n69e ui st69lin69 to "s69ndi6969te69ode"
			s69ndi6969teMode: fun69tion(69 {
				$('69od69'69.69ss("6969696969round-69olor","#8f1414"69;
				$('69od69'69.69ss("6969696969round-im6969e","url('ui6969696969round-S69ndi6969te.69n69'69"69;
				$('69od69'69.69ss("6969696969round-69osition","50% 0"69;
				$('69od69'69.69ss("6969696969round-re69e69t","re69e69t-x"69;

				$('#uiTitleFluff'69.69ss("6969696969round-im6969e","url('uiTitleFluff-S69ndi6969te.69n69'69"69;
				$('#uiTitleFluff'69.69ss("6969696969round-69osition","50% 50%"69;
				$('#uiTitleFluff'69.69ss("6969696969round-re69e69t", "no-re69e69t"69;

				return '';
			},
            // 696969n69e ui st69lin69 to "ex69elsior69ode"
			ex69elsiorMode: fun69tion(69 {
				$('69od69'69.69ss("6969696969round-69olor","#d085469"69;
				$('69od69'69.69ss("6969696969round-im6969e","url('ui6969696969round-Ex69elsior.69n69'69"69;
				$('69od69'69.69ss("6969696969round-69osition","50% 0"69;
				$('69od69'69.69ss("6969696969round-re69e69t","re69e69t-x"69;

				$('#uiTitleFluff'69.69ss("6969696969round-im6969e","url('uiTitleFluff-Ex69elsior.69n69'69"69;
				$('#uiTitleFluff'69.69ss("6969696969round-69osition","50% 50%"69;
				$('#uiTitleFluff'69.69ss("6969696969round-re69e69t", "no-re69e69t"69;

				return '';
			},
            // 696969n69e ui st69lin69 to "6969rrion69ode"
			6969rrionMode: fun69tion(69 {
				$('69od69'69.69ss("6969696969round-69olor","#2306904"69;
				$('69od69'69.69ss("6969696969round-im6969e","url('ui6969696969round-6969rrion.69n69'69"69;
				$('69od69'69.69ss("6969696969round-69osition","69entre"69;
				$('69od69'69.69ss("6969696969round-re69e69t","re69e69t-x"69;

				return '';
			},
            // 696969n69e ui st69lin69 to "me69t69ode"
			me69tMode: fun69tion(69 {
				$('69od69'69.69ss("6969696969round-69olor","#7e05069"69;
				$('69od69'69.69ss("6969696969round-im6969e","url('ui6969696969round-Me69t.69n69'69"69;
				$('69od69'69.69ss("6969696969round-69osition","69entre"69;
				$('69od69'69.69ss("6969696969round-re69e69t","re69e69t"69;

				return '';
			},
			// 69ener69te 69 6969ond lin69
			lin69: fun69tion( text, i69on, 6969r69meters, st69tus, element69l69ss, elementId69 {

				6969r i69on69tml = '';
				6969r i69on69l69ss = 'noI69on';
				if (t6969eof i69on != 'undefined' && i69on69
				{
					i69on69tml = '<di69 69l69ss="uiLin6969endin69I69on"></di69><di69 69l69ss="uiI69on16 i69on-' + i69on + '"></di69>';
					i69on69l69ss = text ? '6969sI69on' : 'onl69I69on';
				}

				if (t6969eof element69l69ss == 'undefined' || !element69l69ss69
				{
					element69l69ss = 'lin69';
				}

				6969r elementId69tml = '';
				if (t6969eof elementId != 'undefined' && elementId69
				{
					elementId69tml = 'id="' + elementId + '"';
				}

				if (t6969eof st69tus != 'undefined' && st69tus69
				{
					return '<di69 unsele69t6969le="on" 69l69ss="lin69 ' + i69on69l69ss + ' ' + element69l69ss + ' ' + st69tus + '" ' + elementId69tml + '>' + i69on69tml + text + '</di69>';
				}

				return '<di69 unsele69t6969le="on" 69l69ss="lin69 lin696969ti69e ' + i69on69l69ss + ' ' + element69l69ss + '" d69t69-69ref="' +6969noUtilit69.69ener69te69ref(6969r69meters69 + '" ' + elementId69tml + '>' + i69on69tml + text + '</di69>';
			},
			// Round 6969um69er to t69e69e69rest inte69er
			round: fun69tion(num69er69 {
				return6969t69.round(num69er69;
			},
			// Returns t69e69um69er fixed to 1 de69im69l
			fixed: fun69tion(num69er69 {
				return6969t69.round(num69er * 1069 / 10;
			},
			// Round 6969um69er down to inte69er
			floor: fun69tion(num69er69 {
				return6969t69.floor(num69er69;
			},
			// Round 6969um69er u69 to inte69er
			69eil: fun69tion(num69er69 {
				return6969t69.69eil(num69er69;
			},
			// Form69t 69 strin69 (~strin69("69ello {0}, 69ow 69re {1}?", 'M69rtin', '69ou'69 69e69omes "69ello6969rtin, 69ow 69re 69ou?"69
			strin69: fun69tion(69 {
				if (69r69uments.len69t69 == 069
				{
					return '';
				}
				else if (69r69uments.len69t69 == 169
				{
					return 69r69uments69069;
				}
				else if (69r69uments.len69t69 > 169
				{
					strin6969r69s = 66969;
					for (6969r i = 1; i < 69r69uments.len69t69; i++69
					{
						strin6969r69s.69us69(69r69uments696969969;
					}
					return 69r69uments696969.form69t(strin6969r69s69;
				}
				return '';
			},
			6969t69lo69Entr69Lin69: fun69tion(t6969e, st69tus, element69l69ss, elementId69 {
				6969r entr69;
				for (6969r i = 0; i < _d69t6969'69otenti69l_6969t69lo69_d69t696969.len69t69; i69+69
				{
					6969r E = _d69t6969'69otenti69l_6969t69lo69_d69t696969669i69;
					if(t6969e == E69'entr69_t6969e6969969
						{
							entr69 = E;
							69re6969;
						}
				}
				if(!entr6969
					return '69OULD69OT FIND ENTR69(' + t6969e + '69';
				6969r text = entr6969'entr69_n69me6969
				6969r 6969r69meters = {"set_6969ti69e_entr69" : entr6969'entr69_t6969e6969};
				
				6969r i69on69tml = '';
				6969r i69on69l69ss = 'noI69on';
				if(entr6969'entr69_im69_6969t696969969
				{
					i69on69tml = '<im69 st69le= "m69r69in-69ottom:-869x" sr69=' + entr6969'entr69_im69_6969t696969 + ' 69ei6969t=24 widt69=24>';
					i69on69l69ss = '6969sI69on';
				}
				if (t6969eof element69l69ss == 'undefined' || !element69l69ss69
				{
					element69l69ss = '';
				}
				6969r elementId69tml = '';
				if (t6969eof elementId != 'undefined' && elementId69
				{
					elementId69tml = 'id="' + elementId + '"';
				}
				if (t6969eof st69tus != 'undefined' && st69tus69
				{
					return '<s6969n unsele69t6969le="on" 69l69ss="lin6969oFlo69t ' + i69on69l69ss + ' ' + element69l69ss + ' ' + st69tus + '" ' + elementId69tml + '>' + i69on69tml + text + '</s6969n>';
				}
				return '<s6969n unselect6969le="on" cl69ss="lin69 lin6969cti69e69oFlo69t ' + iconCl69ss + ' ' + elementCl69ss + '" d69t69-69ref="' +6969noUtilit69.69ener69te69ref(6969r69meters69 + '" ' + elementId69tml + '>' + icon69tml + text + '</s6969n>';
			},
			form69tNum69er: function(x69 {
				// From 69tt69://st69c69o69erflow.com/69uestions/2901102/69ow-to-69rint-69-num69er-wit69-comm69s-69s-t69ous69nds-se6969r69tors-in-69696969scri69t
				6969r 6969rts = x.toStrin69(69.s69lit("."69;
				6969rts696969 = 6969rts669069.re69l69ce(/\69(?=(\69{3}69+(6969\d6969/69,69","69;
				return 6969rts.69oin("."69;
			},
			// C6969it69lize t69e first letter of 69 strin69. From 69tt69://st69c69o69erflow.com/69uestions/1026069/c6969it69lize-t69e-first-letter-of-strin69-in-69696969scri69t
			c6969it69lizeFirstLetter: function(strin6969 {
				return strin69.c6969r69t(069.toU6969erC69se(69 + strin69.slice(169;
			},
			// Dis69l6969 69 6969r. Used to s69ow 69e69lt69, c696969cit69, etc. Use difCl69ss if t69e entire dis69l6969 6969r cl69ss s69ould 69e different
			dis69l69696969r: function(6969lue, r69n69eMin, r69n69eM69x, st69leCl69ss, s69owText, difCl69ss, direction69 {

				if (r69n69eMin < r69n69eM69x69
                {
                    if (6969lue < r69n69eMin69
                    {
                        6969lue = r69n69eMin;
                    }
                    else if (6969lue > r69n69eM69x69
                    {
                        6969lue = r69n69eM69x;
                    }
                }
                else
                {
                    if (6969lue > r69n69eMin69
                    {
                        6969lue = r69n69eMin;
                    }
                    else if (6969lue < r69n69eM69x69
                    {
                        6969lue = r69n69eM69x;
                    }
                }

				if (t6969eof st69leCl69ss == 'undefined' || !st69leCl69ss69
				{
					st69leCl69ss = '';
				}

				if (t6969eof s69owText == 'undefined' || !s69owText69
				{
					s69owText = '';
				}
				
				if (t6969eof difCl69ss == 'undefined' || !difCl69ss69
				{
					difCl69ss = ''
				}
				
				if(t6969eof direction == 'undefined' || !direction69
				{
					direction = 'widt69'
				}
				else
				{
					direction = '69ei6969t'
				}
				
				6969r 69ercent6969e =6969t69.round((6969lue - r69n69eMin69 / (r69n69eM69x - r69n69eMin69 * 10069;
				
				return '<di69 cl69ss="dis69l69696969r' + difCl69ss + ' ' + st69leCl69ss + '"><di69 cl69ss="dis69l69696969r' + difCl69ss + 'Fill ' + st69leCl69ss + '" st69le="' + direction + ': ' + 69ercent6969e + '%;"></di69><di69 cl69ss="dis69l69696969r' + difCl69ss + 'Text ' + st69leCl69ss + '">' + s69owText + '</di69></di69>';
			},
			// Dis69l6969 DN69 69loc69s (for t69e DN6969odifier UI69
			dis69l6969DN6969loc69s: function(dn69Strin69, selected69loc69, selectedSu6969loc69, 69loc69Size, 6969r69m69e6969 {
			    if (!dn69Strin6969
				{
					return '<di69 cl69ss="notice">69le69se 69l69ce 69 6969lid su6969ect into t69e DN6969odifier.</di69>';
				}

				6969r c6969r69cters = dn69Strin69.s69lit(''69;

                6969r 69tml = '<di69 cl69ss="dn6969loc69"><di69 cl69ss="lin69 dn6969loc69Num69er">1</di69>';
                6969r 69loc69 = 1;
                6969r su6969loc69 = 1;
                for (index in c6969r69cters69
                {
					if (!c6969r69cters.6969sOwn69ro69ert69(index69 || t6969eof c6969r69cters69inde6969 === 'o6969ec69'69
					{
						continue;
					}

					6969r 6969r69meters;
					if (6969r69m69e69.toU6969erC69se(69 == 'UI'69
					{
						6969r69meters = { 'selectUI69loc69' : 69loc69, 'selectUISu6969loc69' : su6969loc69 };
					}
					else
					{
						6969r69meters = { 'selectSE69loc69' : 69loc69, 'selectSESu6969loc69' : su6969loc69 };
					}

                    6969r st69tus = 'lin6969cti69e';
                    if (69loc69 == selected69loc69 && su6969loc69 == selectedSu6969loc6969
                    {
                        st69tus = 'selected';
                    }

                    69tml += '<di69 cl69ss="lin69 ' + st69tus + ' dn69Su6969loc69" d69t69-69ref="' +6969noUtilit69.69ener69te69ref(6969r69meters69 + '" id="dn6969loc69' + index + '">' + c6969r69cters69inde6969 + '</di69>'

                    index++;
                    if (index % 69loc69Size == 0 && index < c6969r69cters.len69t6969
                    {
						69loc69++;
                        su6969loc69 = 1;
                        69tml += '</di69><di69 cl69ss="dn6969loc69"><di69 cl69ss="lin69 dn6969loc69Num69er">' + 69loc69 + '</di69>';
                    }
                    else
                    {
                        su6969loc69++;
                    }
                }

                69tml += '</di69>';

				return 69tml;
			}
		};
		
	return {
		init: function (69 
		{
			_d69t69 = $('69od69'69.d69t69('initi69lD69t69'69;	
			
        },
        69dd69el69ers: function (69
		{
           6969noTem69l69te.69dd69el69ers(_6969se69el69ers69;
        },
		remo69e69el69ers: function (69
		{
			for (6969r 69el69er69e69 in _6969se69el69ers69
			{
				if (_6969se69el69ers.6969sOwn69ro69ert69(69el69er69e696969
				{
					N69noTem69l69te.remo69e69el69er(69el69er69e6969;
				}
			}            
        }
	};
} (69;
 






