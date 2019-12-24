# Genero-REST
Example of RESTful services in Genero for the officestore and custdemo 
databases.

Leverages the RESTLibrary project, for more details see:
https://github.com/4js-mikefolcher/RESTLibrary

------------------------------------------------
officeStoreService.4gl: Operations for the officestore database
------------------------------------------------
Get All Records: /officestore/table/{tableName}

Get Record Count: /officestore/table/{tableName}/count

Get First x Records: /officestore/table/{tableName}/limit/{recLimit}

Get First x Records with y Offset: /officestore/table/{tableName}/limit/{recLimit}/offset/{recOffset}

Get Records with Query Equal: /officestore/table/{tableName}/query?column={colName}&value={colValue}

Get Records with Query Contains: /officestore/table/{tableName}/query?column={colName}&contains={colValue}

Post Record: /officestore/table/{tableName}
	Body: { "colName": "colValue", .... }
	
Put Record: /officestore/table/{tableName}?column={colName}&value={colValue}
	Body: { "colName": "colValue", .... }
	
Delete Record: /officestore/table/{tableName}?column={colName}&value={colValue}

------------------------------------------------
custdemoService.4gl: Operations for the custdemo database
------------------------------------------------
Get All Records: /custdemo/table/{tableName}

Get Record Count: /custdemo/table/{tableName}/count

Get First x Records: /custdemo/table/{tableName}/limit/{recLimit}

Get First x Records with y Offset: /custdemo/table/{tableName}/limit/{recLimit}/offset/{recOffset}

Get Records with Query Equal: /custdemo/table/{tableName}/query?column={colName}&value={colValue}

Get Records with Query Contains: /custdemo/table/{tableName}/query?column={colName}&contains={colValue}

Post Record: /custdemo/table/{tableName}
	Body: { "colName": "colValue", .... }
	
Put Record: /custdemo/table/{tableName}?column={colName}&value={colValue}
	Body: { "colName": "colValue", .... }
	
Delete Record: /custdemo/table/{tableName}?column={colName}&value={colValue}

