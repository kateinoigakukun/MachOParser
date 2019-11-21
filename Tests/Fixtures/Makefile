.PHONY: default
default: gen

.PHONY: gen
gen: hello.o
%.o: %.swift
	swiftc -c $< -o $@
