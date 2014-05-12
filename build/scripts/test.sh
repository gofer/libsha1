#!/bin/sh

COMPILE_MSG_LEN=9
COMPILE_OK="  ${COLOR_FG_GREEN}OK${COLOR_DEFAULT}   "
COMPILE_NG=" ${COLOR_UNDERLINE}${COLOR_FG_RED}Error${COLOR_DEFAULT} "

TEST_MSG_LEN=10
TEST_OK="  ${COLOR_FG_GREEN}Pass${COLOR_DEFAULT}  "
TEST_NG="   ${COLOR_UNDERLINE}${COLOR_FG_RED}NG${COLOR_DEFAULT}   "
TEST_TO="${COLOR_UNDERLINE}${COLOR_FG_YELLOW}Time Out${COLOR_DEFAULT}"
TEST_NR=" ${COLOR_FG_YELLOW}NotRun${COLOR_DEFAULT} "

HEADER_LINE_FORMAT="| ${COLOR_LIGHT}%-`expr ${COLS} - ${COMPILE_MSG_LEN} - ${TEST_MSG_LEN} - 6`s${COLOR_DEFAULT} "
HEADER_LINE_FORMAT="${HEADER_LINE_FORMAT}| ${COLOR_LIGHT}%`expr ${COMPILE_MSG_LEN} - 2`s${COLOR_DEFAULT} "
HEADER_LINE_FORMAT="${HEADER_LINE_FORMAT}| ${COLOR_LIGHT}%`expr ${TEST_MSG_LEN} - 2`s${COLOR_DEFAULT} |\n"

LINE_FORMAT="| %-`expr ${COLS} - ${COMPILE_MSG_LEN} - ${TEST_MSG_LEN} - 6`s "
LINE_FORMAT="${LINE_FORMAT}| %`expr ${COMPILE_MSG_LEN} - 2`s "
LINE_FORMAT="${LINE_FORMAT}| %`expr ${TEST_MSG_LEN} - 2`s |\n"

TIMEOUT=timeout
TIMEOUTFLAGS="2s"
TIMEOUT_EXITCODE=124

function check() {
	test
}

function draw_hline() {
	line="+"
	
	n=`expr ${COLS} - ${COMPILE_MSG_LEN} - ${TEST_MSG_LEN} - 4`
	for i in `seq 1 ${n}`; do line="${line}-"; done
	line="${line}+"
	
	n=`expr ${COMPILE_MSG_LEN}`
	for i in `seq 1 ${n}`; do line="${line}-"; done
	line="${line}+"
	
	n=`expr ${TEST_MSG_LEN}`
	for i in `seq 1 ${n}`; do line="${line}-"; done
	line="${line}+"
	
	echo -e ${line}
}

function draw_head() {
	draw_hline
	
	printf "${HEADER_LINE_FORMAT}" "Test Case" "Compile" "Test  "
	draw_hline
}

function make_test_dir() {
	_make_dir ${TEST_DIR}/answer
	_make_dir ${TEST_DIR}/build
	_make_dir ${TEST_DIR}/result
	_make_dir ${TEST_DIR}/src
}

function test() {
	old_TEST_CXXFLAGS=${TEST_CXXFLAGS}
	TEST_CXXFLAGS="${TEST_CXXFLAGS} -I${INCLUDE_DIR} -L${LIBRARY_DIR}"
	
	temp=`mktemp`
	
	testclean
	make_test_dir
	
	cd ${TEST_DIR}
	
	cd src
	TEST_SRC_FILES=(`ls *.{cpp,cc,c} 2> /dev/null`)
	cd ..
	
	draw_head
	
	COMPILER_MESSAGES=`mktemp`
	
	for src in ${TEST_SRC_FILES[@]};
	do
		test_name=`echo ${src} | sed -e 's/\(.cpp\|.cc\|.c\)$//g'`
		target="build/${test_name}.out"
		answer="answer/${test_name}.txt"
		result="result/${test_name}.txt"
		
		compile_status=${COMPILE_NG}
		test_status=${TEST_NR}
		
		# test compile
		${TEST_CXX} ${TEST_CXXFLAGS} src/${src} -o ${target} ${TEST_LDFLAGS} \
			1> /dev/null 2> ${temp}
		exit_code=$?
		
		error_message=`ls ${target} 2> /dev/null | wc -m`
		compiler_message=`cat ${temp}`
		
		if [ ${exit_code} -eq 0 ] && [ ${error_message} -ne 0 ];
		then
			compile_status=${COMPILE_OK}
		else
			compile_status=${COMPILE_NG}
			
			echo "[${COLOR_FG_RED}${test_name}${COLOR_DEFAULT}: Compile Error]" >> ${COMPILER_MESSAGES}
			echo "${compiler_message}" >> ${COMPILER_MESSAGES}
			echo "" >> ${COMPILER_MESSAGES}
		fi
		
		# test running
		${TIMEOUT} ${TIMEOUTFLAGS} ${target} \
			1> ${result} 2> ${temp}
		exit_code=$?
		if [ ${exit_code} -eq 0 ];
		then
			test_status=${TEST_OK}
		else
			if [ ${exit_code} -eq ${TIMEOUT_EXITCODE} ];
			then
				test_status=${TEST_TO}
			else
				test_status=${TEST_NR}
			fi
		fi
		
		# test check
		if [ "${test_status}" == "${TEST_OK}" ];
		then
			diif_mesg=`diff ${result} ${answer} 2> ${temp} | wc -m`
			exit_code=$?
			if [ ${exit_code} -eq 0 ] && [ ${diif_mesg} -eq 0 ];
			then
				test_status=${TEST_OK}
			else
				test_status=${TEST_NG}
				
				echo "[${COLOR_FG_RED}${test_name}${COLOR_DEFAULT}: Test NG]" >> ${COMPILER_MESSAGES}
				echo "<result>"      >> ${COMPILER_MESSAGES}
				echo `cat ${result}` >> ${COMPILER_MESSAGES}
				echo ""              >> ${COMPILER_MESSAGES}
				echo "<answer>"      >> ${COMPILER_MESSAGES}
				echo `cat ${answer}` >> ${COMPILER_MESSAGES}
				echo ""              >> ${COMPILER_MESSAGES}
			fi
		fi
		
		printf "${LINE_FORMAT}" "${test_name}" "${compile_status}" "${test_status}"
	done
	
	draw_hline
	
	cat ${COMPILER_MESSAGES}
	
	cd ${PWD}
	
	rm ${temp}
	
	TEST_CXXFLAGS=${old_TEST_CXXFLAGS}
}

function testclean() {
	rm -rf ${TEST_DIR}/build  1> /dev/null 2> /dev/null
	rm -rf ${TEST_DIR}/result 1> /dev/null 2> /dev/null
}
