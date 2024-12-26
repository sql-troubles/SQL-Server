'formats a range as html table
Public Function GetTable(rng As Range)
  Dim retval As String
  Dim i, j As Long
  
  retval = "<table style=""width: 100%;color:black;border-color:black;font-size:10px;"" border=""0"" cellpadding=""1"">"
  
  For i = 1 To rng.Rows.Count()
    retval = retval & vbCrLf & "<tr style=""background-color:" & IIf(i = 1, "#b0c4de", "white") & ";font-weight:" & IIf(i = 1, "bold", "normal") & """>"
    
    For j = 1 To rng.Columns.Count()
       retval = retval & vbCrLf & "<td align=""" & IIf(IsNumeric(rng.Cells(i, j)), "right", "left") & """>" & Replace(Replace(rng.Cells(i, j), "<", "&lt;"), ">", "&gt;") & "</td>"
    Next
    
    retval = retval & vbCrLf & "</tr>"
  Next
  
  retval = retval & vbCrLf & "</table>"
  
  GetTable = retval
End Function
