Namespace FantasyFootballWeb
    Public MustInherit Class BaseController
        Inherits System.Web.Mvc.Controller

        Private _ManagerId As Integer?
        Private _AuthKey As String

        Public Class Cookies
            Public Const AuthKey As String = "AuthKey"
            'Public Const ManagerId As String = "ManagerId"
        End Class

        Public ReadOnly Property AuthKey As String
            Get
                If _AuthKey Is Nothing Then
                    With Request
                        If .Form(Cookies.AuthKey) IsNot Nothing Then
                            _AuthKey = .Form(Cookies.AuthKey)
                        ElseIf .QueryString(Cookies.AuthKey) IsNot Nothing Then
                            _AuthKey = .QueryString(Cookies.AuthKey)
                        ElseIf .Cookies(Cookies.AuthKey) IsNot Nothing Then
                            _AuthKey = .Cookies(Cookies.AuthKey).Value
                        Else
                            _AuthKey = String.Empty
                        End If
                    End With
                End If

                Return _AuthKey
            End Get
        End Property

        Public ReadOnly Property ManagerId As Integer
            Get
                If _ManagerId Is Nothing Then
                    If String.IsNullOrEmpty(AuthKey) Then
                        _ManagerId = 0
                    Else
                        Dim mgr As New FF.Security()
                        _ManagerId = mgr.GetManagerId(AuthKey)
                    End If
                End If
                Return _ManagerId
            End Get
        End Property

        Public ReadOnly Property LeagueId As Integer
            Get
                Dim id As Integer
                With Request
                    If .Form("LeagueId") IsNot Nothing Then
                        id = .Form("LeagueId")
                    ElseIf .QueryString("LeagueId") IsNot Nothing Then
                        id = .QueryString("LeagueId")
                    Else
                        id = 0
                    End If
                End With
                Return id
            End Get
        End Property

        Public ReadOnly Property Year As Integer
            Get
                If String.IsNullOrEmpty(Request.Form("Year")) = False Then
                    Return Request.Form("Year")
                ElseIf String.IsNullOrEmpty(Request.QueryString("Year")) = False Then
                    Return Request.QueryString("Year")
                Else
                    Return Date.Today.Year
                End If
            End Get
        End Property

    End Class
End Namespace