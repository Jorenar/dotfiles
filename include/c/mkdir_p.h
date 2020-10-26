#ifndef MKDIR_P_H_
#define MKDIR_P_H_

#include <errno.h>
#include <string.h>
#include <linux/limits.h>
#include <sys/stat.h>

int mkdir_p(const char* path_)
{
    errno = 0;

    if (strlen(path_) > PATH_MAX-1) {
        errno = ENAMETOOLONG;
        return -1;
    }

    char path[PATH_MAX];
    strcpy(path, path_);

    // Create "intermediate" directories
    for (char* p = path + 1; *p; ++p) {
        if (*p == '/') {
            *p = '\0'; // temporarily truncate
            if (mkdir(path, S_IRWXU) < 0 && errno != EEXIST) {
                return -1;
            }
            *p = '/';
        }
    }

    // Create final dir
    if (mkdir(path, S_IRWXU) < 0) {
        if (errno != EEXIST) {
            return -1;
        }
    }

    return 0;
}

#endif
