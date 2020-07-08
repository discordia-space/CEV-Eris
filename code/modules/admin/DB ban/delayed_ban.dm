GLOBAL_LIST_EMPTY(delayed_bans)

/datum/delayed_ban
	var/target_id
	var/ip
	var/server
	var/bantype_str
	var/reason
	var/job
	var/duration
	var/computerid
	var/banned_by_id

/datum/delayed_ban/New(_target_id, _server, _bantype_str , _reason, _job, _duration, _computerid, _banned_by_id, _ip)
	. = ..()
	target_id = _target_id
	ip = _ip
	server = _server
	bantype_str = _bantype_str
	reason = _reason
	job = _job
	duration = _duration
	computerid = _computerid
	banned_by_id = _banned_by_id

/datum/delayed_ban/proc/execute()
	var/DBQuery/query_insert = dbcon.NewQuery({"INSERT INTO bans (target_id, time, server, type, reason, job, duration, expiration_time, cid, ip, banned_by_id) VALUES ([target_id], Now(), '[server]', '[bantype_str]', '[reason]', '[job]', [(duration)?"[duration]":"0"], Now() + INTERVAL [(duration>0) ? duration : 0] MINUTE, '[computerid]', NULL, [banned_by_id])"})
	query_insert.Execute()

/hook/roundend/proc/explode()
	for(var/datum/delayed_ban/temp in GLOB.delayed_bans)
		if(istype(temp))
			temp.execute()
