Public Class TeamManager
    
    Property Year As Integer = Date.Today.Year
    Property LeagueId As Integer

    Public Sub New(LeagueId As Integer, Year As Integer)
        Me.LeagueId = LeagueId
        Me.Year = Year
    End Sub

    Public Function GetTeams() As List(Of DTO.Team)
        Dim dt As New DataTable
        Using dal As New Utils.DAL
            With dal.Parameters
                .AddWithValue("@LeagueId", Me.LeagueId)
                .AddWithValue("@Year", Me.Year)
            End With
            dal.Execute("FF.uspTeamsGet", dt)
        End Using
        Return ParseDataTable(dt)
    End Function

    Public Function TeamCount() As Integer
        Dim ret As Integer
        Using dal As New Utils.DAL
            With dal.Parameters
                .AddWithValue("@LeagueId", Me.LeagueId)
                .AddWithValue("@Year", Me.Year)
            End With
            dal.Execute("FF.uspTeamCount", ret)
        End Using
        Return ret
    End Function

    Public Function RoundCount() As Integer
        Dim ret As Integer
        Using dal As New Utils.DAL
            With dal.Parameters
                .AddWithValue("@LeagueId", Me.LeagueId)
                .AddWithValue("@Year", Me.Year)
            End With
            dal.Execute("SELECT Rounds FROM FF.LeagueYear WHERE LeagueId = @LeagueId AND Year = @Year", ret)
        End Using
        Return ret
    End Function

    Private Function ParseDataTable(ByVal Data As DataTable) As List(Of DTO.Team)
        Dim ret As New List(Of DTO.Team)
        For Each row As DataRow In Data.Rows
            Dim t As New DTO.Team
            With t
                .TeamId = row("TeamId")
                .Name = row("Name")
                .ManagerId = row("ManagerId")
                .Manager = row("Manager")
                .DraftOrder = row("DraftOrder")
            End With
            ret.Add(t)
        Next
        Return ret
    End Function

End Class
