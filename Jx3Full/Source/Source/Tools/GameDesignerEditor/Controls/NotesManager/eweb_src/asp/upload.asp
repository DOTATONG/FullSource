<!--#include file="../conn.asp"-->
<%
'/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\'
'\    设计在线 newstu.cn 2007 7.18  /'
'/     CODE version 4.8 express     \'
'\    请保留信息，以便确认版本区别  /'
'/__________________________________\'
Session("eWebEditor_Original_CodePage") = Session.CodePage
Session.CodePage = 65001
%>
<!--#include file="config.asp"-->
<!--#include file="upfileclass.asp"-->

<%
Server.ScriptTimeOut = 1800

Dim sType, sStyleName, sLanguage,pops
Dim sAllowExt, nAllowSize, sUploadDir, nUploadObject, nAutoDir, sBaseUrl, sContentPath
Dim sFileExt, sOriginalFileName, sSaveFileName, sPathFileName, nFileNum
Dim nSLTFlag, nSLTMinSize, nSLTOkSize, nSYFlag, sSYText, sSYFontColor, nSYFontSize, sSYFontName, sSYPicPath, nSLTSYObject, sSLTSYExt, nSYMinSize, sSYShadowColor, nSYShadowOffset
Call InitUpload()

Dim sAction
sAction = UCase(Trim(Request.QueryString("action")))

Select Case sAction
Case "REMOTE"
	Call DoCreateNewDir()
	Call DoRemote()
Case "SAVE"
	Call ShowForm()
	Call DoCreateNewDir()
	Call DoSave()
Case "LOCAL"
	Call DoCreateNewDir()
	Call DoSaveword()
	'Call DoRemote()
Case Else
	Call ShowForm()
End Select
Session.CodePage = Session("eWebEditor_Original_CodePage")

Sub ShowForm()
%>
<HTML>
<HEAD>
<TITLE>eWebEditor</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript" src="../dialog/dialog.js"></script>
<link href='../language/<%=sLanguage%>.css' type='text/css' rel='stylesheet'>
<link href='../dialog/dialog.css' type='text/css' rel='stylesheet'>
</head>
<body class=upload>

<form action="?action=save&type=<%=sType%>&style=<%=sStyleName%>&language=<%=sLanguage%>" method=post name=myform enctype="multipart/form-data">
<input type=file name=uploadfile size=1 style="width:100%" onChange="originalfile.value=this.value">
<input type=hidden name=originalfile value="">
</form>

<script language=javascript>

var sAllowExt = "<%=sAllowExt%>";

function CheckUploadForm() {
	//if (!IsExt(document.myform.uploadfile.value,sAllowExt)){
	if (false){
		parent.UploadError('lang["ErrUploadInvalidExt"]+":'+sAllowExt+'"');
		return false;
	}
	return true;
}

var oForm = document.myform ;
oForm.attachEvent("onsubmit", CheckUploadForm) ;
if (! oForm.submitUpload) oForm.submitUpload = new Array() ;
oForm.submitUpload[oForm.submitUpload.length] = CheckUploadForm ;
if (! oForm.originalSubmit) {
	oForm.originalSubmit = oForm.submit ;
	oForm.submit = function() {
		if (this.submitUpload) {
			for (var i = 0 ; i < this.submitUpload.length ; i++) {
				this.submitUpload[i]() ;
			}
		}
		this.originalSubmit() ;
	}
}

try {
	parent.UploadLoaded();
}
catch(e){
}

</script>

</body>
</html>
<% 
End Sub 

