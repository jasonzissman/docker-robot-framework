#!/bin/sh

HOME=${ROBOT_WORK_DIR}

# No need for the overhead of Pabot if no parallelisation is required
if [ $ROBOT_THREADS -eq 1 ]
then
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
        robot \
        --outputDir $ROBOT_REPORTS_DIR \
        ${ROBOT_OPTIONS} \
        $ROBOT_TESTS_DIR
else
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
        pabot \
        --verbose \
        --processes $ROBOT_THREADS \
        ${PABOT_OPTIONS} \
        --outputDir $ROBOT_REPORTS_DIR \
        ${ROBOT_OPTIONS} \
        $ROBOT_TESTS_DIR
fi

# Re-execute failed tests
if [ $ROBOT_RERUN_FAILED -eq TRUE ]
then
    # No need for the overhead of Pabot if no parallelisation is required
    if [ $ROBOT_THREADS -eq 1 ]
    then
        xvfb-run \
            --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
            robot \
            --rerunfailed $ROBOT_REPORTS_DIR/output.xml
            --outputDir $ROBOT_REPORTS_DIR/rerun/ \
            ${ROBOT_OPTIONS} \
            $ROBOT_TESTS_DIR
    else
        xvfb-run \
            --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
            pabot \
            --verbose \
            --processes $ROBOT_THREADS \
            ${PABOT_OPTIONS} \
            --rerunfailed $ROBOT_REPORTS_DIR/output.xml
            --outputDir $ROBOT_REPORTS_DIR/rerun/ \
            ${ROBOT_OPTIONS} \
            $ROBOT_TESTS_DIR
    fi

    # merge test results
    rebot --output $ROBOT_REPORTS_DIR/output.xml --merge $ROBOT_REPORTS_DIR/output.xml $ROBOT_REPORTS_DIR/rerun/*.xml
fi