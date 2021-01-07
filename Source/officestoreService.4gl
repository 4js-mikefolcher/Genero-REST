##############################################################################################
# officestoreService.4gl provides web service interface for all the tables in the 
#  officestore database
##############################################################################################
IMPORT com
IMPORT FGL serviceHelper
IMPORT FGL officestoreCreate

MAIN
  DEFINE lMessage STRING

  CONNECT TO ":memory:+driver='dbmsqt'"
  CALL officestoreCreate.create_officestore_database()

  CALL com.WebServiceEngine.RegisterRestService("serviceHelper","officestore")

  CALL STARTLOG("officestoreService.log")

  DISPLAY "Server started"
  LET lMessage = serviceHelper.startService()
  DISPLAY lMessage

END MAIN