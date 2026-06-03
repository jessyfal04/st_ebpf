
for c in ./res/*.c; do
	echo "> Convert ${c}"
    ./src/convert.sh $c
done

for o in ./res/*.o; do
	echo "> Bytecode ${o}"
    ./src/bytecode.sh $o
done

shopt -s globstar nullglob
for o in ./out/**/code/*.hex; do
	echo "> Instructions for ${o}"
	./src/instructions.sh $o
done

