Namespace DTO

    Public Class Result
        Property Result As Boolean = True
        Property Message As String
    End Class

    Public Class DraftResult
        Inherits Result
        Property NextPick As Integer
        Property NextRound As Integer
        Property NextTeam As Integer
    End Class

End Namespace
