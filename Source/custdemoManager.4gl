IMPORT os
IMPORT util

PRIVATE CONSTANT c_prefix = "custdemo_"

MAIN

	WHENEVER ANY ERROR CALL errorHandler

	CONNECT TO "custdemo"

	CALL unloadData()

END MAIN

PRIVATE FUNCTION unloadData()
	DEFINE tableList DYNAMIC ARRAY OF STRING = [
		"state",
		"factory",
		"customer",
		"stock",
		"orders",
		"items"
	]
	DEFINE idx INTEGER

	FOR idx = 1 TO tableList.getLength()
		CALL doUnload(tableList[idx])

		{CASE tableList[idx]
			WHEN "stock"
				CALL doStockUnload()
			WHEN "orders"
				CALL doOrdersUnload()
			OTHERWISE
				CALL doUnload(tableList[idx])
		END CASE}
	END FOR

END FUNCTION #unloadData

PRIVATE FUNCTION doUnload(tablename STRING) RETURNS ()
	DEFINE sqlText STRING
	DEFINE filename STRING

	LET filename = SFMT("..%1Data%1%2%3.unl", os.Path.separator(), c_prefix, tablename)

	LET sqlText = SFMT("SELECT * FROM %1", tablename)
	DISPLAY SFMT("File name: %1 SQL: %2", filename, sqlText)
	UNLOAD TO filename sqlText

END FUNCTION #doUnload

PRIVATE FUNCTION errorHandler()

	DISPLAY SFMT("Error Code: %1", STATUS)
	DISPLAY SFMT("Error Message: %1", err_get(STATUS))
	DISPLAY SFMT("Call Stack: %1", base.Application.getStackTrace())

	EXIT PROGRAM -1

END FUNCTION #errorHandler