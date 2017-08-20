<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/SiteBlank.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Draft Admin
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var nextTeam = <% = ViewData("NextTeam") %>;
        var nextPick = <% = ViewData("NextPick") %>;
        var nextRound = <% = ViewData("NextRound") %>;
        var leagueId = <% = ViewData("LeagueId") %>;
        var year = <% = ViewData("Year") %>;
    </script>
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/DraftAdmin/StopWatch.js") %>"></script>
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/DraftAdmin/IndexMethods.js") %>"></script>
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/DraftAdmin/AvailablePlayersGrid.js") %>"></script>
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/DraftAdmin/DraftedPlayersGrid.js") %>"></script>
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/DraftAdmin/IndexLayout.js") %>"></script>
    
    <script type="text/javascript">
        
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    

</asp:Content>


