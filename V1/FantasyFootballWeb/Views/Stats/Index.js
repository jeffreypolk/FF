

$(document).ready(function () {
    $('#ddlYear a').click(function () {
        var year = $(this).html();
        if (year === 'Custom Range') {
            $('#CustomRangeDialog').modal('show');
        } else {
            Main.navigate({
                url: 'stats',
                leagueId: leagueId,
                managers: managers,
                year: $(this).html(),
            });
        }
    });

    $('#btnCustomRange').click(function () {
        Main.navigate({
            url: 'stats',
            leagueId: leagueId,
            managers: managers,
            year1: $('#txtYear1').val(),
            year2: $('#txtYear2').val(),
        });
    });

    $('#ddlManagers a').click(function () {
        Main.navigate({
            url: 'stats',
            leagueId: leagueId,
            managers: $(this).html(),
            year: year,
            year1: year1,
            year2: year2
        });
    });

    $('#ddlLeague a').click(function () {
        Main.navigate({
            url: 'stats',
            leagueId: $(this).data('leagueid'),
            managers: managers,
            year: year,
            year1: year1,
            year2: year2
        });
    });

    $('#btnHome').click(function () {
        Main.navigate({
            url: ''
        });
    });
});
