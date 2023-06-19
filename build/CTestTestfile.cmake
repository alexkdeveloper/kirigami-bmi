# CMake generated Testfile for 
# Source directory: /home/alex/Projects/bmicalc
# Build directory: /home/alex/Projects/bmicalc/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(appstreamtest "/app/bin/cmake" "-DAPPSTREAMCLI=/usr/bin/appstreamcli" "-DINSTALL_FILES=/home/alex/Projects/bmicalc/build/install_manifest.txt" "-P" "/usr/share/ECM/kde-modules/appstreamtest.cmake")
set_tests_properties(appstreamtest PROPERTIES  _BACKTRACE_TRIPLES "/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;165;add_test;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;183;appstreamtest;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;0;;/home/alex/Projects/bmicalc/CMakeLists.txt;18;include;/home/alex/Projects/bmicalc/CMakeLists.txt;0;")
subdirs("src")
