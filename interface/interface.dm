//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = TRUE
	var/wikiurl = config.wikiurl
	if(wikiurl)
		src << link(wikiurl)
	else
		to_chat(src, SPAN_DANGER("The wiki URL is not set in the server configuration."))

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = TRUE
	var/forumurl = config.forumurl
	if(forumurl)
		src << link(forumurl)
	else
		to_chat(src, SPAN_DANGER("The forum URL is not set in the server configuration."))

/client/verb/rules()
	set name = "rules"
	set desc = "Show Server Rules."
	set hidden = TRUE
	var/rulesurl = "https://wiki.cev-eris.com/Rules_ErisEn" // TODO: Move this to the config -- KIROV
	if(rulesurl)
		src << link(rulesurl)
	else
		to_chat(src, SPAN_DANGER("The rules URL is not set in the server configuration."))

/client/verb/github()
	set name = "github"
	set desc = "Visit Github"
	set hidden = TRUE
	var/githuburl = config.githuburl
	if(githuburl)
		src << link(githuburl)
	else
		to_chat(src, SPAN_DANGER("The github URL is not set in the server configuration."))

/client/verb/discord()
	set name = "discord"
	set desc = "Visit Discord"
	set hidden = TRUE
	var/discordurl = config.discordurl
	if(discordurl)
		src << link(discordurl)
	else
		to_chat(src, SPAN_DANGER("The discord URL is not set in the server configuration."))

/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC"
	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.ui_interact(mob)
	if(prefs.lastchangelog != changelog_hash)
		prefs.lastchangelog = changelog_hash
		prefs.save_preferences()
		winset(src, "infowindow.changelog", "font-style=;")

/client/verb/hotkeys_help()
	set name = "Hotkeys Help"
	set category = "OOC"

	//if(!GLOB.hotkeys_tgui)
	//	GLOB.hotkeys_tgui = new /datum/hotkeys_help()

	//GLOB.hotkeys_tgui.ui_interact(mob)
	return
