/*
 * Error Functions
 *
 * Attribution: Advanced Programming in the UNIX Environment
 *         W. Richard Stevens, 3rd edition.
 *
 * Tobin Harding - 17 February 2015
 *
 *
 * Write:
 *
 * if (error_condition)
 *     err_dump(<printf format string>);
 *
 * Instead of:
 *
 * if (error_condition) {
 *     char buf[200]
 *     
 *     sprintf(buf, <printf format string>);
 *     perror(buf);
 *     abort();
 * }
 */

#ifndef _ERR_H
#define _ERR_H

/* Nonfatal error related to a system call */
void	err_ret(const char *fmt, ...); 

/* Fatal error related to a system call. */
void	err_sys(const char *fmt, ...) __attribute__((noreturn));

/* Fatal error related to a system call. */
void	err_dump(const char *fmt, ...) __attribute__((noreturn));

/* Nonfatal error unrelated to a system call. */
void	err_msg(const char *fmt, ...);

/* Nonfatal error unrelated to a system call. */
void	err_cont(int error, const char *fmt, ...);

/* Fatal error unrelated to a system call. */
void	err_quit(const char *fmt, ...) __attribute__((noreturn));

/* Fatal error unrelated to a system call. */
void	err_exit(int error, const char *fmt, ...) __attribute__((noreturn));

#endif	/* _ERR_H */
