<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/SiteBlank.Master" Inherits="System.Web.Mvc.ViewPage" %>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Draft Research
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var leagueId = <% = ViewData("LeagueId") %>;
        var year = <% = ViewData("Year") %>;
        var allKeywordsString = '<% = ViewData("Keywords") %>';
        var currentPickNumber = <% = ViewData("CurrentPickNumber") %>;
    </script>
	<script type="text/javascript" src="<% = ResolveUrl("~/Views/Admin/AdminMethods.js") %>"></script>
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/Admin/PlayersGrid.js") %>"></script>
	<script type="text/javascript" src="<% = ResolveUrl("~/Views/Admin/AdminLayout.js") %>"></script>
    
	<script type="text/javascript">
	    //setRound();
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
	

</asp:Content>

