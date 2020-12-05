#define _XOPEN_SOURCE 500

#include <linux/limits.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

#include <jcbc/sys/mkdir_p.h>
#include <jcbc/sys/rm.h>
#include <progwrap.h>

#define TIME_LIMIT 5    // wait 5 seconds for '~/.mozilla' dir to appear
#define PROC_SELF  "/proc/self/exe"
#define NAME "Firefox XDG wrapper"

void clearJunk();
void genArgs(char* firefox, char* args[], int argc, char* argv[]);

void Exit(int status, pid_t pid);

extern char** environ;

int main(int argc, char* argv[])
{
    struct stat fb;

    char cur[PATH_MAX];
    if (getCurrentBin(cur) == NULL) {
        perror(NAME);
        exit(1);
    }

    char firefox[PATH_MAX];
    if (findRealBin(firefox) == NULL) {
        perror(NAME ": Could not find original binary");
        exit(1);
    }

    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "--profile") == 0) {
            execv(firefox, argv);
        }
    }

    pid_t pid = fork();

    if (pid < 0) {
        perror(NAME);
        exit(1);
    }

    if (pid) {
        char* args[ARG_MAX];
        genArgs(firefox, args, argc, argv);

        if (stat(args[2], &fb) < 0) { // create dir for profile if doesn't already exist
            if (mkdir_p(args[2]) < 0) {
                perror(NAME);
                Exit(1, pid);
            }
        }

        signal(SIGCHLD, SIG_IGN); // forget about zombie from clearJunk()
        if (execve(firefox, args, environ) < 0) {
            perror(NAME);
            Exit(1, pid);
        }
    } else {
        clearJunk();
    }

    return 0;
}

void Exit(int status, pid_t pid)
{
    kill(pid, SIGKILL);
    exit(status);
}

void genArgs(char* firefox, char* args[], int argc, char* argv[])
{
    char xdg_data_home[PATH_MAX];
    char* temp = getenv("XDG_DATA_HOME");
    if (temp) {
        strncpy(xdg_data_home, temp, PATH_MAX);
    } else {
        snprintf(xdg_data_home, PATH_MAX, "%s%s", getenv("HOME"), "/.local/share");
    }

    char profile[PATH_MAX];
    snprintf(profile, PATH_MAX, "%s%s", xdg_data_home, "/firefox");

    int n = argc + 2 + 1; // number of args: passed to executable + profile + NULL

    args[0] = strdup(firefox);
    args[1] = strdup("--profile");
    args[2] = strdup(profile);
    args[n-1] = NULL;

    for (int i = 1; i < argc; ++i) {
        args[i+2] = strdup(argv[i]);
    }
}

void clearJunk()
{
    char mozilla[BUFSIZ]; // "~/.mozilla"
    snprintf(mozilla, BUFSIZ, "%s%s", getenv("HOME"), "/.mozilla");

    int t = 0; // timer

    while (access(mozilla, F_OK) < 0) {
        if (t > TIME_LIMIT) {
            perror(NAME ": Time limit exceeded - '~/.mozilla'");
            exit(1);
        }
        sleep(1);
        ++t;
    }

    rm('r', "%s%s", mozilla, "/firefox/Crash Reports");
    rm('d', "%s%s", mozilla, "/firefox/Pending Pings");
    rm('D', "%s",   mozilla);
}
