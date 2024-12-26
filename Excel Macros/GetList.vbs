'formats a bullet-based list into html
Public Function Duplicate(no As Integer, str As String)
Dim i As Integer
Dim retval As String

Duplicate = ""

For i = 0 To no
    Duplicate = Duplicate & str
Next

End Function

Public Function GetList(rng As Range)
  Dim retval As String
  Dim b, n, c, cll As String
  Dim chrList As String
  Dim i, j As Long
  
  retval = "<ul id=""nav"" class=""ul0"">"
  b = ""
  n = ""
  c = ""
  chrList = "-o§·Øü"
  
  For i = 1 To rng.Rows.Count() - 1
    c = Left(Cells(i, 1), 1)
    n = Left(Cells(i + 1, 1), 1)
    cll = Trim(Replace(Right(Cells(i, 1), Len(Cells(i, 1)) - 2), Chr(160), ""))
    cll = Replace(Replace(cll, "ß", "&lArr;"), "à", "&rArr;")
    
    If InStr(chrList, c) > 0 Then
        If c = n Then
            retval = retval & "<li>" & cll & "</li>" & vbCrLf
        Else
            If InStr(chrList, c) < InStr(chrList, n) Then
                retval = retval & "<li>" & cll & vbCrLf
                retval = retval & "<ul class=""ul" & InStr(chrList, c) & """>" & vbCrLf
            Else
                retval = retval & "<li>" & cll & vbCrLf
                retval = retval & Duplicate(InStr(chrList, c) - InStr(chrList, n) - 1, "</li></ul>") & vbCrLf
            End If
        End If
    Else
        retval = retval & Cells(i, 1)
    End If
  Next
  
  retval = retval & "</li></ul>"
  
  GetList = retval
End Function
