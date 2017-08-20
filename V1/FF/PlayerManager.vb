Public Class PlayerManager

    Property Year As Integer = Date.Today.Year
    Property ManagerId As Integer
    Property LeagueId As Integer
    Private Shared _Keywords As New Dictionary(Of String, List(Of String))
    Private Shared _KeywordsSyncLock As New Object

    Public Sub New(ByVal ManagerId As Integer, ByVal LeagueId As Integer, ByVal Year As Integer)
        Me.ManagerId = ManagerId
        Me.LeagueId = LeagueId
        Me.Year = Year
    End Sub

    Public Function GetAvailablePlayers() As List(Of DTO.Player)
        Dim dt As New DataTable
        Using dal As New Utils.DAL
            With dal.Parameters
                .AddWithValue("@LeagueId", LeagueId)
                .AddWithValue("@Year", Year)
            End With
            dal.Execute("FF.uspAvailablePlayersGet", dt)
        End Using
        Return ParseDataTable(dt)
    End Function

    Public Function GetPlayers() As List(Of DTO.Player)
        Dim dt As New DataTable
        Using dal As New Utils.DAL
            With dal.Parameters
                .AddWithValue("@ManagerId", ManagerId)
                .AddWithValue("@LeagueId", LeagueId)
                .AddWithValue("@Year", Year)
            End With
            dal.Execute("FF.uspPlayersGet", dt)
        End Using
        Return ParseDataTable(dt)
    End Function

    Public Function GetDraftedPlayers() As List(Of DTO.Player)
        Dim dt As New DataTable
        Using dal As New Utils.DAL
            With dal.Parameters
                .AddWithValue("@LeagueId", LeagueId)
                .AddWithValue("@Year", Year)
            End With
            dal.Execute("FF.uspDraftedPlayersGet", dt)
        End Using
        Return ParseDataTable(dt)
    End Function

    Public Function SavePlayer(ByVal PlayerId As Integer, ByVal Name As String, ByVal Position As String, ByVal Team As String, ByVal Age As Integer, ByVal Experience As Integer, ByVal DepthChart As Integer, ByVal Keywords As String, ByVal Comments As String, ProjectedPoints As Decimal, ActualPoints As Decimal, Odds As Integer) As DTO.Result
        Dim ret As New DTO.Result
        Try
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@ManagerId", ManagerId)
                    .AddWithValue("@PlayerId", PlayerId)
                    .AddWithValue("@Year", Year)
                    .AddWithValue("@Name", Name)
                    .AddWithValue("@Position", Position)
                    .AddWithValue("@NFLTeam", Team)
                    .AddWithValue("@Age", Age)
                    .AddWithValue("@Experience", Experience)
                    .AddWithValue("@DepthChart", DepthChart)
                    .AddWithValue("@Keywords", Keywords)
                    .AddWithValue("@Comments", Comments)
                    .AddWithValue("@ProjectedPoints", ProjectedPoints)
                    .AddWithValue("@ActualPoints", ActualPoints)
                    .AddWithValue("@Odds", Odds)
                End With
                dal.Execute("FF.uspPlayerSave")
                RegisterKeywords(Keywords)
            End Using

            ret.Result = True
        Catch ex As Exception
            ret.Result = False
            ret.Message = ex.ToString
        End Try
        Return ret

    End Function

    Private Function ParseDataTable(ByVal Data As DataTable) As List(Of DTO.Player)
        Dim ret As New List(Of DTO.Player)
        For Each row As DataRow In Data.Rows
            Dim p As New DTO.Player
            With p
                .PlayerId = row("PlayerId")
                .Name = row("Name")
                .NFLTeam = row("NFLTeam")
                .Position = row("Position")
                .TeamId = row("TeamId")
                .Team = row("team")
                If Data.Columns("TeamGroupName") IsNot Nothing Then
                    .TeamGroupName = row("TeamGroupName")
                End If
                .Round = row("Round")
                .Overall = row("Overall")
                .Bye = row("Bye")
                .ADP = row("ADP")
                .Age = row("Age")
                .Experience = row("Experience")
                If Data.Columns("DepthChart") IsNot Nothing Then
                    .DepthChart = row("DepthChart")
                End If
                If Data.Columns("IsKeeper") IsNot Nothing Then
                    .IsKeeper = row("IsKeeper")
                End If
                If Data.Columns("Keywords") IsNot Nothing Then
                    If row("Keywords") Is System.DBNull.Value = False Then
                        .Keywords = row("Keywords")
                    End If
                End If
                If Data.Columns("Comments") IsNot Nothing Then
                    If row("Comments") Is System.DBNull.Value = False Then
                        .Comments = row("Comments")
                    End If
                End If
                .ProjectedPoints = row("ProjectedPoints")
                .ActualPoints = row("ActualPoints")
                .Odds = row("Odds")
            End With
            ret.Add(p)
        Next
        Return ret
    End Function

    Public Function AddComment(ByVal PlayerId As Integer, Comment As String) As DTO.Result
        Dim ret As New DTO.Result
        Try
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@PlayerId", PlayerId)
                    .AddWithValue("@Comment", Comment)
                End With
                dal.Execute("UPDATE Player SET Comment = @Comment WHERE PlayerId = @PlayerId")
            End Using

            ret.Result = True
        Catch ex As Exception
            ret.Result = False
            ret.Message = ex.ToString
        End Try
        Return ret

    End Function

    Public Function UpdateADP(ByVal Name As String, ADP As Decimal) As DTO.Result
        Dim ret As New DTO.Result
        Try
            Using dal As New Utils.DAL
                With dal.Parameters
                    .AddWithValue("@Name", Name)
                    .AddWithValue("@Year", Year)
                    .AddWithValue("@ADP", ADP)
                End With
                dal.Execute("UPDATE FF.Player SET ADP = @ADP WHERE Name = @Name AND Year = @Year")
            End Using

            ret.Result = True
        Catch ex As Exception
            ret.Result = False
            ret.Message = ex.ToString
        End Try
        Return ret

    End Function

    Private ReadOnly Property KeywordKey As String
        Get
            Return String.Format("{0}-{1}", ManagerId, Year)
        End Get
    End Property

    Public Sub RebuildKeywords()
        SyncLock _KeywordsSyncLock
            If _Keywords.ContainsKey(KeywordKey) Then
                _Keywords.Remove(KeywordKey)
            End If
        End SyncLock
    End Sub

    Public ReadOnly Property Keywords As List(Of String)
        Get

            SyncLock _KeywordsSyncLock
                If _Keywords.ContainsKey(KeywordKey) = False Then
                    Dim dt As New DataTable
                    
                    Using dal As New Utils.DAL
                        With dal.Parameters
                            .AddWithValue("@ManagerId", ManagerId)
                            .AddWithValue("@Year", Year)
                        End With
                        dal.Execute("FF.uspPlayerKeywordsGet", dt)
                    End Using

                    Dim WordList As New List(Of String)
                    Dim Words As String()

                    For Each row As DataRow In dt.Rows
                        Words = row("Keywords").ToString.Split(" ")
                        For Each w In Words
                            If WordList.Contains(w) = False Then
                                WordList.Add(w)
                            End If
                        Next
                    Next
                    WordList.Sort()
                    _Keywords.Add(KeywordKey, WordList)
                End If
            End SyncLock

            Return _Keywords(KeywordKey)

        End Get
    End Property

    Public Sub RegisterKeywords(ByVal Keywords As String)
        If String.IsNullOrEmpty(Keywords) Then
            Exit Sub
        End If
        Dim WordList As List(Of String) = Me.Keywords
        For Each word As String In Keywords.Split(" ")
            If WordList.Contains(word) = False Then
                WordList.Add(word)
            End If
        Next
        WordList.Sort()
    End Sub
End Class
