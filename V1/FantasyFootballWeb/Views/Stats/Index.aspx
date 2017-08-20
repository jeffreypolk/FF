<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Bootstrap.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Stats
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<% = ResolveUrl("~/Views/Stats/Index.css") %>" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/Stats/Index.js")%>"></script>
    <script type="text/javascript">
        var leagueId = '<%=Model.LeagueId%>';
        var year = '<%=Model.Year%>';
        var year1 = '<%=Model.Year1%>';
        var year2 = '<%=Model.Year2%>';
        var managers = '<%=Model.Managers%>';
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="filter well well-sm">
        
        <button class="btn btn-default" type="button" id="btnHome" style="float:left;" >
            Home
        </button>
        
        <div style="float:left; width:15px">&nbsp;</div>

        <div class="dropdown" style="float:left;" id="ddlLeague">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                <%For Each league In Model.LeagueList%>
                    <%If league.LeagueId = Model.LeagueId Then%>
                        <b>League:</b> <%=league.Name%>
                    <%End If%>
                <%Next%>
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                <%For Each league In Model.LeagueList%>
                    <%If league.LeagueId <> Model.LeagueId Then%>
                        <li><a href="#" data-leagueid="<%=league.LeagueId%>"><%=league.Name%></a></li>
                    <%End If%>
                <%Next%>
            </ul>
        </div>

        <div style="float:left; width:15px">&nbsp;</div>

        <div class="dropdown" style="float:left;" id="ddlManagers">
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                <%For Each opt In Model.ManagersList%>
                    <%If opt = Model.Managers Then%>
                        <b>Managers:</b> <%=opt%>
                    <%End If%>
                <%Next%>
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                <%For Each opt In Model.ManagersList%>
                    <%If opt <> Model.Managers Then%>
                        <li><a href="#"><%=opt%></a></li>
                    <%End If%>
                <%Next%>
            </ul>
        </div>

        <div style="float:left; width:15px">&nbsp;</div>

        <div class="dropdown" style="float:left;" id="ddlYear" >
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                <%For Each opt In Model.YearsList%>
                    <%If opt = Model.Year Then%>
                        <b>Year:</b> <%=opt%>
                    <%End If%>
                <%Next%>
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                <%For Each opt In Model.YearsList%>
                    <%If opt <> Model.Year Then%>
                        <li><a href="#"><%=opt%></a></li>
                    <%End If%>
                <%Next%>
            </ul>
        </div>

        <div style="">&nbsp;</div>

    </div>

    <!-- Rings -->
    <div class="header">Championships</div>
    <table class="table table-striped table-condensed">
        <thead>
            <tr>
                <th class="col-md-1">Name</th>
                <th class="col-md-1">Years</th>
                <th class="col-md-1">Rings</th>
                <th class="col-md-9">Ring %</th>
            </tr>
        </thead>
        <tbody>
            <%For Each drow As Data.DataRow In Model.Rings.Rows%>
            <tr>
                <td><%=drow("Name")%></td>
                <td><%=drow("Years")%></td>
                <td><%=drow("Rings")%></td>
                <td><%=drow("Ring %")%></td>
            </tr>
            <%Next%>
        </tbody>
    </table>

    <div class="spacer"></div>

    <!-- Record -->
    <div class="header">Record and winning percentage <span>(Finish is an average if multiple years)</span></div>
    <table class="table table-striped table-condensed">
        <thead>
            <tr>
                <th class="col-md-1">Name</th>
                <th class="col-md-1">Years</th>
                <th class="col-md-1">Finish</th>
                <th class="col-md-1">Wins</th>
                <th class="col-md-1">Losses</th>
                <th class="col-md-7">Win %</th>
            </tr>
        </thead>
        <tbody>
            <%For Each drow As Data.DataRow In Model.Record.Rows%>
            <tr>
                <td><%=drow("Name")%></td>
                <td><%=drow("Years")%></td>
                <td><%=drow("Finish")%></td>
                <td><%=drow("Wins")%></td>
                <td><%=drow("Losses")%></td>
                <td><%=drow("Win %")%></td>
            </tr>
            <%Next%>
        </tbody>
    </table>

    <div class="spacer"></div>

    <!-- Playoff Appearances -->
    <div class="header">Playoff Appearances <span>(does not include consolation playoffs)</span></div>
    <table class="table table-striped table-condensed">
        <thead>
            <tr>
                <th class="col-md-1">Name</th>
                <th class="col-md-1">Years</th>
                <th class="col-md-1">Playoffs</th>
                <th class="col-md-9">Playoff %</th>
            </tr>
        </thead>
        <tbody>
            <%For Each drow As Data.DataRow In Model.PlayoffAppearances.Rows%>
            <tr>
                <td><%=drow("Name")%></td>
                <td><%=drow("Years")%></td>
                <td><%=drow("Playoffs")%></td>
                <td><%=drow("Playoff %")%></td>
            </tr>
            <%Next%>
        </tbody>
    </table>

    <div class="spacer"></div>

    <!-- Playoff Misses -->
    <div class="header">Playoff Misses <span>(includes consolation playoff misses)</span></div>
    <table class="table table-striped table-condensed">
        <thead>
            <tr>
                <th class="col-md-1">Name</th>
                <th class="col-md-1">Years</th>
                <th class="col-md-1">Misses</th>
                <th class="col-md-9">Suck %</th>
            </tr>
        </thead>
        <tbody>
            <%For Each drow As Data.DataRow In Model.PlayoffMisses.Rows%>
            <tr>
                <td><%=drow("Name")%></td>
                <td><%=drow("Years")%></td>
                <td><%=drow("MissedPlayoffs")%></td>
                <td><%=drow("Suck %")%></td>
            </tr>
            <%Next%>
        </tbody>
    </table>

    <div class="spacer"></div>

    <!-- Points For -->
    <div class="header">Points For</div>
    <table class="table table-striped table-condensed">
        <thead>
            <tr>
                <th class="col-md-1">Name</th>
                <th class="col-md-1">Years</th>
                <th class="col-md-10">Points For</th>
            </tr>
        </thead>
        <tbody>
            <%For Each drow As Data.DataRow In Model.PointsFor.Rows%>
            <tr>
                <td><%=drow("Name")%></td>
                <td><%=drow("Years")%></td>
                <td><%=drow("Points For")%></td>
            </tr>
            <%Next%>
        </tbody>
    </table>
    
    <div class="spacer"></div>

    <!-- Points Against -->
    <div class="header">Points Against</div>
    <table class="table table-striped table-condensed">
        <thead>
            <tr>
                <th class="col-md-1">Name</th>
                <th class="col-md-1">Years</th>
                <th class="col-md-10">Points Against</th>
            </tr>
        </thead>
        <tbody>
            <%For Each drow As Data.DataRow In Model.PointsAgainst.Rows%>
            <tr>
                <td><%=drow("Name")%></td>
                <td><%=drow("Years")%></td>
                <td><%=drow("Points Against")%></td>
            </tr>
            <%Next%>
        </tbody>
    </table>

    <div class="spacer"></div>

    <!-- Moves -->
    <div class="header">Average Moves</div>
    <table class="table table-striped table-condensed">
        <thead>
            <tr>
                <th class="col-md-1">Name</th>
                <th class="col-md-11">Moves</th>
            </tr>
        </thead>
        <tbody>
            <%For Each drow As Data.DataRow In Model.Moves.Rows%>
            <tr>
                <td><%=drow("Name")%></td>
                <td><%=drow("Moves")%></td>
            </tr>
            <%Next%>
        </tbody>
    </table>

    
    <!-- Custom Range Dialog -->
    <div id="CustomRangeDialog1" style="display:none">
        <table>
            <tr>
                <td>Start:</td>
                <td><input type="text" id="txtYear12"/></td>
            </tr>
            <tr>
                <td>End:</td>
                <td><input type="text" id="txtYear22"/></td>
            </tr>
        </table>
    </div>

    <div class="modal" id="CustomRangeDialog">
      <div class="modal-dialog modal-sm">
          <div class="modal-content">
              <div class="modal-body">
                  <div class="form-group">
                      <input type="text" class="form-control" id="txtYear1" placeholder="Start year">
                  </div>
                  <div class="form-group">                      
                      <input type="text" class="form-control" id="txtYear2" placeholder="End year">
                  </div>
              </div>
              <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary" data-dismiss="modal" id="btnCustomRange">OK</button>
              </div>
          </div>
      </div>
    </div>

</asp:Content>


