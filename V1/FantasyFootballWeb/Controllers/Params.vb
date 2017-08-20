Public Class Params

    Private _ManagerId As Integer?
    Private _AuthKey As String

    Public ReadOnly Property AuthKey As String
        Get
            If _AuthKey Is Nothing Then
                With HttpContext.Current.Request
                    If .Form("AuthKey") IsNot Nothing Then
                        _AuthKey = .Form("AuthKey")
                    ElseIf .QueryString("AuthKey") IsNot Nothing Then
                        _AuthKey = .QueryString("AuthKey")
                    ElseIf .Cookies("AuthKey") IsNot Nothing Then
                        _AuthKey = .Cookies("AuthKey").Value
                    Else
                        _AuthKey = String.Empty
                    End If
                End With
            End If

            Return _AuthKey
        End Get
    End Property

    Public Shared ReadOnly Property SiteRoot As String
        Get
            Dim AppReader As New System.Configuration.AppSettingsReader
            Return AppReader.GetValue("SiteRoot", GetType(System.String))
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
            With HttpContext.Current.Request
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
            If String.IsNullOrEmpty(HttpContext.Current.Request.Form("Year")) = False Then
                Return HttpContext.Current.Request.Form("Year")
            ElseIf String.IsNullOrEmpty(HttpContext.Current.Request.QueryString("Year")) = False Then
                Return HttpContext.Current.Request.QueryString("Year")
            Else
                Return Date.Today.Year
            End If
        End Get
    End Property

End Class
