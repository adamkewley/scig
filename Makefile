# Preprocess the markdown readme
README.md: docs/README.md
	./tools/preprocess-markdown -o $@ $<

.PHONY: docs all clean
docs: README.md
all: docs
clean:
	rm README.md
