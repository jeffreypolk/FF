var Main = function () {

    var internal = {

    }

    var external = {

        authKey: null,
        siteRoot: null, 
        leagueId: null,

        navigate: function (config) {
            var url = config.url;
            delete config.url;
            window.location.href = external.siteRoot + url + '?' + $.param(config);
        },

        open: function (config) {
            var url = config.url;
            delete config.url;
            window.open(external.siteRoot + url + '?' + $.param(config));
        }
    }

    var initialize = function () {

    } ();

    return external;
} ();