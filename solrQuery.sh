#!/bin/bash
###############################################################################
## Runs a Solr Query
## W 16 Nov 2016
###############################################################################

printHelp() {
    echo "solrQuery.sh <option(s)>"
    echo ""
    echo "options include" 
    echo -e "\t-h\tprint this help info"
    echo -e "\t-p\tthe port Solr runs on (defaults to 8983)"
    echo -e "\t-c\tthe Solr collection to query [MANDATORY]"
    echo -e "\t-q\tthe Solr query (e.g. \"select\") [MANDATORY]"
    echo -e "\t-a\tthe arguments to the Solr query (e.g. \"q=*%3A*\") [MANDATORY]"
    echo -
    echo ""
    return 0
}

SOLR_PORT=8983
# Doesn't change
SOLR_CONTEXT=solr

while getopts ":hc:p:q:a:" opt; do
    case $opt in
        h)
            printHelp
            exit 0
            ;;
        c)
            SOLR_COLLECTION=${OPTARG}
            ;;
        p)
            SOLR_PORT=${OPTARG}
            ;;
        q)
            SOLR_QUERY=${OPTARG}
            ;;
        a)
            SOLR_ARGS=${OPTARG}
            ;;
        ?)
            printHelp
            exit 0
            ;;
     esac
done

if [[ -z ${SOLR_COLLECTION} ]];then
    echo "[ERROR] Must specify a Solr Collection to query with -c option"
    exit 0
fi

if [[ -z ${SOLR_QUERY} ]];then
    echo "[ERROR] Must specify a Solr Query (e.g. \"select\") with -q option"
    exit 0
fi

if [[ -z ${SOLR_ARGS} ]];then 
    echo "[ERROR] Must specificy the arguments to the Solr Query (e.g. \"q=*%3A*\") with the -a option"
    exit 0
fi

CMD="curl -X GET 'http://${KNOX_HDP}:${SOLR_PORT}/${SOLR_CONTEXT}/${SOLR_COLLECTION}/${SOLR_QUERY}?${SOLR_ARGS}&wt=json&indent=true'"
echo ${CMD}

eval ${CMD}


