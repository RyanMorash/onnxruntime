file(GLOB_RECURSE onnxruntime_providers_hailo_cc_srcs CONFIGURE_DEPENDS
"${ONNXRUNTIME_ROOT}/core/providers/hailo/*.h"
"${ONNXRUNTIME_ROOT}/core/providers/hailo/*.cc"
"${ONNXRUNTIME_ROOT}/core/providers/shared_library/*.h"
"${ONNXRUNTIME_ROOT}/core/providers/shared_library/*.cc"
)

find_package(HailoRT 4.19.0 EXACT REQUIRED)

source_group(TREE ${ONNXRUNTIME_ROOT}/core FILES ${onnxruntime_providers_hailo_cc_srcs})
onnxruntime_add_shared_library_module(onnxruntime_providers_hailo ${onnxruntime_providers_hailo_cc_srcs})

add_dependencies(onnxruntime_providers_hailo onnxruntime_providers_shared ${onnxruntime_EXTERNAL_DEPENDENCIES})
target_include_directories(onnxruntime_providers_hailo PRIVATE ${ONNXRUNTIME_ROOT} ${eigen_INCLUDE_DIRS})
target_link_libraries(onnxruntime_providers_hailo PRIVATE ${ONNXRUNTIME_PROVIDERS_SHARED} HailoRT::libhailort Boost::mp11 absl::hash absl::raw_hash_set)
install(DIRECTORY ${PROJECT_SOURCE_DIR}/../include/onnxruntime/core/providers/hailo  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/onnxruntime/core/providers)
set_target_properties(onnxruntime_providers_hailo PROPERTIES FOLDER "ONNXRuntime")
set_target_properties(onnxruntime_providers_hailo PROPERTIES LINKER_LANGUAGE CXX)

if(UNIX)
set_property(TARGET onnxruntime_providers_hailo APPEND_STRING PROPERTY LINK_FLAGS "-Xlinker --version-script=${ONNXRUNTIME_ROOT}/core/providers/hailo/version_script.lds -Xlinker --gc-sections")
# TODO: Fix Windows compilation HRT-6558
# elseif(WIN32)
#   set_property(TARGET onnxruntime_providers_hailo APPEND_STRING PROPERTY LINK_FLAGS "-DEF:${ONNXRUNTIME_ROOT}/core/providers/hailo/symbols.def")
else()
message(FATAL_ERROR "onnxruntime_providers_hailo unknown platform, need to specify shared library exports for it")
endif()

install(TARGETS onnxruntime_providers_hailo
        ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})
