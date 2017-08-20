
function resetCycleButton(cmp) {
    //console.log(cmp.getActiveItem())
    if (cmp.getActiveItem().itemIndex > 0) {
        cmp.menu.items.itemAt(cmp.getActiveItem().itemIndex).setChecked(false, true);
        cmp.setActiveItem(cmp.items[0]);
        cmp.menu.items.itemAt(0).setChecked(true, true);
    }
}

var playersGrid = new Ext.grid.GridPanel({
    region: 'center',
    title: 'Players',
    border: true,
    //style: 'border-top:0px solid black;',
    //stateful: true,
    //stateId: 'draft-admin-players-grid',
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
                {name: 'Experience', mapping: 'Experience'},
                {name: 'Keywords', mapping: 'Keywords'},
                {name: 'Comments', mapping: 'Comments'}, 
                {name: 'TeamId', mapping: 'TeamId'}, 
                {name: 'Team', mapping: 'Team'}, 
                {name: 'Overall', mapping: 'Overall'}, 
                {name: 'Round', mapping: 'Round'}, 
                {name: 'DepthChart', mapping: 'DepthChart'}, 
                {name: 'ProjectedPoints', mapping: 'ProjectedPoints'}, 
                {name: 'ActualPoints', mapping: 'ActualPoints'}, 
                {name: 'Odds', mapping: 'Odds'}
            ]
        }),
        baseParams: {LeagueId: leagueId, Year: year}, 
        proxy: new Ext.data.HttpProxy({url: Global.siteRoot + 'Admin/Players'}),
        autoLoad: true, 
        listeners: {load: function(){
            filterPlayers();
        }}
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [
            {dataIndex: 'PlayerId', hidden:true},
            {header: 'Name', dataIndex: 'Name', width:150, fixed: true, renderer: function(value, metaData, record, rowIndex, colIndex, store) {
                var ret = value;
                if (record.data.TeamId == 0 && record.data.ADP < currentPickNumber) {
                    //metaData.attr = 'style="color:red;"';
                    metaData.css = 'x-grid3-dirty-cell';
                }
                return ret;
            }},
            {header: 'Position', dataIndex: 'Position', width: 50, fixed: true, align:'center'},
            {header: 'Team', dataIndex: 'NFLTeam', width: 50, fixed: true, align:'center'}, 
            {header: 'Bye', dataIndex: 'Bye', width: 50, fixed: true, align:'center'},
            {header: 'ADP', dataIndex: 'ADP', width: 50, fixed: true, align:'center'},
            {header: 'Points', dataIndex: 'ProjectedPoints', width: 60, fixed: true, align:'right'},
            {header: 'Odds', dataIndex: 'Odds', width: 60, fixed: true, align:'right'},
            {header: 'Age', dataIndex: 'Age', width: 50, fixed: true, align:'center'},
            {header: 'Yrs', dataIndex: 'Experience', width: 50, fixed: true, align:'center'},
            {header: 'Depth', dataIndex: 'DepthChart', width: 50, fixed: true, align:'center'},
            {header: 'Keywords', dataIndex: 'Keywords', width: 200, fixed: true, align:'left'},
            {header: 'Comments', dataIndex: 'Comments', align:'left'}
            
        ],
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    tbar: {
        items:[
            {
                xtype:'button',
                text:'Edit Player',
                handler: function(){
                    //try {
                        loadPlayer(playersGrid.getSelectionModel().getSelected().data);
                    //} catch(e) {}
                }
            }, '-'
            , {
                xtype:'button',
                text:'Refresh',
                //iconCls: 'icon-button-refresh',
                handler: function(){
                    playersGrid.store.load();
                }
            }, '-'
            , {
                xtype:'button',
                text:'Clear',
                handler: function(){
                    Ext.getCmp('txtGeneralFilter').reset();
                    Ext.getCmp('chkUndrafted').reset();
                    Ext.getCmp('chkCommentsOnly').reset();
                    resetCycleButton(Ext.getCmp('cycPosition'));
                    resetCycleButton(Ext.getCmp('cycExperience'));
                    resetCycleButton(Ext.getCmp('cycDepthChart'));
                    filterPlayers();
                }
            }, '-'
            , {
                id:'txtGeneralFilter',
                xtype:'textfield',
                emptyText:'Type to filter',
                width:130,
                listeners:{
                    render: function(f){
                        f.el.on('keyup', filterPlayers, f, {buffer: 5});
                    }
                }
            }, '-', {
                xtype: 'checkbox', 
                id: 'chkUndrafted', 
                checked: true,
                listeners: {
                    check: filterPlayers
                }
            }, {
                xtype: 'tbtext',
                text: '&nbsp;Undrafted'   
            }, '-', {
                xtype: 'checkbox', 
                id: 'chkCommentsOnly', 
                listeners: {
                    check: filterPlayers
                }
            }, {
                xtype: 'tbtext',
                text: '&nbsp;Comments Only'   
            }, '-' , {
                xtype: 'cycle', 
                id: 'cycPosition', 
                showText: true,
                prependText: 'Position: ',
                items: [{
                    text:'All',
                    checked:true
                },{
                    text:'QB'
                },{
                    text:'RB'
                },{
                    text:'WR'
                },{
                    text:'TE'
                },{
                    text:'DEF'
                },{
                    text:'K'
                }],
                changeHandler:filterPlayers
            }, '-'
            , {
                xtype: 'cycle', 
                id: 'cycDepthChart', 
                showText: true,
                prependText: 'Depth Chart: ',
                items: [{
                    text:'All',
                    checked:true
                },{
                    text:'1'
                },{
                    text:'2'
                },{
                    text:'3'
                }],
                changeHandler:filterPlayers
            }, '-'
            , {
                xtype: 'cycle', 
                id: 'cycExperience', 
                showText: true,
                prependText: 'Experience: ',
                items: [{
                    text:'All',
                    checked:true
                },{
                    text:'Rookie'
                },{
                    text:'1 Year'
                },{
                    text:'2 Years'
                },{
                    text:'3 Years'
                }],
                changeHandler:filterPlayers
            }, '-', {
                xtype: 'tbtext', 
                text: 'Current Pick: ' + currentPickNumber
            }, '-', {
                xtype: 'tbtext', 
                text: '# Players: '
            }, {
                xtype: 'tbtext', 
                id: 'txtNumberOfPlayers', 
                text: ''
            }
        ]
    },
    listeners:{
        rowclick: function(grid,rowIndex) {
            //var data = grid.store.getAt(rowIndex).data;
            //updateSelectedPlayer(data.Name + '  (' + data.Position + ' / ' + data.NFLTeam + ')');
        },
        rowdblclick: function(grid, rowIndex) {
            //debugger;
            loadPlayer(grid.store.getAt(rowIndex).data);
        }
    }, 
    view: new Ext.grid.GridView({
        forceFit: true, 
        getRowClass : function (row, index) { 
            return row.data.TeamId == 0 ? '' : 'admin-drafted-row';
        }
    })


})

