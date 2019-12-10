#/bin/bash

# Build/Compile
javac -d /usr/apps/cpuloadgen/classes /usr/apps/cpuloadgen/src/*.java

# Run/Execute
java -XX:+IgnoreUnrecognizedVMOptions -XX:+UseContainerSupport -XX:+IdleTuningCompactOnIdle -XX:+IdleTuningGcOnIdle -Xtune:virtualized -cp /usr/apps/cpuloadgen/classes SimulateCPULoadWithMemoryPressure  50 100 1024
