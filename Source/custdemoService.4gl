##############################################################################################
# custdemoService.4gl provides web service interface for all the tables in the 
#  custdemo database
##############################################################################################

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