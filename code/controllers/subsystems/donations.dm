// keeps track of iriski

SUBSYSTEM_DEF(donations)
	name = "Donations"
	init_order = INIT_ORDER_DONATION
	flags = SS_NO_FIRE

/datum/controller/subsystem/donations/Initialize()
	// load stuff
	if(!config.sql_enabled)
		log_debug("Donation system is disabled due to disable of SQL")
		return

	if(!config.donation_track)
		log_debug("Donations system is disabled by configuration!")
		return

	if(establish_don_db_connection())
		log_debug("Donations system successfully connected!")
		UpdateAllClients()
	else
		log_debug("Donations system failed to connect with DB!")

	return ..()

/datum/controller/subsystem/donations/proc/UpdateAllClients()
	set waitfor = 0
	for(var/client/C in clients)
		log_client_to_db(C)
		update_donator(C)
		update_donator_items(C)
	log_debug("Donators info were updated!")

/datum/controller/subsystem/donations/proc/log_client_to_db(client/player)
	set waitfor = 0

	if(!establish_don_db_connection())
		return FALSE

	dbcon_don.NewQuery("INSERT IGNORE INTO players (ckey) VALUES '[player.ckey]'")

	return TRUE


/datum/controller/subsystem/donations/proc/update_donator(client/player)
	set waitfor = 0

	if(!establish_don_db_connection())
		return FALSE
	ASSERT(player)

	//var/was_donator = player.player_vault.donator
	var/datum/player_vault/PV = SSpersistence.get_vault_account(player.ckey)

	var/DBQuery/query = dbcon_don.NewQuery({"
		SELECT 
			patron_types.type
		FROM 
			players
		JOIN 
			patron_types ON players.patron_type = patron_types.id
		WHERE 
			ckey = '[player.ckey]'
		LIMIT 0,1
	"})

	query.Execute_safe()

	if(query.NextRow())
		PV.patreon_tier = query.item[1]

	query = dbcon_don.NewQuery({"
		SELECT 
			`change`
		FROM 
			points_transactions
		JOIN 
			players ON players.id = points_transactions.player
		WHERE 
			ckey = '[player.ckey]'
	"})

	query.Execute_safe()

	PV.iriska_balance = 0
	while(query.NextRow())
		PV.iriska_balance += text2num(query.item[1])

	if(PV.patreon_tier != VAULT_PATRON_0)
		PV.donator = TRUE

	// if(!was_donator)
	// 	PV.on_patreon_tier_loaded(player)

	return TRUE

/datum/controller/subsystem/donations/proc/update_donator_items(client/player)
	set waitfor = 0

	if(!establish_don_db_connection())
		return FALSE

	var/DBQuery/query = dbcon_don.NewQuery({"
		SELECT 
			item_data,
			transaction
		FROM 
			store_players_items
		WHERE 
			player = (SELECT id FROM players WHERE ckey = '[player.ckey]')
	"})

	query.Execute_safe()

	while(query.NextRow())
		player.player_vault.create_item(json_decode(query.item[1]), TRUE, transaction_id = text2num(query.item[2]))

	return TRUE

/datum/controller/subsystem/donations/proc/give_item(player_ckey, item_data, transaction_id = null)
	if(!establish_don_db_connection())
		return FALSE
	ASSERT(istext(player_ckey))
	ASSERT(item_data)
	ASSERT(transaction_id == null || isnum(transaction_id))

	var/DBQuery/query = dbcon_don.NewQuery({"
		INSERT INTO
			store_players_items
		VALUES
			(NULL,
			(SELECT id from players WHERE ckey = '[player_ckey]'),
			[transaction_id ? transaction_id : "NULL"],
			NOW(),
			'[item_data]')
	"})

	query.Execute_safe()

	return TRUE

/datum/controller/subsystem/donations/proc/remove_item(transaction_id = null, player)
	if(!establish_don_db_connection())
		return FALSE
	ASSERT(isnum(transaction_id))

	log_debug("\[Donations DB] Transaction [transaction_id] item deletion is called! User is '[player]'.")

	var/DBQuery/query = dbcon_don.NewQuery({"
		DELETE FROM
			store_players_items
		WHERE
			transaction = [transaction_id]
	"})

	query.Execute_safe()

/datum/controller/subsystem/donations/proc/create_transaction(client/player, change, type, comment)
	if(!establish_don_db_connection())
		return FALSE
	ASSERT(player)
	ASSERT(isnum(change))

	update_donator(player)
	if(!player) // check if player was gone away, while we were updating him
		return FALSE

	if(player.player_vault.iriska_balance + change < 0)
		return FALSE

	var/DBQuery/query = dbcon_don.NewQuery({"
		INSERT INTO
			points_transactions
		VALUES (
			NULL,
			(SELECT id FROM players WHERE ckey = '[player.ckey]'),
			(SELECT id FROM points_transactions_types WHERE type = '[type]'),
			NOW(),
			[change],
			'[comment]')
	"})

	query.Execute_safe()

	var/transaction_id
	query = dbcon_don.NewQuery({"
		SELECT 
			id
		FROM 
			points_transactions
		WHERE
			player = (SELECT id FROM players WHERE ckey = '[player.ckey]') 
			AND
			comment = '[comment]'
		ORDER BY 
			id 
			DESC
	"})

	query.Execute_safe()

	if(query.NextRow())
		transaction_id = query.item[1]

	update_donator(player)

	return text2num(transaction_id)


/datum/controller/subsystem/donations/proc/remove_transaction(client/player, id)
	if(!establish_don_db_connection())
		return FALSE
	ASSERT(isnum(id))

	log_debug("\[Donations DB] Transaction [id] rollback is called! User is '[player]'.")

	var/DBQuery/query = dbcon_don.NewQuery({"
		DELETE FROM
			points_transactions
		WHERE
			id = [id]
	"})

	query.Execute_safe()

	if(player)
		update_donator(player)
	return TRUE