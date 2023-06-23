.PHONY: all clean
all: memory

plugin/build/memory.so: plugin/memory.cpp
	@make -C plugin/build all

clean:
	rm -f *.ll memory
	@make -C plugin/build clean

RUNTIME=${THORIN_RUNTIME_PATH}/artic/runtime.impala \
	${THORIN_RUNTIME_PATH}/artic/intrinsics_thorin.impala \
	${THORIN_RUNTIME_PATH}/artic/intrinsics_rv.impala \
	${THORIN_RUNTIME_PATH}/artic/intrinsics_math.impala \
	${THORIN_RUNTIME_PATH}/artic/intrinsics.impala

main.ll: main.art plugin/build/memory.so
	artic \
		${RUNTIME} \
		main.art \
		--plugin plugin/build/memory.so \
		--emit-llvm \
		--log-level info \
		-o main

memory: main.ll
	#clang++ -o memory -O3 -L${THORIN_RUNTIME_PATH}/../build/lib -lruntime -lm $^
	clang++ -o memory -Og -g -L${THORIN_RUNTIME_PATH}/../build/lib -lruntime -lm $^
