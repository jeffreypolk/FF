
function StopWatch() {
    var me = this;
    
    me.runTime = 0;
    me.tickDuration = 1000;  /* tick every 100 ms */
    me.countdown = 0; /* set ms to countdown.  0 will count up */
    me.timer = null;
    me.isRunning = false;

    var padTime = function (value, pad) {
        var valueStr = String(value);
        var padStr = String(pad);
        if (valueStr.length >= pad)
            return valueStr;

        for (var i = valueStr.length; i <= padStr.length; i++) {
            valueStr = '0' + valueStr;
        }
        return valueStr;
    }

    me.start = function () {
        /* exit if the stop watch already running */
        if (me.isRunning) return;
        me.onChange(me);
        me.timer = setInterval(function () { me.tick() }, me.tickDuration);
        me.isRunning = true;
    }

    me.tick = function () {
        me.runTime += me.tickDuration;
        me.onChange(me);
        if (me.countdown > 0 && me.runTime >= me.countdown)
            me.stop();
    }

    me.stop = function () {
        clearInterval(me.timer);
        me.isRunning = false;
        me.onChange(me);
    }

    me.reset = function () {
        clearInterval(me.timer);
        me.isRunning = false;
        me.runTime = 0;
        me.onChange(me);
    }

    me.restart = function () {
        me.reset();
        me.start();
    }

    // poor man's event.  overwrite this function to be notified of a change
    me.onChange = function (me) {
    }

    me.formatTime = function () {
        if (me.countdown == 0)
            var time = me.runTime;
        else
            var time = me.countdown - me.runTime;

        var seconds = (time / 1000) % 60
        var minutes = (time / (1000 * 60)) % 60
        var hours = (time / (1000 * 60 * 60)) % 24
        return (padTime(Math.floor(minutes), 2) + ':' + padTime(Math.floor(seconds), 2));
    }
}