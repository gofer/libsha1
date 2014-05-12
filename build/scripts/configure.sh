#!/bin/sh

function cxx_version_check() {
	SED_REGEXP='([0-9]+)\.([0-9]+)\.([0-9]+)'
	CXX_VERSION=`${CXX} --version`
	CXX_VERSION=`echo ${CXX_VERSION} | ${SED} -E "s/(.*)${SED_REGEXP}(.*)/\2.\3.\4/g"`
	CXX_MAJOR_VERSION=`echo ${CXX_VERSION}  | ${SED} -E "s/${SED_REGEXP}/\1/g"`
	CXX_MINOR_VERSION=`echo ${CXX_VERSION}  | ${SED} -E "s/${SED_REGEXP}/\2/g"`
	CXX_MINOR_REVISION=`echo ${CXX_VERSION} | ${SED} -E "s/${SED_REGEXP}/\3/g"`
	
	echo "compiler: ${CXX}, version: ${CXX_VERSION}"
	#echo "Major: ${CXX_MAJOR_VERSION}"
	#echo "Minor: ${CXX_MINOR_VERSION}"
	#echo "Revision: ${CXX_MINOR_REVISION}"
}

function add_script_header() {
	echo "#!/bin/sh" > ${MAKE_SCRIPT_NAME}
}

function add_dir_info() {
	echo "ROOT_DIR=`pwd`"                   >> ${MAKE_SCRIPT_NAME}
	echo "SOURCE_DIR=\${ROOT_DIR}/src"      >> ${MAKE_SCRIPT_NAME}
	echo "INCLUDE_DIR=\${ROOT_DIR}/include" >> ${MAKE_SCRIPT_NAME}
	echo "LIBRARY_DIR=\${ROOT_DIR}/lib"     >> ${MAKE_SCRIPT_NAME}
	echo "BUILD_DIR=\${ROOT_DIR}/build"     >> ${MAKE_SCRIPT_NAME}
	echo "TEST_DIR=\${ROOT_DIR}/test"       >> ${MAKE_SCRIPT_NAME}
}

function add_source() {
	echo "source \${BUILD_DIR}/scripts/shutils.sh"   >> ${MAKE_SCRIPT_NAME}
	echo "source \${BUILD_DIR}/scripts/config.sh"    >> ${MAKE_SCRIPT_NAME}
	echo "source \${BUILD_DIR}/scripts/functions.sh" >> ${MAKE_SCRIPT_NAME}
	echo "source \${BUILD_DIR}/scripts/test.sh"      >> ${MAKE_SCRIPT_NAME}
}

function add_mkdir() {
	echo "_make_dir \${SOURCE_DIR}"      >> ${MAKE_SCRIPT_NAME}
	echo "_make_dir \${INCLUDE_DIR}"     >> ${MAKE_SCRIPT_NAME}
	echo "_make_dir \${LIBRARY_DIR}"     >> ${MAKE_SCRIPT_NAME}
	echo "_make_dir \${BUILD_DIR}"       >> ${MAKE_SCRIPT_NAME}
	echo "_make_dir \${TEST_DIR}"        >> ${MAKE_SCRIPT_NAME}
}

function add_run_script() {
	echo "if [ \$# -eq 0 ];" >> ${MAKE_SCRIPT_NAME}
	echo "then"              >> ${MAKE_SCRIPT_NAME}
	echo "  all"             >> ${MAKE_SCRIPT_NAME}
	echo "else"              >> ${MAKE_SCRIPT_NAME}
	echo "  \$1"             >> ${MAKE_SCRIPT_NAME}
	echo "fi"                >> ${MAKE_SCRIPT_NAME}
}
