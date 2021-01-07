##############################################################################################
# custdemoService.4gl provides web service interface for all the tables in the 
#  custdemo database
##############################################################################################

IMPORT com
IMPORT FGL serviceHelper
IMPORT FGL custdemoCreate

MAIN
  DEFINE lMessage STRING
  CONNECT TO ":memory:+driver='dbmsqt'"
  CALL custdemoCreate.create_custdemo_database()

  CALL com.WebServiceEngine.RegisterRestService("serviceHelper","custdemo")

  CALL STARTLOG("custdemoService.log")

  DISPLAY "Server started"
  LET lMessage = serviceHelper.startService()
  DISPLAY lMessage

END MAIN