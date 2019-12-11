#/bin/bash

# Build/Compile
javac -d /usr/apps/memoryleaker/classes /usr/apps/memoryleaker/src/*.java

# Run/Execute
java -XX:+IgnoreUnrecognizedVMOptions -XX:+UseContainerSupport -XX:+IdleTuningCompactOnIdle -XX:+IdleTuningGcOnIdle -Xtune:virtualized -cp /usr/apps/memoryleaker/classes com.demos.oom.MemoryLeaker
