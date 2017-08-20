Public Class StatsModel

    Property Rings As DataTable
    Property Record As DataTable
    Property PointsFor As DataTable
    Property PointsAgainst As DataTable
    Property Moves As DataTable
    Property PlayoffAppearances As DataTable
    Property PlayoffMisses As DataTable
    Property YearsList As New List(Of String)
    Property Year As String
    Property Year1 As String
    Property Year2 As String
    Property Managers As String
    Property LeagueId As Integer
    Property LeagueList As New List(Of League)
    Property ManagersList As New List(Of String)

    Public Class League
        Property LeagueId As Integer
        Property Name As String
    End Class
End Class


