Namespace FantasyFootballWeb
    Public Class AdminController
        Inherits AdminBaseController

        Function Index() As ActionResult
            ViewData("Year") = Year
            ViewData("LeagueId") = LeagueId
            Dim PlayerMgr As New FF.PlayerManager(ManagerId, LeagueId, Year)
            Dim DraftMgr As New FF.DraftManager(ManagerId, LeagueId, Year)
            ViewData("CurrentPickNumber") = DraftMgr.GetNextPick.NextPick
            ViewData("Keywords") = String.Join("|", PlayerMgr.Keywords.ToArray)
            Return View()
        End Function

        Function UpdateADP() As ActionResult
            Return View()
        End Function

        Function Players() As JsonResult
            Dim ret As New GridResult()
            Dim mgr As New FF.PlayerManager(ManagerId, LeagueId, Year)
            ret.Rows = mgr.GetPlayers
            Return ret.ToJsonResult
        End Function

        <HttpPost()> _
        Function SavePlayer(ByVal PlayerId As Integer, ByVal Name As String, ByVal Position As String, ByVal Team As String, ByVal Age As Integer, ByVal Experience As Integer, ByVal DepthChart As Integer, ByVal Keywords As String, ByVal Comments As String, ByVal ProjectedPoints As Decimal, ByVal ActualPoints As Decimal, ByVal Odds As Integer) As JsonResult
            Dim ret As New JsonResult
            Dim mgr As New FF.PlayerManager(ManagerId, LeagueId, Year)
            ret.Data = mgr.SavePlayer(PlayerId, Name, Position, Team, Age, Experience, DepthChart, Keywords, Comments, ProjectedPoints, ActualPoints, Odds)
            Return ret
        End Function

        <HttpPost()> _
        Function UpdateADP(Data As String) As JsonResult
            Dim ret As New JsonResult
            Dim mgr As New FF.PlayerManager(ManagerId, LeagueId, Year)
            Dim DataArray() As String = Data.Split("|")
            For Each item In DataArray
                Dim info As String() = item.Split("~")
                mgr.UpdateADP(info(0), info(1))
            Next
            Return ret
        End Function

        <HttpPost()> _
        Function RebuildKeywords() As JsonResult
            Dim ret As New JsonResult
            Dim info As New FF.DTO.Result
            Dim mgr As New FF.PlayerManager(ManagerId, LeagueId, Year)
            mgr.RebuildKeywords()
            ret.Data = info
            Return ret
        End Function

    End Class
End Namespace