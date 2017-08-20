
var draftedPlayersGrid = new Ext.grid.GridPanel({
    title: 'Drafted Players',
    //stateful: true,
    //stateId: 'draft-drafted-players-grid',
    //collapsible: true,
    store: new Ext.data.GroupingStore({
        groupField: 'TeamGroupName',
        sortInfo: {field:'Round', direction: 'ASC'},
        reader: new Ext.data.JsonReader({
            root: 'Rows',
            fields: [
                {name: 'PlayerId', mapping: 'PlayerId'},
                {name: 'Name', mapping: 'Name'}, 
                {name: 'Position', mapping: 'Position'}, 
                {name: 'NFLTeam', mapping: 'NFLTeam'},
                {name: 'Team', mapping: 'Team'},
                {name: 'TeamGroupName', mapping: 'TeamGroupName'},
                {name: 'TeamId', mapping: 'TeamId'},
                {name: 'Round', mapping: 'Round'}, 
                {name: 'Bye', mapping: 'Bye'}, 
                {name: 'ADP', mapping: 'ADP'},
                {name: 'Age', mapping: 'Age'}, 
                {name: 'Experience', mapping: 'Experience'},
                { name: 'IsKeeper', mapping: 'IsKeeper' },
                { name: 'ProjectedPoints', mapping: 'ProjectedPoints' }
            ]
        }),
        baseParams: {LeagueId: leagueId, Year: year}, 
        proxy: new Ext.data.HttpProxy({url: Global.siteRoot + 'Draft/DraftedPlayers'}),
        autoLoad: true
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 120,
            sortable: true
        },
        columns: [
            {dataIndex: 'PlayerId', hidden:true},
            {header: 'Round', dataIndex: 'Round', width: 60},
            {header: 'Name', dataIndex: 'Name'},
            {header: 'Position', dataIndex: 'Position', width: 80, align:'center'},
            {header: 'Team', dataIndex: 'NFLTeam', width: 75, align:'center'},
            {header: 'Bye', dataIndex: 'Bye', width: 50, align:'center'},
            { header: 'ADP', dataIndex: 'ADP', width: 50, align: 'center' },
            { header: 'Points', dataIndex: 'ProjectedPoints', width: 50, align: 'right', hidden: !isAdmin},
            {header: 'Age', dataIndex: 'Age', width: 50, align:'center', hidden: !isAdmin},
            {header: 'Yrs', dataIndex: 'Experience', width: 50, align:'center', hidden: !isAdmin},
            {dataIndex: 'Team', hidden:true}, 
            {dataIndex: 'TeamGroupName', hidden:true}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    view: new Ext.grid.GroupingView({
        forceFit:false,
        showGroupName:false,
        groupTextTpl:'{text}',
        getRowClass : function (row, index) { 
            return row.data.IsKeeper == true ? 'draft-keeper-row' : '';
        }
    }),
    tbar: {
        items:[
            {
                xtype:'button'
                , text:'Refresh'
                , iconCls: 'icon-button-refresh'
                , handler: refreshDraftedGrid
            }
        ]
    }
})