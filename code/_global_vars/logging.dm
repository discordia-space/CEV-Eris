// Number for the database
GLOBAL_VAR(round_id)
GLOBAL_PROTECT(round_id)

/// The directory in which ALL log files should be stored
GLOBAL_VAR(log_directory)
GLOBAL_PROTECT(log_directory)

#define DECLARE_LOG_NAMED(log_var_name, log_file_name, start)\
GLOBAL_VAR(##log_var_name);\
GLOBAL_PROTECT(##log_var_name);\
/world/_initialize_log_files(temp_log_override = null){\
	..();\
	GLOB.##log_var_name = temp_log_override || "[GLOB.log_directory]/[##log_file_name].log";\
	if(!temp_log_override && ##start){\
		start_log(GLOB.##log_var_name);\
	}\
}

#define DECLARE_LOG(log_name, start) DECLARE_LOG_NAMED(##log_name, "[copytext(#log_name, 1, length(#log_name) - 4)]", start)
#define START_LOG TRUE
#define DONT_START_LOG FALSE

/// Populated by log declaration macros to set log file names and start messages
/world/proc/_initialize_log_files(temp_log_override = null)
	// Needs to be here to avoid compiler warnings
	SHOULD_CALL_PARENT(TRUE)
	return

// All individual log files.
// These should be used where the log category cannot easily be a json log file.
DECLARE_LOG(config_error_log, DONT_START_LOG)
DECLARE_LOG(perf_log, DONT_START_LOG) // Declared here but name is set in time_track subsystem

/// All admin related log lines minus their categories
GLOBAL_LIST_EMPTY(admin_activities)
GLOBAL_PROTECT(admin_activities)

/// All bomb related messages
GLOBAL_LIST_EMPTY(bombers)
GLOBAL_PROTECT(bombers)

/// Stores who uploaded laws to which silicon-based lifeform, and what the law was
GLOBAL_LIST_EMPTY(lawchanges)
GLOBAL_PROTECT(lawchanges)

#undef DECLARE_LOG
#undef DECLARE_LOG_NAMED
#undef START_LOG
#undef DONT_START_LOG
