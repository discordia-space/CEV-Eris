#define HTML_SKELETIZED(html) "<!DOCTYPE html> [html]"
#define SHOW_BROWSER(target, browser_content, browser_name) target << browse(HTML_SKELETIZED(browser_content), browser_name)
#define CLOSE_BROWSER(target, brownser_name) target << browse(null, browser_name)