function filterPlayers() {
    //debugger;
    var pos = Ext.getCmp('cycPosition').getActiveItem().text;
    var keywordRegex = new RegExp(keywords.join("|"));
    var general = Ext.getCmp('txtGeneralFilter').getValue();
    var undrafted = Ext.getCmp('chkUndrafted').getValue();
    var commentsOnly = Ext.getCmp('chkCommentsOnly').getValue();
    var experience = Ext.getCmp('cycExperience').getActiveItem().text;
    var depthChart = Ext.getCmp('cycDepthChart').getActiveItem().text;
    //console.log(depthChart)

    var isMatch_Pos = function(record) {
        return (pos == 'All') || (pos == record.data.Position);
    }
    var isMatch_Gen = function(record) {
        if (general == '') return true;

        var match = false;
        var re = new RegExp(general.replace('\\','\\\\').replace('+','\\+').replace('?','\\?').replace('*','\\*').replace('[','\\[').replace('(','\\(').replace(')','\\)'), 'i');
        Ext.each(playersGrid.colModel.config, function(config) { 
            match = match || re.test(record.data[config.dataIndex])
        });
        return match;
    }
    var isMatch_Undrafted = function(record) {
        if (undrafted == false) return true;
        return (record.data.TeamId == 0);
    }
    var isMatch_CommentsOnly = function(record) {
        if (commentsOnly == false) return true;
        return (record.data.Comments != '');
    }
    var isMatch_Experience = function(record) {
        var match = false;
        if (experience == 'All') 
            match = true;
        else {
            if (experience == 'Rookie' && record.data.Experience == 0) {
                match = true;
            } else if (experience == '1 Year' && record.data.Experience == 1) {
                match = true;
            } else if (experience == '2 Years' && record.data.Experience == 2) {
                match = true;
            } else if (experience == '3 Years' && record.data.Experience == 3) {
                match = true;
            }
        }
            
        return match;
    }
    var isMatch_DepthChart = function(record) {
        return (depthChart == 'All') || (depthChart == record.data.DepthChart);
    }
    var isMatch_Keywords = function(record) {
        if (keywords.length == 0) return true;
        return keywordRegex.test(record.get('Keywords'));
    }
    
    playersGrid.store.filterBy(function (record){
        return (isMatch_Pos(record) && isMatch_Gen(record) && isMatch_Keywords(record) && isMatch_Undrafted(record) && isMatch_CommentsOnly(record) && isMatch_Experience(record) && isMatch_DepthChart(record));
        //return (isMatch_Keywords(record));
    });
    Ext.getCmp('txtNumberOfPlayers').setText(playersGrid.getStore().getCount());
}