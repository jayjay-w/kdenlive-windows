#
# kdenlive NSIS installer script
#
# This installer creator needs to be run with:
# makensis kdenlive.nsi
#

#--------------------------------
# Include Modern UI

    !include "MUI2.nsh"

#--------------------------------
# General

    # Program version
    !define kdenlive_VERSION "VERSIONTOKEN"

    # VIProductVersion requires version in x.x.x.x format
    !define kdenlive_VIPRODUCTVERSION "PRODVTOKEN"

    # Installer name and filename
    Name "kdenlive"
    Caption "kdenlive ${kdenlive_VERSION} Setup"
    OutFile "..\kdenlive-${kdenlive_VERSION}.exe"

    # Icon to use for the installer
    !define MUI_ICON "kdenlive.ico"

    # Default installation folder
    InstallDir "$PROGRAMFILES\kdenlive"

    # Get installation folder from registry if available
    InstallDirRegKey HKCU "Software\kdenlive" ""

    # Request application privileges
    RequestExecutionLevel admin

#--------------------------------
# Version information

    VIProductVersion "${kdenlive_VIPRODUCTVERSION}"
    VIAddVersionKey "ProductName" "kdenlive"
    VIAddVersionKey "FileDescription" "kdenlive - an open source video editor."
    VIAddVersionKey "FileVersion" "${kdenlive_VERSION}"
    VIAddVersionKey "LegalCopyright" "GPL v.2"
    VIAddVersionKey "ProductVersion" "${kdenlive_VERSION}"

#--------------------------------
# Settings

    # Show a warn on aborting installation
    !define MUI_ABORTWARNING

    # Defines the target start menu folder
    !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
    !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\kdenlive"
    !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

#--------------------------------
# Variables

    Var StartMenuFolder

#--------------------------------
# Custom pages

# Maintain some checkboxes in the uninstall dialog
Var UninstallDialog
Var Checkbox_Reg
Var Checkbox_Reg_State
Var Checkbox_UserDir
Var Checkbox_UserDir_State
Var UserDir

Function un.UninstallOptions
    nsDialogs::Create 1018
    Pop $UninstallDialog
    ${If} $UninstallDialog == error
        Abort
    ${EndIf}

    StrCpy $Checkbox_Reg_State 0
    StrCpy $Checkbox_UserDir 0

    # if this key exists kdenlive was run at least once
    ReadRegStr $UserDir HKCU "Software\kdenlive\kdenlive\GeneralSettings" "default_directory"
    ${If} $UserDir != ""
        # checkbox for removing registry entries
        ${NSD_CreateCheckbox} 0 0u 100% 20u "Registry entries (HKEY_CURRENT_USER\Software\kdenlive)"
        Pop $Checkbox_Reg
        GetFunctionAddress $0 un.OnCheckbox_Reg
        nsDialogs::OnClick $Checkbox_Reg $0

        ${If} ${FileExists} "$UserDir\*.*"
            # checkbox for removing the user directory
            ${NSD_CreateCheckbox} 0 20u 100% 20u "User directory ($UserDir)"
            Pop $Checkbox_UserDir
            GetFunctionAddress $0 un.OnCheckbox_UserDir
            nsDialogs::OnClick $Checkbox_UserDir $0
       ${EndIf}
    ${EndIf}

    nsDialogs::Show
FunctionEnd

Function un.OnCheckbox_Reg
    ${NSD_GetState} $Checkbox_Reg $Checkbox_Reg_State
FunctionEnd
Function un.OnCheckbox_UserDir
    ${NSD_GetState} $Checkbox_UserDir $Checkbox_UserDir_State
    ${If} $Checkbox_UserDir_State == 1
       MessageBox MB_OK "WARNING!$\nMake sure you don't have important files in the user directory!"
    ${EndIf}
FunctionEnd

#--------------------------------
# Pages

    # Installer pages
    !insertmacro MUI_PAGE_LICENSE "gpl-2.0.txt"
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
    !insertmacro MUI_PAGE_INSTFILES

    # Uninstaller pages
    !insertmacro MUI_UNPAGE_CONFIRM
    UninstPage custom un.UninstallOptions
    !insertmacro MUI_UNPAGE_INSTFILES

#--------------------------------
# Languages

    !insertmacro MUI_LANGUAGE "English"

Section
    SetShellVarContext all

    # Installation path
    SetOutPath "$INSTDIR"

    # Delete any already installed DLLs to avoid buildup of various
    # versions of the same library when upgrading
    Delete "$INSTDIR\*.dll"

    # Files to include in installer
    # now that we install into the staging directory and try to only have
    # the DLLs there that we depend on, this is much easier
    File kdenlive.exe
    File /r data
    File /r theme
    File /r images
    File /r plugins
    File /r Documentation
    File /r translations
    File *.dll
    File kdenlive.ico
    File qt.conf

    # Store installation folder in registry
    WriteRegStr HKCU "Software\kdenlive" "" $INSTDIR

    # Create shortcuts
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\kdenlive.lnk" "$INSTDIR\kdenlive.exe" "" "$INSTDIR\kdenlive.ico" 0
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall kdenlive.lnk" "$INSTDIR\Uninstall.exe"
        CreateShortCut "$DESKTOP\kdenlive.lnk" "$INSTDIR\kdenlive.exe" "" "$INSTDIR\kdenlive.ico" 0
    !insertmacro MUI_STARTMENU_WRITE_END

    # Create the uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\kdenlive" \
        "DisplayName" "kdenlive"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\kdenlive" \
        "DisplayIcon" "$INSTDIR\kdenlive.ico"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\kdenlive" \
        "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\kdenlive" \
        "DisplayVersion" ${kdenlive_VERSION}

SectionEnd

#--------------------------------
# Uninstaller section

Section "Uninstall"
    SetShellVarContext all

    # Delete installed files
    Delete "$INSTDIR\*.dll"
    Delete "$INSTDIR\*.exe"
    Delete "$INSTDIR\*.ico"
    Delete "$INSTDIR\Uninstall.exe"
    Delete "$INSTDIR\qt.conf"
    RMDir /r "$INSTDIR\share"
    RMDir /r "$INSTDIR\data"
    RMDir /r "$INSTDIR\theme"
    RMDir /r "$INSTDIR\images"
    RMDir /r "$INSTDIR\translations"
    RMDir /r "$INSTDIR\plugins"
    RMDir "$INSTDIR"

    # Remove shortcuts
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
    Delete "$SMPROGRAMS\$StartMenuFolder\kdenlive.lnk"
    Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall kdenlive.lnk"
    RMDir "$SMPROGRAMS\$StartMenuFolder"
    Delete "$DESKTOP\kdenlive.lnk"

    # remove the registry entires
    ${If} $Checkbox_Reg_State == 1
        DeleteRegKey HKCU "Software\kdenlive"
    ${EndIf}

    # remove the user directory
    ${If} $Checkbox_UserDir_State == 1
    ${AndIf} $UserDir != ""
    ${AndIf} ${FileExists} "$UserDir\*.*"
        RMDir /r $UserDir
    ${EndIf}

    # remove the uninstaller entry
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\kdenlive"

SectionEnd