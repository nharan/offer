file(GLOB HEADERS "include/offer/plugins/smt_test/*.hpp")

add_library( smt_test_plugin
             smt_test_plugin.cpp
           )

target_link_libraries( smt_test_plugin chain_plugin offer_chain offer_protocol )
target_include_directories( smt_test_plugin
                            PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include" )

install( TARGETS
   smt_test_plugin

   RUNTIME DESTINATION bin
   LIBRARY DESTINATION lib
   ARCHIVE DESTINATION lib
)
