var allKeywords = allKeywordsString == '' ? [] : allKeywordsString.split('|');
var keywords = [];

function refreshPlayers() {
    playersGrid.store.load();
}

function addKeywordControl(word) {
    keywordPanel.add({
        xtype: 'checkbox',
        boxLabel: word,
        listeners: {
            check: function (cmp, checked) {
                keywordControlCheck(word, checked);
            }
        }
    });
    keywordPanel.doLayout();
}

function keywordControlCheck(word, checked) {
    var index = keywords.indexOf(word);
        
    if (checked) {
        if (index == -1) {
            keywords.push(word);
            filterPlayers();
        }
    } else {
        if (index > -1) {
            keywords.splice(index, 1);
            filterPlayers()
        }
    }

}

function registerKeywords(words) {
    var wordArray = words.split(' ');
    for (var i = 0; i < wordArray.length; i++) {
        if (allKeywords.indexOf(wordArray[i]) == -1) {
            allKeywords.push(wordArray[i]);
            addKeywordControl(wordArray[i]);
        }
    }
}

function loadPlayer(data) {
    Ext.getCmp('txtPlayerId').setValue(data.PlayerId);
    Ext.getCmp('txtName').setValue(data.Name);
    Ext.getCmp('txtPosition').setValue(data.Position);
    Ext.getCmp('txtTeam').setValue(data.NFLTeam);
    Ext.getCmp('txtAge').setValue(data.Age);
    Ext.getCmp('txtExperience').setValue(data.Experience);
    Ext.getCmp('txtDepthChart').setValue(data.DepthChart);
    Ext.getCmp('txtKeywords').setValue(data.Keywords);
    Ext.getCmp('txtComments').setValue(data.Comments);
    Ext.getCmp('txtProjectedPoints').setValue(data.ProjectedPoints);
    Ext.getCmp('txtActualPoints').setValue(data.ActualPoints);
    Ext.getCmp('txtOdds').setValue(data.Odds);
    playerWindow.show();
}

function rebuildKeywords() {

    //send request
    Ext.Ajax.request({
        url: Global.siteRoot + 'Admin/RebuildKeywords',
        params: {
            leagueId: leagueId,
            year: year
        },
        success: function (response, opts) {
            try {
                var obj = Ext.decode(response.responseText);
                if (obj.Result == true) {
                    //Global.alert('Keywords were rebuilt.  Refresh the page to see any changes.');
                    window.location.href = window.location.href;
                } else {
                    Global.alertError('Server-side failure with error ' + obj.Message);
                }
            } catch (e) {
                Global.alertError('Client-side failure with error ' + e.description);
            }

        },
        failure: function (response, opts) {
            Global.alertError('Server-side failure with status code ' + response.status);
        }
    });
}



function savePlayer() {

    var playerId = Ext.getCmp('txtPlayerId');
    var name = Ext.getCmp('txtName');
    var position = Ext.getCmp('txtPosition');
    var team = Ext.getCmp('txtTeam');
    var keywords = Ext.getCmp('txtKeywords');
    var age = Ext.getCmp('txtAge');
    var experience = Ext.getCmp('txtExperience');
    var comments = Ext.getCmp('txtComments');
    var depthChart = Ext.getCmp('txtDepthChart');
    var projectedPoints = Ext.getCmp('txtProjectedPoints');
    var actualPoints = Ext.getCmp('txtActualPoints');
    var odds = Ext.getCmp('txtOdds');

    //validate
    var valid = true;
    if (name.isValid() == false) valid = false;
    if (position.isValid() == false) valid = false;
    if (team.isValid() == false) valid = false;
    if (age.isValid() == false) valid = false;
    if (experience.isValid() == false) valid = false;
    if (depthChart.isValid() == false) valid = false;
    if (!valid)
        return;

    //send request
    Ext.Ajax.request({
        url: Global.siteRoot + 'Admin/SavePlayer',
        params: {
            leagueId: leagueId,
            year: year,
            playerId: playerId.getValue(),
            name: name.getValue(),
            position: position.getValue(),
            team: team.getValue(),
            keywords: keywords.getValue(),
            age: age.getValue(),
            experience: experience.getValue(),
            comments: comments.getValue(), 
            depthChart: depthChart.getValue(),
            projectedPoints: projectedPoints.getValue(),
            actualPoints: actualPoints.getValue(),
            odds: odds.getValue()
        },
        success: function (response, opts) {
            try {
                var obj = Ext.decode(response.responseText);
                if (obj.Result == true) {
                    if (playerId.getValue() == 0) {
                        Ext.getCmp('txtGeneralFilter').setValue(name.getValue());
                    }
                    refreshPlayers();
                    if (keywords.getValue() != '') {
                        registerKeywords(keywords.getValue());
                    }
                    playerWindow.hide();
                } else {
                    Global.alertError('Server-side failure with error ' + obj.Message);
                }
            } catch (e) {
                Global.alertError('Client-side failure with error ' + e.description);
            }

        },
        failure: function (response, opts) {
            Global.alertError('Server-side failure with status code ' + response.status);
        }
    });
}

