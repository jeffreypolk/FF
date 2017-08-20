Ext.onReady(function() {
    Ext.QuickTips.init();
    var tip = Ext.QuickTips.getQuickTip();
    Ext.apply(tip, {
        maxWidth:400,
        trackMouse:true,
        hideDelay:0
    });
    tip.render();
    tip.el.disableShadow();
});


// Turn on state management using cookies.  This will be used for things like collapsible panels to remember where the user left it.
Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

// Turn off state management by default for all components.  Turn on state management for individual components (like collapsible panels)
// http://extjs.com/forum/showthread.php?t=34055
Ext.Component.prototype.stateful = false;

// Must set this url!
Ext.BLANK_IMAGE_URL = Global.siteRoot + 'Resources/Ext/resources/images/default/s.gif';

// 3.0 enhancement to improve resize performance:
Ext.Container.prototype.bufferResize = false;
