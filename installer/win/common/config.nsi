!define PRODUCT_VERSION "0.9.16"
!define PRODUCT_PUBLISHER "sihorton"
!define PRODUCT_WEB_SITE "http://github.com/sihorton/appjs-deskshell"

!include "MUI2.nsh"
; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

;other settings
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\{PRODUCT_NAME}.exe"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

VIProductVersion "${PRODUCT_VERSION}.0.0"
VIAddVersionKey ProductName "${PRODUCT_NAME}"
VIAddVersionKey Comments "Deskshell - desktop applications built with html5 technology."
;VIAddVersionKey CompanyName company
;VIAddVersionKey LegalCopyright legal
VIAddVersionKey FileDescription "${PRODUCT_NAME}"
VIAddVersionKey FileVersion "${PRODUCT_VERSION}"
VIAddVersionKey ProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey InternalName "${PRODUCT_NAME}"
;VIAddVersionKey LegalTrademarks ""
VIAddVersionKey OriginalFilename "${PRODUCT_NAME}.exe"
