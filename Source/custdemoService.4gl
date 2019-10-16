IMPORT com
IMPORT FGL serviceHelper

MAIN
  DEFINE lMessage STRING
  CONNECT TO "custdemo"
  CALL com.WebServiceEngine.RegisterRestService("serviceHelper","custdemo")

  CALL STARTLOG("custdemoService.log")

  DISPLAY "Server started"
  LET lMessage = serviceHelper.startService()
  DISPLAY lMessage

END MAIN