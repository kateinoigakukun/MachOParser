.PHONY: default
default: gen

.PHONY: gen
gen: hello

hello: hello.o
	swiftc hello.o
%.o: %.swift
	swiftc -c $< -o $@
