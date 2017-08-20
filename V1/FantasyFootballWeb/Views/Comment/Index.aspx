<%@ Page Title="" Language="VB" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Index
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Resources/Css/Comments.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/Comment/CommentsGrid.js") %>"></script>
    <script type="text/javascript" src="<% = ResolveUrl("~/Views/Comment/IndexLayout.js") %>"></script>
    
</asp:Content>
