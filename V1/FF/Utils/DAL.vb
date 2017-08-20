Imports System.Data.SqlClient

Namespace Utils

    Public Class DAL
        Implements System.IDisposable

        Private _ConnectionString As String = String.Empty
        Private _Connection As SqlConnection
        Private _Transaction As SqlTransaction
        Private _KeepAlive As Boolean = False
        Private _Parameters As New ParameterCollection
        Private _Timeout As New Integer

#Region " Constructor "

        Public Sub New()
            _ConnectionString = GetCnnStr()
        End Sub

        Public Sub New(ByVal KeepConnectionAlive As Boolean)
            _ConnectionString = GetCnnStr()
            _KeepAlive = KeepConnectionAlive
        End Sub

        Public Sub New(ByVal KeepConnectionAlive As Boolean, ByVal ConnectionString As String)
            _KeepAlive = KeepConnectionAlive
            _ConnectionString = ConnectionString
        End Sub

#End Region

        Public ReadOnly Property Parameters() As ParameterCollection
            Get
                Return _Parameters
            End Get
        End Property

        Public Property Timeout() As Integer
            Get
                Return _Timeout
            End Get
            Set(ByVal value As Integer)
                _Timeout = value
            End Set
        End Property

        Public Sub BeginTransaction(Optional ByRef Transaction As SqlTransaction = Nothing)
            OpenConnection()
            _KeepAlive = True
            If IsNothing(Transaction) Then
                _Transaction = _Connection.BeginTransaction()
            Else
                _Transaction = Transaction
            End If
        End Sub

        Public Sub EndTransaction(Optional ByVal CommitChanges As Boolean = True)
            If IsNothing(_Transaction) Then
                Exit Sub
            End If
            If CommitChanges Then
                _Transaction.Commit()
            Else
                _Transaction.Rollback()
            End If
            _Transaction.Dispose()
            _Transaction = Nothing
        End Sub

        Private Function BuildCommand(ByVal SQL As String) As SqlCommand
            OpenConnection()
            Using Command As New SqlCommand("SET ARITHABORT ON", _Connection)
                If _Transaction IsNot Nothing Then
                    Command.Transaction = _Transaction
                End If
                Command.ExecuteNonQuery()
            End Using

            Using Command As New SqlCommand(SQL, _Connection)
                Command.CommandType = GetCommandType(SQL)
                If _Timeout >= 0 Then
                    Command.CommandTimeout = _Timeout
                End If
                If _Transaction IsNot Nothing Then
                    Command.Transaction = _Transaction
                End If
                Command.Parameters.Clear()
                If Parameters.Count > 0 Then
                    For Each sp As SqlParameter In Parameters
                        Command.Parameters.Add(sp)
                    Next
                End If
                Return Command
            End Using
        End Function

        Private Function GetCommandType(ByVal SQL As String) As CommandType
            If SQL.IndexOf(" ") >= 0 Then
                Return CommandType.Text
            Else
                Return CommandType.StoredProcedure
            End If
        End Function

        Private Sub OpenConnection()
            If IsNothing(_Connection) Then
                _Connection = New SqlConnection(_ConnectionString)
                _Connection.Open()
            End If
        End Sub

        Private Sub CloseConnection()
            If IsNothing(_Connection) Then
                Exit Sub
            End If
            If _KeepAlive Then
                Exit Sub
            End If
            'make sure transaction is cleaned up
            EndTransaction(False)
            'close it
            _Connection.Close()
            _Connection.Dispose()
            _Connection = Nothing
        End Sub

        Private Function GetCnnStr() As String

            Dim retValue As String = ""


            Try
                ' Try getting the string from Web.config/App.config
                Dim AppReader As New System.Configuration.AppSettingsReader
                retValue = AppReader.GetValue("CnnStr", GetType(System.String))
            Catch ex As Exception

                'called from app, get connection string from config.xml
                Dim config As New System.Xml.XmlDocument, param As System.Xml.XmlNode
                Try
                    config.Load(System.AppDomain.CurrentDomain.BaseDirectory() & "config.xml")
                    param = config.SelectSingleNode("//parameter[@name='ConnectionString']")
                    If Not IsNothing(param) Then
                        retValue = param.Attributes("value").Value
                        'remove provider if in connection string (vb6 uses provider)
                        retValue = retValue.ToString.Replace("Provider=SQLOLEDB;", "")
                        retValue = retValue.ToString.Replace("Provider=SQLOLEDB", "")
                    End If

                Catch ex1 As Exception
                    LogErrorToEventViewer(ex, "DAL.GetCnnStr", "Fetching CnnStr from Config.xml")
                Finally
                    config = Nothing
                    param = Nothing
                End Try
            End Try

            Return retValue

        End Function

        Private Sub LogErrorToEventViewer(ByVal ex As Exception, Optional ByVal Location As String = "", Optional ByVal Description As String = "")
            'log this to the event viewer
            Try
                ' /********************************************************************************/
                ' PROBLEM: The code below will not work without excessive permissions granted to the application identity,
                ' that is permission to enumerate or create registry keys.
                ' SOLUTION: is to use an installer feature to create the event log source.
                ' Also note IUSR or any Guests will not by default have rights to write to the event log.
                ' See kb323076 and System.Security.Principal.WindowsIdentity.GetCurrent.Name()'s rights.
                'If Not objEventLog.SourceExists("Akcelerant Framework") Then
                '    objEventLog.CreateEventSource("Akcelerant Framework", "Application")
                'End If
                ' /********************************************************************************/
                ' TODO: Add creating log source reg key to installer
                ' TODO: Probably want this put into installer as a prompt, save it to appSettings, and read it back from there.
                Dim src As String = "Akcelerant Framework"
                Dim Message As String = ""

                ' HACK: Until creating log source regkey is in installer, use a likely alternate
                Try
                    Dim b As Boolean = EventLog.SourceExists(src) ' die trying
                Catch ex2 As Exception
                    src = "VBRuntime"
                End Try

                'build the message to include both errors
                Message = String.Format("Initial Error:{0}{1}{0}{2}{0}{0}An error occurred while logging to the database:{0}{3}", New String() {vbCrLf, Description, Location, ex.ToString})

                ' Note that if the user does have rights, this call will create the event log source if it does not exist.
                EventLog.WriteEntry(src, Message, EventLogEntryType.Error)
            Catch ex3 As System.Exception
            End Try
        End Sub


        Private Function GetStringNullSafe(ByVal sdr As SqlDataReader, ByVal ColIndex As Integer) As String
            If sdr Is Nothing OrElse sdr.IsDBNull(ColIndex) Then
                Return String.Empty
            Else
                Return sdr.GetString(ColIndex)
            End If
        End Function


