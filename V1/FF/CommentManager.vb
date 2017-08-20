Public Class CommentManager

    Public Function GetComments() As List(Of DTO.Comment)
        Dim dt As New DataTable
        Using dal As New Utils.DAL
            dal.Execute("SELECT C.CommentId, C.Text, C.PostDate, C.TeamId, T.Name AS TeamName, ISNULL(T.LogoUrl, '') AS LogoUrl FROM FF.Comment C INNER JOIN FF.Team T ON C.TeamId = T.TeamId", dt)
        End Using
        Return ParseDataTable(dt)
    End Function

    Private Function ParseDataTable(ByVal Data As DataTable) As List(Of DTO.Comment)
        Dim ret As New List(Of DTO.Comment)
        For Each row As DataRow In Data.Rows
            Dim c As New DTO.Comment
            With c
                .CommentId = row("CommentId")
                .PostDate = row("PostDate")
                .TeamId = row("TeamId")
                .TeamName = row("TeamName")
                .Text = row("Text")
                .LogoUrl = row("LogoUrl")
            End With
            ret.Add(c)
        Next
        Return ret
    End Function

End Class
