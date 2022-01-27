// /data/ files store data in string format.
// They don't contain other logic for69ow.
/datum/computer_file/data/news_article
	filetype = "XNML"
	filename = "Unknown69ews Entry"
	block_size = 5000 		// Results in smaller files
	read_only = 1			// Editing the file breaks69ost formatting due to some HTML tags69ot being accepted as input from average user.
	var/server_file_path 	// File path to HTML file that will be loaded on server start. Example: '/news_articles/space_magazine_1.html'. Use the /news_articles/ folder!
	var/archived			// Set to 1 for older stuff
	var/cover				//filename of cover.

/datum/computer_file/data/news_article/New(var/load_from_file = 0)
	..()
	if(server_file_path && load_from_file)
		stored_data = file2text(server_file_path)
	calculate_size()


//69EWS DEFINITIONS BELOW THIS LINE

//TODO:69ake this69ore69odular so69ew entries don't require a PR, perhaps SQL Database integration.