#Region "Execute Overloads"

        Public Sub Execute(ByVal SQL As String, ByRef ReturnParam As String)
            Try
                Using cmd As SqlCommand = BuildCommand(SQL)
                    'ExecuteScalar will truncate strings at 2033 characters
                    'therefore, execute a reader and combine all rows into a string
                    Dim ret As New Text.StringBuilder
                    Dim sdr As SqlDataReader = cmd.ExecuteReader()
                    While sdr.Read
                        ret.Append(sdr.Item(0))
                    End While
                    sdr.Close()
                    sdr = Nothing
                    ReturnParam = ret.ToString
                    ret.Length = 0
                    ret = Nothing
                    'ReturnParam = cmd.ExecuteScalar
                End Using
            Catch ex As Exception
                Throw
            Finally
                CloseConnection()
            End Try
        End Sub

        Public Sub Execute(ByVal SQL As String, ByRef ReturnParam As Boolean)
            Try
                Using cmd As SqlCommand = BuildCommand(SQL)
                    Dim SQLResult As String = cmd.ExecuteScalar
                    Select Case SQLResult.ToLower
                        Case "0" : ReturnParam = False
                        Case "-1" : ReturnParam = False
                        Case "1" : ReturnParam = True
                        Case "false" : ReturnParam = False
                        Case "true" : ReturnParam = True
                        Case Else
                            If Not Boolean.TryParse(SQLResult, ReturnParam) Then
                                Throw New Exception("Dal.Execute() was unable to convert '" & SQLResult & "' to a Boolean.")
                            End If
                    End Select

                End Using
            Catch ex As Exception
                Throw
            Finally
                CloseConnection()
            End Try
        End Sub

        Public Sub Execute(ByVal SQL As String, ByRef ReturnParam As Integer)
            Try
                Using cmd As SqlCommand = BuildCommand(SQL)
                    Dim SQLResult As String = cmd.ExecuteScalar
                    If Not Integer.TryParse(SQLResult, ReturnParam) Then
                        Throw New Exception("Dal.Execute() was unable to convert '" & SQLResult & "' to a Integer.")
                    End If
                End Using
            Catch ex As Exception
                Throw
            Finally
                CloseConnection()
            End Try
        End Sub

        Public Sub Execute(ByVal SQL As String, ByRef ReturnParam As DataTable)
            Try
                Using cmd As SqlCommand = BuildCommand(SQL)
                    Using da As New SqlDataAdapter
                        If ReturnParam Is Nothing Then ReturnParam = New DataTable()
                        da.SelectCommand = cmd
                        da.Fill(ReturnParam)
                    End Using
                End Using
            Catch ex As Exception
                Throw
            Finally
                CloseConnection()
            End Try
        End Sub


        Public Sub Execute(ByVal SQL As String, ByRef ReturnParam As DataSet)
            Try
                Using cmd As SqlCommand = BuildCommand(SQL)
                    Using da As New SqlDataAdapter
                        da.SelectCommand = cmd
                        If ReturnParam Is Nothing Then ReturnParam = New DataSet()
                        da.SelectCommand = cmd
                        da.Fill(ReturnParam)
                    End Using
                End Using
            Catch ex As Exception
                Throw
            Finally
                CloseConnection()
            End Try
        End Sub

        Public Sub Execute(ByVal SQL As String, ByRef ReturnParam As DataSet, ByVal DataSetName As String)
            Try
                Using cmd As SqlCommand = BuildCommand(SQL)
                    Using da As New SqlDataAdapter
                        da.SelectCommand = cmd
                        If ReturnParam Is Nothing Then ReturnParam = New DataSet()
                        da.SelectCommand = cmd
                        da.Fill(ReturnParam, DataSetName)
                    End Using
                End Using
            Catch ex As Exception
                Throw
            Finally
                CloseConnection()
            End Try
        End Sub

        Public Sub Execute(ByVal SQL As String)
            Try
                Using cmd As SqlCommand = BuildCommand(SQL)
                    cmd.ExecuteNonQuery()
                End Using
            Catch ex As Exception
                Throw
            Finally
                CloseConnection()
            End Try
        End Sub

        Public Sub Execute(ByVal SQL As String, ByRef ReturnParam As Decimal)
            Try
                Using cmd As SqlCommand = BuildCommand(SQL)
                    Dim SQLResult As String = cmd.ExecuteScalar
                    If Not Decimal.TryParse(SQLResult, ReturnParam) Then
                        Throw New Exception("Dal.Execute() was unable to convert '" & SQLResult & "' to a Decimal.")
                    End If
                End Using
            Catch ex As Exception
                Throw
            Finally
                CloseConnection()
            End Try
        End Sub

