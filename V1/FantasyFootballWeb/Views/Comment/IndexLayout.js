

Ext.onReady(function () {






    var mainPanel = new Ext.Panel({

        renderTo: 'main'
        , layout: 'border'
        , border: true
        , height: 1000
        , items: [{
            region: 'north'
            , html: 'north'
        },{
            region: 'center'
            , layout: 'fit'
            , items: [commentsGrid]
        }]
    }); 

});