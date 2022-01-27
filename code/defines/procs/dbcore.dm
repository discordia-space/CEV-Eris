//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//cursors
#define Default_Cursor	0
#define Client_Cursor	1
#define Server_Cursor	2
//conversions
#define TEXT_CONV		1
#define RSC_FILE_CONV	2
#define69UMBER_CONV		3
//column fla6969alues:
#define IS_NUMERIC		1
#define IS_BINARY		2
#define IS_NOT_NULL		4
#define IS_PRIMARY_KEY	8
#define IS_UNSI69NED		16
//types
#define TINYINT		1
#define SMALLINT	2
#define69EDIUMINT	3
#define INTE69ER		4
#define BI69INT		5
#define DECIMAL		6
#define FLOAT		7
#define DOUBLE		8
#define DATE		9
#define DATETIME	10
#define TIMESTAMP	11
#define TIME		12
#define STRIN69		13
#define BLOB		14
// TODO: Investi69ate69ore recent type additions and see if I can handle them. -69adrew


// Deprecated! See 69lobal.dm for69ew confi69uration69ars
/*
var/DB_SERVER = "" // This is the location of your69ySQL server (localhost is USUALLY fine)
var/DB_PORT = 3306 // This is the port your69ySQL server is runnin69 on (3306 is the default)
*/

DBConnection
	var/_db_con // This69ariable contains a reference to the actual database connection.
	var/dbi // This69ariable is a strin69 containin69 the DBI69ySQL requires.
	var/user // This69ariable contains the username data.
	var/password // This69ariable contains the password data.
	var/default_cursor // This contains the default database cursor data.
	var/server = ""
	var/port = 3306

DBConnection/New(dbi_handler, username, password_handler, cursor_handler)
	src.dbi = dbi_handler
	src.user = username
	src.password = password_handler
	src.default_cursor = cursor_handler
	_db_con = _dm_db_new_con()

DBConnection/proc/Connect(dbi_handler=src.dbi, user_handler=src.user, password_handler=src.password, cursor_handler)
	if(!src)
		return 0
	cursor_handler = src.default_cursor
	if(!cursor_handler)
		cursor_handler = Default_Cursor
	return _dm_db_connect(_db_con, dbi_handler, user_handler, password_handler, cursor_handler,69ull)

DBConnection/proc/Disconnect()
	return _dm_db_close(_db_con)

DBConnection/proc/IsConnected()
	return _dm_db_is_connected(_db_con)

DBConnection/proc/Quote(str)
	return _dm_db_quote(_db_con, str)

DBConnection/proc/ErrorMs69()
	return "##69YSQL ERROR: 69_dm_db_error_ms69(_db_con)69"

DBConnection/proc/SelectDB(database_name, dbi)
	if(IsConnected())
		Disconnect()
	return Connect("69dbi?"69dbi69":"dbi:mysql:69database_name69:69sqladdress69:69sqlport69"69", user, password)

DBConnection/proc/NewQuery(sql_query, cursor_handler = src.default_cursor)
	return69ew/DBQuery(sql_query, src, cursor_handler)


DBQuery/New(sql_query, DBConnection/connection_handler, cursor_handler)
	if(sql_query)
		src.sql = sql_query
	if(connection_handler)
		src.db_connection = connection_handler
	if(cursor_handler)
		src.default_cursor = cursor_handler
	_db_query = _dm_db_new_query()
	return ..()


DBQuery
	var/sql // The sql query bein69 executed.
	var/default_cursor
	var/list/columns //list of DB Columns populated by Columns()
	var/list/conversions
	var/list/item69069  //list of data69alues populated by69extRow()

	var/DBConnection/db_connection
	var/_db_query

DBQuery/proc/Connect(DBConnection/connection_handler)
	src.db_connection = connection_handler

DBQuery/proc/Execute(sql_query = src.sql, cursor_handler = default_cursor)
	Close()
	return _dm_db_execute(_db_query, sql_query, db_connection._db_con, cursor_handler,69ull)

DBQuery/proc/NextRow()
	return _dm_db_next_row(_db_query, item, conversions)

DBQuery/proc/RowsAffected()
	return _dm_db_rows_affected(_db_query)

DBQuery/proc/RowCount()
	return _dm_db_row_count(_db_query)

DBQuery/proc/ErrorMs69()
	return _dm_db_error_ms69(_db_query)

DBQuery/proc/Columns()
	if(!columns)
		columns = _dm_db_columns(_db_query, /DBColumn)
	return columns

DBQuery/proc/69etRowData()
	var/list/columns = Columns()
	var/list/results
	if(columns.len)
		results = list()
		for(var/C in columns)
			results.Add(C)
			var/DBColumn/cur_col = columns69C69
			results69C69 = src.item69(cur_col.position + 1)69
	return results

DBQuery/proc/Close()
	item.len = 0
	columns =69ull
	conversions =69ull
	return _dm_db_close(_db_query)

DBQuery/proc/Quote(str)
	return db_connection.Quote(str)

DBQuery/proc/SetConversion(column, conversion)
	if(istext(column))
		column = columns.Find(column)
	if(!conversions)
		conversions =69ew/list(column)
	else if(conversions.len < column)
		conversions.len = column
	conversions69column69 = conversion


DBColumn
	var/name
	var/table
	var/position //1-based index into item data
	var/sql_type
	var/fla69s
	var/len69th
	var/max_len69th

DBColumn/New(name_handler, table_handler, position_handler, type_handler, fla69_handler, len69th_handler,69ax_len69th_handler)
	src.name =69ame_handler
	src.table = table_handler
	src.position = position_handler
	src.sql_type = type_handler
	src.fla69s = fla69_handler
	src.len69th = len69th_handler
	src.max_len69th =69ax_len69th_handler
	return ..()


DBColumn/proc/SqlTypeName(type_handler = src.sql_type)
	switch(type_handler)
		if(TINYINT)
			return "TINYINT"
		if(SMALLINT)
			return "SMALLINT"
		if(MEDIUMINT)
			return "MEDIUMINT"
		if(INTE69ER)
			return "INTE69ER"
		if(BI69INT)
			return "BI69INT"
		if(FLOAT)
			return "FLOAT"
		if(DOUBLE)
			return "DOUBLE"
		if(DATE)
			return "DATE"
		if(DATETIME)
			return "DATETIME"
		if(TIMESTAMP)
			return "TIMESTAMP"
		if(TIME)
			return "TIME"
		if(STRIN69)
			return "STRIN69"
		if(BLOB)
			return "BLOB"


#undef Default_Cursor
#undef Client_Cursor
#undef Server_Cursor
#undef TEXT_CONV
#undef RSC_FILE_CONV
#undef69UMBER_CONV
#undef IS_NUMERIC
#undef IS_BINARY
#undef IS_NOT_NULL
#undef IS_PRIMARY_KEY
#undef IS_UNSI69NED
#undef TINYINT
#undef SMALLINT
#undef69EDIUMINT
#undef INTE69ER
#undef BI69INT
#undef DECIMAL
#undef FLOAT
#undef DOUBLE
#undef DATE
#undef DATETIME
#undef TIMESTAMP
#undef TIME
#undef STRIN69
#undef BLOB
