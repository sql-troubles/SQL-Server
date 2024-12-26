'formats a range as html table (for blog posts)
Public Function GetPosts(rng As Range) As String
On Error GoTo ErrorHandler
  Dim retval As String
  Dim last, concat As String
  Dim i, j As Long
  
  retval = "<table style=""width:100%;color: #6fa8dc;border-color:black;"" border=""0"" cellspacing=""1"" cellpadding=""1"">"
  retval = retval & "<tr><td width=""250px""><b>Topic</b></td><td><b>Posts</b></td></tr>"
  last = ""
  
  For i = 1 To rng.Rows.Count()
    
    If last = "" Then
        last = rng.Cells(i, 2)
        concat = ""
    End If
 
    If last <> rng.Cells(i, 2) Then
        retval = retval & "<tr>"
        retval = retval & "<td valign=""top"">" & last & "</td>"
        retval = retval & "<td valign=""top"">" & IIf(concat <> "", Left(concat, Len(concat) - 1), concat) & "</td>"
        retval = retval & "</tr>" & vbCrLf
        concat = ""
    End If
    
    'reinitialize
    last = rng.Cells(i, 2)
    concat = concat & "<a target=""_blank"" href=""" & rng.Cells(i, 4) & """ title=""" & rng.Cells(i, 1) & """>" & rng.Cells(i, 3) & "</a>,"
  Next
  
  retval = retval & "</table>"
  
  GetPosts = retval
  
  Exit Function
ErrorHandler:
  MsgBox (Err.Description & " " & Err.Source)
End Function

Public Sub GetLinksBody() 
'Must have the Microsoft HTML Object Library reference enabled
Dim oHtml As HTMLDocument
Dim oElement As Object
Dim link As String

Set oHtml = New HTMLDocument

With CreateObject("WINHTTP.WinHTTPRequest.5.1")
    For i = 2 To 761
        .Open "GET", Cells(i, 4), False
        .Send
        oHtml.Body.innerHTML = .responseText
        Cells(i, 5) = oHtml.getElementsByClassName("post-body entry-content")(0).innerText
    Next
End With

End Function

