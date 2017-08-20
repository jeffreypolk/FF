

$(document).ready(function () {
    $('.link-draftboard').click(function () {
        Main.navigate({
            url: 'draft',
            leagueId: $(this).data('leagueid'),
            year: $(this).data('year')
        });
    });

    $('.link-draftstats').click(function () {
        Main.navigate({
            url: 'draft/stats',
            leagueId: $(this).data('leagueid'),
            year: $(this).data('year')
        });
    });

    $('.link-stats').click(function () {
        Main.navigate({
            url: 'stats',
            leagueId: $(this).data('leagueid'),
            year: $(this).data('year')
        });
    });
});

