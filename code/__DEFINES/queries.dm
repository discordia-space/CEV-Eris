
#define QUERIES_INIT(A) var/list/##A = list() // these defines only work if A is called queries
#define QUERY_SETUP(X, Y, Z...) QUERIES_INIT(queries); QUERY_CATEGORY(X, Y, Z) // queries is used to keep track of all queries and delete them when query time is over
#define QUERY_CATEGORY(X, Y, Z...) SET_QUERY(X, Y, Z) queries.Add(X);
#define SET_QUERY(X, Y, Z...) var/datum/db_query/##X = SSdbcore.NewQuery(Y, Z);
#define QUERY_AGAIN(X, Y, Z...) X = SSdbcore.NewQuery(Y, Z); queries.Add(X)
#define QUERY_REFRESH(X, Y, Z...) qdel(X); X = SSdbcore.NewQuery(Y, Z);
#define END_QUERYING for(var/finishedquery in queries){qdel(finishedquery)} // qdels all queries in order
#define SAFE_END spawn(0){END_QUERYING} // guarantees that all queries are qdeled as soon as the proc ends

#define QUERY_NOW(Y, Z...) SET_QUERY(query, Y, Z)// these two are for when you only have one query var, and no early returns
#define QUERY_FAST(Y, Z...) QUERY_REFRESH(query, Y, Z) // don't forget to put a qdel after the last one, this is the streamlined version.
// it's already mostly standardized, might as well finish the job
#define EXECUTE_OR_ERROR(QUERY, PURPOSE) if(!QUERY.Execute()){log_world("Failed to [PURPOSE]. Error message: [QUERY.ErrorMsg()]."); qdel(QUERY); return}
