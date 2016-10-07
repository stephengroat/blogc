/*
 * blogc: A blog compiler.
 * Copyright (C) 2015-2016 Rafael G. Martins <rafael@rafaelmartins.eng.br>
 *
 * This program can be distributed under the terms of the BSD License.
 * See the file LICENSE.
 */

#ifndef _SHELL_COMMAND_PARSER_H
#define _SHELL_COMMAND_PARSER_H

char* bgr_shell_command_parse(const char *command);
char* bgr_shell_quote(const char *command);

#endif /* _SHELL_COMMAND_PARSER_H */