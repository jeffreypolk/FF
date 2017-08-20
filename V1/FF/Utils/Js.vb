Namespace Utils

    Public Class Js
        Public Shared Function Escape(ByVal Value As String) As String
            Value = Value.Replace("\", "\\")
            Value = Value.Replace("""", "\""")
            Value = Value.Replace("'", "\'")
            Value = Value.Replace(vbCrLf, "\n\n")
            Value = Value.Replace(vbCr, "\n")
            Value = Value.Replace(vbLf, "\n")
            Value = Value.Replace(Chr(0), "")
            Return Value
        End Function

#Region " Format Methods "

        Public Shared Function Format(ByVal Value As String, ByVal Arg0 As Object)
            Return String.Format(Value, Arg0)
        End Function
        Public Shared Function Format(ByVal Value As String, ByVal Arg0 As Object, ByVal Arg1 As Object)
            Return String.Format(Value, Arg0, Arg1)
        End Function
        Public Shared Function Format(ByVal Value As String, ByVal Arg0 As Object, ByVal Arg1 As Object, ByVal Arg2 As Object)
            Return String.Format(Value, Arg0, Arg1, Arg2)
        End Function
        Public Shared Function Format(ByVal Value As String, ByVal ParamArray Args() As Object)
            Return String.Format(Value, Args)
        End Function
        Public Shared Function FormatEscape(ByVal Value As String, ByVal Arg0 As Object)
            Return String.Format(Value, Escape(Arg0))
        End Function
        Public Shared Function FormatEscape(ByVal Value As String, ByVal Arg0 As Object, ByVal Arg1 As Object)
            Return String.Format(Value, Escape(Arg0), Escape(Arg1))
        End Function
        Public Shared Function FormatEscape(ByVal Value As String, ByVal Arg0 As Object, ByVal Arg1 As Object, ByVal Arg2 As Object)
            Return String.Format(Value, Escape(Arg0), Escape(Arg1), Escape(Arg2))
        End Function
        Public Shared Function FormatEscape(ByVal Value As String, ByVal ParamArray Args() As Object)
            For i As Integer = 0 To Args.Length - 1
                Args(i) = Escape(Args(i))
            Next
            Return String.Format(Value, Args)
        End Function

#End Region



    End Class

End Namespace
