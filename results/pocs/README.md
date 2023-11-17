# Must Do
Please run
```
sudo chmod +x mvOtherArtifacts.sh
cd /home/ubuntu/results/pocs/
./mvOtherArtifacts.sh
```
first to ensure that the required files are moved to the correct location.

USe command 
```
cd /home/ubuntu/topstream
make clean all
```

# Fuzzing
```
cd $WORKDIR/topstream
afl-fuzz -d -c /home/ubuntu/results/others/restart.sh -i /home/ubuntu/results/seed_corpus -x /home/ubuntu/results/others/topstream.dict -o /home/ubuntu/results/topstream_out -N tcp://127.0.0.1/8888 -P TOPSTREAM -D 10000 -q 3 -s 2 -E -K -R /home/ubuntu/topstream/topstream-fuzz 127.0.0.1 8888 127.0.0.1 9999
```

# Code Coverage
After fuzzing

```
cd $WORKDIR/topstream
for f in $(echo ../results/topstream_out/replayable-queue/id*); do echo "Processing $f ..."; $WORKDIR/topstream/service 127.0.0.1 9999 >> /home/ubuntu/log.txt 2>&1 & aflnet-replay $f TOPSTREAM 8888 > /dev/null 2>&1 & $WORKDIR/topstream/topstream-gcov 127.0.0.1 8888 127.0.0.1 9999; done
```
```
gcovr -r . -s
```


# Reproduce Vulnerabilities

After fuzzing

Traverse all the test cases that caused the crash to see the cause of the crash using AddressSanitizer
```
for f in $(echo $WORKDIR/results/topstream_out/replayable-crashes/id*); do echo "Processing $f ..."; $WORKDIR/topstream/service 127.0.0.1 9999 >> /home/ubuntu/log.txt 2>&1 & aflnet-replay $f TOPSTREAM 8888 > /dev/null 2>&1 & $WORKDIR/topstream/topstream-asan 127.0.0.1 8888 127.0.0.1 9999; done
```

Traverse all the test cases in the folder replayable-queue using AddressSanitizer to find Memory leaks
```
for f in $(echo $WORKDIR/results/topstream_out/replayable-queue/id*); do echo "Processing $f ..."; $WORKDIR/topstream/service 127.0.0.1 9999 >> /home/ubuntu/log.txt 2>&1 & aflnet-replay $f TOPSTREAM 8888 > /dev/null 2>&1 & $WORKDIR/topstream/topstream-asan 127.0.0.1 8888 127.0.0.1 9999; done
```

## Crashes from previous run
I have provided the 'replayable-crashes' folder obtained from the previous run. 

The corresponding relationships are as follows:

'crash1': Movie type

id:000025,sig:06,src:000095,op:havoc,rep:32

'crash2': Movie ID exceeds the limit of the int type

id:000001,sig:06,src:000000+000070,op:splice,rep:32

'crash3': Heap-buffer-overflow

id:000008,sig:11,src:000001+000152,op:splice,rep:8

'crash4': Memory leaks"

id:000131,src:000000,op:havoc,rep:16