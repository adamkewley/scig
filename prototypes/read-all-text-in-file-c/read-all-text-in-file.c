#ifndef READ_ALL_TEXT_IN_FILE_C
#define READ_ALL_TEXT_IN_FILE_C

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

char *read_all_text_in_file(const char *path) {
	// Read the input file example-yaml-file.yml
	FILE *example_input = fopen(path, "rb");

	if(example_input == NULL) {
		printf("Error opening example-yaml-file.yml %d (%s)\n", errno, strerror(errno));
		return NULL;
	}

	fseek(example_input, 0, SEEK_END);

	long example_input_size = ftell(example_input);

	fseek(example_input, 0, SEEK_SET);

	char *text = malloc(example_input_size + 1);

	fread(text, example_input_size, 1, example_input);

	fclose(example_input);

	return text;
}

#endif
