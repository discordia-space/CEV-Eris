#define HTML_SKELETIZED(html) "<!DOCTYPE html> [html]"
#define SHOW_BROWSER(target, browser_content, browser_name) target << browse(HTML_SKELETIZED(browser_content), browser_name)
#define UPDATE_ASSETS(target, browser_content, browser_name) target << browse(browser_content, browser_name) // for when it IS NOT html
#define CLOSE_BROWSER(target, browser_name) target << browse(null, browser_name)
