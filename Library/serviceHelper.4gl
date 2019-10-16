IMPORT com
IMPORT util
IMPORT FGL sqlHelper

PUBLIC FUNCTION startService() RETURNS STRING
    DEFINE serviceStatus    INTEGER
    
    CALL com.WebServiceEngine.Start()
    LET int_flag = FALSE
    WHILE int_flag = FALSE
    
      LET serviceStatus = com.WebServiceEngine.ProcessServices(-1)
      CASE serviceStatus
         WHEN 0
            DISPLAY "Request processed."
         WHEN -1
            DISPLAY "Timeout reached."
         WHEN -2
            RETURN "Disconnected from application server."
         WHEN -3
            DISPLAY "Client Connection lost."
         WHEN -4
            DISPLAY "Server interrupted with Ctrl-C."
         WHEN -9
            DISPLAY "Unsupported operation."
         WHEN -10
            DISPLAY "Internal server error."
         WHEN -23
            DISPLAY "Deserialization error."
         WHEN -35
            DISPLAY "No such REST operation found."
         WHEN -36
            DISPLAY "Missing REST parameter."
         OTHERWISE
            RETURN SFMT("Unexpected server error %1.", serviceStatus)
            LET int_flag = TRUE
     END CASE
     
  END WHILE
  RETURN "Server stopped"

END FUNCTION

PUBLIC FUNCTION getAllRecords(tableName STRING ATTRIBUTES(WSParam))
    ATTRIBUTES(WSGet,
               WSPath = "/table/{tableName}",
               WSDescription = 'Fetches all the data from the specified table',
               WSThrows = "404:Not Found")
    RETURNS util.JSONArray ATTRIBUTES(WSMedia = "application/json")

    DEFINE jsonArray  util.JSONArray

    LET jsonArray = sqlHelper.getTableRecords(tableName, -1, -1)

    IF jsonArray IS NULL THEN
        CALL com.WebServiceEngine.SetRestError(500, NULL)
    ELSE 
        IF jsonArray.getLength() == 0 THEN
            CALL com.WebServiceEngine.SetRestError(404, NULL)
        END IF
    END IF

    RETURN jsonArray

END FUNCTION

PUBLIC FUNCTION getRecordCount(tableName STRING ATTRIBUTES(WSParam))
    ATTRIBUTES(WSGet,
               WSPath = "/table/{tableName}/count",
               WSDescription = 'Fetches the record count from the specified table',
               WSThrows = "404:Not Found")
    RETURNS INTEGER

    DEFINE lCount  INTEGER

    LET lCount = sqlHelper.getTableRecordCount(tableName)

    IF lCount IS NULL THEN
        CALL com.WebServiceEngine.SetRestError(500, NULL)
    ELSE 
        IF lCount == 0 THEN
            CALL com.WebServiceEngine.SetRestError(404, NULL)
        END IF
    END IF

    RETURN lCount

END FUNCTION

PUBLIC FUNCTION getRecordsWithLimit(tableName STRING ATTRIBUTES(WSParam), 
                                    recLimit INTEGER ATTRIBUTES(WSParam))
    ATTRIBUTES(WSGet,
               WSPath = "/table/{tableName}/limit/{recLimit}",
               WSDescription = 'Fetches the reccords from the specified table up to the limit specified',
               WSThrows = "404:Not Found")
    RETURNS util.JSONArray ATTRIBUTES(WSMedia = "application/json")

    DEFINE jsonArray  util.JSONArray

    LET jsonArray = sqlHelper.getTableRecords(tableName, recLimit, -1)

    IF jsonArray IS NULL THEN
        CALL com.WebServiceEngine.SetRestError(500, NULL)
    ELSE 
        IF jsonArray.getLength() == 0 THEN
            CALL com.WebServiceEngine.SetRestError(404, NULL)
        END IF
    END IF

    RETURN jsonArray

END FUNCTION

PUBLIC FUNCTION getRecordsWithLimitOffset(tableName STRING ATTRIBUTES(WSParam), 
                                          recLimit INTEGER ATTRIBUTES(WSParam),
                                          recOffset INTEGER ATTRIBUTES(WSParam))
    ATTRIBUTES(WSGet,
               WSPath = "/table/{tableName}/limit/{recLimit}/offset/{recOffset}",
               WSDescription = 'Fetches the reccords from the specified table up to the limit specified',
               WSThrows = "404:Not Found")
    RETURNS util.JSONArray ATTRIBUTES(WSMedia = "application/json")

    DEFINE jsonArray  util.JSONArray

    LET jsonArray = sqlHelper.getTableRecords(tableName, recLimit, recOffset)

    IF jsonArray IS NULL THEN
        CALL com.WebServiceEngine.SetRestError(500, NULL)
    ELSE 
        IF jsonArray.getLength() == 0 THEN
            CALL com.WebServiceEngine.SetRestError(404, NULL)
        END IF
    END IF

    RETURN jsonArray

END FUNCTION