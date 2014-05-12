#!/bin/sh

function _make_dir() {
	dir_name=$1
	temp=`mktemp`
	ls ${dir_name} 1> /dev/null 2> ${temp}
	
	err=`cat ${temp} | wc -m`
	if [ ${err} -ne 0 ];
	then
		mkdir ${dir_name} 1> /dev/null 2> ${temp}
	fi
	
	err=`cat ${temp} | wc -m`
	rm -rf ${temp} 1> /dev/null 2> /dev/null
	
	if [ ${err} -ne 0 ];
	then
		return 1
	else
		return 0
	fi
}

OBJECT_FILES=()
function compile() {
	cd ${SOURCE_DIR}
	SOURCE_FILES=(`ls *.cpp 2> /dev/null`)
	cd ${PWD}
	
	CXXFLAGS="${CXXFLAGS} -I${INCLUDE_DIR}"
	
	for src in ${SOURCE_FILES[@]};
	do
		obj=`echo ${src} | sed -e 's/\(.cpp\|.cc\|.c\)$/.o/g'`
		OBJECT_FILES=(${OBJECT_FILES[@]} ${obj})
		
		echo "${CXX} ${CXXFLAGS} -c ${src} -o ${BUILD_DIR}/${obj} ${LDFLAGS}"
		${CXX} ${CXXFLAGS} -c ${src} -o ${BUILD_DIR}/${obj}
	done
}

function archive() {
	cd ${BUILD_DIR}
	echo "ar rsv -o ${LIBRARY_DIR}/${TARGET_FILE} ${OBJECT_FILES[@]}"
	${AR} ${ARFLAGS} -o ${LIBRARY_DIR}/${TARGET_FILE} ${OBJECT_FILES[@]}
	cd ${PWD}
}

function clean() {
	cd ${BUILD_DIR}
	rm -rf *.o 1> /dev/null 2> /dev/null
	cd ${PWD}
}

function distclean() {
	testclean
	clean
	cd ${LIBRARY_DIR}
	rm -rf ${TARGET_FILE} 1> /dev/null 2> /dev/null
	cd ${PWD}
	rm -rf make.sh 1> /dev/null 2> /dev/null
}

function all() {
	compile
	archive
}
