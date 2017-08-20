Namespace FantasyFootballWeb
    Public Class CommentController
        Inherits BaseController

        '
        ' GET: /Comment

        Function Index() As ActionResult
            Return View()
        End Function


        Function Comments() As JsonResult
            Dim ret As New GridResult()
            Dim mgr As New FF.CommentManager
            ret.Rows = mgr.GetComments
            Return ret.ToJsonResult
        End Function

    End Class
End Namespace