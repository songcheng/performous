set(CPACK_PACKAGE_NAME "${CMAKE_PROJECT_NAME}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "A karaoke game with pitch detection and scoring, similar to Singstar games. Previously known as UltraStar-NG. Supports songs in Ultrastar format.")
set(CPACK_PACKAGE_CONTACT "http://performous.org/")
set(CPACK_SOURCE_IGNORE_FILES
   "/.cvsignore"
   "/songs/"
   "/build/"
   "/.svn/"
   "/osx-utils/"
   "/portage-overlay/"
)
set(CPACK_PACKAGE_EXECUTABLES performous)
set(CPACK_SOURCE_GENERATOR "TBZ2")
set(CPACK_GENERATOR "TBZ2")

if("${CMAKE_BUILD_TYPE}" MATCHES "Release")
	set(CPACK_STRIP_FILES TRUE)
endif("${CMAKE_BUILD_TYPE}" MATCHES "Release")

if(APPLE)
	set(CPACK_GENERATOR "PACKAGEMAKER;OSXX11")
endif(APPLE)
if(UNIX)
	# Try to find architecture
	execute_process(COMMAND uname -m OUTPUT_VARIABLE CPACK_PACKAGE_ARCHITECTURE)
	# Try to find distro name and distro-specific arch
	execute_process(COMMAND lsb_release -is OUTPUT_VARIABLE LSB_ID)
	execute_process(COMMAND lsb_release -rs OUTPUT_VARIABLE LSB_RELEASE)
	string(STRIP "${LSB_ID}" LSB_ID)
	string(STRIP "${LSB_RELEASE}" LSB_RELEASE)
	set(LSB_DISTRIB "${LSB_ID}${LSB_RELEASE}")
	if(NOT LSB_DISTRIB)
		set(LSB_DISTRIB "unix")
	endif(NOT LSB_DISTRIB)
	# For Debian-based distros we want to create DEB packages.
	if("${LSB_DISTRIB}" MATCHES "Ubuntu|Debian")
		set(CPACK_GENERATOR "DEB")
		set(CPACK_DEBIAN_PACKAGE_PRIORITY extra)
		set(CPACK_DEBIAN_PACKAGE_SECTION universe/games)
		set(CPACK_DEBIAN_PACKAGE_RECOMMENDS ultrastar-songs)
		# We need to alter the architecture names as per distro rules
		if("${CPACK_PACKAGE_ARCHITECTURE}" MATCHES "i[3-6]86")
			set(CPACK_PACKAGE_ARCHITECTURE i386)
		endif("${CPACK_PACKAGE_ARCHITECTURE}" MATCHES "i[3-6]86")
		if("${CPACK_PACKAGE_ARCHITECTURE}" MATCHES "x86_64")
			set(CPACK_PACKAGE_ARCHITECTURE amd64)
		endif("${CPACK_PACKAGE_ARCHITECTURE}" MATCHES "x86_64")
		# Set the dependencies based on the distro version
		if("${LSB_DISTRIB}" MATCHES "Ubuntu8.04")
			set(CPACK_DEBIAN_PACKAGE_DEPENDS "libsdl1.2debian, libcairo2, librsvg2-2, libboost-thread1.34.1, libboost-serialization1.34.1, libboost-program-options1.34.1, libboost-regex1.34.1, libboost-filesystem1.34.1, libavcodec1d, libavformat1d, libswscale1d, libmagick++10, libsamplerate0, libxml++2.6c2a")
		endif("${LSB_DISTRIB}" MATCHES "Ubuntu8.04")
		if("${LSB_DISTRIB}" MATCHES "Ubuntu8.10")
			set(CPACK_DEBIAN_PACKAGE_DEPENDS "libsdl1.2debian, libcairo2, librsvg2-2, libboost-thread1.34.1, libboost-serialization1.34.1, libboost-program-options1.34.1, libboost-regex1.34.1, libboost-filesystem1.34.1, libavcodec51, libavformat52, libswscale0, libmagick++10, libsamplerate0, libxml++2.6-2")
		endif("${LSB_DISTRIB}" MATCHES "Ubuntu8.10")
		if(NOT CPACK_DEBIAN_PACKAGE_DEPENDS)
			message("WARNING: ${LSB_DISTRIB} not supported yet.\nPlease set deps in cmake/performous-packaging.cmake before packaging.")
		endif(NOT CPACK_DEBIAN_PACKAGE_DEPENDS)
	endif("${LSB_DISTRIB}" MATCHES "Ubuntu|Debian")
	set(CPACK_SYSTEM_NAME "${LSB_DISTRIB}-${CPACK_PACKAGE_ARCHITECTURE}")
	message(STATUS "Detected ${CPACK_SYSTEM_NAME}. Use make package to build packages (${CPACK_GENERATOR}).")
endif(UNIX)

include(CPack)
