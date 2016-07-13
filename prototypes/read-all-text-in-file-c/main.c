#include <stdio.h>
#include <stdlib.h>
#include "read-all-text-in-file.c"

int main(int argc, char **argv) {
	if(argc == 1) {
		fprintf(stderr, "Error: Must provide at least one path argument\n");
		return 1;
	}

	char *text_in_file = read_all_text_in_file(argv[1]);

	printf("%s\n", text_in_file);

	free(text_in_file);

	return 0;
}
