Namespace FantasyFootballWeb
    Public Class DraftAdminController
        Inherits AdminBaseController

        '
        ' GET: /Draft

        Function Index() As ActionResult

            Dim sec As New FF.Security()
            If sec.IsCommish(ManagerId, LeagueId, Year) = False Then
                Return View("NoAccess")
            End If

            Dim draft As New FF.DraftManager(ManagerId, LeagueId, Year)
            With draft.GetNextPick()
                ViewData("NextTeam") = .NextTeam
                ViewData("NextRound") = .NextRound
                ViewData("NextPick") = .NextPick
            End With
            ViewData("Year") = Year
            ViewData("LeagueId") = LeagueId
            Return View()

        End Function

        <HttpPost()> _
        Function DraftPlayer(ByVal TeamId As Integer, ByVal PlayerId As Integer, ByVal Round As Integer, ByVal Overall As Integer, IsKeeper As Boolean) As JsonResult

            Dim ret As New JsonResult
            Dim mgr As New FF.DraftManager(ManagerId, LeagueId, Year)
            ret.Data = mgr.DraftPlayer(TeamId, PlayerId, Round, Overall, IsKeeper)
            Return ret
        End Function

        <HttpPost()> _
        Function UndraftPlayer(ByVal PlayerId As Integer) As JsonResult
            Dim ret As New JsonResult
            Dim mgr As New FF.DraftManager(ManagerId, LeagueId, Year)
            If PlayerId = 0 Then
                ret.Data = mgr.ResetDraft()
            Else
                ret.Data = mgr.UndraftPlayer(PlayerId)
            End If

            Return ret

        End Function

        <HttpPost()> _
        Function AddPlayer(ByVal Name As String, ByVal Position As String, ByVal Team As String) As JsonResult
            Dim ret As New JsonResult
            Dim mgr As New FF.PlayerManager(ManagerId, LeagueId, Year)
            ret.Data = mgr.SavePlayer(0, Name, Position, Team, 0, 0, 0, "", "", 0, 0, 0)
            Return ret
        End Function

    End Class
End Namespace