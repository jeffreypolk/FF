Imports System.Reflection
Imports System.Text

Namespace Utils

    Public Class Parser

#Region " Data Type Checkers "

        Friend Shared Function IsDate(ByRef type As System.Type) As Boolean
            Dim retValue As Boolean = False
            If type Is GetType(Date) OrElse type Is GetType(DateTime) Then
                retValue = True
            End If
            Return retValue
        End Function
        Friend Shared Function IsNumber(ByRef type As System.Type) As Boolean
            Dim retValue As Boolean = False
            If type Is GetType(Decimal) OrElse type Is GetType(Double) OrElse type Is GetType(Int16) OrElse type Is GetType(Int32) OrElse type Is GetType(Int64) OrElse type Is GetType(Integer) OrElse type Is GetType(Long) OrElse type Is GetType(Short) OrElse type Is GetType(Single) OrElse type Is GetType(UInt16) OrElse type Is GetType(UInt32) OrElse type Is GetType(UInt64) OrElse type Is GetType(UInteger) OrElse type Is GetType(ULong) OrElse type Is GetType(UShort) Then
                retValue = True
            End If
            Return retValue
        End Function
        Friend Shared Function IsBoolean(ByRef type As System.Type) As Boolean
            Dim retValue As Boolean = False
            If type Is GetType(Boolean) Then
                retValue = True
            End If
            Return retValue
        End Function
        Friend Shared Function IsSystemType(ByRef type As System.Type) As Boolean
            Return (IsNumber(type) OrElse IsDate(type) OrElse IsBoolean(type) OrElse type Is GetType(String)) OrElse type Is GetType(Guid)
        End Function

#End Region

        Public Shared Function ConvertObjectToDataTable(ByVal O As Object) As DataTable
            Dim dt As DataTable = Nothing
            Dim listType As Type = O.GetType()
            Dim colType As Type = Nothing

            Dim elementType As Type
            If listType.IsGenericType Then
                'determine the underlying type the List<> contains 
                elementType = listType.GetGenericArguments()(0)
            Else
                elementType = listType
            End If

            'create empty table -- give it a name in case it needs to be serialized 
            dt = New DataTable(elementType.Name)

            'define the table -- add a column for each public 
            'property or field 
            Dim miArray As MemberInfo() = elementType.GetMembers(BindingFlags.[Public] Or BindingFlags.Instance)
            For Each mi As MemberInfo In miArray
                If mi.MemberType = MemberTypes.[Property] Then
                    Dim pi As PropertyInfo = TryCast(mi, PropertyInfo)
                    colType = pi.PropertyType

                    ' Check for Nullables
                    If colType.IsGenericType Then
                        Dim ColTypeName = pi.PropertyType.GetGenericTypeDefinition().Name
                        If ColTypeName.Contains("Nullable") Then
                            colType = pi.PropertyType.GetGenericArguments()(0)
                        End If
                    End If

                    If IsSystemType(colType) Then
                        dt.Columns.Add(pi.Name, colType)
                    End If

                ElseIf mi.MemberType = MemberTypes.Field Then

                    Dim fi As FieldInfo = TryCast(mi, FieldInfo)
                    colType = fi.FieldType

                    ' Check for Nullables
                    If colType.IsGenericType Then
                        Dim ColTypeName = fi.FieldType.GetGenericTypeDefinition().Name
                        If ColTypeName.Contains("Nullable") Then
                            colType = fi.FieldType.GetGenericArguments()(0)
                        End If
                    End If

                    If IsSystemType(colType) Then
                        dt.Columns.Add(fi.Name, colType)
                    End If
                End If
            Next

            If listType.IsGenericType Then
                'populate the table 
                Dim il As IList = TryCast(O, IList)
                For Each record As Object In il
                    Dim i As Integer = 0
                    Dim fieldValues As Object() = New Object(dt.Columns.Count - 1) {}
                    For Each c As DataColumn In dt.Columns
                        Dim mi As MemberInfo = elementType.GetMember(c.ColumnName)(0)
                        If mi.MemberType = MemberTypes.[Property] Then
                            Dim pi As PropertyInfo = TryCast(mi, PropertyInfo)
                            fieldValues(i) = pi.GetValue(record, Nothing)
                        ElseIf mi.MemberType = MemberTypes.Field Then
                            Dim fi As FieldInfo = TryCast(mi, FieldInfo)
                            fieldValues(i) = fi.GetValue(record)
                        End If
                        i += 1
                    Next
                    dt.Rows.Add(fieldValues)
                Next
            Else
                'populate the table 
                Dim i As Integer = 0
                Dim fieldValues As Object() = New Object(dt.Columns.Count - 1) {}
                For Each c As DataColumn In dt.Columns
                    Dim mi As MemberInfo = elementType.GetMember(c.ColumnName)(0)
                    If mi.MemberType = MemberTypes.[Property] Then
                        Dim pi As PropertyInfo = TryCast(mi, PropertyInfo)
                        fieldValues(i) = pi.GetValue(O, Nothing)
                    ElseIf mi.MemberType = MemberTypes.Field Then
                        Dim fi As FieldInfo = TryCast(mi, FieldInfo)
                        fieldValues(i) = fi.GetValue(O)
                    End If
                    i += 1
                Next
                dt.Rows.Add(fieldValues)
            End If

            Return dt
        End Function

        Public Shared Function ConvertDataTableToJson(ByVal Table As DataTable) As String

            Dim row As DataRow = Nothing
            Dim col As DataColumn = Nothing
            Dim CurrentColIndex As Integer = 0
            Dim Json As New StringBuilder
            Dim CurrentRowIndex As Integer = 0
            Dim RecordCount As Integer = 0
            Dim UseQuotes As Boolean = True

            If IsNothing(Table) Then
                Return "{total:0, version:1, data:[]}"
            Else
                RecordCount = Table.Rows.Count
            End If

            'start it
            Json.Append("{total:" & RecordCount & ", version:1, data:[")

            For CurrentRowIndex = 0 To RecordCount - 1
                CurrentColIndex = 0
                row = Table.Rows(CurrentRowIndex)

                If row IsNot Nothing Then

                    Json.Append("{")
                    For Each col In Table.Columns
                        CurrentColIndex += 1
                        Json.Append(col.ColumnName & ":")

                        If row(col.ColumnName) Is System.DBNull.Value Then
                            Json.Append("null")
                        Else
                            If IsBoolean(col.DataType) Then
                                Json.Append(row(col.ColumnName).ToString.ToLower)
                            Else
                                UseQuotes = Not IsNumber(col.DataType)

                                If UseQuotes Then
                                    Json.Append("""")
                                End If
                                Json.Append(Js.Escape(row(col.ColumnName).ToString))
                                If UseQuotes Then
                                    Json.Append("""")
                                End If
                            End If
                        End If

                        If CurrentColIndex < Table.Columns.Count Then
                            Json.Append(",")
                        End If

                    Next

                    Json.Append("},")
                End If
            Next

            'remove the last comma if one exists
            If Json.ToString.EndsWith(",") Then
                Json.Length -= 1
            End If

            Json.Append("]}")

            Return Json.ToString
        End Function

        Public Shared Function ConvertObjectToJson(ByVal O As Object) As String
            Return ConvertDataTableToJson(ConvertObjectToDataTable(O))
        End Function

    End Class

End Namespace
