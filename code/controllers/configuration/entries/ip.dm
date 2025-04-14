//Should we query IPs to get scores? Generates HTTP traffic to an API service.
/datum/config_entry/flag/ip_reputation
	default = FALSE

//Left null because you MUST specify one otherwise you're making the internet worse.
/datum/config_entry/string/ipr_email

/datum/config_entry/string/ipr_email/ValidateAndSet(str_val)
	. = str_val != "example@example.com" && ..()


//Should we block anyone who meets the minimum score below? Otherwise we just log it (If paranoia logging is on, visibly in chat).
/datum/config_entry/flag/ipr_block_bad_ips
	default = FALSE

//The API returns a value between 0 and 1 (inclusive), with 1 being 'definitely VPN/Tor/Proxy'. Values equal/above this var are considered bad.
/datum/config_entry/number/ipr_bad_score
	default = 1
	integer = TRUE

//Should we allow known players to use VPNs/Proxies? If the player is already banned then obviously they still can't connect.
/datum/config_entry/flag/ipr_allow_existing
	default = FALSE

//How many days before a player is considered 'fine' for the purposes of allowing them to use VPNs.
/datum/config_entry/number/ipr_minimum_age
	default = 5

//API key for ipqualityscore.com. Optional additional service that can be used if an API key is provided.
/datum/config_entry/string/ipqualityscore_apikey

/datum/config_entry/string/ipqualityscore_apikey/ValidateAndSet(str_val)
	. = str_val != "ABCDEFGHIJKLMAOPQRSTUVQWXYZ" && ..()

