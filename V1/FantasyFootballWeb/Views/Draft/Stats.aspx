<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Bootstrap.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Draft Stats
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<% = ResolveUrl("~/Views/Draft/Stats.css")%>" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/Draft/Stats.js")%>"></script>
    <script type="text/javascript">
        var leagueId = '<%=Model.LeagueId%>';
        var year = '<%=Model.Year%>';
        var sort = '<%=Model.Sort%>';
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

        <div style="float:left; width:15px">&nbsp;</div>

        <div class="dropdown" style="float:left;" id="ddlSort" >
            <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                <span style="font-size:14px;font-weight:bold;">Sort: </span>
                <span id="sort-active" style="font-size:14px;"><%=Model.Sort%></span>
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                <%For Each opt In Model.SortList%>
                    <li class="sort-option" data-sortvalue="<%=opt%>" <%=IIf(opt = Model.Sort, "style=""display:none;""", "")%>><a href="#"><%=opt%></a></li>
                <%Next%>
            </ul>
        </div>

        <div style="">&nbsp;</div>

    </div>

    <div class="panel-group" id="accordion">
        <%Dim i As Integer = 1%>
        <%For Each t In Model.TeamInfo.Rows%>
            <div class="panel panel-default" data-projfinish="<%=t("ProjectedFinish")%>" data-actfinish="<%=t("ActualFinish")%>" data-finish="<%=t("Finish")%>">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-md-2">
                            <a data-toggle="collapse" data-target="#collapse<%=t("TeamId")%>" href="javascript:void(0)">
                                <% = t("Name")%>    
                            </a>
                        </div>
                        <div class="col-md-10">
                            <span style="float:left;width:150px">Projected points: <%=t("ProjectedFinish")%></span>
                            <span style="float:left;width:130px">Actual points: <%=t("ActualFinish")%></span>
                            <span style="float:left;width:150px">Finish: <%=t("Finish")%></span>
                        </div>
                    </div>
                </div>
                <div id="collapse<%=t("TeamId")%>" class="panel-collapse collapse">
                    <div class="panel-body">
                        <div class="container">
                            <div class="row">
                                <div class="col-xs-6">
                                    <h4>Projected Points</h4>
                                    <%For Each proj In Model.FilterDataTable(Model.Results, "TeamId=" & t("TeamId") & " AND PointType = 'P'").Rows%>
                                        <div class="row">
                                            <div class="col-sm-2"><%=proj("Position")%></div>
                                            <div class="col-sm-7">
                                                <%=proj("PlayerName")%> (<%=proj("Pick") %><%If proj("Position") = "FLEX" Or proj("Position") = "BENCH" Then%>, <%=proj("PlayerPosition")%><%End If%>)
                                            </div>
                                            <div class="col-sm-3"><%=proj("Points")%></div>
                                        </div>
                                    <%Next%>
                                    <div class="row" style="border-top:solid 1px black;">
                                        <div class="col-sm-9"></div>
                                        <div class="col-sm-3"><%=t("Projected")%></div>
                                    </div>
                                </div>
                                <div class="col-xs-6">
                                    <h4>Actual Points</h4>
                                    <%For Each actual In Model.FilterDataTable(Model.Results, "TeamId=" & t("TeamId") & " AND PointType = 'A'").Rows%>
                                        <div class="row">
                                            <div class="col-sm-2"><%=actual("Position")%></div>
                                            <div class="col-sm-7">
                                                <%=actual("PlayerName")%> (<%=actual("Pick")%><%If actual("Position") = "FLEX" Or actual("Position") = "BENCH" Then%>, <%=actual("PlayerPosition")%><%End If%>)
                                            </div>
                                            <div class="col-sm-3"><%=actual("Points")%></div>
                                        </div>
                                    <%Next%>
                                    <div class="row" style="border-top:solid 1px black;">
                                        <div class="col-sm-9"></div>
                                        <div class="col-sm-3"><%=t("Actual")%></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%i += 1%>
        <%Next%>
        
    </div>
    
    <div id="panel-staging" style="display:none;"></div>

</asp:Content>