#End Region

#Region "===== Specialized Execute Methods ====="

        Public Sub ExecuteForXML(ByVal SQL As String, ByRef ReturnParam As String)
            ' ----------------------------------------------
            Dim strXML As New System.Text.StringBuilder()
            ' ----------------------------------------------
            Using cmd As SqlCommand = BuildCommand(SQL)
                Using sdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.Default)
                    With sdr
                        If .Read Then
                            strXML.Append(GetStringNullSafe(sdr, 0))
                            Do While .Read
                                strXML.Append(GetStringNullSafe(sdr, 0))
                            Loop
                        End If
                        While .NextResult
                            If .Read Then
                                strXML.Append(GetStringNullSafe(sdr, 0))
                                Do While .Read
                                    strXML.Append(GetStringNullSafe(sdr, 0))
                                Loop
                            End If
                        End While
                    End With
                End Using
            End Using

            'return the xml string
            ReturnParam = strXML.ToString
        End Sub

#End Region

#Region "Updates"
        Public Sub UpdateFromDataTable(ByVal TableName As String, ByRef ReturnParam As DataTable)
            Dim SQLSelectCommand As New System.Text.StringBuilder
            Try
                Using da As New SqlDataAdapter
                    If ReturnParam Is Nothing Then
                        ReturnParam = New DataTable()
                    End If
                    If ReturnParam.Columns.Count > 0 Then
                        SQLSelectCommand.Append("SELECT ")
                        For Each col As DataColumn In ReturnParam.Columns
                            SQLSelectCommand.Append(col.ColumnName)
                            SQLSelectCommand.Append(",")
                        Next
                        SQLSelectCommand.Append("FROM ")
                        SQLSelectCommand.Append(TableName)
                    End If

                    If SQLSelectCommand.Length > 0 Then
                        da.SelectCommand = BuildCommand(SQLSelectCommand.ToString.Replace(",FROM ", " FROM "))

                        Using cmdBuilder As New SqlCommandBuilder(da)
                            cmdBuilder.GetUpdateCommand()
                            cmdBuilder.GetInsertCommand()
                            cmdBuilder.GetDeleteCommand()
                            da.Update(ReturnParam)
                        End Using
                    End If
                End Using
            Catch ex As Exception
                Throw
            Finally
                SQLSelectCommand = Nothing
                CloseConnection()
            End Try
        End Sub
