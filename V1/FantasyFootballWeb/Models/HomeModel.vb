Public Class HomeModel

    Property LeaguesList As New List(Of League)
    Property YearsList As New List(Of Integer)

    Public Class League
        Property LeagueId As Integer
        Property Name As String
    End Class
End Class
