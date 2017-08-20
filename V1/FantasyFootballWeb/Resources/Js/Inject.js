/*
bookmarklet:
javascript:(function() {var script = document.createElement("script");script.src = 'http://www.polkspot.net/ff/resources/js/inject.js?id=' + new Date().getTime();var head = document.getElementsByTagName("head")[0];head.appendChild(script);}())
*/

var PAF = function () {

    var internal = {

        dataId: 'paf-data-textarea',

        showData: function (data) {
            if ($('#' + internal.dataId).length) {
                $('#' + internal.dataId).val(data);
            } else {
                //debugger;
                $('body').append('<div id="' + internal.dataId + '-wrap" style="position:absolute;left:0px;top:0px;z-index:99999999"><textarea id="' + internal.dataId + '" rows="25" cols="100">' + data + '</textarea></div>');
                $('body').click(function () {
                    $('#' + internal.dataId + '-wrap').hide();
                });
                $('#' + internal.dataId + '-wrap').click(function (event) {
                    event.stopPropagation();
                });
            }
            $('#' + internal.dataId + '-wrap').show()
            $('#' + internal.dataId).select();
        }
    }

    var external = {

        yahoo: {

            getPoints: function () {

                var sql = [];
                var year = prompt('What year are these points for?', new Date().getFullYear());
                var type = prompt('Are these projected (P) or actual (A) points?', 'P');

                $('.ysf-player-name').each(
	                function () {
	                    //console.log($($(this).parent().parent().parent().nextAll()[2]).find('div').html());
	                    var name = $(this).find('a').html();
	                    var points = parseFloat($($(this).parent().parent().parent().nextAll()[2]).find('div').html());

	                    sql.push('UPDATE FF.Player SET ');
	                    sql.push(type == 'P' ? 'ProjectedPoints' : 'ActualPoints', ' = ', points, ' ');
	                    sql.push('WHERE Year = ', year, ' AND Name = \'', name.replace(/'/g, '\'\''), '\';\n');
	                }
                );
                //console.log(sql);
                internal.showData(sql.join(''));
            }

        },

        cbs: {

            getADP: function () {

                var sql = [];
                $('.data').find('.row1,.row2').each(function () {

                    var name = $(this).find('td:nth-child(2)').find('a').html();
                    var adp = parseFloat($(this).find('td:nth-child(4)').html());

                    sql.push('UPDATE FF.Player SET ');
                    sql.push('ADP = ', adp, ' ');
                    sql.push('WHERE Year = ', new Date().getFullYear(), ' AND Name = \'', name.replace(/'/g, '\'\''), '\';\n');
                });

                internal.showData(sql.join(''));
            }
        }
    }

    var init = function () {

        // include jquery
        javascript: (function () { var el = document.createElement("div"), b = document.getElementsByTagName("body")[0], otherlib = !1, msg = ""; el.style.position = "fixed", el.style.height = "32px", el.style.width = "220px", el.style.marginLeft = "-110px", el.style.top = "0", el.style.left = "50%", el.style.padding = "5px 10px", el.style.zIndex = 9999999, el.style.fontSize = "12px", el.style.color = "#222", el.style.backgroundColor = "#f99"; function showMsg() { var txt = document.createTextNode(msg); el.appendChild(txt), b.appendChild(el), window.setTimeout(function () { txt = null, typeof jQuery == "undefined" ? b.removeChild(el) : (jQuery(el).fadeOut("slow", function () { jQuery(this).remove() }), otherlib && (window.$jq = jQuery.noConflict())) }, 2500) } if (typeof jQuery != "undefined") return msg = "This page already using jQuery v" + jQuery.fn.jquery, showMsg(); typeof $ == "function" && (otherlib = !0); function getScript(url, success) { var script = document.createElement("script"); script.src = url; var head = document.getElementsByTagName("head")[0], done = !1; script.onload = script.onreadystatechange = function () { !done && (!this.readyState || this.readyState == "loaded" || this.readyState == "complete") && (done = !0, success(), script.onload = script.onreadystatechange = null, head.removeChild(script)) }, head.appendChild(script) } getScript("http://code.jquery.com/jquery.min.js", function () { return typeof jQuery == "undefined" ? msg = "Sorry, but jQuery was not able to load" : (msg = "This page is now jQuerified with v" + jQuery.fn.jquery, otherlib && (msg += " and noConflict(). Use $jq(), not $().")), showMsg() }) })();
    } ();

    return external;

} ();