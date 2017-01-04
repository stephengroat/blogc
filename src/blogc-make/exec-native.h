/*
 * blogc: A blog compiler.
 * Copyright (C) 2016 Rafael G. Martins <rafael@rafaelmartins.eng.br>
 *
 * This program can be distributed under the terms of the BSD License.
 * See the file LICENSE.
 */

#ifndef _MAKE_EXEC_NATIVE_H
#define _MAKE_EXEC_NATIVE_H

#include <stdbool.h>
#include "ctx.h"

int bm_exec_native_cp(bm_filectx_t *source, bm_filectx_t *dest, bool verbose);
int bm_exec_native_rm(const char *output_dir, bm_filectx_t *dest, bool verbose);

#endif /* _MAKE_EXEC_NATIVE_H */