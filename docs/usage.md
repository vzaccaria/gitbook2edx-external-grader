Usage:
    gitbook2edx-external-grader serve [ -p PORT ] 
    gitbook2edx-external-grader run [ -e ENGINE ] [ -d | --dry ] CODE 
    gitbook2edx-external-grader -h | --help 

Options:
    -p, --port PORT       port to expose as a push endpoint for edx (def. 1666)
    -e, --engine ENGINE   engine to be used to run scripts ([octave, node])
    -d, --dry             dry run

Arguments:
    CODE                  the code to be executed; default: javascript
