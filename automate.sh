#!/bin/sh

docker system prune -a
docker build -t dash .

inport=18444
outport=18332
echo $LD_LIBRARY_PATH
for i in $(seq 0 24)
do
	#echo $i
	x="node_"$i
	sudo docker run -td -p $inport:$inport -p $outport:$outport --name=$x --hostname=$x --rm dash
	sudo docker exec -t $x dashd -regtest -daemon
	sleep 40
	sudo docker exec -t $x dash-cli -regtest getinfo 
	outport=$((outport+1))
	inport=$((inport+1))
done

python connect_nodes.py
