
var keywordPanel = new Ext.Panel({
    layout: 'form',
    border: false,
    labelWidth: 10,
    bodyStyle: 'padding: 10px;',
    items: [{
        xtype: 'panel',
        border: false,
        html: 'Keywords',
        height: 25
    }]
});

var keywordStore = new Ext.data.ArrayStore({
    id: 0,
    fields: [
                'Keyword'
            ],
    data: function () {
        var ret = [];
        for (var i = 0; i < allKeywords.length; i++) {
            ret.push([allKeywords[i]]);
        }
        return ret;
    }()
});

for (var i = 0; i < allKeywords.length; i++) {
    addKeywordControl(allKeywords[i]);
}

Ext.onReady(function () {

    var mainPanel = new Ext.Viewport({

        //renderTo: 'main'
        layout: 'border'
        , border: true
        , items: [{
            region: 'west'
            , layout: 'fit'
            , border: true
            , split: true
            //, collapsible: true
            , title: 'Admin'
            , width: 171
            , margins: '5 0 5 5'
            , cmargins: '5 5 5 5'
            , tbar: [{
                text: 'Clear',
                handler: function () {
                    keywordPanel.items.each(function (cmp) {
                        console.log(cmp);
                        if (cmp.xtype == 'checkbox') {
                            cmp.setValue(false);
                        }
                    });
                }
            }, '-', {
                text: 'Rebuild',
                handler: rebuildKeywords
            }, '-', {
                text: 'Add Player',
                handler: function () { playerWindow.show(); }
            }]
            //stateful: true,
            //stateId: 'draft-west-region1',
            , items: [keywordPanel]
        }, {
            xtype: 'panel'
            , region: 'center'
            , border: false
            , margins: '5 5 5 0'
            , layout: 'fit'
            , items: [playersGrid]
        }]
    });

});

var playerWindow = new Ext.Window({
    title: 'Player Info',
    layout: 'form',
    height: 450,
    width: 470,
    closeAction: 'hide',
    bodyStyle: 'padding:10px;',
    id: 'EditPlayerPanel',
    labelWidth: 100,
    defaults: {
        xtype: 'textfield',
        width: 330,
        listeners: {
            specialkey: function (field, e) {
                if (e.getKey() == e.ENTER) {
                    savePlayer();
                }
            }
        }
    },
    items: [{
        xtype: 'hidden',
        id: 'txtPlayerId',
        value: 0
    }, {
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
            data: [['QB'], ['RB'], ['WR'], ['TE'], ['DEF'], ['K']]
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
            data: [['ARI'], ['ATL'], ['BAL'], ['BUF'], ['CAR'], ['CHI'], ['CIN'], ['CLE'], ['DAL'], ['DEN'], ['DET'], ['GB'], ['HOU'], ['IND'], ['JAX'], ['KC'], ['LAC'], ['LAR'], ['MIA'], ['MIN'], ['NE'], ['NO'], ['NYG'], ['NYJ'], ['OAK'], ['PHI'], ['PIT'], ['SEA'], ['SF'], ['TB'], ['TEN'], ['WAS']]
        }),
        valueField: 'Team',
        displayField: 'Team',
        value: 'ARI'
    }, {
        xtype: 'combo',
        fieldLabel: 'Keywords',
        id: 'txtKeywords',
        mode: 'local',
        triggerAction: 'all',
        lazyRender: true,
        editable: true,
        store: keywordStore,
        valueField: 'Keyword',
        displayField: 'Keyword',
        value: '',
        myfocusEventAdded: false,
        listeners: {
            expand: function (cmp) {
                if (cmp.myfocusEventAdded == false) {
                    console.log('add listener');
                    cmp.mon(cmp, {
                        focus: cmp.expand,
                        buffer: 50
                    });
                    cmp.myfocusEventAdded = true;
                }
            }
        }
    }, {
        xtype: 'numberfield',
        id: 'txtAge',
        fieldLabel: 'Age',
        value: 0,
        allowBlank: false
    }, {
        xtype: 'numberfield',
        id: 'txtExperience',
        fieldLabel: 'Years',
        value: 0,
        allowBlank: false
    }, {
        xtype: 'combo',
        fieldLabel: 'Depth Chart',
        id: 'txtDepthChart',
        mode: 'local',
        triggerAction: 'all',
        lazyRender: true,
        editable: false,
        store: new Ext.data.ArrayStore({
            id: 0,
            fields: [
            'DepthChart'
        ],
            data: [[0], [1], [2], [3]]
        }),
        valueField: 'DepthChart',
        displayField: 'DepthChart',
        value: 0
    }, {
        xtype: 'numberfield',
        id: 'txtProjectedPoints',
        fieldLabel: 'Projected Points',
        value: 0,
        decimals: 2,
        allowBlank: false
    }, {
        xtype: 'numberfield',
        id: 'txtActualPoints',
        fieldLabel: 'Actual Points',
        value: 0,
        decimals: 2,
        allowBlank: false
    }, {
        xtype: 'numberfield',
        id: 'txtOdds',
        fieldLabel: 'Odds',
        value: 0,
        allowBlank: false
    }, {
        xtype: 'textarea',
        id: 'txtComments',
        fieldLabel: 'Comments',
        height: 100
    }],
    buttonAlign: 'center',
    fbar: [{
        text: 'Save',
        handler: savePlayer
    }, {
        text: 'Cancel',
        handler: function () {
            playerWindow.hide();
        }
    }],
    listeners: {
        show: function () {
            window.setTimeout(function () {
                Ext.getCmp('txtName').focus();
            }, 100);
        },
        hide: function () {
            Ext.getCmp('txtPlayerId').reset();
            Ext.getCmp('txtName').reset();
            Ext.getCmp('txtPosition').reset();
            Ext.getCmp('txtTeam').reset();
            Ext.getCmp('txtKeywords').reset();
            Ext.getCmp('txtAge').reset();
            Ext.getCmp('txtDepthChart').reset();
            Ext.getCmp('txtExperience').reset();
            Ext.getCmp('txtComments').reset();
            Ext.getCmp('txtProjectedPoints').reset();
            Ext.getCmp('txtActualPoints').reset();
            Ext.getCmp('txtOdds').reset();
        }
    }
})
