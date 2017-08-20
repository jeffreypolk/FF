

Ext.onReady(function () {

    var draftForm = new Ext.Panel({
        border: false,
        bodyStyle: 'padding:10px',
        height: 170,
        layout: 'form',
        width: 350,
        fbar: [{
            xtype: 'button',
            id: 'btnDraftPlayer',
            text: 'Draft Player',
            handler: draftPlayer
        }, {
            xtype: 'button',
            id: 'btnUndraftPlayer',
            text: 'Undraft Player',
            handler: undraftPlayer
        }, {
            xtype: 'button',
            id: 'btnUndraftAll',
            text: 'Clear Draft',
            handler: undraftAllPlayers
        }, {
            xtype: 'button',
            id: 'btnAddPlayer',
            text: 'Add Player',
            handler: function () { newPlayerWindow.show(); }
        }],
        items: [{
            xtype: 'combo',
            id: 'Teams',
            fieldLabel: 'Team',
            typeAhead: true,
            forceSelection: true,
            selectOnFocus: true,
            resizable: true,
            triggerAction: 'all',
            editable: false,
            valueField: 'TeamId',
            displayField: 'Name',
            store: new Ext.data.Store({
                reader: new Ext.data.JsonReader({
                    root: 'Rows',
                    fields: [
                        { name: 'TeamId', mapping: 'TeamId' },
                        { name: 'Name', mapping: 'Name' }
                    ]
                }),
                baseParams: { LeagueId: leagueId, Year: year },
                proxy: new Ext.data.HttpProxy({ url: Global.siteRoot + 'Draft/Teams' }),
                autoLoad: true,
                listeners: {
                    load: function () {
                        Ext.getCmp('Teams').setValue(nextTeam);
                    }
                }
            })
        }, {
            xtype: 'spinnerfield',
            id: 'Round',
            fieldLabel: 'Round',
            minValue: 1,
            maxValue: 16,
            value: nextRound,
            incrementValue: 1,
            accelerate: true
        }, {
            xtype: 'spinnerfield',
            id: 'Overall',
            fieldLabel: 'Overall',
            minValue: 1,
            maxValue: 160,
            value: nextPick,
            incrementValue: 1,
            accelerate: true
        }, {
            xtype: 'panel',
            id: 'PlayerName',
            border: false,
            fieldLabel: 'Player',
            html: 'None'

        }, {
            xtype: 'checkbox',
            id: 'IsKeeper',
            fieldLabel: 'Keeper'

        }, {
            xtype: 'panel',
            height: 20,
            border: false
        }]
    });

    var draftNorthPanel = new Ext.Panel({
        region: 'north'
        , layout: 'column'
        , border: true
        , bodyStyle: 'border-bottom: 0px;'
        , height: 175
        , split: true
        , items: [
            draftForm,
            {
                xtype: 'panel'
                , border: false
                , bodyStyle: 'text-align:center;padding-top:20px;'
                , columnWidth: 1
                , layout: 'anchor'
                , items: [{
                    id: 'clockPanel'
                    , html: ' 02:00'
                    , border: false
                    , layout: 'anchor'
                    , width: 250
                    , bodyStyle: 'font-size:26px;'
                    , fbar: {
                        buttonAlign: 'center'
                        , items: [{
                            id: 'btnStart'
                            , text: 'Start'
                            , width: 50
                            , handler: draftClock.start
                        }, {
                            id: 'btnStop'
                            , text: 'Stop'
                            , width: 50
                            , handler: draftClock.stop
                        }, {
                            id: 'btnReset'
                            , text: 'Reset'
                            , width: 50
                            , handler: draftClock.reset
                        }]
                    }
                }]
            }
        ]
    });










    var mainPanel = new Ext.Viewport({

        //renderTo: 'main'
        layout: 'border'
        , border: true
        , items: [{
            region: 'west'
            , layout: 'border'
            , border: false
            , split: true
            //, collapsible: true
            , title: 'Draft Control'
            , width: 600
            , margins: '5 0 5 5'
            , cmargins: '5 5 5 5'
            //stateful: true,
            //stateId: 'draft-west-region1',
            , items: [
                draftNorthPanel
                , {
                    xtype: 'panel'
                    , region: 'center'
                    , layout: 'fit'
                    , border: false
                    , items: [
                        draftedPlayersGrid
                    ]
                }
            ]
        }, {
            xtype: 'panel'
            , region: 'center'
            , border: false
            , margins: '5 5 5 0'
            , layout: 'fit'
            , items: [availablePlayersGrid]
        }]
    });

});

var newPlayerWindow = new Ext.Window({
    title: 'Add New Player',
    layout: 'form',
    height: 180,
    width: 300,
    closeAction: 'hide',
    bodyStyle: 'padding:10px;',
    id: 'NewPlayerPanel',
    labelWidth: 50,
    items: [{
        xtype: 'textfield',
        fieldLabel: 'Name',
        id: 'txtName',
        allowBlank: false
    }, {
        xtype: 'combo',
        fieldLabel: 'Position',
        id: 'txtPosition',
        mode: 'local',
        triggerAction: 'all',
        lazyRender: true,
        editable: false,
        store: new Ext.data.ArrayStore({
            id: 0,
            fields: [
            'Position'
        ],
            data: [['QB'], ['RB'], ['WR'], ['TE'], ['DEF']]
        }),
        valueField: 'Position',
        displayField: 'Position', 
        value: 'RB'
    }, {
        xtype: 'combo',
        fieldLabel: 'Team',
        id: 'txtTeam',
        mode: 'local',
        triggerAction: 'all',
        lazyRender: true,
        editable: false,
        store: new Ext.data.ArrayStore({
            id: 0,
            fields: [
                'Team'
            ],
            data: [['ARI'],['ATL'],['BAL'],['BUF'],['CAR'],['CHI'],['CIN'],['CLE'],['DAL'],['DEN'],['DET'],['GB'],['HOU'],['IND'],['JAX'],['KC'],['MIA'],['MIN'],['NE'],['NO'],['NYG'],['NYJ'],['OAK'],['PHI'],['PIT'],['SD'],['SEA'],['SF'],['STL'],['TB'],['TEN'],['WAS']]
        }),
        valueField: 'Team',
        displayField: 'Team',
        value: 'ARI'
    }],
    buttonAlign: 'center',
    fbar: [{
        text: 'Add',
        handler: addPlayer
    }, {
        text: 'Cancel',
        handler: function () {
            Ext.getCmp('txtName').reset();
            Ext.getCmp('txtPosition').reset();
            Ext.getCmp('txtTeam').reset();
            newPlayerWindow.hide();
        }
    }]
})