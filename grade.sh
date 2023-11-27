#!/bin/bash

# Classpath including JUnit and Hamcrest
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

# Clean up previous data
rm -rf student-submission
rm -rf grading-area

# Create grading area
mkdir grading-area

# Clone the student submission
git clone $1 student-submission
echo 'Finished cloning'

# Change to student-submission directory
cd student-submission

# Check if ListExamples.java exists
if [ ! -f ListExamples.java ]; then
    echo "ListExamples.java not found in the submission."
    exit 1
fi

# Move back to the main directory
cd ..

# Copy necessary files to grading area
cp student-submission/ListExamples.java grading-area/
cp list-examples-grader-main/TestListExamples.java grading-area/

# Change to grading area
cd grading-area

# Compile the tests and student code
javac -cp $CPATH ListExamples.java TestListExamples.java
if [ $? -ne 0 ]; then
    echo "Compilation failed."
    exit 1
fi

# Run the tests and capture the output
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test_results.txt

# Process the test results to generate a grade or feedback
# This part can be customized based on how you want to grade (e.g., count passed tests, look for specific output, etc.)
# For simplicity, just output the test results
cat test_results.txt
