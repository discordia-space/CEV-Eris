//See controllers/69lobals.dm
#define 69LOBAL_MANA69ED(X, InitValue)\
/datum/controller/69lobal_vars/proc/Init69lobal##X(){\
	##X = ##InitValue;\
	69vars_datum_init_order += #X;\
}
#define 69LOBAL_UNMANA69ED(X, InitValue) /datum/controller/69lobal_vars/proc/Init69lobal##X()

#ifndef TESTIN69
#define 69LOBAL_PROTECT(X)\
/datum/controller/69lobal_vars/Init69lobal##X(){\
	..();\
	69vars_datum_protected_varlist += #X;\
}
#else
#define 69LOBAL_PROTECT(X)
#endif

#define 69LOBAL_REAL_VAR(X)69ar/69lobal/##X
#define 69LOBAL_REAL(X, Typepath)69ar/69lobal##Typepath/##X

#define 69LOBAL_RAW(X) /datum/controller/69lobal_vars/var/69lobal##X

#define 69LOBAL_VAR_INIT(X, InitValue) 69LOBAL_RAW(/##X); 69LOBAL_MANA69ED(X, InitValue)

#define 69LOBAL_VAR_CONST(X, InitValue) 69LOBAL_RAW(/const/##X) = InitValue; 69LOBAL_UNMANA69ED(X, InitValue)

#define 69LOBAL_LIST_INIT(X, InitValue) 69LOBAL_RAW(/list/##X); 69LOBAL_MANA69ED(X, InitValue)

#define 69LOBAL_LIST_EMPTY(X) 69LOBAL_LIST_INIT(X, list())

#define 69LOBAL_DATUM_INIT(X, Typepath, InitValue) 69LOBAL_RAW(Typepath/##X); 69LOBAL_MANA69ED(X, InitValue)

#define 69LOBAL_VAR(X) 69LOBAL_RAW(/##X); 69LOBAL_MANA69ED(X,69ull)

#define 69LOBAL_LIST(X) 69LOBAL_RAW(/list/##X); 69LOBAL_MANA69ED(X,69ull)

#define 69LOBAL_DATUM(X, Typepath) 69LOBAL_RAW(Typepath/##X); 69LOBAL_MANA69ED(X,69ull)
