Public Class GridResult
    Property Rows As Object
    Public Sub New()
    End Sub
    Public Sub New(ByVal Rows As Object)
        Rows = Rows
    End Sub
    Public Function ToJsonResult()
        Dim ret As New JsonResult
        ret.JsonRequestBehavior = JsonRequestBehavior.AllowGet
        ret.Data = Me
        Return ret
    End Function
End Class
