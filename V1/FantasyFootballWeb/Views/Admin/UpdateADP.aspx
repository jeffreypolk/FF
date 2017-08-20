<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/JQuery.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Update ADP
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">

    <script type="text/javascript">

        $(document).ready(function () {

            $('#btnSubmit').button().click(function () {
                var adp = JSON.parse($('#txtADPData').val());
                var data = [];
                for (var i = 0; i < adp.length; i++) {
                    data.push(adp[i].name + '~' + adp[i].adp);
                }
                $.ajax({
                    url: Main.siteRoot + 'Admin/UpdateADP?authkey=' + Main.authKey + '&leagueid=' + Main.leagueId,
                    method: 'post',
                    data: 'data=' + data.join('|')
                });
            });

        });

        function scrubAPD() {
            var adp = [];
            $('table.data').find('.row1,.row2').each(function () {
                adp.push({
                    name: $(this).find('td:nth-child(2)').find('a').html(),
                    adp: parseFloat($(this).find('td:nth-child(4)').html())
                });
            });
            $('body').append('<div style="position:absolute;left:0px;top:0px;z-index:99999999"><textarea id="scrub-adp-textarea" rows="25" cols="100">' + JSON.stringify(adp) + '</textarea></div>');
            $('#scrub-adp-textarea').select();
        }

        function scrubADPMin() {
            var adp = []; $('table.data').find('.row1,.row2').each(function () { adp.push({ name: $(this).find('td:nth-child(2)').find('a').html(), adp: parseFloat($(this).find('td:nth-child(4)').html()) }); }); $('body').append('<div style="position:absolute;left:0px;top:0px;z-index:99999999"><textarea id="scrub-adp-textarea" rows="25" cols="100">' + JSON.stringify(adp) + '</textarea></div>'); $('#scrub-adp-textarea').select();
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Update ADP</h2>
    <textarea id="txtADPData" rows="20" cols="100">[{"name":"Calvin Johnson","adp":9.08},{"name":"A.J. Green","adp":17.72}]</textarea>
    <br />
    <input type="button" id="btnSubmit" value="Submit" />

</asp:Content>


