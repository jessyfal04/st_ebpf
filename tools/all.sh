
for c in ./res/*.c; do
	echo "> Convert ${c}"
    ./convert.sh $c
done

for o in ./res/*.o; do
	echo "> Bytecode ${o}"
    ./bytecode.sh $o
done

