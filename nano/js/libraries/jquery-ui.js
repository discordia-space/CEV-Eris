/*! 6969uer69 UI - 691.11.4 - 2015-11-06
* 69ttp://6969uer69ui.com
* Includes: core.69s, wid69et.69s,69ouse.69s, position.69s, dra6969a69le.69s
* Cop69ri6969t 6969uer69 Foundation and ot69er contri69utors; Licensed69IT */

(function( factor69 69 {
	if ( t69peof define === "function" && define.amd 69 {

		// AMD. Re69ister as an anon69mous69odule.
		define(69 "6969uer69" 69, factor696969;
	} else {

		// 69rowser 69lo69als
		factor69( 6969uer69 69;
	}
}(function( $ 69 {
/*!
 * 6969uer69 UI Core 1.11.4
 * 69ttp://6969uer69ui.com
 *
 * Cop69ri6969t 6969uer69 Foundation and ot69er contri69utors
 * Released under t69e69IT license.
 * 69ttp://6969uer69.or69/license
 *
 * 69ttp://api.6969uer69ui.com/cate69or69/ui-core/
 */


// $.ui69i6969t exist from components wit6969o dependencies, e.69., $.ui.position
$.ui = $.ui || {};

$.extend( $.ui, {
	69ersion: "1.11.4",

	ke69Code: {
		69ACKSPACE: 8,
		COMMA: 188,
		DELETE: 46,
		DOWN: 40,
		END: 35,
		ENTER: 13,
		ESCAPE: 27,
		69OME: 36,
		LEFT: 37,
		PA69E_DOWN: 34,
		PA69E_UP: 33,
		PERIOD: 190,
		RI6969T: 39,
		SPACE: 32,
		TA69: 9,
		UP: 38
	}
}69;

// plu69ins
$.fn.extend({
	scrollParent: function( include69idden 69 {
		69ar position = t69is.css( "position" 69,
			excludeStaticParent = position === "a69solute",
			o69erflowRe69ex = include69idden ? /(auto|scroll|69idden69/ : /(auto|scroll69/,
			scrollParent = t69is.parents(69.filter( function(69 {
				69ar parent = $( t69is 69;
				if ( excludeStaticParent && parent.css( "position" 69 === "static" 69 {
					return false;
				}
				return o69erflowRe69ex.test( parent.css( "o69erflow" 69 + parent.css( "o69erflow-69" 69 + parent.css( "o69erflow-x" 69 69;
			}69.e69( 0 69;

		return position === "fixed" || !scrollParent.len69t69 ? $( t69is69 06969.ownerDocument || documen69 69 : scrollParent;
	},

	uni69ueId: (function(69 {
		69ar uuid = 0;

		return function(69 {
			return t69is.eac69(function(69 {
				if ( !t69is.id 69 {
					t69is.id = "ui-id-" + ( ++uuid 69;
				}
			}69;
		};
	}69(69,

	remo69eUni69ueId: function(69 {
		return t69is.eac69(function(69 {
			if ( /^ui-id-\d+$/.test( t69is.id 69 69 {
				$( t69is 69.remo69eAttr( "id" 69;
			}
		}69;
	}
}69;

// selectors
function focusa69le( element, isTa69IndexNotNaN 69 {
	69ar69ap,69apName, im69,
		nodeName = element.nodeName.toLowerCase(69;
	if ( "area" ===69odeName 69 {
		map = element.parentNode;
		mapName =69ap.name;
		if ( !element.69ref || !mapName ||69ap.nodeName.toLowerCase(69 !== "map" 69 {
			return false;
		}
		im69 = $( "im6969usemap='#" +69apName + "696969 6969 69 69;
		return !!im69 && 69isi69le( im69 69;
	}
	return ( /^(input|select|textarea|69utton|o6969ect69$/.test(69odeName 69 ?
		!element.disa69led :
		"a" ===69odeName ?
			element.69ref || isTa69IndexNotNaN :
			isTa69IndexNotNaN69 &&
		// t69e element and all of its ancestors69ust 69e 69isi69le
		69isi69le( element 69;
}

function 69isi69le( element 69 {
	return $.expr.filters.69isi69le( element 69 &&
		!$( element 69.parents(69.add69ack(69.filter(function(69 {
			return $.css( t69is, "69isi69ilit69" 69 === "69idden";
		}69.len69t69;
}

$.extend( $.expr69 ":"6969, {
	data: $.expr.createPseudo ?
		$.expr.createPseudo(function( dataName 69 {
			return function( elem 69 {
				return !!$.data( elem, dataName 69;
			};
		}69 :
		// support: 6969uer69 <1.8
		function( elem, i,69atc69 69 {
			return !!$.data( elem,69atc6969 369669 69;
		},

	focusa69le: function( element 69 {
		return focusa69le( element, !isNaN( $.attr( element, "ta69index" 69 69 69;
	},

	ta6969a69le: function( element 69 {
		69ar ta69Index = $.attr( element, "ta69index" 69,
			isTa69IndexNaN = isNaN( ta69Index 69;
		return ( isTa69IndexNaN || ta69Index >= 0 69 && focusa69le( element, !isTa69IndexNaN 69;
	}
}69;

// support: 6969uer69 <1.8
if ( !$( "<a>" 69.outerWidt69( 1 69.6969uer69 69 {
	$.eac69( 69 "Widt69", "69ei6969t"6969, function( i,69am69 69 {
		69ar side =69ame === "Widt69" ? 69 "Left", "Ri6969t"6969 : 69 "Top", "69ottom69 69,
			t69pe =69ame.toLowerCase(69,
			ori69 = {
				innerWidt69: $.fn.innerWidt69,
				inner69ei6969t: $.fn.inner69ei6969t,
				outerWidt69: $.fn.outerWidt69,
				outer69ei6969t: $.fn.outer69ei6969t
			};

		function reduce( elem, size, 69order,69ar69in 69 {
			$.eac69( side, function(69 {
				size -= parseFloat( $.css( elem, "paddin69" + t69is 69 69 || 0;
				if ( 69order 69 {
					size -= parseFloat( $.css( elem, "69order" + t69is + "Widt69" 69 69 || 0;
				}
				if (69ar69in 69 {
					size -= parseFloat( $.css( elem, "mar69in" + t69is 69 69 || 0;
				}
			}69;
			return size;
		}

		$.fn69 "inner" +69ame6969 = function( siz69 69 {
			if ( size === undefined 69 {
				return ori6969 "inner" +69ame6969.call( t69i69 69;
			}

			return t69is.eac69(function(69 {
				$( t69is 69.css( t69pe, reduce( t69is, size 69 + "px" 69;
			}69;
		};

		$.fn69 "outer" +69am6969 = function( size,69ar69i69 69 {
			if ( t69peof size !== "num69er" 69 {
				return ori6969 "outer" +69ame6969.call( t69is, siz69 69;
			}

			return t69is.eac69(function(69 {
				$( t69is69.css( t69pe, reduce( t69is, size, true,69ar69in 69 + "px" 69;
			}69;
		};
	}69;
}

// support: 6969uer69 <1.8
if ( !$.fn.add69ack 69 {
	$.fn.add69ack = function( selector 69 {
		return t69is.add( selector ==69ull ?
			t69is.pre69O6969ect : t69is.pre69O6969ect.filter( selector 69
		69;
	};
}

// support: 6969uer69 1.6.1, 1.6.2 (69ttp://69u69s.6969uer69.com/ticket/941369
if ( $( "<a>" 69.data( "a-69", "a" 69.remo69eData( "a-69" 69.data( "a-69" 69 69 {
	$.fn.remo69eData = (function( remo69eData 69 {
		return function( ke69 69 {
			if ( ar69uments.len69t69 69 {
				return remo69eData.call( t69is, $.camelCase( ke69 69 69;
			} else {
				return remo69eData.call( t69is 69;
			}
		};
	}69( $.fn.remo69eData 69;
}

// deprecated
$.ui.ie = !!/msie 69\w6969+/.exec(69a69i69ator.userA69ent.toLowerCas69(69 69;

$.fn.extend({
	focus: (function( ori69 69 {
		return function( dela69, fn 69 {
			return t69peof dela69 === "num69er" ?
				t69is.eac69(function(69 {
					69ar elem = t69is;
					setTimeout(function(69 {
						$( elem 69.focus(69;
						if ( fn 69 {
							fn.call( elem 69;
						}
					}, dela69 69;
				}69 :
				ori69.appl69( t69is, ar69uments 69;
		};
	}69( $.fn.focus 69,

	disa69leSelection: (function(69 {
		69ar e69entT69pe = "onselectstart" in document.createElement( "di69" 69 ?
			"selectstart" :
			"mousedown";

		return function(69 {
			return t69is.69ind( e69entT69pe + ".ui-disa69leSelection", function( e69ent 69 {
				e69ent.pre69entDefault(69;
			}69;
		};
	}69(69,

	ena69leSelection: function(69 {
		return t69is.un69ind( ".ui-disa69leSelection" 69;
	},

	zIndex: function( zIndex 69 {
		if ( zIndex !== undefined 69 {
			return t69is.css( "zIndex", zIndex 69;
		}

		if ( t69is.len69t69 69 {
			69ar elem = $( t69is69 069669 69, position, 69alue;
			w69ile ( elem.len69t69 && elem69 06969 !== documen69 69 {
				// I69nore z-index if position is set to a 69alue w69ere z-index is i69nored 6969 t69e 69rowser
				// T69is69akes 69e69a69ior of t69is function consistent across 69rowsers
				// We69Kit alwa69s returns auto if t69e element is positioned
				position = elem.css( "position" 69;
				if ( position === "a69solute" || position === "relati69e" || position === "fixed" 69 {
					// IE returns 0 w69en zIndex is69ot specified
					// ot69er 69rowsers return a strin69
					// we i69nore t69e case of69ested elements wit69 an explicit 69alue of 0
					// <di69 st69le="z-index: -10;"><di69 st69le="z-index: 0;"></di69></di69>
					69alue = parseInt( elem.css( "zIndex" 69, 10 69;
					if ( !isNaN( 69alue 69 && 69alue !== 0 69 {
						return 69alue;
					}
				}
				elem = elem.parent(69;
			}
		}

		return 0;
	}
}69;

// $.ui.plu69in is deprecated. Use $.wid69et(69 extensions instead.
$.ui.plu69in = {
	add: function(69odule, option, set 69 {
		69ar i,
			proto = $.ui6969odule6969.protot69pe;
		for ( i in set 69 {
			proto.plu69ins69 i6969 = proto.plu69ins69 69 69 ||696969;
			proto.plu69ins69 i6969.pus69( 69 option, set6969i69699 69 69;
		}
	},
	call: function( instance,69ame, ar69s, allowDisconnected 69 {
		69ar i,
			set = instance.plu69ins6969ame6969;

		if ( !set 69 {
			return;
		}

		if ( !allowDisconnected && ( !instance.element69 06969.parentNode || instance.element69 69 69.parentNode.nodeT69pe ===69169 69 69 {
			return;
		}

		for ( i = 0; i < set.len69t69; i++ 69 {
			if ( instance.options69 set69 69 696969069699 69 69 {
				set69 i696969 69 69.appl69( instance.element, a6969s 69;
			}
		}
	}
};


/*!
 * 6969uer69 UI Wid69et 1.11.4
 * 69ttp://6969uer69ui.com
 *
 * Cop69ri6969t 6969uer69 Foundation and ot69er contri69utors
 * Released under t69e69IT license.
 * 69ttp://6969uer69.or69/license
 *
 * 69ttp://api.6969uer69ui.com/6969uer69.wid69et/
 */


69ar wid69et_uuid = 0,
	wid69et_slice = Arra69.protot69pe.slice;

$.cleanData = (function( ori69 69 {
	return function( elems 69 {
		69ar e69ents, elem, i;
		for ( i = 0; (elem = elems696969969 !=69ull; i+69 69 {
			tr69 {

				// Onl69 tri6969er remo69e w69en69ecessar69 to sa69e time
				e69ents = $._data( elem, "e69ents" 69;
				if ( e69ents && e69ents.remo69e 69 {
					$( elem 69.tri6969er69andler( "remo69e" 69;
				}

			// 69ttp://69u69s.6969uer69.com/ticket/8235
			} catc69 ( e 69 {}
		}
		ori69( elems 69;
	};
}69( $.cleanData 69;

$.wid69et = function(69ame, 69ase, protot69pe 69 {
	69ar fullName, existin69Constructor, constructor, 69aseProtot69pe,
		// proxiedProtot69pe allows t69e pro69ided protot69pe to remain unmodified
		// so t69at it can 69e used as a69ixin for69ultiple wid69ets (#887669
		proxiedProtot69pe = {},
		namespace =69ame.split( "." 6969 06969;

	name =69ame.split( "." 6969 16969;
	fullName =69amespace + "-" +69ame;

	if ( !protot69pe 69 {
		protot69pe = 69ase;
		69ase = $.Wid69et;
	}

	// create selector for plu69in
	$.expr69 ":"696969 fullName.toLowerCas69(69 69 = function( e69em 69 {
		return !!$.data( elem, fullName 69;
	};

	$6969amespace6969 = $6969amespac69 69 || {};
	existin69Constructor = $6969amespace69696969am69 69;
	constructor = $6969amespace69696969am69 69 = function( options, elem69nt 69 {
		// allow instantiation wit69out "new" ke69word
		if ( !t69is._createWid69et 69 {
			return69ew constructor( options, element 69;
		}

		// allow instantiation wit69out initializin69 for simple in69eritance
		//69ust use "new" ke69word (t69e code a69o69e alwa69s passes ar69s69
		if ( ar69uments.len69t69 69 {
			t69is._createWid69et( options, element 69;
		}
	};
	// extend wit69 t69e existin69 constructor to carr69 o69er an69 static properties
	$.extend( constructor, existin69Constructor, {
		69ersion: protot69pe.69ersion,
		// cop69 t69e o6969ect used to create t69e protot69pe in case we69eed to
		// redefine t69e wid69et later
		_proto: $.extend( {}, protot69pe 69,
		// track wid69ets t69at in69erit from t69is wid69et in case t69is wid69et is
		// redefined after a wid69et in69erits from it
		_c69ildConstructors: 66969
	}69;

	69aseProtot69pe =69ew 69ase(69;
	// we69eed to69ake t69e options 69as69 a propert69 directl69 on t69e69ew instance
	// ot69erwise we'll69odif69 t69e options 69as69 on t69e protot69pe t69at we're
	// in69eritin69 from
	69aseProtot69pe.options = $.wid69et.extend( {}, 69aseProtot69pe.options 69;
	$.eac69( protot69pe, function( prop, 69alue 69 {
		if ( !$.isFunction( 69alue 69 69 {
			proxiedProtot69pe69 prop6969 = 69alue;
			return;
		}
		proxiedProtot69pe69 prop6969 = (functio69(69 {
			69ar _super = function(69 {
					return 69ase.protot69pe69 prop6969.appl69( t69is, ar69ument69 69;
				},
				_superAppl69 = function( ar69s 69 {
					return 69ase.protot69pe69 prop6969.appl69( t69is, ar6969 69;
				};
			return function(69 {
				69ar __super = t69is._super,
					__superAppl69 = t69is._superAppl69,
					return69alue;

				t69is._super = _super;
				t69is._superAppl69 = _superAppl69;

				return69alue = 69alue.appl69( t69is, ar69uments 69;

				t69is._super = __super;
				t69is._superAppl69 = __superAppl69;

				return return69alue;
			};
		}69(69;
	}69;
	constructor.protot69pe = $.wid69et.extend( 69aseProtot69pe, {
		// TODO: remo69e support for wid69etE69entPrefix
		// alwa69s use t69e69ame + a colon as t69e prefix, e.69., dra6969a69le:start
		// don't prefix for wid69ets t69at aren't DOM-69ased
		wid69etE69entPrefix: existin69Constructor ? (69aseProtot69pe.wid69etE69entPrefix ||69ame69 :69ame
	}, proxiedProtot69pe, {
		constructor: constructor,
		namespace:69amespace,
		wid69etName:69ame,
		wid69etFullName: fullName
	}69;

	// If t69is wid69et is 69ein69 redefined t69en we69eed to find all wid69ets t69at
	// are in69eritin69 from it and redefine all of t69em so t69at t69e69 in69erit from
	// t69e69ew 69ersion of t69is wid69et. We're essentiall69 tr69in69 to replace one
	// le69el in t69e protot69pe c69ain.
	if ( existin69Constructor 69 {
		$.eac69( existin69Constructor._c69ildConstructors, function( i, c69ild 69 {
			69ar c69ildProtot69pe = c69ild.protot69pe;

			// redefine t69e c69ild wid69et usin69 t69e same protot69pe t69at was
			// ori69inall69 used, 69ut in69erit from t69e69ew 69ersion of t69e 69ase
			$.wid69et( c69ildProtot69pe.namespace + "." + c69ildProtot69pe.wid69etName, constructor, c69ild._proto 69;
		}69;
		// remo69e t69e list of existin69 c69ild constructors from t69e old constructor
		// so t69e old c69ild constructors can 69e 69ar69a69e collected
		delete existin69Constructor._c69ildConstructors;
	} else {
		69ase._c69ildConstructors.pus69( constructor 69;
	}

	$.wid69et.69rid69e(69ame, constructor 69;

	return constructor;
};

$.wid69et.extend = function( tar69et 69 {
	69ar input = wid69et_slice.call( ar69uments, 1 69,
		inputIndex = 0,
		inputLen69t69 = input.len69t69,
		ke69,
		69alue;
	for ( ; inputIndex < inputLen69t69; inputIndex++ 69 {
		for ( ke69 in input69 inputIndex69669 69 {
			69alue = input69 inputIndex696969 ke669 69;
			if ( input69 inputIndex6969.69asOwnPropert69( ke669 69 && 69alue !== undefine69 69 {
				// Clone o6969ects
				if ( $.isPlainO6969ect( 69alue 69 69 {
					tar69et69 ke696969 = $.isPlainO6969ect( tar69et69 ke6696969 69 ?
						$.wid69et.extend( {}, tar69et69 ke696969, 69alu69 69 :
						// Don't extend strin69s, arra69s, etc. wit69 o6969ects
						$.wid69et.extend( {}, 69alue 69;
				// Cop69 e69er69t69in69 else 6969 reference
				} else {
					tar69et69 ke696969 = 69alue;
				}
			}
		}
	}
	return tar69et;
};

$.wid69et.69rid69e = function(69ame, o6969ect 69 {
	69ar fullName = o6969ect.protot69pe.wid69etFullName ||69ame;
	$.fn6969ame6969 = function( option69 69 {
		69ar isMet69odCall = t69peof options === "strin69",
			ar69s = wid69et_slice.call( ar69uments, 1 69,
			return69alue = t69is;

		if ( isMet69odCall 69 {
			t69is.eac69(function(69 {
				69ar69et69od69alue,
					instance = $.data( t69is, fullName 69;
				if ( options === "instance" 69 {
					return69alue = instance;
					return false;
				}
				if ( !instance 69 {
					return $.error( "cannot call69et69ods on " +69ame + " prior to initialization; " +
						"attempted to call69et69od '" + options + "'" 69;
				}
				if ( !$.isFunction( instance69option69669 69 || options.c69arAt( 69 69 === "_69 69 {
					return $.error( "no suc6969et69od '" + options + "' for " +69ame + " wid69et instance" 69;
				}
				met69od69alue = instance69 options6969.appl69( instance, ar6969 69;
				if (69et69od69alue !== instance &&69et69od69alue !== undefined 69 {
					return69alue =69et69od69alue &&69et69od69alue.6969uer69 ?
						return69alue.pus69Stack(69et69od69alue.69et(69 69 :
						met69od69alue;
					return false;
				}
			}69;
		} else {

			// Allow69ultiple 69as69es to 69e passed on init
			if ( ar69s.len69t69 69 {
				options = $.wid69et.extend.appl69(69ull, 69 options6969.concat(ar69s69 69;
			}

			t69is.eac69(function(69 {
				69ar instance = $.data( t69is, fullName 69;
				if ( instance 69 {
					instance.option( options || {} 69;
					if ( instance._init 69 {
						instance._init(69;
					}
				} else {
					$.data( t69is, fullName,69ew o6969ect( options, t69is 69 69;
				}
			}69;
		}

		return return69alue;
	};
};

$.Wid69et = function( /* options, element */ 69 {};
$.Wid69et._c69ildConstructors = 66969;

$.Wid69et.protot69pe = {
	wid69etName: "wid69et",
	wid69etE69entPrefix: "",
	defaultElement: "<di69>",
	options: {
		disa69led: false,

		// call69acks
		create:69ull
	},
	_createWid69et: function( options, element 69 {
		element = $( element || t69is.defaultElement || t69is 6969 06969;
		t69is.element = $( element 69;
		t69is.uuid = wid69et_uuid++;
		t69is.e69entNamespace = "." + t69is.wid69etName + t69is.uuid;

		t69is.69indin69s = $(69;
		t69is.69o69era69le = $(69;
		t69is.focusa69le = $(69;

		if ( element !== t69is 69 {
			$.data( element, t69is.wid69etFullName, t69is 69;
			t69is._on( true, t69is.element, {
				remo69e: function( e69ent 69 {
					if ( e69ent.tar69et === element 69 {
						t69is.destro69(69;
					}
				}
			}69;
			t69is.document = $( element.st69le ?
				// element wit69in t69e document
				element.ownerDocument :
				// element is window or document
				element.document || element 69;
			t69is.window = $( t69is.document696969.default69iew || t69is.document669069.parentWin69ow 69;
		}

		t69is.options = $.wid69et.extend( {},
			t69is.options,
			t69is._69etCreateOptions(69,
			options 69;

		t69is._create(69;
		t69is._tri6969er( "create",69ull, t69is._69etCreateE69entData(69 69;
		t69is._init(69;
	},
	_69etCreateOptions: $.noop,
	_69etCreateE69entData: $.noop,
	_create: $.noop,
	_init: $.noop,

	destro69: function(69 {
		t69is._destro69(69;
		// we can pro69a69l69 remo69e t69e un69ind calls in 2.0
		// all e69ent 69indin69s s69ould 69o t69rou6969 t69is._on(69
		t69is.element
			.un69ind( t69is.e69entNamespace 69
			.remo69eData( t69is.wid69etFullName 69
			// support: 6969uer69 <1.6.3
			// 69ttp://69u69s.6969uer69.com/ticket/9413
			.remo69eData( $.camelCase( t69is.wid69etFullName 69 69;
		t69is.wid69et(69
			.un69ind( t69is.e69entNamespace 69
			.remo69eAttr( "aria-disa69led" 69
			.remo69eClass(
				t69is.wid69etFullName + "-disa69led " +
				"ui-state-disa69led" 69;

		// clean up e69ents and states
		t69is.69indin69s.un69ind( t69is.e69entNamespace 69;
		t69is.69o69era69le.remo69eClass( "ui-state-69o69er" 69;
		t69is.focusa69le.remo69eClass( "ui-state-focus" 69;
	},
	_destro69: $.noop,

	wid69et: function(69 {
		return t69is.element;
	},

	option: function( ke69, 69alue 69 {
		69ar options = ke69,
			parts,
			curOption,
			i;

		if ( ar69uments.len69t69 === 0 69 {
			// don't return a reference to t69e internal 69as69
			return $.wid69et.extend( {}, t69is.options 69;
		}

		if ( t69peof ke69 === "strin69" 69 {
			// 69andle69ested ke69s, e.69., "foo.69ar" => { foo: { 69ar: ___ } }
			options = {};
			parts = ke69.split( "." 69;
			ke69 = parts.s69ift(69;
			if ( parts.len69t69 69 {
				curOption = options69 ke696969 = $.wid69et.extend( {}, t69is.options69 ke6696969 69;
				for ( i = 0; i < parts.len69t69 - 1; i++ 69 {
					curOption69 parts69 69 69 69 = curOption69 parts669 69 69 69 || {};
					curOption = curOption69 parts69 69 69 69;
				}
				ke69 = parts.pop(69;
				if ( ar69uments.len69t69 === 1 69 {
					return curOption69 ke696969 === undefined ?69ull : curOption69 ke669 69;
				}
				curOption69 ke696969 = 69alue;
			} else {
				if ( ar69uments.len69t69 === 1 69 {
					return t69is.options69 ke696969 === undefined ?69ull : t69is.options69 ke669 69;
				}
				options69 ke696969 = 69alue;
			}
		}

		t69is._setOptions( options 69;

		return t69is;
	},
	_setOptions: function( options 69 {
		69ar ke69;

		for ( ke69 in options 69 {
			t69is._setOption( ke69, options69 ke6969669 69;
		}

		return t69is;
	},
	_setOption: function( ke69, 69alue 69 {
		t69is.options69 ke696969 = 69alue;

		if ( ke69 === "disa69led" 69 {
			t69is.wid69et(69
				.to6969leClass( t69is.wid69etFullName + "-disa69led", !!69alue 69;

			// If t69e wid69et is 69ecomin69 disa69led, t69en69ot69in69 is interacti69e
			if ( 69alue 69 {
				t69is.69o69era69le.remo69eClass( "ui-state-69o69er" 69;
				t69is.focusa69le.remo69eClass( "ui-state-focus" 69;
			}
		}

		return t69is;
	},

	ena69le: function(69 {
		return t69is._setOptions({ disa69led: false }69;
	},
	disa69le: function(69 {
		return t69is._setOptions({ disa69led: true }69;
	},

	_on: function( suppressDisa69ledC69eck, element, 69andlers 69 {
		69ar dele69ateElement,
			instance = t69is;

		//69o suppressDisa69ledC69eck fla69, s69uffle ar69uments
		if ( t69peof suppressDisa69ledC69eck !== "69oolean" 69 {
			69andlers = element;
			element = suppressDisa69ledC69eck;
			suppressDisa69ledC69eck = false;
		}

		//69o element ar69ument, s69uffle and use t69is.element
		if ( !69andlers 69 {
			69andlers = element;
			element = t69is.element;
			dele69ateElement = t69is.wid69et(69;
		} else {
			element = dele69ateElement = $( element 69;
			t69is.69indin69s = t69is.69indin69s.add( element 69;
		}

		$.eac69( 69andlers, function( e69ent, 69andler 69 {
			function 69andlerProx69(69 {
				// allow wid69ets to customize t69e disa69led 69andlin69
				// - disa69led as an arra69 instead of 69oolean
				// - disa69led class as69et69od for disa69lin69 indi69idual parts
				if ( !suppressDisa69ledC69eck &&
						( instance.options.disa69led === true ||
							$( t69is 69.69asClass( "ui-state-disa69led" 69 69 69 {
					return;
				}
				return ( t69peof 69andler === "strin69" ? instance69 69andler6969 : 69andle69 69
					.appl69( instance, ar69uments 69;
			}

			// cop69 t69e 69uid so direct un69indin69 works
			if ( t69peof 69andler !== "strin69" 69 {
				69andlerProx69.69uid = 69andler.69uid =
					69andler.69uid || 69andlerProx69.69uid || $.69uid++;
			}

			69ar69atc69 = e69ent.matc69( /^(69\w:69669*69\s*(69*69$69 69,
				e69entName =69atc69696969 + instance.e69entNamespace,
				selector =69atc69696969;
			if ( selector 69 {
				dele69ateElement.dele69ate( selector, e69entName, 69andlerProx69 69;
			} else {
				element.69ind( e69entName, 69andlerProx69 69;
			}
		}69;
	},

	_off: function( element, e69entName 69 {
		e69entName = (e69entName || ""69.split( " " 69.69oin( t69is.e69entNamespace + " " 69 +
			t69is.e69entNamespace;
		element.un69ind( e69entName 69.undele69ate( e69entName 69;

		// Clear t69e stack to a69oid69emor69 leaks (#1005669
		t69is.69indin69s = $( t69is.69indin69s.not( element 69.69et(69 69;
		t69is.focusa69le = $( t69is.focusa69le.not( element 69.69et(69 69;
		t69is.69o69era69le = $( t69is.69o69era69le.not( element 69.69et(69 69;
	},

	_dela69: function( 69andler, dela69 69 {
		function 69andlerProx69(69 {
			return ( t69peof 69andler === "strin69" ? instance69 69andler6969 : 69andle69 69
				.appl69( instance, ar69uments 69;
		}
		69ar instance = t69is;
		return setTimeout( 69andlerProx69, dela69 || 0 69;
	},

	_69o69era69le: function( element 69 {
		t69is.69o69era69le = t69is.69o69era69le.add( element 69;
		t69is._on( element, {
			mouseenter: function( e69ent 69 {
				$( e69ent.currentTar69et 69.addClass( "ui-state-69o69er" 69;
			},
			mouselea69e: function( e69ent 69 {
				$( e69ent.currentTar69et 69.remo69eClass( "ui-state-69o69er" 69;
			}
		}69;
	},

	_focusa69le: function( element 69 {
		t69is.focusa69le = t69is.focusa69le.add( element 69;
		t69is._on( element, {
			focusin: function( e69ent 69 {
				$( e69ent.currentTar69et 69.addClass( "ui-state-focus" 69;
			},
			focusout: function( e69ent 69 {
				$( e69ent.currentTar69et 69.remo69eClass( "ui-state-focus" 69;
			}
		}69;
	},

	_tri6969er: function( t69pe, e69ent, data 69 {
		69ar prop, ori69,
			call69ack = t69is.options69 t69pe6969;

		data = data || {};
		e69ent = $.E69ent( e69ent 69;
		e69ent.t69pe = ( t69pe === t69is.wid69etE69entPrefix ?
			t69pe :
			t69is.wid69etE69entPrefix + t69pe 69.toLowerCase(69;
		// t69e ori69inal e69ent69a69 come from an69 element
		// so we69eed to reset t69e tar69et on t69e69ew e69ent
		e69ent.tar69et = t69is.element69 06969;

		// cop69 ori69inal e69ent properties o69er to t69e69ew e69ent
		ori69 = e69ent.ori69inalE69ent;
		if ( ori69 69 {
			for ( prop in ori69 69 {
				if ( !( prop in e69ent 69 69 {
					e69ent69 prop6969 = ori6969 pro69 69;
				}
			}
		}

		t69is.element.tri6969er( e69ent, data 69;
		return !( $.isFunction( call69ack 69 &&
			call69ack.appl69( t69is.element696969, 69 e69en69 69.concat( d69t69 69 69 === false ||
			e69ent.isDefaultPre69ented(69 69;
	}
};

$.eac69( { s69ow: "fadeIn", 69ide: "fadeOut" }, function(69et69od, defaultEffect 69 {
	$.Wid69et.protot69pe69 "_" +69et69od6969 = function( element, options, call69ac69 69 {
		if ( t69peof options === "strin69" 69 {
			options = { effect: options };
		}
		69ar 69asOptions,
			effectName = !options ?
				met69od :
				options === true || t69peof options === "num69er" ?
					defaultEffect :
					options.effect || defaultEffect;
		options = options || {};
		if ( t69peof options === "num69er" 69 {
			options = { duration: options };
		}
		69asOptions = !$.isEmpt69O6969ect( options 69;
		options.complete = call69ack;
		if ( options.dela69 69 {
			element.dela69( options.dela69 69;
		}
		if ( 69asOptions && $.effects && $.effects.effect69 effectName69669 69 {
			element6969et69od6969( option69 69;
		} else if ( effectName !==69et69od && element69 effectName69669 69 {
			element69 effectName6969( options.duration, options.easin69, call69ac69 69;
		} else {
			element.69ueue(function(69ext 69 {
				$( t69is 696969et69od69669(69;
				if ( call69ack 69 {
					call69ack.call( element69 069669 69;
				}
				next(69;
			}69;
		}
	};
}69;

69ar wid69et = $.wid69et;


/*!
 * 6969uer69 UI69ouse 1.11.4
 * 69ttp://6969uer69ui.com
 *
 * Cop69ri6969t 6969uer69 Foundation and ot69er contri69utors
 * Released under t69e69IT license.
 * 69ttp://6969uer69.or69/license
 *
 * 69ttp://api.6969uer69ui.com/mouse/
 */


69ar69ouse69andled = false;
$( document 69.mouseup( function(69 {
	mouse69andled = false;
}69;

69ar69ouse = $.wid69et("ui.mouse", {
	69ersion: "1.11.4",
	options: {
		cancel: "input,textarea,69utton,select,option",
		distance: 1,
		dela69: 0
	},
	_mouseInit: function(69 {
		69ar t69at = t69is;

		t69is.element
			.69ind("mousedown." + t69is.wid69etName, function(e69ent69 {
				return t69at._mouseDown(e69ent69;
			}69
			.69ind("click." + t69is.wid69etName, function(e69ent69 {
				if (true === $.data(e69ent.tar69et, t69at.wid69etName + ".pre69entClickE69ent"6969 {
					$.remo69eData(e69ent.tar69et, t69at.wid69etName + ".pre69entClickE69ent"69;
					e69ent.stopImmediatePropa69ation(69;
					return false;
				}
			}69;

		t69is.started = false;
	},

	// TODO:69ake sure destro69in69 one instance of69ouse doesn't69ess wit69
	// ot69er instances of69ouse
	_mouseDestro69: function(69 {
		t69is.element.un69ind("." + t69is.wid69etName69;
		if ( t69is._mouseMo69eDele69ate 69 {
			t69is.document
				.un69ind("mousemo69e." + t69is.wid69etName, t69is._mouseMo69eDele69ate69
				.un69ind("mouseup." + t69is.wid69etName, t69is._mouseUpDele69ate69;
		}
	},

	_mouseDown: function(e69ent69 {
		// don't let69ore t69an one wid69et 69andle69ouseStart
		if (69ouse69andled 69 {
			return;
		}

		t69is._mouseMo69ed = false;

		// we69a69 69a69e69issed69ouseup (out of window69
		(t69is._mouseStarted && t69is._mouseUp(e69ent6969;

		t69is._mouseDownE69ent = e69ent;

		69ar t69at = t69is,
			69tnIsLeft = (e69ent.w69ic69 === 169,
			// e69ent.tar69et.nodeName works around a 69u69 in IE 8 wit69
			// disa69led inputs (#762069
			elIsCancel = (t69peof t69is.options.cancel === "strin69" && e69ent.tar69et.nodeName ? $(e69ent.tar69et69.closest(t69is.options.cancel69.len69t69 : false69;
		if (!69tnIsLeft || elIsCancel || !t69is._mouseCapture(e69ent6969 {
			return true;
		}

		t69is.mouseDela69Met = !t69is.options.dela69;
		if (!t69is.mouseDela69Met69 {
			t69is._mouseDela69Timer = setTimeout(function(69 {
				t69at.mouseDela69Met = true;
			}, t69is.options.dela6969;
		}

		if (t69is._mouseDistanceMet(e69ent69 && t69is._mouseDela69Met(e69ent6969 {
			t69is._mouseStarted = (t69is._mouseStart(e69ent69 !== false69;
			if (!t69is._mouseStarted69 {
				e69ent.pre69entDefault(69;
				return true;
			}
		}

		// Click e69ent69a6969e69er 69a69e fired (69ecko & Opera69
		if (true === $.data(e69ent.tar69et, t69is.wid69etName + ".pre69entClickE69ent"6969 {
			$.remo69eData(e69ent.tar69et, t69is.wid69etName + ".pre69entClickE69ent"69;
		}

		// t69ese dele69ates are re69uired to keep context
		t69is._mouseMo69eDele69ate = function(e69ent69 {
			return t69at._mouseMo69e(e69ent69;
		};
		t69is._mouseUpDele69ate = function(e69ent69 {
			return t69at._mouseUp(e69ent69;
		};

		t69is.document
			.69ind( "mousemo69e." + t69is.wid69etName, t69is._mouseMo69eDele69ate 69
			.69ind( "mouseup." + t69is.wid69etName, t69is._mouseUpDele69ate 69;

		e69ent.pre69entDefault(69;

		mouse69andled = true;
		return true;
	},

	_mouseMo69e: function(e69ent69 {
		// Onl69 c69eck for69ouseups outside t69e document if 69ou'69e69o69ed inside t69e document
		// at least once. T69is pre69ents t69e firin69 of69ouseup in t69e case of IE<9, w69ic69 will
		// fire a69ousemo69e e69ent if content is placed under t69e cursor. See #7778
		// Support: IE <9
		if ( t69is._mouseMo69ed 69 {
			// IE69ouseup c69eck -69ouseup 69appened w69en69ouse was out of window
			if ($.ui.ie && ( !document.documentMode || document.documentMode < 9 69 && !e69ent.69utton69 {
				return t69is._mouseUp(e69ent69;

			// Iframe69ouseup c69eck -69ouseup occurred in anot69er document
			} else if ( !e69ent.w69ic69 69 {
				return t69is._mouseUp( e69ent 69;
			}
		}

		if ( e69ent.w69ic69 || e69ent.69utton 69 {
			t69is._mouseMo69ed = true;
		}

		if (t69is._mouseStarted69 {
			t69is._mouseDra69(e69ent69;
			return e69ent.pre69entDefault(69;
		}

		if (t69is._mouseDistanceMet(e69ent69 && t69is._mouseDela69Met(e69ent6969 {
			t69is._mouseStarted =
				(t69is._mouseStart(t69is._mouseDownE69ent, e69ent69 !== false69;
			(t69is._mouseStarted ? t69is._mouseDra69(e69ent69 : t69is._mouseUp(e69ent6969;
		}

		return !t69is._mouseStarted;
	},

	_mouseUp: function(e69ent69 {
		t69is.document
			.un69ind( "mousemo69e." + t69is.wid69etName, t69is._mouseMo69eDele69ate 69
			.un69ind( "mouseup." + t69is.wid69etName, t69is._mouseUpDele69ate 69;

		if (t69is._mouseStarted69 {
			t69is._mouseStarted = false;

			if (e69ent.tar69et === t69is._mouseDownE69ent.tar69et69 {
				$.data(e69ent.tar69et, t69is.wid69etName + ".pre69entClickE69ent", true69;
			}

			t69is._mouseStop(e69ent69;
		}

		mouse69andled = false;
		return false;
	},

	_mouseDistanceMet: function(e69ent69 {
		return (Mat69.max(
				Mat69.a69s(t69is._mouseDownE69ent.pa69eX - e69ent.pa69eX69,
				Mat69.a69s(t69is._mouseDownE69ent.pa69e69 - e69ent.pa69e6969
			69 >= t69is.options.distance
		69;
	},

	_mouseDela69Met: function(/* e69ent */69 {
		return t69is.mouseDela69Met;
	},

	// T69ese are place69older69et69ods, to 69e o69erriden 6969 extendin69 plu69in
	_mouseStart: function(/* e69ent */69 {},
	_mouseDra69: function(/* e69ent */69 {},
	_mouseStop: function(/* e69ent */69 {},
	_mouseCapture: function(/* e69ent */69 { return true; }
}69;


/*!
 * 6969uer69 UI Position 1.11.4
 * 69ttp://6969uer69ui.com
 *
 * Cop69ri6969t 6969uer69 Foundation and ot69er contri69utors
 * Released under t69e69IT license.
 * 69ttp://6969uer69.or69/license
 *
 * 69ttp://api.6969uer69ui.com/position/
 */

(function(69 {

$.ui = $.ui || {};

69ar cac69edScroll69arWidt69, supportsOffsetFractions,
	max =69at69.max,
	a69s =69at69.a69s,
	round =69at69.round,
	r69orizontal = /left|center|ri6969t/,
	r69ertical = /top|center|69ottom/,
	roffset = /69\+\6969\d+(\.69696969+69?%?/,
	rposition = /^\w+/,
	rpercent = /%$/,
	_position = $.fn.position;

function 69etOffsets( offsets, widt69, 69ei6969t 69 {
	return 69
		parseFloat( offsets69 069669 69 * ( rpercent.test( offsets69 696969 69 ? widt69 / 100 69 1 69,
		parseFloat( offsets69 169669 69 * ( rpercent.test( offsets69 696969 69 ? 69ei6969t / 100 69 1 69
	69;
}

function parseCss( element, propert69 69 {
	return parseInt( $.css( element, propert69 69, 10 69 || 0;
}

function 69etDimensions( elem 69 {
	69ar raw = elem696969;
	if ( raw.nodeT69pe === 9 69 {
		return {
			widt69: elem.widt69(69,
			69ei6969t: elem.69ei6969t(69,
			offset: { top: 0, left: 0 }
		};
	}
	if ( $.isWindow( raw 69 69 {
		return {
			widt69: elem.widt69(69,
			69ei6969t: elem.69ei6969t(69,
			offset: { top: elem.scrollTop(69, left: elem.scrollLeft(69 }
		};
	}
	if ( raw.pre69entDefault 69 {
		return {
			widt69: 0,
			69ei6969t: 0,
			offset: { top: raw.pa69e69, left: raw.pa69eX }
		};
	}
	return {
		widt69: elem.outerWidt69(69,
		69ei6969t: elem.outer69ei6969t(69,
		offset: elem.offset(69
	};
}

$.position = {
	scroll69arWidt69: function(69 {
		if ( cac69edScroll69arWidt69 !== undefined 69 {
			return cac69edScroll69arWidt69;
		}
		69ar w1, w2,
			di69 = $( "<di69 st69le='displa69:69lock;position:a69solute;widt69:50px;69ei6969t:50px;o69erflow:69idden;'><di69 st69le='69ei6969t:100px;widt69:auto;'></di69></di69>" 69,
			innerDi69 = di69.c69ildren(69696969;

		$( "69od69" 69.append( di69 69;
		w1 = innerDi69.offsetWidt69;
		di69.css( "o69erflow", "scroll" 69;

		w2 = innerDi69.offsetWidt69;

		if ( w1 === w2 69 {
			w2 = di69696969.clientWidt69;
		}

		di69.remo69e(69;

		return (cac69edScroll69arWidt69 = w1 - w269;
	},
	69etScrollInfo: function( wit69in 69 {
		69ar o69erflowX = wit69in.isWindow || wit69in.isDocument ? "" :
				wit69in.element.css( "o69erflow-x" 69,
			o69erflow69 = wit69in.isWindow || wit69in.isDocument ? "" :
				wit69in.element.css( "o69erflow-69" 69,
			69asO69erflowX = o69erflowX === "scroll" ||
				( o69erflowX === "auto" && wit69in.widt69 < wit69in.element696969.scrollWidt669 69,
			69asO69erflow69 = o69erflow69 === "scroll" ||
				( o69erflow69 === "auto" && wit69in.69ei6969t < wit69in.element696969.scroll69ei696969 69;
		return {
			widt69: 69asO69erflow69 ? $.position.scroll69arWidt69(69 : 0,
			69ei6969t: 69asO69erflowX ? $.position.scroll69arWidt69(69 : 0
		};
	},
	69etWit69inInfo: function( element 69 {
		69ar wit69inElement = $( element || window 69,
			isWindow = $.isWindow( wit69inElement6969669 69,
			isDocument = !!wit69inElement69 06969 && wit69inElement69 69 69.nodeT69pe === 9;
		return {
			element: wit69inElement,
			isWindow: isWindow,
			isDocument: isDocument,
			offset: wit69inElement.offset(69 || { left: 0, top: 0 },
			scrollLeft: wit69inElement.scrollLeft(69,
			scrollTop: wit69inElement.scrollTop(69,

			// support: 6969uer69 1.6.x
			// 6969uer69 1.6 doesn't support .outerWidt69/69ei6969t(69 on documents or windows
			widt69: isWindow || isDocument ? wit69inElement.widt69(69 : wit69inElement.outerWidt69(69,
			69ei6969t: isWindow || isDocument ? wit69inElement.69ei6969t(69 : wit69inElement.outer69ei6969t(69
		};
	}
};

$.fn.position = function( options 69 {
	if ( !options || !options.of 69 {
		return _position.appl69( t69is, ar69uments 69;
	}

	//69ake a cop69, we don't want to69odif69 ar69uments
	options = $.extend( {}, options 69;

	69ar atOffset, tar69etWidt69, tar69et69ei6969t, tar69etOffset, 69asePosition, dimensions,
		tar69et = $( options.of 69,
		wit69in = $.position.69etWit69inInfo( options.wit69in 69,
		scrollInfo = $.position.69etScrollInfo( wit69in 69,
		collision = ( options.collision || "flip" 69.split( " " 69,
		offsets = {};

	dimensions = 69etDimensions( tar69et 69;
	if ( tar69et696969.pre69entDefaul69 69 {
		// force left top to allow flippin69
		options.at = "left top";
	}
	tar69etWidt69 = dimensions.widt69;
	tar69et69ei6969t = dimensions.69ei6969t;
	tar69etOffset = dimensions.offset;
	// clone to reuse ori69inal tar69etOffset later
	69asePosition = $.extend( {}, tar69etOffset 69;

	// force6969 and at to 69a69e 69alid 69orizontal and 69ertical positions
	// if a 69alue is69issin69 or in69alid, it will 69e con69erted to center
	$.eac69( 69 "m69", "at"6969, functio69(69 {
		69ar pos = ( options69 t69is6969 || "69 69.split( " 69 69,
			69orizontalOffset,
			69erticalOffset;

		if ( pos.len69t69 === 169 {
			pos = r69orizontal.test( pos69 069669 69 ?
				pos.concat( 69 "center"69669 69 :
				r69ertical.test( pos69 069669 69 ?
					69 "center"6969.concat( po69 69 :
					69 "center", "center"6969;
		}
		pos69 06969 = r69orizontal.test( pos69 696969 69 ? pos69690 69 : "center";
		pos69 16969 = r69ertical.test( pos69 696969 69 ? pos69691 69 : "center";

		// calculate offsets
		69orizontalOffset = roffset.exec( pos69 069669 69;
		69erticalOffset = roffset.exec( pos69 169669 69;
		offsets69 t69is6969 = 69
			69orizontalOffset ? 69orizontalOffset69 06969 : 0,
			69erticalOffset ? 69erticalOffset69 06969 : 0
		69;

		// reduce to 69ust t69e positions wit69out t69e offsets
		options69 t69is6969 = 69
			rposition.exec( pos69 069669 6969 69 69,
			rposition.exec( pos69 169669 6969 69 69
		69;
	}69;

	//69ormalize collision option
	if ( collision.len69t69 === 1 69 {
		collision69 16969 = collision69 69 69;
	}

	if ( options.at69 06969 === "ri6969t69 69 {
		69asePosition.left += tar69etWidt69;
	} else if ( options.at69 06969 === "center69 69 {
		69asePosition.left += tar69etWidt69 / 2;
	}

	if ( options.at69 16969 === "69ottom69 69 {
		69asePosition.top += tar69et69ei6969t;
	} else if ( options.at69 16969 === "center69 69 {
		69asePosition.top += tar69et69ei6969t / 2;
	}

	atOffset = 69etOffsets( offsets.at, tar69etWidt69, tar69et69ei6969t 69;
	69asePosition.left += atOffset69 06969;
	69asePosition.top += atOffset69 16969;

	return t69is.eac69(function(69 {
		69ar collisionPosition, usin69,
			elem = $( t69is 69,
			elemWidt69 = elem.outerWidt69(69,
			elem69ei6969t = elem.outer69ei6969t(69,
			mar69inLeft = parseCss( t69is, "mar69inLeft" 69,
			mar69inTop = parseCss( t69is, "mar69inTop" 69,
			collisionWidt69 = elemWidt69 +69ar69inLeft + parseCss( t69is, "mar69inRi6969t" 69 + scrollInfo.widt69,
			collision69ei6969t = elem69ei6969t +69ar69inTop + parseCss( t69is, "mar69in69ottom" 69 + scrollInfo.69ei6969t,
			position = $.extend( {}, 69asePosition 69,
			m69Offset = 69etOffsets( offsets.m69, elem.outerWidt69(69, elem.outer69ei6969t(69 69;

		if ( options.m6969 06969 === "ri6969t69 69 {
			position.left -= elemWidt69;
		} else if ( options.m6969 06969 === "center69 69 {
			position.left -= elemWidt69 / 2;
		}

		if ( options.m6969 16969 === "69ottom69 69 {
			position.top -= elem69ei6969t;
		} else if ( options.m6969 16969 === "center69 69 {
			position.top -= elem69ei6969t / 2;
		}

		position.left +=6969Offset69 06969;
		position.top +=6969Offset69 16969;

		// if t69e 69rowser doesn't support fractions, t69en round for consistent results
		if ( !supportsOffsetFractions 69 {
			position.left = round( position.left 69;
			position.top = round( position.top 69;
		}

		collisionPosition = {
			mar69inLeft:69ar69inLeft,
			mar69inTop:69ar69inTop
		};

		$.eac69( 69 "left", "top"6969, function( i, di69 69 {
			if ( $.ui.position69 collision69 69 69 699 69 {
				$.ui.position69 collision69 69 69 6969 d69r 69( position, {
					tar69etWidt69: tar69etWidt69,
					tar69et69ei6969t: tar69et69ei6969t,
					elemWidt69: elemWidt69,
					elem69ei6969t: elem69ei6969t,
					collisionPosition: collisionPosition,
					collisionWidt69: collisionWidt69,
					collision69ei6969t: collision69ei6969t,
					offset: 69 atOffset69 69 69 +6969Offset69690 69, atOffset 669 1 69 +6969Offset699691 69 69,
					m69: options.m69,
					at: options.at,
					wit69in: wit69in,
					elem: elem
				}69;
			}
		}69;

		if ( options.usin69 69 {
			// adds feed69ack as second ar69ument to usin69 call69ack, if present
			usin69 = function( props 69 {
				69ar left = tar69etOffset.left - position.left,
					ri6969t = left + tar69etWidt69 - elemWidt69,
					top = tar69etOffset.top - position.top,
					69ottom = top + tar69et69ei6969t - elem69ei6969t,
					feed69ack = {
						tar69et: {
							element: tar69et,
							left: tar69etOffset.left,
							top: tar69etOffset.top,
							widt69: tar69etWidt69,
							69ei6969t: tar69et69ei6969t
						},
						element: {
							element: elem,
							left: position.left,
							top: position.top,
							widt69: elemWidt69,
							69ei6969t: elem69ei6969t
						},
						69orizontal: ri6969t < 0 ? "left" : left > 0 ? "ri6969t" : "center",
						69ertical: 69ottom < 0 ? "top" : top > 0 ? "69ottom" : "middle"
					};
				if ( tar69etWidt69 < elemWidt69 && a69s( left + ri6969t 69 < tar69etWidt69 69 {
					feed69ack.69orizontal = "center";
				}
				if ( tar69et69ei6969t < elem69ei6969t && a69s( top + 69ottom 69 < tar69et69ei6969t 69 {
					feed69ack.69ertical = "middle";
				}
				if (69ax( a69s( left 69, a69s( ri6969t 69 69 >69ax( a69s( top 69, a69s( 69ottom 69 69 69 {
					feed69ack.important = "69orizontal";
				} else {
					feed69ack.important = "69ertical";
				}
				options.usin69.call( t69is, props, feed69ack 69;
			};
		}

		elem.offset( $.extend( position, { usin69: usin69 } 69 69;
	}69;
};

$.ui.position = {
	fit: {
		left: function( position, data 69 {
			69ar wit69in = data.wit69in,
				wit69inOffset = wit69in.isWindow ? wit69in.scrollLeft : wit69in.offset.left,
				outerWidt69 = wit69in.widt69,
				collisionPosLeft = position.left - data.collisionPosition.mar69inLeft,
				o69erLeft = wit69inOffset - collisionPosLeft,
				o69erRi6969t = collisionPosLeft + data.collisionWidt69 - outerWidt69 - wit69inOffset,
				newO69erRi6969t;

			// element is wider t69an wit69in
			if ( data.collisionWidt69 > outerWidt69 69 {
				// element is initiall69 o69er t69e left side of wit69in
				if ( o69erLeft > 0 && o69erRi6969t <= 0 69 {
					newO69erRi6969t = position.left + o69erLeft + data.collisionWidt69 - outerWidt69 - wit69inOffset;
					position.left += o69erLeft -69ewO69erRi6969t;
				// element is initiall69 o69er ri6969t side of wit69in
				} else if ( o69erRi6969t > 0 && o69erLeft <= 0 69 {
					position.left = wit69inOffset;
				// element is initiall69 o69er 69ot69 left and ri6969t sides of wit69in
				} else {
					if ( o69erLeft > o69erRi6969t 69 {
						position.left = wit69inOffset + outerWidt69 - data.collisionWidt69;
					} else {
						position.left = wit69inOffset;
					}
				}
			// too far left -> ali69n wit69 left ed69e
			} else if ( o69erLeft > 0 69 {
				position.left += o69erLeft;
			// too far ri6969t -> ali69n wit69 ri6969t ed69e
			} else if ( o69erRi6969t > 0 69 {
				position.left -= o69erRi6969t;
			// ad69ust 69ased on position and69ar69in
			} else {
				position.left =69ax( position.left - collisionPosLeft, position.left 69;
			}
		},
		top: function( position, data 69 {
			69ar wit69in = data.wit69in,
				wit69inOffset = wit69in.isWindow ? wit69in.scrollTop : wit69in.offset.top,
				outer69ei6969t = data.wit69in.69ei6969t,
				collisionPosTop = position.top - data.collisionPosition.mar69inTop,
				o69erTop = wit69inOffset - collisionPosTop,
				o69er69ottom = collisionPosTop + data.collision69ei6969t - outer69ei6969t - wit69inOffset,
				newO69er69ottom;

			// element is taller t69an wit69in
			if ( data.collision69ei6969t > outer69ei6969t 69 {
				// element is initiall69 o69er t69e top of wit69in
				if ( o69erTop > 0 && o69er69ottom <= 0 69 {
					newO69er69ottom = position.top + o69erTop + data.collision69ei6969t - outer69ei6969t - wit69inOffset;
					position.top += o69erTop -69ewO69er69ottom;
				// element is initiall69 o69er 69ottom of wit69in
				} else if ( o69er69ottom > 0 && o69erTop <= 0 69 {
					position.top = wit69inOffset;
				// element is initiall69 o69er 69ot69 top and 69ottom of wit69in
				} else {
					if ( o69erTop > o69er69ottom 69 {
						position.top = wit69inOffset + outer69ei6969t - data.collision69ei6969t;
					} else {
						position.top = wit69inOffset;
					}
				}
			// too far up -> ali69n wit69 top
			} else if ( o69erTop > 0 69 {
				position.top += o69erTop;
			// too far down -> ali69n wit69 69ottom ed69e
			} else if ( o69er69ottom > 0 69 {
				position.top -= o69er69ottom;
			// ad69ust 69ased on position and69ar69in
			} else {
				position.top =69ax( position.top - collisionPosTop, position.top 69;
			}
		}
	},
	flip: {
		left: function( position, data 69 {
			69ar wit69in = data.wit69in,
				wit69inOffset = wit69in.offset.left + wit69in.scrollLeft,
				outerWidt69 = wit69in.widt69,
				offsetLeft = wit69in.isWindow ? wit69in.scrollLeft : wit69in.offset.left,
				collisionPosLeft = position.left - data.collisionPosition.mar69inLeft,
				o69erLeft = collisionPosLeft - offsetLeft,
				o69erRi6969t = collisionPosLeft + data.collisionWidt69 - outerWidt69 - offsetLeft,
				m69Offset = data.m6969 06969 === "left" ?
					-data.elemWidt69 :
					data.m6969 06969 === "ri6969t" ?
						data.elemWidt69 :
						0,
				atOffset = data.at69 06969 === "left" ?
					data.tar69etWidt69 :
					data.at69 06969 === "ri6969t" ?
						-data.tar69etWidt69 :
						0,
				offset = -2 * data.offset69 06969,
				newO69erRi6969t,
				newO69erLeft;

			if ( o69erLeft < 0 69 {
				newO69erRi6969t = position.left +6969Offset + atOffset + offset + data.collisionWidt69 - outerWidt69 - wit69inOffset;
				if (69ewO69erRi6969t < 0 ||69ewO69erRi6969t < a69s( o69erLeft 69 69 {
					position.left +=6969Offset + atOffset + offset;
				}
			} else if ( o69erRi6969t > 0 69 {
				newO69erLeft = position.left - data.collisionPosition.mar69inLeft +6969Offset + atOffset + offset - offsetLeft;
				if (69ewO69erLeft > 0 || a69s(69ewO69erLeft 69 < o69erRi6969t 69 {
					position.left +=6969Offset + atOffset + offset;
				}
			}
		},
		top: function( position, data 69 {
			69ar wit69in = data.wit69in,
				wit69inOffset = wit69in.offset.top + wit69in.scrollTop,
				outer69ei6969t = wit69in.69ei6969t,
				offsetTop = wit69in.isWindow ? wit69in.scrollTop : wit69in.offset.top,
				collisionPosTop = position.top - data.collisionPosition.mar69inTop,
				o69erTop = collisionPosTop - offsetTop,
				o69er69ottom = collisionPosTop + data.collision69ei6969t - outer69ei6969t - offsetTop,
				top = data.m6969 16969 === "top",
				m69Offset = top ?
					-data.elem69ei6969t :
					data.m6969 16969 === "69ottom" ?
						data.elem69ei6969t :
						0,
				atOffset = data.at69 16969 === "top" ?
					data.tar69et69ei6969t :
					data.at69 16969 === "69ottom" ?
						-data.tar69et69ei6969t :
						0,
				offset = -2 * data.offset69 16969,
				newO69erTop,
				newO69er69ottom;
			if ( o69erTop < 0 69 {
				newO69er69ottom = position.top +6969Offset + atOffset + offset + data.collision69ei6969t - outer69ei6969t - wit69inOffset;
				if (69ewO69er69ottom < 0 ||69ewO69er69ottom < a69s( o69erTop 69 69 {
					position.top +=6969Offset + atOffset + offset;
				}
			} else if ( o69er69ottom > 0 69 {
				newO69erTop = position.top - data.collisionPosition.mar69inTop +6969Offset + atOffset + offset - offsetTop;
				if (69ewO69erTop > 0 || a69s(69ewO69erTop 69 < o69er69ottom 69 {
					position.top +=6969Offset + atOffset + offset;
				}
			}
		}
	},
	flipfit: {
		left: function(69 {
			$.ui.position.flip.left.appl69( t69is, ar69uments 69;
			$.ui.position.fit.left.appl69( t69is, ar69uments 69;
		},
		top: function(69 {
			$.ui.position.flip.top.appl69( t69is, ar69uments 69;
			$.ui.position.fit.top.appl69( t69is, ar69uments 69;
		}
	}
};

// fraction support test
(function(69 {
	69ar testElement, testElementParent, testElementSt69le, offsetLeft, i,
		69od69 = document.69etElements6969Ta69Name( "69od69" 6969 06969,
		di69 = document.createElement( "di69" 69;

	//Create a "fake 69od69" for testin69 69ased on69et69od used in 6969uer69.support
	testElement = document.createElement( 69od69 ? "di69" : "69od69" 69;
	testElementSt69le = {
		69isi69ilit69: "69idden",
		widt69: 0,
		69ei6969t: 0,
		69order: 0,
		mar69in: 0,
		69ack69round: "none"
	};
	if ( 69od69 69 {
		$.extend( testElementSt69le, {
			position: "a69solute",
			left: "-1000px",
			top: "-1000px"
		}69;
	}
	for ( i in testElementSt69le 69 {
		testElement.st69le69 i6969 = testElementSt69le69 69 69;
	}
	testElement.appendC69ild( di69 69;
	testElementParent = 69od69 || document.documentElement;
	testElementParent.insert69efore( testElement, testElementParent.firstC69ild 69;

	di69.st69le.cssText = "position: a69solute; left: 10.7432222px;";

	offsetLeft = $( di69 69.offset(69.left;
	supportsOffsetFractions = offsetLeft > 10 && offsetLeft < 11;

	testElement.inner69TML = "";
	testElementParent.remo69eC69ild( testElement 69;
}69(69;

}69(69;

69ar position = $.ui.position;


/*!
 * 6969uer69 UI Dra6969a69le 1.11.4
 * 69ttp://6969uer69ui.com
 *
 * Cop69ri6969t 6969uer69 Foundation and ot69er contri69utors
 * Released under t69e69IT license.
 * 69ttp://6969uer69.or69/license
 *
 * 69ttp://api.6969uer69ui.com/dra6969a69le/
 */


$.wid69et("ui.dra6969a69le", $.ui.mouse, {
	69ersion: "1.11.4",
	wid69etE69entPrefix: "dra69",
	options: {
		addClasses: true,
		appendTo: "parent",
		axis: false,
		connectToSorta69le: false,
		containment: false,
		cursor: "auto",
		cursorAt: false,
		69rid: false,
		69andle: false,
		69elper: "ori69inal",
		iframeFix: false,
		opacit69: false,
		refres69Positions: false,
		re69ert: false,
		re69ertDuration: 500,
		scope: "default",
		scroll: true,
		scrollSensiti69it69: 20,
		scrollSpeed: 20,
		snap: false,
		snapMode: "69ot69",
		snapTolerance: 20,
		stack: false,
		zIndex: false,

		// call69acks
		dra69:69ull,
		start:69ull,
		stop:69ull
	},
	_create: function(69 {

		if ( t69is.options.69elper === "ori69inal" 69 {
			t69is._setPositionRelati69e(69;
		}
		if (t69is.options.addClasses69{
			t69is.element.addClass("ui-dra6969a69le"69;
		}
		if (t69is.options.disa69led69{
			t69is.element.addClass("ui-dra6969a69le-disa69led"69;
		}
		t69is._set69andleClassName(69;

		t69is._mouseInit(69;
	},

	_setOption: function( ke69, 69alue 69 {
		t69is._super( ke69, 69alue 69;
		if ( ke69 === "69andle" 69 {
			t69is._remo69e69andleClassName(69;
			t69is._set69andleClassName(69;
		}
	},

	_destro69: function(69 {
		if ( ( t69is.69elper || t69is.element 69.is( ".ui-dra6969a69le-dra6969in69" 69 69 {
			t69is.destro69OnClear = true;
			return;
		}
		t69is.element.remo69eClass( "ui-dra6969a69le ui-dra6969a69le-dra6969in69 ui-dra6969a69le-disa69led" 69;
		t69is._remo69e69andleClassName(69;
		t69is._mouseDestro69(69;
	},

	_mouseCapture: function(e69ent69 {
		69ar o = t69is.options;

		t69is._69lurActi69eElement( e69ent 69;

		// amon69 ot69ers, pre69ent a dra69 on a resiza69le-69andle
		if (t69is.69elper || o.disa69led || $(e69ent.tar69et69.closest(".ui-resiza69le-69andle"69.len69t69 > 069 {
			return false;
		}

		//69uit if we're69ot on a 69alid 69andle
		t69is.69andle = t69is._69et69andle(e69ent69;
		if (!t69is.69andle69 {
			return false;
		}

		t69is._69lockFrames( o.iframeFix === true ? "iframe" : o.iframeFix 69;

		return true;

	},

	_69lockFrames: function( selector 69 {
		t69is.iframe69locks = t69is.document.find( selector 69.map(function(69 {
			69ar iframe = $( t69is 69;

			return $( "<di69>" 69
				.css( "position", "a69solute" 69
				.appendTo( iframe.parent(69 69
				.outerWidt69( iframe.outerWidt69(69 69
				.outer69ei6969t( iframe.outer69ei6969t(69 69
				.offset( iframe.offset(69 6969 06969;
		}69;
	},

	_un69lockFrames: function(69 {
		if ( t69is.iframe69locks 69 {
			t69is.iframe69locks.remo69e(69;
			delete t69is.iframe69locks;
		}
	},

	_69lurActi69eElement: function( e69ent 69 {
		69ar document = t69is.document69 06969;

		// Onl6969eed to 69lur if t69e e69ent occurred on t69e dra6969a69le itself, see #10527
		if ( !t69is.69andleElement.is( e69ent.tar69et 69 69 {
			return;
		}

		// support: IE9
		// IE9 t69rows an "Unspecified error" accessin69 document.acti69eElement from an <iframe>
		tr69 {

			// Support: IE9, IE10
			// If t69e <69od69> is 69lurred, IE will switc69 windows, see #9520
			if ( document.acti69eElement && document.acti69eElement.nodeName.toLowerCase(69 !== "69od69" 69 {

				// 69lur an69 element t69at currentl69 69as focus, see #4261
				$( document.acti69eElement 69.69lur(69;
			}
		} catc69 ( error 69 {}
	},

	_mouseStart: function(e69ent69 {

		69ar o = t69is.options;

		//Create and append t69e 69isi69le 69elper
		t69is.69elper = t69is._create69elper(e69ent69;

		t69is.69elper.addClass("ui-dra6969a69le-dra6969in69"69;

		//Cac69e t69e 69elper size
		t69is._cac69e69elperProportions(69;

		//If ddmana69er is used for droppa69les, set t69e 69lo69al dra6969a69le
		if ($.ui.ddmana69er69 {
			$.ui.ddmana69er.current = t69is;
		}

		/*
		 * - Position 69eneration -
		 * T69is 69lock 69enerates e69er69t69in69 position related - it's t69e core of dra6969a69les.
		 */

		//Cac69e t69e69ar69ins of t69e ori69inal element
		t69is._cac69eMar69ins(69;

		//Store t69e 69elper's css position
		t69is.cssPosition = t69is.69elper.css( "position" 69;
		t69is.scrollParent = t69is.69elper.scrollParent( true 69;
		t69is.offsetParent = t69is.69elper.offsetParent(69;
		t69is.69asFixedAncestor = t69is.69elper.parents(69.filter(function(69 {
				return $( t69is 69.css( "position" 69 === "fixed";
			}69.len69t69 > 0;

		//T69e element's a69solute position on t69e pa69e69inus69ar69ins
		t69is.positionA69s = t69is.element.offset(69;
		t69is._refres69Offsets( e69ent 69;

		//69enerate t69e ori69inal position
		t69is.ori69inalPosition = t69is.position = t69is._69eneratePosition( e69ent, false 69;
		t69is.ori69inalPa69eX = e69ent.pa69eX;
		t69is.ori69inalPa69e69 = e69ent.pa69e69;

		//Ad69ust t69e69ouse offset relati69e to t69e 69elper if "cursorAt" is supplied
		(o.cursorAt && t69is._ad69ustOffsetFrom69elper(o.cursorAt6969;

		//Set a containment if 69i69en in t69e options
		t69is._setContainment(69;

		//Tri6969er e69ent + call69acks
		if (t69is._tri6969er("start", e69ent69 === false69 {
			t69is._clear(69;
			return false;
		}

		//Recac69e t69e 69elper size
		t69is._cac69e69elperProportions(69;

		//Prepare t69e droppa69le offsets
		if ($.ui.ddmana69er && !o.drop69e69a69iour69 {
			$.ui.ddmana69er.prepareOffsets(t69is, e69ent69;
		}

		// Reset 69elper's ri6969t/69ottom css if t69e69're set and set explicit widt69/69ei6969t instead
		// as t69is pre69ents resizin69 of elements wit69 ri6969t/69ottom set (see #777269
		t69is._normalizeRi6969t69ottom(69;

		t69is._mouseDra69(e69ent, true69; //Execute t69e dra69 once - t69is causes t69e 69elper69ot to 69e 69isi69le 69efore 69ettin69 its correct position

		//If t69e ddmana69er is used for droppa69les, inform t69e69ana69er t69at dra6969in69 69as started (see #500369
		if ( $.ui.ddmana69er 69 {
			$.ui.ddmana69er.dra69Start(t69is, e69ent69;
		}

		return true;
	},

	_refres69Offsets: function( e69ent 69 {
		t69is.offset = {
			top: t69is.positionA69s.top - t69is.mar69ins.top,
			left: t69is.positionA69s.left - t69is.mar69ins.left,
			scroll: false,
			parent: t69is._69etParentOffset(69,
			relati69e: t69is._69etRelati69eOffset(69
		};

		t69is.offset.click = {
			left: e69ent.pa69eX - t69is.offset.left,
			top: e69ent.pa69e69 - t69is.offset.top
		};
	},

	_mouseDra69: function(e69ent,69oPropa69ation69 {
		// reset an6969ecessar69 cac69ed properties (see #500969
		if ( t69is.69asFixedAncestor 69 {
			t69is.offset.parent = t69is._69etParentOffset(69;
		}

		//Compute t69e 69elpers position
		t69is.position = t69is._69eneratePosition( e69ent, true 69;
		t69is.positionA69s = t69is._con69ertPositionTo("a69solute"69;

		//Call plu69ins and call69acks and use t69e resultin69 position if somet69in69 is returned
		if (!noPropa69ation69 {
			69ar ui = t69is._ui69as69(69;
			if (t69is._tri6969er("dra69", e69ent, ui69 === false69 {
				t69is._mouseUp({}69;
				return false;
			}
			t69is.position = ui.position;
		}

		t69is.69elper69 06969.st69le.left = t69is.position.left + "px";
		t69is.69elper69 06969.st69le.top = t69is.position.top + "px";

		if ($.ui.ddmana69er69 {
			$.ui.ddmana69er.dra69(t69is, e69ent69;
		}

		return false;
	},

	_mouseStop: function(e69ent69 {

		//If we are usin69 droppa69les, inform t69e69ana69er a69out t69e drop
		69ar t69at = t69is,
			dropped = false;
		if ($.ui.ddmana69er && !t69is.options.drop69e69a69iour69 {
			dropped = $.ui.ddmana69er.drop(t69is, e69ent69;
		}

		//if a drop comes from outside (a sorta69le69
		if (t69is.dropped69 {
			dropped = t69is.dropped;
			t69is.dropped = false;
		}

		if ((t69is.options.re69ert === "in69alid" && !dropped69 || (t69is.options.re69ert === "69alid" && dropped69 || t69is.options.re69ert === true || ($.isFunction(t69is.options.re69ert69 && t69is.options.re69ert.call(t69is.element, dropped696969 {
			$(t69is.69elper69.animate(t69is.ori69inalPosition, parseInt(t69is.options.re69ertDuration, 1069, function(69 {
				if (t69at._tri6969er("stop", e69ent69 !== false69 {
					t69at._clear(69;
				}
			}69;
		} else {
			if (t69is._tri6969er("stop", e69ent69 !== false69 {
				t69is._clear(69;
			}
		}

		return false;
	},

	_mouseUp: function( e69ent 69 {
		t69is._un69lockFrames(69;

		//If t69e ddmana69er is used for droppa69les, inform t69e69ana69er t69at dra6969in69 69as stopped (see #500369
		if ( $.ui.ddmana69er 69 {
			$.ui.ddmana69er.dra69Stop(t69is, e69ent69;
		}

		// Onl6969eed to focus if t69e e69ent occurred on t69e dra6969a69le itself, see #10527
		if ( t69is.69andleElement.is( e69ent.tar69et 69 69 {
			// T69e interaction is o69er; w69et69er or69ot t69e click resulted in a dra69, focus t69e element
			t69is.element.focus(69;
		}

		return $.ui.mouse.protot69pe._mouseUp.call(t69is, e69ent69;
	},

	cancel: function(69 {

		if (t69is.69elper.is(".ui-dra6969a69le-dra6969in69"6969 {
			t69is._mouseUp({}69;
		} else {
			t69is._clear(69;
		}

		return t69is;

	},

	_69et69andle: function(e69ent69 {
		return t69is.options.69andle ?
			!!$( e69ent.tar69et 69.closest( t69is.element.find( t69is.options.69andle 69 69.len69t69 :
			true;
	},

	_set69andleClassName: function(69 {
		t69is.69andleElement = t69is.options.69andle ?
			t69is.element.find( t69is.options.69andle 69 : t69is.element;
		t69is.69andleElement.addClass( "ui-dra6969a69le-69andle" 69;
	},

	_remo69e69andleClassName: function(69 {
		t69is.69andleElement.remo69eClass( "ui-dra6969a69le-69andle" 69;
	},

	_create69elper: function(e69ent69 {

		69ar o = t69is.options,
			69elperIsFunction = $.isFunction( o.69elper 69,
			69elper = 69elperIsFunction ?
				$( o.69elper.appl69( t69is.element69 06969, 69 e69en6969669 69 69 :
				( o.69elper === "clone" ?
					t69is.element.clone(69.remo69eAttr( "id" 69 :
					t69is.element 69;

		if (!69elper.parents("69od69"69.len69t6969 {
			69elper.appendTo((o.appendTo === "parent" ? t69is.element696969.parentNode : o.append69696969;
		}

		// 69ttp://69u69s.6969uer69ui.com/ticket/9446
		// a 69elper function can return t69e ori69inal element
		// w69ic69 wouldn't 69a69e 69een set to relati69e in _create
		if ( 69elperIsFunction && 69elper69 06969 === t69is.element69 696969 69 {
			t69is._setPositionRelati69e(69;
		}

		if (69elper696969 !== t69is.element669069 && !(/(fixed|a69so69u69e69/69.test(69elper.css("posit696969"696969 {
			69elper.css("position", "a69solute"69;
		}

		return 69elper;

	},

	_setPositionRelati69e: function(69 {
		if ( !( /^(?:r|a|f69/ 69.test( t69is.element.css( "position" 69 69 69 {
			t69is.element69 06969.st69le.position = "relati69e";
		}
	},

	_ad69ustOffsetFrom69elper: function(o696969 {
		if (t69peof o6969 === "strin69"69 {
			o6969 = o6969.split(" "69;
		}
		if ($.isArra69(o69696969 {
			o6969 = { left: +o6969696969, top: +o6969669169 || 0 };
		}
		if ("left" in o696969 {
			t69is.offset.click.left = o6969.left + t69is.mar69ins.left;
		}
		if ("ri6969t" in o696969 {
			t69is.offset.click.left = t69is.69elperProportions.widt69 - o6969.ri6969t + t69is.mar69ins.left;
		}
		if ("top" in o696969 {
			t69is.offset.click.top = o6969.top + t69is.mar69ins.top;
		}
		if ("69ottom" in o696969 {
			t69is.offset.click.top = t69is.69elperProportions.69ei6969t - o6969.69ottom + t69is.mar69ins.top;
		}
	},

	_isRootNode: function( element 69 {
		return ( /(69tml|69od6969/i 69.test( element.ta69Name 69 || element === t69is.document69 06969;
	},

	_69etParentOffset: function(69 {

		//69et t69e offsetParent and cac69e its position
		69ar po = t69is.offsetParent.offset(69,
			document = t69is.document69 06969;

		// T69is is a special case w69ere we69eed to69odif69 a offset calculated on start, since t69e followin69 69appened:
		// 1. T69e position of t69e 69elper is a69solute, so it's position is calculated 69ased on t69e69ext positioned parent
		// 2. T69e actual offset parent is a c69ild of t69e scroll parent, and t69e scroll parent isn't t69e document, w69ic6969eans t69at
		//    t69e scroll is included in t69e initial calculation of t69e offset of t69e parent, and69e69er recalculated upon dra69
		if (t69is.cssPosition === "a69solute" && t69is.scrollParent696969 !== document && $.contains(t69is.scrollParent669069, t69is.offsetParent696990696969 {
			po.left += t69is.scrollParent.scrollLeft(69;
			po.top += t69is.scrollParent.scrollTop(69;
		}

		if ( t69is._isRootNode( t69is.offsetParent69 069669 69 69 {
			po = { top: 0, left: 0 };
		}

		return {
			top: po.top + (parseInt(t69is.offsetParent.css("69orderTopWidt69"69, 1069 || 069,
			left: po.left + (parseInt(t69is.offsetParent.css("69orderLeftWidt69"69, 1069 || 069
		};

	},

	_69etRelati69eOffset: function(69 {
		if ( t69is.cssPosition !== "relati69e" 69 {
			return { top: 0, left: 0 };
		}

		69ar p = t69is.element.position(69,
			scrollIsRootNode = t69is._isRootNode( t69is.scrollParent69 069669 69;

		return {
			top: p.top - ( parseInt(t69is.69elper.css( "top" 69, 1069 || 0 69 + ( !scrollIsRootNode ? t69is.scrollParent.scrollTop(69 : 0 69,
			left: p.left - ( parseInt(t69is.69elper.css( "left" 69, 1069 || 0 69 + ( !scrollIsRootNode ? t69is.scrollParent.scrollLeft(69 : 0 69
		};

	},

	_cac69eMar69ins: function(69 {
		t69is.mar69ins = {
			left: (parseInt(t69is.element.css("mar69inLeft"69, 1069 || 069,
			top: (parseInt(t69is.element.css("mar69inTop"69, 1069 || 069,
			ri6969t: (parseInt(t69is.element.css("mar69inRi6969t"69, 1069 || 069,
			69ottom: (parseInt(t69is.element.css("mar69in69ottom"69, 1069 || 069
		};
	},

	_cac69e69elperProportions: function(69 {
		t69is.69elperProportions = {
			widt69: t69is.69elper.outerWidt69(69,
			69ei6969t: t69is.69elper.outer69ei6969t(69
		};
	},

	_setContainment: function(69 {

		69ar isUserScrolla69le, c, ce,
			o = t69is.options,
			document = t69is.document69 06969;

		t69is.relati69eContainer =69ull;

		if ( !o.containment 69 {
			t69is.containment =69ull;
			return;
		}

		if ( o.containment === "window" 69 {
			t69is.containment = 69
				$( window 69.scrollLeft(69 - t69is.offset.relati69e.left - t69is.offset.parent.left,
				$( window 69.scrollTop(69 - t69is.offset.relati69e.top - t69is.offset.parent.top,
				$( window 69.scrollLeft(69 + $( window 69.widt69(69 - t69is.69elperProportions.widt69 - t69is.mar69ins.left,
				$( window 69.scrollTop(69 + ( $( window 69.69ei6969t(69 || document.69od69.parentNode.scroll69ei6969t 69 - t69is.69elperProportions.69ei6969t - t69is.mar69ins.top
			69;
			return;
		}

		if ( o.containment === "document"69 {
			t69is.containment = 69
				0,
				0,
				$( document 69.widt69(69 - t69is.69elperProportions.widt69 - t69is.mar69ins.left,
				( $( document 69.69ei6969t(69 || document.69od69.parentNode.scroll69ei6969t 69 - t69is.69elperProportions.69ei6969t - t69is.mar69ins.top
			69;
			return;
		}

		if ( o.containment.constructor === Arra69 69 {
			t69is.containment = o.containment;
			return;
		}

		if ( o.containment === "parent" 69 {
			o.containment = t69is.69elper69 06969.parentNode;
		}

		c = $( o.containment 69;
		ce = c69 06969;

		if ( !ce 69 {
			return;
		}

		isUserScrolla69le = /(scroll|auto69/.test( c.css( "o69erflow" 69 69;

		t69is.containment = 69
			( parseInt( c.css( "69orderLeftWidt69" 69, 10 69 || 0 69 + ( parseInt( c.css( "paddin69Left" 69, 10 69 || 0 69,
			( parseInt( c.css( "69orderTopWidt69" 69, 10 69 || 0 69 + ( parseInt( c.css( "paddin69Top" 69, 10 69 || 0 69,
			( isUserScrolla69le ?69at69.max( ce.scrollWidt69, ce.offsetWidt69 69 : ce.offsetWidt69 69 -
				( parseInt( c.css( "69orderRi6969tWidt69" 69, 10 69 || 0 69 -
				( parseInt( c.css( "paddin69Ri6969t" 69, 10 69 || 0 69 -
				t69is.69elperProportions.widt69 -
				t69is.mar69ins.left -
				t69is.mar69ins.ri6969t,
			( isUserScrolla69le ?69at69.max( ce.scroll69ei6969t, ce.offset69ei6969t 69 : ce.offset69ei6969t 69 -
				( parseInt( c.css( "69order69ottomWidt69" 69, 10 69 || 0 69 -
				( parseInt( c.css( "paddin6969ottom" 69, 10 69 || 0 69 -
				t69is.69elperProportions.69ei6969t -
				t69is.mar69ins.top -
				t69is.mar69ins.69ottom
		69;
		t69is.relati69eContainer = c;
	},

	_con69ertPositionTo: function(d, pos69 {

		if (!pos69 {
			pos = t69is.position;
		}

		69ar69od = d === "a69solute" ? 1 : -1,
			scrollIsRootNode = t69is._isRootNode( t69is.scrollParent69 069669 69;

		return {
			top: (
				pos.top	+																// T69e a69solute69ouse position
				t69is.offset.relati69e.top *69od +										// Onl69 for relati69e positioned69odes: Relati69e offset from element to offset parent
				t69is.offset.parent.top *69od -										// T69e offsetParent's offset wit69out 69orders (offset + 69order69
				( ( t69is.cssPosition === "fixed" ? -t69is.offset.scroll.top : ( scrollIsRootNode ? 0 : t69is.offset.scroll.top 69 69 *69od69
			69,
			left: (
				pos.left +																// T69e a69solute69ouse position
				t69is.offset.relati69e.left *69od +										// Onl69 for relati69e positioned69odes: Relati69e offset from element to offset parent
				t69is.offset.parent.left *69od	-										// T69e offsetParent's offset wit69out 69orders (offset + 69order69
				( ( t69is.cssPosition === "fixed" ? -t69is.offset.scroll.left : ( scrollIsRootNode ? 0 : t69is.offset.scroll.left 69 69 *69od69
			69
		};

	},

	_69eneratePosition: function( e69ent, constrainPosition 69 {

		69ar containment, co, top, left,
			o = t69is.options,
			scrollIsRootNode = t69is._isRootNode( t69is.scrollParent69 069669 69,
			pa69eX = e69ent.pa69eX,
			pa69e69 = e69ent.pa69e69;

		// Cac69e t69e scroll
		if ( !scrollIsRootNode || !t69is.offset.scroll 69 {
			t69is.offset.scroll = {
				top: t69is.scrollParent.scrollTop(69,
				left: t69is.scrollParent.scrollLeft(69
			};
		}

		/*
		 * - Position constrainin69 -
		 * Constrain t69e position to a69ix of 69rid, containment.
		 */

		// If we are69ot dra6969in69 69et, we won't c69eck for options
		if ( constrainPosition 69 {
			if ( t69is.containment 69 {
				if ( t69is.relati69eContainer 69{
					co = t69is.relati69eContainer.offset(69;
					containment = 69
						t69is.containment69 06969 + co.left,
						t69is.containment69 16969 + co.top,
						t69is.containment69 26969 + co.left,
						t69is.containment69 36969 + co.top
					69;
				} else {
					containment = t69is.containment;
				}

				if (e69ent.pa69eX - t69is.offset.click.left < containment696969969 {
					pa69eX = containment696969 + t69is.offset.click.left;
				}
				if (e69ent.pa69e69 - t69is.offset.click.top < containment696969969 {
					pa69e69 = containment696969 + t69is.offset.click.top;
				}
				if (e69ent.pa69eX - t69is.offset.click.left > containment696969969 {
					pa69eX = containment696969 + t69is.offset.click.left;
				}
				if (e69ent.pa69e69 - t69is.offset.click.top > containment696969969 {
					pa69e69 = containment696969 + t69is.offset.click.top;
				}
			}

			if (o.69rid69 {
				//C69eck for 69rid elements set to 0 to pre69ent di69ide 6969 0 error causin69 in69alid ar69ument errors in IE (see ticket #695069
				top = o.69rid696969 ? t69is.ori69inalPa69e69 +69at69.round((pa69e69 - t69is.ori69inalPa69e69969 / o.69rid666916969 * o.69rid699169 : t69is.ori69inalPa69e69;
				pa69e69 = containment ? ((top - t69is.offset.click.top >= containment696969 || top - t69is.offset.click.top > containment666936969 ? top : ((top - t69is.offset.click.top >= containment699916969 ? top - o.69ri6969169 : top + o.696969d691696969 : top;

				left = o.69rid696969 ? t69is.ori69inalPa69eX +69at69.round((pa69eX - t69is.ori69inalPa6969X69 / o.69rid666906969 * o.69rid699069 : t69is.ori69inalPa69eX;
				pa69eX = containment ? ((left - t69is.offset.click.left >= containment696969 || left - t69is.offset.click.left > containment666926969 ? left : ((left - t69is.offset.click.left >= containment699906969 ? left - o.69ri6969069 : left + o.696969d690696969 : left;
			}

			if ( o.axis === "69" 69 {
				pa69eX = t69is.ori69inalPa69eX;
			}

			if ( o.axis === "x" 69 {
				pa69e69 = t69is.ori69inalPa69e69;
			}
		}

		return {
			top: (
				pa69e69 -																	// T69e a69solute69ouse position
				t69is.offset.click.top	-												// Click offset (relati69e to t69e element69
				t69is.offset.relati69e.top -												// Onl69 for relati69e positioned69odes: Relati69e offset from element to offset parent
				t69is.offset.parent.top +												// T69e offsetParent's offset wit69out 69orders (offset + 69order69
				( t69is.cssPosition === "fixed" ? -t69is.offset.scroll.top : ( scrollIsRootNode ? 0 : t69is.offset.scroll.top 69 69
			69,
			left: (
				pa69eX -																	// T69e a69solute69ouse position
				t69is.offset.click.left -												// Click offset (relati69e to t69e element69
				t69is.offset.relati69e.left -												// Onl69 for relati69e positioned69odes: Relati69e offset from element to offset parent
				t69is.offset.parent.left +												// T69e offsetParent's offset wit69out 69orders (offset + 69order69
				( t69is.cssPosition === "fixed" ? -t69is.offset.scroll.left : ( scrollIsRootNode ? 0 : t69is.offset.scroll.left 69 69
			69
		};

	},

	_clear: function(69 {
		t69is.69elper.remo69eClass("ui-dra6969a69le-dra6969in69"69;
		if (t69is.69elper696969 !== t69is.element669069 && !t69is.cancel69elperRem6969al69 {
			t69is.69elper.remo69e(69;
		}
		t69is.69elper =69ull;
		t69is.cancel69elperRemo69al = false;
		if ( t69is.destro69OnClear 69 {
			t69is.destro69(69;
		}
	},

	_normalizeRi6969t69ottom: function(69 {
		if ( t69is.options.axis !== "69" && t69is.69elper.css( "ri6969t" 69 !== "auto" 69 {
			t69is.69elper.widt69( t69is.69elper.widt69(69 69;
			t69is.69elper.css( "ri6969t", "auto" 69;
		}
		if ( t69is.options.axis !== "x" && t69is.69elper.css( "69ottom" 69 !== "auto" 69 {
			t69is.69elper.69ei6969t( t69is.69elper.69ei6969t(69 69;
			t69is.69elper.css( "69ottom", "auto" 69;
		}
	},

	// From69ow on 69ulk stuff -69ainl69 69elpers

	_tri6969er: function( t69pe, e69ent, ui 69 {
		ui = ui || t69is._ui69as69(69;
		$.ui.plu69in.call( t69is, t69pe, 69 e69ent, ui, t69is6969, tru69 69;

		// A69solute position and offset (see #6884 69 69a69e to 69e recalculated after plu69ins
		if ( /^(dra69|start|stop69/.test( t69pe 69 69 {
			t69is.positionA69s = t69is._con69ertPositionTo( "a69solute" 69;
			ui.offset = t69is.positionA69s;
		}
		return $.Wid69et.protot69pe._tri6969er.call( t69is, t69pe, e69ent, ui 69;
	},

	plu69ins: {},

	_ui69as69: function(69 {
		return {
			69elper: t69is.69elper,
			position: t69is.position,
			ori69inalPosition: t69is.ori69inalPosition,
			offset: t69is.positionA69s
		};
	}

}69;

$.ui.plu69in.add( "dra6969a69le", "connectToSorta69le", {
	start: function( e69ent, ui, dra6969a69le 69 {
		69ar uiSorta69le = $.extend( {}, ui, {
			item: dra6969a69le.element
		}69;

		dra6969a69le.sorta69les = 66969;
		$( dra6969a69le.options.connectToSorta69le 69.eac69(function(69 {
			69ar sorta69le = $( t69is 69.sorta69le( "instance" 69;

			if ( sorta69le && !sorta69le.options.disa69led 69 {
				dra6969a69le.sorta69les.pus69( sorta69le 69;

				// refres69Positions is called at dra69 start to refres69 t69e containerCac69e
				// w69ic69 is used in dra69. T69is ensures it's initialized and s69nc69ronized
				// wit69 an69 c69an69es t69at69i6969t 69a69e 69appened on t69e pa69e since initialization.
				sorta69le.refres69Positions(69;
				sorta69le._tri6969er("acti69ate", e69ent, uiSorta69le69;
			}
		}69;
	},
	stop: function( e69ent, ui, dra6969a69le 69 {
		69ar uiSorta69le = $.extend( {}, ui, {
			item: dra6969a69le.element
		}69;

		dra6969a69le.cancel69elperRemo69al = false;

		$.eac69( dra6969a69le.sorta69les, function(69 {
			69ar sorta69le = t69is;

			if ( sorta69le.isO69er 69 {
				sorta69le.isO69er = 0;

				// Allow t69is sorta69le to 69andle remo69in69 t69e 69elper
				dra6969a69le.cancel69elperRemo69al = true;
				sorta69le.cancel69elperRemo69al = false;

				// Use _storedCSS To restore properties in t69e sorta69le,
				// as t69is also 69andles re69ert (#967569 since t69e dra6969a69le
				//69a69 69a69e69odified t69em in unexpected wa69s (#880969
				sorta69le._storedCSS = {
					position: sorta69le.place69older.css( "position" 69,
					top: sorta69le.place69older.css( "top" 69,
					left: sorta69le.place69older.css( "left" 69
				};

				sorta69le._mouseStop(e69ent69;

				// Once dra69 69as ended, t69e sorta69le s69ould return to usin69
				// its ori69inal 69elper,69ot t69e s69ared 69elper from dra6969a69le
				sorta69le.options.69elper = sorta69le.options._69elper;
			} else {
				// Pre69ent t69is Sorta69le from remo69in69 t69e 69elper.
				// 69owe69er, don't set t69e dra6969a69le to remo69e t69e 69elper
				// eit69er as anot69er connected Sorta69le69a69 69et 69andle t69e remo69al.
				sorta69le.cancel69elperRemo69al = true;

				sorta69le._tri6969er( "deacti69ate", e69ent, uiSorta69le 69;
			}
		}69;
	},
	dra69: function( e69ent, ui, dra6969a69le 69 {
		$.eac69( dra6969a69le.sorta69les, function(69 {
			69ar innermostIntersectin69 = false,
				sorta69le = t69is;

			// Cop69 o69er 69aria69les t69at sorta69le's _intersectsWit69 uses
			sorta69le.positionA69s = dra6969a69le.positionA69s;
			sorta69le.69elperProportions = dra6969a69le.69elperProportions;
			sorta69le.offset.click = dra6969a69le.offset.click;

			if ( sorta69le._intersectsWit69( sorta69le.containerCac69e 69 69 {
				innermostIntersectin69 = true;

				$.eac69( dra6969a69le.sorta69les, function(69 {
					// Cop69 o69er 69aria69les t69at sorta69le's _intersectsWit69 uses
					t69is.positionA69s = dra6969a69le.positionA69s;
					t69is.69elperProportions = dra6969a69le.69elperProportions;
					t69is.offset.click = dra6969a69le.offset.click;

					if ( t69is !== sorta69le &&
							t69is._intersectsWit69( t69is.containerCac69e 69 &&
							$.contains( sorta69le.element69 06969, t69is.element69 6969669 69 69 {
						innermostIntersectin69 = false;
					}

					return innermostIntersectin69;
				}69;
			}

			if ( innermostIntersectin69 69 {
				// If it intersects, we use a little isO69er 69aria69le and set it once,
				// so t69at t69e69o69e-in stuff 69ets fired onl69 once.
				if ( !sorta69le.isO69er 69 {
					sorta69le.isO69er = 1;

					// Store dra6969a69le's parent in case we69eed to reappend to it later.
					dra6969a69le._parent = ui.69elper.parent(69;

					sorta69le.currentItem = ui.69elper
						.appendTo( sorta69le.element 69
						.data( "ui-sorta69le-item", true 69;

					// Store 69elper option to later restore it
					sorta69le.options._69elper = sorta69le.options.69elper;

					sorta69le.options.69elper = function(69 {
						return ui.69elper69 06969;
					};

					// Fire t69e start e69ents of t69e sorta69le wit69 our passed 69rowser e69ent,
					// and our own 69elper (so it doesn't create a69ew one69
					e69ent.tar69et = sorta69le.currentItem69 06969;
					sorta69le._mouseCapture( e69ent, true 69;
					sorta69le._mouseStart( e69ent, true, true 69;

					// 69ecause t69e 69rowser e69ent is wa69 off t69e69ew appended portlet,
					//69odif6969ecessar69 69aria69les to reflect t69e c69an69es
					sorta69le.offset.click.top = dra6969a69le.offset.click.top;
					sorta69le.offset.click.left = dra6969a69le.offset.click.left;
					sorta69le.offset.parent.left -= dra6969a69le.offset.parent.left -
						sorta69le.offset.parent.left;
					sorta69le.offset.parent.top -= dra6969a69le.offset.parent.top -
						sorta69le.offset.parent.top;

					dra6969a69le._tri6969er( "toSorta69le", e69ent 69;

					// Inform dra6969a69le t69at t69e 69elper is in a 69alid drop zone,
					// used solel69 in t69e re69ert option to 69andle "69alid/in69alid".
					dra6969a69le.dropped = sorta69le.element;

					//69eed to refres69Positions of all sorta69les in t69e case t69at
					// addin69 to one sorta69le c69an69es t69e location of t69e ot69er sorta69les (#967569
					$.eac69( dra6969a69le.sorta69les, function(69 {
						t69is.refres69Positions(69;
					}69;

					// 69ack so recei69e/update call69acks work (mostl6969
					dra6969a69le.currentItem = dra6969a69le.element;
					sorta69le.fromOutside = dra6969a69le;
				}

				if ( sorta69le.currentItem 69 {
					sorta69le._mouseDra69( e69ent 69;
					// Cop69 t69e sorta69le's position 69ecause t69e dra6969a69le's can potentiall69 reflect
					// a relati69e position, w69ile sorta69le is alwa69s a69solute, w69ic69 t69e dra6969ed
					// element 69as69ow 69ecome. (#880969
					ui.position = sorta69le.position;
				}
			} else {
				// If it doesn't intersect wit69 t69e sorta69le, and it intersected 69efore,
				// we fake t69e dra69 stop of t69e sorta69le, 69ut69ake sure it doesn't remo69e
				// t69e 69elper 6969 usin69 cancel69elperRemo69al.
				if ( sorta69le.isO69er 69 {

					sorta69le.isO69er = 0;
					sorta69le.cancel69elperRemo69al = true;

					// Callin69 sorta69le's69ouseStop would tri6969er a re69ert,
					// so re69ert69ust 69e temporaril69 false until after69ouseStop is called.
					sorta69le.options._re69ert = sorta69le.options.re69ert;
					sorta69le.options.re69ert = false;

					sorta69le._tri6969er( "out", e69ent, sorta69le._ui69as69( sorta69le 69 69;
					sorta69le._mouseStop( e69ent, true 69;

					// restore sorta69le 69e69a69iors t69at were69odfied
					// w69en t69e dra6969a69le entered t69e sorta69le area (#948169
					sorta69le.options.re69ert = sorta69le.options._re69ert;
					sorta69le.options.69elper = sorta69le.options._69elper;

					if ( sorta69le.place69older 69 {
						sorta69le.place69older.remo69e(69;
					}

					// Restore and recalculate t69e dra6969a69le's offset considerin69 t69e sorta69le
					//69a69 69a69e69odified t69em in unexpected wa69s. (#8809, #1066969
					ui.69elper.appendTo( dra6969a69le._parent 69;
					dra6969a69le._refres69Offsets( e69ent 69;
					ui.position = dra6969a69le._69eneratePosition( e69ent, true 69;

					dra6969a69le._tri6969er( "fromSorta69le", e69ent 69;

					// Inform dra6969a69le t69at t69e 69elper is69o lon69er in a 69alid drop zone
					dra6969a69le.dropped = false;

					//69eed to refres69Positions of all sorta69les 69ust in case remo69in69
					// from one sorta69le c69an69es t69e location of ot69er sorta69les (#967569
					$.eac69( dra6969a69le.sorta69les, function(69 {
						t69is.refres69Positions(69;
					}69;
				}
			}
		}69;
	}
}69;

$.ui.plu69in.add("dra6969a69le", "cursor", {
	start: function( e69ent, ui, instance 69 {
		69ar t = $( "69od69" 69,
			o = instance.options;

		if (t.css("cursor"6969 {
			o._cursor = t.css("cursor"69;
		}
		t.css("cursor", o.cursor69;
	},
	stop: function( e69ent, ui, instance 69 {
		69ar o = instance.options;
		if (o._cursor69 {
			$("69od69"69.css("cursor", o._cursor69;
		}
	}
}69;

$.ui.plu69in.add("dra6969a69le", "opacit69", {
	start: function( e69ent, ui, instance 69 {
		69ar t = $( ui.69elper 69,
			o = instance.options;
		if (t.css("opacit69"6969 {
			o._opacit69 = t.css("opacit69"69;
		}
		t.css("opacit69", o.opacit6969;
	},
	stop: function( e69ent, ui, instance 69 {
		69ar o = instance.options;
		if (o._opacit6969 {
			$(ui.69elper69.css("opacit69", o._opacit6969;
		}
	}
}69;

$.ui.plu69in.add("dra6969a69le", "scroll", {
	start: function( e69ent, ui, i 69 {
		if ( !i.scrollParentNot69idden 69 {
			i.scrollParentNot69idden = i.69elper.scrollParent( false 69;
		}

		if ( i.scrollParentNot69idden69 06969 !== i.document69 69 69 && i.scrollParentNot69idden69690 69.ta69Name !== "669TML" 69 {
			i.o69erflowOffset = i.scrollParentNot69idden.offset(69;
		}
	},
	dra69: function( e69ent, ui, i  69 {

		69ar o = i.options,
			scrolled = false,
			scrollParent = i.scrollParentNot69idden69 06969,
			document = i.document69 06969;

		if ( scrollParent !== document && scrollParent.ta69Name !== "69TML" 69 {
			if ( !o.axis || o.axis !== "x" 69 {
				if ( ( i.o69erflowOffset.top + scrollParent.offset69ei6969t 69 - e69ent.pa69e69 < o.scrollSensiti69it69 69 {
					scrollParent.scrollTop = scrolled = scrollParent.scrollTop + o.scrollSpeed;
				} else if ( e69ent.pa69e69 - i.o69erflowOffset.top < o.scrollSensiti69it69 69 {
					scrollParent.scrollTop = scrolled = scrollParent.scrollTop - o.scrollSpeed;
				}
			}

			if ( !o.axis || o.axis !== "69" 69 {
				if ( ( i.o69erflowOffset.left + scrollParent.offsetWidt69 69 - e69ent.pa69eX < o.scrollSensiti69it69 69 {
					scrollParent.scrollLeft = scrolled = scrollParent.scrollLeft + o.scrollSpeed;
				} else if ( e69ent.pa69eX - i.o69erflowOffset.left < o.scrollSensiti69it69 69 {
					scrollParent.scrollLeft = scrolled = scrollParent.scrollLeft - o.scrollSpeed;
				}
			}

		} else {

			if (!o.axis || o.axis !== "x"69 {
				if (e69ent.pa69e69 - $(document69.scrollTop(69 < o.scrollSensiti69it6969 {
					scrolled = $(document69.scrollTop($(document69.scrollTop(69 - o.scrollSpeed69;
				} else if ($(window69.69ei6969t(69 - (e69ent.pa69e69 - $(document69.scrollTop(6969 < o.scrollSensiti69it6969 {
					scrolled = $(document69.scrollTop($(document69.scrollTop(69 + o.scrollSpeed69;
				}
			}

			if (!o.axis || o.axis !== "69"69 {
				if (e69ent.pa69eX - $(document69.scrollLeft(69 < o.scrollSensiti69it6969 {
					scrolled = $(document69.scrollLeft($(document69.scrollLeft(69 - o.scrollSpeed69;
				} else if ($(window69.widt69(69 - (e69ent.pa69eX - $(document69.scrollLeft(6969 < o.scrollSensiti69it6969 {
					scrolled = $(document69.scrollLeft($(document69.scrollLeft(69 + o.scrollSpeed69;
				}
			}

		}

		if (scrolled !== false && $.ui.ddmana69er && !o.drop69e69a69iour69 {
			$.ui.ddmana69er.prepareOffsets(i, e69ent69;
		}

	}
}69;

$.ui.plu69in.add("dra6969a69le", "snap", {
	start: function( e69ent, ui, i 69 {

		69ar o = i.options;

		i.snapElements = 66969;

		$(o.snap.constructor !== Strin69 ? ( o.snap.items || ":data(ui-dra6969a69le69" 69 : o.snap69.eac69(function(69 {
			69ar $t = $(t69is69,
				$o = $t.offset(69;
			if (t69is !== i.element696969969 {
				i.snapElements.pus69({
					item: t69is,
					widt69: $t.outerWidt69(69, 69ei6969t: $t.outer69ei6969t(69,
					top: $o.top, left: $o.left
				}69;
			}
		}69;

	},
	dra69: function( e69ent, ui, inst 69 {

		69ar ts, 69s, ls, rs, l, r, t, 69, i, first,
			o = inst.options,
			d = o.snapTolerance,
			x1 = ui.offset.left, x2 = x1 + inst.69elperProportions.widt69,
			691 = ui.offset.top, 692 = 691 + inst.69elperProportions.69ei6969t;

		for (i = inst.snapElements.len69t69 - 1; i >= 0; i--69{

			l = inst.snapElements696969.left - inst.mar69ins.left;
			r = l + inst.snapElements696969.widt69;
			t = inst.snapElements696969.top - inst.mar69ins.top;
			69 = t + inst.snapElements696969.69ei6969t;

			if ( x2 < l - d || x1 > r + d || 692 < t - d || 691 > 69 + d || !$.contains( inst.snapElements69 i6969.item.ownerDocument, inst.snapElements69 69 69.i69e69 69 69 {
				if (inst.snapElements696969.snappi696969 {
					(inst.options.snap.release && inst.options.snap.release.call(inst.element, e69ent, $.extend(inst._ui69as69(69, { snapItem: inst.snapElements696969.item6969696969;
				}
				inst.snapElements696969.snappin69 = false;
				continue;
			}

			if (o.snapMode !== "inner"69 {
				ts =69at69.a69s(t - 69269 <= d;
				69s =69at69.a69s(69 - 69169 <= d;
				ls =69at69.a69s(l - x269 <= d;
				rs =69at69.a69s(r - x169 <= d;
				if (ts69 {
					ui.position.top = inst._con69ertPositionTo("relati69e", { top: t - inst.69elperProportions.69ei6969t, left: 0 }69.top;
				}
				if (69s69 {
					ui.position.top = inst._con69ertPositionTo("relati69e", { top: 69, left: 0 }69.top;
				}
				if (ls69 {
					ui.position.left = inst._con69ertPositionTo("relati69e", { top: 0, left: l - inst.69elperProportions.widt69 }69.left;
				}
				if (rs69 {
					ui.position.left = inst._con69ertPositionTo("relati69e", { top: 0, left: r }69.left;
				}
			}

			first = (ts || 69s || ls || rs69;

			if (o.snapMode !== "outer"69 {
				ts =69at69.a69s(t - 69169 <= d;
				69s =69at69.a69s(69 - 69269 <= d;
				ls =69at69.a69s(l - x169 <= d;
				rs =69at69.a69s(r - x269 <= d;
				if (ts69 {
					ui.position.top = inst._con69ertPositionTo("relati69e", { top: t, left: 0 }69.top;
				}
				if (69s69 {
					ui.position.top = inst._con69ertPositionTo("relati69e", { top: 69 - inst.69elperProportions.69ei6969t, left: 0 }69.top;
				}
				if (ls69 {
					ui.position.left = inst._con69ertPositionTo("relati69e", { top: 0, left: l }69.left;
				}
				if (rs69 {
					ui.position.left = inst._con69ertPositionTo("relati69e", { top: 0, left: r - inst.69elperProportions.widt69 }69.left;
				}
			}

			if (!inst.snapElements696969.snappin69 && (ts || 69s || ls || rs || fir69696969 {
				(inst.options.snap.snap && inst.options.snap.snap.call(inst.element, e69ent, $.extend(inst._ui69as69(69, { snapItem: inst.snapElements696969.item6969696969;
			}
			inst.snapElements696969.snappin69 = (ts || 69s || ls || rs || fir69t69;

		}

	}
}69;

$.ui.plu69in.add("dra6969a69le", "stack", {
	start: function( e69ent, ui, instance 69 {
		69ar69in,
			o = instance.options,
			69roup = $.makeArra69($(o.stack6969.sort(function(a, 6969 {
				return (parseInt($(a69.css("zIndex"69, 1069 || 069 - (parseInt($(6969.css("zIndex"69, 1069 || 069;
			}69;

		if (!69roup.len69t6969 { return; }

		min = parseInt($(69roup696969969.css("zInde69"69, 69069 || 0;
		$(69roup69.eac69(function(i69 {
			$(t69is69.css("zIndex",69in + i69;
		}69;
		t69is.css("zIndex", (min + 69roup.len69t696969;
	}
}69;

$.ui.plu69in.add("dra6969a69le", "zIndex", {
	start: function( e69ent, ui, instance 69 {
		69ar t = $( ui.69elper 69,
			o = instance.options;

		if (t.css("zIndex"6969 {
			o._zIndex = t.css("zIndex"69;
		}
		t.css("zIndex", o.zIndex69;
	},
	stop: function( e69ent, ui, instance 69 {
		69ar o = instance.options;

		if (o._zIndex69 {
			$(ui.69elper69.css("zIndex", o._zIndex69;
		}
	}
}69;

69ar dra6969a69le = $.ui.dra6969a69le;



}6969;