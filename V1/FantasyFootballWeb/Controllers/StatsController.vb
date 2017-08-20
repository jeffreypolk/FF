<HandleError()> _
Public Class StatsController
    Inherits FantasyFootballWeb.BaseController

    Function Index(Optional LeagueId As Integer = 1, Optional Year As String = "All Time", Optional Year1 As String = "", Optional Year2 As String = "", Optional Managers As String = "Active") As ActionResult

        Dim model As New StatsModel

        Dim IsCustomRange As Boolean
        If String.IsNullOrEmpty(Year1) = False And String.IsNullOrEmpty(Year2) = False Then
            IsCustomRange = True
            Year = Year1 & " through " & Year2
        End If

        If String.IsNullOrEmpty(Year) Then
            Year = "All Time"
        End If


        'populate year selections
        If IsCustomRange Then
            model.YearsList.Add(Year)
        End If
        model.YearsList.Add("All Time")
        model.YearsList.Add("Last 5 Years")
        model.YearsList.Add("Custom Range")
        Dim i As Integer = DatePart(DateInterval.Year, Date.Today)
        Do While i >= 2003
            model.YearsList.Add(i)
            i -= 1
        Loop

        'populate manager list
        model.ManagersList.Add("Active")
        model.ManagersList.Add("All")

        'populate league list
        model.LeagueList.Add(New StatsModel.League() With {.LeagueId = 1, .Name = "PA Fantasy"})
        model.LeagueList.Add(New StatsModel.League() With {.LeagueId = 2, .Name = "What's Your Fantasy Football"})


        model.Year = Year
        model.Year1 = Year1
        model.Year2 = Year2
        model.Managers = Managers
        model.LeagueId = LeagueId

        Dim ds As New DataSet
        Using dal As New FF.Utils.DAL()
            'set parameters
            dal.Parameters.AddWithValue("@LeagueId", LeagueId)
            Select Case True
                Case IsCustomRange
                    dal.Parameters.AddWithValue("@StartYear", Year1)
                    dal.Parameters.AddWithValue("@EndYear", Year2)
                Case Year = "All Time"
                    'use defaults so no param setting
                Case Year = "Last 5 Years"
                    dal.Parameters.AddWithValue("@StartYear", Date.Today.Year - 5)
                    dal.Parameters.AddWithValue("@EndYear", Date.Today.Year - 1)
                Case Else
                    dal.Parameters.AddWithValue("@StartYear", Year)
                    dal.Parameters.AddWithValue("@EndYear", Year)
            End Select
            dal.Parameters.AddWithValue("@Managers", Managers)
            dal.Execute("FF.uspManagerStats", ds)
        End Using

        With model
            .Rings = ds.Tables(0)
            .Record = ds.Tables(1)
            .PointsFor = ds.Tables(2)
            .PointsAgainst = ds.Tables(3)
            .Moves = ds.Tables(4)
            .PlayoffAppearances = ds.Tables(5)
            .PlayoffMisses = ds.Tables(6)
        End With


        'sort record based on year selection
        'SortDataTable(model.Record, "Finish", "ASC")

        Return View(model)
    End Function

    Private Sub SortDataTable(ByRef Data As DataTable, ColumnName As String, Direction As String)
        Data.DefaultView.Sort = ColumnName & " " & Direction
        Data = Data.DefaultView.ToTable
    End Sub
End Class