Sub DoSave()
	dim jpeg,jpeg1,path,waterpath,coverpath
		Call DoUpload_Class()

		Dim s_SmallImageFile, s_SmallImagePathFile, s_SmallImageScript
		s_SmallImagePathFile = ""
		s_SmallImageScript = ""
		s_SmallImageFile = ""
		sPathFileName = sContentPath & sSaveFileName
	if nSLTFlag=1 then 
	On Error Resume Next
	Set Jpeg = Server.CreateObject("Persits.Jpeg")
	if Err then
	   Call OutScript("parent.UploadSaved('" & sPathFileName & "','" & s_SmallImagePathFile & "');var obj=parent.dialogArguments.dialogArguments;if (!obj) obj=parent.dialogArguments;try{obj.addUploadFile('" & sOriginalFileName & "', '" & sSaveFileName & "', '" & sPathFileName & "');} catch(e){} " & s_SmallImageScript)
	end if

	Path = Server.MapPath(sPathFileName) 
	Jpeg.Open Path
	if Jpeg.Width > nSLTMinSize then 

		Jpeg.Width = Jpeg.OriginalWidth/2 
		Jpeg.Height = Jpeg.OriginalHeight/2 

	Jpeg.Save Server.MapPath(sContentPath&"small/"& sSaveFileName)
	s_SmallImagePathFile = sContentPath&"small/"&sSaveFileName
	s_SmallImageFile="small/"& sSaveFileName
	s_SmallImageScript = "try{obj.addUploadFile('" & sOriginalFileName & "', '" & s_SmallImageFile & "', '" & s_SmallImagePathFile & "');} catch(e){} "
	response.Write(s_SmallImageFile)
	end if
	Set Jpeg = Nothing
	end if
	if nSYFlag=1 then 
		waterpath=Server.MapPath(sPathFileName)
	On Error Resume Next
	Set Jpeg = Server.CreateObject("Persits.Jpeg")
	if Err then
	   Call OutScript("parent.UploadSaved('" & sPathFileName & "','" & s_SmallImagePathFile & "');var obj=parent.dialogArguments.dialogArguments;if (!obj) obj=parent.dialogArguments;try{obj.addUploadFile('" & sOriginalFileName & "', '" & sSaveFileName & "', '" & sPathFileName & "');} catch(e){} " & s_SmallImageScript)

	end if

	Jpeg.Open waterpath

	Jpeg.Canvas.Font.Color ="&H"&sSYFontColor 
	Jpeg.Canvas.Pen.Color ="&H"&sSYFontColor  
	Jpeg.Canvas.Font.ShadowColor = &H000000 
	Jpeg.Canvas.Font.ShadowXoffset = 1 
	Jpeg.Canvas.Font.ShadowYoffset = 1 
	Jpeg.Canvas.Font.Family = "'"& sSYFontName &"'"
	Jpeg.Canvas.Font.Bold = True    
	Jpeg.Canvas.Font.Size = 15 
	Jpeg.Canvas.Font.BkColor=&H5FD211 
	Jpeg.Canvas.Font.Quality = 3  
	Jpeg.Canvas.Font.BkMode = "Transparent" 

	Jpeg.Canvas.Print Jpeg.OriginalWidth-120, Jpeg.OriginalHeight-35, sSYText 
	Jpeg.Canvas.Pen.Width = nSYShadowOffset
	Jpeg.Canvas.Brush.Solid = False 
	Jpeg.Canvas.DrawBar nSYShadowOffset, nSYShadowOffset, Jpeg.Width, Jpeg.Height


	Jpeg.Save Server.MapPath(sPathFileName)
	Set Jpeg=Nothing
	end if
	if nSYFlag=2 then 
	waterpath=Server.MapPath(sPathFileName)
	coverpath=Server.MapPath(sSYPicPath)
	On Error Resume Next
	Set Jpeg = Server.CreateObject("Persits.Jpeg")
	Set Jpeg1 = Server.CreateObject("Persits.Jpeg")
	if Err then
	   Call OutScript("parent.UploadSaved('" & sPathFileName & "','" & s_SmallImagePathFile & "');var obj=parent.dialogArguments.dialogArguments;if (!obj) obj=parent.dialogArguments;try{obj.addUploadFile('" & sOriginalFileName & "', '" & sSaveFileName & "', '" & sPathFileName & "');} catch(e){} " & s_SmallImageScript)

	end if
	Jpeg.Open waterpath
	Jpeg1.Open coverpath
	if Jpeg.height >= nSYMinSize then
	Jpeg.Canvas.Pen.Color  = &HFFFFFF 
	Jpeg.Canvas.Pen.Width  = 0    
	Jpeg.Canvas.Brush.Solid = False   
	Jpeg.Canvas.Bar 0, 0, Jpeg.Width, Jpeg.Height 
	Jpeg.Width = Jpeg.Width
	Jpeg.height = Jpeg.height
	Jpeg.Sharpen 1, 120
	Jpeg.DrawImage Jpeg.Width-Jpeg1.Width, Jpeg.Height-Jpeg1.Height, Jpeg1, 0.8, &HFFFFFF 


	Jpeg.Save Server.MapPath(sPathFileName)
	end if
	Set Jpeg=Nothing
	Set Jpeg1=Nothing
	end if

		Call OutScript("parent.UploadSaved('" & sPathFileName & "','" & s_SmallImagePathFile & "');var obj=parent.dialogArguments.dialogArguments;if (!obj) obj=parent.dialogArguments;try{obj.addUploadFile('" & sOriginalFileName & "', '" & sSaveFileName & "', '" & sPathFileName & "');} catch(e){} " & s_SmallImageScript)
	  
	  
