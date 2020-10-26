#ifndef RM_H_
#define RM_H_

#define _XOPEN_SOURCE 500

#include <ftw.h>
#include <stdarg.h>
#include <stdio.h>
#include <unistd.h>

int ntfw_rm(const char* fpath, const struct stat* sb, int typeflag, struct FTW* ftwbuf)
{
    return remove(fpath);
}

int ntfw_rmdir(const char* fpath, const struct stat* sb, int typeflag, struct FTW* ftwbuf)
{
    return rmdir(fpath);
}

int rm(const char mode, const char* fmt, ...)
{
    va_list vars;
    va_start(vars, fmt);
    char path[BUFSIZ];
    vsnprintf(path, BUFSIZ, fmt, vars);
    va_end(vars);

    switch (mode) {
        case 'r': // remove recursively
            return nftw(path, ntfw_rm, 100, FTW_DEPTH|FTW_PHYS);
        case 'd': // remove dir
            return rmdir(path);
        case 'D': // remove empty subdirs and if emptied, then dir too
            return nftw(path, ntfw_rmdir, 100, FTW_DEPTH|FTW_PHYS);
        default:  // remove file
            return unlink(path);
    }
}

#endif
