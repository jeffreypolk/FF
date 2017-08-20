Public Class DraftResultsModel

    Property LeagueId As Integer
    Property Year As Integer
    Property Results As DataTable
    Property TeamInfo As DataTable
    Property Sort As String
    Property LeagueList As New List(Of League)
    Property YearsList As New List(Of Integer)
    Property SortList As New List(Of String)

    Public Function SortDataTable(Data As DataTable, SortExpression As String)
        Dim dv As New DataView(Data)
        dv.Sort = SortExpression
        Return dv.ToTable
    End Function

    Public Function FilterDataTable(Data As DataTable, FilterExpression As String)
        Dim dv As New DataView(Data)
        dv.RowFilter = FilterExpression
        Return dv.ToTable
    End Function

    Public Function FilterAndSortDataTable(Data As DataTable, FilterExpression As String, SortExpression As String)
        Dim dv As New DataView(Data)
        dv.RowFilter = FilterExpression
        dv.Sort = SortExpression
        Return dv.ToTable
    End Function

    Public Class League
        Property LeagueId As Integer
        Property Name As String
    End Class
End Class
