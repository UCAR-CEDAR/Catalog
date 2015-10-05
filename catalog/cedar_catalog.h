#ifndef cedar_catalog_h_
#define cedar_catalog_h_ 1

#ifdef __cplusplus
extern "C" {
// IDL include.
#include "export.h"
}
#endif


  /**
     Execute a query and load it into a result set.
     @param query: An IDL string conatining the query to be executed.
     @return 0 OK, 1 Bad Query
  */
  static extern "C" IDL_VPTR load_catalog_query(int argc, IDL_VPTR argv[]);
  
  /**
     Access a cell (i,j) in a result set.
     
  */
  static extern "C" IDL_VPTR get_cell(int argc, IDL_VPTR argv[]);
  
  /**
     Destroy a result set.
  */
  static extern "C" IDL_VPTR destroy_result_set(int argc, IDL_VPTR argv[]);


#endif // cedar_catalog_h_
