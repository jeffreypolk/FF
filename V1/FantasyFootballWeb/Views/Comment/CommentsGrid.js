
var commentsGridTemplate = new Ext.XTemplate(
    '<tpl for=".">',
        '<div class="comment-wrapper">', 
            '<p><img class="team-logo" src="{LogoUrl}" width="48" height="48">', 
            '<span class="comment-text">{Text}</span></p>',
            '<p><span class="posted-time">{PostTime}</span></p>', 
        '</div>', 
    '</tpl>'
);

var commentsGrid = new Ext.DataView({
    store: new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'Rows',
            fields: [
                {name: 'CommentId', mapping: 'CommentId'},
                {name: 'PostDate', mapping: 'PostDate'}, 
                {name: 'Text', mapping: 'Text'},
                { name: 'LogoUrl', mapping: 'LogoUrl' },
                { name: 'TeamName', mapping: 'TeamName' }
            ]
        }),
        proxy: new Ext.data.HttpProxy({url: Global.siteRoot + 'Comment/Comments'}),
        autoLoad: true
    })
    , tpl: commentsGridTemplate
    , autoHeight:true
    , overClass:'x-view-over'
    , itemSelector:'div.thumb-wrap'
    , emptyText: 'No images to display'
})




