Namespace FantasyFootballWeb
    Public Class DraftController
        Inherits BaseController

        '
        ' GET: /Draft

        Function Index(LeagueId As Integer) As ActionResult

            Dim model As New DraftBoardModel

            Dim player As New FF.DraftManager(ManagerId, LeagueId, Year)
            model.DraftedPlayerCount = player.DraftedPlayerCount()
            model.Year = Year

            Dim team As New FF.TeamManager(LeagueId, Year)
            model.Teams = team.GetTeams().OrderBy(Function(t) t.DraftOrder).ToList()
            model.RoundCount = team.RoundCount
            model.LeagueId = LeagueId
            Return View("Board", model)

        End Function

        Function Positions(LeagueId As Integer) As ActionResult

            Dim model As New DraftBoardModel

            model.Year = Year

            Dim team As New FF.TeamManager(LeagueId, Year)
            model.Teams = team.GetTeams().OrderBy(Function(t) t.DraftOrder).ToList()
            model.RoundCount = team.RoundCount
            model.LeagueId = LeagueId
            Return View("Positions", model)

        End Function

        Function AvailablePlayers(LeagueId As Integer) As JsonResult

            Dim ret As New GridResult()
            Dim mgr As New FF.PlayerManager(ManagerId, LeagueId, Year)
            ret.Rows = mgr.GetAvailablePlayers()
            Return ret.ToJsonResult
        End Function


        Function DraftedPlayers(LeagueId As Integer) As JsonResult
            
            Dim ret As New GridResult()
            Dim mgr As New FF.PlayerManager(ManagerId, LeagueId, Year)
            ret.Rows = mgr.GetDraftedPlayers()
            Return ret.ToJsonResult

        End Function

        Function Teams(LeagueId As Integer) As JsonResult

            Dim ret As New GridResult()
            Dim mgr As New FF.TeamManager(LeagueId, Year)
            ret.Rows = mgr.GetTeams
            Return ret.ToJsonResult
        End Function

        Function DraftedPlayerCount(ByVal LeagueId As Integer) As JsonResult
            Dim ret As New JsonResult
            ret.JsonRequestBehavior = JsonRequestBehavior.AllowGet

            Dim data As New DraftedPlayerResponse

            Dim mgr As New FF.DraftManager(ManagerId, LeagueId, Year)
            data.DraftedPlayerCount = mgr.DraftedPlayerCount()
            ret.Data = data

            Return ret

        End Function

        Function Stats(Optional LeagueId As Integer = 1, Optional Year As Integer = 0, Optional Sort As String = "Projected Points") As ActionResult

            Dim model As New DraftResultsModel

            If Year = 0 Then
                Year = Date.Today.Year
            End If

            Dim i As Integer = DatePart(DateInterval.Year, Date.Today)
            Do While i >= 2012
                model.YearsList.Add(i)
                i -= 1
            Loop

            model.Year = Year
            model.LeagueId = LeagueId
            model.Sort = Sort

            'populate league list
            model.LeagueList.Add(New DraftResultsModel.League() With {.LeagueId = 1, .Name = "PA Fantasy"})
            model.LeagueList.Add(New DraftResultsModel.League() With {.LeagueId = 2, .Name = "What's Your Fantasy Football"})

            'populate sort list
            model.SortList.Add("Projected Points")
            model.SortList.Add("Actual Points")
            model.SortList.Add("Actual Finish")

            Dim ds As New DataSet
            Using dal As New FF.Utils.DAL()
                'set parameters
                dal.Parameters.AddWithValue("@LeagueId", LeagueId)
                dal.Parameters.AddWithValue("@Year", Year)
                dal.Execute("FF.uspDraftScorecard", ds)
            End Using

            With model
                .Results = ds.Tables(0)
                Select Case model.Sort
                    Case "Projected Points"
                        model.TeamInfo = model.SortDataTable(ds.Tables(1), "ProjectedFinish ASC")
                    Case "Actual Points"
                        model.TeamInfo = model.SortDataTable(ds.Tables(1), "ActualFinish ASC")
                    Case Else
                        model.TeamInfo = model.SortDataTable(ds.Tables(1), "Finish ASC")

                End Select
            End With


            'sort record based on year selection
            'SortDataTable(model.Record, "Finish", "ASC")

            Return View(model)
        End Function



        Private Class DraftedPlayerResponse
            Inherits FF.DTO.Result
            Property DraftedPlayerCount As Integer
        End Class

        Private ReadOnly Property Year As Integer
            Get
                If String.IsNullOrEmpty(Request.Form("Year")) = False Then
                    Return Request.Form("Year")
                ElseIf String.IsNullOrEmpty(Request.QueryString("Year")) = False Then
                    Return Request.QueryString("Year")
                Else
                    Return Date.Today.Year
                End If
            End Get
        End Property
    End Class
End Namespace