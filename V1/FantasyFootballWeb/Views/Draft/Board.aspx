<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/JQuery.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Draft Board
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    
    <link href="<% = ResolveUrl("~/Views/Draft/Board.css") %>" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript">
        var draftedPlayerCount = <% = Model.DraftedPlayerCount %>;
        var teamCount = <% = Model.Teams.Count %>;
        var leagueId = <% = Model.LeagueId %>;
        var year = <% = Model.Year %>;
    </script>

    <script type="text/javascript" src="<% = ResolveUrl("~/Resources/Js/jquery-1.4.1.min.js") %>"></script>
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/Draft/Board.js") %>"></script>
    

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
	
    <table>
        <tr>
            <td></td>
            <%
                For Each t As FF.DTO.Team In Model.Teams
                    Response.Write(String.Format("<td class=""team"">{0}</td>", t.Name))
                Next
            %>
        </tr>
        <%
            Dim PickIndex As Integer = 0
            Dim Cells As New Collections.Generic.List(Of String)
            For Round As Integer = 1 To Model.RoundCount
                Response.Write(String.Format("<tr><td>{0}</td>", Round))
                Cells.Clear()
                For j As Integer = 1 To Model.Teams.Count
                    PickIndex += 1
                    Cells.Add(String.Format("<td id=""pick-{0}"" class=""pick""></td>", PickIndex))
                Next
                If Round Mod 2 = 0 Then
                    Cells.Reverse()
                End If
                For Each cell As String In Cells
                    Response.Write(cell)
                Next
                Response.Write("</tr>")
            Next
        %>
        

    </table>


    <div style="display:none">
        <table>
        <tr><td>1</td><td id="pick-1" class="pick"></td><td id="pick-2" class="pick"></td><td id="pick-3" class="pick"></td><td id="pick-4" class="pick"></td><td id="pick-5" class="pick"></td><td id="pick-6" class="pick"></td><td id="pick-7" class="pick"></td><td id="pick-8" class="pick"></td><td id="pick-9" class="pick"></td><td id="pick-10" class="pick"></td></tr>
        <tr><td>2</td><td id="pick-20" class="pick"></td><td id="pick-19" class="pick"></td><td id="pick-18" class="pick"></td><td id="pick-17" class="pick"></td><td id="pick-16" class="pick"></td><td id="pick-15" class="pick"></td><td id="pick-14" class="pick"></td><td id="pick-13" class="pick"></td><td id="pick-12" class="pick"></td><td id="pick-11" class="pick"></td></tr>
        <tr><td>3</td><td id="pick-21" class="pick"></td><td id="pick-22" class="pick"></td><td id="pick-23" class="pick"></td><td id="pick-24" class="pick"></td><td id="pick-25" class="pick"></td><td id="pick-26" class="pick"></td><td id="pick-27" class="pick"></td><td id="pick-28" class="pick"></td><td id="pick-29" class="pick"></td><td id="pick-30" class="pick"></td></tr>
        <tr><td>4</td><td id="pick-40" class="pick"></td><td id="pick-39" class="pick"></td><td id="pick-38" class="pick"></td><td id="pick-37" class="pick"></td><td id="pick-36" class="pick"></td><td id="pick-35" class="pick"></td><td id="pick-34" class="pick"></td><td id="pick-33" class="pick"></td><td id="pick-32" class="pick"></td><td id="pick-31" class="pick"></td></tr>
        <tr><td>5</td><td id="pick-41" class="pick"></td><td id="pick-42" class="pick"></td><td id="pick-43" class="pick"></td><td id="pick-44" class="pick"></td><td id="pick-45" class="pick"></td><td id="pick-46" class="pick"></td><td id="pick-47" class="pick"></td><td id="pick-48" class="pick"></td><td id="pick-49" class="pick"></td><td id="pick-50" class="pick"></td></tr>
        <tr><td>6</td><td id="pick-60" class="pick"></td><td id="pick-59" class="pick"></td><td id="pick-58" class="pick"></td><td id="pick-57" class="pick"></td><td id="pick-56" class="pick"></td><td id="pick-55" class="pick"></td><td id="pick-54" class="pick"></td><td id="pick-53" class="pick"></td><td id="pick-52" class="pick"></td><td id="pick-51" class="pick"></td></tr>
        <tr><td>7</td><td id="pick-61" class="pick"></td><td id="pick-62" class="pick"></td><td id="pick-63" class="pick"></td><td id="pick-64" class="pick"></td><td id="pick-65" class="pick"></td><td id="pick-66" class="pick"></td><td id="pick-67" class="pick"></td><td id="pick-68" class="pick"></td><td id="pick-69" class="pick"></td><td id="pick-70" class="pick"></td></tr>
        <tr><td>8</td><td id="pick-80" class="pick"></td><td id="pick-79" class="pick"></td><td id="pick-78" class="pick"></td><td id="pick-77" class="pick"></td><td id="pick-76" class="pick"></td><td id="pick-75" class="pick"></td><td id="pick-74" class="pick"></td><td id="pick-73" class="pick"></td><td id="pick-72" class="pick"></td><td id="pick-71" class="pick"></td></tr>
        <tr><td>9</td><td id="pick-81" class="pick"></td><td id="pick-82" class="pick"></td><td id="pick-83" class="pick"></td><td id="pick-84" class="pick"></td><td id="pick-85" class="pick"></td><td id="pick-86" class="pick"></td><td id="pick-87" class="pick"></td><td id="pick-88" class="pick"></td><td id="pick-89" class="pick"></td><td id="pick-90" class="pick"></td></tr>
        <tr><td>10</td><td id="pick-100" class="pick"></td><td id="pick-99" class="pick"></td><td id="pick-98" class="pick"></td><td id="pick-97" class="pick"></td><td id="pick-96" class="pick"></td><td id="pick-95" class="pick"></td><td id="pick-94" class="pick"></td><td id="pick-93" class="pick"></td><td id="pick-92" class="pick"></td><td id="pick-91" class="pick"></td></tr>
        <tr><td>11</td><td id="pick-101" class="pick"></td><td id="pick-102" class="pick"></td><td id="pick-103" class="pick"></td><td id="pick-104" class="pick"></td><td id="pick-105" class="pick"></td><td id="pick-106" class="pick"></td><td id="pick-107" class="pick"></td><td id="pick-108" class="pick"></td><td id="pick-109" class="pick"></td><td id="pick-110" class="pick"></td></tr>
        <tr><td>12</td><td id="pick-120" class="pick"></td><td id="pick-119" class="pick"></td><td id="pick-118" class="pick"></td><td id="pick-117" class="pick"></td><td id="pick-116" class="pick"></td><td id="pick-115" class="pick"></td><td id="pick-114" class="pick"></td><td id="pick-113" class="pick"></td><td id="pick-112" class="pick"></td><td id="pick-111" class="pick"></td></tr>
        <tr><td>13</td><td id="pick-121" class="pick"></td><td id="pick-122" class="pick"></td><td id="pick-123" class="pick"></td><td id="pick-124" class="pick"></td><td id="pick-125" class="pick"></td><td id="pick-126" class="pick"></td><td id="pick-127" class="pick"></td><td id="pick-128" class="pick"></td><td id="pick-129" class="pick"></td><td id="pick-130" class="pick"></td></tr>
        <tr><td>14</td><td id="pick-140" class="pick"></td><td id="pick-139" class="pick"></td><td id="pick-138" class="pick"></td><td id="pick-137" class="pick"></td><td id="pick-136" class="pick"></td><td id="pick-135" class="pick"></td><td id="pick-134" class="pick"></td><td id="pick-133" class="pick"></td><td id="pick-132" class="pick"></td><td id="pick-131" class="pick"></td></tr>
        </table>
    
    </div>


</asp:Content>