End Sub

Sub DoRemote()
	Dim sContent, i
	For i = 1 To Request.Form("eWebEditor_UploadText").Count 
		sContent = sContent & Request.Form("eWebEditor_UploadText")(i) 
	Next
	If sAllowExt <> "" Then
		sContent = ReplaceRemoteUrl(sContent, sAllowExt)
	End If

	Response.Write "<HTML><HEAD><TITLE>eWebEditor</TITLE><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body>" & _
		"<input type=hidden id=UploadText value=""" & inHTML(sContent) & """>" & _
		"</body></html>"

	Call OutScriptNoBack("parent.setHTML(UploadText.value);try{parent.addUploadFile('" & sOriginalFileName & "', '" & sSaveFileName & "', '" & sPathFileName & "');} catch(e){} parent.remoteUploadOK();")

End Sub

Sub DoCreateNewDir()
End Sub

Sub DoUpload_Class()
	On Error Resume Next
	Dim oUpload, oFile
	Set oUpload = New upfile_class

	oUpload.GetData nAllowSize*1024

	If oUpload.Err > 0 Then
		Select Case oUpload.Err
		Case 1
			Call OutScript("parent.UploadError('lang[""ErrUploadInvalidFile""]')")
		Case 2
			Call OutScript("parent.UploadError('lang[""ErrUploadSizeLimit""]+"":" & nAllowSize & "KB""')")
		End Select
	End If

	Set oFile = oUpload.File("uploadfile")
	sFileExt = LCase(oFile.FileExt)
	Call CheckValidExt(sFileExt)
	sOriginalFileName = oFile.FileName
	sSaveFileName = GetRndFileName(sFileExt)

	Dim str_Mappath
	str_Mappath = Server.Mappath(sUploadDir & sSaveFileName)
	sFileExt = LCase(Mid(str_Mappath, InstrRev(str_Mappath, ".") + 1))
	Call CheckValidExt(sFileExt)

	'oFile.SaveToFile str_Mappath=====================================================================
	
	'oFile.SaveToSQL 
	sSaveFileName = "showimg.asp?id=" & oFile.SaveToSQL
	Set oFile = Nothing
	Set oUpload = Nothing
	
End Sub

Function GetRndFileName(sExt)
	Dim sRnd
	Randomize
	sRnd = Int(900 * Rnd) + 100
	GetRndFileName = FormatTime(Now(), 5) & sRnd & "." & sExt
End Function

Sub OutScript(str)
	
	Response.Write "<script language=javascript>" & str & ";history.back()</script>"
	Session.CodePage = Session("eWebEditor_Original_CodePage")
	Response.End
End Sub

Sub OutScriptNoBack(str)
	Response.Write "<script language=javascript>" & str & "</script>"
End Sub

Sub CheckValidExt(sExt)
	Dim b, i, aExt
	b = False
	aExt = Split(sAllowExt, "|")
	For i = 0 To UBound(aExt)
		If LCase(aExt(i)) = sExt Then
			b = True
			Exit For
		End If
	Next
	'If b = False Then
	If False Then
		Call OutScript("parent.UploadError('lang[""ErrUploadInvalidExt""]+"":" & sAllowExt & """')")
	End If
