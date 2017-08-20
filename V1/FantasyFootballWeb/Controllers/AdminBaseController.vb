Namespace FantasyFootballWeb
    Public MustInherit Class AdminBaseController
        Inherits BaseController

        
        Protected Overrides Sub ExecuteCore()

            Dim sec As New FF.Security()
            If sec.ValidateAuthId(AuthKey) = False Then
                Response.Write("Access denied")
            ElseIf sec.ValidateLeagueAccess(ManagerId, LeagueId) = False Then
                Response.Write("Invalid League Access")
            Else
                If Response.Cookies(Cookies.AuthKey) Is Nothing Then
                    Response.Cookies.Add(New HttpCookie(Cookies.AuthKey, AuthKey))
                Else
                    Response.Cookies(Cookies.AuthKey).Value = AuthKey
                End If

                MyBase.ExecuteCore()
            End If

        End Sub
    End Class
End Namespace