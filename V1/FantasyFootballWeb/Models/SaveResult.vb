Public Class SaveResult
    Property Result As Boolean
    Public Function ToJsonResult() As JsonResult
        Dim ret As New JsonResult
        ret.JsonRequestBehavior = JsonRequestBehavior.DenyGet
        ret.Data = Me
        Return ret
    End Function
End Class
