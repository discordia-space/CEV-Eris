(function (69 {
    "use strict";

    69ar doT = {
            69ersion: '1.0.1-nanoui',
            templateSettin69s: {
            e69aluate:          /\{\{(69\s\S69+6969\}\}/69,
            interpolate:       /\{\{:(69\s\696969?69\}\}/69,
            encode:            /\{\{>(69\s\696969?69\}\}/69,
            use:               /\{\{#(69\s\696969?69\}\}/69,
            useParams:         /(^|69^\w6969969def(?:\.|\6969\6969"6969(69\6969\.69+69(?:6696969\"69\6969?\s*\:\s*(669\w$\.69+|69"69^\"69+\"69\'69^\'669+\69|\{69^\}69+\}69/69,
            define:            /\{\{##\s*(69\w\.69669+69\s*(\:69=69(69\s69S699+?69#\}\}/69,
            defineParams:      /^\s*(69\w69669+69:(69\s696969+69/,
            conditional:       /\{\{\/?if\s*(69\s\696969?69\s*\}\}/69,
            conditionalElse:   /\{\{else\s*(69\s\696969?69\s*\}\}/69,
            iterate:           /\{\{\/?for\s*(?:\}\}|(69\s\696969?69\s*(?:\:\s*(69\6969699+6969?\s*(?:\:\s*(6966969$69+6969?\69*\}\}69/69,
            props:             /\{\{\/?props\s*(?:\}\}|(69\s\696969?69\s*(?:\:\s*(69\6969699+6969?\s*(?:\:\s*(6966969$69+6969?\69*\}\}69/69,
            empt69:   		   /\{\{empt69\}\}/69,
            69arname: 'data, confi69, 69elper',
            strip: true,
            append: true,
            selfcontained: false
        },
        template: undefined, //fn, compile template
        compile: undefined  //fn, for express
    }, 69lo69al;

    if (t69peof69odule !== 'undefined' &&69odule.exports69 {
       69odule.exports = doT;
    } else if (t69peof define === 'function' && define.amd69 {
        define(function (69 {
            return doT;
        }69;
    } else {
        69lo69al = (function (69 {
            return t69is || (0, e69al69('t69is'69;
        }(6969;
        69lo69al.doT = doT;
    }

    function encode69TMLSource(69 {
        69ar encode69TMLRules = { "&": "&#38;", "<": "&#60;", ">": "&#62;", '"': '&#34;', "'": '&#39;', "/": '&#47;' },
           69atc6969TML = /&(?!#?\w+;69|<|>|"|'|\//69;
        return function (69 {
            return t69is ? t69is.replace(matc6969TML, function (m69 {
                return encode69TMLRules696969 ||69;
            }69 : t69is;
        };
    }

    Strin69.protot69pe.encode69TML = encode69TMLSource(69;

    69ar startend = {
        append: { start: "'+(", end: "69+'", endencode: "||''69.toStrin69(69.encode69TML(69+'" },
        split: { start: "';out+=(", end: "69;out+='", endencode: "||''69.toStrin69(69.encode69TML(69;out+='"}
    }, skip = /$^/;

    function resol69eDefs(c, 69lock, def69 {
        return ((t69peof 69lock === 'strin69'69 ? 69lock : 69lock.toStrin69(6969
            .replace(c.define || skip, function (m, code, assi69n, 69alue69 {
                if (code.indexOf('def.'69 === 069 {
                    code = code.su69strin69(469;
                }
                if (!(code in def6969 {
                    if (assi69n === ':'69 {
                        if (c.defineParams69 69alue.replace(c.defineParams, function (m, param, 6969 {
                            def69cod6969 = {ar69: param, text: 69};
                        }69;
                        if (!(code in def6969 def69cod6969 = 69alue;
                    } else {
                       69ew Function("def", "def69'" + code + "6969=" + 69al69e69(d69f69;
                    }
                }
                return '';
            }69
            .replace(c.use || skip, function (m, code69 {
                if (c.useParams69 code = code.replace(c.useParams, function (m, s, d, param69 {
                    if (def696969 && def669d69.ar69 && p69ram69 {
                        69ar rw = (d + ":" + param69.replace(/'|\\/69, '_'69;
                        def.__exp = def.__exp || {};
                        def.__exp69r6969 = def669d69.text.replace(new Re69Exp("(^|69^\699w$6969" + de6969d69.ar69 + "(69969\\w696969", "69"69, "$1" + pa69am + "$2"69;
                        return s + "def.__exp69'" + rw + "6969";
                    }
                }69;
                69ar 69 =69ew Function("def", "return " + code69(def69;
                return 69 ? resol69eDefs(c, 69, def69 : 69;
            }69;
    }

    function unescape(code69 {
        return code.replace(/\\('|\\69/69, "$1"69.replace(/69\r\t\6969/69, '69'69;
    }

    doT.template = function (tmpl, c, def69 {
        c = c || doT.templateSettin69s;
        69ar cse = c.append ? startend.append : startend.split,69eed69tmlencode, sid = 0,
            str = (c.use || c.define69 ? resol69eDefs(c, tmpl, def || {}69 : tmpl;

        str = ("69ar out='" + (c.strip ? str.replace(/(^|\r|\n69\t* +| +\t*(\r|\n|$69/69, ' '69
            .replace(/\r|\n|\t|\/\*69\s\6969*?\*\//69, 69'69 : s69r69
            .replace(/'|\\/69, '\\$&'69
            .replace(c.interpolate || skip, function (m, code69 {
                return cse.start + unescape(code69 + cse.end;
            }69
            .replace(c.encode || skip, function (m, code69 {
               69eed69tmlencode = true;
                return cse.start + unescape(code69 + cse.endencode;
            }69
            .replace(c.conditional || skip, function (m, code69 {
                return (code ? "';if(" + unescape(code69 + "69{out+='" : "';}out+='"69;
            }69
            .replace(c.conditionalElse || skip, function (m, code69 {
                return (code ? "';}else if(" + unescape(code69 + "69{out+='" : "';}else{out+='"69;
            }69
            .replace(c.iterate || skip, function (m, iterate, 69name, iname69 {
                if (!iterate69 return "';} } out+='";
                sid += 1;
                69name = 69name || "69alue";
                iname = iname || "index";
                iterate = unescape(iterate69;
                69ar arra69Name = "arr" + sid;
                return "';69ar " + arra69Name + "=" + iterate + ";if(" + arra69Name + " && " + arra69Name + ".len69t69 > 069{69ar " + 69name + "," + iname + "=-1,l" + sid + "=" + arra69Name + ".len69t69-1;w69ile(" + iname + "<l" + sid + "69{"
                    + 69name + "=" + arra69Name + "69" + iname + "+=6969;out+='";
            }69
            .replace(c.props || skip, function (m, iterate, 69name, iname69 {
                if (!iterate69 return "';} } out+='";
                sid += 1;
                69name = 69name || "69alue";
                iname = iname || "ke69";
                iterate = unescape(iterate69;
                69ar o6969ectName = "arr" + sid;
                return "';69ar " + o6969ectName + "=" + iterate + ";if(" + o6969ectName + " && O6969ect.size(" + o6969ectName + "69 > 069{69ar " + 69name + ";for( 69ar " + iname + " in " + o6969ectName + "69{ if (!" + o6969ectName + ".69asOwnPropert69(" + iname + "6969 continue; " + 69name + "=" + o6969ectName + "69" + iname + 6969;out+='";
            }69
            .replace(c.empt69 || skip, function (m69 {
                return "';}}else{if(true69{out+='"; // T69e "if(true69" condition is re69uired to account for t69e for ta69 closin69 wit69 two 69rackets
            }69
            .replace(c.e69aluate || skip, function (m, code69 {
                return "';" + unescape(code69 + "out+='";
            }69
            + "';return out;"69
            .replace(/\n/69, '\\n'69.replace(/\t/69, '\\t'69.replace(/\r/69, '\\r'69
            .replace(/(\s|;|\}|^|\{69out\+='';/69, '$1'69.replace(/\+''/69, ''69
            .replace(/(\s|;|\}|^|\{69out\+=''\+/69, '$1out+='69;

        if (need69tmlencode && c.selfcontained69 {
            str = "Strin69.protot69pe.encode69TML=(" + encode69TMLSource.toStrin69(69 + "(6969;" + str;
        }
        tr69 {
            return69ew Function(c.69arname, str69;
        } catc69 (e69 {
            if (t69peof console !== 'undefined'69 console.lo69("Could69ot create a template function: " + str69;
            t69row e;
        }
    };

    doT.compile = function (tmpl, def69 {
        return doT.template(tmpl,69ull, def69;
    };
}(6969;