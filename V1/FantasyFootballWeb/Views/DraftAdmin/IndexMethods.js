var isAdmin = true;

var draftClock = new StopWatch();
draftClock.countdown = 120000; // 2 mins
draftClock.onChange = function (clock) {
    Ext.getCmp('clockPanel').body.update(clock.formatTime());
}

function draftPlayer() {
    if (availablePlayersGrid.getSelectionModel().getCount() === 0) {
        Global.alert('Select a player');
        return;
    }
    var overallField = Ext.getCmp('Overall');
    var teamsField = Ext.getCmp('Teams');
    var roundField = Ext.getCmp('Round');
    var isKeeperField = Ext.getCmp('IsKeeper');

    var postParams = {};
    postParams.LeagueId = leagueId;
    postParams.PlayerId = availablePlayersGrid.getSelectionModel().selections.items[0].data.PlayerId;
    postParams.TeamId = teamsField.getValue();
    postParams.IsKeeper = isKeeperField.getValue();
    //postParams.TeamId = 1;
    postParams.Round = roundField.getValue();
    postParams.Overall = overallField.getValue();

    Ext.Ajax.request({
        url: Global.siteRoot + 'DraftAdmin/DraftPlayer',
        params: postParams,
        method: 'POST',
        success: function (response) {
            var ret = Ext.decode(response.responseText);
            if (ret.Result === true) {
                // update the form
                refreshGrids();
                Ext.getCmp('availablePlayersFilter').setValue();
                Ext.getCmp('availablePlayersFilter').focus();
                draftClock.restart();
                setPickFields(ret.NextTeam, ret.NextRound, ret.NextPick);
                isKeeperField.reset();
            } else {
                Global.alertError(ret.Message);
            }
        },
        failure: function (response) {
            if (response.responseText == null)
                Global.alertError("Errors encountered while processing request.  The request may have timed out, or an error may have occured on the server.  Check the Event Log for error messages.", 0, f);
            else
                Global.alertError(response.responseText);
        }
    });
}

function undraftAllPlayers() {
    Ext.Msg.show({
        title: 'Confirm',
        msg: 'You are about to undraft all players.  Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'yes')
                _undraftPlayer(true);
        },
        icon: Ext.MessageBox.QUESTION
    });
}

function undraftPlayer() {

    if (draftedPlayersGrid.getSelectionModel().getCount() === 0) {
        Global.alert('Select a player');
        return;
    }
                
    Ext.Msg.show({
        title: 'Confirm',
        msg: 'You are about to undraft this player.  Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'yes')
                _undraftPlayer(false);
        },
        icon: Ext.MessageBox.QUESTION
    });
    
}

function _undraftPlayer(all) {
    

    var postParams = {};
    if (all)
        postParams.PlayerId = 0;
    else
        postParams.PlayerId = draftedPlayersGrid.getSelectionModel().selections.items[0].data.PlayerId;
    postParams.LeagueId = leagueId;
    postParams.Year = year;

    Ext.Ajax.request({
        url: Global.siteRoot + 'DraftAdmin/UndraftPlayer',
        params: postParams,
        method: 'POST',
        success: function (response) {
            var ret = Ext.decode(response.responseText);
            if (ret.Result === true) {
                refreshGrids();
                if (all) {
                    ret.NextPick = 1;
                    ret.NextRound = 1;
                    ret.Team = 1;
                }
                draftClock.restart();
                setPickFields(ret.NextTeam, ret.NextRound, ret.NextPick);
            }
        },
        failure: function (response) {
            if (response.responseText == null)
                Global.alertError("Errors encountered while processing request.  The request may have timed out, or an error may have occured on the server.  Check the Event Log for error messages.", 0, f);
            else
                Global.alertError(response.responseText);
        }
    });
}

function addPlayer() {

    var name = Ext.getCmp('txtName');
    var position = Ext.getCmp('txtPosition');
    var team = Ext.getCmp('txtTeam');

    //validate
    var valid = true;
    if (name.isValid() == false) valid = false;
    if (position.isValid() == false) valid = false;
    if (team.isValid() == false) valid = false;
    if (!valid)
        return;

    //send request
    Ext.Ajax.request({
        url: Global.siteRoot + 'DraftAdmin/AddPlayer',
        params: {
            name: name.getValue(),
            position: position.getValue(),
            team: team.getValue(),
            year: year, 
            leagueId: leagueId
        },
        success: function (response, opts) {
            try {
                var obj = Ext.decode(response.responseText);
                if (obj.Result == true) {
                    Ext.getCmp('availablePlayersFilter').setValue(name.getValue());
                    refreshAvailableGrid();
                    filterAvailablePlayers()
                    name.reset();
                    position.reset();
                    team.reset();
                    newPlayerWindow.hide();
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

function setPickFields(Team, Round, Overall) {
    Ext.getCmp('Teams').setValue(Team);
    Ext.getCmp('Round').setValue(Round);
    Ext.getCmp('Overall').setValue(Overall);
}

function updateSelectedPlayer(info) {
    Ext.getCmp('PlayerName').body.update(info);
}
function clearSelectedPlayer() {
    Ext.getCmp('PlayerName').body.update('None');
}

function refreshGrids() {
    availablePlayersGrid.store.load();
    draftedPlayersGrid.store.load();
    clearSelectedPlayer();
}


function refreshAvailableGrid() {
    availablePlayersGrid.store.load();
    clearSelectedPlayer();
}

function refreshDraftedGrid() {
    draftedPlayersGrid.store.load();
}
