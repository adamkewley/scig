#include <yaml.h>
#include "../read-all-text-in-file/read-all-text-in-file.c"
#include <string.h>

const char *str_parser_err(const unsigned int parser_error)
{
	static const char *memory_error_msg =
		"MEMORY_ERROR";
	static const char *reader_error_msg =
		"READER ERROR";
	static const char *scanner_error_msg =
		"SCANNER ERROR";
	static const char *parser_error_msg =
		"PARSER ERROR";
	static const char *internal_error_msg =
		"INTERNAL ERROR";

	switch (parser_error) {
	case YAML_MEMORY_ERROR:
		return memory_error_msg;
	case YAML_READER_ERROR:
		return reader_error_msg;
	case YAML_SCANNER_ERROR:
		return scanner_error_msg;
	case YAML_PARSER_ERROR:
		return parser_error_msg;
	default:
		return internal_error_msg;
	}
}

int main(const int argc, const char **argv)
{
	if (argc == 1) {
		fprintf (stderr, "Must provide at least one argument");
		return 1;
	}

	const char *input_path = argv[1];

	yaml_parser_t parser;
	yaml_event_t event;

	int done = 0;

	char *yaml_text = read_all_text_in_file(input_path);

	int len = strlen(yaml_text);

	yaml_parser_initialize(&parser);

	// Set a string input
	yaml_parser_set_input_string(&parser, yaml_text, len);

	while (!done) {
		if (!yaml_parser_parse(&parser, &event))
		{

			switch (parser.error)
			{
			case YAML_MEMORY_ERROR:
				fprintf(stderr, "Memory error: Not enough memory for parsing\n");
				break;
			case YAML_READER_ERROR:
				if (parser.problem_value != -1) {
					fprintf (stderr, "Reader error: %s: #%X at %d\n", parser.problem,
						 parser.problem_value, parser.problem_offset);
				}
				else {
					fprintf(stderr, "Reader error: %s at %d\n", parser.problem,
						parser.problem_offset);
				}
				break;
			case YAML_SCANNER_ERROR:
				if (parser.context) {
					fprintf(stderr, "Scanner error: %s at line %d, column %d\n"
						"%s at line %d, column %d\n", parser.context,
						parser.context_mark.line+1, parser.context_mark.column+1,
						parser.problem, parser.problem_mark.line+1,
						parser.problem_mark.column+1);
				}
				else {
					fprintf(stderr, "Scanner error: %s at line %d, column %d\n",
						parser.problem, parser.problem_mark.line+1,
						parser.problem_mark.column+1);
				}
				break;
			case YAML_PARSER_ERROR:
				if (parser.context) {
					fprintf(stderr, "Parser error: %s at line %d, column %d\n"
						"%s at line %d, column %d\n", parser.context,
						parser.context_mark.line+1, parser.context_mark.column+1,
						parser.problem, parser.problem_mark.line+1,
						parser.problem_mark.column+1);
				}
				else {
					fprintf(stderr, "Parser error: %s at line %d, column %d\n",
						parser.problem, parser.problem_mark.line+1,
						parser.problem_mark.column+1);
				}
				break;
			default:
				/* Couldn't happen. */
				fprintf(stderr, "Internal error\n");
				break;
			}
			return 1;
		}
		else {
			done = (event.type == YAML_STREAM_END_EVENT);
			yaml_event_delete(&event);
		}
	}

	yaml_parser_delete(&parser);

	return 0;
}
