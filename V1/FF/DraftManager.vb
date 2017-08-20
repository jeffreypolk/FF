Public Class DraftManager

    Property Year As Integer = Date.Today.Year
    Property ManagerId As Integer
    Property LeagueId As Integer
    
    Public Sub New(ByVal ManagerId As Integer, ByVal LeagueId As Integer, ByVal Year As Integer)
        Me.ManagerId = ManagerId
        Me.LeagueId = LeagueId
        Me.Year = Year
    End Sub

    Public Function DraftPlayer(ByVal TeamId As Integer, ByVal PlayerId As Integer, ByVal Round As Integer, ByVal Overall As Integer, ByVal IsKeeper As Boolean) As DTO.DraftResult
        Dim ret As New DTO.DraftResult
        Try
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@LeagueId", Me.LeagueId)
                    .AddWithValue("@Year", Me.Year)
                    .AddWithValue("@TeamId", TeamId)
                    .AddWithValue("@PlayerId", PlayerId)
                    .AddWithValue("@Round", Round)
                    .AddWithValue("@Overall", Overall)
                    .AddWithValue("@IsKeeper", IsKeeper, ParameterDirection.Input, DbType.Boolean)
                End With
                Using dt As New DataTable
                    dal.Execute("FF.uspDraftPlayerAdd", dt)
                    If dt.Rows.Count > 0 Then
                        ret.NextPick = dt.Rows(0)("NextPick")
                        ret.NextRound = dt.Rows(0)("NextRound")
                        ret.NextTeam = dt.Rows(0)("NextTeam")
                    End If
                End Using
            End Using

            ret.Result = True
        Catch ex As Exception
            ret.Result = False
            ret.Message = ex.ToString
        End Try
        Return ret

    End Function

    Public Function UndraftPlayer(ByVal PlayerId As Integer) As DTO.DraftResult
        Dim ret As New DTO.DraftResult
        Try
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@LeagueId", LeagueId)
                    .AddWithValue("@PlayerId", PlayerId)
                End With
                Using dt As New DataTable
                    dal.Execute("FF.uspDraftPlayerRemove", dt)
                    If dt.Rows.Count > 0 Then
                        ret.NextPick = dt.Rows(0)("NextPick")
                        ret.NextRound = dt.Rows(0)("NextRound")
                        ret.NextTeam = dt.Rows(0)("NextTeam")
                    End If
                End Using
            End Using

            ret.Result = True
        Catch ex As Exception
            ret.Result = False
            ret.Message = ex.ToString
        End Try
        Return ret

    End Function

    Public Function ResetDraft() As DTO.DraftResult
        Dim ret As New DTO.DraftResult
        Try
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@LeagueId", LeagueId)
                    .AddWithValue("@Year", Year)
                End With
                Using dt As New DataTable
                    dal.Execute("FF.uspDraftReset", dt)
                    If dt.Rows.Count > 0 Then
                        ret.NextPick = dt.Rows(0)("NextPick")
                        ret.NextRound = dt.Rows(0)("NextRound")
                        ret.NextTeam = dt.Rows(0)("NextTeam")
                    End If
                End Using
            End Using

            ret.Result = True
        Catch ex As Exception
            ret.Result = False
            ret.Message = ex.ToString
        End Try
        Return ret

    End Function

    Public Function GetNextPick() As DTO.DraftResult
        Dim ret As New DTO.DraftResult
        Try
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@LeagueId", Me.LeagueId)
                    .AddWithValue("@Year", Me.Year)
                End With
                Using dt As New DataTable
                    dal.Execute("FF.uspDraftGetNextPick", dt)
                    If dt.Rows.Count > 0 Then
                        ret.NextPick = dt.Rows(0)("NextPick")
                        ret.NextRound = dt.Rows(0)("NextRound")
                        ret.NextTeam = dt.Rows(0)("NextTeam")
                    End If
                End Using
            End Using

            ret.Result = True
        Catch ex As Exception
            ret.Result = False
            ret.Message = ex.ToString
        End Try
        Return ret

    End Function

    Public ReadOnly Property DraftedPlayerCount() As Integer
        Get
            Dim ret As Integer
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@LeagueId", Me.LeagueId)
                    .AddWithValue("@Year", Me.Year)
                End With
                dal.Execute("FF.uspDraftedPlayerCount", ret)
            End Using
            Return ret
        End Get
    End Property
    

End Class