End Sub

Sub InitUpload()
	sType = UCase(Trim(Request.QueryString("type")))
	sStyleName = Trim(Request.QueryString("style"))
	sLanguage = Trim(Request.QueryString("language"))

	Dim i, aStyleConfig, bValidStyle
	bValidStyle = False
	For i = 1 To Ubound(aStyle)
		aStyleConfig = Split(aStyle(i), "|||")
		If Lcase(sStyleName) = Lcase(aStyleConfig(0)) Then
			bValidStyle = True
			Exit For
		End If
	Next

	If bValidStyle = False Then
		OutScript("parent.UploadError('lang[""ErrInvalidStyle""]')")
	End If

	sBaseUrl = aStyleConfig(19)
	nUploadObject = Clng(aStyleConfig(20))
	nAutoDir = CLng(aStyleConfig(21))
	sUploadDir = aStyleConfig(3)
	If Left(sUploadDir, 1) <> "/" Then
		sUploadDir = "../" & sUploadDir
	End If

       
  Select Case nAutoDir
   Case 0
   sUploadDir = left(sUploadDir,InStrRev(LCase(sUploadDir), "/")-1)
   Case 1
   sUploadDir =sUploadDir & Year(Now)
   Case 2
   sUploadDir =sUploadDir & Year(Now) & "-" & Month(Now)
   Case 3
   sUploadDir =sUploadDir & Year(Now) & "-" & Month(Now) &"-"& Day(Now)
  End Select
  
  dim objFSO
      Set objFSO = server.CreateObject("Scripting.FileSystemObject")
            If  objFSO.FolderExists(Server.MapPath(sUploadDir)) = False Then
             objFSO.CreateFolder(Server.MapPath(sUploadDir))
            End If
            If  objFSO.FolderExists(Server.MapPath(sUploadDir&"/small")) = False Then
             objFSO.CreateFolder(Server.MapPath(sUploadDir&"/small"))
            End If
		
  sUploadDir =sUploadDir &"/"
 
	Select Case sBaseUrl
	Case "0"
		sContentPath = aStyleConfig(23)
	Case "1"
		sContentPath = RelativePath2RootPath(sUploadDir)
	Case "2"
		sContentPath = RootPath2DomainPath(RelativePath2RootPath(sUploadDir))
	End Select

	Select Case sType
		Case "REMOTE"
			sAllowExt = aStyleConfig(10)
			nAllowSize = Clng(aStyleConfig(15))
		Case "FILE"
			sAllowExt = aStyleConfig(6)
			nAllowSize = Clng(aStyleConfig(11))
		Case "MEDIA"
			sAllowExt = aStyleConfig(9)
			nAllowSize = Clng(aStyleConfig(14))
		Case "FLASH"
			sAllowExt = aStyleConfig(7)
			nAllowSize = Clng(aStyleConfig(12))
		Case Else
			sAllowExt = aStyleConfig(8)
			nAllowSize = Clng(aStyleConfig(13))
	End Select
	nAllowSize = 5000000

	nSLTFlag = Clng(aStyleConfig(29))
	nSLTMinSize = Clng(aStyleConfig(30))
	nSLTOkSize = Clng(aStyleConfig(31))
	nSYFlag = Clng(aStyleConfig(32))
	sSYText = aStyleConfig(33)
	sSYFontColor = aStyleConfig(34)
	nSYFontSize = Clng(aStyleConfig(35))
	sSYFontName = aStyleConfig(36)
	sSYPicPath = aStyleConfig(37)
	nSLTSYObject = Clng(aStyleConfig(38))
	sSLTSYExt = aStyleConfig(39)
	nSYMinSize = Clng(aStyleConfig(40))
	sSYShadowColor = aStyleConfig(41)
	nSYShadowOffset = Clng(aStyleConfig(42))

End Sub

