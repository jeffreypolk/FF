
var availablePlayersGrid = new Ext.grid.GridPanel({
    region: 'center',
    title: 'Available Players',
    border: true,
    //style: 'border-top:0px solid black;',
    //stateful: true,
    //stateId: 'draft-available-players-grid',
    store: new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'Rows',
            fields: [
                {name: 'PlayerId', mapping: 'PlayerId'},
                {name: 'Name', mapping: 'Name'}, 
                {name: 'Position', mapping: 'Position'}, 
                {name: 'NFLTeam', mapping: 'NFLTeam'},
                {name: 'Bye', mapping: 'Bye'},
                {name: 'ADP', mapping: 'ADP'},
                {name: 'Age', mapping: 'Age'},
                { name: 'Experience', mapping: 'Experience' },
                { name: 'ProjectedPoints', mapping: 'ProjectedPoints' }
            ]
        }),
        baseParams: {LeagueId: leagueId, Year: year}, 
        proxy: new Ext.data.HttpProxy({url: Global.siteRoot + 'Draft/AvailablePlayers/'}),
        autoLoad: true, 
        listeners: {load: function(){
            if (Ext.getCmp('availablePlayersFilter').getValue() != '') {
                filterAvailablePlayers();
            }
        }}
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 120,
            sortable: true
        },
        columns: [
            {dataIndex: 'PlayerId', hidden:true},
            {header: 'Name', dataIndex: 'Name', width:200},
            {header: 'Position', dataIndex: 'Position', width: 80, align:'center'},
            {header: 'Team', dataIndex: 'NFLTeam', width: 75, align:'center'}, 
            {header: 'Bye', dataIndex: 'Bye', width: 50, align:'center'},
            { header: 'ADP', dataIndex: 'ADP', width: 50, align: 'center' },
            {header: 'Points', dataIndex: 'ProjectedPoints', width: 50, align:'right'},
            {header: 'Age', dataIndex: 'Age', width: 50, align:'center'},
            { header: 'Yrs', dataIndex: 'Experience', width: 50, align: 'center' }
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    tbar: {
        items:[
            {
                xtype:'button',
                text:'Refresh',
                iconCls: 'icon-button-refresh',
                handler: refreshAvailableGrid
            }
            , '-'
            , {
                id:'availablePlayersFilter',
                xtype:'textfield',
                emptyText:'Type to filter',
                width:130,
                listeners:{
                    render: function(f){
                        f.el.on('keyup', filterAvailablePlayers, f, {buffer: 5});
                    }
                }
            }
        ]
    },
    listeners:{
        rowclick: function(grid,rowIndex) {
            var data = grid.store.getAt(rowIndex).data;
            updateSelectedPlayer(data.Name + '  (' + data.Position + ' / ' + data.NFLTeam + ')');
        },
        dblclick: function() {
            draftPlayer();
        }
    }


})

function filterAvailablePlayers() {
    availablePlayersGrid.store.filterBy(function (record){
        var re = new RegExp(Ext.getCmp('availablePlayersFilter').getValue().replace('\\','\\\\').replace('+','\\+').replace('?','\\?').replace('*','\\*').replace('[','\\[').replace('(','\\(').replace(')','\\)'), 'i');
        var match = false;
        Ext.each(availablePlayersGrid.colModel.config, function(config) { 
            match = match || re.test(record.data[config.dataIndex])
        });
        return match;
    })
}