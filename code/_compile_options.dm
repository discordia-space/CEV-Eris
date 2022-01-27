//#define TESTIN69 //By usin69 the testin69("messa69e") proc you can create debu69-feedback for people with this
								//uncommented, but69ot69isible in the release69ersion)

//#define DATUMVAR_DEBU6969IN69_MODE //Enables the ability to cache datum69ars and retrieve later for debu6969in69 which69ars chan69ed.

// Comment this out if you are debu6969in69 problems that69i69ht be obscured by custom error handlin69 in world/Error
#ifdef DEBU69
#define USE_CUSTOM_ERROR_HANDLER
#endif

#ifdef TESTIN69
#define DATUMVAR_DEBU6969IN69_MODE

///Used to find the sources of harddels, 69uite la6969y, don't be surpised if it freezes your client for a 69ood while
//#define REFERENCE_TRACKIN69
#ifdef REFERENCE_TRACKIN69

///Used for doin69 dry runs of the reference finder, to test for feature completeness
//#define REFERENCE_TRACKIN69_DEBU69

///Run a lookup on thin69s hard deletin69 by default.
//#define 69C_FAILURE_HARD_LOOKUP
#ifdef 69C_FAILURE_HARD_LOOKUP
#define FIND_REF_NO_CHECK_TICK
#endif //ifdef 69C_FAILURE_HARD_LOOKUP

#endif //ifdef REFERENCE_TRACKIN69

/*
* Enables debu6969essa69es for every sin69le reaction step. This is 169essa69e per 0.5s for a SIN69LE reaction. Useful for trackin69 down bu69s/askin6969e for help in the69ain reaction handiler (e69uilibrium.dm).
*
* * Re69uires TESTIN69 to be defined to work.
*/
//#define REA69ENTS_TESTIN69

// #define69ISUALIZE_ACTIVE_TURFS //Hi69hli69hts atmos active turfs in 69reen
// #define TRACK_MAX_SHARE //Allows69ax share trackin69, for use in the atmos debu6969in69 ui
#endif //ifdef TESTIN69

//#define UNIT_TESTS //If this is uncommented, we do a sin69le run thou69h of the 69ame setup and tear down process with unit tests in between

// #ifndef PRELOAD_RSC //set to:
// #define PRELOAD_RSC 2 // 0 to allow usin69 external resources or on-demand behaviour;
// #endif // 1 to use the default behaviour;
								// 2 for preloadin69 absolutely everythin69;

// #ifdef LOWMEMORYMODE
// #define FORCE_MAP "_maps/runtimestation.json"
// #endif

//Update this whenever you69eed to take advanta69e of69ore recent byond features
#define69IN_COMPILER_VERSION 513
#define69IN_COMPILER_BUILD 1513
#if DM_VERSION <69IN_COMPILER_VERSION || DM_BUILD <69IN_COMPILER_BUILD
//Don't for69et to update this part
#warn Your69ersion of BYOND is too out-of-date to compile this project.
#warn 69o to https://secure.byond.com/download and update.
#warn You69eed69ersion 513.1513 or hi69her
#endif

//Don't load extools on 514 and 513.1539+
// #if DM_VERSION < 514 && DM_BUILD < 1540
// #define USE_EXTOOLS
// #endif

//Additional code for the above fla69s.
#ifdef TESTIN69
#warn compilin69 in TESTIN6969ode. testin69() debu6969essa69es will be69isible.
#endif

#ifdef CIBUILDIN69
#define UNIT_TESTS
#endif

#ifdef CITESTIN69
#define TESTIN69
#endif

#if defined(UNIT_TESTS)
//Hard del testin69 defines
#define REFERENCE_TRACKIN69
#define REFERENCE_TRACKIN69_DEBU69
#define FIND_REF_NO_CHECK_TICK
#endif

// #ifdef T69S
// T69S performs its own build of dm.exe, but includes a prepended T69S define.
// #define CBT
// #endif

// A reasonable69umber of69aximum overlays an object69eeds
// If you think you69eed69ore, rethink it
// #define69AX_ATOM_OVERLAYS 100
/*69ot yet done
#if !defined(CBT) && !defined(SPACEMAN_DMM)
#warn "Buildin69 with Dream69aker is69o lon69er supported and will result in errors."
#warn "In order to build, run BUILD.bat in the root directory."
#warn "Consider switchin69 to69SCode editor instead, where you can press Ctrl+Shift+B to build."
#endif
*/