Function RelativePath2RootPath(url)
	Dim sTempUrl
	sTempUrl = url
	If Left(sTempUrl, 1) = "/" Then
		RelativePath2RootPath = sTempUrl
		Exit Function
	End If

	Dim sWebEditorPath
	sWebEditorPath = Request.ServerVariables("SCRIPT_NAME")
	sWebEditorPath = Left(sWebEditorPath, InstrRev(sWebEditorPath, "/") - 1)
	Do While Left(sTempUrl, 3) = "../"
		sTempUrl = Mid(sTempUrl, 4)
		sWebEditorPath = Left(sWebEditorPath, InstrRev(sWebEditorPath, "/") - 1)
	Loop
	RelativePath2RootPath = sWebEditorPath & "/" & sTempUrl
End Function

Function RootPath2DomainPath(url)
	Dim sHost, sPort
	sHost = Split(Request.ServerVariables("SERVER_PROTOCOL"), "/")(0) & "://" & Request.ServerVariables("HTTP_HOST")
	sPort = Request.ServerVariables("SERVER_PORT")
	If sPort <> "80" Then
		sHost = sHost & ":" & sPort
	End If
	RootPath2DomainPath = sHost & url
End Function

'/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\'
'\    设计在线 newstu.cn 2007 7.18   /'
'/     CODE version 4.8 express     \'
'\    请保留信息，以便确认版本区别  /'
'/__________________________________\'
Function ReplaceRemoteUrl(sHTML, sExt)
	' ----------------------------------------
	' ?? ? 
	' ? IsOpenAutoSave1 = ???0 = ?
	Const IsOpenAutoSave = 1
	If IsOpenAutoSave <> 1 Then Exit Function
	' ----------------------------------------
	Dim s_Content
	s_Content = sHTML
	If IsObjInstalled("Microsoft.XMLHTTP") = False then
		ReplaceRemoteUrl = s_Content
		Exit Function
	End If
	
	Dim re, RemoteFile, RemoteFileurl, SaveFileName, SaveFileType
	Set re = new RegExp
	re.IgnoreCase  = True
	re.Global = True
	re.Pattern = "((http|https|ftp|rtsp|mms):(\/\/|\\\\){1}(([A-Za-z0-9_-])+[.]){1,}(net|com|cn|org|cc|tv|[0-9]{1,3})([^ \f\n\r\t\v\""\'\>]*\/)(([^ \f\n\r\t\v\""\'\>])+[.]{1}(" & sExt & ")))"

	Set RemoteFile = re.Execute(s_Content)
	Dim a_RemoteUrl(), n, i, bRepeat
	n = 0
	'      
	For Each RemoteFileurl in RemoteFile
		If n = 0 Then
			n = n + 1
			Redim a_RemoteUrl(n)
			a_RemoteUrl(n) = RemoteFileurl
		Else
			bRepeat = False
			For i = 1 To UBound(a_RemoteUrl)
				If UCase(RemoteFileurl) = UCase(a_RemoteUrl(i)) Then
					bRepeat = True
					Exit For
				End If
			Next
			If bRepeat = False Then
				n = n + 1
				Redim Preserve a_RemoteUrl(n)
				a_RemoteUrl(n) = RemoteFileurl
			End If
		End If		
	Next
	' ??  
	nFileNum = 0
	For i = 1 To n
		SaveFileType = Mid(a_RemoteUrl(i), InstrRev(a_RemoteUrl(i), ".") + 1)
		SaveFileName = GetRndFileName(SaveFileType)
		If SaveRemoteFile(SaveFileName, a_RemoteUrl(i)) = True Then
			nFileNum = nFileNum + 1
			If nFileNum > 0 Then
				sOriginalFileName = sOriginalFileName & "|"
				sSaveFileName = sSaveFileName & "|"
				sPathFileName = sPathFileName & "|"
			End If
			sOriginalFileName = sOriginalFileName & Mid(a_RemoteUrl(i), InstrRev(a_RemoteUrl(i), "/") + 1)
			sSaveFileName = sSaveFileName & SaveFileName
			sPathFileName = sPathFileName & sContentPath & SaveFileName
			s_Content = Replace(s_Content, a_RemoteUrl(i), sContentPath & SaveFileName, 1, -1, 1)
		End If
	Next

	ReplaceRemoteUrl = s_Content
