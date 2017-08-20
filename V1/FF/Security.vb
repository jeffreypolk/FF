Public Class Security

    Public Function ValidateAuthId(ByVal AuthId As String) As Boolean
        Dim ret As Boolean = False
        Try
            If String.IsNullOrEmpty(AuthId) Then
                ret = False
            Else
                Dim dt As DataTable
                Using dal As New Utils.DAL
                    With dal.Parameters
                        .AddWithValue("@AuthId", AuthId)
                    End With
                    dal.Execute("SELECT ManagerId FROM FF.Manager WHERE AuthId = @AuthId", dt)
                    If dt.Rows.Count > 0 Then
                        ret = True
                    End If
                End Using
            End If
        Catch ex As Exception
            Throw 'New Exception("Invalid Authorization")
        End Try
        Return ret
    End Function

    Public Function ValidateLeagueAccess(ByVal ManagerId As Integer, ByVal LeagueId As Integer) As Integer
        Try
            Dim ret As Boolean = False
            Dim dt As DataTable
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@ManagerId", ManagerId)
                    .AddWithValue("@LeagueId", LeagueId)
                End With
                dal.Execute("SELECT TeamId FROM FF.Team WHERE ManagerId = @ManagerId AND LeagueId = @LeagueId", dt)
                If dt.Rows.Count > 0 Then
                    ret = True
                End If
                dt.Dispose()
            End Using
            Return ret
        Catch ex As Exception
            Throw New Exception("Invalid League Access")
        End Try

    End Function

    Public Function GetManagerId(ByVal AuthId As String) As Integer
        Dim ret As Integer = 0
        Try
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@AuthId", AuthId)
                End With
                dal.Execute("SELECT ManagerId FROM FF.Manager WHERE AuthId = @AuthId", ret)
            End Using
        Catch ex As Exception
            Throw New Exception("Invalid Authorization")
        End Try
        Return ret
    End Function

    Public Function IsCommish(ByVal ManagerId As Integer, ByVal LeagueId As Integer, ByVal Year As Integer) As Boolean
        Dim ret As Boolean = False
        Try
            Using dal As New Utils.DAL
                Dim dt As DataTable
                With dal.Parameters
                    .AddWithValue("@ManagerId", ManagerId)
                    .AddWithValue("@LeagueId", LeagueId)
                    .AddWithValue("@Year", Year)
                End With
                dal.Execute("SELECT TeamId FROM FF.Team WHERE ManagerId = @ManagerId AND LeagueId = @LeagueId AND [Year] = @Year AND IsCommish = 1", dt)
                If dt.Rows.Count > 0 Then
                    ret = True
                End If
            End Using
        Catch ex As Exception
            Throw New Exception("Invalid Authorization")
        End Try
        Return ret
    End Function


End Class
