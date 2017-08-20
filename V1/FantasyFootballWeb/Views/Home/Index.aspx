<%@ Page Language="VB" MasterPageFile="~/Views/Shared/Bootstrap.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="indexTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Fantasy Football
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        @media (max-width: 991px) {
          .league-2 {
            padding-top:200px;
          }
        }
    </style>

    <script type="text/javascript" src="<% = ResolveUrl("~/Views/Home/Index.js")%>"></script>
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="jumbotron">
      <div class="container">
        <h1>Fantasy Football</h1>
        <!--<p>It rocks</p>-->
        
      </div>
    </div>

    <div class="container">
        <div class="row">
            <%For Each l In Model.LeaguesList%>
                <div class="col-md-6 league-<%=l.LeagueId%>">
                    <h1><%=l.Name %></h1>
                    <div style="font-size:18px;padding-top:15px;">
                        Draft Boards&nbsp;&nbsp;
                        <%For Each y In Model.YearsList%>
                            <a href="<%=String.Format("{0}draft?leagueid={1}&year={2}", FantasyFootballWeb.Params.SiteRoot, l.LeagueId, y)%>"><%=y%></a>&nbsp;&nbsp;
                        <%Next%>
                        <br /><br />
                        Draft Grades&nbsp;&nbsp;
                        <%For Each y In Model.YearsList%>
                            <a href="<%=String.Format("{0}draft/stats?leagueid={1}&year={2}", FantasyFootballWeb.Params.SiteRoot, l.LeagueId, y)%>"><%=y%></a>&nbsp;&nbsp;
                        <%Next%>
                        <br /><br />
                        Overall Stats&nbsp;&nbsp;
                        <a href="<%=String.Format("{0}stats?leagueid={1}", FantasyFootballWeb.Params.SiteRoot, l.LeagueId)%>">All Time</a>&nbsp;&nbsp;
                        <%For i As Integer = 0 To Model.YearsList.Count - 2%>
                            <a href="<%=String.Format("{0}stats?leagueid={1}&year={2}", FantasyFootballWeb.Params.SiteRoot, l.LeagueId, Model.YearsList(i))%>"><%=Model.YearsList(i)%></a>&nbsp;&nbsp;    
                        <%Next%>
                        <%If l.LeagueId = 1 Then%>
                            <br /><br />
                            View the <a href="https://drive.google.com/open?id=125UZMXq01aRq5YiSdQkW_167UTbrGr-zgBRmCJ1a_po">PA Fantasy Bylaws</a>
                        <%End If%>
                    </div>
                </div>
            <%Next%>
            
            
        </div>
    </div>

</asp:Content>
