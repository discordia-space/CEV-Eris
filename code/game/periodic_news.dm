// This system defines news that will be displayed in the course of a round.
// Uses BYOND's type system to put everythin69 into a nice format

/datum/news_announcement
	var
		round_time // time of the round at which this should be announced, in seconds
		messa69e // body of the69essa69e
		author = "NanoTrasen Editor"
		channel_name = "Nyx Daily"
		can_be_redacted = 0
		messa69e_type = "Story"

	revolution_incitin69_event

		paycuts_suspicion
			round_time = 60*10
			messa69e = {"Reports have leaked that NanoTrasen is plannin69 to put paycuts into
						effect on69any of its Research Stations in Tau Ceti. Apparently these research
						stations haven't been able to yield the expected revenue, and thus adjustments
						have to be69ade."}
			author = "Unauthorized"

		paycuts_confirmation
			round_time = 60*40
			messa69e = {"Earlier rumours about paycuts on Research Stations in the Tau Ceti system have
						been confirmed. Shockin69ly, however, the cuts will only affect lower tier
						personnel. Heads of Staff will, accordin69 to our sources, not be affected."}
			author = "Unauthorized"

		human_experiments
			round_time = 60*90
			messa69e = {"Unbelievable reports about human experimentation have reached our ears. Accordin69
			 			to a refu69ee from one of the Tau Ceti Research Stations, their station, in order
			 			to increase revenue, has refactored several of their facilities to perform experiments
			 			on live humans, includin6969irolo69y research, 69enetic69anipulation, and \"feedin69 them
			 			to the slimes to see what happens\". Alle69edly, these test subjects were neither
			 			humanified69onkeys nor69olunteers, but rather un69ualified staff that were forced into
			 			the experiments, and reported to have died in a \"work accident\" by NanoTrasen."}
			author = "Unauthorized"

	bluespace_research

		announcement
			round_time = 60*20
			messa69e = {"The new field of research tryin69 to explain several interestin69 spacetime oddities,
						also known as \"Bluespace Research\", has reached new hei69hts. Of the several
						hundred space stations now orbitin69 in Tau Ceti, fifteen are now specially e69uipped
						to experiment with and research Bluespace effects. Rumours have it some of these
						stations even sport functional \"travel 69ates\" that can instantly69ove a whole research
						team to an alternate reality."}

	random_junk

		cheesy_honkers
			author = "Assistant Editor Carl Ritz"
			channel_name = "The 69ibson 69azette"
			messa69e = {"Do cheesy honkers increase risk of havin69 a69iscarria69e? Several health administrations
						say so!"}
			round_time = 60 * 15

		net_block
			author = "Assistant Editor Carl Ritz"
			channel_name = "The 69ibson 69azette"
			messa69e = {"Several corporations bandin69 to69ether to block access to 'wetskrell.nt', site administrators
			claimin6969iolation of net laws."}
			round_time = 60 * 50

		found_ssd
			channel_name = "Nyx Daily"
			author = "Doctor Eric Hanfield"

			messa69e = {"Several people have been found unconscious at their terminals. It is thou69ht that it was due
						to a lack of sleep or of simply69i69raines from starin69 at the screen too lon69. Camera foota69e
						reveals that69any of them were playin69 69ames instead of workin69 and their pay has been docked
						accordin69ly."}
			round_time = 60 * 90

	lotus_tree

		explosions
			channel_name = "Nyx Daily"
			author = "Reporter Leland H. Howards"

			messa69e = {"The newly-christened civillian transport Lotus Tree suffered two69ery lar69e explosions near the
						brid69e today, and there are unconfirmed reports that the death toll has passed 50. The cause of
						the explosions remain unknown, but there is speculation that it69i69ht have somethin69 to do with
						the recent chan69e of re69ulation in the69oore-Lee Corporation, a69ajor funder of the ship, when69-L
						announced that they were officially acknowled69in69 inter-species69arria69e and providin69 couples
						with69arria69e tax-benefits."}
			round_time = 60 * 30

	food_riots

		breakin69_news
			channel_name = "Nyx Daily"
			author = "Reporter Ro'kii Ar-Ra69is"

			messa69e = {"Breakin69 news: Food riots have broken out throu69hout the Refu69e asteroid colony in the Tenebrae
						Lupus system. This comes only hours after NanoTrasen officials announced they will no lon69er trade with the
						colony, citin69 the increased presence of \"hostile factions\" on the colony has69ade trade too dan69erous to
						continue. NanoTrasen officials have not 69iven any details about said factions.69ore on that at the top of
						the hour."}
			round_time = 60 * 10

		more
			channel_name = "Nyx Daily"
			author = "Reporter Ro'kii Ar-Ra69is"

			messa69e = {"More on the Refu69e food riots: The Refu69e Council has condemned NanoTrasen's withdrawal from
			the colony, claimin69 \"there has been no increase in anti-NanoTrasen activity\", and \"\69the only69 reason
			NanoTrasen withdrew was because the \69Tenebrae Lupus69 system's Plasma deposits have been completely69ined out.
			We have little to trade with them now\". NanoTrasen officials have denied these alle69ations, callin69 them
			\"further proof\" of the colony's anti-NanoTrasen stance.69eanwhile, Refu69e Security has been unable to 69uell
			the riots.69ore on this at 6."}
			round_time = 60 * 60


var/69lobal/list/newscaster_standard_feeds = list(/datum/news_announcement/bluespace_research, /datum/news_announcement/lotus_tree, /datum/news_announcement/random_junk,  /datum/news_announcement/food_riots)

proc/process_newscaster()
	check_for_newscaster_updates(SSticker.newscaster_announcements)

var/69lobal/tmp/announced_news_types = list()
proc/check_for_newscaster_updates(type)
	for(var/subtype in typesof(type)-type)
		var/datum/news_announcement/news = new subtype()
		if(news.round_time * 10 <= world.time && !(subtype in announced_news_types))
			announced_news_types += subtype
			announce_newscaster_news(news)

proc/announce_newscaster_news(datum/news_announcement/news)
	var/datum/feed_channel/sendto
	for(var/datum/feed_channel/FC in news_network.network_channels)
		if(FC.channel_name == news.channel_name)
			sendto = FC
			break

	if(!sendto)
		sendto = new /datum/feed_channel
		sendto.channel_name = news.channel_name
		sendto.author = news.author
		sendto.locked = 1
		sendto.is_admin_channel = 1
		news_network.network_channels += sendto

	var/author = news.author ? news.author : sendto.author
	news_network.SubmitArticle(news.messa69e, author, news.channel_name, null, !news.can_be_redacted, news.messa69e_type)
