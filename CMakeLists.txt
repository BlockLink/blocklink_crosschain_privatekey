project( blocklink_crosschain_privatekey )
cmake_minimum_required( VERSION 2.8.12 )

message(STATUS "Configuring project blocklink_crosschain_privatekey located in: ${CMAKE_CURRENT_SOURCE_DIR}")


SET(BOOST_COMPONENTS)
LIST(APPEND BOOST_COMPONENTS thread 
                             date_time 
							 system 
							 filesystem 
							 program_options 
							 signals serialization 
							 chrono 
							 unit_test_framework 
							 context
							 locale 
							 iostreams
							 regex
                             )
SET( Boost_USE_STATIC_LIBS ON CACHE STRING "ON or OFF" )

IF( WIN32 )
  SET(BOOST_ROOT $ENV{BOOST_ROOT})
  set(Boost_USE_MULTITHREADED ON)
  set(BOOST_ALL_DYN_LINK OFF) # force dynamic linking for all libraries
ENDIF(WIN32)

FIND_PACKAGE(Boost 1.57 REQUIRED COMPONENTS ${BOOST_COMPONENTS})
# For Boost 1.53 on windows, coroutine was not in BOOST_LIBRARYDIR and do not need it to build,  but if boost versin >= 1.54, find coroutine otherwise will cause link errors
IF(NOT "${Boost_VERSION}" MATCHES "1.53(.*)")
   SET(BOOST_LIBRARIES_TEMP ${Boost_LIBRARIES})
   FIND_PACKAGE(Boost 1.54 REQUIRED COMPONENTS coroutine)
   LIST(APPEND BOOST_COMPONENTS coroutine)
   SET(Boost_LIBRARIES ${BOOST_LIBRARIES_TEMP} ${Boost_LIBRARIES})
ENDIF()

if (Boost_FOUND)
	message(STATUS "found boost library!")
else (Boost_FOUND)
	message(STATUS "cannot found Boost library!")
endif()


# build library blocklink libbitcoin
message(STATUS "build library blocklink_libbitcoin_secp256k1")
set( CMAKE_AUTOMOC OFF )

# configure blocklink_libbitcoin_secp256k1 
set( BLOCKLINK_LIBBITCOIN_SECP256K1_DIR "${CMAKE_CURRENT_SOURCE_DIR}/secp256k1" )

file( GLOB BLOCKLINK_LIBBITCOIN_SECP256K1_SOURCES "${BLOCKLINK_LIBBITCOIN_SECP256K1_DIR}/src/secp256k1.c" )
add_library( blocklink_libbitcoin_secp256k1 ${BLOCKLINK_LIBBITCOIN_SECP256K1_SOURCES} )

target_include_directories( blocklink_libbitcoin_secp256k1 PRIVATE "${BLOCKLINK_LIBBITCOIN_SECP256K1_DIR}" PUBLIC "${BLOCKLINK_LIBBITCOIN_SECP256K1_DIR}/include" )
target_compile_definitions( blocklink_libbitcoin_secp256k1 PUBLIC
							ENABLE_MODULE_RECOVERY
							ENABLE_MODULE_ECDH
							USE_SCALAR_8X32
							USE_FIELD_10X26
							USE_ENDOMORPHISM
							USE_NUM_NONE
							USE_FIELD_INV_BUILTIN
							USE_SCALAR_INV_BUILTIN
							UNICODE
							_UNICODE
							WIN32
							_WIN32
							WIN64
							_WIN64   
						 )


# End configure blocklink_libbitcoin_secp256k1

message(STATUS "build library blocklink libbitcoin")

file(GLOB_RECURSE blocklink_libbitcoin_header_files ${CMAKE_CURRENT_SOURCE_DIR}/libbitcoin/include/*.hpp  ${CMAKE_CURRENT_SOURCE_DIR}/libbitcoin/include/*.h)
file(GLOB_RECURSE blocklink_libbitcoin_source_files ${CMAKE_CURRENT_SOURCE_DIR}/libbitcoin/src/*.c   ${CMAKE_CURRENT_SOURCE_DIR}/libbitcoin/src/*.cpp)

add_library(blocklink_libbitcoin STATIC
            ${blocklink_libbitcoin_header_files}
			${blocklink_libbitcoin_source_files})

target_compile_definitions( blocklink_libbitcoin PUBLIC
							SECP256K1_STATIC
							BC_STATIC
							WITH_ICU
							WIN32_LEAN_AND_MEAN
							NOMINMAX
							_WIN32_WINNT=0x0600
							UNICODE
							_UNICODE
							WIN32
							_WIN32
							WIN64
							_WIN64
							)
target_include_directories(blocklink_libbitcoin PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/libbitcoin/include  ${BOOST_ROOT}/ ${LIBBITCOIN_SECP256K1_DIR}/include)
target_link_libraries(blocklink_libbitcoin PUBLIC blocklink_libbitcoin_secp256k1 ${Boost_LIBRARIES})



install(TARGETS
        blocklink_libbitcoin_secp256k1
	    LIBRARY DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/third_libs
		ARCHIVE DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/third_libs
		)

install(TARGETS
        blocklink_libbitcoin
	    LIBRARY DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/third_libs
		ARCHIVE DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/third_libs
		)



