#!/bin/bash

###############################################################################
## Maven build script allowing other options to be set on the cmd line.
## John McParland
## Th 7 Jan 2016
###############################################################################

printHelp() {
    echo "build.sh <option(s)>"
    echo ""
    echo "options include" 
    echo -e "\t-h\tprint this help info"
    echo -e "\t-t\tskip tests"
    echo -e "\t-i\tskip integration tests"
    echo -e "\t-f\tignore test failures"
    echo -e "\t-m\tincrease memory"
    echo -e "\t-m\tdump memory on crash dump"
    echo -e "\t-d\tdebug"
    echo -e "\t-w\tcheck for warnings in the build"
    echo -e "\t-e\tignore test errors"
    echo -e "\t-r\tignore rat (license) checks"
    echo -e "\t-g <goals>\t the goals to execute"
    echo ""
    return 0
}

while getopts ":htimpdferg:" opt; do
    case $opt in
        t)
            MAVEN_ARGS="${MAVEN_ARGS} -DskipTests=true"
            ;;
        i)
            MAVEN_ARGS="${MAVEN_ARGS} -DskipITs"
            ;;
        m)
            MAVEN_OPTS="${MAVEN_OPTS} -Xms1024m -Xmx2048m"
            ;;
        c)
            MAVEN_OPTS="${MAVEN_OPTS} -XX:+HeapDumpOnOutOfMemoryError"
            ;;
        d)
            MAVEN_ARGS="${MAVEN_ARGS} --debug"
            ;;
        w) 
            CHECK_FOR_WARNS=1
            ;;
        f) 
            #MAVEN_ARGS="${MAVEN_ARGS} --fail-at-end" 
            MAVEN_ARGS="${MAVEN_ARGS} -Dmaven.test.failure.ignore=true"
            ;;
        e)
            MAVEN_ARGS="${MAVEN_ARGS} -Dmaven.test.error.ignore=true"
            ;;
        r)
            MAVEN_ARGS="${MAVEN_ARGS} -Drat.skip=true"
            ;;
        h)
            printHelp
            exit 0
            ;;
        g) 
            MAVEN_GOALS="${OPTARG}"
            ;;
    esac
done

if [[ -z ${MAVEN_GOALS} ]];then
    MAVEN_GOALS="clean package install"
fi

export MAVEN_OPTS
echo "MAVEN_OPTS = ${MAVEN_OPTS}"
echo "MAVEN_ARGS = ${MAVEN_ARGS}"
echo "MAVEN_GOALS = ${MAVEN_GOALS}"

LOGFILE=${HOME}/knox_build.log
if [[ -f ${LOGFILE} ]];then
    rm ${LOGFILE}
fi

# Build
CMD="mvn ${MAVEN_ARGS} ${MAVEN_GOALS} 2>&1 | tee -a ${LOGFILE}"
echo ${CMD}
eval ${CMD}

# Check it was ok
RETVAL=${?}
if [[ 0 -ne ${RETVAL} ]];then
    echo "[ERROR] Maven problem: ${RETVAL}"
    exit ${RETVAL}
fi

# Check the log file
echo ""
echo "Checking for ERRORs"
echo "==================="
grep ERROR ${LOGFILE}
echo ""
if [[ ! -z ${CHECK_FOR_WARNS} ]];then
    echo "Checking for WARNs"
    echo "==================="
    grep WARN ${LOGFILE}
    echo ""
fi 
echo "Checking for Test Failures"
echo "=========================="
egrep "Failures: [1-9]" ${LOGFILE}
egrep -C 5 "Tests failed:" ${LOGFILE}
echo ""

echo "Checking for Test Errors"
echo "========================"
egrep "Errors: [1-9]" ${LOGFILE}
egrep -C 5 "Tests in error:" ${LOGFILE}
echo ""

echo "Log File"
echo "========"
echo "Log File: ${LOGFILE}"
fi