#End Region

        Public Class ParameterCollection
            Inherits CollectionBase
            Default Public Property Item(ByVal Index As Integer) As SqlParameter
                Get
                    Return CType(List.Item(Index), SqlParameter)
                End Get
                Set(ByVal value As SqlParameter)
                    List.Item(Index) = value
                End Set
            End Property

            Default Public Property Item(ByVal Name As String) As SqlParameter
                Get
                    Dim ReturnValue As SqlParameter = Nothing
                    For Each sp As SqlParameter In List
                        If sp.ParameterName = Name Then
                            ReturnValue = sp
                        End If
                    Next
                    Return ReturnValue
                End Get
                Set(ByVal value As SqlParameter)
                    For Each sp As SqlParameter In List
                        If sp.ParameterName = value.ParameterName Then
                            sp = value
                        End If
                    Next
                End Set
            End Property
            ''' <summary>
            ''' Adds a parameter to the DAL's parameter collection.
            ''' </summary>
            ''' <param name="Name">The name of the parameter.  Must include the "@" symbol.</param>
            ''' <param name="Value">The value to be assigned to the parameter.</param>
            ''' <returns>A System.Data.Sqlclient.SqlParameter object.</returns>
            ''' <remarks>Although there's not much use for the returned parameter, this is provided for consistency with the way that the System.Data.SqlClient.SqlCommand.AddwithValue() method works.</remarks>
            Public Function AddWithValue(ByVal Name As String, ByVal Value As Object) As SqlParameter
                Dim NewParameter As New SqlParameter
                NewParameter.ParameterName = Name
                NewParameter.Value = Value
                List.Add(NewParameter)
                Return NewParameter
            End Function
            ''' <summary>
            ''' Adds a parameter to the DAL's parameter collection.
            ''' </summary>
            ''' <param name="Name">The name of the parameter.  Must include the "@" symbol.</param>
            ''' <param name="value">The value to be assigned to the parameter.</param>
            ''' <param name="Direction">The direction type of the parameter.</param>
            ''' <param name="ParameterDBType">The System.Data.DbType of the parameter.</param>
            ''' <returns>A System.Data.Sqlclient.SqlParameter object.</returns>
            ''' <remarks>Although there's not much use for the returned parameter, this is provided for consistency with the way that the System.Data.SqlClient.SqlCommand.AddwithValue() method works.</remarks>
            Public Function AddWithValue(ByVal Name As String, ByVal value As Object, ByVal Direction As ParameterDirection, ByVal ParameterDBType As System.Data.DbType) As SqlParameter
                Dim NewParameter As New SqlParameter
                With NewParameter
                    .ParameterName = Name
                    .Value = value
                    .Direction = Direction
                    .DbType = ParameterDBType
                End With
                List.Add(NewParameter)
                Return NewParameter
            End Function
            ''' <summary>
            ''' Adds a parameter to the DAL's parameter collection.
            ''' </summary>
            ''' <param name="Name">The name of the parameter.  Must include the "@" symbol.</param>
            ''' <param name="value">The value to be assigned to the parameter.</param>
            ''' <param name="Direction">The direction type of the parameter.</param>
            ''' <param name="ParameterDBType">The System.Data.DbType of the parameter.</param>
            ''' <param name="Size">An Integer indicating how many bytes the SqlParameter needs.  Usually only relevant for parameters of type VarChar.</param>
            ''' <returns>A System.Data.Sqlclient.SqlParameter object.</returns>
            ''' <remarks>Although there's not much use for the returned parameter, this is provided for consistency with the way that the System.Data.SqlClient.SqlCommand.AddwithValue() method works.</remarks>
            Public Function AddWithValue(ByVal Name As String, ByVal value As Object, ByVal Direction As ParameterDirection, ByVal ParameterDBType As System.Data.DbType, ByVal Size As Integer) As SqlParameter
                Dim NewParameter As New SqlParameter
                With NewParameter
                    .ParameterName = Name
                    .Value = value
                    .Direction = Direction
                    .DbType = ParameterDBType
                    .Size = Size
                End With
                List.Add(NewParameter)
                Return NewParameter
            End Function

            ''' <summary>
            ''' Clears the parameters in DAL's parameter collection.
            ''' </summary>
            Public Overloads Sub Clear()
                MyBase.Clear()
            End Sub
        End Class

#Region " IDisposable Support "

        Private disposedValue As Boolean = False        ' To detect redundant calls

        ' IDisposable
        Protected Overridable Sub Dispose(ByVal disposing As Boolean)
            If Not Me.disposedValue Then
                If disposing Then
                    ' TODO: free other state (managed objects).
                End If

                ' TODO: free your own state (unmanaged objects).
                ' TODO: set large fields to null.
            End If
            Me.disposedValue = True
        End Sub

        ' This code added by Visual Basic to correctly implement the disposable pattern.
        Public Sub Dispose() Implements IDisposable.Dispose
            ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub

#End Region

    End Class

End Namespace