#include "unzip.h"

#include <stdio.h>
#include <string.h>


int UZ_EXP MyUzpPassword( zvoid *pG,            /* Ignore (globals pointer). */
                          int *rcnt,            /* Retry count. */
                          char *pwbuf,          /* Password buffer. */
                          int size,             /* Password buffer size. */
                          ZCONST char *zfn,     /* Archive name. */
                          ZCONST char *efn)     /* Archive member name. */
{
    fprintf( stderr, "MyUP.  size = %d, zfn: >%s<\n", size, zfn);
    fprintf( stderr, "MyUP.  efn: >%s<\n", efn);
    fprintf( stderr, "MyUP.  *rcnt = %d\n", *rcnt);
    strncpy( pwbuf, "password", size);
    return IZ_PW_ENTERED;
}

/*
 * unzip.h:
 *
 *typedef struct _UzpCB {
 *    ulg structlen;
 *    MsgFn *msgfn;
 *    InputFn *inputfn;
 *    PauseFn *pausefn;
 *    PasswdFn *passwdfn;
 *    StatCBFn *statrepfn;
 *} UzpCB;
 */


int main( int argc, char **argv)
{
    int sts;
#ifdef __VMS
    int vsts;
#endif
    ZCONST UzpVer *unzip_ver_p;
    UzpCB user_functions =
#ifdef MY_PW
     { (sizeof user_functions), NULL, NULL, NULL, MyUzpPassword, NULL };
#else /* def MY_PW */
     { (sizeof user_functions), NULL, NULL, NULL, NULL, NULL };
#endif /* def MY_PW [else] */

    sts = UzpMainI( argc, argv, &user_functions);

    fprintf( stderr, " Raw sts = %d (%%x%08x).\n", sts, sts);
#ifdef __VMS
    vsts = vms_status( sts);
    fprintf( stderr, " VMS sts = %d (%%x%08x).\n", vsts, vsts);
#endif

    unzip_ver_p = UzpVersion();
    fprintf( stderr, " UnZip version %d.%d%d%s\n",
     unzip_ver_p->unzip.major, unzip_ver_p->unzip.minor,
     unzip_ver_p->unzip.patchlevel, unzip_ver_p->betalevel);
}
