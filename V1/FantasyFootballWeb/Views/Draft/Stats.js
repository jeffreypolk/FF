

$(document).ready(function () {
    $('#ddlYear a').click(function () {
        Main.navigate({
            url: 'draft/stats',
            leagueId: leagueId,
            year: $(this).html(),
            sort: sort
        });
    });

    $('#ddlLeague a').click(function () {
        Main.navigate({
            url: 'draft/stats',
            leagueId: $(this).data('leagueid'),
            year: year,
            sort: sort
        });
    });

    $('#ddlSort a').click(function () {
        
        var option = $(this).parent(); //the <li> clicked
        var sort = option.data('sortvalue');

        // set the dropdown
        $('.sort-option').show();
        option.hide();
        $('#sort-active').html(sort);

        // sort the panels
        var divList = $(".panel");
        
        var searchField = '';
        
        if (sort === 'Projected Points')
            searchField = 'projfinish';
        else if (sort === 'Actual Points')
            searchField = 'actfinish';
        else
            searchField = 'finish';

        divList.sort(function (a, b) {
            return $(a).data(searchField) - $(b).data(searchField);
        });
        $("#accordion").hide().html(divList).fadeIn(500);

    });

    $('#btnHome').click(function () {
        Main.navigate({
            url: ''
        });
    });



});

