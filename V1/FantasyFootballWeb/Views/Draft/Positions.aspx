<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/SiteBlank.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Draft Positions
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    
    <link href="<% = ResolveUrl("~/Views/Draft/Board.css") %>" rel="stylesheet" type="text/css" />
    
    <style type="text/css">
        .pick 
        {
            font-size: 14px;
            background-color:#B8CAEA;
            text-align: center;
            
        }    
    </style>

    <script type="text/javascript" src="<% = ResolveUrl("~/Resources/Js/jquery-1.4.1.min.js") %>"></script>

    <script type="text/javascript">


        $(document).ready(function () {
            
        });    
    </script>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
	
    <table>
        <tr>
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
                Cells.Clear()
                For j As Integer = 1 To Model.Teams.Count
                    PickIndex += 1
                    Cells.Add(String.Format("<td id=""pick-{0}"" class=""pick"">{0}, {1}</td>", Round, PickIndex))
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

</asp:Content>


