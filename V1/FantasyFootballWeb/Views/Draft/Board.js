

$(document).ready(function () {
    
    loadBoard();
    if (year == new Date().getFullYear()) {
        window.setInterval(checkPlayerCount, 10000);
    }



    

});

function loadBoard() {

    var postParams = {};
    postParams.LeagueId = leagueId;
    postParams.Year = year;

    $.getJSON(Main.siteRoot + 'Draft/DraftedPlayers', postParams, function(data){
        $('.pick').empty();
        // loop and set each pick
        for (var i = 0; i < data.Rows.length; i++) {
            var pick = data.Rows[i];
            var html = [];
            html.push('<div class="pick-name">', pick.Name);
            if (pick.IsKeeper) {
                html.push(' (K)');
            }
            html.push('</div>', pick.Position, ', ', pick.NFLTeam, ', ', pick.Round, '-', pick.Overall, ', ', Math.round(pick.Overall - pick.ADP));
            //if (pick.Overall < pick.ADP) {
            //    //bad choice
            //    html.push('<div style="padding-top:10px"><span class="circle circle-good">&nbsp;&nbsp;&nbsp;</span><span style="padding-left:15px">')
            //    html.push(pick.Overall, ' vs ', pick.ADP)
            //    html.push('</span></div>')
            //} else if (pick.Overall > pick.ADP) {
            //    //good pick
            //    html.push('<div class="ui-icon ui-icon-check"></div>')
            //}
            $('#pick-' + pick.Overall.toString()).html(html.join(''));
            $('#pick-' + pick.Overall.toString()).addClass('pick-' + pick.Position);
            if (pick.IsKeeper) {
                $('#pick-' + pick.Overall.toString()).addClass('pick-keeper');
            }

        }
        
    });
        
}

function checkPlayerCount() {
    $.getJSON(Main.siteRoot + 'Draft/DraftedPlayerCount', { LeagueId: leagueId, Year: year }, function (data) {
        if (data.DraftedPlayerCount !== draftedPlayerCount) {
            loadBoard();
        }
    });
}