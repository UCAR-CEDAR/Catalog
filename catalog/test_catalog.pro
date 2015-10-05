PRO test_catalog,query
;{
    IF( query NE '' ) THEN BEGIN ;{
	toggle_debug
	rows=0ul
	columns=0ul
	results=0ul
	cell=''
	row=''

	val0=LOAD_CATALOG_QUERY( query, rows, columns, results )

	IF( val0 EQ 0 ) THEN BEGIN ;{
	    PRINT,'  + load_catalog_query succeeded:'
	    PRINT,'      rows = ',rows
	    PRINT,'      columns = ',columns
	    FOR i=0ul,(rows-1) DO BEGIN ;{
		row = ''
		FOR j=0ul,(columns-1) DO BEGIN ;{
		    val1 = GET_CELL( results, i, j, cell )
		    part = str_sep( cell, '%', /TRIM )
		    PRINT,'cell = ',cell
		    PRINT,'part = ',part
		    IF( val1 EQ 0 ) THEN BEGIN ;{
			row = row + '  ' + part
		    ENDIF ELSE BEGIN ;} ;{
			PRINT,'  - get_cell call failed for row ',row,' column ',column,' with return value: ',val1
			row = row + '  BAD'
		    ENDELSE ;}
		ENDFOR ;}
		PRINT,'  row = ',row
	    ENDFOR ;}
	    PRINT,'calling destroy'
	    val2 = DESTROY_RESULT_SET( results )
	    IF( val2 NE 0 ) THEN BEGIN ;{
		PRINT,'failed to destroy result set: ',val2
	    ENDIF ;}
	ENDIF ELSE BEGIN ;} ;{
	    PRINT,'  - load_catalog_query failed: ',val0
	ENDELSE ;}
    ENDIF ;}
;}
END