End Function

'/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\'
'\    设计在线 newstu.cn 2007 7.18  /'
'/     CODE version 4.8 express     \'
'\    请保留信息，以便确认版本区别   /'
'/__________________________________\'
Function SaveRemoteFile(s_LocalFileName, s_RemoteFileUrl)
	Dim Ads, Retrieval, GetRemoteData
	Dim bError
	bError = False
	SaveRemoteFile = False
	On Error Resume Next
	Set Retrieval = Server.CreateObject("Microsoft.XMLHTTP")
	With Retrieval
		.Open "Get", s_RemoteFileUrl, False, "", ""
		.Send
		GetRemoteData = .ResponseBody
	End With
	Set Retrieval = Nothing

	If LenB(GetRemoteData) > nAllowSize*1024 Then
	'If 1+1=3 Then
		bError = True
	Else
		'Set Ads = Server.CreateObject("Adodb.Stream")
		Set Ads = Server.CreateObject("Adodb." & "Stream")
		With Ads
			.Type = 1
			.Open
			.Write GetRemoteData
			.SaveToFile Server.MapPath(sUploadDir & s_LocalFileName), 2
			.Cancel()
			.Close()
		End With
		Set Ads=nothing
	End If

	If Err.Number = 0 And bError = False Then
		SaveRemoteFile = True
	Else
		Err.Clear
	End If
End Function

Sub DoSaveword()
	Call DoUpload_Class()
	Dim s_SmallImageFile, s_SmallImagePathFile, s_SmallImageScript
	s_SmallImagePathFile = ""
	s_SmallImageScript = ""
	s_SmallImageFile = ""
	sPathFileName = sContentPath & sSaveFileName
    'sPathFileName= RelativePath2RootPath(sPathFileName)
	response.Write(sPathFileName)
End Sub
'/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\'
'\    设计在线 newstu.cn 2007 7.18  /'
'/     CODE version 4.8 express     \'
'\    请保留信息，以便确认版本区别  /'
'/__________________________________\'
Function IsObjInstalled(strClassString)
	On Error Resume Next
	IsObjInstalled = False
	Err = 0
	Dim xTestObj
	Set xTestObj = Server.CreateObject(strClassString)
	If 0 = Err Then IsObjInstalled = True
	Set xTestObj = Nothing
	Err = 0
End Function

Function inHTML(str)
	Dim sTemp
	sTemp = str
	inHTML = ""
	If IsNull(sTemp) = True Then
		Exit Function
	End If
	sTemp = Replace(sTemp, "&", "&amp;")
	sTemp = Replace(sTemp, "<", "&lt;")
	sTemp = Replace(sTemp, ">", "&gt;")
	sTemp = Replace(sTemp, Chr(34), "&quot;")
	inHTML = sTemp
End Function

Function FormatTime(s_Time, n_Flag)
	Dim y, m, d, h, mi, s
	FormatTime = ""
	If IsDate(s_Time) = False Then Exit Function
	y = cstr(year(s_Time))
	m = cstr(month(s_Time))
	If len(m) = 1 Then m = "0" & m
	d = cstr(day(s_Time))
	If len(d) = 1 Then d = "0" & d
	h = cstr(hour(s_Time))
	If len(h) = 1 Then h = "0" & h
	mi = cstr(minute(s_Time))
	If len(mi) = 1 Then mi = "0" & mi
	s = cstr(second(s_Time))
	If len(s) = 1 Then s = "0" & s
	Select Case n_Flag
	Case 1
		FormatTime = y & "-" & m & "-" & d & " " & h & ":" & mi & ":" & s
	Case 2
		FormatTime = y & "-" & m & "-" & d
	Case 3
		FormatTime = h & ":" & mi & ":" & s
	Case 4
		FormatTime = y & m & d
	Case 5
		FormatTime = y & m & d & h & mi & s
	End Select
End Function

%>