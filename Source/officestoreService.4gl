IMPORT com
IMPORT FGL serviceHelper

MAIN
  DEFINE lMessage STRING
  CONNECT TO "officestore"
  CALL com.WebServiceEngine.RegisterRestService("serviceHelper","officestore")

  CALL STARTLOG("officestoreService.log")

  DISPLAY "Server started"
  LET lMessage = serviceHelper.startService()
  DISPLAY lMessage

END MAIN