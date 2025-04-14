///Protects a datum from being VV'd or spawned through admin manipulation
// TODO: REENABLE WHEN NEW VV IS IMPLEMENTED
/*
##Path/can_vv_get(var_name){\
 	return FALSE;\
}\
##Path/vv_edit_var(var_name, var_value){\
	return FALSE;\
} */
#ifndef TESTING
#define GENERAL_PROTECT_DATUM(Path)\
##Path/CanProcCall(procname){\
	return FALSE;\
}\
##Path/Read(savefile/savefile){\
	qdel(src);\
}\
##Path/Write(savefile/savefile){\
	return;\
}
#else
#define GENERAL_PROTECT_DATUM(Path)
#endif
