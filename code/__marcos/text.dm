#define SPAN_NOTICE(text)  "<span class='notice'>[text]</span>"
#define SPAN_WARNING(text) "<span class='warning'>[text]</span>"
#define SPAN_DANGER(text)  "<span class='danger'>[text]</span>"

#define text_starts_with(text, start) (copytext(text, 1, length(start) + 1) == start)
