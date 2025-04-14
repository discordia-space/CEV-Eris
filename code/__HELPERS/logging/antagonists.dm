// TODO: LOGGING FOR UPLINKS

/// Logging for items purchased from a traitor uplink
/proc/log_uplink(text, list/data)
	logger.Log(LOG_CATEGORY_UPLINK, text, data)
