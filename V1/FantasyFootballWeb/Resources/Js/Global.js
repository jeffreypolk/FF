
var Global = {};

Global.siteRoot = _siteRoot;

Global.alert = function (message, title, callback, width) {
    if (title == null) {
        title = 'Message'
    }

    if (width == null) {
        width = 300
    }

    Ext.MessageBox.show({
        title: title,
        msg: message,
        buttons: Ext.MessageBox.OK,
        icon: Ext.MessageBox.INFO,
        width: width,
        fn: function () {
            if (callback != null) callback();
        }
    });
}

Global.alertError = function (message, callback) {
    var win = new Ext.Window({
        title: 'Error',
        iconCls: 'icon-error-16',
        width: 400,
        height: 400,
        bodyStyle: 'padding:5px;font-size:9pt;',
        html: message,
        shim: false,
        modal: true,
        autoScroll: true,
        animCollapse: false,
        constrainHeader: true,
        buttonAlign: 'center',
        buttons: [{
            text: 'Close',
            handler: function () {
                win.close();
            }
        }],
        defaultButton: 0,
        listeners: {
            close: function () {
                if (callback != null) callback();
            }
        }
    })
    win.show()
}
