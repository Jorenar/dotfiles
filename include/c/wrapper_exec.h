#ifndef WRAPPER_EXEC_H_
#define WRAPPER_EXEC_H_

#include <errno.h>
#include <libgen.h>
#include <linux/limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

char execChainEnvVar[100];

int appendExecChain(ino_t I)
{
    char inoStr[100];
    snprintf(inoStr, 100, "%zu", I);

    char* chain = getenv(execChainEnvVar);
    if (chain && strstr(chain, inoStr)) {
        return 1;
    } else {
        char buf[BUFSIZ];
        if (chain) {
            snprintf(buf, BUFSIZ, "%s%s%s%s%s", execChainEnvVar, "=", chain, ":", inoStr);
        } else {
            snprintf(buf, BUFSIZ, "%s%s%s", execChainEnvVar, "=", inoStr);
        }
        putenv(buf);
    }
    return 0;
}

char* findRealBin(char* bin, char* cur)
{
    errno = 0;

    struct stat fb;

    stat(cur, &fb);
    ino_t curInode = fb.st_ino;

    char* bs = basename(cur);
    snprintf(execChainEnvVar, 100, "%s%s", "execution_chain_", bs);

    char buf[PATH_MAX];
    char PATH[BUFSIZ];
    strncpy(PATH, getenv("PATH"), BUFSIZ);
    char* dir = strtok(PATH, ":");

    do {
        snprintf(buf, PATH_MAX, "%s%s%s", dir, "/", bs);
        if (stat(buf, &fb) < 0) {
            continue;
        }
        ino_t ino = fb.st_ino;

        if (ino != curInode && fb.st_mode & S_IXUSR) {
            if (appendExecChain(ino) == 0) {
                strncpy(bin, buf, PATH_MAX);
                return bin;
            }
        }
    } while ((dir = strtok(NULL, ":")));

    errno = ENOENT;
    return NULL;
}

#endif
