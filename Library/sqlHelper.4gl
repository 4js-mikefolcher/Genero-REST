IMPORT util

PUBLIC FUNCTION getTableRecords(tableName STRING) RETURNS util.JSONArray

    DEFINE jsonArray    util.JSONArray
    DEFINE jsonObj      util.JSONObject
    DEFINE lSQLSelect   STRING
    DEFINE sqlObj       base.SqlHandle
    DEFINE lIndex       INTEGER = 0
    DEFINE lCount       INTEGER = 0
    DEFINE lMoreRecords BOOLEAN = TRUE

    WHENEVER ANY ERROR CALL errorHandler

    LET lSQLSelect = SFMT("SELECT * FROM %1",tableName)
    LET jsonArray = util.JSONArray.create()

    TRY
        LET sqlObj = base.SqlHandle.create()
        CALL sqlObj.prepare(lSQLSelect)
        CALL sqlObj.open()

        WHILE lMoreRecords

            CALL sqlObj.fetch()
            IF SQLCA.sqlcode == NOTFOUND THEN
                LET lMoreRecords = FALSE
            ELSE
                LET jsonObj = util.JSONObject.create()
                FOR lIndex = 1 TO sqlObj.getResultCount()
                    CALL jsonObj.put(sqlObj.getResultName(lIndex), sqlObj.getResultValue(lIndex))
                END FOR
                LET lCount = lCount + 1
                CALL jsonArray.put(lCount, jsonObj)
            END IF

        END WHILE

    CATCH
        LET jsonArray = NULL
    END TRY

    RETURN jsonArray

END FUNCTION

PRIVATE FUNCTION errorHandler()
    CALL ERRORLOG(SFMT("Error Code: %1", STATUS))
    CALL ERRORLOG(base.Application.getStackTrace())
    EXIT PROGRAM -1
END FUNCTION