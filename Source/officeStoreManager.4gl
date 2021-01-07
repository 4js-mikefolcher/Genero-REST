IMPORT os

MAIN

	WHENEVER ANY ERROR CALL errorHandler

	CONNECT TO "officestore"

	CALL unloadData()

END MAIN

PRIVATE FUNCTION unloadData()
	DEFINE tableList DYNAMIC ARRAY OF STRING = [
		"supplier",
		"country",
		"category",
		"product",
		"account",
		"item",
		"inventory",
		"orders",
		"lineitem",
		"orderstatus",
		"seqreg",
		"signon"
	]
	DEFINE idx INTEGER

	FOR idx = 1 TO tableList.getLength()
		CALL doUnload(tableList[idx])
	END FOR

END FUNCTION #unloadData

PRIVATE FUNCTION doUnload(tablename STRING) RETURNS ()
	DEFINE sqlText STRING
	DEFINE filename STRING

	LET filename = SFMT("..%1Data%1%2.unl", os.Path.separator(), tablename)

	LET sqlText = SFMT("SELECT * FROM %1", tablename)
	DISPLAY SFMT("Table name: %1 SQL: %2", tablename, sqlText)
	UNLOAD TO filename sqlText

END FUNCTION #doUnload

PRIVATE FUNCTION errorHandler()

	DISPLAY SFMT("Error Code: %1", STATUS)
	DISPLAY SFMT("Error Message: %1", err_get(STATUS))
	DISPLAY SFMT("Call Stack: %1", base.Application.getStackTrace())

	EXIT PROGRAM -1

END FUNCTION #errorHandler