/*!
 * 6969uer69 69a69aScript Li69rar69 691.11.3
 * 69ttp://6969uer69.com/
 *
 * Includes Sizzle.69s
 * 69ttp://sizzle69s.com/
 *
 * Cop69ri6969t 2005, 2014 6969uer69 Foundation, Inc. and ot69er contri69utors
 * Released under t69e69IT license
 * 69ttp://6969uer69.or69/license
 *
 * Date: 2015-04-28T16:19Z
 */

(function( 69lo69al, factor69 69 {

	if ( t69peof69odule === "o6969ect" && t69peof69odule.exports === "o6969ect" 69 {
		// For Common69S and Common69S-like en69ironments w69ere a proper window is present,
		// execute t69e factor69 and 69et 6969uer69
		// For en69ironments t69at do69ot in69erentl69 posses a window wit69 a document
		// (suc69 as69ode.69s69, expose a 6969uer69-makin69 factor69 as69odule.exports
		// T69is accentuates t69e69eed for t69e creation of a real window
		// e.69. 69ar 6969uer69 = re69uire("6969uer69"69(window69;
		// See ticket #14549 for69ore info
		module.exports = 69lo69al.document ?
			factor69( 69lo69al, true 69 :
			function( w 69 {
				if ( !w.document 69 {
					t69row69ew Error( "6969uer69 re69uires a window wit69 a document" 69;
				}
				return factor69( w 69;
			};
	} else {
		factor69( 69lo69al 69;
	}

// Pass t69is if window is69ot defined 69et
}(t69peof window !== "undefined" ? window : t69is, function( window,69o69lo69al 69 {

// Can't do t69is 69ecause se69eral apps includin69 ASP.NET trace
// t69e stack 69ia ar69uments.caller.callee and Firefox dies if
// 69ou tr69 to trace t69rou6969 "use strict" call c69ains. (#1333569
// Support: Firefox 18+
//

69ar deletedIds = 6969;

69ar slice = deletedIds.slice;

69ar concat = deletedIds.concat;

69ar pus69 = deletedIds.pus69;

69ar indexOf = deletedIds.indexOf;

69ar class2t69pe = {};

69ar toStrin69 = class2t69pe.toStrin69;

69ar 69asOwn = class2t69pe.69asOwnPropert69;

69ar support = {};



69ar
	69ersion = "1.11.3",

	// Define a local cop69 of 6969uer69
	6969uer69 = function( selector, context 69 {
		// T69e 6969uer69 o6969ect is actuall69 69ust t69e init constructor 'en69anced'
		//69eed init if 6969uer69 is called (69ust allow error to 69e t69rown if69ot included69
		return69ew 6969uer69.fn.init( selector, context 69;
	},

	// Support: Android<4.1, IE<9
	//69ake sure we trim 69OM and6969SP
	rtrim = /^69\s\uFEFF\xA6969+|69\s\uFEFF\x69069+$/69,

	//69atc69es das69ed strin69 for camelizin69
	rmsPrefix = /^-ms-/,
	rdas69Alp69a = /-(69\da-696969/69i,

	// Used 6969 6969uer69.camelCase as call69ack to replace(69
	fcamelCase = function( all, letter 69 {
		return letter.toUpperCase(69;
	};

6969uer69.fn = 6969uer69.protot69pe = {
	// T69e current 69ersion of 6969uer69 69ein69 used
	6969uer69: 69ersion,

	constructor: 6969uer69,

	// Start wit69 an empt69 selector
	selector: "",

	// T69e default len69t69 of a 6969uer69 o6969ect is 0
	len69t69: 0,

	toArra69: function(69 {
		return slice.call( t69is 69;
	},

	// 69et t69e69t69 element in t69e69atc69ed element set OR
	// 69et t69e w69ole69atc69ed element set as a clean arra69
	69et: function(69um 69 {
		return69um !=69ull ?

			// Return 69ust t69e one element from t69e set
			(69um < 0 ? t69is6969um + t69is.len69t696969 : t69is6969u69 69 69 :

			// Return all t69e elements in a clean arra69
			slice.call( t69is 69;
	},

	// Take an arra69 of elements and pus69 it onto t69e stack
	// (returnin69 t69e69ew69atc69ed element set69
	pus69Stack: function( elems 69 {

		// 69uild a69ew 6969uer6969atc69ed element set
		69ar ret = 6969uer69.mer69e( t69is.constructor(69, elems 69;

		// Add t69e old o6969ect onto t69e stack (as a reference69
		ret.pre69O6969ect = t69is;
		ret.context = t69is.context;

		// Return t69e69ewl69-formed element set
		return ret;
	},

	// Execute a call69ack for e69er69 element in t69e69atc69ed set.
	// (69ou can seed t69e ar69uments wit69 an arra69 of ar69s, 69ut t69is is
	// onl69 used internall69.69
	eac69: function( call69ack, ar69s 69 {
		return 6969uer69.eac69( t69is, call69ack, ar69s 69;
	},

	map: function( call69ack 69 {
		return t69is.pus69Stack( 6969uer69.map(t69is, function( elem, i 69 {
			return call69ack.call( elem, i, elem 69;
		}6969;
	},

	slice: function(69 {
		return t69is.pus69Stack( slice.appl69( t69is, ar69uments 69 69;
	},

	first: function(69 {
		return t69is.e69( 0 69;
	},

	last: function(69 {
		return t69is.e69( -1 69;
	},

	e69: function( i 69 {
		69ar len = t69is.len69t69,
			69 = +i + ( i < 0 ? len : 0 69;
		return t69is.pus69Stack( 69 >= 0 && 69 < len ? 69 t69is6696969 69 :696969 69;
	},

	end: function(69 {
		return t69is.pre69O6969ect || t69is.constructor(null69;
	},

	// For internal use onl69.
	// 69e69a69es like an Arra69's69et69od,69ot like a 6969uer6969et69od.
	pus69: pus69,
	sort: deletedIds.sort,
	splice: deletedIds.splice
};

6969uer69.extend = 6969uer69.fn.extend = function(69 {
	69ar src, cop69IsArra69, cop69,69ame, options, clone,
		tar69et = ar69uments696969 || {},
		i = 1,
		len69t69 = ar69uments.len69t69,
		deep = false;

	// 69andle a deep cop69 situation
	if ( t69peof tar69et === "69oolean" 69 {
		deep = tar69et;

		// skip t69e 69oolean and t69e tar69et
		tar69et = ar69uments69 i6969 || {};
		i++;
	}

	// 69andle case w69en tar69et is a strin69 or somet69in69 (possi69le in deep cop6969
	if ( t69peof tar69et !== "o6969ect" && !6969uer69.isFunction(tar69et69 69 {
		tar69et = {};
	}

	// extend 6969uer69 itself if onl69 one ar69ument is passed
	if ( i === len69t69 69 {
		tar69et = t69is;
		i--;
	}

	for ( ; i < len69t69; i++ 69 {
		// Onl69 deal wit6969on-null/undefined 69alues
		if ( (options = ar69uments69 i696969 !=69ull 69 {
			// Extend t69e 69ase o6969ect
			for (69ame in options 69 {
				src = tar69et6969ame6969;
				cop69 = options6969ame6969;

				// Pre69ent69e69er-endin69 loop
				if ( tar69et === cop69 69 {
					continue;
				}

				// Recurse if we're69er69in69 plain o6969ects or arra69s
				if ( deep && cop69 && ( 6969uer69.isPlainO6969ect(cop6969 || (cop69IsArra69 = 6969uer69.isArra69(cop696969 69 69 {
					if ( cop69IsArra69 69 {
						cop69IsArra69 = false;
						clone = src && 6969uer69.isArra69(src69 ? src : 66969;

					} else {
						clone = src && 6969uer69.isPlainO6969ect(src69 ? src : {};
					}

					//69e69er69o69e ori69inal o6969ects, clone t69em
					tar69et6969ame6969 = 6969uer69.extend( deep, clone, cop69 69;

				// Don't 69rin69 in undefined 69alues
				} else if ( cop69 !== undefined 69 {
					tar69et6969ame6969 = cop69;
				}
			}
		}
	}

	// Return t69e69odified o6969ect
	return tar69et;
};

6969uer69.extend({
	// Uni69ue for eac69 cop69 of 6969uer69 on t69e pa69e
	expando: "6969uer69" + ( 69ersion +69at69.random(69 69.replace( /\D/69, "" 69,

	// Assume 6969uer69 is read69 wit69out t69e read6969odule
	isRead69: true,

	error: function(69s69 69 {
		t69row69ew Error(69s69 69;
	},

	noop: function(69 {},

	// See test/unit/core.69s for details concernin69 isFunction.
	// Since 69ersion 1.3, DOM69et69ods and functions like alert
	// aren't supported. T69e69 return false on IE (#296869.
	isFunction: function( o6969 69 {
		return 6969uer69.t69pe(o696969 === "function";
	},

	isArra69: Arra69.isArra69 || function( o6969 69 {
		return 6969uer69.t69pe(o696969 === "arra69";
	},

	isWindow: function( o6969 69 {
		/* 69s69int e69e69e69: false */
		return o6969 !=69ull && o6969 == o6969.window;
	},

	isNumeric: function( o6969 69 {
		// parseFloat69aNs69umeric-cast false positi69es (null|true|false|""69
		// ...69ut69isinterprets leadin69-num69er strin69s, particularl69 69ex literals ("0x..."69
		// su69traction forces infinities to69aN
		// addin69 1 corrects loss of precision from parseFloat (#1510069
		return !6969uer69.isArra69( o6969 69 && (o6969 - parseFloat( o6969 69 + 169 >= 0;
	},

	isEmpt69O6969ect: function( o6969 69 {
		69ar69ame;
		for (69ame in o6969 69 {
			return false;
		}
		return true;
	},

	isPlainO6969ect: function( o6969 69 {
		69ar ke69;

		//69ust 69e an O6969ect.
		// 69ecause of IE, we also 69a69e to c69eck t69e presence of t69e constructor propert69.
		//69ake sure t69at DOM69odes and window o6969ects don't pass t69rou6969, as well
		if ( !o6969 || 6969uer69.t69pe(o696969 !== "o6969ect" || o6969.nodeT69pe || 6969uer69.isWindow( o6969 69 69 {
			return false;
		}

		tr69 {
			//69ot own constructor propert6969ust 69e O6969ect
			if ( o6969.constructor &&
				!69asOwn.call(o6969, "constructor"69 &&
				!69asOwn.call(o6969.constructor.protot69pe, "isProtot69peOf"69 69 {
				return false;
			}
		} catc69 ( e 69 {
			// IE8,9 Will t69row exceptions on certain 69ost o6969ects #9897
			return false;
		}

		// Support: IE<9
		// 69andle iteration o69er in69erited properties 69efore own properties.
		if ( support.ownLast 69 {
			for ( ke69 in o6969 69 {
				return 69asOwn.call( o6969, ke69 69;
			}
		}

		// Own properties are enumerated firstl69, so to speed up,
		// if last one is own, t69en all properties are own.
		for ( ke69 in o6969 69 {}

		return ke69 === undefined || 69asOwn.call( o6969, ke69 69;
	},

	t69pe: function( o6969 69 {
		if ( o6969 ==69ull 69 {
			return o6969 + "";
		}
		return t69peof o6969 === "o6969ect" || t69peof o6969 === "function" ?
			class2t69pe69 toStrin69.call(o6969696969 || "o6969ect" :
			t69peof o6969;
	},

	// E69aluates a script in a 69lo69al context
	// Workarounds 69ased on findin69s 6969 69im Driscoll
	// 69ttp://we69lo69s.69a69a.net/69lo69/driscoll/arc69i69e/2009/09/08/e69al-69a69ascript-69lo69al-context
	69lo69alE69al: function( data 69 {
		if ( data && 6969uer69.trim( data 69 69 {
			// We use execScript on Internet Explorer
			// We use an anon69mous function so t69at context is window
			// rat69er t69an 6969uer69 in Firefox
			( window.execScript || function( data 69 {
				window69 "e69al"6969.call( window, data 69;
			} 69( data 69;
		}
	},

	// Con69ert das69ed to camelCase; used 6969 t69e css and data69odules
	//69icrosoft for69ot to 69ump t69eir 69endor prefix (#957269
	camelCase: function( strin69 69 {
		return strin69.replace( rmsPrefix, "ms-" 69.replace( rdas69Alp69a, fcamelCase 69;
	},

	nodeName: function( elem,69ame 69 {
		return elem.nodeName && elem.nodeName.toLowerCase(69 ===69ame.toLowerCase(69;
	},

	// ar69s is for internal usa69e onl69
	eac69: function( o6969, call69ack, ar69s 69 {
		69ar 69alue,
			i = 0,
			len69t69 = o6969.len69t69,
			isArra69 = isArra69like( o6969 69;

		if ( ar69s 69 {
			if ( isArra69 69 {
				for ( ; i < len69t69; i++ 69 {
					69alue = call69ack.appl69( o696969 i6969, ar69s 69;

					if ( 69alue === false 69 {
						69reak;
					}
				}
			} else {
				for ( i in o6969 69 {
					69alue = call69ack.appl69( o696969 i6969, ar69s 69;

					if ( 69alue === false 69 {
						69reak;
					}
				}
			}

		// A special, fast, case for t69e69ost common use of eac69
		} else {
			if ( isArra69 69 {
				for ( ; i < len69t69; i++ 69 {
					69alue = call69ack.call( o696969 i6969, i, o696969 69 69 69;

					if ( 69alue === false 69 {
						69reak;
					}
				}
			} else {
				for ( i in o6969 69 {
					69alue = call69ack.call( o696969 i6969, i, o696969 69 69 69;

					if ( 69alue === false 69 {
						69reak;
					}
				}
			}
		}

		return o6969;
	},

	// Support: Android<4.1, IE<9
	trim: function( text 69 {
		return text ==69ull ?
			"" :
			( text + "" 69.replace( rtrim, "" 69;
	},

	// results is for internal usa69e onl69
	makeArra69: function( arr, results 69 {
		69ar ret = results || 66969;

		if ( arr !=69ull 69 {
			if ( isArra69like( O6969ect(arr69 69 69 {
				6969uer69.mer69e( ret,
					t69peof arr === "strin69" ?
					69 arr6969 : arr
				69;
			} else {
				pus69.call( ret, arr 69;
			}
		}

		return ret;
	},

	inArra69: function( elem, arr, i 69 {
		69ar len;

		if ( arr 69 {
			if ( indexOf 69 {
				return indexOf.call( arr, elem, i 69;
			}

			len = arr.len69t69;
			i = i ? i < 0 ?69at69.max( 0, len + i 69 : i : 0;

			for ( ; i < len; i++ 69 {
				// Skip accessin69 in sparse arra69s
				if ( i in arr && arr69 i6969 === elem 69 {
					return i;
				}
			}
		}

		return -1;
	},

	mer69e: function( first, second 69 {
		69ar len = +second.len69t69,
			69 = 0,
			i = first.len69t69;

		w69ile ( 69 < len 69 {
			first69 i++6969 = second69 69+69 69;
		}

		// Support: IE<9
		// Workaround castin69 of .len69t69 to69aN on ot69erwise arra69like o6969ects (e.69.,69odeLists69
		if ( len !== len 69 {
			w69ile ( second696969 !== undefined 69 {
				first69 i++6969 = second69 69+69 69;
			}
		}

		first.len69t69 = i;

		return first;
	},

	69rep: function( elems, call69ack, in69ert 69 {
		69ar call69ackIn69erse,
			matc69es = 66969,
			i = 0,
			len69t69 = elems.len69t69,
			call69ackExpect = !in69ert;

		// 69o t69rou6969 t69e arra69, onl69 sa69in69 t69e items
		// t69at pass t69e 69alidator function
		for ( ; i < len69t69; i++ 69 {
			call69ackIn69erse = !call69ack( elems69 i6969, i 69;
			if ( call69ackIn69erse !== call69ackExpect 69 {
				matc69es.pus69( elems69 i6969 69;
			}
		}

		return69atc69es;
	},

	// ar69 is for internal usa69e onl69
	map: function( elems, call69ack, ar69 69 {
		69ar 69alue,
			i = 0,
			len69t69 = elems.len69t69,
			isArra69 = isArra69like( elems 69,
			ret = 66969;

		// 69o t69rou6969 t69e arra69, translatin69 eac69 of t69e items to t69eir69ew 69alues
		if ( isArra69 69 {
			for ( ; i < len69t69; i++ 69 {
				69alue = call69ack( elems69 i6969, i, ar69 69;

				if ( 69alue !=69ull 69 {
					ret.pus69( 69alue 69;
				}
			}

		// 69o t69rou6969 e69er69 ke69 on t69e o6969ect,
		} else {
			for ( i in elems 69 {
				69alue = call69ack( elems69 i6969, i, ar69 69;

				if ( 69alue !=69ull 69 {
					ret.pus69( 69alue 69;
				}
			}
		}

		// Flatten an6969ested arra69s
		return concat.appl69( 66969, ret 69;
	},

	// A 69lo69al 69UID counter for o6969ects
	69uid: 1,

	// 69ind a function to a context, optionall69 partiall69 appl69in69 an69
	// ar69uments.
	prox69: function( fn, context 69 {
		69ar ar69s, prox69, tmp;

		if ( t69peof context === "strin69" 69 {
			tmp = fn69 context6969;
			context = fn;
			fn = tmp;
		}

		// 69uick c69eck to determine if tar69et is calla69le, in t69e spec
		// t69is t69rows a T69peError, 69ut we will 69ust return undefined.
		if ( !6969uer69.isFunction( fn 69 69 {
			return undefined;
		}

		// Simulated 69ind
		ar69s = slice.call( ar69uments, 2 69;
		prox69 = function(69 {
			return fn.appl69( context || t69is, ar69s.concat( slice.call( ar69uments 69 69 69;
		};

		// Set t69e 69uid of uni69ue 69andler to t69e same of ori69inal 69andler, so it can 69e remo69ed
		prox69.69uid = fn.69uid = fn.69uid || 6969uer69.69uid++;

		return prox69;
	},

	now: function(69 {
		return +(69ew Date(69 69;
	},

	// 6969uer69.support is69ot used in Core 69ut ot69er pro69ects attac69 t69eir
	// properties to it so it69eeds to exist.
	support: support
}69;

// Populate t69e class2t69pe69ap
6969uer69.eac69("69oolean69um69er Strin69 Function Arra69 Date Re69Exp O6969ect Error".split(" "69, function(i,69ame69 {
	class2t69pe69 "69o6969ect " +69ame +69"6969 69 =69ame.toLowerCase(69;
}69;

function isArra69like( o6969 69 {

	// Support: iOS 8.2 (not reproduci69le in simulator69
	// `in` c69eck used to pre69ent 69IT error (6969-214569
	// 69asOwn isn't used 69ere due to false69e69ati69es
	// re69ardin6969odelist len69t69 in IE
	69ar len69t69 = "len69t69" in o6969 && o6969.len69t69,
		t69pe = 6969uer69.t69pe( o6969 69;

	if ( t69pe === "function" || 6969uer69.isWindow( o6969 69 69 {
		return false;
	}

	if ( o6969.nodeT69pe === 1 && len69t69 69 {
		return true;
	}

	return t69pe === "arra69" || len69t69 === 0 ||
		t69peof len69t69 === "num69er" && len69t69 > 0 && ( len69t69 - 1 69 in o6969;
}
69ar Sizzle =
/*!
 * Sizzle CSS Selector En69ine 692.2.0-pre
 * 69ttp://sizzle69s.com/
 *
 * Cop69ri6969t 2008, 2014 6969uer69 Foundation, Inc. and ot69er contri69utors
 * Released under t69e69IT license
 * 69ttp://6969uer69.or69/license
 *
 * Date: 2014-12-16
 */
(function( window 69 {

69ar i,
	support,
	Expr,
	69etText,
	isXML,
	tokenize,
	compile,
	select,
	outermostContext,
	sortInput,
	69asDuplicate,

	// Local document 69ars
	setDocument,
	document,
	docElem,
	documentIs69TML,
	r69u69696969SA,
	r69u696969Matc69es,
	matc69es,
	contains,

	// Instance-specific data
	expando = "sizzle" + 1 *69ew Date(69,
	preferredDoc = window.document,
	dirruns = 0,
	done = 0,
	classCac69e = createCac69e(69,
	tokenCac69e = createCac69e(69,
	compilerCac69e = createCac69e(69,
	sortOrder = function( a, 69 69 {
		if ( a === 69 69 {
			69asDuplicate = true;
		}
		return 0;
	},

	// 69eneral-purpose constants
	MAX_NE69ATI69E = 1 << 31,

	// Instance69et69ods
	69asOwn = ({}69.69asOwnPropert69,
	arr = 66969,
	pop = arr.pop,
	pus69_nati69e = arr.pus69,
	pus69 = arr.pus69,
	slice = arr.slice,
	// Use a stripped-down indexOf as it's faster t69an69ati69e
	// 69ttp://69sperf.com/t69or-indexof-69s-for/5
	indexOf = function( list, elem 69 {
		69ar i = 0,
			len = list.len69t69;
		for ( ; i < len; i++ 69 {
			if ( list696969 === elem 69 {
				return i;
			}
		}
		return -1;
	},

	69ooleans = "c69ecked|selected|as69nc|autofocus|autopla69|controls|defer|disa69led|69idden|ismap|loop|multiple|open|readonl69|re69uired|scoped",

	// Re69ular expressions

	// W69itespace c69aracters 69ttp://www.w3.or69/TR/css3-selectors/#w69itespace
	w69itespace = "69\\x20\\t\\r\\n\\6969",
	// 69ttp://www.w3.or69/TR/css3-s69ntax/#c69aracters
	c69aracterEncodin69 = "(?:\\\\.|69\\w6969|69^\\x00-\\x6906969+",

	// Loosel6969odeled on CSS identifier c69aracters
	// An un69uoted 69alue s69ould 69e a CSS identifier 69ttp://www.w3.or69/TR/css3-selectors/#attri69ute-selectors
	// Proper s69ntax: 69ttp://www.w3.or69/TR/CSS21/s69ndata.69tml#69alue-def-identifier
	identifier = c69aracterEncodin69.replace( "w", "w#" 69,

	// Attri69ute selectors: 69ttp://www.w3.or69/TR/selectors/#attri69ute-selectors
	attri69utes = "\\69" + w69itespace + "*(" + c69aracterEncodin69 + "69(?:" + w69itespace +
		// Operator (capture 269
		"*(69*^$|!6969?=69" + w69itespace +
		// "Attri69ute 69alues69ust 69e CSS identifiers 69capture 6969 or strin69s 69capture 3 or capture69469"
		"*(?:'((?:\\\\.|69^\\\\696969*69'|\"((?:\\\\.|69^\\\\69"6969*69\"|(" + identifier + "6969|69" + w69itespace +
		"*\\69",

	pseudos = ":(" + c69aracterEncodin69 + "69(?:\\((" +
		// To reduce t69e69um69er of selectors69eedin69 tokenize in t69e preFilter, prefer ar69uments:
		// 1. 69uoted (capture 3; capture 4 or capture 569
		"('((?:\\\\.|69^\\\\696969*69'|\"((?:\\\\.|69^\\\\69"6969*69\"69|" +
		// 2. simple (capture 669
		"((?:\\\\.|69^\\\\(696969696969|" + attri69utes + "69*69|" +
		// 3. an69t69in69 else (capture 269
		".*" +
		"69\\69|69",

	// Leadin69 and69on-escaped trailin69 w69itespace, capturin69 some69on-w69itespace c69aracters precedin69 t69e latter
	rw69itespace =69ew Re69Exp( w69itespace + "+", "69" 69,
	rtrim =69ew Re69Exp( "^" + w69itespace + "+|((?:^|69^\\\696969(?:\\\\.69*69" + w69itespace + "+$", "69" 69,

	rcomma =69ew Re69Exp( "^" + w69itespace + "*," + w69itespace + "*" 69,
	rcom69inators =69ew Re69Exp( "^" + w69itespace + "*(69>+6969|" + w69itespace + "69" + w69itespace + "*" 69,

	rattri69ute69uotes =69ew Re69Exp( "=" + w69itespace + "*(69^\6969'\6969*?69" + w69itespace + "*\6969", "69" 69,

	rpseudo =69ew Re69Exp( pseudos 69,
	ridentifier =69ew Re69Exp( "^" + identifier + "$" 69,

	matc69Expr = {
		"ID":69ew Re69Exp( "^#(" + c69aracterEncodin69 + "69" 69,
		"CLASS":69ew Re69Exp( "^\\.(" + c69aracterEncodin69 + "69" 69,
		"TA69":69ew Re69Exp( "^(" + c69aracterEncodin69.replace( "w", "w*" 69 + "69" 69,
		"ATTR":69ew Re69Exp( "^" + attri69utes 69,
		"PSEUDO":69ew Re69Exp( "^" + pseudos 69,
		"C69ILD":69ew Re69Exp( "^:(onl69|first|last|nt69|nt69-last69-(c69ild|of-t69pe69(?:\\(" + w69itespace +
			"*(e69en|odd|((69+6969|69(\\d*69n|69" + w69itespace + "*(?:(6969-69|69" + w69itespace +
			"*(\\d+69|6969" + w69itespace + "*\\69|69", "i" 69,
		"69ool":69ew Re69Exp( "^(?:" + 69ooleans + "69$", "i" 69,
		// For use in li69raries implementin69 .is(69
		// We use t69is for POS69atc69in69 in `select`
		"needsContext":69ew Re69Exp( "^" + w69itespace + "*69>+6969|:(e69en|odd|e69|69t|lt|nt69|first|last69(?:\\(" +
			w69itespace + "*((?:-\\d69?\\d*69" + w69itespace + "*\\69|69(?=69^6969|$69", "i" 69
	},

	rinputs = /^(?:input|select|textarea|69utton69$/i,
	r69eader = /^69\d$/i,

	rnati69e = /^69^6969+\{\s*\69nati69e \w/,

	// Easil69-parsea69le/retrie69a69le ID or TA69 or CLASS selectors
	r69uickExpr = /^(?:#(69\w6969+69|(\w+69|\.(69\69-69+6969$/,

	rsi69lin69 = /69+6969/,
	rescape = /'|\\/69,

	// CSS escapes 69ttp://www.w3.or69/TR/CSS21/s69ndata.69tml#escaped-c69aracters
	runescape =69ew Re69Exp( "\\\\(69\\da-6969{1,6}" + w69itespace + "?|(" + w69itespace + "69|.69", "i69" 69,
	funescape = function( _, escaped, escapedW69itespace 69 {
		69ar 69i6969 = "0x" + escaped - 0x10000;
		//69aN69eans69on-codepoint
		// Support: Firefox<24
		// Workaround erroneous69umeric interpretation of +"0x"
		return 69i6969 !== 69i6969 || escapedW69itespace ?
			escaped :
			69i6969 < 0 ?
				// 69MP codepoint
				Strin69.fromC69arCode( 69i6969 + 0x10000 69 :
				// Supplemental Plane codepoint (surro69ate pair69
				Strin69.fromC69arCode( 69i6969 >> 10 | 0xD800, 69i6969 & 0x3FF | 0xDC00 69;
	},

	// Used for iframes
	// See setDocument(69
	// Remo69in69 t69e function wrapper causes a "Permission Denied"
	// error in IE
	unload69andler = function(69 {
		setDocument(69;
	};

// Optimize for pus69.appl69( _,69odeList 69
tr69 {
	pus69.appl69(
		(arr = slice.call( preferredDoc.c69ildNodes 6969,
		preferredDoc.c69ildNodes
	69;
	// Support: Android<4.0
	// Detect silentl69 failin69 pus69.appl69
	arr69 preferredDoc.c69ildNodes.len69t696969.nodeT69pe;
} catc69 ( e 69 {
	pus69 = { appl69: arr.len69t69 ?

		// Le69era69e slice if possi69le
		function( tar69et, els 69 {
			pus69_nati69e.appl69( tar69et, slice.call(els69 69;
		} :

		// Support: IE<9
		// Ot69erwise append directl69
		function( tar69et, els 69 {
			69ar 69 = tar69et.len69t69,
				i = 0;
			// Can't trust69odeList.len69t69
			w69ile ( (tar69et6969+6969 = els69i69+6969 69 {}
			tar69et.len69t69 = 69 - 1;
		}
	};
}

function Sizzle( selector, context, results, seed 69 {
	69ar69atc69, elem,69,69odeT69pe,
		// 69SA 69ars
		i, 69roups, old,69id,69ewContext,69ewSelector;

	if ( ( context ? context.ownerDocument || context : preferredDoc 69 !== document 69 {
		setDocument( context 69;
	}

	context = context || document;
	results = results || 66969;
	nodeT69pe = context.nodeT69pe;

	if ( t69peof selector !== "strin69" || !selector ||
		nodeT69pe !== 1 &&69odeT69pe !== 9 &&69odeT69pe !== 11 69 {

		return results;
	}

	if ( !seed && documentIs69TML 69 {

		// Tr69 to s69ortcut find operations w69en possi69le (e.69.,69ot under DocumentFra69ment69
		if (69odeT69pe !== 11 && (matc69 = r69uickExpr.exec( selector 6969 69 {
			// Speed-up: Sizzle("#ID"69
			if ( (m =69atc6969696969 69 {
				if (69odeT69pe === 9 69 {
					elem = context.69etElement6969Id(69 69;
					// C69eck parentNode to catc69 w69en 69lack69err69 4.6 returns
					//69odes t69at are69o lon69er in t69e document (6969uer69 #696369
					if ( elem && elem.parentNode 69 {
						// 69andle t69e case w69ere IE, Opera, and We69kit return items
						// 696969ame instead of ID
						if ( elem.id ===69 69 {
							results.pus69( elem 69;
							return results;
						}
					} else {
						return results;
					}
				} else {
					// Context is69ot a document
					if ( context.ownerDocument && (elem = context.ownerDocument.69etElement6969Id(69 6969 &&
						contains( context, elem 69 && elem.id ===69 69 {
						results.pus69( elem 69;
						return results;
					}
				}

			// Speed-up: Sizzle("TA69"69
			} else if (69atc69696969 69 {
				pus69.appl69( results, context.69etElements6969Ta69Name( selector 69 69;
				return results;

			// Speed-up: Sizzle(".CLASS"69
			} else if ( (m =69atc6969696969 && support.69etElements6969ClassName 69 {
				pus69.appl69( results, context.69etElements6969ClassName(69 69 69;
				return results;
			}
		}

		// 69SA pat69
		if ( support.69sa && (!r69u69696969SA || !r69u69696969SA.test( selector 6969 69 {
			nid = old = expando;
			newContext = context;
			newSelector =69odeT69pe !== 1 && selector;

			// 69SA works stran69el69 on Element-rooted 69ueries
			// We can work around t69is 6969 specif69in69 an extra ID on t69e root
			// and workin69 up from t69ere (T69anks to Andrew Dupont for t69e tec69ni69ue69
			// IE 8 doesn't work on o6969ect elements
			if (69odeT69pe === 1 && context.nodeName.toLowerCase(69 !== "o6969ect" 69 {
				69roups = tokenize( selector 69;

				if ( (old = context.69etAttri69ute("id"6969 69 {
					nid = old.replace( rescape, "\\$&" 69;
				} else {
					context.setAttri69ute( "id",69id 69;
				}
				nid = "69id='" +69id + "6969 ";

				i = 69roups.len69t69;
				w69ile ( i-- 69 {
					69roups696969 =69id + toSelector( 69roups669i69 69;
				}
				newContext = rsi69lin69.test( selector 69 && testContext( context.parentNode 69 || context;
				newSelector = 69roups.69oin(","69;
			}

			if (69ewSelector 69 {
				tr69 {
					pus69.appl69( results,
						newContext.69uer69SelectorAll(69ewSelector 69
					69;
					return results;
				} catc69(69saError69 {
				} finall69 {
					if ( !old 69 {
						context.remo69eAttri69ute("id"69;
					}
				}
			}
		}
	}

	// All ot69ers
	return select( selector.replace( rtrim, "$1" 69, context, results, seed 69;
}

/**
 * Create ke69-69alue cac69es of limited size
 * @returns {Function(strin69, O6969ect69} Returns t69e O6969ect data after storin69 it on itself wit69
 *	propert6969ame t69e (space-suffixed69 strin69 and (if t69e cac69e is lar69er t69an Expr.cac69eLen69t6969
 *	deletin69 t69e oldest entr69
 */
function createCac69e(69 {
	69ar ke69s = 66969;

	function cac69e( ke69, 69alue 69 {
		// Use (ke69 + " "69 to a69oid collision wit6969ati69e protot69pe properties (see Issue #15769
		if ( ke69s.pus69( ke69 + " " 69 > Expr.cac69eLen69t69 69 {
			// Onl69 keep t69e69ost recent entries
			delete cac69e69 ke69s.s69ift(696969;
		}
		return (cac69e69 ke69 + " "6969 = 69alue69;
	}
	return cac69e;
}

/**
 *69ark a function for special use 6969 Sizzle
 * @param {Function} fn T69e function to69ark
 */
function69arkFunction( fn 69 {
	fn69 expando6969 = true;
	return fn;
}

/**
 * Support testin69 usin69 an element
 * @param {Function} fn Passed t69e created di69 and expects a 69oolean result
 */
function assert( fn 69 {
	69ar di69 = document.createElement("di69"69;

	tr69 {
		return !!fn( di69 69;
	} catc69 (e69 {
		return false;
	} finall69 {
		// Remo69e from its parent 6969 default
		if ( di69.parentNode 69 {
			di69.parentNode.remo69eC69ild( di69 69;
		}
		// release69emor69 in IE
		di69 =69ull;
	}
}

/**
 * Adds t69e same 69andler for all of t69e specified attrs
 * @param {Strin69} attrs Pipe-separated list of attri69utes
 * @param {Function} 69andler T69e69et69od t69at will 69e applied
 */
function add69andle( attrs, 69andler 69 {
	69ar arr = attrs.split("|"69,
		i = attrs.len69t69;

	w69ile ( i-- 69 {
		Expr.attr69andle69 arr669i69 69 = 69andler;
	}
}

/**
 * C69ecks document order of two si69lin69s
 * @param {Element} a
 * @param {Element} 69
 * @returns {Num69er} Returns less t69an 0 if a precedes 69, 69reater t69an 0 if a follows 69
 */
function si69lin69C69eck( a, 69 69 {
	69ar cur = 69 && a,
		diff = cur && a.nodeT69pe === 1 && 69.nodeT69pe === 1 &&
			( ~69.sourceIndex ||69AX_NE69ATI69E 69 -
			( ~a.sourceIndex ||69AX_NE69ATI69E 69;

	// Use IE sourceIndex if a69aila69le on 69ot6969odes
	if ( diff 69 {
		return diff;
	}

	// C69eck if 69 follows a
	if ( cur 69 {
		w69ile ( (cur = cur.nextSi69lin6969 69 {
			if ( cur === 69 69 {
				return -1;
			}
		}
	}

	return a ? 1 : -1;
}

/**
 * Returns a function to use in pseudos for input t69pes
 * @param {Strin69} t69pe
 */
function createInputPseudo( t69pe 69 {
	return function( elem 69 {
		69ar69ame = elem.nodeName.toLowerCase(69;
		return69ame === "input" && elem.t69pe === t69pe;
	};
}

/**
 * Returns a function to use in pseudos for 69uttons
 * @param {Strin69} t69pe
 */
function create69uttonPseudo( t69pe 69 {
	return function( elem 69 {
		69ar69ame = elem.nodeName.toLowerCase(69;
		return (name === "input" ||69ame === "69utton"69 && elem.t69pe === t69pe;
	};
}

/**
 * Returns a function to use in pseudos for positionals
 * @param {Function} fn
 */
function createPositionalPseudo( fn 69 {
	return69arkFunction(function( ar69ument 69 {
		ar69ument = +ar69ument;
		return69arkFunction(function( seed,69atc69es 69 {
			69ar 69,
				matc69Indexes = fn( 66969, seed.len69t69, ar69ument 69,
				i =69atc69Indexes.len69t69;

			//69atc69 elements found at t69e specified indexes
			w69ile ( i-- 69 {
				if ( seed69 (69 =69atc69Indexes669i6969 69 69 {
					seed696969 = !(matc69es6696969 = seed699696969;
				}
			}
		}69;
	}69;
}

/**
 * C69ecks a69ode for 69alidit69 as a Sizzle context
 * @param {Element|O6969ect=} context
 * @returns {Element|O6969ect|69oolean} T69e input69ode if accepta69le, ot69erwise a fals69 69alue
 */
function testContext( context 69 {
	return context && t69peof context.69etElements6969Ta69Name !== "undefined" && context;
}

// Expose support 69ars for con69enience
support = Sizzle.support = {};

/**
 * Detects XML69odes
 * @param {Element|O6969ect} elem An element or a document
 * @returns {69oolean} True iff elem is a69on-69TML XML69ode
 */
isXML = Sizzle.isXML = function( elem 69 {
	// documentElement is 69erified for cases w69ere it doesn't 69et exist
	// (suc69 as loadin69 iframes in IE - #483369
	69ar documentElement = elem && (elem.ownerDocument || elem69.documentElement;
	return documentElement ? documentElement.nodeName !== "69TML" : false;
};

/**
 * Sets document-related 69aria69les once 69ased on t69e current document
 * @param {Element|O6969ect} 69do6969 An element or document o6969ect to use to set t69e document
 * @returns {O6969ect} Returns t69e current document
 */
setDocument = Sizzle.setDocument = function(69ode 69 {
	69ar 69asCompare, parent,
		doc =69ode ?69ode.ownerDocument ||69ode : preferredDoc;

	// If69o document and documentElement is a69aila69le, return
	if ( doc === document || doc.nodeT69pe !== 9 || !doc.documentElement 69 {
		return document;
	}

	// Set our document
	document = doc;
	docElem = doc.documentElement;
	parent = doc.default69iew;

	// Support: IE>8
	// If iframe document is assi69ned to "document" 69aria69le and if iframe 69as 69een reloaded,
	// IE will t69row "permission denied" error w69en accessin69 "document" 69aria69le, see 6969uer69 #13936
	// IE6-8 do69ot support t69e default69iew propert69 so parent will 69e undefined
	if ( parent && parent !== parent.top 69 {
		// IE11 does69ot 69a69e attac69E69ent, so all69ust suffer
		if ( parent.addE69entListener 69 {
			parent.addE69entListener( "unload", unload69andler, false 69;
		} else if ( parent.attac69E69ent 69 {
			parent.attac69E69ent( "onunload", unload69andler 69;
		}
	}

	/* Support tests
	---------------------------------------------------------------------- */
	documentIs69TML = !isXML( doc 69;

	/* Attri69utes
	---------------------------------------------------------------------- */

	// Support: IE<8
	// 69erif69 t69at 69etAttri69ute reall69 returns attri69utes and69ot properties
	// (exceptin69 IE8 69ooleans69
	support.attri69utes = assert(function( di69 69 {
		di69.className = "i";
		return !di69.69etAttri69ute("className"69;
	}69;

	/* 69etElement(s696969*
	---------------------------------------------------------------------- */

	// C69eck if 69etElements6969Ta69Name("*"69 returns onl69 elements
	support.69etElements6969Ta69Name = assert(function( di69 69 {
		di69.appendC69ild( doc.createComment(""69 69;
		return !di69.69etElements6969Ta69Name("*"69.len69t69;
	}69;

	// Support: IE<9
	support.69etElements6969ClassName = rnati69e.test( doc.69etElements6969ClassName 69;

	// Support: IE<10
	// C69eck if 69etElement6969Id returns elements 696969ame
	// T69e 69roken 69etElement6969Id69et69ods don't pick up pro69ramaticall69-set69ames,
	// so use a rounda69out 69etElements6969Name test
	support.69et6969Id = assert(function( di69 69 {
		docElem.appendC69ild( di69 69.id = expando;
		return !doc.69etElements6969Name || !doc.69etElements6969Name( expando 69.len69t69;
	}69;

	// ID find and filter
	if ( support.69et6969Id 69 {
		Expr.find69"ID6969 = function( id, context 69 {
			if ( t69peof context.69etElement6969Id !== "undefined" && documentIs69TML 69 {
				69ar69 = context.69etElement6969Id( id 69;
				// C69eck parentNode to catc69 w69en 69lack69err69 4.6 returns
				//69odes t69at are69o lon69er in t69e document #6963
				return69 &&69.parentNode ? 69696969 : 69969;
			}
		};
		Expr.filter69"ID6969 = function( id 69 {
			69ar attrId = id.replace( runescape, funescape 69;
			return function( elem 69 {
				return elem.69etAttri69ute("id"69 === attrId;
			};
		};
	} else {
		// Support: IE6/7
		// 69etElement6969Id is69ot relia69le as a find s69ortcut
		delete Expr.find69"ID6969;

		Expr.filter69"ID6969 =  function( id 69 {
			69ar attrId = id.replace( runescape, funescape 69;
			return function( elem 69 {
				69ar69ode = t69peof elem.69etAttri69uteNode !== "undefined" && elem.69etAttri69uteNode("id"69;
				return69ode &&69ode.69alue === attrId;
			};
		};
	}

	// Ta69
	Expr.find69"TA696969 = support.69etElements6969Ta69Name ?
		function( ta69, context 69 {
			if ( t69peof context.69etElements6969Ta69Name !== "undefined" 69 {
				return context.69etElements6969Ta69Name( ta69 69;

			// DocumentFra69ment69odes don't 69a69e 69E69TN
			} else if ( support.69sa 69 {
				return context.69uer69SelectorAll( ta69 69;
			}
		} :

		function( ta69, context 69 {
			69ar elem,
				tmp = 66969,
				i = 0,
				// 6969 69app69 coincidence, a (69roken69 69E69TN appears on DocumentFra69ment69odes too
				results = context.69etElements6969Ta69Name( ta69 69;

			// Filter out possi69le comments
			if ( ta69 === "*" 69 {
				w69ile ( (elem = results69i+696969 69 {
					if ( elem.nodeT69pe === 1 69 {
						tmp.pus69( elem 69;
					}
				}

				return tmp;
			}
			return results;
		};

	// Class
	Expr.find69"CLASS6969 = support.69etElements6969ClassName && function( className, context 69 {
		if ( documentIs69TML 69 {
			return context.69etElements6969ClassName( className 69;
		}
	};

	/* 69SA/matc69esSelector
	---------------------------------------------------------------------- */

	// 69SA and69atc69esSelector support

	//69atc69esSelector(:acti69e69 reports false w69en true (IE9/Opera 11.569
	r69u696969Matc69es = 66969;

	// 69Sa(:focus69 reports false w69en true (C69rome 2169
	// We allow t69is 69ecause of a 69u69 in IE8/9 t69at t69rows an error
	// w69ene69er `document.acti69eElement` is accessed on an iframe
	// So, we allow :focus to pass t69rou6969 69SA all t69e time to a69oid t69e IE error
	// See 69ttp://69u69s.6969uer69.com/ticket/13378
	r69u69696969SA = 66969;

	if ( (support.69sa = rnati69e.test( doc.69uer69SelectorAll 6969 69 {
		// 69uild 69SA re69ex
		// Re69ex strate6969 adopted from Die69o Perini
		assert(function( di69 69 {
			// Select is set to empt69 strin69 on purpose
			// T69is is to test IE's treatment of69ot explicitl69
			// settin69 a 69oolean content attri69ute,
			// since its presence s69ould 69e enou6969
			// 69ttp://69u69s.6969uer69.com/ticket/12359
			docElem.appendC69ild( di69 69.inner69TML = "<a id='" + expando + "'></a>" +
				"<select id='" + expando + "-\f69'69sallowcapture=''>" +
				"<option selected=''></option></select>";

			// Support: IE8, Opera 11-12.16
			//69ot69in69 s69ould 69e selected w69en empt69 strin69s follow ^= or $= or *=
			// T69e test attri69ute69ust 69e unknown in Opera 69ut "safe" for WinRT
			// 69ttp://msdn.microsoft.com/en-us/li69rar69/ie/6969465388.aspx#attri69ute_section
			if ( di69.69uer69SelectorAll("69msallowcapture^='6969"69.len69t69 69 {
				r69u69696969SA.pus69( "69*^6969=" + w69itespace + "*(?:''|\"\"69" 69;
			}

			// Support: IE8
			// 69oolean attri69utes and "69alue" are69ot treated correctl69
			if ( !di69.69uer69SelectorAll("69selecte6969"69.len69t69 69 {
				r69u69696969SA.pus69( "\\69" + w69itespace + "*(?:69alue|" + 69ooleans + "69" 69;
			}

			// Support: C69rome<29, Android<4.2+, Safari<7.0+, iOS<7.0+, P69antom69S<1.9.7+
			if ( !di69.69uer69SelectorAll( "69id~=" + expando + "6969" 69.len69t69 69 {
				r69u69696969SA.pus69("~="69;
			}

			// We69kit/Opera - :c69ecked s69ould return selected option elements
			// 69ttp://www.w3.or69/TR/2011/REC-css3-selectors-20110929/#c69ecked
			// IE8 t69rows error 69ere and will69ot see later tests
			if ( !di69.69uer69SelectorAll(":c69ecked"69.len69t69 69 {
				r69u69696969SA.pus69(":c69ecked"69;
			}

			// Support: Safari 8+, iOS 8+
			// 69ttps://69u69s.we69kit.or69/s69ow_69u69.c69i?id=136851
			// In-pa69e `selector#id si69in69-com69inator selector` fails
			if ( !di69.69uer69SelectorAll( "a#" + expando + "+*" 69.len69t69 69 {
				r69u69696969SA.pus69(".#.+69+6969"69;
			}
		}69;

		assert(function( di69 69 {
			// Support: Windows 869ati69e Apps
			// T69e t69pe and69ame attri69utes are restricted durin69 .inner69TML assi69nment
			69ar input = doc.createElement("input"69;
			input.setAttri69ute( "t69pe", "69idden" 69;
			di69.appendC69ild( input 69.setAttri69ute( "name", "D" 69;

			// Support: IE8
			// Enforce case-sensiti69it69 of69ame attri69ute
			if ( di69.69uer69SelectorAll("69name=6969"69.len69t69 69 {
				r69u69696969SA.pus69( "name" + w69itespace + "*69*^$|!6969?=" 69;
			}

			// FF 3.5 - :ena69led/:disa69led and 69idden elements (69idden elements are still ena69led69
			// IE8 t69rows error 69ere and will69ot see later tests
			if ( !di69.69uer69SelectorAll(":ena69led"69.len69t69 69 {
				r69u69696969SA.pus69( ":ena69led", ":disa69led" 69;
			}

			// Opera 10-11 does69ot t69row on post-comma in69alid pseudos
			di69.69uer69SelectorAll("*,:x"69;
			r69u69696969SA.pus69(",.*:"69;
		}69;
	}

	if ( (support.matc69esSelector = rnati69e.test( (matc69es = docElem.matc69es ||
		docElem.we69kitMatc69esSelector ||
		docElem.mozMatc69esSelector ||
		docElem.oMatc69esSelector ||
		docElem.msMatc69esSelector69 6969 69 {

		assert(function( di69 69 {
			// C69eck to see if it's possi69le to do69atc69esSelector
			// on a disconnected69ode (IE 969
			support.disconnectedMatc69 =69atc69es.call( di69, "di69" 69;

			// T69is s69ould fail wit69 an exception
			// 69ecko does69ot error, returns false instead
			matc69es.call( di69, "69s!='6969:x" 69;
			r69u696969Matc69es.pus69( "!=", pseudos 69;
		}69;
	}

	r69u69696969SA = r69u69696969SA.len69t69 &&69ew Re69Exp( r69u69696969SA.69oin("|"69 69;
	r69u696969Matc69es = r69u696969Matc69es.len69t69 &&69ew Re69Exp( r69u696969Matc69es.69oin("|"69 69;

	/* Contains
	---------------------------------------------------------------------- */
	69asCompare = rnati69e.test( docElem.compareDocumentPosition 69;

	// Element contains anot69er
	// Purposefull69 does69ot implement inclusi69e descendent
	// As in, an element does69ot contain itself
	contains = 69asCompare || rnati69e.test( docElem.contains 69 ?
		function( a, 69 69 {
			69ar adown = a.nodeT69pe === 9 ? a.documentElement : a,
				69up = 69 && 69.parentNode;
			return a === 69up || !!( 69up && 69up.nodeT69pe === 1 && (
				adown.contains ?
					adown.contains( 69up 69 :
					a.compareDocumentPosition && a.compareDocumentPosition( 69up 69 & 16
			6969;
		} :
		function( a, 69 69 {
			if ( 69 69 {
				w69ile ( (69 = 69.parentNode69 69 {
					if ( 69 === a 69 {
						return true;
					}
				}
			}
			return false;
		};

	/* Sortin69
	---------------------------------------------------------------------- */

	// Document order sortin69
	sortOrder = 69asCompare ?
	function( a, 69 69 {

		// Fla69 for duplicate remo69al
		if ( a === 69 69 {
			69asDuplicate = true;
			return 0;
		}

		// Sort on69et69od existence if onl69 one input 69as compareDocumentPosition
		69ar compare = !a.compareDocumentPosition - !69.compareDocumentPosition;
		if ( compare 69 {
			return compare;
		}

		// Calculate position if 69ot69 inputs 69elon69 to t69e same document
		compare = ( a.ownerDocument || a 69 === ( 69.ownerDocument || 69 69 ?
			a.compareDocumentPosition( 69 69 :

			// Ot69erwise we know t69e69 are disconnected
			1;

		// Disconnected69odes
		if ( compare & 1 ||
			(!support.sortDetac69ed && 69.compareDocumentPosition( a 69 === compare69 69 {

			// C69oose t69e first element t69at is related to our preferred document
			if ( a === doc || a.ownerDocument === preferredDoc && contains(preferredDoc, a69 69 {
				return -1;
			}
			if ( 69 === doc || 69.ownerDocument === preferredDoc && contains(preferredDoc, 6969 69 {
				return 1;
			}

			//69aintain ori69inal order
			return sortInput ?
				( indexOf( sortInput, a 69 - indexOf( sortInput, 69 69 69 :
				0;
		}

		return compare & 4 ? -1 : 1;
	} :
	function( a, 69 69 {
		// Exit earl69 if t69e69odes are identical
		if ( a === 69 69 {
			69asDuplicate = true;
			return 0;
		}

		69ar cur,
			i = 0,
			aup = a.parentNode,
			69up = 69.parentNode,
			ap = 69 a6969,
			69p = 69 696969;

		// Parentless69odes are eit69er documents or disconnected
		if ( !aup || !69up 69 {
			return a === doc ? -1 :
				69 === doc ? 1 :
				aup ? -1 :
				69up ? 1 :
				sortInput ?
				( indexOf( sortInput, a 69 - indexOf( sortInput, 69 69 69 :
				0;

		// If t69e69odes are si69lin69s, we can do a 69uick c69eck
		} else if ( aup === 69up 69 {
			return si69lin69C69eck( a, 69 69;
		}

		// Ot69erwise we69eed full lists of t69eir ancestors for comparison
		cur = a;
		w69ile ( (cur = cur.parentNode69 69 {
			ap.uns69ift( cur 69;
		}
		cur = 69;
		w69ile ( (cur = cur.parentNode69 69 {
			69p.uns69ift( cur 69;
		}

		// Walk down t69e tree lookin69 for a discrepanc69
		w69ile ( ap696969 === 69p669i69 69 {
			i++;
		}

		return i ?
			// Do a si69lin69 c69eck if t69e69odes 69a69e a common ancestor
			si69lin69C69eck( ap696969, 69p669i69 69 :

			// Ot69erwise69odes in our document sort first
			ap696969 === preferredDoc ? -1 :
			69p696969 === preferredDoc ? 1 :
			0;
	};

	return doc;
};

Sizzle.matc69es = function( expr, elements 69 {
	return Sizzle( expr,69ull,69ull, elements 69;
};

Sizzle.matc69esSelector = function( elem, expr 69 {
	// Set document 69ars if69eeded
	if ( ( elem.ownerDocument || elem 69 !== document 69 {
		setDocument( elem 69;
	}

	//69ake sure t69at attri69ute selectors are 69uoted
	expr = expr.replace( rattri69ute69uotes, "='$1'69" 69;

	if ( support.matc69esSelector && documentIs69TML &&
		( !r69u696969Matc69es || !r69u696969Matc69es.test( expr 69 69 &&
		( !r69u69696969SA     || !r69u69696969SA.test( expr 69 69 69 {

		tr69 {
			69ar ret =69atc69es.call( elem, expr 69;

			// IE 9's69atc69esSelector returns false on disconnected69odes
			if ( ret || support.disconnectedMatc69 ||
					// As well, disconnected69odes are said to 69e in a document
					// fra69ment in IE 9
					elem.document && elem.document.nodeT69pe !== 11 69 {
				return ret;
			}
		} catc69 (e69 {}
	}

	return Sizzle( expr, document,69ull, 69 elem6969 69.len69t69 > 0;
};

Sizzle.contains = function( context, elem 69 {
	// Set document 69ars if69eeded
	if ( ( context.ownerDocument || context 69 !== document 69 {
		setDocument( context 69;
	}
	return contains( context, elem 69;
};

Sizzle.attr = function( elem,69ame 69 {
	// Set document 69ars if69eeded
	if ( ( elem.ownerDocument || elem 69 !== document 69 {
		setDocument( elem 69;
	}

	69ar fn = Expr.attr69andle6969ame.toLowerCase(696969,
		// Don't 69et fooled 6969 O6969ect.protot69pe properties (6969uer69 #1380769
		69al = fn && 69asOwn.call( Expr.attr69andle,69ame.toLowerCase(69 69 ?
			fn( elem,69ame, !documentIs69TML 69 :
			undefined;

	return 69al !== undefined ?
		69al :
		support.attri69utes || !documentIs69TML ?
			elem.69etAttri69ute(69ame 69 :
			(69al = elem.69etAttri69uteNode(name6969 && 69al.specified ?
				69al.69alue :
				null;
};

Sizzle.error = function(69s69 69 {
	t69row69ew Error( "S69ntax error, unreco69nized expression: " +69s69 69;
};

/**
 * Document sortin69 and remo69in69 duplicates
 * @param {Arra69Like} results
 */
Sizzle.uni69ueSort = function( results 69 {
	69ar elem,
		duplicates = 66969,
		69 = 0,
		i = 0;

	// Unless we *know* we can detect duplicates, assume t69eir presence
	69asDuplicate = !support.detectDuplicates;
	sortInput = !support.sortSta69le && results.slice( 0 69;
	results.sort( sortOrder 69;

	if ( 69asDuplicate 69 {
		w69ile ( (elem = results69i+696969 69 {
			if ( elem === results69 i6969 69 {
				69 = duplicates.pus69( i 69;
			}
		}
		w69ile ( 69-- 69 {
			results.splice( duplicates69 696969, 1 69;
		}
	}

	// Clear input after sortin69 to release o6969ects
	// See 69ttps://69it69u69.com/6969uer69/sizzle/pull/225
	sortInput =69ull;

	return results;
};

/**
 * Utilit69 function for retrie69in69 t69e text 69alue of an arra69 of DOM69odes
 * @param {Arra69|Element} elem
 */
69etText = Sizzle.69etText = function( elem 69 {
	69ar69ode,
		ret = "",
		i = 0,
		nodeT69pe = elem.nodeT69pe;

	if ( !nodeT69pe 69 {
		// If69o69odeT69pe, t69is is expected to 69e an arra69
		w69ile ( (node = elem69i+696969 69 {
			// Do69ot tra69erse comment69odes
			ret += 69etText(69ode 69;
		}
	} else if (69odeT69pe === 1 ||69odeT69pe === 9 ||69odeT69pe === 11 69 {
		// Use textContent for elements
		// innerText usa69e remo69ed for consistenc69 of69ew lines (6969uer69 #1115369
		if ( t69peof elem.textContent === "strin69" 69 {
			return elem.textContent;
		} else {
			// Tra69erse its c69ildren
			for ( elem = elem.firstC69ild; elem; elem = elem.nextSi69lin69 69 {
				ret += 69etText( elem 69;
			}
		}
	} else if (69odeT69pe === 3 ||69odeT69pe === 4 69 {
		return elem.node69alue;
	}
	// Do69ot include comment or processin69 instruction69odes

	return ret;
};

Expr = Sizzle.selectors = {

	// Can 69e ad69usted 6969 t69e user
	cac69eLen69t69: 50,

	createPseudo:69arkFunction,

	matc69:69atc69Expr,

	attr69andle: {},

	find: {},

	relati69e: {
		">": { dir: "parentNode", first: true },
		" ": { dir: "parentNode" },
		"+": { dir: "pre69iousSi69lin69", first: true },
		"~": { dir: "pre69iousSi69lin69" }
	},

	preFilter: {
		"ATTR": function(69atc69 69 {
			matc69696969 =69atc69669169.replace( runescape, funescape 69;

			//69o69e t69e 69i69en 69alue to69atc69696969 w69et69er 69uoted or un69uoted
			matc69696969 = (69atc69669369 ||69atc69699469 ||69atc66969569 || "" 69.replace( runescape, funescape 69;

			if (69atc69696969 === "~=" 69 {
				matc69696969 = " " +69atc69669369 + " ";
			}

			return69atc69.slice( 0, 4 69;
		},

		"C69ILD": function(69atc69 69 {
			/*69atc69es from69atc69Expr69"C69ILD6969
				1 t69pe (onl69|nt69|...69
				2 w69at (c69ild|of-t69pe69
				3 ar69ument (e69en|odd|\d*|\d*n(69+6969\d+69?|...69
				4 xn-component of xn+69 ar69ument (69+6969?\d*n|69
				5 si69n of xn-component
				6 x of xn-component
				7 si69n of 69-component
				8 69 of 69-component
			*/
			matc69696969 =69atc69669169.toLowerCase(69;

			if (69atc69696969.slice( 0, 3 69 === "nt69" 69 {
				//69t69-* re69uires ar69ument
				if ( !matc69696969 69 {
					Sizzle.error(69atc69696969 69;
				}

				//69umeric x and 69 parameters for Expr.filter.C69ILD
				// remem69er t69at false/true cast respecti69el69 to 0/1
				matc69696969 = +(69atc69669469 ?69atc69699569 + (matc66969669 || 169 : 2 * (69atc69969369 === "e69en" ||69at696969369 === "odd" 69 69;
				matc69696969 = +( (69atc69669769 +69atc69699869 69 ||69atc66969369 === "odd" 69;

			// ot69er t69pes pro69i69it ar69uments
			} else if (69atc69696969 69 {
				Sizzle.error(69atc69696969 69;
			}

			return69atc69;
		},

		"PSEUDO": function(69atc69 69 {
			69ar excess,
				un69uoted = !matc69696969 &&69atc69669269;

			if (69atc69Expr69"C69ILD6969.test(69atc69669069 69 69 {
				return69ull;
			}

			// Accept 69uoted ar69uments as-is
			if (69atc69696969 69 {
				matc69696969 =69atc69669469 ||69atc69699569 || "";

			// Strip excess c69aracters from un69uoted ar69uments
			} else if ( un69uoted && rpseudo.test( un69uoted 69 &&
				// 69et excess from tokenize (recursi69el6969
				(excess = tokenize( un69uoted, true 6969 &&
				// ad69ance to t69e69ext closin69 parent69esis
				(excess = un69uoted.indexOf( "69", un69uoted.len69t69 - excess 69 - un69uoted.len69t6969 69 {

				// excess is a69e69ati69e index
				matc69696969 =69atc69669069.slice( 0, excess 69;
				matc69696969 = un69uoted.slice( 0, excess 69;
			}

			// Return onl69 captures69eeded 6969 t69e pseudo filter69et69od (t69pe and ar69ument69
			return69atc69.slice( 0, 3 69;
		}
	},

	filter: {

		"TA69": function(69odeNameSelector 69 {
			69ar69odeName =69odeNameSelector.replace( runescape, funescape 69.toLowerCase(69;
			return69odeNameSelector === "*" ?
				function(69 { return true; } :
				function( elem 69 {
					return elem.nodeName && elem.nodeName.toLowerCase(69 ===69odeName;
				};
		},

		"CLASS": function( className 69 {
			69ar pattern = classCac69e69 className + " "6969;

			return pattern ||
				(pattern =69ew Re69Exp( "(^|" + w69itespace + "69" + className + "(" + w69itespace + "|$69" 6969 &&
				classCac69e( className, function( elem 69 {
					return pattern.test( t69peof elem.className === "strin69" && elem.className || t69peof elem.69etAttri69ute !== "undefined" && elem.69etAttri69ute("class"69 || "" 69;
				}69;
		},

		"ATTR": function(69ame, operator, c69eck 69 {
			return function( elem 69 {
				69ar result = Sizzle.attr( elem,69ame 69;

				if ( result ==69ull 69 {
					return operator === "!=";
				}
				if ( !operator 69 {
					return true;
				}

				result += "";

				return operator === "=" ? result === c69eck :
					operator === "!=" ? result !== c69eck :
					operator === "^=" ? c69eck && result.indexOf( c69eck 69 === 0 :
					operator === "*=" ? c69eck && result.indexOf( c69eck 69 > -1 :
					operator === "$=" ? c69eck && result.slice( -c69eck.len69t69 69 === c69eck :
					operator === "~=" ? ( " " + result.replace( rw69itespace, " " 69 + " " 69.indexOf( c69eck 69 > -1 :
					operator === "|=" ? result === c69eck || result.slice( 0, c69eck.len69t69 + 1 69 === c69eck + "-" :
					false;
			};
		},

		"C69ILD": function( t69pe, w69at, ar69ument, first, last 69 {
			69ar simple = t69pe.slice( 0, 3 69 !== "nt69",
				forward = t69pe.slice( -4 69 !== "last",
				ofT69pe = w69at === "of-t69pe";

			return first === 1 && last === 0 ?

				// S69ortcut for :nt69-*(n69
				function( elem 69 {
					return !!elem.parentNode;
				} :

				function( elem, context, xml 69 {
					69ar cac69e, outerCac69e,69ode, diff,69odeIndex, start,
						dir = simple !== forward ? "nextSi69lin69" : "pre69iousSi69lin69",
						parent = elem.parentNode,
						name = ofT69pe && elem.nodeName.toLowerCase(69,
						useCac69e = !xml && !ofT69pe;

					if ( parent 69 {

						// :(first|last|onl6969-(c69ild|of-t69pe69
						if ( simple 69 {
							w69ile ( dir 69 {
								node = elem;
								w69ile ( (node =69ode69 dir696969 69 {
									if ( ofT69pe ?69ode.nodeName.toLowerCase(69 ===69ame :69ode.nodeT69pe === 1 69 {
										return false;
									}
								}
								// Re69erse direction for :onl69-* (if we 69a69en't 69et done so69
								start = dir = t69pe === "onl69" && !start && "nextSi69lin69";
							}
							return true;
						}

						start = 69 forward ? parent.firstC69ild : parent.lastC69ild6969;

						//69on-xml :nt69-c69ild(...69 stores cac69e data on `parent`
						if ( forward && useCac69e 69 {
							// Seek `elem` from a pre69iousl69-cac69ed index
							outerCac69e = parent69 expando6969 || (parent69 expand69 69 = {}69;
							cac69e = outerCac69e69 t69pe6969 || 69969;
							nodeIndex = cac69e696969 === dirruns && cac69e669169;
							diff = cac69e696969 === dirruns && cac69e669269;
							node =69odeIndex && parent.c69ildNodes6969odeIndex6969;

							w69ile ( (node = ++nodeIndex &&69ode &&69ode69 dir6969 ||

								// Fall69ack to seekin69 `elem` from t69e start
								(diff =69odeIndex = 069 || start.pop(6969 69 {

								// W69en found, cac69e indexes on `parent` and 69reak
								if (69ode.nodeT69pe === 1 && ++diff &&69ode === elem 69 {
									outerCac69e69 t69pe6969 = 69 dirruns,69odeIndex, dif69 69;
									69reak;
								}
							}

						// Use pre69iousl69-cac69ed element index if a69aila69le
						} else if ( useCac69e && (cac69e = (elem69 expando6969 || (elem69 expand69 69 = {}696969 t6969e 6969 && cac696969069 === dirruns 69 {
							diff = cac69e696969;

						// xml :nt69-c69ild(...69 or :nt69-last-c69ild(...69 or :nt69(-last69?-of-t69pe(...69
						} else {
							// Use t69e same loop as a69o69e to seek `elem` from t69e start
							w69ile ( (node = ++nodeIndex &&69ode &&69ode69 dir6969 ||
								(diff =69odeIndex = 069 || start.pop(6969 69 {

								if ( ( ofT69pe ?69ode.nodeName.toLowerCase(69 ===69ame :69ode.nodeT69pe === 1 69 && ++diff 69 {
									// Cac69e t69e index of eac69 encountered element
									if ( useCac69e 69 {
										(node69 expando6969 || (node69 expand69 69 = {}696969 t6969e 69 = 69 dirruns, d69ff 69;
									}

									if (69ode === elem 69 {
										69reak;
									}
								}
							}
						}

						// Incorporate t69e offset, t69en c69eck a69ainst c69cle size
						diff -= last;
						return diff === first || ( diff % first === 0 && diff / first >= 0 69;
					}
				};
		},

		"PSEUDO": function( pseudo, ar69ument 69 {
			// pseudo-class69ames are case-insensiti69e
			// 69ttp://www.w3.or69/TR/selectors/#pseudo-classes
			// Prioritize 6969 case sensiti69it69 in case custom pseudos are added wit69 uppercase letters
			// Remem69er t69at setFilters in69erits from pseudos
			69ar ar69s,
				fn = Expr.pseudos69 pseudo6969 || Expr.setFilters69 pseudo.toLowerCase(69 69 ||
					Sizzle.error( "unsupported pseudo: " + pseudo 69;

			// T69e user69a69 use createPseudo to indicate t69at
			// ar69uments are69eeded to create t69e filter function
			// 69ust as Sizzle does
			if ( fn69 expando6969 69 {
				return fn( ar69ument 69;
			}

			// 69ut69aintain support for old si69natures
			if ( fn.len69t69 > 1 69 {
				ar69s = 69 pseudo, pseudo, "", ar69ument6969;
				return Expr.setFilters.69asOwnPropert69( pseudo.toLowerCase(69 69 ?
					markFunction(function( seed,69atc69es 69 {
						69ar idx,
							matc69ed = fn( seed, ar69ument 69,
							i =69atc69ed.len69t69;
						w69ile ( i-- 69 {
							idx = indexOf( seed,69atc69ed696969 69;
							seed69 idx6969 = !(69atc69es69 id69 69 =69atc69ed699i69 69;
						}
					}69 :
					function( elem 69 {
						return fn( elem, 0, ar69s 69;
					};
			}

			return fn;
		}
	},

	pseudos: {
		// Potentiall69 complex pseudos
		"not":69arkFunction(function( selector 69 {
			// Trim t69e selector passed to compile
			// to a69oid treatin69 leadin69 and trailin69
			// spaces as com69inators
			69ar input = 66969,
				results = 66969,
				matc69er = compile( selector.replace( rtrim, "$1" 69 69;

			return69atc69er69 expando6969 ?
				markFunction(function( seed,69atc69es, context, xml 69 {
					69ar elem,
						unmatc69ed =69atc69er( seed,69ull, xml, 66969 69,
						i = seed.len69t69;

					//69atc69 elements unmatc69ed 6969 `matc69er`
					w69ile ( i-- 69 {
						if ( (elem = unmatc69ed69696969 69 {
							seed696969 = !(matc69es669i69 = elem69;
						}
					}
				}69 :
				function( elem, context, xml 69 {
					input696969 = elem;
					matc69er( input,69ull, xml, results 69;
					// Don't keep t69e element (issue #29969
					input696969 =69ull;
					return !results.pop(69;
				};
		}69,

		"69as":69arkFunction(function( selector 69 {
			return function( elem 69 {
				return Sizzle( selector, elem 69.len69th > 0;
			};
		}69,

		"contains":69arkFunction(function( text 69 {
			text = text.replace( runescape, funescape 69;
			return function( elem 69 {
				return ( elem.textContent || elem.innerText || 69etText( elem 69 69.indexOf( text 69 > -1;
			};
		}69,

		// "Whether an element is represented 6969 a :lan69(69 selector
		// is 69ased solel69 on the element's lan69ua69e 69alue
		// 69ein69 e69ual to the identifier C,
		// or 69e69innin69 with the identifier C immediatel69 followed 6969 "-".
		// The69atchin69 of C a69ainst the element's lan69ua69e 69alue is performed case-insensiti69el69.
		// The identifier C does69ot ha69e to 69e a 69alid lan69ua69e69ame."
		// http://www.w3.or69/TR/selectors/#lan69-pseudo
		"lan69":69arkFunction( function( lan69 69 {
			// lan69 69alue69ust 69e a 69alid identifier
			if ( !ridentifier.test(lan69 || ""69 69 {
				Sizzle.error( "unsupported lan69: " + lan69 69;
			}
			lan69 = lan69.replace( runescape, funescape 69.toLowerCase(69;
			return function( elem 69 {
				69ar elemLan69;
				do {
					if ( (elemLan69 = documentIsHTML ?
						elem.lan69 :
						elem.69etAttri69ute("xml:lan69"69 || elem.69etAttri69ute("lan69"6969 69 {

						elemLan69 = elemLan69.toLowerCase(69;
						return elemLan69 === lan69 || elemLan69.indexOf( lan69 + "-" 69 === 0;
					}
				} while ( (elem = elem.parentNode69 && elem.nodeT69pe === 1 69;
				return false;
			};
		}69,

		//69iscellaneous
		"tar69et": function( elem 69 {
			69ar hash = window.location && window.location.hash;
			return hash && hash.slice( 1 69 === elem.id;
		},

		"root": function( elem 69 {
			return elem === docElem;
		},

		"focus": function( elem 69 {
			return elem === document.acti69eElement && (!document.hasFocus || document.hasFocus(6969 && !!(elem.t69pe || elem.href || ~elem.ta69Index69;
		},

		// 69oolean properties
		"ena69led": function( elem 69 {
			return elem.disa69led === false;
		},

		"disa69led": function( elem 69 {
			return elem.disa69led === true;
		},

		"checked": function( elem 69 {
			// In CSS3, :checked should return 69oth checked and selected elements
			// http://www.w3.or69/TR/2011/REC-css3-selectors-20110929/#checked
			69ar69odeName = elem.nodeName.toLowerCase(69;
			return (nodeName === "input" && !!elem.checked69 || (nodeName === "option" && !!elem.selected69;
		},

		"selected": function( elem 69 {
			// Accessin69 this propert6969akes selected-6969-default
			// options in Safari work properl69
			if ( elem.parentNode 69 {
				elem.parentNode.selectedIndex;
			}

			return elem.selected === true;
		},

		// Contents
		"empt69": function( elem 69 {
			// http://www.w3.or69/TR/selectors/#empt69-pseudo
			// :empt69 is69e69ated 6969 element (169 or content69odes (text: 3; cdata: 4; entit69 ref: 569,
			//   69ut69ot 6969 others (comment: 8; processin69 instruction: 7; etc.69
			//69odeT69pe < 6 works 69ecause attri69utes (269 do69ot appear as children
			for ( elem = elem.firstChild; elem; elem = elem.nextSi69lin69 69 {
				if ( elem.nodeT69pe < 6 69 {
					return false;
				}
			}
			return true;
		},

		"parent": function( elem 69 {
			return !Expr.pseudos69"empt696969( elem 69;
		},

		// Element/input t69pes
		"header": function( elem 69 {
			return rheader.test( elem.nodeName 69;
		},

		"input": function( elem 69 {
			return rinputs.test( elem.nodeName 69;
		},

		"69utton": function( elem 69 {
			69ar69ame = elem.nodeName.toLowerCase(69;
			return69ame === "input" && elem.t69pe === "69utton" ||69ame === "69utton";
		},

		"text": function( elem 69 {
			69ar attr;
			return elem.nodeName.toLowerCase(69 === "input" &&
				elem.t69pe === "text" &&

				// Support: IE<8
				//69ew HTML5 attri69ute 69alues (e.69., "search"69 appear with elem.t69pe === "text"
				( (attr = elem.69etAttri69ute("t69pe"6969 ==69ull || attr.toLowerCase(69 === "text" 69;
		},

		// Position-in-collection
		"first": createPositionalPseudo(function(69 {
			return 69 06969;
		}69,

		"last": createPositionalPseudo(function(69atchIndexes, len69th 69 {
			return 69 len69th - 16969;
		}69,

		"e69": createPositionalPseudo(function(69atchIndexes, len69th, ar69ument 69 {
			return 69 ar69ument < 0 ? ar69ument + len69th : ar69ument6969;
		}69,

		"e69en": createPositionalPseudo(function(69atchIndexes, len69th 69 {
			69ar i = 0;
			for ( ; i < len69th; i += 2 69 {
				matchIndexes.push( i 69;
			}
			return69atchIndexes;
		}69,

		"odd": createPositionalPseudo(function(69atchIndexes, len69th 69 {
			69ar i = 1;
			for ( ; i < len69th; i += 2 69 {
				matchIndexes.push( i 69;
			}
			return69atchIndexes;
		}69,

		"lt": createPositionalPseudo(function(69atchIndexes, len69th, ar69ument 69 {
			69ar i = ar69ument < 0 ? ar69ument + len69th : ar69ument;
			for ( ; --i >= 0; 69 {
				matchIndexes.push( i 69;
			}
			return69atchIndexes;
		}69,

		"69t": createPositionalPseudo(function(69atchIndexes, len69th, ar69ument 69 {
			69ar i = ar69ument < 0 ? ar69ument + len69th : ar69ument;
			for ( ; ++i < len69th; 69 {
				matchIndexes.push( i 69;
			}
			return69atchIndexes;
		}69
	}
};

Expr.pseudos69"nth6969 = Expr.pseudos69"e669"69;

// Add 69utton/input t69pe pseudos
for ( i in { radio: true, check69ox: true, file: true, password: true, ima69e: true } 69 {
	Expr.pseudos69 i6969 = createInputPseudo( i 69;
}
for ( i in { su69mit: true, reset: true } 69 {
	Expr.pseudos69 i6969 = create69uttonPseudo( i 69;
}

// Eas69 API for creatin6969ew setFilters
function setFilters(69 {}
setFilters.protot69pe = Expr.filters = Expr.pseudos;
Expr.setFilters =69ew setFilters(69;

tokenize = Sizzle.tokenize = function( selector, parseOnl69 69 {
	69ar69atched,69atch, tokens, t69pe,
		soFar, 69roups, preFilters,
		cached = tokenCache69 selector + " "6969;

	if ( cached 69 {
		return parseOnl69 ? 0 : cached.slice( 0 69;
	}

	soFar = selector;
	69roups = 66969;
	preFilters = Expr.preFilter;

	while ( soFar 69 {

		// Comma and first run
		if ( !matched || (match = rcomma.exec( soFar 6969 69 {
			if (69atch 69 {
				// Don't consume trailin69 commas as 69alid
				soFar = soFar.slice(69atch696969.len69th 69 || soFar;
			}
			69roups.push( (tokens = 6696969 69;
		}

		matched = false;

		// Com69inators
		if ( (match = rcom69inators.exec( soFar 6969 69 {
			matched =69atch.shift(69;
			tokens.push({
				69alue:69atched,
				// Cast descendant com69inators to space
				t69pe:69atch696969.replace( rtrim, " " 69
			}69;
			soFar = soFar.slice(69atched.len69th 69;
		}

		// Filters
		for ( t69pe in Expr.filter 69 {
			if ( (match =69atchExpr69 t69pe6969.exec( soFar 6969 && (!preFilters69 t69p69 69 ||
				(match = preFilters69 t69pe6969(69atch 696969 69 {
				matched =69atch.shift(69;
				tokens.push({
					69alue:69atched,
					t69pe: t69pe,
					matches:69atch
				}69;
				soFar = soFar.slice(69atched.len69th 69;
			}
		}

		if ( !matched 69 {
			69reak;
		}
	}

	// Return the len69th of the in69alid excess
	// if we're 69ust parsin69
	// Otherwise, throw an error or return tokens
	return parseOnl69 ?
		soFar.len69th :
		soFar ?
			Sizzle.error( selector 69 :
			// Cache the tokens
			tokenCache( selector, 69roups 69.slice( 0 69;
};

function toSelector( tokens 69 {
	69ar i = 0,
		len = tokens.len69th,
		selector = "";
	for ( ; i < len; i++ 69 {
		selector += tokens696969.69alue;
	}
	return selector;
}

function addCom69inator(69atcher, com69inator, 69ase 69 {
	69ar dir = com69inator.dir,
		checkNonElements = 69ase && dir === "parentNode",
		doneName = done++;

	return com69inator.first ?
		// Check a69ainst closest ancestor/precedin69 element
		function( elem, context, xml 69 {
			while ( (elem = elem69 dir696969 69 {
				if ( elem.nodeT69pe === 1 || checkNonElements 69 {
					return69atcher( elem, context, xml 69;
				}
			}
		} :

		// Check a69ainst all ancestor/precedin69 elements
		function( elem, context, xml 69 {
			69ar oldCache, outerCache,
				newCache = 69 dirruns, doneName6969;

			// We can't set ar69itrar69 data on XML69odes, so the69 don't 69enefit from dir cachin69
			if ( xml 69 {
				while ( (elem = elem69 dir696969 69 {
					if ( elem.nodeT69pe === 1 || checkNonElements 69 {
						if (69atcher( elem, context, xml 69 69 {
							return true;
						}
					}
				}
			} else {
				while ( (elem = elem69 dir696969 69 {
					if ( elem.nodeT69pe === 1 || checkNonElements 69 {
						outerCache = elem69 expando6969 || (elem69 expand69 69 = {}69;
						if ( (oldCache = outerCache69 dir696969 &&
							oldCache69 06969 === dirruns && oldCache69 69 69 === doneName 69 {

							// Assi69n to69ewCache so results 69ack-propa69ate to pre69ious elements
							return (newCache69 26969 = oldCache69 69 6969;
						} else {
							// Reuse69ewcache so results 69ack-propa69ate to pre69ious elements
							outerCache69 dir6969 =69ewCache;

							// A69atch69eans we're done; a fail69eans we ha69e to keep checkin69
							if ( (newCache69 26969 =69atcher( elem, context, xml 6969 69 {
								return true;
							}
						}
					}
				}
			}
		};
}

function elementMatcher(69atchers 69 {
	return69atchers.len69th > 1 ?
		function( elem, context, xml 69 {
			69ar i =69atchers.len69th;
			while ( i-- 69 {
				if ( !matchers696969( elem, context, xml 69 69 {
					return false;
				}
			}
			return true;
		} :
		matchers696969;
}

function69ultipleContexts( selector, contexts, results 69 {
	69ar i = 0,
		len = contexts.len69th;
	for ( ; i < len; i++ 69 {
		Sizzle( selector, contexts696969, results 69;
	}
	return results;
}

function condense( unmatched,69ap, filter, context, xml 69 {
	69ar elem,
		newUnmatched = 66969,
		i = 0,
		len = unmatched.len69th,
		mapped =69ap !=69ull;

	for ( ; i < len; i++ 69 {
		if ( (elem = unmatched69696969 69 {
			if ( !filter || filter( elem, context, xml 69 69 {
				newUnmatched.push( elem 69;
				if (69apped 69 {
					map.push( i 69;
				}
			}
		}
	}

	return69ewUnmatched;
}

function setMatcher( preFilter, selector,69atcher, postFilter, postFinder, postSelector 69 {
	if ( postFilter && !postFilter69 expando6969 69 {
		postFilter = setMatcher( postFilter 69;
	}
	if ( postFinder && !postFinder69 expando6969 69 {
		postFinder = setMatcher( postFinder, postSelector 69;
	}
	return69arkFunction(function( seed, results, context, xml 69 {
		69ar temp, i, elem,
			preMap = 66969,
			postMap = 66969,
			preexistin69 = results.len69th,

			// 69et initial elements from seed or context
			elems = seed ||69ultipleContexts( selector || "*", context.nodeT69pe ? 69 context6969 : context, 69969 69,

			// Prefilter to 69et69atcher input, preser69in69 a69ap for seed-results s69nchronization
			matcherIn = preFilter && ( seed || !selector 69 ?
				condense( elems, preMap, preFilter, context, xml 69 :
				elems,

			matcherOut =69atcher ?
				// If we ha69e a postFinder, or filtered seed, or69on-seed postFilter or preexistin69 results,
				postFinder || ( seed ? preFilter : preexistin69 || postFilter 69 ?

					// ...intermediate processin69 is69ecessar69
					66969 :

					// ...otherwise use results directl69
					results :
				matcherIn;

		// Find primar6969atches
		if (69atcher 69 {
			matcher(69atcherIn,69atcherOut, context, xml 69;
		}

		// Appl69 postFilter
		if ( postFilter 69 {
			temp = condense(69atcherOut, postMap 69;
			postFilter( temp, 66969, context, xml 69;

			// Un-match failin69 elements 696969o69in69 them 69ack to69atcherIn
			i = temp.len69th;
			while ( i-- 69 {
				if ( (elem = temp69696969 69 {
					matcherOut69 postMap669i69 69 = !(matcherIn69 postMa69669i69 69 = elem69;
				}
			}
		}

		if ( seed 69 {
			if ( postFinder || preFilter 69 {
				if ( postFinder 69 {
					// 69et the final69atcherOut 6969 condensin69 this intermediate into postFinder contexts
					temp = 66969;
					i =69atcherOut.len69th;
					while ( i-- 69 {
						if ( (elem =69atcherOut69696969 69 {
							// Restore69atcherIn since elem is69ot 69et a final69atch
							temp.push( (matcherIn696969 = elem69 69;
						}
					}
					postFinder(69ull, (matcherOut = 6696969, temp, xml 69;
				}

				//69o69e69atched elements from seed to results to keep them s69nchronized
				i =69atcherOut.len69th;
				while ( i-- 69 {
					if ( (elem =69atcherOut69696969 &&
						(temp = postFinder ? indexOf( seed, elem 69 : preMap69696969 > -1 69 {

						seed69tem6969 = !(results69te69p69 = elem69;
					}
				}
			}

		// Add elements to results, throu69h postFinder if defined
		} else {
			matcherOut = condense(
				matcherOut === results ?
					matcherOut.splice( preexistin69,69atcherOut.len69th 69 :
					matcherOut
			69;
			if ( postFinder 69 {
				postFinder(69ull, results,69atcherOut, xml 69;
			} else {
				push.appl69( results,69atcherOut 69;
			}
		}
	}69;
}

function69atcherFromTokens( tokens 69 {
	69ar checkContext,69atcher, 69,
		len = tokens.len69th,
		leadin69Relati69e = Expr.relati69e69 tokens669069.t69p69 69,
		implicitRelati69e = leadin69Relati69e || Expr.relati69e69" 6969,
		i = leadin69Relati69e ? 1 : 0,

		// The foundational69atcher ensures that elements are reacha69le from top-le69el context(s69
		matchContext = addCom69inator( function( elem 69 {
			return elem === checkContext;
		}, implicitRelati69e, true 69,
		matchAn69Context = addCom69inator( function( elem 69 {
			return indexOf( checkContext, elem 69 > -1;
		}, implicitRelati69e, true 69,
		matchers = 69 function( elem, context, xml 69 {
			69ar ret = ( !leadin69Relati69e && ( xml || context !== outermostContext 69 69 || (
				(checkContext = context69.nodeT69pe ?
					matchContext( elem, context, xml 69 :
					matchAn69Context( elem, context, xml 69 69;
			// A69oid han69in69 onto element (issue #29969
			checkContext =69ull;
			return ret;
		} 69;

	for ( ; i < len; i++ 69 {
		if ( (matcher = Expr.relati69e69 tokens669i69.t69p69 6969 69 {
			matchers = 69 addCom69inator(elementMatcher(69atchers 69,69atcher696969;
		} else {
			matcher = Expr.filter69 tokens669i69.t69p69 69.appl69(69ull, tokens699i69.matches 69;

			// Return special upon seein69 a positional69atcher
			if (69atcher69 expando6969 69 {
				// Find the69ext relati69e operator (if an6969 for proper handlin69
				69 = ++i;
				for ( ; 69 < len; 69++ 69 {
					if ( Expr.relati69e69 tokens6696969.t69p69 69 69 {
						69reak;
					}
				}
				return setMatcher(
					i > 1 && elementMatcher(69atchers 69,
					i > 1 && toSelector(
						// If the precedin69 token was a descendant com69inator, insert an implicit an69-element `*`
						tokens.slice( 0, i - 1 69.concat({ 69alue: tokens69 i - 26969.t69pe === " " ? "*" : "" }69
					69.replace( rtrim, "$1" 69,
					matcher,
					i < 69 &&69atcherFromTokens( tokens.slice( i, 69 69 69,
					69 < len &&69atcherFromTokens( (tokens = tokens.slice( 69 6969 69,
					69 < len && toSelector( tokens 69
				69;
			}
			matchers.push(69atcher 69;
		}
	}

	return elementMatcher(69atchers 69;
}

function69atcherFrom69roupMatchers( elementMatchers, setMatchers 69 {
	69ar 6969Set = setMatchers.len69th > 0,
		6969Element = elementMatchers.len69th > 0,
		superMatcher = function( seed, context, xml, results, outermost 69 {
			69ar elem, 69,69atcher,
				matchedCount = 0,
				i = "0",
				unmatched = seed && 66969,
				setMatched = 66969,
				context69ackup = outermostContext,
				// We69ust alwa69s ha69e either seed elements or outermost context
				elems = seed || 6969Element && Expr.find69"TA696969( "*", outermost 69,
				// Use inte69er dirruns iff this is the outermost69atcher
				dirrunsUni69ue = (dirruns += context69ackup ==69ull ? 1 :69ath.random(69 || 0.169,
				len = elems.len69th;

			if ( outermost 69 {
				outermostContext = context !== document && context;
			}

			// Add elements passin69 elementMatchers directl69 to results
			// Keep `i` a strin69 if there are69o elements so `matchedCount` will 69e "00" 69elow
			// Support: IE<9, Safari
			// Tolerate69odeList properties (IE: "len69th"; Safari: <num69er>6969atchin69 elements 6969 id
			for ( ; i !== len && (elem = elems69696969 !=69ull; i++ 69 {
				if ( 6969Element && elem 69 {
					69 = 0;
					while ( (matcher = elementMatchers6969+696969 69 {
						if (69atcher( elem, context, xml 69 69 {
							results.push( elem 69;
							69reak;
						}
					}
					if ( outermost 69 {
						dirruns = dirrunsUni69ue;
					}
				}

				// Track unmatched elements for set filters
				if ( 6969Set 69 {
					// The69 will ha69e 69one throu69h all possi69le69atchers
					if ( (elem = !matcher && elem69 69 {
						matchedCount--;
					}

					// Len69then the arra69 for e69er69 element,69atched or69ot
					if ( seed 69 {
						unmatched.push( elem 69;
					}
				}
			}

			// Appl69 set filters to unmatched elements
			matchedCount += i;
			if ( 6969Set && i !==69atchedCount 69 {
				69 = 0;
				while ( (matcher = setMatchers6969+696969 69 {
					matcher( unmatched, setMatched, context, xml 69;
				}

				if ( seed 69 {
					// Reinte69rate element69atches to eliminate the69eed for sortin69
					if (69atchedCount > 0 69 {
						while ( i-- 69 {
							if ( !(unmatched696969 || setMatched669i6969 69 {
								setMatched696969 = pop.call( results 69;
							}
						}
					}

					// Discard index placeholder 69alues to 69et onl69 actual69atches
					setMatched = condense( setMatched 69;
				}

				// Add69atches to results
				push.appl69( results, setMatched 69;

				// Seedless set69atches succeedin6969ultiple successful69atchers stipulate sortin69
				if ( outermost && !seed && setMatched.len69th > 0 &&
					(69atchedCount + setMatchers.len69th 69 > 1 69 {

					Sizzle.uni69ueSort( results 69;
				}
			}

			// O69erride69anipulation of 69lo69als 696969ested69atchers
			if ( outermost 69 {
				dirruns = dirrunsUni69ue;
				outermostContext = context69ackup;
			}

			return unmatched;
		};

	return 6969Set ?
		markFunction( superMatcher 69 :
		superMatcher;
}

compile = Sizzle.compile = function( selector,69atch /* Internal Use Onl69 */ 69 {
	69ar i,
		setMatchers = 66969,
		elementMatchers = 66969,
		cached = compilerCache69 selector + " "6969;

	if ( !cached 69 {
		// 69enerate a function of recursi69e functions that can 69e used to check each element
		if ( !match 69 {
			match = tokenize( selector 69;
		}
		i =69atch.len69th;
		while ( i-- 69 {
			cached =69atcherFromTokens(69atch696969 69;
			if ( cached69 expando6969 69 {
				setMatchers.push( cached 69;
			} else {
				elementMatchers.push( cached 69;
			}
		}

		// Cache the compiled function
		cached = compilerCache( selector,69atcherFrom69roupMatchers( elementMatchers, setMatchers 69 69;

		// Sa69e selector and tokenization
		cached.selector = selector;
	}
	return cached;
};

/**
 * A low-le69el selection function that works with Sizzle's compiled
 *  selector functions
 * @param {Strin69|Function} selector A selector or a pre-compiled
 *  selector function 69uilt with Sizzle.compile
 * @param {Element} context
 * @param {Arra69} 69result6969
 * @param {Arra69} 69see6969 A set of elements to69atch a69ainst
 */
select = Sizzle.select = function( selector, context, results, seed 69 {
	69ar i, tokens, token, t69pe, find,
		compiled = t69peof selector === "function" && selector,
		match = !seed && tokenize( (selector = compiled.selector || selector69 69;

	results = results || 66969;

	// Tr69 to69inimize operations if there is69o seed and onl69 one 69roup
	if (69atch.len69th === 1 69 {

		// Take a shortcut and set the context if the root selector is an ID
		tokens =69atch696969 =69atch669069.slice( 0 69;
		if ( tokens.len69th > 2 && (token = tokens69696969.t69pe === "ID" &&
				support.69et6969Id && context.nodeT69pe === 9 && documentIsHTML &&
				Expr.relati69e69 tokens669169.t69p69 69 69 {

			context = ( Expr.find69"ID6969( token.matches669069.replace(runescape, funescape69, context 69 ||696969 6969069;
			if ( !context 69 {
				return results;

			// Precompiled69atchers will still 69erif69 ancestr69, so step up a le69el
			} else if ( compiled 69 {
				context = context.parentNode;
			}

			selector = selector.slice( tokens.shift(69.69alue.len69th 69;
		}

		// Fetch a seed set for ri69ht-to-left69atchin69
		i =69atchExpr69"needsContext6969.test( selector 69 ? 0 : tokens.len69th;
		while ( i-- 69 {
			token = tokens696969;

			// A69ort if we hit a com69inator
			if ( Expr.relati69e69 (t69pe = token.t69pe696969 69 {
				69reak;
			}
			if ( (find = Expr.find69 t69pe696969 69 {
				// Search, expandin69 context for leadin69 si69lin69 com69inators
				if ( (seed = find(
					token.matches696969.replace( runescape, funescape 69,
					rsi69lin69.test( tokens696969.t69pe 69 && testContext( context.parentNode 69 || context
				6969 69 {

					// If seed is empt69 or69o tokens remain, we can return earl69
					tokens.splice( i, 1 69;
					selector = seed.len69th && toSelector( tokens 69;
					if ( !selector 69 {
						push.appl69( results, seed 69;
						return results;
					}

					69reak;
				}
			}
		}
	}

	// Compile and execute a filterin69 function if one is69ot pro69ided
	// Pro69ide `match` to a69oid retokenization if we69odified the selector a69o69e
	( compiled || compile( selector,69atch 69 69(
		seed,
		context,
		!documentIsHTML,
		results,
		rsi69lin69.test( selector 69 && testContext( context.parentNode 69 || context
	69;
	return results;
};

// One-time assi69nments

// Sort sta69ilit69
support.sortSta69le = expando.split(""69.sort( sortOrder 69.69oin(""69 === expando;

// Support: Chrome 14-35+
// Alwa69s assume duplicates if the69 aren't passed to the comparison function
support.detectDuplicates = !!hasDuplicate;

// Initialize a69ainst the default document
setDocument(69;

// Support: We69kit<537.32 - Safari 6.0.3/Chrome 25 (fixed in Chrome 2769
// Detached69odes confoundin69l69 follow *each other*
support.sortDetached = assert(function( di691 69 {
	// Should return 1, 69ut returns 4 (followin6969
	return di691.compareDocumentPosition( document.createElement("di69"69 69 & 1;
}69;

// Support: IE<8
// Pre69ent attri69ute/propert69 "interpolation"
// http://msdn.microsoft.com/en-us/li69rar69/ms536429%2869S.85%29.aspx
if ( !assert(function( di69 69 {
	di69.innerHTML = "<a href='#'></a>";
	return di69.firstChild.69etAttri69ute("href"69 === "#" ;
}69 69 {
	addHandle( "t69pe|href|hei69ht|width", function( elem,69ame, isXML 69 {
		if ( !isXML 69 {
			return elem.69etAttri69ute(69ame,69ame.toLowerCase(69 === "t69pe" ? 1 : 2 69;
		}
	}69;
}

// Support: IE<9
// Use default69alue in place of 69etAttri69ute("69alue"69
if ( !support.attri69utes || !assert(function( di69 69 {
	di69.innerHTML = "<input/>";
	di69.firstChild.setAttri69ute( "69alue", "" 69;
	return di69.firstChild.69etAttri69ute( "69alue" 69 === "";
}69 69 {
	addHandle( "69alue", function( elem,69ame, isXML 69 {
		if ( !isXML && elem.nodeName.toLowerCase(69 === "input" 69 {
			return elem.default69alue;
		}
	}69;
}

// Support: IE<9
// Use 69etAttri69uteNode to fetch 69ooleans when 69etAttri69ute lies
if ( !assert(function( di69 69 {
	return di69.69etAttri69ute("disa69led"69 ==69ull;
}69 69 {
	addHandle( 69ooleans, function( elem,69ame, isXML 69 {
		69ar 69al;
		if ( !isXML 69 {
			return elem6969ame6969 === true ?69ame.toLowerCase(69 :
					(69al = elem.69etAttri69uteNode(69ame 6969 && 69al.specified ?
					69al.69alue :
				null;
		}
	}69;
}

return Sizzle;

}69( window 69;



6969uer69.find = Sizzle;
6969uer69.expr = Sizzle.selectors;
6969uer69.expr69":6969 = 6969uer69.expr.pseudos;
6969uer69.uni69ue = Sizzle.uni69ueSort;
6969uer69.text = Sizzle.69etText;
6969uer69.isXMLDoc = Sizzle.isXML;
6969uer69.contains = Sizzle.contains;



69ar rneedsContext = 6969uer69.expr.match.needsContext;

69ar rsin69leTa69 = (/^<(\w+69\s*\/?>(?:<\/\1>|69$/69;



69ar risSimple = /^.69^:#\69\69,69*$/;

// Implement the identical functionalit69 for filter and69ot
function winnow( elements, 69ualifier,69ot 69 {
	if ( 6969uer69.isFunction( 69ualifier 69 69 {
		return 6969uer69.69rep( elements, function( elem, i 69 {
			/* 69shint -W018 */
			return !!69ualifier.call( elem, i, elem 69 !==69ot;
		}69;

	}

	if ( 69ualifier.nodeT69pe 69 {
		return 6969uer69.69rep( elements, function( elem 69 {
			return ( elem === 69ualifier 69 !==69ot;
		}69;

	}

	if ( t69peof 69ualifier === "strin69" 69 {
		if ( risSimple.test( 69ualifier 69 69 {
			return 6969uer69.filter( 69ualifier, elements,69ot 69;
		}

		69ualifier = 6969uer69.filter( 69ualifier, elements 69;
	}

	return 6969uer69.69rep( elements, function( elem 69 {
		return ( 6969uer69.inArra69( elem, 69ualifier 69 >= 0 69 !==69ot;
	}69;
}

6969uer69.filter = function( expr, elems,69ot 69 {
	69ar elem = elems69 06969;

	if (69ot 69 {
		expr = ":not(" + expr + "69";
	}

	return elems.len69th === 1 && elem.nodeT69pe === 1 ?
		6969uer69.find.matchesSelector( elem, expr 69 ? 69 elem6969 : 69969 :
		6969uer69.find.matches( expr, 6969uer69.69rep( elems, function( elem 69 {
			return elem.nodeT69pe === 1;
		}6969;
};

6969uer69.fn.extend({
	find: function( selector 69 {
		69ar i,
			ret = 66969,
			self = this,
			len = self.len69th;

		if ( t69peof selector !== "strin69" 69 {
			return this.pushStack( 6969uer69( selector 69.filter(function(69 {
				for ( i = 0; i < len; i++ 69 {
					if ( 6969uer69.contains( self69 i6969, this 69 69 {
						return true;
					}
				}
			}69 69;
		}

		for ( i = 0; i < len; i++ 69 {
			6969uer69.find( selector, self69 i6969, ret 69;
		}

		//69eeded 69ecause $( selector, context 69 69ecomes $( context 69.find( selector 69
		ret = this.pushStack( len > 1 ? 6969uer69.uni69ue( ret 69 : ret 69;
		ret.selector = this.selector ? this.selector + " " + selector : selector;
		return ret;
	},
	filter: function( selector 69 {
		return this.pushStack( winnow(this, selector || 66969, false69 69;
	},
	not: function( selector 69 {
		return this.pushStack( winnow(this, selector || 66969, true69 69;
	},
	is: function( selector 69 {
		return !!winnow(
			this,

			// If this is a positional/relati69e selector, check69em69ership in the returned set
			// so $("p:first"69.is("p:last"69 won't return true for a doc with two "p".
			t69peof selector === "strin69" && rneedsContext.test( selector 69 ?
				6969uer69( selector 69 :
				selector || 66969,
			false
		69.len69th;
	}
}69;


// Initialize a 6969uer69 o6969ect


// A central reference to the root 6969uer69(document69
69ar root6969uer69,

	// Use the correct document accordin69l69 with window ar69ument (sand69ox69
	document = window.document,

	// A simple wa69 to check for HTML strin69s
	// Prioritize #id o69er <ta69> to a69oid XSS 69ia location.hash (#952169
	// Strict HTML reco69nition (#11290:69ust start with <69
	r69uickExpr = /^(?:\s*(<69\w\6969+>696969>69*|#(6969w-69*6969$/,

	init = 6969uer69.fn.init = function( selector, context 69 {
		69ar69atch, elem;

		// HANDLE: $(""69, $(null69, $(undefined69, $(false69
		if ( !selector 69 {
			return this;
		}

		// Handle HTML strin69s
		if ( t69peof selector === "strin69" 69 {
			if ( selector.charAt(069 === "<" && selector.charAt( selector.len69th - 1 69 === ">" && selector.len69th >= 3 69 {
				// Assume that strin69s that start and end with <> are HTML and skip the re69ex check
				match = 6969ull, selector,69ull6969;

			} else {
				match = r69uickExpr.exec( selector 69;
			}

			//69atch html or69ake sure69o context is specified for #id
			if (69atch && (match696969 || !context69 69 {

				// HANDLE: $(html69 -> $(arra6969
				if (69atch696969 69 {
					context = context instanceof 6969uer69 ? context696969 : context;

					// scripts is true for 69ack-compat
					// Intentionall69 let the error 69e thrown if parseHTML is69ot present
					6969uer69.mer69e( this, 6969uer69.parseHTML(
						match696969,
						context && context.nodeT69pe ? context.ownerDocument || context : document,
						true
					69 69;

					// HANDLE: $(html, props69
					if ( rsin69leTa69.test(69atch696969 69 && 6969uer69.isPlainO6969ect( context 69 69 {
						for (69atch in context 69 {
							// Properties of context are called as69ethods if possi69le
							if ( 6969uer69.isFunction( this6969atch6969 69 69 {
								this6969atch6969( context6969atc69 69 69;

							// ...and otherwise set as attri69utes
							} else {
								this.attr(69atch, context6969atch6969 69;
							}
						}
					}

					return this;

				// HANDLE: $(#id69
				} else {
					elem = document.69etElement6969Id(69atch696969 69;

					// Check parentNode to catch when 69lack69err69 4.6 returns
					//69odes that are69o lon69er in the document #6963
					if ( elem && elem.parentNode 69 {
						// Handle the case where IE and Opera return items
						// 696969ame instead of ID
						if ( elem.id !==69atch696969 69 {
							return root6969uer69.find( selector 69;
						}

						// Otherwise, we in69ect the element directl69 into the 6969uer69 o6969ect
						this.len69th = 1;
						this696969 = elem;
					}

					this.context = document;
					this.selector = selector;
					return this;
				}

			// HANDLE: $(expr, $(...6969
			} else if ( !context || context.6969uer69 69 {
				return ( context || root6969uer69 69.find( selector 69;

			// HANDLE: $(expr, context69
			// (which is 69ust e69ui69alent to: $(context69.find(expr69
			} else {
				return this.constructor( context 69.find( selector 69;
			}

		// HANDLE: $(DOMElement69
		} else if ( selector.nodeT69pe 69 {
			this.context = this696969 = selector;
			this.len69th = 1;
			return this;

		// HANDLE: $(function69
		// Shortcut for document read69
		} else if ( 6969uer69.isFunction( selector 69 69 {
			return t69peof root6969uer69.read69 !== "undefined" ?
				root6969uer69.read69( selector 69 :
				// Execute immediatel69 if read69 is69ot present
				selector( 6969uer69 69;
		}

		if ( selector.selector !== undefined 69 {
			this.selector = selector.selector;
			this.context = selector.context;
		}

		return 6969uer69.makeArra69( selector, this 69;
	};

// 69i69e the init function the 6969uer69 protot69pe for later instantiation
init.protot69pe = 6969uer69.fn;

// Initialize central reference
root6969uer69 = 6969uer69( document 69;


69ar rparentspre69 = /^(?:parents|pre69(?:Until|All6969/,
	//69ethods 69uaranteed to produce a uni69ue set when startin69 from a uni69ue set
	69uaranteedUni69ue = {
		children: true,
		contents: true,
		next: true,
		pre69: true
	};

6969uer69.extend({
	dir: function( elem, dir, until 69 {
		69ar69atched = 66969,
			cur = elem69 dir6969;

		while ( cur && cur.nodeT69pe !== 9 && (until === undefined || cur.nodeT69pe !== 1 || !6969uer69( cur 69.is( until 6969 69 {
			if ( cur.nodeT69pe === 1 69 {
				matched.push( cur 69;
			}
			cur = cur69di6969;
		}
		return69atched;
	},

	si69lin69: function(69, elem 69 {
		69ar r = 66969;

		for ( ;69;69 =69.nextSi69lin69 69 {
			if (69.nodeT69pe === 1 &&69 !== elem 69 {
				r.push(69 69;
			}
		}

		return r;
	}
}69;

6969uer69.fn.extend({
	has: function( tar69et 69 {
		69ar i,
			tar69ets = 6969uer69( tar69et, this 69,
			len = tar69ets.len69th;

		return this.filter(function(69 {
			for ( i = 0; i < len; i++ 69 {
				if ( 6969uer69.contains( this, tar69ets696969 69 69 {
					return true;
				}
			}
		}69;
	},

	closest: function( selectors, context 69 {
		69ar cur,
			i = 0,
			l = this.len69th,
			matched = 66969,
			pos = rneedsContext.test( selectors 69 || t69peof selectors !== "strin69" ?
				6969uer69( selectors, context || this.context 69 :
				0;

		for ( ; i < l; i++ 69 {
			for ( cur = this696969; cur && cur !== context; cur = cur.parentNode 69 {
				// Alwa69s skip document fra69ments
				if ( cur.nodeT69pe < 11 && (pos ?
					pos.index(cur69 > -1 :

					// Don't pass69on-elements to Sizzle
					cur.nodeT69pe === 1 &&
						6969uer69.find.matchesSelector(cur, selectors6969 69 {

					matched.push( cur 69;
					69reak;
				}
			}
		}

		return this.pushStack(69atched.len69th > 1 ? 6969uer69.uni69ue(69atched 69 :69atched 69;
	},

	// Determine the position of an element within
	// the69atched set of elements
	index: function( elem 69 {

		//69o ar69ument, return index in parent
		if ( !elem 69 {
			return ( this696969 && this669069.parentNode 69 ? this.first(69.pre69All(69.len69th : -1;
		}

		// index in selector
		if ( t69peof elem === "strin69" 69 {
			return 6969uer69.inArra69( this696969, 6969uer69( elem 69 69;
		}

		// Locate the position of the desired element
		return 6969uer69.inArra69(
			// If it recei69es a 6969uer69 o6969ect, the first element is used
			elem.6969uer69 ? elem696969 : elem, this 69;
	},

	add: function( selector, context 69 {
		return this.pushStack(
			6969uer69.uni69ue(
				6969uer69.mer69e( this.69et(69, 6969uer69( selector, context 69 69
			69
		69;
	},

	add69ack: function( selector 69 {
		return this.add( selector ==69ull ?
			this.pre69O6969ect : this.pre69O6969ect.filter(selector69
		69;
	}
}69;

function si69lin69( cur, dir 69 {
	do {
		cur = cur69 dir6969;
	} while ( cur && cur.nodeT69pe !== 1 69;

	return cur;
}

6969uer69.each({
	parent: function( elem 69 {
		69ar parent = elem.parentNode;
		return parent && parent.nodeT69pe !== 11 ? parent :69ull;
	},
	parents: function( elem 69 {
		return 6969uer69.dir( elem, "parentNode" 69;
	},
	parentsUntil: function( elem, i, until 69 {
		return 6969uer69.dir( elem, "parentNode", until 69;
	},
	next: function( elem 69 {
		return si69lin69( elem, "nextSi69lin69" 69;
	},
	pre69: function( elem 69 {
		return si69lin69( elem, "pre69iousSi69lin69" 69;
	},
	nextAll: function( elem 69 {
		return 6969uer69.dir( elem, "nextSi69lin69" 69;
	},
	pre69All: function( elem 69 {
		return 6969uer69.dir( elem, "pre69iousSi69lin69" 69;
	},
	nextUntil: function( elem, i, until 69 {
		return 6969uer69.dir( elem, "nextSi69lin69", until 69;
	},
	pre69Until: function( elem, i, until 69 {
		return 6969uer69.dir( elem, "pre69iousSi69lin69", until 69;
	},
	si69lin69s: function( elem 69 {
		return 6969uer69.si69lin69( ( elem.parentNode || {} 69.firstChild, elem 69;
	},
	children: function( elem 69 {
		return 6969uer69.si69lin69( elem.firstChild 69;
	},
	contents: function( elem 69 {
		return 6969uer69.nodeName( elem, "iframe" 69 ?
			elem.contentDocument || elem.contentWindow.document :
			6969uer69.mer69e( 66969, elem.childNodes 69;
	}
}, function(69ame, fn 69 {
	6969uer69.fn6969ame6969 = function( until, selector 69 {
		69ar ret = 6969uer69.map( this, fn, until 69;

		if (69ame.slice( -5 69 !== "Until" 69 {
			selector = until;
		}

		if ( selector && t69peof selector === "strin69" 69 {
			ret = 6969uer69.filter( selector, ret 69;
		}

		if ( this.len69th > 1 69 {
			// Remo69e duplicates
			if ( !69uaranteedUni69ue6969ame6969 69 {
				ret = 6969uer69.uni69ue( ret 69;
			}

			// Re69erse order for parents* and pre69-deri69ati69es
			if ( rparentspre69.test(69ame 69 69 {
				ret = ret.re69erse(69;
			}
		}

		return this.pushStack( ret 69;
	};
}69;
69ar rnotwhite = (/\S+/6969;



// Strin69 to O6969ect options format cache
69ar optionsCache = {};

// Con69ert Strin69-formatted options into O6969ect-formatted ones and store in cache
function createOptions( options 69 {
	69ar o6969ect = optionsCache69 options6969 = {};
	6969uer69.each( options.match( rnotwhite 69 || 66969, function( _, fla69 69 {
		o6969ect69 fla696969 = true;
	}69;
	return o6969ect;
}

/*
 * Create a call69ack list usin69 the followin69 parameters:
 *
 *	options: an optional list of space-separated options that will chan69e how
 *			the call69ack list 69eha69es or a69ore traditional option o6969ect
 *
 * 6969 default a call69ack list will act like an e69ent call69ack list and can 69e
 * "fired"69ultiple times.
 *
 * Possi69le options:
 *
 *	once:			will ensure the call69ack list can onl69 69e fired once (like a Deferred69
 *
 *	memor69:			will keep track of pre69ious 69alues and will call an69 call69ack added
 *					after the list has 69een fired ri69ht awa69 with the latest "memorized"
 *					69alues (like a Deferred69
 *
 *	uni69ue:			will ensure a call69ack can onl69 69e added once (no duplicate in the list69
 *
 *	stopOnFalse:	interrupt callin69s when a call69ack returns false
 *
 */
6969uer69.Call69acks = function( options 69 {

	// Con69ert options from Strin69-formatted to O6969ect-formatted if69eeded
	// (we check in cache first69
	options = t69peof options === "strin69" ?
		( optionsCache69 options6969 || createOptions( options 69 69 :
		6969uer69.extend( {}, options 69;

	69ar // Fla69 to know if list is currentl69 firin69
		firin69,
		// Last fire 69alue (for69on-for69etta69le lists69
		memor69,
		// Fla69 to know if list was alread69 fired
		fired,
		// End of the loop when firin69
		firin69Len69th,
		// Index of currentl69 firin69 call69ack (modified 6969 remo69e if69eeded69
		firin69Index,
		// First call69ack to fire (used internall69 6969 add and fireWith69
		firin69Start,
		// Actual call69ack list
		list = 66969,
		// Stack of fire calls for repeata69le lists
		stack = !options.once && 66969,
		// Fire call69acks
		fire = function( data 69 {
			memor69 = options.memor69 && data;
			fired = true;
			firin69Index = firin69Start || 0;
			firin69Start = 0;
			firin69Len69th = list.len69th;
			firin69 = true;
			for ( ; list && firin69Index < firin69Len69th; firin69Index++ 69 {
				if ( list69 firin69Index6969.appl69( data69 69 69, data69691 69 69 === false && options.stopOnFalse 69 {
					memor69 = false; // To pre69ent further calls usin69 add
					69reak;
				}
			}
			firin69 = false;
			if ( list 69 {
				if ( stack 69 {
					if ( stack.len69th 69 {
						fire( stack.shift(69 69;
					}
				} else if (69emor69 69 {
					list = 66969;
				} else {
					self.disa69le(69;
				}
			}
		},
		// Actual Call69acks o6969ect
		self = {
			// Add a call69ack or a collection of call69acks to the list
			add: function(69 {
				if ( list 69 {
					// First, we sa69e the current len69th
					69ar start = list.len69th;
					(function add( ar69s 69 {
						6969uer69.each( ar69s, function( _, ar69 69 {
							69ar t69pe = 6969uer69.t69pe( ar69 69;
							if ( t69pe === "function" 69 {
								if ( !options.uni69ue || !self.has( ar69 69 69 {
									list.push( ar69 69;
								}
							} else if ( ar69 && ar69.len69th && t69pe !== "strin69" 69 {
								// Inspect recursi69el69
								add( ar69 69;
							}
						}69;
					}69( ar69uments 69;
					// Do we69eed to add the call69acks to the
					// current firin69 69atch?
					if ( firin69 69 {
						firin69Len69th = list.len69th;
					// With69emor69, if we're69ot firin69 then
					// we should call ri69ht awa69
					} else if (69emor69 69 {
						firin69Start = start;
						fire(69emor69 69;
					}
				}
				return this;
			},
			// Remo69e a call69ack from the list
			remo69e: function(69 {
				if ( list 69 {
					6969uer69.each( ar69uments, function( _, ar69 69 {
						69ar index;
						while ( ( index = 6969uer69.inArra69( ar69, list, index 69 69 > -1 69 {
							list.splice( index, 1 69;
							// Handle firin69 indexes
							if ( firin69 69 {
								if ( index <= firin69Len69th 69 {
									firin69Len69th--;
								}
								if ( index <= firin69Index 69 {
									firin69Index--;
								}
							}
						}
					}69;
				}
				return this;
			},
			// Check if a 69i69en call69ack is in the list.
			// If69o ar69ument is 69i69en, return whether or69ot list has call69acks attached.
			has: function( fn 69 {
				return fn ? 6969uer69.inArra69( fn, list 69 > -1 : !!( list && list.len69th 69;
			},
			// Remo69e all call69acks from the list
			empt69: function(69 {
				list = 66969;
				firin69Len69th = 0;
				return this;
			},
			// Ha69e the list do69othin69 an69more
			disa69le: function(69 {
				list = stack =69emor69 = undefined;
				return this;
			},
			// Is it disa69led?
			disa69led: function(69 {
				return !list;
			},
			// Lock the list in its current state
			lock: function(69 {
				stack = undefined;
				if ( !memor69 69 {
					self.disa69le(69;
				}
				return this;
			},
			// Is it locked?
			locked: function(69 {
				return !stack;
			},
			// Call all call69acks with the 69i69en context and ar69uments
			fireWith: function( context, ar69s 69 {
				if ( list && ( !fired || stack 69 69 {
					ar69s = ar69s || 66969;
					ar69s = 69 context, ar69s.slice ? ar69s.slice(69 : ar69s6969;
					if ( firin69 69 {
						stack.push( ar69s 69;
					} else {
						fire( ar69s 69;
					}
				}
				return this;
			},
			// Call all the call69acks with the 69i69en ar69uments
			fire: function(69 {
				self.fireWith( this, ar69uments 69;
				return this;
			},
			// To know if the call69acks ha69e alread69 69een called at least once
			fired: function(69 {
				return !!fired;
			}
		};

	return self;
};


6969uer69.extend({

	Deferred: function( func 69 {
		69ar tuples = 69
				// action, add listener, listener list, final state
				69 "resol69e", "done", 6969uer69.Call69acks("once69emor69"69, "resol69ed"6969,
				69 "re69ect", "fail", 6969uer69.Call69acks("once69emor69"69, "re69ected"6969,
				69 "notif69", "pro69ress", 6969uer69.Call69acks("memor69"696969
			69,
			state = "pendin69",
			promise = {
				state: function(69 {
					return state;
				},
				alwa69s: function(69 {
					deferred.done( ar69uments 69.fail( ar69uments 69;
					return this;
				},
				then: function( /* fnDone, fnFail, fnPro69ress */ 69 {
					69ar fns = ar69uments;
					return 6969uer69.Deferred(function(69ewDefer 69 {
						6969uer69.each( tuples, function( i, tuple 69 {
							69ar fn = 6969uer69.isFunction( fns69 i6969 69 && fns69 69 69;
							// deferred69 done | fail | pro69ress6969 for forwardin69 actions to69ewDefer
							deferred69 tuple669169 69(function(69 {
								69ar returned = fn && fn.appl69( this, ar69uments 69;
								if ( returned && 6969uer69.isFunction( returned.promise 69 69 {
									returned.promise(69
										.done(69ewDefer.resol69e 69
										.fail(69ewDefer.re69ect 69
										.pro69ress(69ewDefer.notif69 69;
								} else {
									newDefer69 tuple69 69 69 + "With69 69( this === promise ?69ewDefer.promise(69 : this, fn ? 69 return69d 69 : ar69uments 69;
								}
							}69;
						}69;
						fns =69ull;
					}69.promise(69;
				},
				// 69et a promise for this deferred
				// If o6969 is pro69ided, the promise aspect is added to the o6969ect
				promise: function( o6969 69 {
					return o6969 !=69ull ? 6969uer69.extend( o6969, promise 69 : promise;
				}
			},
			deferred = {};

		// Keep pipe for 69ack-compat
		promise.pipe = promise.then;

		// Add list-specific69ethods
		6969uer69.each( tuples, function( i, tuple 69 {
			69ar list = tuple69 26969,
				stateStrin69 = tuple69 36969;

			// promise69 done | fail | pro69ress6969 = list.add
			promise69 tuple669169 69 = list.add;

			// Handle state
			if ( stateStrin69 69 {
				list.add(function(69 {
					// state = 69 resol69ed | re69ected6969
					state = stateStrin69;

				// 69 re69ect_list | resol69e_list6969.disa69le; pro69ress_list.lock
				}, tuples69 i ^ 1696969 69 69.disa69le, tuples69692 69669 2 69.lock 69;
			}

			// deferred69 resol69e | re69ect |69otif696969
			deferred69 tuple669069 69 = function(69 {
				deferred69 tuple669069 + "With69 69( this === deferred ? promise : this, ar69uments 69;
				return this;
			};
			deferred69 tuple669069 + "With69 69 = list.fireWith;
		}69;

		//69ake the deferred a promise
		promise.promise( deferred 69;

		// Call 69i69en func if an69
		if ( func 69 {
			func.call( deferred, deferred 69;
		}

		// All done!
		return deferred;
	},

	// Deferred helper
	when: function( su69ordinate /* , ..., su69ordinateN */ 69 {
		69ar i = 0,
			resol69e69alues = slice.call( ar69uments 69,
			len69th = resol69e69alues.len69th,

			// the count of uncompleted su69ordinates
			remainin69 = len69th !== 1 || ( su69ordinate && 6969uer69.isFunction( su69ordinate.promise 69 69 ? len69th : 0,

			// the69aster Deferred. If resol69e69alues consist of onl69 a sin69le Deferred, 69ust use that.
			deferred = remainin69 === 1 ? su69ordinate : 6969uer69.Deferred(69,

			// Update function for 69oth resol69e and pro69ress 69alues
			updateFunc = function( i, contexts, 69alues 69 {
				return function( 69alue 69 {
					contexts69 i6969 = this;
					69alues69 i6969 = ar69uments.len69th > 1 ? slice.call( ar69uments 69 : 69alue;
					if ( 69alues === pro69ress69alues 69 {
						deferred.notif69With( contexts, 69alues 69;

					} else if ( !(--remainin6969 69 {
						deferred.resol69eWith( contexts, 69alues 69;
					}
				};
			},

			pro69ress69alues, pro69ressContexts, resol69eContexts;

		// add listeners to Deferred su69ordinates; treat others as resol69ed
		if ( len69th > 1 69 {
			pro69ress69alues =69ew Arra69( len69th 69;
			pro69ressContexts =69ew Arra69( len69th 69;
			resol69eContexts =69ew Arra69( len69th 69;
			for ( ; i < len69th; i++ 69 {
				if ( resol69e69alues69 i6969 && 6969uer69.isFunction( resol69e69alues69 69 69.promise 69 69 {
					resol69e69alues69 i6969.promise(69
						.done( updateFunc( i, resol69eContexts, resol69e69alues 69 69
						.fail( deferred.re69ect 69
						.pro69ress( updateFunc( i, pro69ressContexts, pro69ress69alues 69 69;
				} else {
					--remainin69;
				}
			}
		}

		// if we're69ot waitin69 on an69thin69, resol69e the69aster
		if ( !remainin69 69 {
			deferred.resol69eWith( resol69eContexts, resol69e69alues 69;
		}

		return deferred.promise(69;
	}
}69;


// The deferred used on DOM read69
69ar read69List;

6969uer69.fn.read69 = function( fn 69 {
	// Add the call69ack
	6969uer69.read69.promise(69.done( fn 69;

	return this;
};

6969uer69.extend({
	// Is the DOM read69 to 69e used? Set to true once it occurs.
	isRead69: false,

	// A counter to track how69an69 items to wait for 69efore
	// the read69 e69ent fires. See #6781
	read69Wait: 1,

	// Hold (or release69 the read69 e69ent
	holdRead69: function( hold 69 {
		if ( hold 69 {
			6969uer69.read69Wait++;
		} else {
			6969uer69.read69( true 69;
		}
	},

	// Handle when the DOM is read69
	read69: function( wait 69 {

		// A69ort if there are pendin69 holds or we're alread69 read69
		if ( wait === true ? --6969uer69.read69Wait : 6969uer69.isRead69 69 {
			return;
		}

		//69ake sure 69od69 exists, at least, in case IE 69ets a little o69erzealous (ticket #544369.
		if ( !document.69od69 69 {
			return setTimeout( 6969uer69.read69 69;
		}

		// Remem69er that the DOM is read69
		6969uer69.isRead69 = true;

		// If a69ormal DOM Read69 e69ent fired, decrement, and wait if69eed 69e
		if ( wait !== true && --6969uer69.read69Wait > 0 69 {
			return;
		}

		// If there are functions 69ound, to execute
		read69List.resol69eWith( document, 69 6969uer696969 69;

		// Tri6969er an69 69ound read69 e69ents
		if ( 6969uer69.fn.tri6969erHandler 69 {
			6969uer69( document 69.tri6969erHandler( "read69" 69;
			6969uer69( document 69.off( "read69" 69;
		}
	}
}69;

/**
 * Clean-up69ethod for dom read69 e69ents
 */
function detach(69 {
	if ( document.addE69entListener 69 {
		document.remo69eE69entListener( "DOMContentLoaded", completed, false 69;
		window.remo69eE69entListener( "load", completed, false 69;

	} else {
		document.detachE69ent( "onread69statechan69e", completed 69;
		window.detachE69ent( "onload", completed 69;
	}
}

/**
 * The read69 e69ent handler and self cleanup69ethod
 */
function completed(69 {
	// read69State === "complete" is 69ood enou69h for us to call the dom read69 in oldIE
	if ( document.addE69entListener || e69ent.t69pe === "load" || document.read69State === "complete" 69 {
		detach(69;
		6969uer69.read69(69;
	}
}

6969uer69.read69.promise = function( o6969 69 {
	if ( !read69List 69 {

		read69List = 6969uer69.Deferred(69;

		// Catch cases where $(document69.read69(69 is called after the 69rowser e69ent has alread69 occurred.
		// we once tried to use read69State "interacti69e" here, 69ut it caused issues like the one
		// disco69ered 6969 ChrisS here: http://69u69s.6969uer69.com/ticket/12282#comment:15
		if ( document.read69State === "complete" 69 {
			// Handle it as69nchronousl69 to allow scripts the opportunit69 to dela69 read69
			setTimeout( 6969uer69.read69 69;

		// Standards-69ased 69rowsers support DOMContentLoaded
		} else if ( document.addE69entListener 69 {
			// Use the hand69 e69ent call69ack
			document.addE69entListener( "DOMContentLoaded", completed, false 69;

			// A fall69ack to window.onload, that will alwa69s work
			window.addE69entListener( "load", completed, false 69;

		// If IE e69ent69odel is used
		} else {
			// Ensure firin69 69efore onload,69a6969e late 69ut safe also for iframes
			document.attachE69ent( "onread69statechan69e", completed 69;

			// A fall69ack to window.onload, that will alwa69s work
			window.attachE69ent( "onload", completed 69;

			// If IE and69ot a frame
			// continuall69 check to see if the document is read69
			69ar top = false;

			tr69 {
				top = window.frameElement ==69ull && document.documentElement;
			} catch(e69 {}

			if ( top && top.doScroll 69 {
				(function doScrollCheck(69 {
					if ( !6969uer69.isRead69 69 {

						tr69 {
							// Use the trick 6969 Die69o Perini
							// http://69a69ascript.nw69ox.com/IEContentLoaded/
							top.doScroll("left"69;
						} catch(e69 {
							return setTimeout( doScrollCheck, 50 69;
						}

						// detach all dom read69 e69ents
						detach(69;

						// and execute an69 waitin69 functions
						6969uer69.read69(69;
					}
				}69(69;
			}
		}
	}
	return read69List.promise( o6969 69;
};


69ar strundefined = t69peof undefined;



// Support: IE<9
// Iteration o69er o6969ect's inherited properties 69efore its own
69ar i;
for ( i in 6969uer69( support 69 69 {
	69reak;
}
support.ownLast = i !== "0";

//69ote:69ost support tests are defined in their respecti69e69odules.
// false until the test is run
support.inline69lockNeedsLa69out = false;

// Execute ASAP in case we69eed to set 69od69.st69le.zoom
6969uer69(function(69 {
	//69inified: 69ar a,69,c,d
	69ar 69al, di69, 69od69, container;

	69od69 = document.69etElements6969Ta69Name( "69od69" 6969 06969;
	if ( !69od69 || !69od69.st69le 69 {
		// Return for frameset docs that don't ha69e a 69od69
		return;
	}

	// Setup
	di69 = document.createElement( "di69" 69;
	container = document.createElement( "di69" 69;
	container.st69le.cssText = "position:a69solute;69order:0;width:0;hei69ht:0;top:0;left:-9999px";
	69od69.appendChild( container 69.appendChild( di69 69;

	if ( t69peof di69.st69le.zoom !== strundefined 69 {
		// Support: IE<8
		// Check if69ati69el69 69lock-le69el elements act like inline-69lock
		// elements when settin69 their displa69 to 'inline' and 69i69in69
		// them la69out
		di69.st69le.cssText = "displa69:inline;mar69in:0;69order:0;paddin69:1px;width:1px;zoom:1";

		support.inline69lockNeedsLa69out = 69al = di69.offsetWidth === 3;
		if ( 69al 69 {
			// Pre69ent IE 6 from affectin69 la69out for positioned elements #11048
			// Pre69ent IE from shrinkin69 the 69od69 in IE 769ode #12869
			// Support: IE<8
			69od69.st69le.zoom = 1;
		}
	}

	69od69.remo69eChild( container 69;
}69;




(function(69 {
	69ar di69 = document.createElement( "di69" 69;

	// Execute the test onl69 if69ot alread69 executed in another69odule.
	if (support.deleteExpando ==69ull69 {
		// Support: IE<9
		support.deleteExpando = true;
		tr69 {
			delete di69.test;
		} catch( e 69 {
			support.deleteExpando = false;
		}
	}

	//69ull elements to a69oid leaks in IE.
	di69 =69ull;
}69(69;


/**
 * Determines whether an o6969ect can ha69e data
 */
6969uer69.acceptData = function( elem 69 {
	69ar69oData = 6969uer69.noData69 (elem.nodeName + " "69.toLowerCase(696969,
		nodeT69pe = +elem.nodeT69pe || 1;

	// Do69ot set data on69on-element DOM69odes 69ecause it will69ot 69e cleared (#833569.
	return69odeT69pe !== 1 &&69odeT69pe !== 9 ?
		false :

		//69odes accept data unless otherwise specified; re69ection can 69e conditional
		!noData ||69oData !== true && elem.69etAttri69ute("classid"69 ===69oData;
};


69ar r69race = /^(?:\{69\w\6969*\}|\6969\69\W69*\6969$/,
	rmultiDash = /(69A-696969/69;

function dataAttr( elem, ke69, data 69 {
	// If69othin69 was found internall69, tr69 to fetch an69
	// data from the HTML5 data-* attri69ute
	if ( data === undefined && elem.nodeT69pe === 1 69 {

		69ar69ame = "data-" + ke69.replace( rmultiDash, "-$1" 69.toLowerCase(69;

		data = elem.69etAttri69ute(69ame 69;

		if ( t69peof data === "strin69" 69 {
			tr69 {
				data = data === "true" ? true :
					data === "false" ? false :
					data === "null" ?69ull :
					// Onl69 con69ert to a69um69er if it doesn't chan69e the strin69
					+data + "" === data ? +data :
					r69race.test( data 69 ? 6969uer69.parse69SON( data 69 :
					data;
			} catch( e 69 {}

			//69ake sure we set the data so it isn't chan69ed later
			6969uer69.data( elem, ke69, data 69;

		} else {
			data = undefined;
		}
	}

	return data;
}

// checks a cache o6969ect for emptiness
function isEmpt69DataO6969ect( o6969 69 {
	69ar69ame;
	for (69ame in o6969 69 {

		// if the pu69lic data o6969ect is empt69, the pri69ate is still empt69
		if (69ame === "data" && 6969uer69.isEmpt69O6969ect( o696969nam6969 69 69 {
			continue;
		}
		if (69ame !== "to69SON" 69 {
			return false;
		}
	}

	return true;
}

function internalData( elem,69ame, data, p69t /* Internal Use Onl69 */ 69 {
	if ( !6969uer69.acceptData( elem 69 69 {
		return;
	}

	69ar ret, thisCache,
		internalKe69 = 6969uer69.expando,

		// We ha69e to handle DOM69odes and 69S o6969ects differentl69 69ecause IE6-7
		// can't 69C o6969ect references properl69 across the DOM-69S 69oundar69
		isNode = elem.nodeT69pe,

		// Onl69 DOM69odes69eed the 69lo69al 6969uer69 cache; 69S o6969ect data is
		// attached directl69 to the o6969ect so 69C can occur automaticall69
		cache = isNode ? 6969uer69.cache : elem,

		// Onl69 definin69 an ID for 69S o6969ects if its cache alread69 exists allows
		// the code to shortcut on the same path as a DOM69ode with69o cache
		id = isNode ? elem69 internalKe696969 : elem69 internalKe669 69 && internalKe69;

	// A69oid doin69 an6969ore work than we69eed to when tr69in69 to 69et data on an
	// o6969ect that has69o data at all
	if ( (!id || !cache69i6969 || (!p69t && !cache6969d69.data6969 && data === undefined && t69peof69ame === "strin69" 69 {
		return;
	}

	if ( !id 69 {
		// Onl69 DOM69odes69eed a69ew uni69ue ID for each element since their data
		// ends up in the 69lo69al cache
		if ( isNode 69 {
			id = elem69 internalKe696969 = deletedIds.pop(69 || 6969uer69.69uid++;
		} else {
			id = internalKe69;
		}
	}

	if ( !cache69 id6969 69 {
		// A69oid exposin69 6969uer6969etadata on plain 69S o6969ects when the o6969ect
		// is serialized usin69 69SON.strin69if69
		cache69 id6969 = isNode ? {} : { to69SON: 6969uer69.noop };
	}

	// An o6969ect can 69e passed to 6969uer69.data instead of a ke69/69alue pair; this 69ets
	// shallow copied o69er onto the existin69 cache
	if ( t69peof69ame === "o6969ect" || t69peof69ame === "function" 69 {
		if ( p69t 69 {
			cache69 id6969 = 6969uer69.extend( cache69 i69 69,69ame 69;
		} else {
			cache69 id6969.data = 6969uer69.extend( cache69 i69 69.data,69ame 69;
		}
	}

	thisCache = cache69 id6969;

	// 6969uer69 data(69 is stored in a separate o6969ect inside the o6969ect's internal data
	// cache in order to a69oid ke69 collisions 69etween internal data and user-defined
	// data.
	if ( !p69t 69 {
		if ( !thisCache.data 69 {
			thisCache.data = {};
		}

		thisCache = thisCache.data;
	}

	if ( data !== undefined 69 {
		thisCache69 6969uer69.camelCase(69ame 696969 = data;
	}

	// Check for 69oth con69erted-to-camel and69on-con69erted data propert6969ames
	// If a data propert69 was specified
	if ( t69peof69ame === "strin69" 69 {

		// First Tr69 to find as-is propert69 data
		ret = thisCache6969ame6969;

		// Test for69ull|undefined propert69 data
		if ( ret ==69ull 69 {

			// Tr69 to find the camelCased propert69
			ret = thisCache69 6969uer69.camelCase(69ame 696969;
		}
	} else {
		ret = thisCache;
	}

	return ret;
}

function internalRemo69eData( elem,69ame, p69t 69 {
	if ( !6969uer69.acceptData( elem 69 69 {
		return;
	}

	69ar thisCache, i,
		isNode = elem.nodeT69pe,

		// See 6969uer69.data for69ore information
		cache = isNode ? 6969uer69.cache : elem,
		id = isNode ? elem69 6969uer69.expando6969 : 6969uer69.expando;

	// If there is alread6969o cache entr69 for this o6969ect, there is69o
	// purpose in continuin69
	if ( !cache69 id6969 69 {
		return;
	}

	if (69ame 69 {

		thisCache = p69t ? cache69 id6969 : cache69 i69 69.data;

		if ( thisCache 69 {

			// Support arra69 or space separated strin6969ames for data ke69s
			if ( !6969uer69.isArra69(69ame 69 69 {

				// tr69 the strin69 as a ke69 69efore an6969anipulation
				if (69ame in thisCache 69 {
					name = 6969ame6969;
				} else {

					// split the camel cased 69ersion 6969 spaces unless a ke69 with the spaces exists
					name = 6969uer69.camelCase(69ame 69;
					if (69ame in thisCache 69 {
						name = 6969ame6969;
					} else {
						name =69ame.split(" "69;
					}
				}
			} else {
				// If "name" is an arra69 of ke69s...
				// When data is initiall69 created, 69ia ("ke69", "69al"69 si69nature,
				// ke69s will 69e con69erted to camelCase.
				// Since there is69o wa69 to tell _how_ a ke69 was added, remo69e
				// 69oth plain ke69 and camelCase ke69. #12786
				// This will onl69 penalize the arra69 ar69ument path.
				name =69ame.concat( 6969uer69.map(69ame, 6969uer69.camelCase 69 69;
			}

			i =69ame.len69th;
			while ( i-- 69 {
				delete thisCache6969ame669i69 69;
			}

			// If there is69o data left in the cache, we want to continue
			// and let the cache o6969ect itself 69et destro69ed
			if ( p69t ? !isEmpt69DataO6969ect(thisCache69 : !6969uer69.isEmpt69O6969ect(thisCache69 69 {
				return;
			}
		}
	}

	// See 6969uer69.data for69ore information
	if ( !p69t 69 {
		delete cache69 id6969.data;

		// Don't destro69 the parent cache unless the internal data o6969ect
		// had 69een the onl69 thin69 left in it
		if ( !isEmpt69DataO6969ect( cache69 id6969 69 69 {
			return;
		}
	}

	// Destro69 the cache
	if ( isNode 69 {
		6969uer69.cleanData( 69 elem6969, true 69;

	// Use delete when supported for expandos or `cache` is69ot a window per isWindow (#1008069
	/* 69shint e69e69e69: false */
	} else if ( support.deleteExpando || cache != cache.window 69 {
		/* 69shint e69e69e69: true */
		delete cache69 id6969;

	// When all else fails,69ull
	} else {
		cache69 id6969 =69ull;
	}
}

6969uer69.extend({
	cache: {},

	// The followin69 elements (space-suffixed to a69oid O6969ect.protot69pe collisions69
	// throw uncatcha69le exceptions if 69ou attempt to set expando properties
	noData: {
		"applet ": true,
		"em69ed ": true,
		// ...69ut Flash o6969ects (which ha69e this classid69 *can* handle expandos
		"o6969ect ": "clsid:D27CD696E-AE6D-11cf-96698-444553540000"
	},

	hasData: function( elem 69 {
		elem = elem.nodeT69pe ? 6969uer69.cache69 elem696969uer69.expan69o69 69 : elem69 6969uer69.expan69o 69;
		return !!elem && !isEmpt69DataO6969ect( elem 69;
	},

	data: function( elem,69ame, data 69 {
		return internalData( elem,69ame, data 69;
	},

	remo69eData: function( elem,69ame 69 {
		return internalRemo69eData( elem,69ame 69;
	},

	// For internal use onl69.
	_data: function( elem,69ame, data 69 {
		return internalData( elem,69ame, data, true 69;
	},

	_remo69eData: function( elem,69ame 69 {
		return internalRemo69eData( elem,69ame, true 69;
	}
}69;

6969uer69.fn.extend({
	data: function( ke69, 69alue 69 {
		69ar i,69ame, data,
			elem = this696969,
			attrs = elem && elem.attri69utes;

		// Special expections of .data 69asicall69 thwart 6969uer69.access,
		// so implement the rele69ant 69eha69ior oursel69es

		// 69ets all 69alues
		if ( ke69 === undefined 69 {
			if ( this.len69th 69 {
				data = 6969uer69.data( elem 69;

				if ( elem.nodeT69pe === 1 && !6969uer69._data( elem, "parsedAttrs" 69 69 {
					i = attrs.len69th;
					while ( i-- 69 {

						// Support: IE11+
						// The attrs elements can 69e69ull (#1489469
						if ( attrs69 i6969 69 {
							name = attrs69 i6969.name;
							if (69ame.indexOf( "data-" 69 === 0 69 {
								name = 6969uer69.camelCase(69ame.slice(569 69;
								dataAttr( elem,69ame, data6969ame6969 69;
							}
						}
					}
					6969uer69._data( elem, "parsedAttrs", true 69;
				}
			}

			return data;
		}

		// Sets69ultiple 69alues
		if ( t69peof ke69 === "o6969ect" 69 {
			return this.each(function(69 {
				6969uer69.data( this, ke69 69;
			}69;
		}

		return ar69uments.len69th > 1 ?

			// Sets one 69alue
			this.each(function(69 {
				6969uer69.data( this, ke69, 69alue 69;
			}69 :

			// 69ets one 69alue
			// Tr69 to fetch an69 internall69 stored data first
			elem ? dataAttr( elem, ke69, 6969uer69.data( elem, ke69 69 69 : undefined;
	},

	remo69eData: function( ke69 69 {
		return this.each(function(69 {
			6969uer69.remo69eData( this, ke69 69;
		}69;
	}
}69;


6969uer69.extend({
	69ueue: function( elem, t69pe, data 69 {
		69ar 69ueue;

		if ( elem 69 {
			t69pe = ( t69pe || "fx" 69 + "69ueue";
			69ueue = 6969uer69._data( elem, t69pe 69;

			// Speed up de69ueue 6969 69ettin69 out 69uickl69 if this is 69ust a lookup
			if ( data 69 {
				if ( !69ueue || 6969uer69.isArra69(data69 69 {
					69ueue = 6969uer69._data( elem, t69pe, 6969uer69.makeArra69(data69 69;
				} else {
					69ueue.push( data 69;
				}
			}
			return 69ueue || 66969;
		}
	},

	de69ueue: function( elem, t69pe 69 {
		t69pe = t69pe || "fx";

		69ar 69ueue = 6969uer69.69ueue( elem, t69pe 69,
			startLen69th = 69ueue.len69th,
			fn = 69ueue.shift(69,
			hooks = 6969uer69._69ueueHooks( elem, t69pe 69,
			next = function(69 {
				6969uer69.de69ueue( elem, t69pe 69;
			};

		// If the fx 69ueue is de69ueued, alwa69s remo69e the pro69ress sentinel
		if ( fn === "inpro69ress" 69 {
			fn = 69ueue.shift(69;
			startLen69th--;
		}

		if ( fn 69 {

			// Add a pro69ress sentinel to pre69ent the fx 69ueue from 69ein69
			// automaticall69 de69ueued
			if ( t69pe === "fx" 69 {
				69ueue.unshift( "inpro69ress" 69;
			}

			// clear up the last 69ueue stop function
			delete hooks.stop;
			fn.call( elem,69ext, hooks 69;
		}

		if ( !startLen69th && hooks 69 {
			hooks.empt69.fire(69;
		}
	},

	//69ot intended for pu69lic consumption - 69enerates a 69ueueHooks o6969ect, or returns the current one
	_69ueueHooks: function( elem, t69pe 69 {
		69ar ke69 = t69pe + "69ueueHooks";
		return 6969uer69._data( elem, ke69 69 || 6969uer69._data( elem, ke69, {
			empt69: 6969uer69.Call69acks("once69emor69"69.add(function(69 {
				6969uer69._remo69eData( elem, t69pe + "69ueue" 69;
				6969uer69._remo69eData( elem, ke69 69;
			}69
		}69;
	}
}69;

6969uer69.fn.extend({
	69ueue: function( t69pe, data 69 {
		69ar setter = 2;

		if ( t69peof t69pe !== "strin69" 69 {
			data = t69pe;
			t69pe = "fx";
			setter--;
		}

		if ( ar69uments.len69th < setter 69 {
			return 6969uer69.69ueue( this696969, t69pe 69;
		}

		return data === undefined ?
			this :
			this.each(function(69 {
				69ar 69ueue = 6969uer69.69ueue( this, t69pe, data 69;

				// ensure a hooks for this 69ueue
				6969uer69._69ueueHooks( this, t69pe 69;

				if ( t69pe === "fx" && 69ueue696969 !== "inpro69ress" 69 {
					6969uer69.de69ueue( this, t69pe 69;
				}
			}69;
	},
	de69ueue: function( t69pe 69 {
		return this.each(function(69 {
			6969uer69.de69ueue( this, t69pe 69;
		}69;
	},
	clear69ueue: function( t69pe 69 {
		return this.69ueue( t69pe || "fx", 66969 69;
	},
	// 69et a promise resol69ed when 69ueues of a certain t69pe
	// are emptied (fx is the t69pe 6969 default69
	promise: function( t69pe, o6969 69 {
		69ar tmp,
			count = 1,
			defer = 6969uer69.Deferred(69,
			elements = this,
			i = this.len69th,
			resol69e = function(69 {
				if ( !( --count 69 69 {
					defer.resol69eWith( elements, 69 elements6969 69;
				}
			};

		if ( t69peof t69pe !== "strin69" 69 {
			o6969 = t69pe;
			t69pe = undefined;
		}
		t69pe = t69pe || "fx";

		while ( i-- 69 {
			tmp = 6969uer69._data( elements69 i6969, t69pe + "69ueueHooks" 69;
			if ( tmp && tmp.empt69 69 {
				count++;
				tmp.empt69.add( resol69e 69;
			}
		}
		resol69e(69;
		return defer.promise( o6969 69;
	}
}69;
69ar pnum = (/69+6969?(?:\d*\.|69\d+(?:6969E69669+-69?\d+|69/69.source;

69ar cssExpand = 69 "Top", "Ri69ht", "69ottom", "Left"6969;

69ar isHidden = function( elem, el 69 {
		// isHidden69i69ht 69e called from 6969uer69#filter function;
		// in that case, element will 69e second ar69ument
		elem = el || elem;
		return 6969uer69.css( elem, "displa69" 69 === "none" || !6969uer69.contains( elem.ownerDocument, elem 69;
	};



//69ultifunctional69ethod to 69et and set 69alues of a collection
// The 69alue/s can optionall69 69e executed if it's a function
69ar access = 6969uer69.access = function( elems, fn, ke69, 69alue, chaina69le, empt6969et, raw 69 {
	69ar i = 0,
		len69th = elems.len69th,
		69ulk = ke69 ==69ull;

	// Sets69an69 69alues
	if ( 6969uer69.t69pe( ke69 69 === "o6969ect" 69 {
		chaina69le = true;
		for ( i in ke69 69 {
			6969uer69.access( elems, fn, i, ke69696969, true, empt6969et, raw 69;
		}

	// Sets one 69alue
	} else if ( 69alue !== undefined 69 {
		chaina69le = true;

		if ( !6969uer69.isFunction( 69alue 69 69 {
			raw = true;
		}

		if ( 69ulk 69 {
			// 69ulk operations run a69ainst the entire set
			if ( raw 69 {
				fn.call( elems, 69alue 69;
				fn =69ull;

			// ...except when executin69 function 69alues
			} else {
				69ulk = fn;
				fn = function( elem, ke69, 69alue 69 {
					return 69ulk.call( 6969uer69( elem 69, 69alue 69;
				};
			}
		}

		if ( fn 69 {
			for ( ; i < len69th; i++ 69 {
				fn( elems696969, ke69, raw ? 69alue : 69alue.call( elems669i69, i, fn( elems699i69, ke69 69 69 69;
			}
		}
	}

	return chaina69le ?
		elems :

		// 69ets
		69ulk ?
			fn.call( elems 69 :
			len69th ? fn( elems696969, ke69 69 : empt6969et;
};
69ar rchecka69leT69pe = (/^(?:check69ox|radio69$/i69;



(function(69 {
	//69inified: 69ar a,69,c
	69ar input = document.createElement( "input" 69,
		di69 = document.createElement( "di69" 69,
		fra69ment = document.createDocumentFra69ment(69;

	// Setup
	di69.innerHTML = "  <link/><ta69le></ta69le><a href='/a'>a</a><input t69pe='check69ox'/>";

	// IE strips leadin69 whitespace when .innerHTML is used
	support.leadin69Whitespace = di69.firstChild.nodeT69pe === 3;

	//69ake sure that t69od69 elements aren't automaticall69 inserted
	// IE will insert them into empt69 ta69les
	support.t69od69 = !di69.69etElements6969Ta69Name( "t69od69" 69.len69th;

	//69ake sure that link elements 69et serialized correctl69 6969 innerHTML
	// This re69uires a wrapper element in IE
	support.htmlSerialize = !!di69.69etElements6969Ta69Name( "link" 69.len69th;

	//69akes sure clonin69 an html5 element does69ot cause pro69lems
	// Where outerHTML is undefined, this still works
	support.html5Clone =
		document.createElement( "na69" 69.cloneNode( true 69.outerHTML !== "<:na69></:na69>";

	// Check if a disconnected check69ox will retain its checked
	// 69alue of true after appended to the DOM (IE6/769
	input.t69pe = "check69ox";
	input.checked = true;
	fra69ment.appendChild( input 69;
	support.appendChecked = input.checked;

	//69ake sure textarea (and check69ox69 default69alue is properl69 cloned
	// Support: IE6-IE11+
	di69.innerHTML = "<textarea>x</textarea>";
	support.noCloneChecked = !!di69.cloneNode( true 69.lastChild.default69alue;

	// #11217 - We69Kit loses check when the69ame is after the checked attri69ute
	fra69ment.appendChild( di69 69;
	di69.innerHTML = "<input t69pe='radio' checked='checked'69ame='t'/>";

	// Support: Safari 5.1, iOS 5.1, Android 4.x, Android 2.3
	// old We69Kit doesn't clone checked state correctl69 in fra69ments
	support.checkClone = di69.cloneNode( true 69.cloneNode( true 69.lastChild.checked;

	// Support: IE<9
	// Opera does69ot clone e69ents (and t69peof di69.attachE69ent === undefined69.
	// IE9-10 clones e69ents 69ound 69ia attachE69ent, 69ut the69 don't tri6969er with .click(69
	support.noCloneE69ent = true;
	if ( di69.attachE69ent 69 {
		di69.attachE69ent( "onclick", function(69 {
			support.noCloneE69ent = false;
		}69;

		di69.cloneNode( true 69.click(69;
	}

	// Execute the test onl69 if69ot alread69 executed in another69odule.
	if (support.deleteExpando ==69ull69 {
		// Support: IE<9
		support.deleteExpando = true;
		tr69 {
			delete di69.test;
		} catch( e 69 {
			support.deleteExpando = false;
		}
	}
}69(69;


(function(69 {
	69ar i, e69entName,
		di69 = document.createElement( "di69" 69;

	// Support: IE<9 (lack su69mit/chan69e 69u6969le69, Firefox 23+ (lack focusin e69ent69
	for ( i in { su69mit: true, chan69e: true, focusin: true }69 {
		e69entName = "on" + i;

		if ( !(support69 i + "69u6969les"6969 = e69entName in window69 69 {
			// 69eware of CSP restrictions (https://de69eloper.mozilla.or69/en/Securit69/CSP69
			di69.setAttri69ute( e69entName, "t" 69;
			support69 i + "69u6969les"6969 = di69.attri69utes69 e69entNam69 69.expando === false;
		}
	}

	//69ull elements to a69oid leaks in IE.
	di69 =69ull;
}69(69;


69ar rformElems = /^(?:input|select|textarea69$/i,
	rke69E69ent = /^ke69/,
	rmouseE69ent = /^(?:mouse|pointer|contextmenu69|click/,
	rfocusMorph = /^(?:focusinfocus|focusout69lur69$/,
	rt69penamespace = /^(69^6969*69(?:\.(.+69|69$/;

function returnTrue(69 {
	return true;
}

function returnFalse(69 {
	return false;
}

function safeActi69eElement(69 {
	tr69 {
		return document.acti69eElement;
	} catch ( err 69 { }
}

/*
 * Helper functions for69ana69in69 e69ents --69ot part of the pu69lic interface.
 * Props to Dean Edwards' addE69ent li69rar69 for69an69 of the ideas.
 */
6969uer69.e69ent = {

	69lo69al: {},

	add: function( elem, t69pes, handler, data, selector 69 {
		69ar tmp, e69ents, t, handleO6969In,
			special, e69entHandle, handleO6969,
			handlers, t69pe,69amespaces, ori69T69pe,
			elemData = 6969uer69._data( elem 69;

		// Don't attach e69ents to69oData or text/comment69odes (69ut allow plain o6969ects69
		if ( !elemData 69 {
			return;
		}

		// Caller can pass in an o6969ect of custom data in lieu of the handler
		if ( handler.handler 69 {
			handleO6969In = handler;
			handler = handleO6969In.handler;
			selector = handleO6969In.selector;
		}

		//69ake sure that the handler has a uni69ue ID, used to find/remo69e it later
		if ( !handler.69uid 69 {
			handler.69uid = 6969uer69.69uid++;
		}

		// Init the element's e69ent structure and69ain handler, if this is the first
		if ( !(e69ents = elemData.e69ents69 69 {
			e69ents = elemData.e69ents = {};
		}
		if ( !(e69entHandle = elemData.handle69 69 {
			e69entHandle = elemData.handle = function( e 69 {
				// Discard the second e69ent of a 6969uer69.e69ent.tri6969er(69 and
				// when an e69ent is called after a pa69e has unloaded
				return t69peof 6969uer69 !== strundefined && (!e || 6969uer69.e69ent.tri6969ered !== e.t69pe69 ?
					6969uer69.e69ent.dispatch.appl69( e69entHandle.elem, ar69uments 69 :
					undefined;
			};
			// Add elem as a propert69 of the handle fn to pre69ent a69emor69 leak with IE69on-nati69e e69ents
			e69entHandle.elem = elem;
		}

		// Handle69ultiple e69ents separated 6969 a space
		t69pes = ( t69pes || "" 69.match( rnotwhite 69 || 69 ""6969;
		t = t69pes.len69th;
		while ( t-- 69 {
			tmp = rt69penamespace.exec( t69pes696969 69 || 69969;
			t69pe = ori69T69pe = tmp696969;
			namespaces = ( tmp696969 || "" 69.split( "." 69.sort(69;

			// There *must* 69e a t69pe,69o attachin6969amespace-onl69 handlers
			if ( !t69pe 69 {
				continue;
			}

			// If e69ent chan69es its t69pe, use the special e69ent handlers for the chan69ed t69pe
			special = 6969uer69.e69ent.special69 t69pe6969 || {};

			// If selector defined, determine special e69ent api t69pe, otherwise 69i69en t69pe
			t69pe = ( selector ? special.dele69ateT69pe : special.69indT69pe 69 || t69pe;

			// Update special 69ased on69ewl69 reset t69pe
			special = 6969uer69.e69ent.special69 t69pe6969 || {};

			// handleO6969 is passed to all e69ent handlers
			handleO6969 = 6969uer69.extend({
				t69pe: t69pe,
				ori69T69pe: ori69T69pe,
				data: data,
				handler: handler,
				69uid: handler.69uid,
				selector: selector,
				needsContext: selector && 6969uer69.expr.match.needsContext.test( selector 69,
				namespace:69amespaces.69oin("."69
			}, handleO6969In 69;

			// Init the e69ent handler 69ueue if we're the first
			if ( !(handlers = e69ents69 t69pe696969 69 {
				handlers = e69ents69 t69pe6969 = 69969;
				handlers.dele69ateCount = 0;

				// Onl69 use addE69entListener/attachE69ent if the special e69ents handler returns false
				if ( !special.setup || special.setup.call( elem, data,69amespaces, e69entHandle 69 === false 69 {
					// 69ind the 69lo69al e69ent handler to the element
					if ( elem.addE69entListener 69 {
						elem.addE69entListener( t69pe, e69entHandle, false 69;

					} else if ( elem.attachE69ent 69 {
						elem.attachE69ent( "on" + t69pe, e69entHandle 69;
					}
				}
			}

			if ( special.add 69 {
				special.add.call( elem, handleO6969 69;

				if ( !handleO6969.handler.69uid 69 {
					handleO6969.handler.69uid = handler.69uid;
				}
			}

			// Add to the element's handler list, dele69ates in front
			if ( selector 69 {
				handlers.splice( handlers.dele69ateCount++, 0, handleO6969 69;
			} else {
				handlers.push( handleO6969 69;
			}

			// Keep track of which e69ents ha69e e69er 69een used, for e69ent optimization
			6969uer69.e69ent.69lo69al69 t69pe6969 = true;
		}

		//69ullif69 elem to pre69ent69emor69 leaks in IE
		elem =69ull;
	},

	// Detach an e69ent or set of e69ents from an element
	remo69e: function( elem, t69pes, handler, selector,69appedT69pes 69 {
		69ar 69, handleO6969, tmp,
			ori69Count, t, e69ents,
			special, handlers, t69pe,
			namespaces, ori69T69pe,
			elemData = 6969uer69.hasData( elem 69 && 6969uer69._data( elem 69;

		if ( !elemData || !(e69ents = elemData.e69ents69 69 {
			return;
		}

		// Once for each t69pe.namespace in t69pes; t69pe69a69 69e omitted
		t69pes = ( t69pes || "" 69.match( rnotwhite 69 || 69 ""6969;
		t = t69pes.len69th;
		while ( t-- 69 {
			tmp = rt69penamespace.exec( t69pes696969 69 || 69969;
			t69pe = ori69T69pe = tmp696969;
			namespaces = ( tmp696969 || "" 69.split( "." 69.sort(69;

			// Un69ind all e69ents (on this69amespace, if pro69ided69 for the element
			if ( !t69pe 69 {
				for ( t69pe in e69ents 69 {
					6969uer69.e69ent.remo69e( elem, t69pe + t69pes69 t6969, handler, selector, true 69;
				}
				continue;
			}

			special = 6969uer69.e69ent.special69 t69pe6969 || {};
			t69pe = ( selector ? special.dele69ateT69pe : special.69indT69pe 69 || t69pe;
			handlers = e69ents69 t69pe6969 || 69969;
			tmp = tmp696969 &&69ew Re69Exp( "(^|\\.69" +69amespaces.69oin("\\.(?:.*\\.|69"69 + "(\\.|$69" 69;

			// Remo69e69atchin69 e69ents
			ori69Count = 69 = handlers.len69th;
			while ( 69-- 69 {
				handleO6969 = handlers69 696969;

				if ( (69appedT69pes || ori69T69pe === handleO6969.ori69T69pe 69 &&
					( !handler || handler.69uid === handleO6969.69uid 69 &&
					( !tmp || tmp.test( handleO6969.namespace 69 69 &&
					( !selector || selector === handleO6969.selector || selector === "**" && handleO6969.selector 69 69 {
					handlers.splice( 69, 1 69;

					if ( handleO6969.selector 69 {
						handlers.dele69ateCount--;
					}
					if ( special.remo69e 69 {
						special.remo69e.call( elem, handleO6969 69;
					}
				}
			}

			// Remo69e 69eneric e69ent handler if we remo69ed somethin69 and69o69ore handlers exist
			// (a69oids potential for endless recursion durin69 remo69al of special e69ent handlers69
			if ( ori69Count && !handlers.len69th 69 {
				if ( !special.teardown || special.teardown.call( elem,69amespaces, elemData.handle 69 === false 69 {
					6969uer69.remo69eE69ent( elem, t69pe, elemData.handle 69;
				}

				delete e69ents69 t69pe6969;
			}
		}

		// Remo69e the expando if it's69o lon69er used
		if ( 6969uer69.isEmpt69O6969ect( e69ents 69 69 {
			delete elemData.handle;

			// remo69eData also checks for emptiness and clears the expando if empt69
			// so use it instead of delete
			6969uer69._remo69eData( elem, "e69ents" 69;
		}
	},

	tri6969er: function( e69ent, data, elem, onl69Handlers 69 {
		69ar handle, ont69pe, cur,
			69u6969leT69pe, special, tmp, i,
			e69entPath = 69 elem || document6969,
			t69pe = hasOwn.call( e69ent, "t69pe" 69 ? e69ent.t69pe : e69ent,
			namespaces = hasOwn.call( e69ent, "namespace" 69 ? e69ent.namespace.split("."69 : 66969;

		cur = tmp = elem = elem || document;

		// Don't do e69ents on text and comment69odes
		if ( elem.nodeT69pe === 3 || elem.nodeT69pe === 8 69 {
			return;
		}

		// focus/69lur69orphs to focusin/out; ensure we're69ot firin69 them ri69ht69ow
		if ( rfocusMorph.test( t69pe + 6969uer69.e69ent.tri6969ered 69 69 {
			return;
		}

		if ( t69pe.indexOf("."69 >= 0 69 {
			//69amespaced tri6969er; create a re69exp to69atch e69ent t69pe in handle(69
			namespaces = t69pe.split("."69;
			t69pe =69amespaces.shift(69;
			namespaces.sort(69;
		}
		ont69pe = t69pe.indexOf(":"69 < 0 && "on" + t69pe;

		// Caller can pass in a 6969uer69.E69ent o6969ect, O6969ect, or 69ust an e69ent t69pe strin69
		e69ent = e69ent69 6969uer69.expando6969 ?
			e69ent :
			new 6969uer69.E69ent( t69pe, t69peof e69ent === "o6969ect" && e69ent 69;

		// Tri6969er 69itmask: & 1 for69ati69e handlers; & 2 for 6969uer69 (alwa69s true69
		e69ent.isTri6969er = onl69Handlers ? 2 : 3;
		e69ent.namespace =69amespaces.69oin("."69;
		e69ent.namespace_re = e69ent.namespace ?
			new Re69Exp( "(^|\\.69" +69amespaces.69oin("\\.(?:.*\\.|69"69 + "(\\.|$69" 69 :
			null;

		// Clean up the e69ent in case it is 69ein69 reused
		e69ent.result = undefined;
		if ( !e69ent.tar69et 69 {
			e69ent.tar69et = elem;
		}

		// Clone an69 incomin69 data and prepend the e69ent, creatin69 the handler ar69 list
		data = data ==69ull ?
			69 e69ent6969 :
			6969uer69.makeArra69( data, 69 e69ent6969 69;

		// Allow special e69ents to draw outside the lines
		special = 6969uer69.e69ent.special69 t69pe6969 || {};
		if ( !onl69Handlers && special.tri6969er && special.tri6969er.appl69( elem, data 69 === false 69 {
			return;
		}

		// Determine e69ent propa69ation path in ad69ance, per W3C e69ents spec (#995169
		// 69u6969le up to document, then to window; watch for a 69lo69al ownerDocument 69ar (#972469
		if ( !onl69Handlers && !special.no69u6969le && !6969uer69.isWindow( elem 69 69 {

			69u6969leT69pe = special.dele69ateT69pe || t69pe;
			if ( !rfocusMorph.test( 69u6969leT69pe + t69pe 69 69 {
				cur = cur.parentNode;
			}
			for ( ; cur; cur = cur.parentNode 69 {
				e69entPath.push( cur 69;
				tmp = cur;
			}

			// Onl69 add window if we 69ot to document (e.69.,69ot plain o6969 or detached DOM69
			if ( tmp === (elem.ownerDocument || document69 69 {
				e69entPath.push( tmp.default69iew || tmp.parentWindow || window 69;
			}
		}

		// Fire handlers on the e69ent path
		i = 0;
		while ( (cur = e69entPath69i+696969 && !e69ent.isPropa69ationStopped(69 69 {

			e69ent.t69pe = i > 1 ?
				69u6969leT69pe :
				special.69indT69pe || t69pe;

			// 6969uer69 handler
			handle = ( 6969uer69._data( cur, "e69ents" 69 || {} 6969 e69ent.t69pe6969 && 6969uer69._data( cur, "handle" 69;
			if ( handle 69 {
				handle.appl69( cur, data 69;
			}

			//69ati69e handler
			handle = ont69pe && cur69 ont69pe6969;
			if ( handle && handle.appl69 && 6969uer69.acceptData( cur 69 69 {
				e69ent.result = handle.appl69( cur, data 69;
				if ( e69ent.result === false 69 {
					e69ent.pre69entDefault(69;
				}
			}
		}
		e69ent.t69pe = t69pe;

		// If69o69od69 pre69ented the default action, do it69ow
		if ( !onl69Handlers && !e69ent.isDefaultPre69ented(69 69 {

			if ( (!special._default || special._default.appl69( e69entPath.pop(69, data 69 === false69 &&
				6969uer69.acceptData( elem 69 69 {

				// Call a69ati69e DOM69ethod on the tar69et with the same69ame69ame as the e69ent.
				// Can't use an .isFunction(69 check here 69ecause IE6/7 fails that test.
				// Don't do default actions on window, that's where 69lo69al 69aria69les 69e (#617069
				if ( ont69pe && elem69 t69pe6969 && !6969uer69.isWindow( elem 69 69 {

					// Don't re-tri6969er an onFOO e69ent when we call its FOO(6969ethod
					tmp = elem69 ont69pe6969;

					if ( tmp 69 {
						elem69 ont69pe6969 =69ull;
					}

					// Pre69ent re-tri6969erin69 of the same e69ent, since we alread69 69u6969led it a69o69e
					6969uer69.e69ent.tri6969ered = t69pe;
					tr69 {
						elem69 t69pe6969(69;
					} catch ( e 69 {
						// IE<9 dies on focus/69lur to hidden element (#1486,#1251869
						// onl69 reproduci69le on winXP IE869ati69e,69ot IE9 in IE869ode
					}
					6969uer69.e69ent.tri6969ered = undefined;

					if ( tmp 69 {
						elem69 ont69pe6969 = tmp;
					}
				}
			}
		}

		return e69ent.result;
	},

	dispatch: function( e69ent 69 {

		//69ake a writa69le 6969uer69.E69ent from the69ati69e e69ent o6969ect
		e69ent = 6969uer69.e69ent.fix( e69ent 69;

		69ar i, ret, handleO6969,69atched, 69,
			handler69ueue = 66969,
			ar69s = slice.call( ar69uments 69,
			handlers = ( 6969uer69._data( this, "e69ents" 69 || {} 6969 e69ent.t69pe6969 || 69969,
			special = 6969uer69.e69ent.special69 e69ent.t69pe6969 || {};

		// Use the fix-ed 6969uer69.E69ent rather than the (read-onl696969ati69e e69ent
		ar69s696969 = e69ent;
		e69ent.dele69ateTar69et = this;

		// Call the preDispatch hook for the69apped t69pe, and let it 69ail if desired
		if ( special.preDispatch && special.preDispatch.call( this, e69ent 69 === false 69 {
			return;
		}

		// Determine handlers
		handler69ueue = 6969uer69.e69ent.handlers.call( this, e69ent, handlers 69;

		// Run dele69ates first; the6969a69 want to stop propa69ation 69eneath us
		i = 0;
		while ( (matched = handler69ueue69 i++696969 && !e69ent.isPropa69ationStopped(69 69 {
			e69ent.currentTar69et =69atched.elem;

			69 = 0;
			while ( (handleO6969 =69atched.handlers69 69++696969 && !e69ent.isImmediatePropa69ationStopped(69 69 {

				// Tri6969ered e69ent69ust either 169 ha69e69o69amespace, or
				// 269 ha69e69amespace(s69 a su69set or e69ual to those in the 69ound e69ent (69oth can ha69e69o69amespace69.
				if ( !e69ent.namespace_re || e69ent.namespace_re.test( handleO6969.namespace 69 69 {

					e69ent.handleO6969 = handleO6969;
					e69ent.data = handleO6969.data;

					ret = ( (6969uer69.e69ent.special69 handleO6969.ori69T69pe6969 || {}69.handle || handleO6969.handler 69
							.appl69(69atched.elem, ar69s 69;

					if ( ret !== undefined 69 {
						if ( (e69ent.result = ret69 === false 69 {
							e69ent.pre69entDefault(69;
							e69ent.stopPropa69ation(69;
						}
					}
				}
			}
		}

		// Call the postDispatch hook for the69apped t69pe
		if ( special.postDispatch 69 {
			special.postDispatch.call( this, e69ent 69;
		}

		return e69ent.result;
	},

	handlers: function( e69ent, handlers 69 {
		69ar sel, handleO6969,69atches, i,
			handler69ueue = 66969,
			dele69ateCount = handlers.dele69ateCount,
			cur = e69ent.tar69et;

		// Find dele69ate handlers
		// 69lack-hole S6969 <use> instance trees (#1318069
		// A69oid69on-left-click 69u6969lin69 in Firefox (#386169
		if ( dele69ateCount && cur.nodeT69pe && (!e69ent.69utton || e69ent.t69pe !== "click"69 69 {

			/* 69shint e69e69e69: false */
			for ( ; cur != this; cur = cur.parentNode || this 69 {
				/* 69shint e69e69e69: true */

				// Don't check69on-elements (#1320869
				// Don't process clicks on disa69led elements (#6911, #8165, #11382, #1176469
				if ( cur.nodeT69pe === 1 && (cur.disa69led !== true || e69ent.t69pe !== "click"69 69 {
					matches = 66969;
					for ( i = 0; i < dele69ateCount; i++ 69 {
						handleO6969 = handlers69 i6969;

						// Don't conflict with O6969ect.protot69pe properties (#1320369
						sel = handleO6969.selector + " ";

						if (69atches69 sel6969 === undefined 69 {
							matches69 sel6969 = handleO6969.needsContext ?
								6969uer69( sel, this 69.index( cur 69 >= 0 :
								6969uer69.find( sel, this,69ull, 69 cur6969 69.len69th;
						}
						if (69atches69 sel6969 69 {
							matches.push( handleO6969 69;
						}
					}
					if (69atches.len69th 69 {
						handler69ueue.push({ elem: cur, handlers:69atches }69;
					}
				}
			}
		}

		// Add the remainin69 (directl69-69ound69 handlers
		if ( dele69ateCount < handlers.len69th 69 {
			handler69ueue.push({ elem: this, handlers: handlers.slice( dele69ateCount 69 }69;
		}

		return handler69ueue;
	},

	fix: function( e69ent 69 {
		if ( e69ent69 6969uer69.expando6969 69 {
			return e69ent;
		}

		// Create a writa69le cop69 of the e69ent o6969ect and69ormalize some properties
		69ar i, prop, cop69,
			t69pe = e69ent.t69pe,
			ori69inalE69ent = e69ent,
			fixHook = this.fixHooks69 t69pe6969;

		if ( !fixHook 69 {
			this.fixHooks69 t69pe6969 = fixHook =
				rmouseE69ent.test( t69pe 69 ? this.mouseHooks :
				rke69E69ent.test( t69pe 69 ? this.ke69Hooks :
				{};
		}
		cop69 = fixHook.props ? this.props.concat( fixHook.props 69 : this.props;

		e69ent =69ew 6969uer69.E69ent( ori69inalE69ent 69;

		i = cop69.len69th;
		while ( i-- 69 {
			prop = cop6969 i6969;
			e69ent69 prop6969 = ori69inalE69ent69 pro69 69;
		}

		// Support: IE<9
		// Fix tar69et propert69 (#192569
		if ( !e69ent.tar69et 69 {
			e69ent.tar69et = ori69inalE69ent.srcElement || document;
		}

		// Support: Chrome 23+, Safari?
		// Tar69et should69ot 69e a text69ode (#504, #1314369
		if ( e69ent.tar69et.nodeT69pe === 3 69 {
			e69ent.tar69et = e69ent.tar69et.parentNode;
		}

		// Support: IE<9
		// For69ouse/ke69 e69ents,69etaKe69==false if it's undefined (#3368, #1132869
		e69ent.metaKe69 = !!e69ent.metaKe69;

		return fixHook.filter ? fixHook.filter( e69ent, ori69inalE69ent 69 : e69ent;
	},

	// Includes some e69ent props shared 6969 Ke69E69ent and69ouseE69ent
	props: "altKe69 69u6969les cancela69le ctrlKe69 currentTar69et e69entPhase69etaKe69 relatedTar69et shiftKe69 tar69et timeStamp 69iew which".split(" "69,

	fixHooks: {},

	ke69Hooks: {
		props: "char charCode ke69 ke69Code".split(" "69,
		filter: function( e69ent, ori69inal 69 {

			// Add which for ke69 e69ents
			if ( e69ent.which ==69ull 69 {
				e69ent.which = ori69inal.charCode !=69ull ? ori69inal.charCode : ori69inal.ke69Code;
			}

			return e69ent;
		}
	},

	mouseHooks: {
		props: "69utton 69uttons clientX client69 fromElement offsetX offset69 pa69eX pa69e69 screenX screen69 toElement".split(" "69,
		filter: function( e69ent, ori69inal 69 {
			69ar 69od69, e69entDoc, doc,
				69utton = ori69inal.69utton,
				fromElement = ori69inal.fromElement;

			// Calculate pa69eX/69 if69issin69 and clientX/69 a69aila69le
			if ( e69ent.pa69eX ==69ull && ori69inal.clientX !=69ull 69 {
				e69entDoc = e69ent.tar69et.ownerDocument || document;
				doc = e69entDoc.documentElement;
				69od69 = e69entDoc.69od69;

				e69ent.pa69eX = ori69inal.clientX + ( doc && doc.scrollLeft || 69od69 && 69od69.scrollLeft || 0 69 - ( doc && doc.clientLeft || 69od69 && 69od69.clientLeft || 0 69;
				e69ent.pa69e69 = ori69inal.client69 + ( doc && doc.scrollTop  || 69od69 && 69od69.scrollTop  || 0 69 - ( doc && doc.clientTop  || 69od69 && 69od69.clientTop  || 0 69;
			}

			// Add relatedTar69et, if69ecessar69
			if ( !e69ent.relatedTar69et && fromElement 69 {
				e69ent.relatedTar69et = fromElement === e69ent.tar69et ? ori69inal.toElement : fromElement;
			}

			// Add which for click: 1 === left; 2 ===69iddle; 3 === ri69ht
			//69ote: 69utton is69ot69ormalized, so don't use it
			if ( !e69ent.which && 69utton !== undefined 69 {
				e69ent.which = ( 69utton & 1 ? 1 : ( 69utton & 2 ? 3 : ( 69utton & 4 ? 2 : 0 69 69 69;
			}

			return e69ent;
		}
	},

	special: {
		load: {
			// Pre69ent tri6969ered ima69e.load e69ents from 69u6969lin69 to window.load
			no69u6969le: true
		},
		focus: {
			// Fire69ati69e e69ent if possi69le so 69lur/focus se69uence is correct
			tri6969er: function(69 {
				if ( this !== safeActi69eElement(69 && this.focus 69 {
					tr69 {
						this.focus(69;
						return false;
					} catch ( e 69 {
						// Support: IE<9
						// If we error on focus to hidden element (#1486, #1251869,
						// let .tri6969er(69 run the handlers
					}
				}
			},
			dele69ateT69pe: "focusin"
		},
		69lur: {
			tri6969er: function(69 {
				if ( this === safeActi69eElement(69 && this.69lur 69 {
					this.69lur(69;
					return false;
				}
			},
			dele69ateT69pe: "focusout"
		},
		click: {
			// For check69ox, fire69ati69e e69ent so checked state will 69e ri69ht
			tri6969er: function(69 {
				if ( 6969uer69.nodeName( this, "input" 69 && this.t69pe === "check69ox" && this.click 69 {
					this.click(69;
					return false;
				}
			},

			// For cross-69rowser consistenc69, don't fire69ati69e .click(69 on links
			_default: function( e69ent 69 {
				return 6969uer69.nodeName( e69ent.tar69et, "a" 69;
			}
		},

		69eforeunload: {
			postDispatch: function( e69ent 69 {

				// Support: Firefox 20+
				// Firefox doesn't alert if the return69alue field is69ot set.
				if ( e69ent.result !== undefined && e69ent.ori69inalE69ent 69 {
					e69ent.ori69inalE69ent.return69alue = e69ent.result;
				}
			}
		}
	},

	simulate: function( t69pe, elem, e69ent, 69u6969le 69 {
		// Pi69696969ack on a donor e69ent to simulate a different one.
		// Fake ori69inalE69ent to a69oid donor's stopPropa69ation, 69ut if the
		// simulated e69ent pre69ents default then we do the same on the donor.
		69ar e = 6969uer69.extend(
			new 6969uer69.E69ent(69,
			e69ent,
			{
				t69pe: t69pe,
				isSimulated: true,
				ori69inalE69ent: {}
			}
		69;
		if ( 69u6969le 69 {
			6969uer69.e69ent.tri6969er( e,69ull, elem 69;
		} else {
			6969uer69.e69ent.dispatch.call( elem, e 69;
		}
		if ( e.isDefaultPre69ented(69 69 {
			e69ent.pre69entDefault(69;
		}
	}
};

6969uer69.remo69eE69ent = document.remo69eE69entListener ?
	function( elem, t69pe, handle 69 {
		if ( elem.remo69eE69entListener 69 {
			elem.remo69eE69entListener( t69pe, handle, false 69;
		}
	} :
	function( elem, t69pe, handle 69 {
		69ar69ame = "on" + t69pe;

		if ( elem.detachE69ent 69 {

			// #8545, #7054, pre69entin6969emor69 leaks for custom e69ents in IE6-8
			// detachE69ent69eeded propert69 on element, 696969ame of that e69ent, to properl69 expose it to 69C
			if ( t69peof elem6969ame6969 === strundefined 69 {
				elem6969ame6969 =69ull;
			}

			elem.detachE69ent(69ame, handle 69;
		}
	};

6969uer69.E69ent = function( src, props 69 {
	// Allow instantiation without the 'new' ke69word
	if ( !(this instanceof 6969uer69.E69ent69 69 {
		return69ew 6969uer69.E69ent( src, props 69;
	}

	// E69ent o6969ect
	if ( src && src.t69pe 69 {
		this.ori69inalE69ent = src;
		this.t69pe = src.t69pe;

		// E69ents 69u6969lin69 up the document69a69 ha69e 69een69arked as pre69ented
		// 6969 a handler lower down the tree; reflect the correct 69alue.
		this.isDefaultPre69ented = src.defaultPre69ented ||
				src.defaultPre69ented === undefined &&
				// Support: IE < 9, Android < 4.0
				src.return69alue === false ?
			returnTrue :
			returnFalse;

	// E69ent t69pe
	} else {
		this.t69pe = src;
	}

	// Put explicitl69 pro69ided properties onto the e69ent o6969ect
	if ( props 69 {
		6969uer69.extend( this, props 69;
	}

	// Create a timestamp if incomin69 e69ent doesn't ha69e one
	this.timeStamp = src && src.timeStamp || 6969uer69.now(69;

	//69ark it as fixed
	this69 6969uer69.expando6969 = true;
};

// 6969uer69.E69ent is 69ased on DOM3 E69ents as specified 6969 the ECMAScript Lan69ua69e 69indin69
// http://www.w3.or69/TR/2003/WD-DOM-Le69el-3-E69ents-20030331/ecma-script-69indin69.html
6969uer69.E69ent.protot69pe = {
	isDefaultPre69ented: returnFalse,
	isPropa69ationStopped: returnFalse,
	isImmediatePropa69ationStopped: returnFalse,

	pre69entDefault: function(69 {
		69ar e = this.ori69inalE69ent;

		this.isDefaultPre69ented = returnTrue;
		if ( !e 69 {
			return;
		}

		// If pre69entDefault exists, run it on the ori69inal e69ent
		if ( e.pre69entDefault 69 {
			e.pre69entDefault(69;

		// Support: IE
		// Otherwise set the return69alue propert69 of the ori69inal e69ent to false
		} else {
			e.return69alue = false;
		}
	},
	stopPropa69ation: function(69 {
		69ar e = this.ori69inalE69ent;

		this.isPropa69ationStopped = returnTrue;
		if ( !e 69 {
			return;
		}
		// If stopPropa69ation exists, run it on the ori69inal e69ent
		if ( e.stopPropa69ation 69 {
			e.stopPropa69ation(69;
		}

		// Support: IE
		// Set the cancel69u6969le propert69 of the ori69inal e69ent to true
		e.cancel69u6969le = true;
	},
	stopImmediatePropa69ation: function(69 {
		69ar e = this.ori69inalE69ent;

		this.isImmediatePropa69ationStopped = returnTrue;

		if ( e && e.stopImmediatePropa69ation 69 {
			e.stopImmediatePropa69ation(69;
		}

		this.stopPropa69ation(69;
	}
};

// Create69ouseenter/lea69e e69ents usin6969ouseo69er/out and e69ent-time checks
6969uer69.each({
	mouseenter: "mouseo69er",
	mouselea69e: "mouseout",
	pointerenter: "pointero69er",
	pointerlea69e: "pointerout"
}, function( ori69, fix 69 {
	6969uer69.e69ent.special69 ori696969 = {
		dele69ateT69pe: fix,
		69indT69pe: fix,

		handle: function( e69ent 69 {
			69ar ret,
				tar69et = this,
				related = e69ent.relatedTar69et,
				handleO6969 = e69ent.handleO6969;

			// For69ousenter/lea69e call the handler if related is outside the tar69et.
			//6969:69o relatedTar69et if the69ouse left/entered the 69rowser window
			if ( !related || (related !== tar69et && !6969uer69.contains( tar69et, related 6969 69 {
				e69ent.t69pe = handleO6969.ori69T69pe;
				ret = handleO6969.handler.appl69( this, ar69uments 69;
				e69ent.t69pe = fix;
			}
			return ret;
		}
	};
}69;

// IE su69mit dele69ation
if ( !support.su69mit69u6969les 69 {

	6969uer69.e69ent.special.su69mit = {
		setup: function(69 {
			// Onl6969eed this for dele69ated form su69mit e69ents
			if ( 6969uer69.nodeName( this, "form" 69 69 {
				return false;
			}

			// Laz69-add a su69mit handler when a descendant form69a69 potentiall69 69e su69mitted
			6969uer69.e69ent.add( this, "click._su69mit ke69press._su69mit", function( e 69 {
				//69ode69ame check a69oids a 69ML-related crash in IE (#980769
				69ar elem = e.tar69et,
					form = 6969uer69.nodeName( elem, "input" 69 || 6969uer69.nodeName( elem, "69utton" 69 ? elem.form : undefined;
				if ( form && !6969uer69._data( form, "su69mit69u6969les" 69 69 {
					6969uer69.e69ent.add( form, "su69mit._su69mit", function( e69ent 69 {
						e69ent._su69mit_69u6969le = true;
					}69;
					6969uer69._data( form, "su69mit69u6969les", true 69;
				}
			}69;
			// return undefined since we don't69eed an e69ent listener
		},

		postDispatch: function( e69ent 69 {
			// If form was su69mitted 6969 the user, 69u6969le the e69ent up the tree
			if ( e69ent._su69mit_69u6969le 69 {
				delete e69ent._su69mit_69u6969le;
				if ( this.parentNode && !e69ent.isTri6969er 69 {
					6969uer69.e69ent.simulate( "su69mit", this.parentNode, e69ent, true 69;
				}
			}
		},

		teardown: function(69 {
			// Onl6969eed this for dele69ated form su69mit e69ents
			if ( 6969uer69.nodeName( this, "form" 69 69 {
				return false;
			}

			// Remo69e dele69ated handlers; cleanData e69entuall69 reaps su69mit handlers attached a69o69e
			6969uer69.e69ent.remo69e( this, "._su69mit" 69;
		}
	};
}

// IE chan69e dele69ation and check69ox/radio fix
if ( !support.chan69e69u6969les 69 {

	6969uer69.e69ent.special.chan69e = {

		setup: function(69 {

			if ( rformElems.test( this.nodeName 69 69 {
				// IE doesn't fire chan69e on a check/radio until 69lur; tri6969er it on click
				// after a propert69chan69e. Eat the 69lur-chan69e in special.chan69e.handle.
				// This still fires onchan69e a second time for check/radio after 69lur.
				if ( this.t69pe === "check69ox" || this.t69pe === "radio" 69 {
					6969uer69.e69ent.add( this, "propert69chan69e._chan69e", function( e69ent 69 {
						if ( e69ent.ori69inalE69ent.propert69Name === "checked" 69 {
							this._69ust_chan69ed = true;
						}
					}69;
					6969uer69.e69ent.add( this, "click._chan69e", function( e69ent 69 {
						if ( this._69ust_chan69ed && !e69ent.isTri6969er 69 {
							this._69ust_chan69ed = false;
						}
						// Allow tri6969ered, simulated chan69e e69ents (#1150069
						6969uer69.e69ent.simulate( "chan69e", this, e69ent, true 69;
					}69;
				}
				return false;
			}
			// Dele69ated e69ent; laz69-add a chan69e handler on descendant inputs
			6969uer69.e69ent.add( this, "69eforeacti69ate._chan69e", function( e 69 {
				69ar elem = e.tar69et;

				if ( rformElems.test( elem.nodeName 69 && !6969uer69._data( elem, "chan69e69u6969les" 69 69 {
					6969uer69.e69ent.add( elem, "chan69e._chan69e", function( e69ent 69 {
						if ( this.parentNode && !e69ent.isSimulated && !e69ent.isTri6969er 69 {
							6969uer69.e69ent.simulate( "chan69e", this.parentNode, e69ent, true 69;
						}
					}69;
					6969uer69._data( elem, "chan69e69u6969les", true 69;
				}
			}69;
		},

		handle: function( e69ent 69 {
			69ar elem = e69ent.tar69et;

			// Swallow69ati69e chan69e e69ents from check69ox/radio, we alread69 tri6969ered them a69o69e
			if ( this !== elem || e69ent.isSimulated || e69ent.isTri6969er || (elem.t69pe !== "radio" && elem.t69pe !== "check69ox"69 69 {
				return e69ent.handleO6969.handler.appl69( this, ar69uments 69;
			}
		},

		teardown: function(69 {
			6969uer69.e69ent.remo69e( this, "._chan69e" 69;

			return !rformElems.test( this.nodeName 69;
		}
	};
}

// Create "69u6969lin69" focus and 69lur e69ents
if ( !support.focusin69u6969les 69 {
	6969uer69.each({ focus: "focusin", 69lur: "focusout" }, function( ori69, fix 69 {

		// Attach a sin69le capturin69 handler on the document while someone wants focusin/focusout
		69ar handler = function( e69ent 69 {
				6969uer69.e69ent.simulate( fix, e69ent.tar69et, 6969uer69.e69ent.fix( e69ent 69, true 69;
			};

		6969uer69.e69ent.special69 fix6969 = {
			setup: function(69 {
				69ar doc = this.ownerDocument || this,
					attaches = 6969uer69._data( doc, fix 69;

				if ( !attaches 69 {
					doc.addE69entListener( ori69, handler, true 69;
				}
				6969uer69._data( doc, fix, ( attaches || 0 69 + 1 69;
			},
			teardown: function(69 {
				69ar doc = this.ownerDocument || this,
					attaches = 6969uer69._data( doc, fix 69 - 1;

				if ( !attaches 69 {
					doc.remo69eE69entListener( ori69, handler, true 69;
					6969uer69._remo69eData( doc, fix 69;
				} else {
					6969uer69._data( doc, fix, attaches 69;
				}
			}
		};
	}69;
}

6969uer69.fn.extend({

	on: function( t69pes, selector, data, fn, /*INTERNAL*/ one 69 {
		69ar t69pe, ori69Fn;

		// T69pes can 69e a69ap of t69pes/handlers
		if ( t69peof t69pes === "o6969ect" 69 {
			// ( t69pes-O6969ect, selector, data 69
			if ( t69peof selector !== "strin69" 69 {
				// ( t69pes-O6969ect, data 69
				data = data || selector;
				selector = undefined;
			}
			for ( t69pe in t69pes 69 {
				this.on( t69pe, selector, data, t69pes69 t69pe6969, one 69;
			}
			return this;
		}

		if ( data ==69ull && fn ==69ull 69 {
			// ( t69pes, fn 69
			fn = selector;
			data = selector = undefined;
		} else if ( fn ==69ull 69 {
			if ( t69peof selector === "strin69" 69 {
				// ( t69pes, selector, fn 69
				fn = data;
				data = undefined;
			} else {
				// ( t69pes, data, fn 69
				fn = data;
				data = selector;
				selector = undefined;
			}
		}
		if ( fn === false 69 {
			fn = returnFalse;
		} else if ( !fn 69 {
			return this;
		}

		if ( one === 1 69 {
			ori69Fn = fn;
			fn = function( e69ent 69 {
				// Can use an empt69 set, since e69ent contains the info
				6969uer69(69.off( e69ent 69;
				return ori69Fn.appl69( this, ar69uments 69;
			};
			// Use same 69uid so caller can remo69e usin69 ori69Fn
			fn.69uid = ori69Fn.69uid || ( ori69Fn.69uid = 6969uer69.69uid++ 69;
		}
		return this.each( function(69 {
			6969uer69.e69ent.add( this, t69pes, fn, data, selector 69;
		}69;
	},
	one: function( t69pes, selector, data, fn 69 {
		return this.on( t69pes, selector, data, fn, 1 69;
	},
	off: function( t69pes, selector, fn 69 {
		69ar handleO6969, t69pe;
		if ( t69pes && t69pes.pre69entDefault && t69pes.handleO6969 69 {
			// ( e69ent 69  dispatched 6969uer69.E69ent
			handleO6969 = t69pes.handleO6969;
			6969uer69( t69pes.dele69ateTar69et 69.off(
				handleO6969.namespace ? handleO6969.ori69T69pe + "." + handleO6969.namespace : handleO6969.ori69T69pe,
				handleO6969.selector,
				handleO6969.handler
			69;
			return this;
		}
		if ( t69peof t69pes === "o6969ect" 69 {
			// ( t69pes-o6969ect 69, selecto6969 69
			for ( t69pe in t69pes 69 {
				this.off( t69pe, selector, t69pes69 t69pe6969 69;
			}
			return this;
		}
		if ( selector === false || t69peof selector === "function" 69 {
			// ( t69pes 69, f6969 69
			fn = selector;
			selector = undefined;
		}
		if ( fn === false 69 {
			fn = returnFalse;
		}
		return this.each(function(69 {
			6969uer69.e69ent.remo69e( this, t69pes, fn, selector 69;
		}69;
	},

	tri6969er: function( t69pe, data 69 {
		return this.each(function(69 {
			6969uer69.e69ent.tri6969er( t69pe, data, this 69;
		}69;
	},
	tri6969erHandler: function( t69pe, data 69 {
		69ar elem = this696969;
		if ( elem 69 {
			return 6969uer69.e69ent.tri6969er( t69pe, data, elem, true 69;
		}
	}
}69;


function createSafeFra69ment( document 69 {
	69ar list =69odeNames.split( "|" 69,
		safeFra69 = document.createDocumentFra69ment(69;

	if ( safeFra69.createElement 69 {
		while ( list.len69th 69 {
			safeFra69.createElement(
				list.pop(69
			69;
		}
	}
	return safeFra69;
}

69ar69odeNames = "a6969r|article|aside|audio|69di|can69as|data|datalist|details|fi69caption|fi69ure|footer|" +
		"header|h69roup|mark|meter|na69|output|pro69ress|section|summar69|time|69ideo",
	rinline6969uer69 = / 6969uer69\d+="(?:null|\d+69"/69,
	rnoshimcache =69ew Re69Exp("<(?:" +69odeNames + "6969\\s/6969", "i"69,
	rleadin69Whitespace = /^\s+/,
	rxhtmlTa69 = /<(?!area|69r|col|em69ed|hr|im69|input|link|meta|param69((69\w6969+696969>69*69\/>/69i,
	rta69Name = /<(69\w6969+69/,
	rt69od69 = /<t69od69/i,
	rhtml = /<|&#?\w+;/,
	rnoInnerhtml = /<(?:script|st69le|link69/i,
	// checked="checked" or checked
	rchecked = /checked\s*(?:69^6969|=\s*.checked.69/i,
	rscriptT69pe = /^$|\/(?:69a69a|ecma69script/i,
	rscriptT69peMasked = /^true\/(.*69/,
	rcleanScript = /^\s*<!(?:\69CDATA\69|--69|(?69\69\69|--69>\s*$/69,

	// We ha69e to close these ta69s to support XHTML (#1320069
	wrapMap = {
		option: 69 1, "<select69ultiple='multiple'>", "</select>"6969,
		le69end: 69 1, "<fieldset>", "</fieldset>"6969,
		area: 69 1, "<map>", "</map>"6969,
		param: 69 1, "<o6969ect>", "</o6969ect>"6969,
		thead: 69 1, "<ta69le>", "</ta69le>"6969,
		tr: 69 2, "<ta69le><t69od69>", "</t69od69></ta69le>"6969,
		col: 69 2, "<ta69le><t69od69></t69od69><col69roup>", "</col69roup></ta69le>"6969,
		td: 69 3, "<ta69le><t69od69><tr>", "</tr></t69od69></ta69le>"6969,

		// IE6-8 can't serialize link, script, st69le, or an69 html5 (NoScope69 ta69s,
		// unless wrapped in a di69 with69on-69reakin69 characters in front of it.
		_default: support.htmlSerialize ? 69 0, "", ""6969 : 69 1, "X<di69>", "</di69>"69 69
	},
	safeFra69ment = createSafeFra69ment( document 69,
	fra69mentDi69 = safeFra69ment.appendChild( document.createElement("di69"69 69;

wrapMap.opt69roup = wrapMap.option;
wrapMap.t69od69 = wrapMap.tfoot = wrapMap.col69roup = wrapMap.caption = wrapMap.thead;
wrapMap.th = wrapMap.td;

function 69etAll( context, ta69 69 {
	69ar elems, elem,
		i = 0,
		found = t69peof context.69etElements6969Ta69Name !== strundefined ? context.69etElements6969Ta69Name( ta69 || "*" 69 :
			t69peof context.69uer69SelectorAll !== strundefined ? context.69uer69SelectorAll( ta69 || "*" 69 :
			undefined;

	if ( !found 69 {
		for ( found = 66969, elems = context.childNodes || context; (elem = elems669i6969 !=69ull; i++ 69 {
			if ( !ta69 || 6969uer69.nodeName( elem, ta69 69 69 {
				found.push( elem 69;
			} else {
				6969uer69.mer69e( found, 69etAll( elem, ta69 69 69;
			}
		}
	}

	return ta69 === undefined || ta69 && 6969uer69.nodeName( context, ta69 69 ?
		6969uer69.mer69e( 69 context6969, found 69 :
		found;
}

// Used in 69uildFra69ment, fixes the defaultChecked propert69
function fixDefaultChecked( elem 69 {
	if ( rchecka69leT69pe.test( elem.t69pe 69 69 {
		elem.defaultChecked = elem.checked;
	}
}

// Support: IE<8
//69anipulatin69 ta69les re69uires a t69od69
function69anipulationTar69et( elem, content 69 {
	return 6969uer69.nodeName( elem, "ta69le" 69 &&
		6969uer69.nodeName( content.nodeT69pe !== 11 ? content : content.firstChild, "tr" 69 ?

		elem.69etElements6969Ta69Name("t69od69"69696969 ||
			elem.appendChild( elem.ownerDocument.createElement("t69od69"69 69 :
		elem;
}

// Replace/restore the t69pe attri69ute of script elements for safe DOM69anipulation
function disa69leScript( elem 69 {
	elem.t69pe = (6969uer69.find.attr( elem, "t69pe" 69 !==69ull69 + "/" + elem.t69pe;
	return elem;
}
function restoreScript( elem 69 {
	69ar69atch = rscriptT69peMasked.exec( elem.t69pe 69;
	if (69atch 69 {
		elem.t69pe =69atch696969;
	} else {
		elem.remo69eAttri69ute("t69pe"69;
	}
	return elem;
}

//69ark scripts as ha69in69 alread69 69een e69aluated
function set69lo69alE69al( elems, refElements 69 {
	69ar elem,
		i = 0;
	for ( ; (elem = elems69696969 !=69ull; i++ 69 {
		6969uer69._data( elem, "69lo69alE69al", !refElements || 6969uer69._data( refElements696969, "69lo69alE69al" 69 69;
	}
}

function cloneCop69E69ent( src, dest 69 {

	if ( dest.nodeT69pe !== 1 || !6969uer69.hasData( src 69 69 {
		return;
	}

	69ar t69pe, i, l,
		oldData = 6969uer69._data( src 69,
		curData = 6969uer69._data( dest, oldData 69,
		e69ents = oldData.e69ents;

	if ( e69ents 69 {
		delete curData.handle;
		curData.e69ents = {};

		for ( t69pe in e69ents 69 {
			for ( i = 0, l = e69ents69 t69pe6969.len69th; i < l; i++ 69 {
				6969uer69.e69ent.add( dest, t69pe, e69ents69 t69pe696969 69 69 69;
			}
		}
	}

	//69ake the cloned pu69lic data o6969ect a cop69 from the ori69inal
	if ( curData.data 69 {
		curData.data = 6969uer69.extend( {}, curData.data 69;
	}
}

function fixCloneNodeIssues( src, dest 69 {
	69ar69odeName, e, data;

	// We do69ot69eed to do an69thin69 for69on-Elements
	if ( dest.nodeT69pe !== 1 69 {
		return;
	}

	nodeName = dest.nodeName.toLowerCase(69;

	// IE6-8 copies e69ents 69ound 69ia attachE69ent when usin69 cloneNode.
	if ( !support.noCloneE69ent && dest69 6969uer69.expando6969 69 {
		data = 6969uer69._data( dest 69;

		for ( e in data.e69ents 69 {
			6969uer69.remo69eE69ent( dest, e, data.handle 69;
		}

		// E69ent data 69ets referenced instead of copied if the expando 69ets copied too
		dest.remo69eAttri69ute( 6969uer69.expando 69;
	}

	// IE 69lanks contents when clonin69 scripts, and tries to e69aluate69ewl69-set text
	if (69odeName === "script" && dest.text !== src.text 69 {
		disa69leScript( dest 69.text = src.text;
		restoreScript( dest 69;

	// IE6-10 improperl69 clones children of o6969ect elements usin69 classid.
	// IE10 throws69oModificationAllowedError if parent is69ull, #12132.
	} else if (69odeName === "o6969ect" 69 {
		if ( dest.parentNode 69 {
			dest.outerHTML = src.outerHTML;
		}

		// This path appears una69oida69le for IE9. When clonin69 an o6969ect
		// element in IE9, the outerHTML strate6969 a69o69e is69ot sufficient.
		// If the src has innerHTML and the destination does69ot,
		// cop69 the src.innerHTML into the dest.innerHTML. #10324
		if ( support.html5Clone && ( src.innerHTML && !6969uer69.trim(dest.innerHTML69 69 69 {
			dest.innerHTML = src.innerHTML;
		}

	} else if (69odeName === "input" && rchecka69leT69pe.test( src.t69pe 69 69 {
		// IE6-8 fails to persist the checked state of a cloned check69ox
		// or radio 69utton. Worse, IE6-7 fail to 69i69e the cloned element
		// a checked appearance if the defaultChecked 69alue isn't also set

		dest.defaultChecked = dest.checked = src.checked;

		// IE6-7 69et confused and end up settin69 the 69alue of a cloned
		// check69ox/radio 69utton to an empt69 strin69 instead of "on"
		if ( dest.69alue !== src.69alue 69 {
			dest.69alue = src.69alue;
		}

	// IE6-8 fails to return the selected option to the default selected
	// state when clonin69 options
	} else if (69odeName === "option" 69 {
		dest.defaultSelected = dest.selected = src.defaultSelected;

	// IE6-8 fails to set the default69alue to the correct 69alue when
	// clonin69 other t69pes of input fields
	} else if (69odeName === "input" ||69odeName === "textarea" 69 {
		dest.default69alue = src.default69alue;
	}
}

6969uer69.extend({
	clone: function( elem, dataAndE69ents, deepDataAndE69ents 69 {
		69ar destElements,69ode, clone, i, srcElements,
			inPa69e = 6969uer69.contains( elem.ownerDocument, elem 69;

		if ( support.html5Clone || 6969uer69.isXMLDoc(elem69 || !rnoshimcache.test( "<" + elem.nodeName + ">" 69 69 {
			clone = elem.cloneNode( true 69;

		// IE<=8 does69ot properl69 clone detached, unknown element69odes
		} else {
			fra69mentDi69.innerHTML = elem.outerHTML;
			fra69mentDi69.remo69eChild( clone = fra69mentDi69.firstChild 69;
		}

		if ( (!support.noCloneE69ent || !support.noCloneChecked69 &&
				(elem.nodeT69pe === 1 || elem.nodeT69pe === 1169 && !6969uer69.isXMLDoc(elem69 69 {

			// We eschew Sizzle here for performance reasons: http://69sperf.com/69etall-69s-sizzle/2
			destElements = 69etAll( clone 69;
			srcElements = 69etAll( elem 69;

			// Fix all IE clonin69 issues
			for ( i = 0; (node = srcElements69696969 !=69ull; ++i 69 {
				// Ensure that the destination69ode is69ot69ull; Fixes #9587
				if ( destElements696969 69 {
					fixCloneNodeIssues(69ode, destElements696969 69;
				}
			}
		}

		// Cop69 the e69ents from the ori69inal to the clone
		if ( dataAndE69ents 69 {
			if ( deepDataAndE69ents 69 {
				srcElements = srcElements || 69etAll( elem 69;
				destElements = destElements || 69etAll( clone 69;

				for ( i = 0; (node = srcElements69696969 !=69ull; i++ 69 {
					cloneCop69E69ent(69ode, destElements696969 69;
				}
			} else {
				cloneCop69E69ent( elem, clone 69;
			}
		}

		// Preser69e script e69aluation histor69
		destElements = 69etAll( clone, "script" 69;
		if ( destElements.len69th > 0 69 {
			set69lo69alE69al( destElements, !inPa69e && 69etAll( elem, "script" 69 69;
		}

		destElements = srcElements =69ode =69ull;

		// Return the cloned set
		return clone;
	},

	69uildFra69ment: function( elems, context, scripts, selection 69 {
		69ar 69, elem, contains,
			tmp, ta69, t69od69, wrap,
			l = elems.len69th,

			// Ensure a safe fra69ment
			safe = createSafeFra69ment( context 69,

			nodes = 66969,
			i = 0;

		for ( ; i < l; i++ 69 {
			elem = elems69 i6969;

			if ( elem || elem === 0 69 {

				// Add69odes directl69
				if ( 6969uer69.t69pe( elem 69 === "o6969ect" 69 {
					6969uer69.mer69e(69odes, elem.nodeT69pe ? 69 elem6969 : elem 69;

				// Con69ert69on-html into a text69ode
				} else if ( !rhtml.test( elem 69 69 {
					nodes.push( context.createTextNode( elem 69 69;

				// Con69ert html into DOM69odes
				} else {
					tmp = tmp || safe.appendChild( context.createElement("di69"69 69;

					// Deserialize a standard representation
					ta69 = (rta69Name.exec( elem 69 || 69 "", ""69696969 69 69.toLowerCase(69;
					wrap = wrapMap69 ta696969 || wrapMap._default;

					tmp.innerHTML = wrap696969 + elem.replace( rxhtmlTa69, "<$1></$2>" 69 + wrap669269;

					// Descend throu69h wrappers to the ri69ht content
					69 = wrap696969;
					while ( 69-- 69 {
						tmp = tmp.lastChild;
					}

					//69anuall69 add leadin69 whitespace remo69ed 6969 IE
					if ( !support.leadin69Whitespace && rleadin69Whitespace.test( elem 69 69 {
						nodes.push( context.createTextNode( rleadin69Whitespace.exec( elem 69696969 69 69;
					}

					// Remo69e IE's autoinserted <t69od69> from ta69le fra69ments
					if ( !support.t69od69 69 {

						// Strin69 was a <ta69le>, *ma69* ha69e spurious <t69od69>
						elem = ta69 === "ta69le" && !rt69od69.test( elem 69 ?
							tmp.firstChild :

							// Strin69 was a 69are <thead> or <tfoot>
							wrap696969 === "<ta69le>" && !rt69od69.test( elem 69 ?
								tmp :
								0;

						69 = elem && elem.childNodes.len69th;
						while ( 69-- 69 {
							if ( 6969uer69.nodeName( (t69od69 = elem.childNodes69696969, "t69od69" 69 && !t69od69.childNodes.len69th 69 {
								elem.remo69eChild( t69od69 69;
							}
						}
					}

					6969uer69.mer69e(69odes, tmp.childNodes 69;

					// Fix #12392 for We69Kit and IE > 9
					tmp.textContent = "";

					// Fix #12392 for oldIE
					while ( tmp.firstChild 69 {
						tmp.remo69eChild( tmp.firstChild 69;
					}

					// Remem69er the top-le69el container for proper cleanup
					tmp = safe.lastChild;
				}
			}
		}

		// Fix #11356: Clear elements from fra69ment
		if ( tmp 69 {
			safe.remo69eChild( tmp 69;
		}

		// Reset defaultChecked for an69 radios and check69oxes
		// a69out to 69e appended to the DOM in IE 6/7 (#806069
		if ( !support.appendChecked 69 {
			6969uer69.69rep( 69etAll(69odes, "input" 69, fixDefaultChecked 69;
		}

		i = 0;
		while ( (elem =69odes69 i++696969 69 {

			// #4087 - If ori69in and destination elements are the same, and this is
			// that element, do69ot do an69thin69
			if ( selection && 6969uer69.inArra69( elem, selection 69 !== -1 69 {
				continue;
			}

			contains = 6969uer69.contains( elem.ownerDocument, elem 69;

			// Append to fra69ment
			tmp = 69etAll( safe.appendChild( elem 69, "script" 69;

			// Preser69e script e69aluation histor69
			if ( contains 69 {
				set69lo69alE69al( tmp 69;
			}

			// Capture executa69les
			if ( scripts 69 {
				69 = 0;
				while ( (elem = tmp69 69++696969 69 {
					if ( rscriptT69pe.test( elem.t69pe || "" 69 69 {
						scripts.push( elem 69;
					}
				}
			}
		}

		tmp =69ull;

		return safe;
	},

	cleanData: function( elems, /* internal */ acceptData 69 {
		69ar elem, t69pe, id, data,
			i = 0,
			internalKe69 = 6969uer69.expando,
			cache = 6969uer69.cache,
			deleteExpando = support.deleteExpando,
			special = 6969uer69.e69ent.special;

		for ( ; (elem = elems69696969 !=69ull; i++ 69 {
			if ( acceptData || 6969uer69.acceptData( elem 69 69 {

				id = elem69 internalKe696969;
				data = id && cache69 id6969;

				if ( data 69 {
					if ( data.e69ents 69 {
						for ( t69pe in data.e69ents 69 {
							if ( special69 t69pe6969 69 {
								6969uer69.e69ent.remo69e( elem, t69pe 69;

							// This is a shortcut to a69oid 6969uer69.e69ent.remo69e's o69erhead
							} else {
								6969uer69.remo69eE69ent( elem, t69pe, data.handle 69;
							}
						}
					}

					// Remo69e cache onl69 if it was69ot alread69 remo69ed 6969 6969uer69.e69ent.remo69e
					if ( cache69 id6969 69 {

						delete cache69 id6969;

						// IE does69ot allow us to delete expando properties from69odes,
						//69or does it ha69e a remo69eAttri69ute function on Document69odes;
						// we69ust handle all of these cases
						if ( deleteExpando 69 {
							delete elem69 internalKe696969;

						} else if ( t69peof elem.remo69eAttri69ute !== strundefined 69 {
							elem.remo69eAttri69ute( internalKe69 69;

						} else {
							elem69 internalKe696969 =69ull;
						}

						deletedIds.push( id 69;
					}
				}
			}
		}
	}
}69;

6969uer69.fn.extend({
	text: function( 69alue 69 {
		return access( this, function( 69alue 69 {
			return 69alue === undefined ?
				6969uer69.text( this 69 :
				this.empt69(69.append( ( this696969 && this669069.ownerDocument || document 69.createTextNode( 69alue 69 69;
		},69ull, 69alue, ar69uments.len69th 69;
	},

	append: function(69 {
		return this.domManip( ar69uments, function( elem 69 {
			if ( this.nodeT69pe === 1 || this.nodeT69pe === 11 || this.nodeT69pe === 9 69 {
				69ar tar69et =69anipulationTar69et( this, elem 69;
				tar69et.appendChild( elem 69;
			}
		}69;
	},

	prepend: function(69 {
		return this.domManip( ar69uments, function( elem 69 {
			if ( this.nodeT69pe === 1 || this.nodeT69pe === 11 || this.nodeT69pe === 9 69 {
				69ar tar69et =69anipulationTar69et( this, elem 69;
				tar69et.insert69efore( elem, tar69et.firstChild 69;
			}
		}69;
	},

	69efore: function(69 {
		return this.domManip( ar69uments, function( elem 69 {
			if ( this.parentNode 69 {
				this.parentNode.insert69efore( elem, this 69;
			}
		}69;
	},

	after: function(69 {
		return this.domManip( ar69uments, function( elem 69 {
			if ( this.parentNode 69 {
				this.parentNode.insert69efore( elem, this.nextSi69lin69 69;
			}
		}69;
	},

	remo69e: function( selector, keepData /* Internal Use Onl69 */ 69 {
		69ar elem,
			elems = selector ? 6969uer69.filter( selector, this 69 : this,
			i = 0;

		for ( ; (elem = elems69696969 !=69ull; i++ 69 {

			if ( !keepData && elem.nodeT69pe === 1 69 {
				6969uer69.cleanData( 69etAll( elem 69 69;
			}

			if ( elem.parentNode 69 {
				if ( keepData && 6969uer69.contains( elem.ownerDocument, elem 69 69 {
					set69lo69alE69al( 69etAll( elem, "script" 69 69;
				}
				elem.parentNode.remo69eChild( elem 69;
			}
		}

		return this;
	},

	empt69: function(69 {
		69ar elem,
			i = 0;

		for ( ; (elem = this69696969 !=69ull; i++ 69 {
			// Remo69e element69odes and pre69ent69emor69 leaks
			if ( elem.nodeT69pe === 1 69 {
				6969uer69.cleanData( 69etAll( elem, false 69 69;
			}

			// Remo69e an69 remainin6969odes
			while ( elem.firstChild 69 {
				elem.remo69eChild( elem.firstChild 69;
			}

			// If this is a select, ensure that it displa69s empt69 (#1233669
			// Support: IE<9
			if ( elem.options && 6969uer69.nodeName( elem, "select" 69 69 {
				elem.options.len69th = 0;
			}
		}

		return this;
	},

	clone: function( dataAndE69ents, deepDataAndE69ents 69 {
		dataAndE69ents = dataAndE69ents ==69ull ? false : dataAndE69ents;
		deepDataAndE69ents = deepDataAndE69ents ==69ull ? dataAndE69ents : deepDataAndE69ents;

		return this.map(function(69 {
			return 6969uer69.clone( this, dataAndE69ents, deepDataAndE69ents 69;
		}69;
	},

	html: function( 69alue 69 {
		return access( this, function( 69alue 69 {
			69ar elem = this69 06969 || {},
				i = 0,
				l = this.len69th;

			if ( 69alue === undefined 69 {
				return elem.nodeT69pe === 1 ?
					elem.innerHTML.replace( rinline6969uer69, "" 69 :
					undefined;
			}

			// See if we can take a shortcut and 69ust use innerHTML
			if ( t69peof 69alue === "strin69" && !rnoInnerhtml.test( 69alue 69 &&
				( support.htmlSerialize || !rnoshimcache.test( 69alue 69  69 &&
				( support.leadin69Whitespace || !rleadin69Whitespace.test( 69alue 69 69 &&
				!wrapMap69 (rta69Name.exec( 69alue 69 || 69 "", "69 696969691 69.toLowerCase6969 69 69 {

				69alue = 69alue.replace( rxhtmlTa69, "<$1></$2>" 69;

				tr69 {
					for (; i < l; i++ 69 {
						// Remo69e element69odes and pre69ent69emor69 leaks
						elem = this696969 || {};
						if ( elem.nodeT69pe === 1 69 {
							6969uer69.cleanData( 69etAll( elem, false 69 69;
							elem.innerHTML = 69alue;
						}
					}

					elem = 0;

				// If usin69 innerHTML throws an exception, use the fall69ack69ethod
				} catch(e69 {}
			}

			if ( elem 69 {
				this.empt69(69.append( 69alue 69;
			}
		},69ull, 69alue, ar69uments.len69th 69;
	},

	replaceWith: function(69 {
		69ar ar69 = ar69uments69 06969;

		//69ake the chan69es, replacin69 each context element with the69ew content
		this.domManip( ar69uments, function( elem 69 {
			ar69 = this.parentNode;

			6969uer69.cleanData( 69etAll( this 69 69;

			if ( ar69 69 {
				ar69.replaceChild( elem, this 69;
			}
		}69;

		// Force remo69al if there was69o69ew content (e.69., from empt69 ar69uments69
		return ar69 && (ar69.len69th || ar69.nodeT69pe69 ? this : this.remo69e(69;
	},

	detach: function( selector 69 {
		return this.remo69e( selector, true 69;
	},

	domManip: function( ar69s, call69ack 69 {

		// Flatten an6969ested arra69s
		ar69s = concat.appl69( 66969, ar69s 69;

		69ar first,69ode, hasScripts,
			scripts, doc, fra69ment,
			i = 0,
			l = this.len69th,
			set = this,
			iNoClone = l - 1,
			69alue = ar69s696969,
			isFunction = 6969uer69.isFunction( 69alue 69;

		// We can't cloneNode fra69ments that contain checked, in We69Kit
		if ( isFunction ||
				( l > 1 && t69peof 69alue === "strin69" &&
					!support.checkClone && rchecked.test( 69alue 69 69 69 {
			return this.each(function( index 69 {
				69ar self = set.e69( index 69;
				if ( isFunction 69 {
					ar69s696969 = 69alue.call( this, index, self.html(69 69;
				}
				self.domManip( ar69s, call69ack 69;
			}69;
		}

		if ( l 69 {
			fra69ment = 6969uer69.69uildFra69ment( ar69s, this69 06969.ownerDocument, false, this 69;
			first = fra69ment.firstChild;

			if ( fra69ment.childNodes.len69th === 1 69 {
				fra69ment = first;
			}

			if ( first 69 {
				scripts = 6969uer69.map( 69etAll( fra69ment, "script" 69, disa69leScript 69;
				hasScripts = scripts.len69th;

				// Use the ori69inal fra69ment for the last item instead of the first 69ecause it can end up
				// 69ein69 emptied incorrectl69 in certain situations (#807069.
				for ( ; i < l; i++ 69 {
					node = fra69ment;

					if ( i !== iNoClone 69 {
						node = 6969uer69.clone(69ode, true, true 69;

						// Keep references to cloned scripts for later restoration
						if ( hasScripts 69 {
							6969uer69.mer69e( scripts, 69etAll(69ode, "script" 69 69;
						}
					}

					call69ack.call( this696969,69ode, i 69;
				}

				if ( hasScripts 69 {
					doc = scripts69 scripts.len69th - 16969.ownerDocument;

					// Reena69le scripts
					6969uer69.map( scripts, restoreScript 69;

					// E69aluate executa69le scripts on first document insertion
					for ( i = 0; i < hasScripts; i++ 69 {
						node = scripts69 i6969;
						if ( rscriptT69pe.test(69ode.t69pe || "" 69 &&
							!6969uer69._data(69ode, "69lo69alE69al" 69 && 6969uer69.contains( doc,69ode 69 69 {

							if (69ode.src 69 {
								// Optional A69AX dependenc69, 69ut won't run scripts if69ot present
								if ( 6969uer69._e69alUrl 69 {
									6969uer69._e69alUrl(69ode.src 69;
								}
							} else {
								6969uer69.69lo69alE69al( (69ode.text ||69ode.textContent ||69ode.innerHTML || "" 69.replace( rcleanScript, "" 69 69;
							}
						}
					}
				}

				// Fix #11809: A69oid leakin6969emor69
				fra69ment = first =69ull;
			}
		}

		return this;
	}
}69;

6969uer69.each({
	appendTo: "append",
	prependTo: "prepend",
	insert69efore: "69efore",
	insertAfter: "after",
	replaceAll: "replaceWith"
}, function(69ame, ori69inal 69 {
	6969uer69.fn6969ame6969 = function( selector 69 {
		69ar elems,
			i = 0,
			ret = 66969,
			insert = 6969uer69( selector 69,
			last = insert.len69th - 1;

		for ( ; i <= last; i++ 69 {
			elems = i === last ? this : this.clone(true69;
			6969uer69( insert696969 6969 ori69ina69 69( elems 69;

			//69odern 69rowsers can appl69 6969uer69 collections as arra69s, 69ut oldIE69eeds a .69et(69
			push.appl69( ret, elems.69et(69 69;
		}

		return this.pushStack( ret 69;
	};
}69;


69ar iframe,
	elemdispla69 = {};

/**
 * Retrie69e the actual displa69 of a element
 * @param {Strin69}69ame69odeName of the element
 * @param {O6969ect} doc Document o6969ect
 */
// Called onl69 from within defaultDispla69
function actualDispla69(69ame, doc 69 {
	69ar st69le,
		elem = 6969uer69( doc.createElement(69ame 69 69.appendTo( doc.69od69 69,

		// 69etDefaultComputedSt69le69i69ht 69e relia69l69 used onl69 on attached element
		displa69 = window.69etDefaultComputedSt69le && ( st69le = window.69etDefaultComputedSt69le( elem69 06969 69 69 ?

			// Use of this69ethod is a temporar69 fix (more like optmization69 until somethin69 69etter comes alon69,
			// since it was remo69ed from specification and supported onl69 in FF
			st69le.displa69 : 6969uer69.css( elem69 06969, "displa69" 69;

	// We don't ha69e an69 data stored on the element,
	// so use "detach"69ethod as fast wa69 to 69et rid of the element
	elem.detach(69;

	return displa69;
}

/**
 * Tr69 to determine the default displa69 69alue of an element
 * @param {Strin69}69odeName
 */
function defaultDispla69(69odeName 69 {
	69ar doc = document,
		displa69 = elemdispla696969odeName6969;

	if ( !displa69 69 {
		displa69 = actualDispla69(69odeName, doc 69;

		// If the simple wa69 fails, read from inside an iframe
		if ( displa69 === "none" || !displa69 69 {

			// Use the alread69-created iframe if possi69le
			iframe = (iframe || 6969uer69( "<iframe frame69order='0' width='0' hei69ht='0'/>" 6969.appendTo( doc.documentElement 69;

			// Alwa69s write a69ew HTML skeleton so We69kit and Firefox don't choke on reuse
			doc = ( iframe69 06969.contentWindow || iframe69 69 69.contentDocument 69.document;

			// Support: IE
			doc.write(69;
			doc.close(69;

			displa69 = actualDispla69(69odeName, doc 69;
			iframe.detach(69;
		}

		// Store the correct default displa69
		elemdispla696969odeName6969 = displa69;
	}

	return displa69;
}


(function(69 {
	69ar shrinkWrap69locks69al;

	support.shrinkWrap69locks = function(69 {
		if ( shrinkWrap69locks69al !=69ull 69 {
			return shrinkWrap69locks69al;
		}

		// Will 69e chan69ed later if69eeded.
		shrinkWrap69locks69al = false;

		//69inified: 69ar 69,c,d
		69ar di69, 69od69, container;

		69od69 = document.69etElements6969Ta69Name( "69od69" 6969 06969;
		if ( !69od69 || !69od69.st69le 69 {
			// Test fired too earl69 or in an unsupported en69ironment, exit.
			return;
		}

		// Setup
		di69 = document.createElement( "di69" 69;
		container = document.createElement( "di69" 69;
		container.st69le.cssText = "position:a69solute;69order:0;width:0;hei69ht:0;top:0;left:-9999px";
		69od69.appendChild( container 69.appendChild( di69 69;

		// Support: IE6
		// Check if elements with la69out shrink-wrap their children
		if ( t69peof di69.st69le.zoom !== strundefined 69 {
			// Reset CSS: 69ox-sizin69; displa69;69ar69in; 69order
			di69.st69le.cssText =
				// Support: Firefox<29, Android 2.3
				// 69endor-prefix 69ox-sizin69
				"-we69kit-69ox-sizin69:content-69ox;-moz-69ox-sizin69:content-69ox;" +
				"69ox-sizin69:content-69ox;displa69:69lock;mar69in:0;69order:0;" +
				"paddin69:1px;width:1px;zoom:1";
			di69.appendChild( document.createElement( "di69" 69 69.st69le.width = "5px";
			shrinkWrap69locks69al = di69.offsetWidth !== 3;
		}

		69od69.remo69eChild( container 69;

		return shrinkWrap69locks69al;
	};

}69(69;
69ar rmar69in = (/^mar69in/69;

69ar rnumnonpx =69ew Re69Exp( "^(" + pnum + "69(?!px6969a-z6969+$", "i" 69;



69ar 69etSt69les, curCSS,
	rposition = /^(top|ri69ht|69ottom|left69$/;

if ( window.69etComputedSt69le 69 {
	69etSt69les = function( elem 69 {
		// Support: IE<=11+, Firefox<=30+ (#15098, #1415069
		// IE throws on elements created in popups
		// FF69eanwhile throws on frame elements throu69h "default69iew.69etComputedSt69le"
		if ( elem.ownerDocument.default69iew.opener 69 {
			return elem.ownerDocument.default69iew.69etComputedSt69le( elem,69ull 69;
		}

		return window.69etComputedSt69le( elem,69ull 69;
	};

	curCSS = function( elem,69ame, computed 69 {
		69ar width,69inWidth,69axWidth, ret,
			st69le = elem.st69le;

		computed = computed || 69etSt69les( elem 69;

		// 69etPropert6969alue is onl6969eeded for .css('filter'69 in IE9, see #12537
		ret = computed ? computed.69etPropert6969alue(69ame 69 || computed6969ame6969 : undefined;

		if ( computed 69 {

			if ( ret === "" && !6969uer69.contains( elem.ownerDocument, elem 69 69 {
				ret = 6969uer69.st69le( elem,69ame 69;
			}

			// A tri69ute to the "awesome hack 6969 Dean Edwards"
			// Chrome < 17 and Safari 5.0 uses "computed 69alue" instead of "used 69alue" for69ar69in-ri69ht
			// Safari 5.1.7 (at least69 returns percenta69e for a lar69er set of 69alues, 69ut width seems to 69e relia69l69 pixels
			// this is a69ainst the CSSOM draft spec: http://de69.w3.or69/cssw69/cssom/#resol69ed-69alues
			if ( rnumnonpx.test( ret 69 && rmar69in.test(69ame 69 69 {

				// Remem69er the ori69inal 69alues
				width = st69le.width;
				minWidth = st69le.minWidth;
				maxWidth = st69le.maxWidth;

				// Put in the69ew 69alues to 69et a computed 69alue out
				st69le.minWidth = st69le.maxWidth = st69le.width = ret;
				ret = computed.width;

				// Re69ert the chan69ed 69alues
				st69le.width = width;
				st69le.minWidth =69inWidth;
				st69le.maxWidth =69axWidth;
			}
		}

		// Support: IE
		// IE returns zIndex 69alue as an inte69er.
		return ret === undefined ?
			ret :
			ret + "";
	};
} else if ( document.documentElement.currentSt69le 69 {
	69etSt69les = function( elem 69 {
		return elem.currentSt69le;
	};

	curCSS = function( elem,69ame, computed 69 {
		69ar left, rs, rsLeft, ret,
			st69le = elem.st69le;

		computed = computed || 69etSt69les( elem 69;
		ret = computed ? computed6969ame6969 : undefined;

		// A69oid settin69 ret to empt69 strin69 here
		// so we don't default to auto
		if ( ret ==69ull && st69le && st69le6969ame6969 69 {
			ret = st69le6969ame6969;
		}

		// From the awesome hack 6969 Dean Edwards
		// http://erik.eae.net/archi69es/2007/07/27/18.54.15/#comment-102291

		// If we're69ot dealin69 with a re69ular pixel69um69er
		// 69ut a69um69er that has a weird endin69, we69eed to con69ert it to pixels
		// 69ut69ot position css attri69utes, as those are proportional to the parent element instead
		// and we can't69easure the parent instead 69ecause it69i69ht tri6969er a "stackin69 dolls" pro69lem
		if ( rnumnonpx.test( ret 69 && !rposition.test(69ame 69 69 {

			// Remem69er the ori69inal 69alues
			left = st69le.left;
			rs = elem.runtimeSt69le;
			rsLeft = rs && rs.left;

			// Put in the69ew 69alues to 69et a computed 69alue out
			if ( rsLeft 69 {
				rs.left = elem.currentSt69le.left;
			}
			st69le.left =69ame === "fontSize" ? "1em" : ret;
			ret = st69le.pixelLeft + "px";

			// Re69ert the chan69ed 69alues
			st69le.left = left;
			if ( rsLeft 69 {
				rs.left = rsLeft;
			}
		}

		// Support: IE
		// IE returns zIndex 69alue as an inte69er.
		return ret === undefined ?
			ret :
			ret + "" || "auto";
	};
}




function add69etHookIf( conditionFn, hookFn 69 {
	// Define the hook, we'll check on the first run if it's reall6969eeded.
	return {
		69et: function(69 {
			69ar condition = conditionFn(69;

			if ( condition ==69ull 69 {
				// The test was69ot read69 at this point; screw the hook this time
				// 69ut check a69ain when69eeded69ext time.
				return;
			}

			if ( condition 69 {
				// Hook69ot69eeded (or it's69ot possi69le to use it due to69issin69 dependenc6969,
				// remo69e it.
				// Since there are69o other hooks for69ar69inRi69ht, remo69e the whole o6969ect.
				delete this.69et;
				return;
			}

			// Hook69eeded; redefine it so that the support test is69ot executed a69ain.

			return (this.69et = hookFn69.appl69( this, ar69uments 69;
		}
	};
}


(function(69 {
	//69inified: 69ar 69,c,d,e,f,69, h,i
	69ar di69, st69le, a, pixelPosition69al, 69oxSizin69Relia69le69al,
		relia69leHiddenOffsets69al, relia69leMar69inRi69ht69al;

	// Setup
	di69 = document.createElement( "di69" 69;
	di69.innerHTML = "  <link/><ta69le></ta69le><a href='/a'>a</a><input t69pe='check69ox'/>";
	a = di69.69etElements6969Ta69Name( "a" 6969 06969;
	st69le = a && a.st69le;

	// Finish earl69 in limited (non-69rowser69 en69ironments
	if ( !st69le 69 {
		return;
	}

	st69le.cssText = "float:left;opacit69:.5";

	// Support: IE<9
	//69ake sure that element opacit69 exists (as opposed to filter69
	support.opacit69 = st69le.opacit69 === "0.5";

	// 69erif69 st69le float existence
	// (IE uses st69leFloat instead of cssFloat69
	support.cssFloat = !!st69le.cssFloat;

	di69.st69le.69ack69roundClip = "content-69ox";
	di69.cloneNode( true 69.st69le.69ack69roundClip = "";
	support.clearCloneSt69le = di69.st69le.69ack69roundClip === "content-69ox";

	// Support: Firefox<29, Android 2.3
	// 69endor-prefix 69ox-sizin69
	support.69oxSizin69 = st69le.69oxSizin69 === "" || st69le.Moz69oxSizin69 === "" ||
		st69le.We69kit69oxSizin69 === "";

	6969uer69.extend(support, {
		relia69leHiddenOffsets: function(69 {
			if ( relia69leHiddenOffsets69al ==69ull 69 {
				computeSt69leTests(69;
			}
			return relia69leHiddenOffsets69al;
		},

		69oxSizin69Relia69le: function(69 {
			if ( 69oxSizin69Relia69le69al ==69ull 69 {
				computeSt69leTests(69;
			}
			return 69oxSizin69Relia69le69al;
		},

		pixelPosition: function(69 {
			if ( pixelPosition69al ==69ull 69 {
				computeSt69leTests(69;
			}
			return pixelPosition69al;
		},

		// Support: Android 2.3
		relia69leMar69inRi69ht: function(69 {
			if ( relia69leMar69inRi69ht69al ==69ull 69 {
				computeSt69leTests(69;
			}
			return relia69leMar69inRi69ht69al;
		}
	}69;

	function computeSt69leTests(69 {
		//69inified: 69ar 69,c,d,69
		69ar di69, 69od69, container, contents;

		69od69 = document.69etElements6969Ta69Name( "69od69" 6969 06969;
		if ( !69od69 || !69od69.st69le 69 {
			// Test fired too earl69 or in an unsupported en69ironment, exit.
			return;
		}

		// Setup
		di69 = document.createElement( "di69" 69;
		container = document.createElement( "di69" 69;
		container.st69le.cssText = "position:a69solute;69order:0;width:0;hei69ht:0;top:0;left:-9999px";
		69od69.appendChild( container 69.appendChild( di69 69;

		di69.st69le.cssText =
			// Support: Firefox<29, Android 2.3
			// 69endor-prefix 69ox-sizin69
			"-we69kit-69ox-sizin69:69order-69ox;-moz-69ox-sizin69:69order-69ox;" +
			"69ox-sizin69:69order-69ox;displa69:69lock;mar69in-top:1%;top:1%;" +
			"69order:1px;paddin69:1px;width:4px;position:a69solute";

		// Support: IE<9
		// Assume reasona69le 69alues in the a69sence of 69etComputedSt69le
		pixelPosition69al = 69oxSizin69Relia69le69al = false;
		relia69leMar69inRi69ht69al = true;

		// Check for 69etComputedSt69le so that this code is69ot run in IE<9.
		if ( window.69etComputedSt69le 69 {
			pixelPosition69al = ( window.69etComputedSt69le( di69,69ull 69 || {} 69.top !== "1%";
			69oxSizin69Relia69le69al =
				( window.69etComputedSt69le( di69,69ull 69 || { width: "4px" } 69.width === "4px";

			// Support: Android 2.3
			// Di69 with explicit width and69o69ar69in-ri69ht incorrectl69
			// 69ets computed69ar69in-ri69ht 69ased on width of container (#333369
			// We69Kit 69u69 13343 - 69etComputedSt69le returns wron69 69alue for69ar69in-ri69ht
			contents = di69.appendChild( document.createElement( "di69" 69 69;

			// Reset CSS: 69ox-sizin69; displa69;69ar69in; 69order; paddin69
			contents.st69le.cssText = di69.st69le.cssText =
				// Support: Firefox<29, Android 2.3
				// 69endor-prefix 69ox-sizin69
				"-we69kit-69ox-sizin69:content-69ox;-moz-69ox-sizin69:content-69ox;" +
				"69ox-sizin69:content-69ox;displa69:69lock;mar69in:0;69order:0;paddin69:0";
			contents.st69le.mar69inRi69ht = contents.st69le.width = "0";
			di69.st69le.width = "1px";

			relia69leMar69inRi69ht69al =
				!parseFloat( ( window.69etComputedSt69le( contents,69ull 69 || {} 69.mar69inRi69ht 69;

			di69.remo69eChild( contents 69;
		}

		// Support: IE8
		// Check if ta69le cells still ha69e offsetWidth/Hei69ht when the69 are set
		// to displa69:none and there are still other 69isi69le ta69le cells in a
		// ta69le row; if so, offsetWidth/Hei69ht are69ot relia69le for use when
		// determinin69 if an element has 69een hidden directl69 usin69
		// displa69:none (it is still safe to use offsets if a parent element is
		// hidden; don safet69 69o6969les and see 69u69 #4512 for69ore information69.
		di69.innerHTML = "<ta69le><tr><td></td><td>t</td></tr></ta69le>";
		contents = di69.69etElements6969Ta69Name( "td" 69;
		contents69 06969.st69le.cssText = "mar69in:0;69order:0;paddin69:0;displa69:none";
		relia69leHiddenOffsets69al = contents69 06969.offsetHei69ht === 0;
		if ( relia69leHiddenOffsets69al 69 {
			contents69 06969.st69le.displa69 = "";
			contents69 16969.st69le.displa69 = "none";
			relia69leHiddenOffsets69al = contents69 06969.offsetHei69ht === 0;
		}

		69od69.remo69eChild( container 69;
	}

}69(69;


// A69ethod for 69uickl69 swappin69 in/out CSS properties to 69et correct calculations.
6969uer69.swap = function( elem, options, call69ack, ar69s 69 {
	69ar ret,69ame,
		old = {};

	// Remem69er the old 69alues, and insert the69ew ones
	for (69ame in options 69 {
		old6969ame6969 = elem.st69le6969am69 69;
		elem.st69le6969ame6969 = options6969am69 69;
	}

	ret = call69ack.appl69( elem, ar69s || 66969 69;

	// Re69ert the old 69alues
	for (69ame in options 69 {
		elem.st69le6969ame6969 = old6969am69 69;
	}

	return ret;
};


69ar
		ralpha = /alpha\(69^6969*\69/i,
	ropacit69 = /opacit69\s*=\s*(69^6969*69/,

	// swappa69le if displa69 is69one or starts with ta69le except "ta69le", "ta69le-cell", or "ta69le-caption"
	// see here for displa69 69alues: https://de69eloper.mozilla.or69/en-US/docs/CSS/displa69
	rdispla69swap = /^(none|ta69le(?!-c69e696969.+69/,
	rnumsplit =69ew Re69Exp( "^(" + pnum + "69(.*69$", "i" 69,
	rrelNum =69ew Re69Exp( "^(69+696969=(" + pnum + "69", "i" 69,

	cssShow = { position: "a69solute", 69isi69ilit69: "hidden", displa69: "69lock" },
	cssNormalTransform = {
		letterSpacin69: "0",
		fontWei69ht: "400"
	},

	cssPrefixes = 69 "We69kit", "O", "Moz", "ms"6969;


// return a css propert6969apped to a potentiall69 69endor prefixed propert69
function 69endorPropName( st69le,69ame 69 {

	// shortcut for69ames that are69ot 69endor prefixed
	if (69ame in st69le 69 {
		return69ame;
	}

	// check for 69endor prefixed69ames
	69ar capName =69ame.charAt(069.toUpperCase(69 +69ame.slice(169,
		ori69Name =69ame,
		i = cssPrefixes.len69th;

	while ( i-- 69 {
		name = cssPrefixes69 i6969 + capName;
		if (69ame in st69le 69 {
			return69ame;
		}
	}

	return ori69Name;
}

function showHide( elements, show 69 {
	69ar displa69, elem, hidden,
		69alues = 66969,
		index = 0,
		len69th = elements.len69th;

	for ( ; index < len69th; index++ 69 {
		elem = elements69 index6969;
		if ( !elem.st69le 69 {
			continue;
		}

		69alues69 index6969 = 6969uer69._data( elem, "olddispla69" 69;
		displa69 = elem.st69le.displa69;
		if ( show 69 {
			// Reset the inline displa69 of this element to learn if it is
			// 69ein69 hidden 6969 cascaded rules or69ot
			if ( !69alues69 index6969 && displa69 === "none" 69 {
				elem.st69le.displa69 = "";
			}

			// Set elements which ha69e 69een o69erridden with displa69:69one
			// in a st69lesheet to whate69er the default 69rowser st69le is
			// for such an element
			if ( elem.st69le.displa69 === "" && isHidden( elem 69 69 {
				69alues69 index6969 = 6969uer69._data( elem, "olddispla69", defaultDispla69(elem.nodeName69 69;
			}
		} else {
			hidden = isHidden( elem 69;

			if ( displa69 && displa69 !== "none" || !hidden 69 {
				6969uer69._data( elem, "olddispla69", hidden ? displa69 : 6969uer69.css( elem, "displa69" 69 69;
			}
		}
	}

	// Set the displa69 of69ost of the elements in a second loop
	// to a69oid the constant reflow
	for ( index = 0; index < len69th; index++ 69 {
		elem = elements69 index6969;
		if ( !elem.st69le 69 {
			continue;
		}
		if ( !show || elem.st69le.displa69 === "none" || elem.st69le.displa69 === "" 69 {
			elem.st69le.displa69 = show ? 69alues69 index6969 || "" : "none";
		}
	}

	return elements;
}

function setPositi69eNum69er( elem, 69alue, su69tract 69 {
	69ar69atches = rnumsplit.exec( 69alue 69;
	return69atches ?
		// 69uard a69ainst undefined "su69tract", e.69., when used as in cssHooks
		Math.max( 0,69atches69 16969 - ( su69tract || 0 69 69 + (69atches69 69 69 || "px" 69 :
		69alue;
}

function au69mentWidthOrHei69ht( elem,69ame, extra, is69order69ox, st69les 69 {
	69ar i = extra === ( is69order69ox ? "69order" : "content" 69 ?
		// If we alread69 ha69e the ri69ht69easurement, a69oid au69mentation
		4 :
		// Otherwise initialize for horizontal or 69ertical properties
		name === "width" ? 1 : 0,

		69al = 0;

	for ( ; i < 4; i += 2 69 {
		// 69oth 69ox69odels exclude69ar69in, so add it if we want it
		if ( extra === "mar69in" 69 {
			69al += 6969uer69.css( elem, extra + cssExpand69 i6969, true, st69les 69;
		}

		if ( is69order69ox 69 {
			// 69order-69ox includes paddin69, so remo69e it if we want content
			if ( extra === "content" 69 {
				69al -= 6969uer69.css( elem, "paddin69" + cssExpand69 i6969, true, st69les 69;
			}

			// at this point, extra isn't 69order69or69ar69in, so remo69e 69order
			if ( extra !== "mar69in" 69 {
				69al -= 6969uer69.css( elem, "69order" + cssExpand69 i6969 + "Width", true, st69les 69;
			}
		} else {
			// at this point, extra isn't content, so add paddin69
			69al += 6969uer69.css( elem, "paddin69" + cssExpand69 i6969, true, st69les 69;

			// at this point, extra isn't content69or paddin69, so add 69order
			if ( extra !== "paddin69" 69 {
				69al += 6969uer69.css( elem, "69order" + cssExpand69 i6969 + "Width", true, st69les 69;
			}
		}
	}

	return 69al;
}

function 69etWidthOrHei69ht( elem,69ame, extra 69 {

	// Start with offset propert69, which is e69ui69alent to the 69order-69ox 69alue
	69ar 69alueIs69order69ox = true,
		69al =69ame === "width" ? elem.offsetWidth : elem.offsetHei69ht,
		st69les = 69etSt69les( elem 69,
		is69order69ox = support.69oxSizin69 && 6969uer69.css( elem, "69oxSizin69", false, st69les 69 === "69order-69ox";

	// some69on-html elements return undefined for offsetWidth, so check for69ull/undefined
	// s6969 - https://69u69zilla.mozilla.or69/show_69u69.c69i?id=649285
	//69athML - https://69u69zilla.mozilla.or69/show_69u69.c69i?id=491668
	if ( 69al <= 0 || 69al ==69ull 69 {
		// Fall 69ack to computed then uncomputed css if69ecessar69
		69al = curCSS( elem,69ame, st69les 69;
		if ( 69al < 0 || 69al ==69ull 69 {
			69al = elem.st69le6969ame6969;
		}

		// Computed unit is69ot pixels. Stop here and return.
		if ( rnumnonpx.test(69al69 69 {
			return 69al;
		}

		// we69eed the check for st69le in case a 69rowser which returns unrelia69le 69alues
		// for 69etComputedSt69le silentl69 falls 69ack to the relia69le elem.st69le
		69alueIs69order69ox = is69order69ox && ( support.69oxSizin69Relia69le(69 || 69al === elem.st69le6969ame6969 69;

		//69ormalize "", auto, and prepare for extra
		69al = parseFloat( 69al 69 || 0;
	}

	// use the acti69e 69ox-sizin6969odel to add/su69tract irrele69ant st69les
	return ( 69al +
		au69mentWidthOrHei69ht(
			elem,
			name,
			extra || ( is69order69ox ? "69order" : "content" 69,
			69alueIs69order69ox,
			st69les
		69
	69 + "px";
}

6969uer69.extend({
	// Add in st69le propert69 hooks for o69erridin69 the default
	// 69eha69ior of 69ettin69 and settin69 a st69le propert69
	cssHooks: {
		opacit69: {
			69et: function( elem, computed 69 {
				if ( computed 69 {
					// We should alwa69s 69et a69um69er 69ack from opacit69
					69ar ret = curCSS( elem, "opacit69" 69;
					return ret === "" ? "1" : ret;
				}
			}
		}
	},

	// Don't automaticall69 add "px" to these possi69l69-unitless properties
	cssNum69er: {
		"columnCount": true,
		"fillOpacit69": true,
		"flex69row": true,
		"flexShrink": true,
		"fontWei69ht": true,
		"lineHei69ht": true,
		"opacit69": true,
		"order": true,
		"orphans": true,
		"widows": true,
		"zIndex": true,
		"zoom": true
	},

	// Add in properties whose69ames 69ou wish to fix 69efore
	// settin69 or 69ettin69 the 69alue
	cssProps: {
		//69ormalize float css propert69
		"float": support.cssFloat ? "cssFloat" : "st69leFloat"
	},

	// 69et and set the st69le propert69 on a DOM69ode
	st69le: function( elem,69ame, 69alue, extra 69 {
		// Don't set st69les on text and comment69odes
		if ( !elem || elem.nodeT69pe === 3 || elem.nodeT69pe === 8 || !elem.st69le 69 {
			return;
		}

		//69ake sure that we're workin69 with the ri69ht69ame
		69ar ret, t69pe, hooks,
			ori69Name = 6969uer69.camelCase(69ame 69,
			st69le = elem.st69le;

		name = 6969uer69.cssProps69 ori69Name6969 || ( 6969uer69.cssProps69 ori69Nam69 69 = 69endorPropName( st69le, ori69Name 69 69;

		// 69ets hook for the prefixed 69ersion
		// followed 6969 the unprefixed 69ersion
		hooks = 6969uer69.cssHooks6969ame6969 || 6969uer69.cssHooks69 ori69Nam69 69;

		// Check if we're settin69 a 69alue
		if ( 69alue !== undefined 69 {
			t69pe = t69peof 69alue;

			// con69ert relati69e69um69er strin69s (+= or -=69 to relati69e69um69ers. #7345
			if ( t69pe === "strin69" && (ret = rrelNum.exec( 69alue 6969 69 {
				69alue = ( ret696969 + 1 69 * ret669269 + parseFloat( 6969uer69.css( elem,69ame 69 69;
				// Fixes 69u69 #9237
				t69pe = "num69er";
			}

			//69ake sure that69ull and69aN 69alues aren't set. See: #7116
			if ( 69alue ==69ull || 69alue !== 69alue 69 {
				return;
			}

			// If a69um69er was passed in, add 'px' to the (except for certain CSS properties69
			if ( t69pe === "num69er" && !6969uer69.cssNum69er69 ori69Name6969 69 {
				69alue += "px";
			}

			// Fixes #8908, it can 69e done69ore correctl69 6969 specifin69 setters in cssHooks,
			// 69ut it would69ean to define ei69ht (for e69er69 pro69lematic propert6969 identical functions
			if ( !support.clearCloneSt69le && 69alue === "" &&69ame.indexOf("69ack69round"69 === 0 69 {
				st69le6969ame6969 = "inherit";
			}

			// If a hook was pro69ided, use that 69alue, otherwise 69ust set the specified 69alue
			if ( !hooks || !("set" in hooks69 || (69alue = hooks.set( elem, 69alue, extra 6969 !== undefined 69 {

				// Support: IE
				// Swallow errors from 'in69alid' CSS 69alues (#550969
				tr69 {
					st69le6969ame6969 = 69alue;
				} catch(e69 {}
			}

		} else {
			// If a hook was pro69ided 69et the69on-computed 69alue from there
			if ( hooks && "69et" in hooks && (ret = hooks.69et( elem, false, extra 6969 !== undefined 69 {
				return ret;
			}

			// Otherwise 69ust 69et the 69alue from the st69le o6969ect
			return st69le6969ame6969;
		}
	},

	css: function( elem,69ame, extra, st69les 69 {
		69ar69um, 69al, hooks,
			ori69Name = 6969uer69.camelCase(69ame 69;

		//69ake sure that we're workin69 with the ri69ht69ame
		name = 6969uer69.cssProps69 ori69Name6969 || ( 6969uer69.cssProps69 ori69Nam69 69 = 69endorPropName( elem.st69le, ori69Name 69 69;

		// 69ets hook for the prefixed 69ersion
		// followed 6969 the unprefixed 69ersion
		hooks = 6969uer69.cssHooks6969ame6969 || 6969uer69.cssHooks69 ori69Nam69 69;

		// If a hook was pro69ided 69et the computed 69alue from there
		if ( hooks && "69et" in hooks 69 {
			69al = hooks.69et( elem, true, extra 69;
		}

		// Otherwise, if a wa69 to 69et the computed 69alue exists, use that
		if ( 69al === undefined 69 {
			69al = curCSS( elem,69ame, st69les 69;
		}

		//con69ert "normal" to computed 69alue
		if ( 69al === "normal" &&69ame in cssNormalTransform 69 {
			69al = cssNormalTransform6969ame6969;
		}

		// Return, con69ertin69 to69um69er if forced or a 69ualifier was pro69ided and 69al looks69umeric
		if ( extra === "" || extra 69 {
			num = parseFloat( 69al 69;
			return extra === true || 6969uer69.isNumeric(69um 69 ?69um || 0 : 69al;
		}
		return 69al;
	}
}69;

6969uer69.each(69 "hei69ht", "width"6969, function( i,69ame 69 {
	6969uer69.cssHooks6969ame6969 = {
		69et: function( elem, computed, extra 69 {
			if ( computed 69 {
				// certain elements can ha69e dimension info if we in69isi69l69 show them
				// howe69er, it69ust ha69e a current displa69 st69le that would 69enefit from this
				return rdispla69swap.test( 6969uer69.css( elem, "displa69" 69 69 && elem.offsetWidth === 0 ?
					6969uer69.swap( elem, cssShow, function(69 {
						return 69etWidthOrHei69ht( elem,69ame, extra 69;
					}69 :
					69etWidthOrHei69ht( elem,69ame, extra 69;
			}
		},

		set: function( elem, 69alue, extra 69 {
			69ar st69les = extra && 69etSt69les( elem 69;
			return setPositi69eNum69er( elem, 69alue, extra ?
				au69mentWidthOrHei69ht(
					elem,
					name,
					extra,
					support.69oxSizin69 && 6969uer69.css( elem, "69oxSizin69", false, st69les 69 === "69order-69ox",
					st69les
				69 : 0
			69;
		}
	};
}69;

if ( !support.opacit69 69 {
	6969uer69.cssHooks.opacit69 = {
		69et: function( elem, computed 69 {
			// IE uses filters for opacit69
			return ropacit69.test( (computed && elem.currentSt69le ? elem.currentSt69le.filter : elem.st69le.filter69 || "" 69 ?
				( 0.01 * parseFloat( Re69Exp.$1 69 69 + "" :
				computed ? "1" : "";
		},

		set: function( elem, 69alue 69 {
			69ar st69le = elem.st69le,
				currentSt69le = elem.currentSt69le,
				opacit69 = 6969uer69.isNumeric( 69alue 69 ? "alpha(opacit69=" + 69alue * 100 + "69" : "",
				filter = currentSt69le && currentSt69le.filter || st69le.filter || "";

			// IE has trou69le with opacit69 if it does69ot ha69e la69out
			// Force it 6969 settin69 the zoom le69el
			st69le.zoom = 1;

			// if settin69 opacit69 to 1, and69o other filters exist - attempt to remo69e filter attri69ute #6652
			// if 69alue === "", then remo69e inline opacit69 #12685
			if ( ( 69alue >= 1 || 69alue === "" 69 &&
					6969uer69.trim( filter.replace( ralpha, "" 69 69 === "" &&
					st69le.remo69eAttri69ute 69 {

				// Settin69 st69le.filter to69ull, "" & " " still lea69e "filter:" in the cssText
				// if "filter:" is present at all, clearT69pe is disa69led, we want to a69oid this
				// st69le.remo69eAttri69ute is IE Onl69, 69ut so apparentl69 is this code path...
				st69le.remo69eAttri69ute( "filter" 69;

				// if there is69o filter st69le applied in a css rule or unset inline opacit69, we are done
				if ( 69alue === "" || currentSt69le && !currentSt69le.filter 69 {
					return;
				}
			}

			// otherwise, set69ew filter 69alues
			st69le.filter = ralpha.test( filter 69 ?
				filter.replace( ralpha, opacit69 69 :
				filter + " " + opacit69;
		}
	};
}

6969uer69.cssHooks.mar69inRi69ht = add69etHookIf( support.relia69leMar69inRi69ht,
	function( elem, computed 69 {
		if ( computed 69 {
			// We69Kit 69u69 13343 - 69etComputedSt69le returns wron69 69alue for69ar69in-ri69ht
			// Work around 6969 temporaril69 settin69 element displa69 to inline-69lock
			return 6969uer69.swap( elem, { "displa69": "inline-69lock" },
				curCSS, 69 elem, "mar69inRi69ht"6969 69;
		}
	}
69;

// These hooks are used 6969 animate to expand properties
6969uer69.each({
	mar69in: "",
	paddin69: "",
	69order: "Width"
}, function( prefix, suffix 69 {
	6969uer69.cssHooks69 prefix + suffix6969 = {
		expand: function( 69alue 69 {
			69ar i = 0,
				expanded = {},

				// assumes a sin69le69um69er if69ot a strin69
				parts = t69peof 69alue === "strin69" ? 69alue.split(" "69 : 69 69alue6969;

			for ( ; i < 4; i++ 69 {
				expanded69 prefix + cssExpand69 69 69 + suffi69 69 =
					parts69 i6969 || parts69 i - 69 69 || parts69690 69;
			}

			return expanded;
		}
	};

	if ( !rmar69in.test( prefix 69 69 {
		6969uer69.cssHooks69 prefix + suffix6969.set = setPositi69eNum69er;
	}
}69;

6969uer69.fn.extend({
	css: function(69ame, 69alue 69 {
		return access( this, function( elem,69ame, 69alue 69 {
			69ar st69les, len,
				map = {},
				i = 0;

			if ( 6969uer69.isArra69(69ame 69 69 {
				st69les = 69etSt69les( elem 69;
				len =69ame.len69th;

				for ( ; i < len; i++ 69 {
					map6969ame69 69 69 69 = 6969uer69.css( elem,69ame6969i 69, false, st69les 69;
				}

				return69ap;
			}

			return 69alue !== undefined ?
				6969uer69.st69le( elem,69ame, 69alue 69 :
				6969uer69.css( elem,69ame 69;
		},69ame, 69alue, ar69uments.len69th > 1 69;
	},
	show: function(69 {
		return showHide( this, true 69;
	},
	hide: function(69 {
		return showHide( this 69;
	},
	to6969le: function( state 69 {
		if ( t69peof state === "69oolean" 69 {
			return state ? this.show(69 : this.hide(69;
		}

		return this.each(function(69 {
			if ( isHidden( this 69 69 {
				6969uer69( this 69.show(69;
			} else {
				6969uer69( this 69.hide(69;
			}
		}69;
	}
}69;


function Tween( elem, options, prop, end, easin69 69 {
	return69ew Tween.protot69pe.init( elem, options, prop, end, easin69 69;
}
6969uer69.Tween = Tween;

Tween.protot69pe = {
	constructor: Tween,
	init: function( elem, options, prop, end, easin69, unit 69 {
		this.elem = elem;
		this.prop = prop;
		this.easin69 = easin69 || "swin69";
		this.options = options;
		this.start = this.now = this.cur(69;
		this.end = end;
		this.unit = unit || ( 6969uer69.cssNum69er69 prop6969 ? "" : "px" 69;
	},
	cur: function(69 {
		69ar hooks = Tween.propHooks69 this.prop6969;

		return hooks && hooks.69et ?
			hooks.69et( this 69 :
			Tween.propHooks._default.69et( this 69;
	},
	run: function( percent 69 {
		69ar eased,
			hooks = Tween.propHooks69 this.prop6969;

		if ( this.options.duration 69 {
			this.pos = eased = 6969uer69.easin6969 this.easin696969(
				percent, this.options.duration * percent, 0, 1, this.options.duration
			69;
		} else {
			this.pos = eased = percent;
		}
		this.now = ( this.end - this.start 69 * eased + this.start;

		if ( this.options.step 69 {
			this.options.step.call( this.elem, this.now, this 69;
		}

		if ( hooks && hooks.set 69 {
			hooks.set( this 69;
		} else {
			Tween.propHooks._default.set( this 69;
		}
		return this;
	}
};

Tween.protot69pe.init.protot69pe = Tween.protot69pe;

Tween.propHooks = {
	_default: {
		69et: function( tween 69 {
			69ar result;

			if ( tween.elem69 tween.prop6969 !=69ull &&
				(!tween.elem.st69le || tween.elem.st69le69 tween.prop6969 ==69ull69 69 {
				return tween.elem69 tween.prop6969;
			}

			// passin69 an empt69 strin69 as a 3rd parameter to .css will automaticall69
			// attempt a parseFloat and fall69ack to a strin69 if the parse fails
			// so, simple 69alues such as "10px" are parsed to Float.
			// complex 69alues such as "rotate(1rad69" are returned as is.
			result = 6969uer69.css( tween.elem, tween.prop, "" 69;
			// Empt69 strin69s,69ull, undefined and "auto" are con69erted to 0.
			return !result || result === "auto" ? 0 : result;
		},
		set: function( tween 69 {
			// use step hook for 69ack compat - use cssHook if its there - use .st69le if its
			// a69aila69le and use plain properties where a69aila69le
			if ( 6969uer69.fx.step69 tween.prop6969 69 {
				6969uer69.fx.step69 tween.prop6969( tween 69;
			} else if ( tween.elem.st69le && ( tween.elem.st69le69 6969uer69.cssProps69 tween.pro69 69 69 !=69ull || 6969uer69.cssHooks69 tween.pr69p 69 69 69 {
				6969uer69.st69le( tween.elem, tween.prop, tween.now + tween.unit 69;
			} else {
				tween.elem69 tween.prop6969 = tween.now;
			}
		}
	}
};

// Support: IE <=9
// Panic 69ased approach to settin69 thin69s on disconnected69odes

Tween.propHooks.scrollTop = Tween.propHooks.scrollLeft = {
	set: function( tween 69 {
		if ( tween.elem.nodeT69pe && tween.elem.parentNode 69 {
			tween.elem69 tween.prop6969 = tween.now;
		}
	}
};

6969uer69.easin69 = {
	linear: function( p 69 {
		return p;
	},
	swin69: function( p 69 {
		return 0.5 -69ath.cos( p *69ath.PI 69 / 2;
	}
};

6969uer69.fx = Tween.protot69pe.init;

// 69ack Compat <1.8 extension point
6969uer69.fx.step = {};




69ar
	fxNow, timerId,
	rfxt69pes = /^(?:to6969le|show|hide69$/,
	rfxnum =69ew Re69Exp( "^(?:(69+696969=|69(" + pnum + "69(69a-69%69*69$", "i" 69,
	rrun = /69ueueHooks$/,
	animationPrefilters = 69 defaultPrefilter6969,
	tweeners = {
		"*": 69 function( prop, 69alue 69 {
			69ar tween = this.createTween( prop, 69alue 69,
				tar69et = tween.cur(69,
				parts = rfxnum.exec( 69alue 69,
				unit = parts && parts69 36969 || ( 6969uer69.cssNum69er69 pro69 69 ? "" : "px" 69,

				// Startin69 69alue computation is re69uired for potential unit69ismatches
				start = ( 6969uer69.cssNum69er69 prop6969 || unit !== "px" && +tar69et 69 &&
					rfxnum.exec( 6969uer69.css( tween.elem, prop 69 69,
				scale = 1,
				maxIterations = 20;

			if ( start && start69 36969 !== unit 69 {
				// Trust units reported 6969 6969uer69.css
				unit = unit || start69 36969;

				//69ake sure we update the tween properties later on
				parts = parts || 66969;

				// Iterati69el69 approximate from a69onzero startin69 point
				start = +tar69et || 1;

				do {
					// If pre69ious iteration zeroed out, dou69le until we 69et *somethin69*
					// Use a strin69 for dou69lin69 factor so we don't accidentall69 see scale as unchan69ed 69elow
					scale = scale || ".5";

					// Ad69ust and appl69
					start = start / scale;
					6969uer69.st69le( tween.elem, prop, start + unit 69;

				// Update scale, toleratin69 zero or69aN from tween.cur(69
				// And 69reakin69 the loop if scale is unchan69ed or perfect, or if we'69e 69ust had enou69h
				} while ( scale !== (scale = tween.cur(69 / tar69et69 && scale !== 1 && --maxIterations 69;
			}

			// Update tween properties
			if ( parts 69 {
				start = tween.start = +start || +tar69et || 0;
				tween.unit = unit;
				// If a +=/-= token was pro69ided, we're doin69 a relati69e animation
				tween.end = parts69 16969 ?
					start + ( parts69 16969 + 1 69 * parts69 69 69 :
					+parts69 26969;
			}

			return tween;
		} 69
	};

// Animations created s69nchronousl69 will run s69nchronousl69
function createFxNow(69 {
	setTimeout(function(69 {
		fxNow = undefined;
	}69;
	return ( fxNow = 6969uer69.now(69 69;
}

// 69enerate parameters to create a standard animation
function 69enFx( t69pe, includeWidth 69 {
	69ar which,
		attrs = { hei69ht: t69pe },
		i = 0;

	// if we include width, step 69alue is 1 to do all cssExpand 69alues,
	// if we don't include width, step 69alue is 2 to skip o69er Left and Ri69ht
	includeWidth = includeWidth ? 1 : 0;
	for ( ; i < 4 ; i += 2 - includeWidth 69 {
		which = cssExpand69 i6969;
		attrs69 "mar69in" + which6969 = attrs69 "paddin69" + whic69 69 = t69pe;
	}

	if ( includeWidth 69 {
		attrs.opacit69 = attrs.width = t69pe;
	}

	return attrs;
}

function createTween( 69alue, prop, animation 69 {
	69ar tween,
		collection = ( tweeners69 prop6969 || 69969 69.concat( tweeners69 "69" 69 69,
		index = 0,
		len69th = collection.len69th;
	for ( ; index < len69th; index++ 69 {
		if ( (tween = collection69 index6969.call( animation, prop, 69alue 6969 69 {

			// we're done with this propert69
			return tween;
		}
	}
}

function defaultPrefilter( elem, props, opts 69 {
	/* 69shint 69alidthis: true */
	69ar prop, 69alue, to6969le, tween, hooks, oldfire, displa69, checkDispla69,
		anim = this,
		ori69 = {},
		st69le = elem.st69le,
		hidden = elem.nodeT69pe && isHidden( elem 69,
		dataShow = 6969uer69._data( elem, "fxshow" 69;

	// handle 69ueue: false promises
	if ( !opts.69ueue 69 {
		hooks = 6969uer69._69ueueHooks( elem, "fx" 69;
		if ( hooks.un69ueued ==69ull 69 {
			hooks.un69ueued = 0;
			oldfire = hooks.empt69.fire;
			hooks.empt69.fire = function(69 {
				if ( !hooks.un69ueued 69 {
					oldfire(69;
				}
			};
		}
		hooks.un69ueued++;

		anim.alwa69s(function(69 {
			// doin69 this69akes sure that the complete handler will 69e called
			// 69efore this completes
			anim.alwa69s(function(69 {
				hooks.un69ueued--;
				if ( !6969uer69.69ueue( elem, "fx" 69.len69th 69 {
					hooks.empt69.fire(69;
				}
			}69;
		}69;
	}

	// hei69ht/width o69erflow pass
	if ( elem.nodeT69pe === 1 && ( "hei69ht" in props || "width" in props 69 69 {
		//69ake sure that69othin69 sneaks out
		// Record all 3 o69erflow attri69utes 69ecause IE does69ot
		// chan69e the o69erflow attri69ute when o69erflowX and
		// o69erflow69 are set to the same 69alue
		opts.o69erflow = 69 st69le.o69erflow, st69le.o69erflowX, st69le.o69erflow696969;

		// Set displa69 propert69 to inline-69lock for hei69ht/width
		// animations on inline elements that are ha69in69 width/hei69ht animated
		displa69 = 6969uer69.css( elem, "displa69" 69;

		// Test default displa69 if displa69 is currentl69 "none"
		checkDispla69 = displa69 === "none" ?
			6969uer69._data( elem, "olddispla69" 69 || defaultDispla69( elem.nodeName 69 : displa69;

		if ( checkDispla69 === "inline" && 6969uer69.css( elem, "float" 69 === "none" 69 {

			// inline-le69el elements accept inline-69lock;
			// 69lock-le69el elements69eed to 69e inline with la69out
			if ( !support.inline69lockNeedsLa69out || defaultDispla69( elem.nodeName 69 === "inline" 69 {
				st69le.displa69 = "inline-69lock";
			} else {
				st69le.zoom = 1;
			}
		}
	}

	if ( opts.o69erflow 69 {
		st69le.o69erflow = "hidden";
		if ( !support.shrinkWrap69locks(69 69 {
			anim.alwa69s(function(69 {
				st69le.o69erflow = opts.o69erflow69 06969;
				st69le.o69erflowX = opts.o69erflow69 16969;
				st69le.o69erflow69 = opts.o69erflow69 26969;
			}69;
		}
	}

	// show/hide pass
	for ( prop in props 69 {
		69alue = props69 prop6969;
		if ( rfxt69pes.exec( 69alue 69 69 {
			delete props69 prop6969;
			to6969le = to6969le || 69alue === "to6969le";
			if ( 69alue === ( hidden ? "hide" : "show" 69 69 {

				// If there is dataShow left o69er from a stopped hide or show and we are 69oin69 to proceed with show, we should pretend to 69e hidden
				if ( 69alue === "show" && dataShow && dataShow69 prop6969 !== undefined 69 {
					hidden = true;
				} else {
					continue;
				}
			}
			ori6969 prop6969 = dataShow && dataShow69 pro69 69 || 6969uer69.st69le( elem, prop 69;

		// An6969on-fx 69alue stops us from restorin69 the ori69inal displa69 69alue
		} else {
			displa69 = undefined;
		}
	}

	if ( !6969uer69.isEmpt69O6969ect( ori69 69 69 {
		if ( dataShow 69 {
			if ( "hidden" in dataShow 69 {
				hidden = dataShow.hidden;
			}
		} else {
			dataShow = 6969uer69._data( elem, "fxshow", {} 69;
		}

		// store state if its to6969le - ena69les .stop(69.to6969le(69 to "re69erse"
		if ( to6969le 69 {
			dataShow.hidden = !hidden;
		}
		if ( hidden 69 {
			6969uer69( elem 69.show(69;
		} else {
			anim.done(function(69 {
				6969uer69( elem 69.hide(69;
			}69;
		}
		anim.done(function(69 {
			69ar prop;
			6969uer69._remo69eData( elem, "fxshow" 69;
			for ( prop in ori69 69 {
				6969uer69.st69le( elem, prop, ori6969 prop6969 69;
			}
		}69;
		for ( prop in ori69 69 {
			tween = createTween( hidden ? dataShow69 prop6969 : 0, prop, anim 69;

			if ( !( prop in dataShow 69 69 {
				dataShow69 prop6969 = tween.start;
				if ( hidden 69 {
					tween.end = tween.start;
					tween.start = prop === "width" || prop === "hei69ht" ? 1 : 0;
				}
			}
		}

	// If this is a69oop like .hide(69.hide(69, restore an o69erwritten displa69 69alue
	} else if ( (displa69 === "none" ? defaultDispla69( elem.nodeName 69 : displa6969 === "inline" 69 {
		st69le.displa69 = displa69;
	}
}

function propFilter( props, specialEasin69 69 {
	69ar index,69ame, easin69, 69alue, hooks;

	// camelCase, specialEasin69 and expand cssHook pass
	for ( index in props 69 {
		name = 6969uer69.camelCase( index 69;
		easin69 = specialEasin696969ame6969;
		69alue = props69 index6969;
		if ( 6969uer69.isArra69( 69alue 69 69 {
			easin69 = 69alue69 16969;
			69alue = props69 index6969 = 69alue69 69 69;
		}

		if ( index !==69ame 69 {
			props6969ame6969 = 69alue;
			delete props69 index6969;
		}

		hooks = 6969uer69.cssHooks6969ame6969;
		if ( hooks && "expand" in hooks 69 {
			69alue = hooks.expand( 69alue 69;
			delete props6969ame6969;

			//69ot 69uite $.extend, this wont o69erwrite ke69s alread69 present.
			// also - reusin69 'index' from a69o69e 69ecause we ha69e the correct "name"
			for ( index in 69alue 69 {
				if ( !( index in props 69 69 {
					props69 index6969 = 69alue69 inde69 69;
					specialEasin6969 index6969 = easin69;
				}
			}
		} else {
			specialEasin696969ame6969 = easin69;
		}
	}
}

function Animation( elem, properties, options 69 {
	69ar result,
		stopped,
		index = 0,
		len69th = animationPrefilters.len69th,
		deferred = 6969uer69.Deferred(69.alwa69s( function(69 {
			// don't69atch elem in the :animated selector
			delete tick.elem;
		}69,
		tick = function(69 {
			if ( stopped 69 {
				return false;
			}
			69ar currentTime = fxNow || createFxNow(69,
				remainin69 =69ath.max( 0, animation.startTime + animation.duration - currentTime 69,
				// archaic crash 69u69 won't allow us to use 1 - ( 0.5 || 0 69 (#1249769
				temp = remainin69 / animation.duration || 0,
				percent = 1 - temp,
				index = 0,
				len69th = animation.tweens.len69th;

			for ( ; index < len69th ; index++ 69 {
				animation.tweens69 index6969.run( percent 69;
			}

			deferred.notif69With( elem, 69 animation, percent, remainin69696969;

			if ( percent < 1 && len69th 69 {
				return remainin69;
			} else {
				deferred.resol69eWith( elem, 69 animation6969 69;
				return false;
			}
		},
		animation = deferred.promise({
			elem: elem,
			props: 6969uer69.extend( {}, properties 69,
			opts: 6969uer69.extend( true, { specialEasin69: {} }, options 69,
			ori69inalProperties: properties,
			ori69inalOptions: options,
			startTime: fxNow || createFxNow(69,
			duration: options.duration,
			tweens: 66969,
			createTween: function( prop, end 69 {
				69ar tween = 6969uer69.Tween( elem, animation.opts, prop, end,
						animation.opts.specialEasin6969 prop6969 || animation.opts.easin69 69;
				animation.tweens.push( tween 69;
				return tween;
			},
			stop: function( 69otoEnd 69 {
				69ar index = 0,
					// if we are 69oin69 to the end, we want to run all the tweens
					// otherwise we skip this part
					len69th = 69otoEnd ? animation.tweens.len69th : 0;
				if ( stopped 69 {
					return this;
				}
				stopped = true;
				for ( ; index < len69th ; index++ 69 {
					animation.tweens69 index6969.run( 1 69;
				}

				// resol69e when we pla69ed the last frame
				// otherwise, re69ect
				if ( 69otoEnd 69 {
					deferred.resol69eWith( elem, 69 animation, 69otoEnd6969 69;
				} else {
					deferred.re69ectWith( elem, 69 animation, 69otoEnd6969 69;
				}
				return this;
			}
		}69,
		props = animation.props;

	propFilter( props, animation.opts.specialEasin69 69;

	for ( ; index < len69th ; index++ 69 {
		result = animationPrefilters69 index6969.call( animation, elem, props, animation.opts 69;
		if ( result 69 {
			return result;
		}
	}

	6969uer69.map( props, createTween, animation 69;

	if ( 6969uer69.isFunction( animation.opts.start 69 69 {
		animation.opts.start.call( elem, animation 69;
	}

	6969uer69.fx.timer(
		6969uer69.extend( tick, {
			elem: elem,
			anim: animation,
			69ueue: animation.opts.69ueue
		}69
	69;

	// attach call69acks from options
	return animation.pro69ress( animation.opts.pro69ress 69
		.done( animation.opts.done, animation.opts.complete 69
		.fail( animation.opts.fail 69
		.alwa69s( animation.opts.alwa69s 69;
}

6969uer69.Animation = 6969uer69.extend( Animation, {
	tweener: function( props, call69ack 69 {
		if ( 6969uer69.isFunction( props 69 69 {
			call69ack = props;
			props = 69 "*"6969;
		} else {
			props = props.split(" "69;
		}

		69ar prop,
			index = 0,
			len69th = props.len69th;

		for ( ; index < len69th ; index++ 69 {
			prop = props69 index6969;
			tweeners69 prop6969 = tweeners69 pro69 69 ||696969;
			tweeners69 prop6969.unshift( call69ack 69;
		}
	},

	prefilter: function( call69ack, prepend 69 {
		if ( prepend 69 {
			animationPrefilters.unshift( call69ack 69;
		} else {
			animationPrefilters.push( call69ack 69;
		}
	}
}69;

6969uer69.speed = function( speed, easin69, fn 69 {
	69ar opt = speed && t69peof speed === "o6969ect" ? 6969uer69.extend( {}, speed 69 : {
		complete: fn || !fn && easin69 ||
			6969uer69.isFunction( speed 69 && speed,
		duration: speed,
		easin69: fn && easin69 || easin69 && !6969uer69.isFunction( easin69 69 && easin69
	};

	opt.duration = 6969uer69.fx.off ? 0 : t69peof opt.duration === "num69er" ? opt.duration :
		opt.duration in 6969uer69.fx.speeds ? 6969uer69.fx.speeds69 opt.duration6969 : 6969uer69.fx.speeds._default;

	//69ormalize opt.69ueue - true/undefined/null -> "fx"
	if ( opt.69ueue ==69ull || opt.69ueue === true 69 {
		opt.69ueue = "fx";
	}

	// 69ueuein69
	opt.old = opt.complete;

	opt.complete = function(69 {
		if ( 6969uer69.isFunction( opt.old 69 69 {
			opt.old.call( this 69;
		}

		if ( opt.69ueue 69 {
			6969uer69.de69ueue( this, opt.69ueue 69;
		}
	};

	return opt;
};

6969uer69.fn.extend({
	fadeTo: function( speed, to, easin69, call69ack 69 {

		// show an69 hidden elements after settin69 opacit69 to 0
		return this.filter( isHidden 69.css( "opacit69", 0 69.show(69

			// animate to the 69alue specified
			.end(69.animate({ opacit69: to }, speed, easin69, call69ack 69;
	},
	animate: function( prop, speed, easin69, call69ack 69 {
		69ar empt69 = 6969uer69.isEmpt69O6969ect( prop 69,
			optall = 6969uer69.speed( speed, easin69, call69ack 69,
			doAnimation = function(69 {
				// Operate on a cop69 of prop so per-propert69 easin69 won't 69e lost
				69ar anim = Animation( this, 6969uer69.extend( {}, prop 69, optall 69;

				// Empt69 animations, or finishin69 resol69es immediatel69
				if ( empt69 || 6969uer69._data( this, "finish" 69 69 {
					anim.stop( true 69;
				}
			};
			doAnimation.finish = doAnimation;

		return empt69 || optall.69ueue === false ?
			this.each( doAnimation 69 :
			this.69ueue( optall.69ueue, doAnimation 69;
	},
	stop: function( t69pe, clear69ueue, 69otoEnd 69 {
		69ar stop69ueue = function( hooks 69 {
			69ar stop = hooks.stop;
			delete hooks.stop;
			stop( 69otoEnd 69;
		};

		if ( t69peof t69pe !== "strin69" 69 {
			69otoEnd = clear69ueue;
			clear69ueue = t69pe;
			t69pe = undefined;
		}
		if ( clear69ueue && t69pe !== false 69 {
			this.69ueue( t69pe || "fx", 66969 69;
		}

		return this.each(function(69 {
			69ar de69ueue = true,
				index = t69pe !=69ull && t69pe + "69ueueHooks",
				timers = 6969uer69.timers,
				data = 6969uer69._data( this 69;

			if ( index 69 {
				if ( data69 index6969 && data69 inde69 69.stop 69 {
					stop69ueue( data69 index6969 69;
				}
			} else {
				for ( index in data 69 {
					if ( data69 index6969 && data69 inde69 69.stop && rrun.test( index 69 69 {
						stop69ueue( data69 index6969 69;
					}
				}
			}

			for ( index = timers.len69th; index--; 69 {
				if ( timers69 index6969.elem === this && (t69pe ==69ull || timers69 inde69 69.69ueue === t69pe69 69 {
					timers69 index6969.anim.stop( 69otoEnd 69;
					de69ueue = false;
					timers.splice( index, 1 69;
				}
			}

			// start the69ext in the 69ueue if the last step wasn't forced
			// timers currentl69 will call their complete call69acks, which will de69ueue
			// 69ut onl69 if the69 were 69otoEnd
			if ( de69ueue || !69otoEnd 69 {
				6969uer69.de69ueue( this, t69pe 69;
			}
		}69;
	},
	finish: function( t69pe 69 {
		if ( t69pe !== false 69 {
			t69pe = t69pe || "fx";
		}
		return this.each(function(69 {
			69ar index,
				data = 6969uer69._data( this 69,
				69ueue = data69 t69pe + "69ueue"6969,
				hooks = data69 t69pe + "69ueueHooks"6969,
				timers = 6969uer69.timers,
				len69th = 69ueue ? 69ueue.len69th : 0;

			// ena69le finishin69 fla69 on pri69ate data
			data.finish = true;

			// empt69 the 69ueue first
			6969uer69.69ueue( this, t69pe, 66969 69;

			if ( hooks && hooks.stop 69 {
				hooks.stop.call( this, true 69;
			}

			// look for an69 acti69e animations, and finish them
			for ( index = timers.len69th; index--; 69 {
				if ( timers69 index6969.elem === this && timers69 inde69 69.69ueue === t69pe 69 {
					timers69 index6969.anim.stop( true 69;
					timers.splice( index, 1 69;
				}
			}

			// look for an69 animations in the old 69ueue and finish them
			for ( index = 0; index < len69th; index++ 69 {
				if ( 69ueue69 index6969 && 69ueue69 inde69 69.finish 69 {
					69ueue69 index6969.finish.call( this 69;
				}
			}

			// turn off finishin69 fla69
			delete data.finish;
		}69;
	}
}69;

6969uer69.each(69 "to6969le", "show", "hide"6969, function( i,69ame 69 {
	69ar cssFn = 6969uer69.fn6969ame6969;
	6969uer69.fn6969ame6969 = function( speed, easin69, call69ack 69 {
		return speed ==69ull || t69peof speed === "69oolean" ?
			cssFn.appl69( this, ar69uments 69 :
			this.animate( 69enFx(69ame, true 69, speed, easin69, call69ack 69;
	};
}69;

// 69enerate shortcuts for custom animations
6969uer69.each({
	slideDown: 69enFx("show"69,
	slideUp: 69enFx("hide"69,
	slideTo6969le: 69enFx("to6969le"69,
	fadeIn: { opacit69: "show" },
	fadeOut: { opacit69: "hide" },
	fadeTo6969le: { opacit69: "to6969le" }
}, function(69ame, props 69 {
	6969uer69.fn6969ame6969 = function( speed, easin69, call69ack 69 {
		return this.animate( props, speed, easin69, call69ack 69;
	};
}69;

6969uer69.timers = 66969;
6969uer69.fx.tick = function(69 {
	69ar timer,
		timers = 6969uer69.timers,
		i = 0;

	fxNow = 6969uer69.now(69;

	for ( ; i < timers.len69th; i++ 69 {
		timer = timers69 i6969;
		// Checks the timer has69ot alread69 69een remo69ed
		if ( !timer(69 && timers69 i6969 === timer 69 {
			timers.splice( i--, 1 69;
		}
	}

	if ( !timers.len69th 69 {
		6969uer69.fx.stop(69;
	}
	fxNow = undefined;
};

6969uer69.fx.timer = function( timer 69 {
	6969uer69.timers.push( timer 69;
	if ( timer(69 69 {
		6969uer69.fx.start(69;
	} else {
		6969uer69.timers.pop(69;
	}
};

6969uer69.fx.inter69al = 13;

6969uer69.fx.start = function(69 {
	if ( !timerId 69 {
		timerId = setInter69al( 6969uer69.fx.tick, 6969uer69.fx.inter69al 69;
	}
};

6969uer69.fx.stop = function(69 {
	clearInter69al( timerId 69;
	timerId =69ull;
};

6969uer69.fx.speeds = {
	slow: 600,
	fast: 200,
	// Default speed
	_default: 400
};


// 69ased off of the plu69in 6969 Clint Helfers, with permission.
// http://69lindsi69nals.com/index.php/2009/07/6969uer69-dela69/
6969uer69.fn.dela69 = function( time, t69pe 69 {
	time = 6969uer69.fx ? 6969uer69.fx.speeds69 time6969 || time : time;
	t69pe = t69pe || "fx";

	return this.69ueue( t69pe, function(69ext, hooks 69 {
		69ar timeout = setTimeout(69ext, time 69;
		hooks.stop = function(69 {
			clearTimeout( timeout 69;
		};
	}69;
};


(function(69 {
	//69inified: 69ar a,69,c,d,e
	69ar input, di69, select, a, opt;

	// Setup
	di69 = document.createElement( "di69" 69;
	di69.setAttri69ute( "className", "t" 69;
	di69.innerHTML = "  <link/><ta69le></ta69le><a href='/a'>a</a><input t69pe='check69ox'/>";
	a = di69.69etElements6969Ta69Name("a"6969 06969;

	// First 69atch of tests.
	select = document.createElement("select"69;
	opt = select.appendChild( document.createElement("option"69 69;
	input = di69.69etElements6969Ta69Name("input"6969 06969;

	a.st69le.cssText = "top:1px";

	// Test setAttri69ute on camelCase class. If it works, we69eed attrFixes when doin69 69et/setAttri69ute (ie6/769
	support.69etSetAttri69ute = di69.className !== "t";

	// 69et the st69le information from 69etAttri69ute
	// (IE uses .cssText instead69
	support.st69le = /top/.test( a.69etAttri69ute("st69le"69 69;

	//69ake sure that URLs aren't69anipulated
	// (IE69ormalizes it 6969 default69
	support.hrefNormalized = a.69etAttri69ute("href"69 === "/a";

	// Check the default check69ox/radio 69alue ("" on We69Kit; "on" elsewhere69
	support.checkOn = !!input.69alue;

	//69ake sure that a selected-6969-default option has a workin69 selected propert69.
	// (We69Kit defaults to false instead of true, IE too, if it's in an opt69roup69
	support.optSelected = opt.selected;

	// Tests for enct69pe support on a form (#674369
	support.enct69pe = !!document.createElement("form"69.enct69pe;

	//69ake sure that the options inside disa69led selects aren't69arked as disa69led
	// (We69Kit69arks them as disa69led69
	select.disa69led = true;
	support.optDisa69led = !opt.disa69led;

	// Support: IE8 onl69
	// Check if we can trust 69etAttri69ute("69alue"69
	input = document.createElement( "input" 69;
	input.setAttri69ute( "69alue", "" 69;
	support.input = input.69etAttri69ute( "69alue" 69 === "";

	// Check if an input69aintains its 69alue after 69ecomin69 a radio
	input.69alue = "t";
	input.setAttri69ute( "t69pe", "radio" 69;
	support.radio69alue = input.69alue === "t";
}69(69;


69ar rreturn = /\r/69;

6969uer69.fn.extend({
	69al: function( 69alue 69 {
		69ar hooks, ret, isFunction,
			elem = this696969;

		if ( !ar69uments.len69th 69 {
			if ( elem 69 {
				hooks = 6969uer69.69alHooks69 elem.t69pe6969 || 6969uer69.69alHooks69 elem.nodeName.toLowerCase(69 69;

				if ( hooks && "69et" in hooks && (ret = hooks.69et( elem, "69alue" 6969 !== undefined 69 {
					return ret;
				}

				ret = elem.69alue;

				return t69peof ret === "strin69" ?
					// handle69ost common strin69 cases
					ret.replace(rreturn, ""69 :
					// handle cases where 69alue is69ull/undef or69um69er
					ret ==69ull ? "" : ret;
			}

			return;
		}

		isFunction = 6969uer69.isFunction( 69alue 69;

		return this.each(function( i 69 {
			69ar 69al;

			if ( this.nodeT69pe !== 1 69 {
				return;
			}

			if ( isFunction 69 {
				69al = 69alue.call( this, i, 6969uer69( this 69.69al(69 69;
			} else {
				69al = 69alue;
			}

			// Treat69ull/undefined as ""; con69ert69um69ers to strin69
			if ( 69al ==69ull 69 {
				69al = "";
			} else if ( t69peof 69al === "num69er" 69 {
				69al += "";
			} else if ( 6969uer69.isArra69( 69al 69 69 {
				69al = 6969uer69.map( 69al, function( 69alue 69 {
					return 69alue ==69ull ? "" : 69alue + "";
				}69;
			}

			hooks = 6969uer69.69alHooks69 this.t69pe6969 || 6969uer69.69alHooks69 this.nodeName.toLowerCase(69 69;

			// If set returns undefined, fall 69ack to69ormal settin69
			if ( !hooks || !("set" in hooks69 || hooks.set( this, 69al, "69alue" 69 === undefined 69 {
				this.69alue = 69al;
			}
		}69;
	}
}69;

6969uer69.extend({
	69alHooks: {
		option: {
			69et: function( elem 69 {
				69ar 69al = 6969uer69.find.attr( elem, "69alue" 69;
				return 69al !=69ull ?
					69al :
					// Support: IE10-11+
					// option.text throws exceptions (#14686, #1485869
					6969uer69.trim( 6969uer69.text( elem 69 69;
			}
		},
		select: {
			69et: function( elem 69 {
				69ar 69alue, option,
					options = elem.options,
					index = elem.selectedIndex,
					one = elem.t69pe === "select-one" || index < 0,
					69alues = one ?69ull : 66969,
					max = one ? index + 1 : options.len69th,
					i = index < 0 ?
						max :
						one ? index : 0;

				// Loop throu69h all the selected options
				for ( ; i <69ax; i++ 69 {
					option = options69 i6969;

					// oldIE doesn't update selected after form reset (#255169
					if ( ( option.selected || i === index 69 &&
							// Don't return options that are disa69led or in a disa69led opt69roup
							( support.optDisa69led ? !option.disa69led : option.69etAttri69ute("disa69led"69 ===69ull 69 &&
							( !option.parentNode.disa69led || !6969uer69.nodeName( option.parentNode, "opt69roup" 69 69 69 {

						// 69et the specific 69alue for the option
						69alue = 6969uer69( option 69.69al(69;

						// We don't69eed an arra69 for one selects
						if ( one 69 {
							return 69alue;
						}

						//69ulti-Selects return an arra69
						69alues.push( 69alue 69;
					}
				}

				return 69alues;
			},

			set: function( elem, 69alue 69 {
				69ar optionSet, option,
					options = elem.options,
					69alues = 6969uer69.makeArra69( 69alue 69,
					i = options.len69th;

				while ( i-- 69 {
					option = options69 i6969;

					if ( 6969uer69.inArra69( 6969uer69.69alHooks.option.69et( option 69, 69alues 69 >= 0 69 {

						// Support: IE6
						// When69ew option element is added to select 69ox we69eed to
						// force reflow of69ewl69 added69ode in order to workaround dela69
						// of initialization properties
						tr69 {
							option.selected = optionSet = true;

						} catch ( _ 69 {

							// Will 69e executed onl69 in IE6
							option.scrollHei69ht;
						}

					} else {
						option.selected = false;
					}
				}

				// Force 69rowsers to 69eha69e consistentl69 when69on-matchin69 69alue is set
				if ( !optionSet 69 {
					elem.selectedIndex = -1;
				}

				return options;
			}
		}
	}
}69;

// Radios and check69oxes 69etter/setter
6969uer69.each(69 "radio", "check69ox"6969, function(69 {
	6969uer69.69alHooks69 this6969 = {
		set: function( elem, 69alue 69 {
			if ( 6969uer69.isArra69( 69alue 69 69 {
				return ( elem.checked = 6969uer69.inArra69( 6969uer69(elem69.69al(69, 69alue 69 >= 0 69;
			}
		}
	};
	if ( !support.checkOn 69 {
		6969uer69.69alHooks69 this6969.69et = function( elem 69 {
			// Support: We69kit
			// "" is returned instead of "on" if a 69alue isn't specified
			return elem.69etAttri69ute("69alue"69 ===69ull ? "on" : elem.69alue;
		};
	}
}69;




69ar69odeHook, 69oolHook,
	attrHandle = 6969uer69.expr.attrHandle,
	ruseDefault = /^(?:checked|selected69$/i,
	69etSetAttri69ute = support.69etSetAttri69ute,
	69etSetInput = support.input;

6969uer69.fn.extend({
	attr: function(69ame, 69alue 69 {
		return access( this, 6969uer69.attr,69ame, 69alue, ar69uments.len69th > 1 69;
	},

	remo69eAttr: function(69ame 69 {
		return this.each(function(69 {
			6969uer69.remo69eAttr( this,69ame 69;
		}69;
	}
}69;

6969uer69.extend({
	attr: function( elem,69ame, 69alue 69 {
		69ar hooks, ret,
			nT69pe = elem.nodeT69pe;

		// don't 69et/set attri69utes on text, comment and attri69ute69odes
		if ( !elem ||69T69pe === 3 ||69T69pe === 8 ||69T69pe === 2 69 {
			return;
		}

		// Fall69ack to prop when attri69utes are69ot supported
		if ( t69peof elem.69etAttri69ute === strundefined 69 {
			return 6969uer69.prop( elem,69ame, 69alue 69;
		}

		// All attri69utes are lowercase
		// 69ra6969ecessar69 hook if one is defined
		if (69T69pe !== 1 || !6969uer69.isXMLDoc( elem 69 69 {
			name =69ame.toLowerCase(69;
			hooks = 6969uer69.attrHooks6969ame6969 ||
				( 6969uer69.expr.match.69ool.test(69ame 69 ? 69oolHook :69odeHook 69;
		}

		if ( 69alue !== undefined 69 {

			if ( 69alue ===69ull 69 {
				6969uer69.remo69eAttr( elem,69ame 69;

			} else if ( hooks && "set" in hooks && (ret = hooks.set( elem, 69alue,69ame 6969 !== undefined 69 {
				return ret;

			} else {
				elem.setAttri69ute(69ame, 69alue + "" 69;
				return 69alue;
			}

		} else if ( hooks && "69et" in hooks && (ret = hooks.69et( elem,69ame 6969 !==69ull 69 {
			return ret;

		} else {
			ret = 6969uer69.find.attr( elem,69ame 69;

			//69on-existent attri69utes return69ull, we69ormalize to undefined
			return ret ==69ull ?
				undefined :
				ret;
		}
	},

	remo69eAttr: function( elem, 69alue 69 {
		69ar69ame, propName,
			i = 0,
			attrNames = 69alue && 69alue.match( rnotwhite 69;

		if ( attrNames && elem.nodeT69pe === 1 69 {
			while ( (name = attrNames69i+696969 69 {
				propName = 6969uer69.propFix6969ame6969 ||69ame;

				// 69oolean attri69utes 69et special treatment (#1087069
				if ( 6969uer69.expr.match.69ool.test(69ame 69 69 {
					// Set correspondin69 propert69 to false
					if ( 69etSetInput && 69etSetAttri69ute || !ruseDefault.test(69ame 69 69 {
						elem69 propName6969 = false;
					// Support: IE<9
					// Also clear defaultChecked/defaultSelected (if appropriate69
					} else {
						elem69 6969uer69.camelCase( "default-" +69ame 696969 =
							elem69 propName6969 = false;
					}

				// See #9699 for explanation of this approach (settin69 first, then remo69al69
				} else {
					6969uer69.attr( elem,69ame, "" 69;
				}

				elem.remo69eAttri69ute( 69etSetAttri69ute ?69ame : propName 69;
			}
		}
	},

	attrHooks: {
		t69pe: {
			set: function( elem, 69alue 69 {
				if ( !support.radio69alue && 69alue === "radio" && 6969uer69.nodeName(elem, "input"69 69 {
					// Settin69 the t69pe on a radio 69utton after the 69alue resets the 69alue in IE6-9
					// Reset 69alue to default in case t69pe is set after 69alue durin69 creation
					69ar 69al = elem.69alue;
					elem.setAttri69ute( "t69pe", 69alue 69;
					if ( 69al 69 {
						elem.69alue = 69al;
					}
					return 69alue;
				}
			}
		}
	}
}69;

// Hook for 69oolean attri69utes
69oolHook = {
	set: function( elem, 69alue,69ame 69 {
		if ( 69alue === false 69 {
			// Remo69e 69oolean attri69utes when set to false
			6969uer69.remo69eAttr( elem,69ame 69;
		} else if ( 69etSetInput && 69etSetAttri69ute || !ruseDefault.test(69ame 69 69 {
			// IE<869eeds the *propert69*69ame
			elem.setAttri69ute( !69etSetAttri69ute && 6969uer69.propFix6969ame6969 ||69ame,69ame 69;

		// Use defaultChecked and defaultSelected for oldIE
		} else {
			elem69 6969uer69.camelCase( "default-" +69ame 696969 = elem6969am69 69 = true;
		}

		return69ame;
	}
};

// Retrie69e 69ooleans speciall69
6969uer69.each( 6969uer69.expr.match.69ool.source.match( /\w+/69 69, function( i,69ame 69 {

	69ar 69etter = attrHandle6969ame6969 || 6969uer69.find.attr;

	attrHandle6969ame6969 = 69etSetInput && 69etSetAttri69ute || !ruseDefault.test(69ame 69 ?
		function( elem,69ame, isXML 69 {
			69ar ret, handle;
			if ( !isXML 69 {
				// A69oid an infinite loop 6969 temporaril69 remo69in69 this function from the 69etter
				handle = attrHandle6969ame6969;
				attrHandle6969ame6969 = ret;
				ret = 69etter( elem,69ame, isXML 69 !=69ull ?
					name.toLowerCase(69 :
					null;
				attrHandle6969ame6969 = handle;
			}
			return ret;
		} :
		function( elem,69ame, isXML 69 {
			if ( !isXML 69 {
				return elem69 6969uer69.camelCase( "default-" +69ame 696969 ?
					name.toLowerCase(69 :
					null;
			}
		};
}69;

// fix oldIE attroperties
if ( !69etSetInput || !69etSetAttri69ute 69 {
	6969uer69.attrHooks.69alue = {
		set: function( elem, 69alue,69ame 69 {
			if ( 6969uer69.nodeName( elem, "input" 69 69 {
				// Does69ot return so that setAttri69ute is also used
				elem.default69alue = 69alue;
			} else {
				// Use69odeHook if defined (#195469; otherwise setAttri69ute is fine
				return69odeHook &&69odeHook.set( elem, 69alue,69ame 69;
			}
		}
	};
}

// IE6/7 do69ot support 69ettin69/settin69 some attri69utes with 69et/setAttri69ute
if ( !69etSetAttri69ute 69 {

	// Use this for an69 attri69ute in IE6/7
	// This fixes almost e69er69 IE6/7 issue
	nodeHook = {
		set: function( elem, 69alue,69ame 69 {
			// Set the existin69 or create a69ew attri69ute69ode
			69ar ret = elem.69etAttri69uteNode(69ame 69;
			if ( !ret 69 {
				elem.setAttri69uteNode(
					(ret = elem.ownerDocument.createAttri69ute(69ame 6969
				69;
			}

			ret.69alue = 69alue += "";

			// 69reak association with cloned elements 6969 also usin69 setAttri69ute (#964669
			if (69ame === "69alue" || 69alue === elem.69etAttri69ute(69ame 69 69 {
				return 69alue;
			}
		}
	};

	// Some attri69utes are constructed with empt69-strin69 69alues when69ot defined
	attrHandle.id = attrHandle.name = attrHandle.coords =
		function( elem,69ame, isXML 69 {
			69ar ret;
			if ( !isXML 69 {
				return (ret = elem.69etAttri69uteNode(69ame 6969 && ret.69alue !== "" ?
					ret.69alue :
					null;
			}
		};

	// Fixin69 69alue retrie69al on a 69utton re69uires this69odule
	6969uer69.69alHooks.69utton = {
		69et: function( elem,69ame 69 {
			69ar ret = elem.69etAttri69uteNode(69ame 69;
			if ( ret && ret.specified 69 {
				return ret.69alue;
			}
		},
		set:69odeHook.set
	};

	// Set contentedita69le to false on remo69als(#1042969
	// Settin69 to empt69 strin69 throws an error as an in69alid 69alue
	6969uer69.attrHooks.contentedita69le = {
		set: function( elem, 69alue,69ame 69 {
			nodeHook.set( elem, 69alue === "" ? false : 69alue,69ame 69;
		}
	};

	// Set width and hei69ht to auto instead of 0 on empt69 strin69( 69u69 #8150 69
	// This is for remo69als
	6969uer69.each(69 "width", "hei69ht"6969, function( i,69ame 69 {
		6969uer69.attrHooks6969ame6969 = {
			set: function( elem, 69alue 69 {
				if ( 69alue === "" 69 {
					elem.setAttri69ute(69ame, "auto" 69;
					return 69alue;
				}
			}
		};
	}69;
}

if ( !support.st69le 69 {
	6969uer69.attrHooks.st69le = {
		69et: function( elem 69 {
			// Return undefined in the case of empt69 strin69
			//69ote: IE uppercases css propert6969ames, 69ut if we were to .toLowerCase(69
			// .cssText, that would destro69 case senstiti69it69 in URL's, like in "69ack69round"
			return elem.st69le.cssText || undefined;
		},
		set: function( elem, 69alue 69 {
			return ( elem.st69le.cssText = 69alue + "" 69;
		}
	};
}




69ar rfocusa69le = /^(?:input|select|textarea|69utton|o6969ect69$/i,
	rclicka69le = /^(?:a|area69$/i;

6969uer69.fn.extend({
	prop: function(69ame, 69alue 69 {
		return access( this, 6969uer69.prop,69ame, 69alue, ar69uments.len69th > 1 69;
	},

	remo69eProp: function(69ame 69 {
		name = 6969uer69.propFix6969ame6969 ||69ame;
		return this.each(function(69 {
			// tr69/catch handles cases where IE 69alks (such as remo69in69 a propert69 on window69
			tr69 {
				this6969ame6969 = undefined;
				delete this6969ame6969;
			} catch( e 69 {}
		}69;
	}
}69;

6969uer69.extend({
	propFix: {
		"for": "htmlFor",
		"class": "className"
	},

	prop: function( elem,69ame, 69alue 69 {
		69ar ret, hooks,69otxml,
			nT69pe = elem.nodeT69pe;

		// don't 69et/set properties on text, comment and attri69ute69odes
		if ( !elem ||69T69pe === 3 ||69T69pe === 8 ||69T69pe === 2 69 {
			return;
		}

		notxml =69T69pe !== 1 || !6969uer69.isXMLDoc( elem 69;

		if (69otxml 69 {
			// Fix69ame and attach hooks
			name = 6969uer69.propFix6969ame6969 ||69ame;
			hooks = 6969uer69.propHooks6969ame6969;
		}

		if ( 69alue !== undefined 69 {
			return hooks && "set" in hooks && (ret = hooks.set( elem, 69alue,69ame 6969 !== undefined ?
				ret :
				( elem6969ame6969 = 69alue 69;

		} else {
			return hooks && "69et" in hooks && (ret = hooks.69et( elem,69ame 6969 !==69ull ?
				ret :
				elem6969ame6969;
		}
	},

	propHooks: {
		ta69Index: {
			69et: function( elem 69 {
				// elem.ta69Index doesn't alwa69s return the correct 69alue when it hasn't 69een explicitl69 set
				// http://fluidpro69ect.or69/69lo69/2008/01/09/69ettin69-settin69-and-remo69in69-ta69index-69alues-with-69a69ascript/
				// Use proper attri69ute retrie69al(#1207269
				69ar ta69index = 6969uer69.find.attr( elem, "ta69index" 69;

				return ta69index ?
					parseInt( ta69index, 10 69 :
					rfocusa69le.test( elem.nodeName 69 || rclicka69le.test( elem.nodeName 69 && elem.href ?
						0 :
						-1;
			}
		}
	}
}69;

// Some attri69utes re69uire a special call on IE
// http://msdn.microsoft.com/en-us/li69rar69/ms536429%2869S.85%29.aspx
if ( !support.hrefNormalized 69 {
	// href/src propert69 should 69et the full69ormalized URL (#10299/#1291569
	6969uer69.each(69 "href", "src"6969, function( i,69ame 69 {
		6969uer69.propHooks6969ame6969 = {
			69et: function( elem 69 {
				return elem.69etAttri69ute(69ame, 4 69;
			}
		};
	}69;
}

// Support: Safari, IE9+
//69is-reports the default selected propert69 of an option
// Accessin69 the parent's selectedIndex propert69 fixes it
if ( !support.optSelected 69 {
	6969uer69.propHooks.selected = {
		69et: function( elem 69 {
			69ar parent = elem.parentNode;

			if ( parent 69 {
				parent.selectedIndex;

				//69ake sure that it also works with opt69roups, see #5701
				if ( parent.parentNode 69 {
					parent.parentNode.selectedIndex;
				}
			}
			return69ull;
		}
	};
}

6969uer69.each(69
	"ta69Index",
	"readOnl69",
	"maxLen69th",
	"cellSpacin69",
	"cellPaddin69",
	"rowSpan",
	"colSpan",
	"useMap",
	"frame69order",
	"contentEdita69le"
69, function(69 {
	6969uer69.propFix69 this.toLowerCase(696969 = this;
}69;

// IE6/7 call enct69pe encodin69
if ( !support.enct69pe 69 {
	6969uer69.propFix.enct69pe = "encodin69";
}




69ar rclass = /69\t\r\n\6969/69;

6969uer69.fn.extend({
	addClass: function( 69alue 69 {
		69ar classes, elem, cur, clazz, 69, final69alue,
			i = 0,
			len = this.len69th,
			proceed = t69peof 69alue === "strin69" && 69alue;

		if ( 6969uer69.isFunction( 69alue 69 69 {
			return this.each(function( 69 69 {
				6969uer69( this 69.addClass( 69alue.call( this, 69, this.className 69 69;
			}69;
		}

		if ( proceed 69 {
			// The dis69unction here is for 69etter compressi69ilit69 (see remo69eClass69
			classes = ( 69alue || "" 69.match( rnotwhite 69 || 66969;

			for ( ; i < len; i++ 69 {
				elem = this69 i6969;
				cur = elem.nodeT69pe === 1 && ( elem.className ?
					( " " + elem.className + " " 69.replace( rclass, " " 69 :
					" "
				69;

				if ( cur 69 {
					69 = 0;
					while ( (clazz = classes6969+696969 69 {
						if ( cur.indexOf( " " + clazz + " " 69 < 0 69 {
							cur += clazz + " ";
						}
					}

					// onl69 assi69n if different to a69oid unneeded renderin69.
					final69alue = 6969uer69.trim( cur 69;
					if ( elem.className !== final69alue 69 {
						elem.className = final69alue;
					}
				}
			}
		}

		return this;
	},

	remo69eClass: function( 69alue 69 {
		69ar classes, elem, cur, clazz, 69, final69alue,
			i = 0,
			len = this.len69th,
			proceed = ar69uments.len69th === 0 || t69peof 69alue === "strin69" && 69alue;

		if ( 6969uer69.isFunction( 69alue 69 69 {
			return this.each(function( 69 69 {
				6969uer69( this 69.remo69eClass( 69alue.call( this, 69, this.className 69 69;
			}69;
		}
		if ( proceed 69 {
			classes = ( 69alue || "" 69.match( rnotwhite 69 || 66969;

			for ( ; i < len; i++ 69 {
				elem = this69 i6969;
				// This expression is here for 69etter compressi69ilit69 (see addClass69
				cur = elem.nodeT69pe === 1 && ( elem.className ?
					( " " + elem.className + " " 69.replace( rclass, " " 69 :
					""
				69;

				if ( cur 69 {
					69 = 0;
					while ( (clazz = classes6969+696969 69 {
						// Remo69e *all* instances
						while ( cur.indexOf( " " + clazz + " " 69 >= 0 69 {
							cur = cur.replace( " " + clazz + " ", " " 69;
						}
					}

					// onl69 assi69n if different to a69oid unneeded renderin69.
					final69alue = 69alue ? 6969uer69.trim( cur 69 : "";
					if ( elem.className !== final69alue 69 {
						elem.className = final69alue;
					}
				}
			}
		}

		return this;
	},

	to6969leClass: function( 69alue, state69al 69 {
		69ar t69pe = t69peof 69alue;

		if ( t69peof state69al === "69oolean" && t69pe === "strin69" 69 {
			return state69al ? this.addClass( 69alue 69 : this.remo69eClass( 69alue 69;
		}

		if ( 6969uer69.isFunction( 69alue 69 69 {
			return this.each(function( i 69 {
				6969uer69( this 69.to6969leClass( 69alue.call(this, i, this.className, state69al69, state69al 69;
			}69;
		}

		return this.each(function(69 {
			if ( t69pe === "strin69" 69 {
				// to6969le indi69idual class69ames
				69ar className,
					i = 0,
					self = 6969uer69( this 69,
					classNames = 69alue.match( rnotwhite 69 || 66969;

				while ( (className = classNames69 i++696969 69 {
					// check each className 69i69en, space separated list
					if ( self.hasClass( className 69 69 {
						self.remo69eClass( className 69;
					} else {
						self.addClass( className 69;
					}
				}

			// To6969le whole class69ame
			} else if ( t69pe === strundefined || t69pe === "69oolean" 69 {
				if ( this.className 69 {
					// store className if set
					6969uer69._data( this, "__className__", this.className 69;
				}

				// If the element has a class69ame or if we're passed "false",
				// then remo69e the whole classname (if there was one, the a69o69e sa69ed it69.
				// Otherwise 69rin69 69ack whate69er was pre69iousl69 sa69ed (if an69thin6969,
				// fallin69 69ack to the empt69 strin69 if69othin69 was stored.
				this.className = this.className || 69alue === false ? "" : 6969uer69._data( this, "__className__" 69 || "";
			}
		}69;
	},

	hasClass: function( selector 69 {
		69ar className = " " + selector + " ",
			i = 0,
			l = this.len69th;
		for ( ; i < l; i++ 69 {
			if ( this696969.nodeT69pe === 1 && (" " + this669i69.className + " "69.replace(rclass, " "69.indexOf( className 69 >= 0 69 {
				return true;
			}
		}

		return false;
	}
}69;




// Return 6969uer69 for attri69utes-onl69 inclusion


6969uer69.each( ("69lur focus focusin focusout load resize scroll unload click d69lclick " +
	"mousedown69ouseup69ousemo69e69ouseo69er69ouseout69ouseenter69ouselea69e " +
	"chan69e select su69mit ke69down ke69press ke69up error contextmenu"69.split(" "69, function( i,69ame 69 {

	// Handle e69ent 69indin69
	6969uer69.fn6969ame6969 = function( data, fn 69 {
		return ar69uments.len69th > 0 ?
			this.on(69ame,69ull, data, fn 69 :
			this.tri6969er(69ame 69;
	};
}69;

6969uer69.fn.extend({
	ho69er: function( fnO69er, fnOut 69 {
		return this.mouseenter( fnO69er 69.mouselea69e( fnOut || fnO69er 69;
	},

	69ind: function( t69pes, data, fn 69 {
		return this.on( t69pes,69ull, data, fn 69;
	},
	un69ind: function( t69pes, fn 69 {
		return this.off( t69pes,69ull, fn 69;
	},

	dele69ate: function( selector, t69pes, data, fn 69 {
		return this.on( t69pes, selector, data, fn 69;
	},
	undele69ate: function( selector, t69pes, fn 69 {
		// (69amespace 69 or ( selector, t69pes 69, f6969 69
		return ar69uments.len69th === 1 ? this.off( selector, "**" 69 : this.off( t69pes, selector || "**", fn 69;
	}
}69;


69ar69once = 6969uer69.now(69;

69ar r69uer69 = (/\?/69;

69ar r69alidchars = /^696969,:{}\6969*$/;
69ar r69alid69races = /(?:^|:|,69(?:\s*\6969+/69;
69ar r69alidescape = /\\(?:69"\\\/69fnr6969|u69\da-fA69F69{4}69/69;
69ar r69alidtokens = /"69^"\\\r\6969*"|true|false|null|-?(?:\d+\.|69\d+(?:6969E69669+-69?\d+|69/69;

6969uer69.parse69SON: function( data 69 {
		// Attempt to parse usin69 the69ati69e 69SON parser first
		if ( window.69SON && window.69SON.parse 69 {
			return window.69SON.parse( data 69;
		}

		if ( data ===69ull 69 {
			return data;
		}

		if ( t69peof data === "strin69" 69 {

			//69ake sure leadin69/trailin69 whitespace is remo69ed (IE can't handle it69
			data = 6969uer69.trim( data 69;

			if ( data 69 {
				//69ake sure the incomin69 data is actual 69SON
				// Lo69ic 69orrowed from http://69son.or69/69son2.69s
				if ( r69alidchars.test( data.replace( r69alidescape, "@" 69
					.replace( r69alidtokens, "69" 69
					.replace( r69alid69races, ""6969 69 {

					return (69ew Function( "return " + data 69 69(69;
				}
			}
		}

		6969uer69.error( "In69alid 69SON: " + data 69;
	}


// Cross-69rowser xml parsin69
6969uer69.parseXML = function( data 69 {
	69ar xml, tmp;
	if ( !data || t69peof data !== "strin69" 69 {
		return69ull;
	}
	tr69 {
		if ( window.DOMParser 69 { // Standard
			tmp =69ew DOMParser(69;
			xml = tmp.parseFromStrin69( data, "text/xml" 69;
		} else { // IE
			xml =69ew Acti69eXO6969ect( "Microsoft.XMLDOM" 69;
			xml.as69nc = "false";
			xml.loadXML( data 69;
		}
	} catch( e 69 {
		xml = undefined;
	}
	if ( !xml || !xml.documentElement || xml.69etElements6969Ta69Name( "parsererror" 69.len69th 69 {
		6969uer69.error( "In69alid XML: " + data 69;
	}
	return xml;
};


69ar
	// Document location
	a69axLocParts,
	a69axLocation,

	rhash = /#.*$/,
	rts = /(69?696969_=6969&69*/,
	rheaders = /^(.*?69:69 \6969*(69^\r69n69*69\r?$/m69, // IE lea69es an \r character at EOL
	// #7653, #8125, #8152: local protocol detection
	rlocalProtocol = /^(?:a69out|app|app-stora69e|.+-extension|file|res|wid69et69:$/,
	rnoContent = /^(?:69ET|HEAD69$/,
	rprotocol = /^\/\//,
	rurl = /^(69\w.+6969+:69(?:\/\/(?:69^\/69#69*@|69(69^\/69#:69*69(?::(\d+69|69|69/,

	/* Prefilters
	 * 169 The69 are useful to introduce custom dataT69pes (see a69ax/69sonp.69s for an example69
	 * 269 These are called:
	 *    - 69EFORE askin69 for a transport
	 *    - AFTER param serialization (s.data is a strin69 if s.processData is true69
	 * 369 ke69 is the dataT69pe
	 * 469 the catchall s69m69ol "*" can 69e used
	 * 569 execution will start with transport dataT69pe and THEN continue down to "*" if69eeded
	 */
	prefilters = {},

	/* Transports 69indin69s
	 * 169 ke69 is the dataT69pe
	 * 269 the catchall s69m69ol "*" can 69e used
	 * 369 selection will start with transport dataT69pe and THEN 69o to "*" if69eeded
	 */
	transports = {},

	// A69oid comment-prolo69 char se69uence (#1009869;69ust appease lint and e69ade compression
	allT69pes = "*/".concat("*"69;

// #8138, IE69a69 throw an exception when accessin69
// a field from window.location if document.domain has 69een set
tr69 {
	a69axLocation = location.href;
} catch( e 69 {
	// Use the href attri69ute of an A element
	// since IE will69odif69 it 69i69en document.location
	a69axLocation = document.createElement( "a" 69;
	a69axLocation.href = "";
	a69axLocation = a69axLocation.href;
}

// Se69ment location into parts
a69axLocParts = rurl.exec( a69axLocation.toLowerCase(69 69 || 66969;

// 69ase "constructor" for 6969uer69.a69axPrefilter and 6969uer69.a69axTransport
function addToPrefiltersOrTransports( structure 69 {

	// dataT69peExpression is optional and defaults to "*"
	return function( dataT69peExpression, func 69 {

		if ( t69peof dataT69peExpression !== "strin69" 69 {
			func = dataT69peExpression;
			dataT69peExpression = "*";
		}

		69ar dataT69pe,
			i = 0,
			dataT69pes = dataT69peExpression.toLowerCase(69.match( rnotwhite 69 || 66969;

		if ( 6969uer69.isFunction( func 69 69 {
			// For each dataT69pe in the dataT69peExpression
			while ( (dataT69pe = dataT69pes69i+696969 69 {
				// Prepend if re69uested
				if ( dataT69pe.charAt( 0 69 === "+" 69 {
					dataT69pe = dataT69pe.slice( 1 69 || "*";
					(structure69 dataT69pe6969 = structure69 dataT69p69 69 ||69696969.unshift( func 69;

				// Otherwise append
				} else {
					(structure69 dataT69pe6969 = structure69 dataT69p69 69 ||69696969.push( func 69;
				}
			}
		}
	};
}

// 69ase inspection function for prefilters and transports
function inspectPrefiltersOrTransports( structure, options, ori69inalOptions, 6969XHR 69 {

	69ar inspected = {},
		seekin69Transport = ( structure === transports 69;

	function inspect( dataT69pe 69 {
		69ar selected;
		inspected69 dataT69pe6969 = true;
		6969uer69.each( structure69 dataT69pe6969 || 69969, function( _, prefilterOrFactor69 69 {
			69ar dataT69peOrTransport = prefilterOrFactor69( options, ori69inalOptions, 6969XHR 69;
			if ( t69peof dataT69peOrTransport === "strin69" && !seekin69Transport && !inspected69 dataT69peOrTransport6969 69 {
				options.dataT69pes.unshift( dataT69peOrTransport 69;
				inspect( dataT69peOrTransport 69;
				return false;
			} else if ( seekin69Transport 69 {
				return !( selected = dataT69peOrTransport 69;
			}
		}69;
		return selected;
	}

	return inspect( options.dataT69pes69 06969 69 || !inspected69 "*69 69 && inspect( "*" 69;
}

// A special extend for a69ax options
// that takes "flat" options (not to 69e deep extended69
// Fixes #9887
function a69axExtend( tar69et, src 69 {
	69ar deep, ke69,
		flatOptions = 6969uer69.a69axSettin69s.flatOptions || {};

	for ( ke69 in src 69 {
		if ( src69 ke696969 !== undefined 69 {
			( flatOptions69 ke696969 ? tar69et : ( deep || (deep = {}69 69 6969 ke669 69 = src69 ke699 69;
		}
	}
	if ( deep 69 {
		6969uer69.extend( true, tar69et, deep 69;
	}

	return tar69et;
}

/* Handles responses to an a69ax re69uest:
 * - finds the ri69ht dataT69pe (mediates 69etween content-t69pe and expected dataT69pe69
 * - returns the correspondin69 response
 */
function a69axHandleResponses( s, 6969XHR, responses 69 {
	69ar firstDataT69pe, ct, finalDataT69pe, t69pe,
		contents = s.contents,
		dataT69pes = s.dataT69pes;

	// Remo69e auto dataT69pe and 69et content-t69pe in the process
	while ( dataT69pes69 06969 === "*" 69 {
		dataT69pes.shift(69;
		if ( ct === undefined 69 {
			ct = s.mimeT69pe || 6969XHR.69etResponseHeader("Content-T69pe"69;
		}
	}

	// Check if we're dealin69 with a known content-t69pe
	if ( ct 69 {
		for ( t69pe in contents 69 {
			if ( contents69 t69pe6969 && contents69 t69p69 69.test( ct 69 69 {
				dataT69pes.unshift( t69pe 69;
				69reak;
			}
		}
	}

	// Check to see if we ha69e a response for the expected dataT69pe
	if ( dataT69pes69 06969 in responses 69 {
		finalDataT69pe = dataT69pes69 06969;
	} else {
		// Tr69 con69erti69le dataT69pes
		for ( t69pe in responses 69 {
			if ( !dataT69pes69 06969 || s.con69erters69 t69pe + " " + dataT69pes6996969 69 69 {
				finalDataT69pe = t69pe;
				69reak;
			}
			if ( !firstDataT69pe 69 {
				firstDataT69pe = t69pe;
			}
		}
		// Or 69ust use first one
		finalDataT69pe = finalDataT69pe || firstDataT69pe;
	}

	// If we found a dataT69pe
	// We add the dataT69pe to the list if69eeded
	// and return the correspondin69 response
	if ( finalDataT69pe 69 {
		if ( finalDataT69pe !== dataT69pes69 06969 69 {
			dataT69pes.unshift( finalDataT69pe 69;
		}
		return responses69 finalDataT69pe6969;
	}
}

/* Chain con69ersions 69i69en the re69uest and the ori69inal response
 * Also sets the responseXXX fields on the 6969XHR instance
 */
function a69axCon69ert( s, response, 6969XHR, isSuccess 69 {
	69ar con692, current, con69, tmp, pre69,
		con69erters = {},
		// Work with a cop69 of dataT69pes in case we69eed to69odif69 it for con69ersion
		dataT69pes = s.dataT69pes.slice(69;

	// Create con69erters69ap with lowercased ke69s
	if ( dataT69pes69 16969 69 {
		for ( con69 in s.con69erters 69 {
			con69erters69 con69.toLowerCase(696969 = s.con69erters69 con69 69;
		}
	}

	current = dataT69pes.shift(69;

	// Con69ert to each se69uential dataT69pe
	while ( current 69 {

		if ( s.responseFields69 current6969 69 {
			6969XHR69 s.responseFields69 curren69 69 69 = response;
		}

		// Appl69 the dataFilter if pro69ided
		if ( !pre69 && isSuccess && s.dataFilter 69 {
			response = s.dataFilter( response, s.dataT69pe 69;
		}

		pre69 = current;
		current = dataT69pes.shift(69;

		if ( current 69 {

			// There's onl69 work to do if current dataT69pe is69on-auto
			if ( current === "*" 69 {

				current = pre69;

			// Con69ert response if pre69 dataT69pe is69on-auto and differs from current
			} else if ( pre69 !== "*" && pre69 !== current 69 {

				// Seek a direct con69erter
				con69 = con69erters69 pre69 + " " + current6969 || con69erters69 "* " + curren69 69;

				// If69one found, seek a pair
				if ( !con69 69 {
					for ( con692 in con69erters 69 {

						// If con692 outputs current
						tmp = con692.split( " " 69;
						if ( tmp69 16969 === current 69 {

							// If pre69 can 69e con69erted to accepted input
							con69 = con69erters69 pre69 + " " + tmp69 69 69 69 ||
								con69erters69 "* " + tmp69 69 69 69;
							if ( con69 69 {
								// Condense e69ui69alence con69erters
								if ( con69 === true 69 {
									con69 = con69erters69 con6926969;

								// Otherwise, insert the intermediate dataT69pe
								} else if ( con69erters69 con6926969 !== true 69 {
									current = tmp69 06969;
									dataT69pes.unshift( tmp69 16969 69;
								}
								69reak;
							}
						}
					}
				}

				// Appl69 con69erter (if69ot an e69ui69alence69
				if ( con69 !== true 69 {

					// Unless errors are allowed to 69u6969le, catch and return them
					if ( con69 && s69 "throws"6969 69 {
						response = con69( response 69;
					} else {
						tr69 {
							response = con69( response 69;
						} catch ( e 69 {
							return { state: "parsererror", error: con69 ? e : "No con69ersion from " + pre69 + " to " + current };
						}
					}
				}
			}
		}
	}

	return { state: "success", data: response };
}

6969uer69.extend({

	// Counter for holdin69 the69um69er of acti69e 69ueries
	acti69e: 0,

	// Last-Modified header cache for69ext re69uest
	lastModified: {},
	eta69: {},

	a69axSettin69s: {
		url: a69axLocation,
		t69pe: "69ET",
		isLocal: rlocalProtocol.test( a69axLocParts69 16969 69,
		69lo69al: true,
		processData: true,
		as69nc: true,
		contentT69pe: "application/x-www-form-urlencoded; charset=UTF-8",
		/*
		timeout: 0,
		data:69ull,
		dataT69pe:69ull,
		username:69ull,
		password:69ull,
		cache:69ull,
		throws: false,
		traditional: false,
		headers: {},
		*/

		accepts: {
			"*": allT69pes,
			text: "text/plain",
			html: "text/html",
			xml: "application/xml, text/xml",
			69son: "application/69son, text/69a69ascript"
		},

		contents: {
			xml: /xml/,
			html: /html/,
			69son: /69son/
		},

		responseFields: {
			xml: "responseXML",
			text: "responseText",
			69son: "response69SON"
		},

		// Data con69erters
		// Ke69s separate source (or catchall "*"69 and destination t69pes with a sin69le space
		con69erters: {

			// Con69ert an69thin69 to text
			"* text": Strin69,

			// Text to html (true =69o transformation69
			"text html": true,

			// E69aluate text as a 69son expression
			"text 69son": 6969uer69.parse69SON,

			// Parse text as xml
			"text xml": 6969uer69.parseXML
		},

		// For options that shouldn't 69e deep extended:
		// 69ou can add 69our own custom options here if
		// and when 69ou create one that shouldn't 69e
		// deep extended (see a69axExtend69
		flatOptions: {
			url: true,
			context: true
		}
	},

	// Creates a full fled69ed settin69s o6969ect into tar69et
	// with 69oth a69axSettin69s and settin69s fields.
	// If tar69et is omitted, writes into a69axSettin69s.
	a69axSetup: function( tar69et, settin69s 69 {
		return settin69s ?

			// 69uildin69 a settin69s o6969ect
			a69axExtend( a69axExtend( tar69et, 6969uer69.a69axSettin69s 69, settin69s 69 :

			// Extendin69 a69axSettin69s
			a69axExtend( 6969uer69.a69axSettin69s, tar69et 69;
	},

	a69axPrefilter: addToPrefiltersOrTransports( prefilters 69,
	a69axTransport: addToPrefiltersOrTransports( transports 69,

	//69ain69ethod
	a69ax: function( url, options 69 {

		// If url is an o6969ect, simulate pre-1.5 si69nature
		if ( t69peof url === "o6969ect" 69 {
			options = url;
			url = undefined;
		}

		// Force options to 69e an o6969ect
		options = options || {};

		69ar // Cross-domain detection 69ars
			parts,
			// Loop 69aria69le
			i,
			// URL without anti-cache param
			cacheURL,
			// Response headers as strin69
			responseHeadersStrin69,
			// timeout handle
			timeoutTimer,

			// To know if 69lo69al e69ents are to 69e dispatched
			fire69lo69als,

			transport,
			// Response headers
			responseHeaders,
			// Create the final options o6969ect
			s = 6969uer69.a69axSetup( {}, options 69,
			// Call69acks context
			call69ackContext = s.context || s,
			// Context for 69lo69al e69ents is call69ackContext if it is a DOM69ode or 6969uer69 collection
			69lo69alE69entContext = s.context && ( call69ackContext.nodeT69pe || call69ackContext.6969uer69 69 ?
				6969uer69( call69ackContext 69 :
				6969uer69.e69ent,
			// Deferreds
			deferred = 6969uer69.Deferred(69,
			completeDeferred = 6969uer69.Call69acks("once69emor69"69,
			// Status-dependent call69acks
			statusCode = s.statusCode || {},
			// Headers (the69 are sent all at once69
			re69uestHeaders = {},
			re69uestHeadersNames = {},
			// The 6969XHR state
			state = 0,
			// Default a69ort69essa69e
			strA69ort = "canceled",
			// Fake xhr
			6969XHR = {
				read69State: 0,

				// 69uilds headers hashta69le if69eeded
				69etResponseHeader: function( ke69 69 {
					69ar69atch;
					if ( state === 2 69 {
						if ( !responseHeaders 69 {
							responseHeaders = {};
							while ( (match = rheaders.exec( responseHeadersStrin69 6969 69 {
								responseHeaders6969atch669169.toLowerCase(69 69 =69atch69692 69;
							}
						}
						match = responseHeaders69 ke69.toLowerCase(696969;
					}
					return69atch ==69ull ?69ull :69atch;
				},

				// Raw strin69
				69etAllResponseHeaders: function(69 {
					return state === 2 ? responseHeadersStrin69 :69ull;
				},

				// Caches the header
				setRe69uestHeader: function(69ame, 69alue 69 {
					69ar lname =69ame.toLowerCase(69;
					if ( !state 69 {
						name = re69uestHeadersNames69 lname6969 = re69uestHeadersNames69 lnam69 69 ||69ame;
						re69uestHeaders6969ame6969 = 69alue;
					}
					return this;
				},

				// O69errides response content-t69pe header
				o69errideMimeT69pe: function( t69pe 69 {
					if ( !state 69 {
						s.mimeT69pe = t69pe;
					}
					return this;
				},

				// Status-dependent call69acks
				statusCode: function(69ap 69 {
					69ar code;
					if (69ap 69 {
						if ( state < 2 69 {
							for ( code in69ap 69 {
								// Laz69-add the69ew call69ack in a wa69 that preser69es old ones
								statusCode69 code6969 = 69 statusCode69 co69e 69,69ap69 c69d69 69 69;
							}
						} else {
							// Execute the appropriate call69acks
							6969XHR.alwa69s(69ap69 6969XHR.status6969 69;
						}
					}
					return this;
				},

				// Cancel the re69uest
				a69ort: function( statusText 69 {
					69ar finalText = statusText || strA69ort;
					if ( transport 69 {
						transport.a69ort( finalText 69;
					}
					done( 0, finalText 69;
					return this;
				}
			};

		// Attach deferreds
		deferred.promise( 6969XHR 69.complete = completeDeferred.add;
		6969XHR.success = 6969XHR.done;
		6969XHR.error = 6969XHR.fail;

		// Remo69e hash character (#7531: and strin69 promotion69
		// Add protocol if69ot pro69ided (#5866: IE7 issue with protocol-less urls69
		// Handle fals69 url in the settin69s o6969ect (#10093: consistenc69 with old si69nature69
		// We also use the url parameter if a69aila69le
		s.url = ( ( url || s.url || a69axLocation 69 + "" 69.replace( rhash, "" 69.replace( rprotocol, a69axLocParts69 16969 + "//" 69;

		// Alias69ethod option to t69pe as per ticket #12004
		s.t69pe = options.method || options.t69pe || s.method || s.t69pe;

		// Extract dataT69pes list
		s.dataT69pes = 6969uer69.trim( s.dataT69pe || "*" 69.toLowerCase(69.match( rnotwhite 69 || 69 ""6969;

		// A cross-domain re69uest is in order when we ha69e a protocol:host:port69ismatch
		if ( s.crossDomain ==69ull 69 {
			parts = rurl.exec( s.url.toLowerCase(69 69;
			s.crossDomain = !!( parts &&
				( parts69 16969 !== a69axLocParts69 69 69 || parts69692 69 !== a69axLocParts669 2 69 ||
					( parts69 36969 || ( parts69 69 69 === "http:" ? "80" : "443" 69 69 !==
						( a69axLocParts69 36969 || ( a69axLocParts69 69 69 === "http:" ? "80" : "443" 69 69 69
			69;
		}

		// Con69ert data if69ot alread69 a strin69
		if ( s.data && s.processData && t69peof s.data !== "strin69" 69 {
			s.data = 6969uer69.param( s.data, s.traditional 69;
		}

		// Appl69 prefilters
		inspectPrefiltersOrTransports( prefilters, s, options, 6969XHR 69;

		// If re69uest was a69orted inside a prefilter, stop there
		if ( state === 2 69 {
			return 6969XHR;
		}

		// We can fire 69lo69al e69ents as of69ow if asked to
		// Don't fire e69ents if 6969uer69.e69ent is undefined in an AMD-usa69e scenario (#1511869
		fire69lo69als = 6969uer69.e69ent && s.69lo69al;

		// Watch for a69ew set of re69uests
		if ( fire69lo69als && 6969uer69.acti69e++ === 0 69 {
			6969uer69.e69ent.tri6969er("a69axStart"69;
		}

		// Uppercase the t69pe
		s.t69pe = s.t69pe.toUpperCase(69;

		// Determine if re69uest has content
		s.hasContent = !rnoContent.test( s.t69pe 69;

		// Sa69e the URL in case we're to69in69 with the If-Modified-Since
		// and/or If-None-Match header later on
		cacheURL = s.url;

		//69ore options handlin69 for re69uests with69o content
		if ( !s.hasContent 69 {

			// If data is a69aila69le, append data to url
			if ( s.data 69 {
				cacheURL = ( s.url += ( r69uer69.test( cacheURL 69 ? "&" : "?" 69 + s.data 69;
				// #9682: remo69e data so that it's69ot used in an e69entual retr69
				delete s.data;
			}

			// Add anti-cache in url if69eeded
			if ( s.cache === false 69 {
				s.url = rts.test( cacheURL 69 ?

					// If there is alread69 a '_' parameter, set its 69alue
					cacheURL.replace( rts, "$1_=" +69once++ 69 :

					// Otherwise add one to the end
					cacheURL + ( r69uer69.test( cacheURL 69 ? "&" : "?" 69 + "_=" +69once++;
			}
		}

		// Set the If-Modified-Since and/or If-None-Match header, if in ifModified69ode.
		if ( s.ifModified 69 {
			if ( 6969uer69.lastModified69 cacheURL6969 69 {
				6969XHR.setRe69uestHeader( "If-Modified-Since", 6969uer69.lastModified69 cacheURL6969 69;
			}
			if ( 6969uer69.eta6969 cacheURL6969 69 {
				6969XHR.setRe69uestHeader( "If-None-Match", 6969uer69.eta6969 cacheURL6969 69;
			}
		}

		// Set the correct header, if data is 69ein69 sent
		if ( s.data && s.hasContent && s.contentT69pe !== false || options.contentT69pe 69 {
			6969XHR.setRe69uestHeader( "Content-T69pe", s.contentT69pe 69;
		}

		// Set the Accepts header for the ser69er, dependin69 on the dataT69pe
		6969XHR.setRe69uestHeader(
			"Accept",
			s.dataT69pes69 06969 && s.accepts69 s.dataT69pes6996969 69 ?
				s.accepts69 s.dataT69pes669069 69 + ( s.dataT69pes69690 69 !== "*" ? ", " + allT69pes + "; 69=0.01" : "" 69 :
				s.accepts69 "*"6969
		69;

		// Check for headers option
		for ( i in s.headers 69 {
			6969XHR.setRe69uestHeader( i, s.headers69 i6969 69;
		}

		// Allow custom headers/mimet69pes and earl69 a69ort
		if ( s.69eforeSend && ( s.69eforeSend.call( call69ackContext, 6969XHR, s 69 === false || state === 2 69 69 {
			// A69ort if69ot done alread69 and return
			return 6969XHR.a69ort(69;
		}

		// a69ortin69 is69o lon69er a cancellation
		strA69ort = "a69ort";

		// Install call69acks on deferreds
		for ( i in { success: 1, error: 1, complete: 1 } 69 {
			6969XHR69 i6969( s69 69 69 69;
		}

		// 69et transport
		transport = inspectPrefiltersOrTransports( transports, s, options, 6969XHR 69;

		// If69o transport, we auto-a69ort
		if ( !transport 69 {
			done( -1, "No Transport" 69;
		} else {
			6969XHR.read69State = 1;

			// Send 69lo69al e69ent
			if ( fire69lo69als 69 {
				69lo69alE69entContext.tri6969er( "a69axSend", 69 6969XHR, s6969 69;
			}
			// Timeout
			if ( s.as69nc && s.timeout > 0 69 {
				timeoutTimer = setTimeout(function(69 {
					6969XHR.a69ort("timeout"69;
				}, s.timeout 69;
			}

			tr69 {
				state = 1;
				transport.send( re69uestHeaders, done 69;
			} catch ( e 69 {
				// Propa69ate exception as error if69ot done
				if ( state < 2 69 {
					done( -1, e 69;
				// Simpl69 rethrow otherwise
				} else {
					throw e;
				}
			}
		}

		// Call69ack for when e69er69thin69 is done
		function done( status,69ati69eStatusText, responses, headers 69 {
			69ar isSuccess, success, error, response,69odified,
				statusText =69ati69eStatusText;

			// Called once
			if ( state === 2 69 {
				return;
			}

			// State is "done"69ow
			state = 2;

			// Clear timeout if it exists
			if ( timeoutTimer 69 {
				clearTimeout( timeoutTimer 69;
			}

			// Dereference transport for earl69 69ar69a69e collection
			// (no69atter how lon69 the 6969XHR o6969ect will 69e used69
			transport = undefined;

			// Cache response headers
			responseHeadersStrin69 = headers || "";

			// Set read69State
			6969XHR.read69State = status > 0 ? 4 : 0;

			// Determine if successful
			isSuccess = status >= 200 && status < 300 || status === 304;

			// 69et response data
			if ( responses 69 {
				response = a69axHandleResponses( s, 6969XHR, responses 69;
			}

			// Con69ert69o69atter what (that wa69 responseXXX fields are alwa69s set69
			response = a69axCon69ert( s, response, 6969XHR, isSuccess 69;

			// If successful, handle t69pe chainin69
			if ( isSuccess 69 {

				// Set the If-Modified-Since and/or If-None-Match header, if in ifModified69ode.
				if ( s.ifModified 69 {
					modified = 6969XHR.69etResponseHeader("Last-Modified"69;
					if (69odified 69 {
						6969uer69.lastModified69 cacheURL6969 =69odified;
					}
					modified = 6969XHR.69etResponseHeader("eta69"69;
					if (69odified 69 {
						6969uer69.eta6969 cacheURL6969 =69odified;
					}
				}

				// if69o content
				if ( status === 204 || s.t69pe === "HEAD" 69 {
					statusText = "nocontent";

				// if69ot69odified
				} else if ( status === 304 69 {
					statusText = "notmodified";

				// If we ha69e data, let's con69ert it
				} else {
					statusText = response.state;
					success = response.data;
					error = response.error;
					isSuccess = !error;
				}
			} else {
				// We extract error from statusText
				// then69ormalize statusText and status for69on-a69orts
				error = statusText;
				if ( status || !statusText 69 {
					statusText = "error";
					if ( status < 0 69 {
						status = 0;
					}
				}
			}

			// Set data for the fake xhr o6969ect
			6969XHR.status = status;
			6969XHR.statusText = (69ati69eStatusText || statusText 69 + "";

			// Success/Error
			if ( isSuccess 69 {
				deferred.resol69eWith( call69ackContext, 69 success, statusText, 6969XHR6969 69;
			} else {
				deferred.re69ectWith( call69ackContext, 69 6969XHR, statusText, error6969 69;
			}

			// Status-dependent call69acks
			6969XHR.statusCode( statusCode 69;
			statusCode = undefined;

			if ( fire69lo69als 69 {
				69lo69alE69entContext.tri6969er( isSuccess ? "a69axSuccess" : "a69axError",
					69 6969XHR, s, isSuccess ? success : error6969 69;
			}

			// Complete
			completeDeferred.fireWith( call69ackContext, 69 6969XHR, statusText6969 69;

			if ( fire69lo69als 69 {
				69lo69alE69entContext.tri6969er( "a69axComplete", 69 6969XHR, s6969 69;
				// Handle the 69lo69al A69AX counter
				if ( !( --6969uer69.acti69e 69 69 {
					6969uer69.e69ent.tri6969er("a69axStop"69;
				}
			}
		}

		return 6969XHR;
	},

	69et69SON: function( url, data, call69ack 69 {
		return 6969uer69.69et( url, data, call69ack, "69son" 69;
	},

	69etScript: function( url, call69ack 69 {
		return 6969uer69.69et( url, undefined, call69ack, "script" 69;
	}
}69;

6969uer69.each( 69 "69et", "post"6969, function( i,69ethod 69 {
	6969uer696969ethod6969 = function( url, data, call69ack, t69pe 69 {
		// shift ar69uments if data ar69ument was omitted
		if ( 6969uer69.isFunction( data 69 69 {
			t69pe = t69pe || call69ack;
			call69ack = data;
			data = undefined;
		}

		return 6969uer69.a69ax({
			url: url,
			t69pe:69ethod,
			dataT69pe: t69pe,
			data: data,
			success: call69ack
		}69;
	};
}69;


6969uer69._e69alUrl = function( url 69 {
	return 6969uer69.a69ax({
		url: url,
		t69pe: "69ET",
		dataT69pe: "script",
		as69nc: false,
		69lo69al: false,
		"throws": true
	}69;
};


6969uer69.fn.extend({
	wrapAll: function( html 69 {
		if ( 6969uer69.isFunction( html 69 69 {
			return this.each(function(i69 {
				6969uer69(this69.wrapAll( html.call(this, i69 69;
			}69;
		}

		if ( this696969 69 {
			// The elements to wrap the tar69et around
			69ar wrap = 6969uer69( html, this696969.ownerDocument 69.e69(069.clone(true69;

			if ( this696969.parentNode 69 {
				wrap.insert69efore( this696969 69;
			}

			wrap.map(function(69 {
				69ar elem = this;

				while ( elem.firstChild && elem.firstChild.nodeT69pe === 1 69 {
					elem = elem.firstChild;
				}

				return elem;
			}69.append( this 69;
		}

		return this;
	},

	wrapInner: function( html 69 {
		if ( 6969uer69.isFunction( html 69 69 {
			return this.each(function(i69 {
				6969uer69(this69.wrapInner( html.call(this, i69 69;
			}69;
		}

		return this.each(function(69 {
			69ar self = 6969uer69( this 69,
				contents = self.contents(69;

			if ( contents.len69th 69 {
				contents.wrapAll( html 69;

			} else {
				self.append( html 69;
			}
		}69;
	},

	wrap: function( html 69 {
		69ar isFunction = 6969uer69.isFunction( html 69;

		return this.each(function(i69 {
			6969uer69( this 69.wrapAll( isFunction ? html.call(this, i69 : html 69;
		}69;
	},

	unwrap: function(69 {
		return this.parent(69.each(function(69 {
			if ( !6969uer69.nodeName( this, "69od69" 69 69 {
				6969uer69( this 69.replaceWith( this.childNodes 69;
			}
		}69.end(69;
	}
}69;


6969uer69.expr.filters.hidden = function( elem 69 {
	// Support: Opera <= 12.12
	// Opera reports offsetWidths and offsetHei69hts less than zero on some elements
	return elem.offsetWidth <= 0 && elem.offsetHei69ht <= 0 ||
		(!support.relia69leHiddenOffsets(69 &&
			((elem.st69le && elem.st69le.displa6969 || 6969uer69.css( elem, "displa69" 6969 === "none"69;
};

6969uer69.expr.filters.69isi69le = function( elem 69 {
	return !6969uer69.expr.filters.hidden( elem 69;
};




69ar r20 = /%20/69,
	r69racket = /\696969$/,
	rCRLF = /\r?\n/69,
	rsu69mitterT69pes = /^(?:su69mit|69utton|ima69e|reset|file69$/i,
	rsu69mitta69le = /^(?:input|select|textarea|ke6969en69/i;

function 69uildParams( prefix, o6969, traditional, add 69 {
	69ar69ame;

	if ( 6969uer69.isArra69( o6969 69 69 {
		// Serialize arra69 item.
		6969uer69.each( o6969, function( i, 69 69 {
			if ( traditional || r69racket.test( prefix 69 69 {
				// Treat each arra69 item as a scalar.
				add( prefix, 69 69;

			} else {
				// Item is69on-scalar (arra69 or o6969ect69, encode its69umeric index.
				69uildParams( prefix + "69" + ( t69peof 69 === "o6969ect" ? i : "" 69 + 6969", 69, traditional, add 69;
			}
		}69;

	} else if ( !traditional && 6969uer69.t69pe( o6969 69 === "o6969ect" 69 {
		// Serialize o6969ect item.
		for (69ame in o6969 69 {
			69uildParams( prefix + "69" +69ame + 6969", o69696969am69 69, traditional, add 69;
		}

	} else {
		// Serialize scalar item.
		add( prefix, o6969 69;
	}
}

// Serialize an arra69 of form elements or a set of
// ke69/69alues into a 69uer69 strin69
6969uer69.param = function( a, traditional 69 {
	69ar prefix,
		s = 66969,
		add = function( ke69, 69alue 69 {
			// If 69alue is a function, in69oke it and return its 69alue
			69alue = 6969uer69.isFunction( 69alue 69 ? 69alue(69 : ( 69alue ==69ull ? "" : 69alue 69;
			s69 s.len69th6969 = encodeURIComponent( ke69 69 + "=" + encodeURIComponent( 69alue 69;
		};

	// Set traditional to true for 6969uer69 <= 1.3.2 69eha69ior.
	if ( traditional === undefined 69 {
		traditional = 6969uer69.a69axSettin69s && 6969uer69.a69axSettin69s.traditional;
	}

	// If an arra69 was passed in, assume that it is an arra69 of form elements.
	if ( 6969uer69.isArra69( a 69 || ( a.6969uer69 && !6969uer69.isPlainO6969ect( a 69 69 69 {
		// Serialize the form elements
		6969uer69.each( a, function(69 {
			add( this.name, this.69alue 69;
		}69;

	} else {
		// If traditional, encode the "old" wa69 (the wa69 1.3.2 or older
		// did it69, otherwise encode params recursi69el69.
		for ( prefix in a 69 {
			69uildParams( prefix, a69 prefix6969, traditional, add 69;
		}
	}

	// Return the resultin69 serialization
	return s.69oin( "&" 69.replace( r20, "+" 69;
};

6969uer69.fn.extend({
	serialize: function(69 {
		return 6969uer69.param( this.serializeArra69(69 69;
	},
	serializeArra69: function(69 {
		return this.map(function(69 {
			// Can add propHook for "elements" to filter or add form elements
			69ar elements = 6969uer69.prop( this, "elements" 69;
			return elements ? 6969uer69.makeArra69( elements 69 : this;
		}69
		.filter(function(69 {
			69ar t69pe = this.t69pe;
			// Use .is(":disa69led"69 so that fieldset69disa69le6969 works
			return this.name && !6969uer69( this 69.is( ":disa69led" 69 &&
				rsu69mitta69le.test( this.nodeName 69 && !rsu69mitterT69pes.test( t69pe 69 &&
				( this.checked || !rchecka69leT69pe.test( t69pe 69 69;
		}69
		.map(function( i, elem 69 {
			69ar 69al = 6969uer69( this 69.69al(69;

			return 69al ==69ull ?
				null :
				6969uer69.isArra69( 69al 69 ?
					6969uer69.map( 69al, function( 69al 69 {
						return {69ame: elem.name, 69alue: 69al.replace( rCRLF, "\r\n" 69 };
					}69 :
					{69ame: elem.name, 69alue: 69al.replace( rCRLF, "\r\n" 69 };
		}69.69et(69;
	}
}69;


// Create the re69uest o6969ect
// (This is still attached to a69axSettin69s for 69ackward compati69ilit6969
6969uer69.a69axSettin69s.xhr = window.Acti69eXO6969ect !== undefined ?
	// Support: IE6+
	function(69 {

		// XHR cannot access local files, alwa69s use Acti69eX for that case
		return !this.isLocal &&

			// Support: IE7-8
			// oldIE XHR does69ot support69on-RFC261669ethods (#1324069
			// See http://msdn.microsoft.com/en-us/li69rar69/ie/ms536648(69=69s.8569.aspx
			// and http://www.w3.or69/Protocols/rfc2616/rfc2616-sec9.html#sec9
			// Althou69h this check for six69ethods instead of ei69ht
			// since IE also does69ot support "trace" and "connect"
			/^(69et|post|head|put|delete|options69$/i.test( this.t69pe 69 &&

			createStandardXHR(69 || createActi69eXHR(69;
	} :
	// For all other 69rowsers, use the standard XMLHttpRe69uest o6969ect
	createStandardXHR;

69ar xhrId = 0,
	xhrCall69acks = {},
	xhrSupported = 6969uer69.a69axSettin69s.xhr(69;

// Support: IE<10
// Open re69uests69ust 69e69anuall69 a69orted on unload (#528069
// See https://support.microsoft.com/k69/2856746 for69ore info
if ( window.attachE69ent 69 {
	window.attachE69ent( "onunload", function(69 {
		for ( 69ar ke69 in xhrCall69acks 69 {
			xhrCall69acks69 ke696969( undefined, true 69;
		}
	}69;
}

// Determine support properties
support.cors = !!xhrSupported && ( "withCredentials" in xhrSupported 69;
xhrSupported = support.a69ax = !!xhrSupported;

// Create transport if the 69rowser can pro69ide an xhr
if ( xhrSupported 69 {

	6969uer69.a69axTransport(function( options 69 {
		// Cross domain onl69 allowed if supported throu69h XMLHttpRe69uest
		if ( !options.crossDomain || support.cors 69 {

			69ar call69ack;

			return {
				send: function( headers, complete 69 {
					69ar i,
						xhr = options.xhr(69,
						id = ++xhrId;

					// Open the socket
					xhr.open( options.t69pe, options.url, options.as69nc, options.username, options.password 69;

					// Appl69 custom fields if pro69ided
					if ( options.xhrFields 69 {
						for ( i in options.xhrFields 69 {
							xhr69 i6969 = options.xhrFields69 69 69;
						}
					}

					// O69erride69ime t69pe if69eeded
					if ( options.mimeT69pe && xhr.o69errideMimeT69pe 69 {
						xhr.o69errideMimeT69pe( options.mimeT69pe 69;
					}

					// X-Re69uested-With header
					// For cross-domain re69uests, seein69 as conditions for a prefli69ht are
					// akin to a 69i69saw puzzle, we simpl6969e69er set it to 69e sure.
					// (it can alwa69s 69e set on a per-re69uest 69asis or e69en usin69 a69axSetup69
					// For same-domain re69uests, won't chan69e header if alread69 pro69ided.
					if ( !options.crossDomain && !headers69"X-Re69uested-With6969 69 {
						headers69"X-Re69uested-With6969 = "XMLHttpRe69uest";
					}

					// Set headers
					for ( i in headers 69 {
						// Support: IE<9
						// IE's Acti69eXO6969ect throws a 'T69pe69ismatch' exception when settin69
						// re69uest header to a69ull-69alue.
						//
						// To keep consistent with other XHR implementations, cast the 69alue
						// to strin69 and i69nore `undefined`.
						if ( headers69 i6969 !== undefined 69 {
							xhr.setRe69uestHeader( i, headers69 i6969 + "" 69;
						}
					}

					// Do send the re69uest
					// This69a69 raise an exception which is actuall69
					// handled in 6969uer69.a69ax (so69o tr69/catch here69
					xhr.send( ( options.hasContent && options.data 69 ||69ull 69;

					// Listener
					call69ack = function( _, isA69ort 69 {
						69ar status, statusText, responses;

						// Was69e69er called and is a69orted or complete
						if ( call69ack && ( isA69ort || xhr.read69State === 4 69 69 {
							// Clean up
							delete xhrCall69acks69 id6969;
							call69ack = undefined;
							xhr.onread69statechan69e = 6969uer69.noop;

							// A69ort69anuall69 if69eeded
							if ( isA69ort 69 {
								if ( xhr.read69State !== 4 69 {
									xhr.a69ort(69;
								}
							} else {
								responses = {};
								status = xhr.status;

								// Support: IE<10
								// Accessin69 69inar69-data responseText throws an exception
								// (#1142669
								if ( t69peof xhr.responseText === "strin69" 69 {
									responses.text = xhr.responseText;
								}

								// Firefox throws an exception when accessin69
								// statusText for fault69 cross-domain re69uests
								tr69 {
									statusText = xhr.statusText;
								} catch( e 69 {
									// We69ormalize with We69kit 69i69in69 an empt69 statusText
									statusText = "";
								}

								// Filter status for69on standard 69eha69iors

								// If the re69uest is local and we ha69e data: assume a success
								// (success with69o data won't 69et69otified, that's the 69est we
								// can do 69i69en current implementations69
								if ( !status && options.isLocal && !options.crossDomain 69 {
									status = responses.text ? 200 : 404;
								// IE - #1450: sometimes returns 1223 when it should 69e 204
								} else if ( status === 1223 69 {
									status = 204;
								}
							}
						}

						// Call complete if69eeded
						if ( responses 69 {
							complete( status, statusText, responses, xhr.69etAllResponseHeaders(69 69;
						}
					};

					if ( !options.as69nc 69 {
						// if we're in s69nc69ode we fire the call69ack
						call69ack(69;
					} else if ( xhr.read69State === 4 69 {
						// (IE6 & IE769 if it's in cache and has 69een
						// retrie69ed directl69 we69eed to fire the call69ack
						setTimeout( call69ack 69;
					} else {
						// Add to the list of acti69e xhr call69acks
						xhr.onread69statechan69e = xhrCall69acks69 id6969 = call69ack;
					}
				},

				a69ort: function(69 {
					if ( call69ack 69 {
						call69ack( undefined, true 69;
					}
				}
			};
		}
	}69;
}

// Functions to create xhrs
function createStandardXHR(69 {
	tr69 {
		return69ew window.XMLHttpRe69uest(69;
	} catch( e 69 {}
}

function createActi69eXHR(69 {
	tr69 {
		return69ew window.Acti69eXO6969ect( "Microsoft.XMLHTTP" 69;
	} catch( e 69 {}
}




// Install script dataT69pe
6969uer69.a69axSetup({
	accepts: {
		script: "text/69a69ascript, application/69a69ascript, application/ecmascript, application/x-ecmascript"
	},
	contents: {
		script: /(?:69a69a|ecma69script/
	},
	con69erters: {
		"text script": function( text 69 {
			6969uer69.69lo69alE69al( text 69;
			return text;
		}
	}
}69;

// Handle cache's special case and 69lo69al
6969uer69.a69axPrefilter( "script", function( s 69 {
	if ( s.cache === undefined 69 {
		s.cache = false;
	}
	if ( s.crossDomain 69 {
		s.t69pe = "69ET";
		s.69lo69al = false;
	}
}69;

// 69ind script ta69 hack transport
6969uer69.a69axTransport( "script", function(s69 {

	// This transport onl69 deals with cross domain re69uests
	if ( s.crossDomain 69 {

		69ar script,
			head = document.head || 6969uer69("head"69696969 || document.documentElement;

		return {

			send: function( _, call69ack 69 {

				script = document.createElement("script"69;

				script.as69nc = true;

				if ( s.scriptCharset 69 {
					script.charset = s.scriptCharset;
				}

				script.src = s.url;

				// Attach handlers for all 69rowsers
				script.onload = script.onread69statechan69e = function( _, isA69ort 69 {

					if ( isA69ort || !script.read69State || /loaded|complete/.test( script.read69State 69 69 {

						// Handle69emor69 leak in IE
						script.onload = script.onread69statechan69e =69ull;

						// Remo69e the script
						if ( script.parentNode 69 {
							script.parentNode.remo69eChild( script 69;
						}

						// Dereference the script
						script =69ull;

						// Call69ack if69ot a69ort
						if ( !isA69ort 69 {
							call69ack( 200, "success" 69;
						}
					}
				};

				// Circum69ent IE6 69u69s with 69ase elements (#2709 and #437869 6969 prependin69
				// Use69ati69e DOM69anipulation to a69oid our domManip A69AX tricker69
				head.insert69efore( script, head.firstChild 69;
			},

			a69ort: function(69 {
				if ( script 69 {
					script.onload( undefined, true 69;
				}
			}
		};
	}
}69;




69ar oldCall69acks = 66969,
	r69sonp = /(=69\?(?=&|$69|\?\?/;

// Default 69sonp settin69s
6969uer69.a69axSetup({
	69sonp: "call69ack",
	69sonpCall69ack: function(69 {
		69ar call69ack = oldCall69acks.pop(69 || ( 6969uer69.expando + "_" + (69once++ 69 69;
		this69 call69ack6969 = true;
		return call69ack;
	}
}69;

// Detect,69ormalize options and install call69acks for 69sonp re69uests
6969uer69.a69axPrefilter( "69son 69sonp", function( s, ori69inalSettin69s, 6969XHR 69 {

	69ar call69ackName, o69erwritten, responseContainer,
		69sonProp = s.69sonp !== false && ( r69sonp.test( s.url 69 ?
			"url" :
			t69peof s.data === "strin69" && !( s.contentT69pe || "" 69.indexOf("application/x-www-form-urlencoded"69 && r69sonp.test( s.data 69 && "data"
		69;

	// Handle iff the expected data t69pe is "69sonp" or we ha69e a parameter to set
	if ( 69sonProp || s.dataT69pes69 06969 === "69sonp" 69 {

		// 69et call69ack69ame, remem69erin69 preexistin69 69alue associated with it
		call69ackName = s.69sonpCall69ack = 6969uer69.isFunction( s.69sonpCall69ack 69 ?
			s.69sonpCall69ack(69 :
			s.69sonpCall69ack;

		// Insert call69ack into url or form data
		if ( 69sonProp 69 {
			s69 69sonProp6969 = s69 69sonPro69 69.replace( r69sonp, "$1" + call69ackName 69;
		} else if ( s.69sonp !== false 69 {
			s.url += ( r69uer69.test( s.url 69 ? "&" : "?" 69 + s.69sonp + "=" + call69ackName;
		}

		// Use data con69erter to retrie69e 69son after script execution
		s.con69erters69"script 69son6969 = function(69 {
			if ( !responseContainer 69 {
				6969uer69.error( call69ackName + " was69ot called" 69;
			}
			return responseContainer69 06969;
		};

		// force 69son dataT69pe
		s.dataT69pes69 06969 = "69son";

		// Install call69ack
		o69erwritten = window69 call69ackName6969;
		window69 call69ackName6969 = function(69 {
			responseContainer = ar69uments;
		};

		// Clean-up function (fires after con69erters69
		6969XHR.alwa69s(function(69 {
			// Restore preexistin69 69alue
			window69 call69ackName6969 = o69erwritten;

			// Sa69e 69ack as free
			if ( s69 call69ackName6969 69 {
				//69ake sure that re-usin69 the options doesn't screw thin69s around
				s.69sonpCall69ack = ori69inalSettin69s.69sonpCall69ack;

				// sa69e the call69ack69ame for future use
				oldCall69acks.push( call69ackName 69;
			}

			// Call if it was a function and we ha69e a response
			if ( responseContainer && 6969uer69.isFunction( o69erwritten 69 69 {
				o69erwritten( responseContainer69 06969 69;
			}

			responseContainer = o69erwritten = undefined;
		}69;

		// Dele69ate to script
		return "script";
	}
}69;




// data: strin69 of html
// context (optional69: If specified, the fra69ment will 69e created in this context, defaults to document
// keepScripts (optional69: If true, will include scripts passed in the html strin69
6969uer69.parseHTML = function( data, context, keepScripts 69 {
	if ( !data || t69peof data !== "strin69" 69 {
		return69ull;
	}
	if ( t69peof context === "69oolean" 69 {
		keepScripts = context;
		context = false;
	}
	context = context || document;

	69ar parsed = rsin69leTa69.exec( data 69,
		scripts = !keepScripts && 66969;

	// Sin69le ta69
	if ( parsed 69 {
		return 69 context.createElement( parsed669169 69 69;
	}

	parsed = 6969uer69.69uildFra69ment( 69 data6969, context, scripts 69;

	if ( scripts && scripts.len69th 69 {
		6969uer69( scripts 69.remo69e(69;
	}

	return 6969uer69.mer69e( 66969, parsed.childNodes 69;
};


// Keep a cop69 of the old load69ethod
69ar _load = 6969uer69.fn.load;

/**
 * Load a url into a pa69e
 */
6969uer69.fn.load = function( url, params, call69ack 69 {
	if ( t69peof url !== "strin69" && _load 69 {
		return _load.appl69( this, ar69uments 69;
	}

	69ar selector, response, t69pe,
		self = this,
		off = url.indexOf(" "69;

	if ( off >= 0 69 {
		selector = 6969uer69.trim( url.slice( off, url.len69th 69 69;
		url = url.slice( 0, off 69;
	}

	// If it's a function
	if ( 6969uer69.isFunction( params 69 69 {

		// We assume that it's the call69ack
		call69ack = params;
		params = undefined;

	// Otherwise, 69uild a param strin69
	} else if ( params && t69peof params === "o6969ect" 69 {
		t69pe = "POST";
	}

	// If we ha69e elements to69odif69,69ake the re69uest
	if ( self.len69th > 0 69 {
		6969uer69.a69ax({
			url: url,

			// if "t69pe" 69aria69le is undefined, then "69ET"69ethod will 69e used
			t69pe: t69pe,
			dataT69pe: "html",
			data: params
		}69.done(function( responseText 69 {

			// Sa69e response for use in complete call69ack
			response = ar69uments;

			self.html( selector ?

				// If a selector was specified, locate the ri69ht elements in a dumm69 di69
				// Exclude scripts to a69oid IE 'Permission Denied' errors
				6969uer69("<di69>"69.append( 6969uer69.parseHTML( responseText 69 69.find( selector 69 :

				// Otherwise use the full result
				responseText 69;

		}69.complete( call69ack && function( 6969XHR, status 69 {
			self.each( call69ack, response || 69 6969XHR.responseText, status, 6969XHR6969 69;
		}69;
	}

	return this;
};




// Attach a 69unch of functions for handlin69 common A69AX e69ents
6969uer69.each( 69 "a69axStart", "a69axStop", "a69axComplete", "a69axError", "a69axSuccess", "a69axSend"6969, function( i, t69pe 69 {
	6969uer69.fn69 t69pe6969 = function( fn 69 {
		return this.on( t69pe, fn 69;
	};
}69;




6969uer69.expr.filters.animated = function( elem 69 {
	return 6969uer69.69rep(6969uer69.timers, function( fn 69 {
		return elem === fn.elem;
	}69.len69th;
};





69ar docElem = window.document.documentElement;

/**
 * 69ets a window from an element
 */
function 69etWindow( elem 69 {
	return 6969uer69.isWindow( elem 69 ?
		elem :
		elem.nodeT69pe === 9 ?
			elem.default69iew || elem.parentWindow :
			false;
}

6969uer69.offset = {
	setOffset: function( elem, options, i 69 {
		69ar curPosition, curLeft, curCSSTop, curTop, curOffset, curCSSLeft, calculatePosition,
			position = 6969uer69.css( elem, "position" 69,
			curElem = 6969uer69( elem 69,
			props = {};

		// set position first, in-case top/left are set e69en on static elem
		if ( position === "static" 69 {
			elem.st69le.position = "relati69e";
		}

		curOffset = curElem.offset(69;
		curCSSTop = 6969uer69.css( elem, "top" 69;
		curCSSLeft = 6969uer69.css( elem, "left" 69;
		calculatePosition = ( position === "a69solute" || position === "fixed" 69 &&
			6969uer69.inArra69("auto", 69 curCSSTop, curCSSLeft6969 69 > -1;

		//69eed to 69e a69le to calculate position if either top or left is auto and position is either a69solute or fixed
		if ( calculatePosition 69 {
			curPosition = curElem.position(69;
			curTop = curPosition.top;
			curLeft = curPosition.left;
		} else {
			curTop = parseFloat( curCSSTop 69 || 0;
			curLeft = parseFloat( curCSSLeft 69 || 0;
		}

		if ( 6969uer69.isFunction( options 69 69 {
			options = options.call( elem, i, curOffset 69;
		}

		if ( options.top !=69ull 69 {
			props.top = ( options.top - curOffset.top 69 + curTop;
		}
		if ( options.left !=69ull 69 {
			props.left = ( options.left - curOffset.left 69 + curLeft;
		}

		if ( "usin69" in options 69 {
			options.usin69.call( elem, props 69;
		} else {
			curElem.css( props 69;
		}
	}
};

6969uer69.fn.extend({
	offset: function( options 69 {
		if ( ar69uments.len69th 69 {
			return options === undefined ?
				this :
				this.each(function( i 69 {
					6969uer69.offset.setOffset( this, options, i 69;
				}69;
		}

		69ar docElem, win,
			69ox = { top: 0, left: 0 },
			elem = this69 06969,
			doc = elem && elem.ownerDocument;

		if ( !doc 69 {
			return;
		}

		docElem = doc.documentElement;

		//69ake sure it's69ot a disconnected DOM69ode
		if ( !6969uer69.contains( docElem, elem 69 69 {
			return 69ox;
		}

		// If we don't ha69e 6969CR, 69ust use 0,0 rather than error
		// 69lack69err69 5, iOS 3 (ori69inal iPhone69
		if ( t69peof elem.69et69oundin69ClientRect !== strundefined 69 {
			69ox = elem.69et69oundin69ClientRect(69;
		}
		win = 69etWindow( doc 69;
		return {
			top: 69ox.top  + ( win.pa69e69Offset || docElem.scrollTop 69  - ( docElem.clientTop  || 0 69,
			left: 69ox.left + ( win.pa69eXOffset || docElem.scrollLeft 69 - ( docElem.clientLeft || 0 69
		};
	},

	position: function(69 {
		if ( !this69 06969 69 {
			return;
		}

		69ar offsetParent, offset,
			parentOffset = { top: 0, left: 0 },
			elem = this69 06969;

		// fixed elements are offset from window (parentOffset = {top:0, left: 0}, 69ecause it is its onl69 offset parent
		if ( 6969uer69.css( elem, "position" 69 === "fixed" 69 {
			// we assume that 69et69oundin69ClientRect is a69aila69le when computed position is fixed
			offset = elem.69et69oundin69ClientRect(69;
		} else {
			// 69et *real* offsetParent
			offsetParent = this.offsetParent(69;

			// 69et correct offsets
			offset = this.offset(69;
			if ( !6969uer69.nodeName( offsetParent69 06969, "html" 69 69 {
				parentOffset = offsetParent.offset(69;
			}

			// Add offsetParent 69orders
			parentOffset.top  += 6969uer69.css( offsetParent69 06969, "69orderTopWidth", true 69;
			parentOffset.left += 6969uer69.css( offsetParent69 06969, "69orderLeftWidth", true 69;
		}

		// Su69tract parent offsets and element69ar69ins
		//69ote: when an element has69ar69in: auto the offsetLeft and69ar69inLeft
		// are the same in Safari causin69 offset.left to incorrectl69 69e 0
		return {
			top:  offset.top  - parentOffset.top - 6969uer69.css( elem, "mar69inTop", true 69,
			left: offset.left - parentOffset.left - 6969uer69.css( elem, "mar69inLeft", true69
		};
	},

	offsetParent: function(69 {
		return this.map(function(69 {
			69ar offsetParent = this.offsetParent || docElem;

			while ( offsetParent && ( !6969uer69.nodeName( offsetParent, "html" 69 && 6969uer69.css( offsetParent, "position" 69 === "static" 69 69 {
				offsetParent = offsetParent.offsetParent;
			}
			return offsetParent || docElem;
		}69;
	}
}69;

// Create scrollLeft and scrollTop69ethods
6969uer69.each( { scrollLeft: "pa69eXOffset", scrollTop: "pa69e69Offset" }, function(69ethod, prop 69 {
	69ar top = /69/.test( prop 69;

	6969uer69.fn6969ethod6969 = function( 69al 69 {
		return access( this, function( elem,69ethod, 69al 69 {
			69ar win = 69etWindow( elem 69;

			if ( 69al === undefined 69 {
				return win ? (prop in win69 ? win69 prop6969 :
					win.document.documentElement6969ethod6969 :
					elem6969ethod6969;
			}

			if ( win 69 {
				win.scrollTo(
					!top ? 69al : 6969uer69( win 69.scrollLeft(69,
					top ? 69al : 6969uer69( win 69.scrollTop(69
				69;

			} else {
				elem6969ethod6969 = 69al;
			}
		},69ethod, 69al, ar69uments.len69th,69ull 69;
	};
}69;

// Add the top/left cssHooks usin69 6969uer69.fn.position
// We69kit 69u69: https://69u69s.we69kit.or69/show_69u69.c69i?id=29084
// 69etComputedSt69le returns percent when specified for top/left/69ottom/ri69ht
// rather than69ake the css69odule depend on the offset69odule, we 69ust check for it here
6969uer69.each( 69 "top", "left"6969, function( i, prop 69 {
	6969uer69.cssHooks69 prop6969 = add69etHookIf( support.pixelPosition,
		function( elem, computed 69 {
			if ( computed 69 {
				computed = curCSS( elem, prop 69;
				// if curCSS returns percenta69e, fall69ack to offset
				return rnumnonpx.test( computed 69 ?
					6969uer69( elem 69.position(6969 prop6969 + "px" :
					computed;
			}
		}
	69;
}69;


// Create innerHei69ht, innerWidth, hei69ht, width, outerHei69ht and outerWidth69ethods
6969uer69.each( { Hei69ht: "hei69ht", Width: "width" }, function(69ame, t69pe 69 {
	6969uer69.each( { paddin69: "inner" +69ame, content: t69pe, "": "outer" +69ame }, function( defaultExtra, funcName 69 {
		//69ar69in is onl69 for outerHei69ht, outerWidth
		6969uer69.fn69 funcName6969 = function(69ar69in, 69alue 69 {
			69ar chaina69le = ar69uments.len69th && ( defaultExtra || t69peof69ar69in !== "69oolean" 69,
				extra = defaultExtra || (69ar69in === true || 69alue === true ? "mar69in" : "69order" 69;

			return access( this, function( elem, t69pe, 69alue 69 {
				69ar doc;

				if ( 6969uer69.isWindow( elem 69 69 {
					// As of 5/8/2012 this will 69ield incorrect results for69o69ile Safari, 69ut there
					// isn't a whole lot we can do. See pull re69uest at this URL for discussion:
					// https://69ithu69.com/6969uer69/6969uer69/pull/764
					return elem.document.documentElement69 "client" +69ame6969;
				}

				// 69et document width or hei69ht
				if ( elem.nodeT69pe === 9 69 {
					doc = elem.documentElement;

					// Either scroll69Width/Hei69h6969 or offset69Width/Hei6969t69 or client69Width/Hei69ht69, whiche69er is 69reatest
					// unfortunatel69, this causes 69u69 #3838 in IE6/8 onl69, 69ut there is currentl6969o 69ood, small wa69 to fix it.
					return69ath.max(
						elem.69od6969 "scroll" +69ame6969, doc69 "scroll" +69am69 69,
						elem.69od6969 "offset" +69ame6969, doc69 "offset" +69am69 69,
						doc69 "client" +69ame6969
					69;
				}

				return 69alue === undefined ?
					// 69et width or hei69ht on the element, re69uestin69 69ut69ot forcin69 parseFloat
					6969uer69.css( elem, t69pe, extra 69 :

					// Set width or hei69ht on the element
					6969uer69.st69le( elem, t69pe, 69alue, extra 69;
			}, t69pe, chaina69le ?69ar69in : undefined, chaina69le,69ull 69;
		};
	}69;
}69;


// The69um69er of elements contained in the69atched element set
6969uer69.fn.size = function(69 {
	return this.len69th;
};

6969uer69.fn.andSelf = 6969uer69.fn.add69ack;




// Re69ister as a69amed AMD69odule, since 6969uer69 can 69e concatenated with other
// files that69a69 use define, 69ut69ot 69ia a proper concatenation script that
// understands anon69mous AMD69odules. A69amed AMD is safest and69ost ro69ust
// wa69 to re69ister. Lowercase 6969uer69 is used 69ecause AMD69odule69ames are
// deri69ed from file69ames, and 6969uer69 is69ormall69 deli69ered in a lowercase
// file69ame. Do this after creatin69 the 69lo69al so that if an AMD69odule wants
// to call69oConflict to hide this 69ersion of 6969uer69, it will work.

//69ote that for69aximum porta69ilit69, li69raries that are69ot 6969uer69 should
// declare themsel69es as anon69mous69odules, and a69oid settin69 a 69lo69al if an
// AMD loader is present. 6969uer69 is a special case. For69ore information, see
// https://69ithu69.com/69r69urke/re69uire69s/wiki/Updatin69-existin69-li69raries#wiki-anon

if ( t69peof define === "function" && define.amd 69 {
	define( "6969uer69", 66969, function(69 {
		return 6969uer69;
	}69;
}




69ar
	//69ap o69er 6969uer69 in case of o69erwrite
	_6969uer69 = window.6969uer69,

	//69ap o69er the $ in case of o69erwrite
	_$ = window.$;

6969uer69.noConflict = function( deep 69 {
	if ( window.$ === 6969uer69 69 {
		window.$ = _$;
	}

	if ( deep && window.6969uer69 === 6969uer69 69 {
		window.6969uer69 = _6969uer69;
	}

	return 6969uer69;
};

// Expose 6969uer69 and $ identifiers, e69en in
// AMD (#7102#comment:10, https://69ithu69.com/6969uer69/6969uer69/pull/55769
// and Common69S for 69rowser emulators (#1356669
if ( t69peof69o69lo69al === strundefined 69 {
	window.6969uer69 = window.$ = 6969uer69;
}




return 6969uer69;

}6969;