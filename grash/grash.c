#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>

/*
  GRAph SHell - a Flow-Based Programming shell

  A *nix shell that reads scripts of simple commands that plumb
  commands together with a graph of pipes / sockets / etc.

  This shell is not intended for heavy human consumption, but as an assembler
  that interprets programs created by graphical Flow-Based Programming
  (FBP) tools.

  Commands to the interpreter

  comments: # as very first character in the line
  empty line

  pipe N : creates N pipes starting at index 0
  push N : push N as an arg to the next command (dup)
  dup N : dup2(pipes[TOS][TOS-1],N), pop TOS, pop TOS
  exec <args> : splits the args and calls execvp, after closing all pipes
  exec1st <args> : splits the args, appends args from the command line and calls execvp, after closing all pipes
  fork : forks a new process
         parent ignores all subsequent commands until krof is seen
  krof : signifies end of forked child section
         parent resumes processing commands
	 child (if not exec'ed) terminates

*/

#define SOCKMAX 100
#define LINEMAX 1024
#define ARGVMAX 128
#define STACKMAX 2

#define PREAD 0
#define PWRITE 1
#define STDIN 0
#define STDOUT 1

int comment (char *line) {
  /* return 1 if line begins with # or is empty, otherwise 0 */
  return line[0] == '#' || line[0] == '\n' || line[0] == '\0';
}

char *parse (char *cmd, char *line) {
  /* if command matches, return pointer to first non-whitespace char of args */
  while (*cmd)
    if (*cmd++ != *line++)
      return NULL;
  while (*line == ' ') line++;
  return line;
}

int sockets[SOCKMAX-1][2];
int child;
#define MAIN 1
#define PARENT 2
#define CHILD 3
int state = MAIN;
int stack[STACKMAX];
int sp = 0;

void quit (char *m) {
  perror (m);
  exit (1);
}

void push (char *p) {
  assert (sp < STACKMAX);
  stack[sp++] = atoi(p);
}

int pop () {
  assert (sp > 0);
  return stack[--sp];
}

void gdup (char *p) {
  int fd = atoi(p);
  int i = pop();
  int dir = pop();
  dup2 (sockets[i][dir], fd);
}

int highPipe = -1;

void mkPipes (char *p) {
  int i = atoi(p);
  if (i <= 0 || i > SOCKMAX)
    quit("socket index");
  highPipe = i - 1;
  i = 0;
  while (i <= highPipe)
    if (pipe (sockets[i++]) < 0)
      quit ("error opening stream socket pair");
}

void closeAllPipes () {
  int i;
  for (i = 0 ; i <= highPipe ; i++) {
    close (sockets[i][PREAD]);
    close (sockets[i][PWRITE]);
  }
}
	   

void doFork () {
  if ((child = fork()) == -1)
    quit ("fork");
  state = child ? PARENT : CHILD;
}

void doKrof () {
  state = MAIN;
}

void  parseArgs(char *line, int *argc, char **argv) {
  *argc = 0;
  while (*line != '\0') {
    while (*line == ' ' || *line == '\t' || *line == '\n')
      *line++ = '\0';
    if (*line == '\0')
      break;
    *argv++ = line;
    *argc += 1;
    while (*line != '\0' && *line != ' ' && 
	   *line != '\t' && *line != '\n') 
      line++;
  }
  *argv = '\0';
}
  
void appendArgs (int argc, char **argv, int oargc, char **oargv) {
  /* tack extra command-line args onto tail of argv */
  if (oargc > 2) {
    int i = 2;
    while (i < oargc) {
      argv[argc] = oargv[i];
      argc += 1;
      i += 1;
    }
    argv[i] = '\0';
  }
}

void doExec (char *p, int oargc, char **oargv, int first) {
  char *argv[ARGVMAX];
  int argc;
  closeAllPipes();
  parseArgs (p, &argc, argv);
  if (first) {
    appendArgs (argc, argv, oargc, oargv);
  }
  argc = 0;
  while (argv[argc]) {
    fprintf (stderr, "%s ", argv[argc++]);
  }
  fprintf (stderr, "\n");
  if (execvp (argv[0], argv) < 0)
    quit ("exec failed");
}

void interpret (char *line, int argc, char **argv) {
  char *p;
  if (comment (line))
    return;

  switch (state) {

  case CHILD:
    p = parse ("krof", line);
    if (p)
      exit(0);
    /* fall through */

  case MAIN:
    p = parse ("pipes", line);
    if (p) {
      mkPipes (p);
      return;
    }
    p = parse ("dup", line);
    if (p) {
      gdup (p);
      return;
    }
    p = parse ("push", line);
    if (p) {
      push (p);
      return;
    }
    p = parse ("fork", line);
    if (p) {
      doFork ();
      return;
    }
    p = parse ("exec1st", line);
    if (p) {
      doExec (p, argc, argv, 1);
      return;
    }
    p = parse ("exec", line);
    if (p) {
      doExec (p, argc, argv, 0);
      return;
    }
    p = parse ("krof", line);
    if (p)
      quit ("krof seen in MAIN state (can't happen)");
    break;

  case PARENT:
    p = parse ("krof", line);
    if (p) {
      doKrof ();
      return;
    }
    return;
  }
  quit ("command");
}
  

int main (int argc, char **argv) {
  int r;
  char line[LINEMAX-1];
  char *p;
  FILE *f;

  if (argc < 2 || argv[1][0] == '-') {
    f = stdin;
  } else {
    f = fopen (argv[1], "r");
  }
  if (f == NULL)
    quit ("usage: grash {filename|-} [args]");

  for (r = 0; r < SOCKMAX; r++) {
    sockets[r][0] = -1;
    sockets[r][1] = -1;
  }
  
  p = fgets (line, sizeof(line), f);
  while (p != NULL) {
    interpret (line, argc, argv);
    p = fgets (line, sizeof(line), f);
  }
}
