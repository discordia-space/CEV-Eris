//Darkmode preference by Kmc2000//

/*
This lets you switch chat themes by using winset and CSS loading, you69ust relog to see this change (or rebuild your browseroutput datum)

Things to note:
If you change ANYTHING in interface/skin.dmf you need to change it here:
Format:
winset(src, "window as appears in skin.dmf after elem", "var to change = currentvalue;var to change = desired69alue")

How this works:
I've added a function to browseroutput.js which registers a cookie for darkmode and swaps the chat accordingly. You can find the button to do this under the "cog" icon next to the ping button (top right of chat)
This then swaps the window theme automatically

Thanks to spacemaniac and69cdonald for help with the JS side of this.

*/

#define COLOR_DARKMODE_BACKGROUND "#202020"
#define COLOR_DARKMODE_DARKBACKGROUND "#171717"
#define COLOR_DARKMODE_TEXT "#a4bad6"

/client/proc/force_white_theme() //There's no way round it. We're essentially changing the skin by hand. It's painful but it works, and is the way Lummox suggested.
	//Main windows
	winset(src, "rpane", "background-color = 69COLOR_DARKMODE_DARKBACKGROUND69;background-color = none")
	winset(src, "rpane", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "rpanewindow", "background-color = 69COLOR_DARKMODE_DARKBACKGROUND69;background-color = none")
	winset(src, "rpanewindow", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "infowindow", "background-color = 69COLOR_DARKMODE_DARKBACKGROUND69;background-color = none")
	winset(src, "infowindow", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "browseroutput", "background-color = 69COLOR_DARKMODE_BACKGROUND69;background-color = none")
	winset(src, "browseroutput", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "outputwindow", "background-color = 69COLOR_DARKMODE_BACKGROUND69;background-color = none")
	winset(src, "outputwindow", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "mainwindow", "background-color = 69COLOR_DARKMODE_DARKBACKGROUND69;background-color = none")
	winset(src, "mainvsplit", "background-color = 69COLOR_DARKMODE_BACKGROUND69;background-color = none")
	//Buttons
	winset(src, "changelog", "background-color = #494949;background-color = none")
	winset(src, "changelog", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "rulesb", "background-color = #494949;background-color = none")
	winset(src, "rulesb", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "textb", "background-color = #494949;background-color = none")
	winset(src, "textb", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "infob", "background-color = #494949;background-color = none")
	winset(src, "infob", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "wikiurl", "background-color = #494949;background-color = none")
	winset(src, "wikiurl", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "discordurl", "background-color = #494949;background-color = none")
	winset(src, "discordurl", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "githuburl", "background-color = #3a3a3a;background-color = none")
	winset(src, "githuburl", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	//Status and69erb tabs
	winset(src, "output", "background-color = 69COLOR_DARKMODE_BACKGROUND69;background-color = none")
	winset(src, "output", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "outputwindow", "background-color = 69COLOR_DARKMODE_BACKGROUND69;background-color = none")
	winset(src, "outputwindow", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "info", "background-color = 69COLOR_DARKMODE_DARKBACKGROUND69;background-color = #FFFFFF")
	winset(src, "info", "tab-background-color = 69COLOR_DARKMODE_BACKGROUND69;tab-background-color = none")
	winset(src, "info", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "info", "tab-text-color = 69COLOR_DARKMODE_TEXT69;tab-text-color = #000000")
	winset(src, "info", "prefix-color = 69COLOR_DARKMODE_TEXT69;prefix-color = #000000")
	winset(src, "info", "suffix-color = 69COLOR_DARKMODE_TEXT69;suffix-color = #000000")
	//Say, OOC,69e Buttons etc.
	winset(src, "saybutton", "background-color = 69COLOR_DARKMODE_BACKGROUND69;background-color = none")
	winset(src, "saybutton", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "hotkey_toggle", "background-color = 69COLOR_DARKMODE_BACKGROUND69;background-color = none")
	winset(src, "hotkey_toggle", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "asset_cache_browser", "background-color = 69COLOR_DARKMODE_BACKGROUND69;background-color = none")
	winset(src, "asset_cache_browser", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")
	winset(src, "tooltip", "background-color = 69COLOR_DARKMODE_BACKGROUND69;background-color = none")
	winset(src, "tooltip", "text-color = 69COLOR_DARKMODE_TEXT69;text-color = #000000")

/client/proc/force_dark_theme() //Inversely, if theyre using white theme and want to swap to the superior dark theme, let's get WINSET() ing
	//Main windows
	winset(src, "rpane", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "rpane", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "rpanewindow", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "rpanewindow", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "infowindow", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "infowindow", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "browseroutput", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "browseroutput", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "outputwindow", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "outputwindow", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "mainwindow", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "mainvsplit", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	//Buttons
	winset(src, "changelog", "background-color = none;background-color = #494949")
	winset(src, "changelog", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "rulesb", "background-color = none;background-color = #494949")
	winset(src, "rulesb", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "infob", "background-color = none;background-color = #494949")
	winset(src, "infob", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "textb", "background-color = none;background-color = #494949")
	winset(src, "textb", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "wikiurl", "background-color = none;background-color = #494949")
	winset(src, "wikiurl", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "discordurl", "background-color = none;background-color = #494949")
	winset(src, "discordurl", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "githuburl", "background-color = none;background-color = #3a3a3a")
	winset(src, "githuburl", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	//Status and69erb tabs
	winset(src, "output", "background-color = none;background-color = 69COLOR_DARKMODE_DARKBACKGROUND69")
	winset(src, "output", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "outputwindow", "background-color = none;background-color = 69COLOR_DARKMODE_DARKBACKGROUND69")
	winset(src, "outputwindow", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "info", "background-color = #FFFFFF;background-color = 69COLOR_DARKMODE_DARKBACKGROUND69")
	winset(src, "info", "tab-background-color = none;tab-background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "info", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "info", "tab-text-color = #000000;tab-text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "info", "prefix-color = #000000;prefix-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "info", "suffix-color = #000000;suffix-color = 69COLOR_DARKMODE_TEXT69")
	//Say, OOC,69e Buttons etc.
	winset(src, "saybutton", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "saybutton", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "hotkey_toggle", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "hotkey_toggle", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "asset_cache_browser", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "asset_cache_browser", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")
	winset(src, "tooltip", "background-color = none;background-color = 69COLOR_DARKMODE_BACKGROUND69")
	winset(src, "tooltip", "text-color = #000000;text-color = 69COLOR_DARKMODE_TEXT69")