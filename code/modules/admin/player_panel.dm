
/datum/admins/proc/player_panel_new()//The new one
	if (!usr.client.holder)
		return
	var/dat = "<html><head><title>Admin Player Panel</title></head>"

	//javascript, the part that does69ost of the work~
	dat += {"

		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch(){


					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != ""){
						var69tbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == ""){
						return;
					}else{

						var69aintable_data = document.getElementById('maintable_data');
						var ltr =69aintable_data.getElementsByTagName("tr");
						for (69ar i = 0; i < ltr.length; ++i )
						{
							try{
								var tr = ltr\69i\69;
								if(tr.getAttribute("id").indexOf("data") != 0){
									continue;
								}
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\690\69;
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\690\69;
								//var inner_span = li.getElementsByTagName("span")\691\69 //Should only ever contain one element.
								//document.write("<p>"+search.innerText+"<br>"+filter+"<br>"+search.innerText.indexOf(filter))
								if ( search.innerText.toLowerCase().indexOf(filter) == -1 )
								{
									//document.write("a");
									//ltr.removeChild(tr);
									td.innerHTML = "";
									i--;
								}
							}catch(err) {   }
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();

				}

				function expand(id,job,name,real_name,image,key,ip,antagonist,ref){

					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";

					body += "</td><td align='center'>";

					body += "<font size='2'><b>"+job+" "+name+"</b><br><b>Real name "+real_name+"</b><br><b>Played by "+key+" ("+ip+")</b></font>"

					body += "</td><td align='center'>";

					body += "<a href='?src=\ref69src69;adminplayeropts="+ref+"'>PP</a> - "
					body += "<a href='?src=\ref69src69;notes=show;mob="+ref+"'>N</a> - "
					body += "<a href='?_src_=vars;Vars="+ref+"'>VV</a> - "
					body += "<a href='?src=\ref69src69;contractor="+ref+"'>TP</a> - "
					body += "<a href='?src=\ref69usr69;priv_msg=\ref"+ref+"'>PM</a> - "
					body += "<a href='?src=\ref69src69;subtlemessage="+ref+"'>SM</a> - "
					body += "<a href='?src=\ref69src69;manup="+ref+"'>MAN_UP</a> - "
					body += "<a href='?src=\ref69src69;viewlogs="+ref+"'>LOGS</a> - "
					body += "<a href='?src=\ref69src69;paralyze="+ref+"'>PARA</a> - "
					body += "<a href='?src=\ref69src69;adminobservejump="+ref+"'>JMP</a><br>"
					if(antagonist > 1)
						body += "<font size='2'><a href='?src=\ref69src69;check_antagonist=1'><font color='red'><b>Antagonist</b></font></a></font>";
					else if(antagonist > 0)
						body += "<font size='2'><font color='red'><b>Limited Antagonist</b></font></font>";
					body += "</td></tr></table>";


					span.innerHTML = body
				}

				function clearAll(){
					var spans = document.getElementsByTagName('span');
					for(var i = 0; i < spans.length; i++){
						var span = spans\69i\69;

						var id = span.getAttribute("id");

						if(!(id.indexOf("item")==0))
							continue;

						var pass = 1;

						for(var j = 0; j < locked_tabs.length; j++){
							if(locked_tabs\69j\69==id){
								pass = 0;
								break;
							}
						}

						if(pass != 1)
							continue;




						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id){
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if(decision == "1"){
						link.setAttribute("name","2");
					}else{
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\69j\69==id){
							pass = 0;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<font color='red'>Locked</font> ";
					//link.setAttribute("onClick","attempt('"+id+"','"+link_id+"','"+notice_span_id+"');");
					//document.write("removeFromLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
					//document.write("aa - "+link.getAttribute("onClick"));
				}

				function attempt(ab){
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id){
					//document.write("a");
					var index = 0;
					var pass = 0;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\69j\69==id){
							pass = 1;
							index = j;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs\69index\69 = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
					//var link = document.getElementById(link_id);
					//link.setAttribute("onClick","addToLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"

	//title + search bar
	dat += {"

		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Player panel</b></font><br>
					Hover over a line to see69ore information - <a href='?src=\ref69src69;check_antagonist=1'>Storyteller Panel</a>
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter'69alue='' style='width:300px;'>
				</td>
			</tr>
	</table>

	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/list/mobs = sortmobs()
	var/i = 1
	for(var/mob/M in69obs)
		if(M.ckey)

			var/color = "#e6e6e6"
			if(i%2 == 0)
				color = "#f2f2f2"
			var/is_antagonist = is_special_character(M)

			var/M_job = ""

			if(isliving(M))

				if(iscarbon(M)) //Carbon stuff
					if(ishuman(M))
						var/mob/living/carbon/human/H =69
						M_job = H.job
					else if(isslime(M))
						M_job = "slime"
					else if(issmall(M))
						M_job = "Monkey"
					else
						M_job = "Carbon-based"

				else if(issilicon(M)) //silicon
					if(isAI(M))
						M_job = "AI"
					else if(ispAI(M))
						M_job = "pAI"
					else if(isrobot(M))
						M_job = "Robot"
					else
						M_job = "Silicon-based"

				else if(isanimal(M)) //simple animals
					if(iscorgi(M))
						M_job = "Corgi"
					else
						M_job = "Animal"

				else
					M_job = "Living"

			else if(isnewplayer(M))
				M_job = "New player"

			else if(isghost(M))
				M_job = "Ghost"
			else
				M_job = "Unknown (69M.type69)"

			M_job = replacetext(M_job, "'", "")
			M_job = replacetext(M_job, "\"", "")
			M_job = replacetext(M_job, "\\", "")

			var/M_name =69.name
			M_name = replacetext(M_name, "'", "")
			M_name = replacetext(M_name, "\"", "")
			M_name = replacetext(M_name, "\\", "")
			var/M_rname =69.real_name
			M_rname = replacetext(M_rname, "'", "")
			M_rname = replacetext(M_rname, "\"", "")
			M_rname = replacetext(M_rname, "\\", "")

			var/M_key =69.key
			M_key = replacetext(M_key, "'", "")
			M_key = replacetext(M_key, "\"", "")
			M_key = replacetext(M_key, "\\", "")

			//output for each69ob
			dat += {"

				<tr id='data69i69' name='69i69' onClick="addToLocked('item69i69','data69i69','notice_span69i69')">
					<td align='center' bgcolor='69color69'>
						<span id='notice_span69i69'></span>
						<a id='link69i69'
						onmouseover='expand("item69i69","69M_job69","69M_name69","69M_rname69","--unused--","69M_key69","69M.lastKnownIP69",69is_antagonist69,"\ref69M69")'
						>
						<span id='search69i69'><b>69M_name69 - 69M_rname69 - 69M_key69 (69M_job69)</b></span>
						</a>
						<br><span id='item69i69'></span>
					</td>
				</tr>

			"}

			i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var69aintable = document.getElementById("maintable_data_archive");
			var complete_list =69aintable.innerHTML;
		</script>
	</body></html>
	"}

	usr << browse(dat, "window=players;size=600x480")


/datum/admins/proc/storyteller_panel()
	if(get_storyteller())
		get_storyteller().storyteller_panel()
	else
		to_chat(usr, SPAN_WARNING("There is no storyteller."))

