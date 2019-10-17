IMPORT util

PUBLIC CONSTANT MAX_RECORDS = 500
PUBLIC CONSTANT NO_OFFSET = 0

PUBLIC FUNCTION getTableRecords(tableName STRING, recLimit INTEGER, recOffset INTEGER) 
 RETURNS util.JSONArray

    DEFINE jsonArray    util.JSONArray
    DEFINE jsonObj      util.JSONObject
    DEFINE lSQLSelect   STRING
    DEFINE sqlObj       base.SqlHandle
    DEFINE lIndex       INTEGER = 0
    DEFINE lCount       INTEGER = 0
    DEFINE lMoreRecords BOOLEAN = TRUE
    DEFINE lFetchOffset BOOLEAN = FALSE

    WHENEVER ANY ERROR CALL errorHandler

    LET lSQLSelect = SFMT("SELECT * FROM %1",tableName)
    LET jsonArray = util.JSONArray.create()

    TRY
        LET sqlObj = base.SqlHandle.create()
        CALL sqlObj.prepare(lSQLSelect)
        IF recOffset < 1 THEN 
            #No offset
            CALL sqlObj.open()
        ELSE
            CALL sqlObj.openScrollCursor()
            LET lFetchOffset = TRUE
        END IF
        
        WHILE lMoreRecords

            IF lFetchOffset THEN
                CALL sqlObj.fetchAbsolute(recOffset)
                LET recOffset = recOffset + 1
            ELSE
                CALL sqlObj.fetch()
            END IF
            
            IF SQLCA.sqlcode == NOTFOUND THEN
                LET lMoreRecords = FALSE
            ELSE
                LET jsonObj = util.JSONObject.create()
                FOR lIndex = 1 TO sqlObj.getResultCount()
                    CALL jsonObj.put(sqlObj.getResultName(lIndex), sqlObj.getResultValue(lIndex))
                END FOR
                LET lCount = lCount + 1
                CALL jsonArray.put(lCount, jsonObj)
                IF recLimit > 0 AND lCount >= recLimit THEN
                    LET lMoreRecords = FALSE
                END IF
            END IF

        END WHILE
        CALL sqlObj.close()

    CATCH
        LET jsonArray = NULL
    END TRY

    RETURN jsonArray

END FUNCTION

PUBLIC FUNCTION getTableQuery(tableName STRING, colName STRING, colValue STRING, useLike BOOLEAN)
 RETURNS util.JSONArray

    DEFINE jsonArray    util.JSONArray
    DEFINE jsonObj      util.JSONObject
    DEFINE lSQLSelect   STRING
    DEFINE sqlObj       base.SqlHandle
    DEFINE lIndex       INTEGER = 0
    DEFINE lCount       INTEGER = 0
    DEFINE lMoreRecords BOOLEAN = TRUE

    WHENEVER ANY ERROR CALL errorHandler

    IF useLike THEN
        LET lSQLSelect = SFMT("SELECT * FROM %1 WHERE %2 LIKE ?",tableName, colName)
    ELSE
        LET lSQLSelect = SFMT("SELECT * FROM %1 WHERE %2 = ?",tableName, colName)
    END IF
    LET jsonArray = util.JSONArray.create()

    TRY
        LET sqlObj = base.SqlHandle.create()
        CALL sqlObj.prepare(lSQLSelect)
        CALL sqlObj.setParameter(1, colValue)
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
        CALL sqlObj.close()

    CATCH
        LET jsonArray = NULL
    END TRY

    RETURN jsonArray

END FUNCTION

PUBLIC FUNCTION getTableRecordCount(tableName STRING) RETURNS INTEGER

    DEFINE lSQLSelect   STRING
    DEFINE sqlObj       base.SqlHandle
    DEFINE lCount       INTEGER = 0
    DEFINE lIndex       INTEGER
    DEFINE lColName     STRING = "rec_count"

    WHENEVER ANY ERROR CALL errorHandler

    LET lSQLSelect = SFMT("SELECT COUNT(*) AS %2 FROM %1", tableName, lColName)

    TRY
        LET sqlObj = base.SqlHandle.create()
        CALL sqlObj.prepare(lSQLSelect)
        CALL sqlObj.open()
        CALL sqlObj.fetch()
        FOR lIndex = 1 TO sqlObj.getResultCount()
            IF sqlObj.getResultName(lIndex) == lColName THEN
                LET lCount = sqlObj.getResultValue(lIndex)
                EXIT FOR
            END IF
        END FOR
        CALL sqlObj.close()

    CATCH
        LET lCount = 0
    END TRY

    RETURN lCount

END FUNCTION

PRIVATE FUNCTION errorHandler()
    CALL ERRORLOG(SFMT("Error Code: %1", STATUS))
    CALL ERRORLOG(base.Application.getStackTrace())
    EXIT PROGRAM -1
END FUNCTION