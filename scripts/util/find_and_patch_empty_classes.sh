#!/bin/bash

PACKAGE_NAME=$1
WORK_DIR=$2

# We will used this to add a "pass" to class definitions
# that for some reason are empty
patch_empty_class() {
  PACKAGE_NAME=$1
  WORK_DIR=$2
  CLASS_FILE=$3

  echo "Patching" ${WORK_DIR}/${PACKAGE_NAME}/models/${CLASS_FILE}
  sleep 1
  echo "    # patched with a 'pass' because original pydantic model was empty" >> ${WORK_DIR}/${PACKAGE_NAME}/models/${CLASS_FILE}
  echo "    pass" >> ${WORK_DIR}/${PACKAGE_NAME}/models/${CLASS_FILE}
  echo "" >> ${WORK_DIR}/${PACKAGE_NAME}/models/${CLASS_FILE}
}

# the blank class definition files have 2 empty lines at the end
# we use this fact to find which classes are empty
for x in $(tail -v -n2 ${WORK_DIR}/${PACKAGE_NAME}/models/* | grep "^class"| sed 's/class //g');
do
    CLASS_NAME=$x
    echo "Class with Empty Body: $CLASS_NAME"
    CLASS_FILE=$(basename $(grep -H ${CLASS_NAME} ${WORK_DIR}/${PACKAGE_NAME}/models/*|sed 's/:class//g'))
    echo "Calling patcher for: $CLASS_FILE @ ${WORK_DIR}"
    patch_empty_class ${PACKAGE_NAME} ${WORK_DIR} ${CLASS_FILE}
    # ./scripts/util/patch_class_file.sh ${PACKAGE_NAME} ${WORK_DIR} ${CLASS_FILE}
done

