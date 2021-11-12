#==============================================================================
# Makefile for UnZip, UnZipSFX and fUnZip:  Unix and MS-DOS ("real" makes only)
# Version:  6.1                                                     05 Aug 2011
#==============================================================================


# INSTRUCTIONS (such as they are):
#
# "make generic"         Makes UnZip on most systems using "cc".
# "make generic CC=gcc"  Makes UnZip on most systems using "gcc".
# "make list"	         Lists all supported targets.
# "make help"	         Advice on which targets to try if problems occur.
#
# CF are flags for the C compiler.  LF are flags for the loader.  LF2 are more
# flags for the loader, if they need to be at the end of the line instead of at
# the beginning (for example, some libraries).  FL and FL2 are corresponding
# flags for fUnZip.  LOCAL_UNZIP is a "make" macro that can be used to add
# default C flags to your compile without editing the Makefile (e.g.,
# -DDEBUG_STRUC, or -FPi87 on PCs using Microsoft C).
#
# The "generic" target uses the "unix/configure" script to probe the compiler
# and other parts of the environment to adjust the build procedure, and to
# enable or disable some program features.  Other (older) targets are less
# well tested, and may need considerable help from the user to get optimal
# results (or any success at all).
#
# If you want bzip2 support included, the "generic" target should find bzip2
# source code in the local ./bzip2 subdirectory, or the user can set the
# "make" macro IZ_BZIP2 to a directory containing suitable bzip2 header and
# object/shared library files.
#
# Similarly, to use zlib for uncompressing instead of UnZip's built-in code,
# set the "make" macro IZ_ZLIB to a directory containing suitable zlib header
# and object/shared library files.  For example:
#     make -f unix/Makefile IZ_BZIP2=../../bzip2/bzip2-1.0.6 \
#      IZ_ZLIB=../../zlib/zlib-1.2.5 generic
#
# Some versions of make do not define the macro "MAKE"; this is rare, but if
# things don't work, try using "make" instead of "$(MAKE)" in your system's
# makerule.  Or try adding the following line to your .login file:
#     setenv MAKE 'make'          # C shell
#     MAKE='make' ; export MAKE   # Bourne(-like) shell.
# (That never works.  "make" programs that don't define MAKE probably won't
# look in the environment, either.)
#
# Memcpy and memset are provided for those systems that don't have them; they
# are in fileio.c and will be used if -DZMEM is included in CF.  These days,
# almost all systems have them.
#
# Be sure to test your new UnZip (and UnZipSFX and fUnZip).  A successful
# build does not guarantee a working program.


#####################
# MACRO DEFINITIONS #
#####################

# Defaults most systems use (use "make" macro LOCAL_UNZIP to add compiler
# flags, such as -DDOSWILD).

# (To use GCC, change cc to gcc in CC.)
CC = cc
LD = $(CC) # CC and LD must agree.
AR = ar
AS = as
CHMOD = chmod
#CP = cp
LN = ln
MAKEF = -f unix/Makefile
RANLIB = ranlib
RM = rm -f
SHELL = /bin/sh
STRIP = strip
ZIP = zip

# UnZip flags
LOC = $(D_USE_BZ2) $(D_USE_ZLIB) $(LOCAL_UNZIP)
AF = $(LOC)
CFLAGS = -O
CF_NOOPT = -I. -DUNIX $(LOC)
CF = $(CFLAGS) $(CF_NOOPT)
LFLAGS1 =
LF = -o unzip$E $(LFLAGS1)
LF2 = -s

# UnZipSFX flags
SL = -o unzipsfx$E $(LFLAGS1)
SL2 = $(LF2)

# fUnZip flags
FL = -o funzip$E $(LFLAGS1)
FL2 = $(LF2)

# general-purpose stuff
BINPERMS = 755
MANPERMS = 644
E =
O = .o
M = unix

# Version info for unix/unix.c
HOST_VERSINFO=-DIZ_CC_NAME='\"\$$(CC) \"' -DIZ_OS_NAME='\"`uname -a`\"'

# defaults for crc32 stuff and system dependent headers
CRCA_O =
OSDEP_H = unix/unxcfg.h
# default for dependency on auto-configure result, is an empty symbol
# so that the static non-autoconfigure targets continue to work
ACONF_DEP =

# optional inclusion of bzip2 decompression
IZ_OUR_BZIP2_DIR = bzip2
IZ_BZIP2 = $(IZ_OUR_BZIP2_DIR)
## The following symbols definitions need to be set to activate bzip2 support:
#D_USE_BZ2 = -DUSE_BZIP2
#L_BZ2 = -lbz2
#LIBBZ2 = $(IZ_BZIP2)/libbz2.a

# defaults for unzip's "built-in" bzip2 library compilation
CC_BZ = $(CC)
CFLAGS_BZ = $(CFLAGS)

# object files
OBJS1 = unzip$O crc32$O $(CRCA_O) crypt$O envargs$O explode$O
OBJS2 = extract$O fileio$O globals$O inflate$O list$O match$O
OBJS3 = process$O ttyio$O ubz2err$O unreduce$O unshrink$O zipinfo$O
OBJAES = aescrypt$O aeskey$O aestab$O fileenc$O hmac$O prng$O pwd2key$O \
         sha1$O
OBJLZMA = 7zFile$O Alloc$O LzFind$O LzmaDec$O
OBJS = $(OBJS1) $(OBJS2) $(OBJS3) $M$O
LOBJS = $(OBJS)
OBJSDLL = $(OBJS:.o=.pic.o) api.pic.o
OBJX = unzipsfx$O crc32_$O $(CRCA_O) crypt_$O extract_$O fileio_$O \
	globals_$O inflate_$O match_$O process_$O ttyio_$O ubz2err_$O $M_$O
LOBJX = $(OBJX)
OBJF = funzip$O crc32$O $(CRCA_O) cryptf$O globalsf$O inflatef$O ttyiof$O
#OBJS_OS2 = $(OBJS1:.o=.obj) $(OBJS2:.o=.obj) os2.obj
#OBJF_OS2 = $(OBJF:.o=.obj)
UNZIP_H = unzip.h unzpriv.h globals.h $(OSDEP_H) $(ACONF_DEP)
AES_H = aes_wg/aes.h aes_wg/aesopt.h aes_wg/fileenc.h aes_wg/hmac.h \
        aes_wg/prng.h aes_wg/pwd2key.h aes_wg/sha1.h
LZMA_H = lzma/7zFile.h lzma/7zVersion.h lzma/Alloc.h lzma/LzFind.h \
         lzma/LzHash.h lzma/LzmaDec.h lzma/Types.h

# installation
# (probably can change next two to `install' and `install -d' if you have it)
INSTALL = cp
INSTALL_PROGRAM = $(INSTALL)
INSTALL_D = mkdir -p
# on some systems, manext=l and MANDIR=/usr/man/man$(manext) may be appropriate
manext = 1
prefix = /usr/local
BINDIR = $(prefix)/bin#			where to install executables
MANDIR = $(prefix)/man/man$(manext)#	where to install man pages
INSTALLEDBIN = $(BINDIR)/funzip$E $(BINDIR)/unzip$E $(BINDIR)/unzipsfx$E \
	$(BINDIR)/zipgrep$E $(BINDIR)/zipinfo$E
INSTALLEDMAN = $(MANDIR)/funzip.$(manext) $(MANDIR)/unzip.$(manext) \
	$(MANDIR)/unzipsfx.$(manext) $(MANDIR)/zipgrep.$(manext) \
	$(MANDIR)/zipinfo.$(manext)

# Solaris 2.x package stuff:
PKGDIR = IZunzip
VERSION = Version 6.1

UNZIPS = unzip$E funzip$E unzipsfx$E
# this is a little ugly...well, OK, it's a lot ugly:
MANS = man/funzip.1 man/unzip.1 man/unzipsfx.1 man/zipgrep.1 man/zipinfo.1
DOCS = funzip.txt unzip.txt unzipsfx.txt zipgrep.txt zipinfo.txt

# list of supported systems/targets in this version
SYSTEMG1 = generic generic_pkg
SYSTEMG2 = generic1 generic2 generic3 generic_bz2 generic_zlib generic_shlib
SYSTEMS1 = 386i 3Bx 7300 7300_gcc aix aix_rt amdahl amdahl_eft apollo aviion
SYSTEMS2 = bsd bsdi bsdi_noasm bull coherent convex cray cray_opt cyber_sgi
SYSTEMS3 = cygwin dec dnix encore eta freebsd gcc gould hk68 hp hpux
SYSTEMS4 = isc isc_gcc isi linux linux_dos linux_noasm linux_shlib linux_shlibz
SYSTEMS5 = lynx macosx macosx_gcc minix mips mpeix next next10 next2x next3x
SYSTEMS6 = nextfat osf1 pixel ptx pyramid qnxnto realix regulus rs6000 sco
SYSTEMS7 = sco_dos sco_sl sco_x286 sequent sgi solaris solaris_pkg stardent
SYSTEMS8 = stellar sunos3 sunos4 sysv sysv_gcc sysv6300 tahoe ti_sysv ultrix
SYSTEMS9 = vax v7 xenix xos


####################
# DEFAULT HANDLING #
####################

# By default, print help on which makefile targets to try.  (The SYSTEM
# variable is no longer supported; use "make <target>" instead.)

help:
	@echo ''
	@echo '  For most users, the best build method is to use the "make"'
	@echo '  target "generic".  For example: "make generic" (cc) or'
	@echo '  "make generic CC=gcc" (gcc).  Other (older) targets are less'
	@echo '  well tested, and may need considerable help from the user to'
	@echo '  get optimal results (or any success at all).  Use "make list"'
	@echo '  to get a list of valid targets.'
	@echo ''
	@echo '  Add "CC=gcc" to the "make" command to use "gcc" instead of'
	@echo '  "cc".  First try "make -f unix/Makefile generic" (to use "cc")'
	@echo '  (or "make -f unix/Makefile generic CC=gcc" (to use "gcc")), as'
	@echo '  "generic" should autodetect and set the proper flags.'
	@echo ''
	@echo '  If the "generic" target fails, then you might try an older'
	@echo '  generic target which is now called "generic1".  Always do'
	@echo '  "make clean" before trying a different target.'
	@echo ''
	@echo '  If the compiler complains about "timezone redefined", then the'
	@echo '  "generic2" target may work better.  If the linker complains'
	@echo '  about an undefined symbol, "_ftime", then the "generic3"'
	@echo '  target may work better.'
	@echo ''
	@echo '  One of these actions should produce working UnZip programs on'
	@echo '  most UNIX(-like) systems.  If you know a bit more about the'
	@echo '  system on which you work, then you might try "make list" for'
	@echo '  a list of the system-specific targets supported herein.  (Many'
	@echo "  of them do exactly the same thing, so don't agonize too much"
	@echo '  over which to pick if two or more sound equally likely.)'
	@echo '  The comments in unix/Makefile and the INSTALL file may offer'
	@echo '  some useful information for building on various target'
	@echo '  systems.'
	@echo ''
	@echo '  To make the manuals use "make unzipsman" after UnZip is made.'
	@echo '  See the files INSTALL and unzip.txt for more information.'
	@echo ''

list:
	@echo ''
	@echo\
 'Type "make <system>", where <system> is one of the following:'
	@echo ''
	@echo  "	$(SYSTEMG1)"
	@echo  "	$(SYSTEMG2)"
	@echo ''
	@echo  "	$(SYSTEMS1)"
	@echo  "	$(SYSTEMS2)"
	@echo  "	$(SYSTEMS3)"
	@echo  "	$(SYSTEMS4)"
	@echo  "	$(SYSTEMS5)"
	@echo  "	$(SYSTEMS6)"
	@echo  "	$(SYSTEMS7)"
	@echo  "	$(SYSTEMS8)"
	@echo  "	$(SYSTEMS9)"
#	@echo ''
#	@echo\
# 'Targets for related utilities (ZipInfo and fUnZip) include:'
#	@echo ''
#	@echo  "	$(SYS_UTIL1)"
#	@echo  "	$(SYS_UTIL2)"
	@echo ''
	@echo\
 'For further (very useful) information, please read the comments in Makefile.'
	@echo ''

generic_msg:
	@echo ''
	@echo\
 '  Attempting "make generic" now.  If this fails for some reason, type'
	@echo\
 '  "make help" and/or "make list" for suggestions.'
	@echo ''


###############################################
# BASIC COMPILE INSTRUCTIONS AND DEPENDENCIES #
###############################################

# this is for GNU make; comment out and notify zip-bugs if it causes errors
.SUFFIXES:	.c .o .obj .pic.o

# yes, we should be able to use the $O macro to combine these two, but it
# fails on some brain-damaged makes (e.g., AIX's)...no big deal
.c.o:
	$(CC) -c $(CF) $*.c

.c.obj:
	$(CC) -c $(CF) $*.c

.c.pic.o:
	$(CC) -c $(CF) -o $@ $*.c

# this doesn't work...directories are always a pain with implicit rules
#.1.txt:		man/$<
#	nroff -Tman -man $< | col -b | uniq | \
#	 sed 's/Sun Release ..../Info-ZIP        /' > $@


# these rules may be specific to Linux (or at least the GNU groff package)
# and are really intended only for the authors' use in creating non-Unix
# documentation files (which are provided with both source and binary
# distributions).  We should probably add a ".1.txt" rule for more generic
# systems...

funzip.txt:	man/funzip.1
	nroff -Tascii -man man/funzip.1 | col -bx | uniq | expand > $@

unzip.txt:	man/unzip.1
	nroff -Tascii -man man/unzip.1 | col -bx | uniq | expand > $@

unzipsfx.txt:	man/unzipsfx.1
	nroff -Tascii -man man/unzipsfx.1 | col -bx | uniq | expand > $@

zipgrep.txt:	man/zipgrep.1
	nroff -Tascii -man man/zipgrep.1 | col -bx | uniq | expand > $@

zipinfo.txt:	man/zipinfo.1
	nroff -Tascii -man man/zipinfo.1 | col -bx | uniq | expand > $@


all:		generic_msg generic
unzips:		$(UNZIPS)
objs:		$(OBJS)
objsdll:	$(OBJSDLL)
docs:		$(DOCS)
unzipsman:	unzips docs
unzipsdocs:	unzips docs


# EDIT HERE FOR PARALLEL MAKES on Sequent (and others?)--screws up MS-DOS
# make utilities if default:  change "unzip$E:" to "unzip$E:&"

unzip$E:	$(OBJS) $(LIBBZ2) \
                 $(LIB_AES_WG) $(LIB_LZMA)      # add `&' for parallel makes
	$(LD) $(LF) $(LOBJS) $(LF2)

unzipsfx$E:	$(OBJX) $(LIBBZ2) \
                 $(LIB_AES_WG) $(LIB_LZMA)      # add `&' for parallel makes
	$(LD) $(SL) $(LOBJX) $(SL2)

funzip$E:	$(OBJF) $(LIBBZ2) \
                 $(LIB_AES_WG) $(LIB_LZMA)      # add `&' for parallel makes
	$(LD) $(FL) $(OBJF) $(FL2)

zipinfo$E:	unzip$E $(LIB_AES_WG)           # `&' is pointless here...
	@echo\
 '  This is a Unix-specific target.  ZipInfo is not enabled in some MS-DOS'
	@echo\
 '  versions of UnZip; if it is in yours, copy unzip.exe to zipinfo.exe'
	@echo\
 '  or else invoke as "unzip -Z" (in a batch file, for example).'
	$(LN) unzip$E zipinfo$E


# AES object library.

libaes.a : $(OBJAES)
	-@$(RM) libaes.a
	$(AR) cq libaes.a $(OBJAES)
	-$(RANLIB) libaes.a

aescrypt$O: aes_wg/aescrypt.c
	$(CC) -c $(CF) aes_wg/aescrypt.c

aeskey$O: aes_wg/aeskey.c
	$(CC) -c $(CF) aes_wg/aeskey.c

aestab$O: aes_wg/aestab.c
	$(CC) -c $(CF) aes_wg/aestab.c

fileenc$O: aes_wg/fileenc.c
	$(CC) -c $(CF) aes_wg/fileenc.c

hmac$O: aes_wg/hmac.c
	$(CC) -c $(CF) aes_wg/hmac.c

prng$O: aes_wg/prng.c
	$(CC) -c $(CF) aes_wg/prng.c

pwd2key$O: aes_wg/pwd2key.c
	$(CC) -c $(CF) aes_wg/pwd2key.c

sha1$O: aes_wg/sha1.c
	$(CC) -c $(CF) aes_wg/sha1.c


# LZMA object library.

liblzma.a : $(OBJLZMA)
	-@$(RM) liblzma.a
	$(AR) cq liblzma.a $(OBJLZMA)
	-$(RANLIB) liblzma.a

7zFile$O: lzma/7zFile.c
	$(CC) -c $(CF) lzma/7zFile.c

Alloc$O: lzma/Alloc.c
	$(CC) -c $(CF) lzma/Alloc.c

LzFind$O: lzma/LzFind.c
	$(CC) -c $(CF) lzma/LzFind.c

LzmaDec$O: lzma/LzmaDec.c
	$(CC) -c $(CF) lzma/LzmaDec.c


# when the optional bzip2 support is provided (as recommended) by sources
# in the 'bzip2' subdirectory, create/update the library:
$(IZ_OUR_BZIP2_DIR)/libbz2.a:
	@echo 'Building/updating bzip2 object library...'
	( cd $(IZ_OUR_BZIP2_DIR) ; $(MAKE) -f Makebz2.iz CC="$(CC_BZ)"\
	 CFLAGS="$(CFLAGS_BZ)" RM="rm -f" )


crc32$O:	crc32.c $(UNZIP_H) zip.h crc32.h
crypt$O:	crypt.c $(UNZIP_H) zip.h crypt.h crc32.h ttyio.h
envargs$O:	envargs.c $(UNZIP_H)
explode$O:	explode.c $(UNZIP_H)
extract$O:	extract.c $(UNZIP_H) crc32.h crypt.h
fileio$O:	fileio.c $(UNZIP_H) crc32.h crypt.h ttyio.h ebcdic.h
funzip$O:	funzip.c $(UNZIP_H) crc32.h crypt.h ttyio.h
globals$O:	globals.c $(UNZIP_H)
inflate$O:	inflate.c inflate.h $(UNZIP_H)
list$O:		list.c $(UNZIP_H)
match$O:	match.c $(UNZIP_H)
process$O:	process.c $(UNZIP_H) crc32.h
ttyio$O:	ttyio.c $(UNZIP_H) zip.h crypt.h ttyio.h
ubz2err$O:	ubz2err.c $(UNZIP_H)
unreduce$O:	unreduce.c $(UNZIP_H)
unshrink$O:	unshrink.c $(UNZIP_H)
unzip$O:	unzip.c $(UNZIP_H) crypt.h unzvers.h consts.h
zipinfo$O:	zipinfo.c $(UNZIP_H)

$(OBJAES):	$(AES_H)
$(OBJLZMA):	$(LZMA_H)

# unzipsfx compilation section
unzipsfx$O:	unzip.c $(UNZIP_H) crypt.h unzvers.h consts.h
	$(CC) -c $(CF) -DSFX -o $@ unzip.c

crc32_$O:	crc32.c $(UNZIP_H) zip.h crc32.h
	$(CC) -c $(CF) -DSFX -o $@ crc32.c

crypt_$O:	crypt.c $(UNZIP_H) zip.h crypt.h crc32.h ttyio.h
	$(CC) -c $(CF) -DSFX -o $@ crypt.c

extract_$O:	extract.c $(UNZIP_H) crc32.h crypt.h
	$(CC) -c $(CF) -DSFX -o $@ extract.c

fileio_$O:	fileio.c $(UNZIP_H) crc32.h crypt.h ttyio.h ebcdic.h
	$(CC) -c $(CF) -DSFX -o $@ fileio.c

globals_$O:	globals.c $(UNZIP_H)
	$(CC) -c $(CF) -DSFX -o $@ globals.c

inflate_$O:	inflate.c inflate.h $(UNZIP_H) crypt.h
	$(CC) -c $(CF) -DSFX -o $@ inflate.c

match_$O:	match.c $(UNZIP_H)
	$(CC) -c $(CF) -DSFX -o $@ match.c

process_$O:	process.c $(UNZIP_H) crc32.h
	$(CC) -c $(CF) -DSFX -o $@ process.c

ttyio_$O:	ttyio.c $(UNZIP_H) zip.h crypt.h ttyio.h
	$(CC) -c $(CF) -DSFX -o $@ ttyio.c

ubz2err_$O:	ubz2err.c $(UNZIP_H)
	$(CC) -c $(CF) -DSFX -o $@ ubz2err.c


# funzip compilation section
cryptf$O:	crypt.c $(UNZIP_H) zip.h crypt.h crc32.h ttyio.h
	$(CC) -c $(CF) -DFUNZIP -o $@ crypt.c

globalsf$O:	globals.c $(UNZIP_H)
	$(CC) -c $(CF) -DFUNZIP -o $@ globals.c

inflatef$O:	inflate.c inflate.h $(UNZIP_H) crypt.h
	$(CC) -c $(CF) -DFUNZIP -o $@ inflate.c

ttyiof$O:	ttyio.c $(UNZIP_H) zip.h crypt.h ttyio.h
	$(CC) -c $(CF) -DFUNZIP -o $@ ttyio.c


# optional assembler replacements
crc_i86$O:	msdos/crc_i86.asm				# 16bit only
	$(AS) $(AF) msdos/crc_i86.asm $(ASEOL)

crc_gcc$O:	crc_i386.S $(ACONF_DEP)				# 32bit, GNU AS
	$(AS) $(AF) -x assembler-with-cpp -c -o $@ crc_i386.S

crc_gcc.pic.o:	crc_i386.S $(ACONF_DEP)				# 32bit, GNU AS
	$(AS) $(AF) -x assembler-with-cpp -c -o $@ crc_i386.S

crc_sysv$O:	crc_i386.S $(ACONF_DEP)				# 32bit, SysV AS
	$(CC) -E $(AF) crc_i386.S > crc_i386s.s
	$(AS) -o $@ crc_i386s.s
	$(RM) crc_i386s.s

msdos$O:	msdos/msdos.c $(UNZIP_H) unzvers.h		# DOS only
	$(CC) -c $(CF) msdos/msdos.c

msdos_$O:	msdos/msdos.c $(UNZIP_H)			# DOS unzipsfx
	-$(CP) msdos/msdos.c msdos_.c > nul
	$(CC) -c $(CF) -DSFX msdos_.c
	$(RM) msdos_.c

#os2$O:		os2/os2.c $(UNZIP_H)				# OS/2 only
#	$(CC) -c $(CF) os2/os2.c

unix$O:		unix/unix.c $(UNZIP_H) unzvers.h		# Unix only
	$(CC) -c $(CF) unix/unix.c

unix_$O:	unix/unix.c $(UNZIP_H)				# Unix unzipsfx
	$(CC) -c $(CF) -DSFX -o $@ unix/unix.c

unix.pic.o:	unix/unix.c $(UNZIP_H) unzvers.h		# Unix shlib
	$(CC) -c $(CF) -o $@ unix/unix.c


unix_make:
#	@echo\
# '(Ignore any errors from `make'"' due to the following command; it's harmless.)"
	-@2>&1 $(LN) unix/Makefile . > /dev/null || echo > /dev/null

# this really only works for Unix targets, unless E and O specified on cmd line
clean:
	@echo ''
	@echo '         This is a Unix-specific target.  (Just so you know.)'
	@echo ''
	-( cd $(IZ_OUR_BZIP2_DIR); $(MAKE) -f Makebz2.iz RM="rm -f" clean )
	rm -f $(UNZIPS) $(OBJS) $(OBJF) $(OBJX) api$O apihelp$O crc_gcc$O \
	  crc_sysv$O unzipstb$O crypt_.c extract_.c globals_.c inflate_.c \
	  ttyio_.c crc_i386s.s msdos_.c process_.c unix_.c unzipsfx.c
	rm -f flags
	rm -rf ./$(PKGDIR)

# Package generation interface (by J.Bush).  Originally tested under Sun
# Solaris 2.x.  Other SVr4s may be very similar and could possibly use this.
# Note:  expects version info to be stored in VERSION macro variable.
# See "README" under ./unix/Packaging
#
svr4package:	unzips
	@echo 'Creating SVR4 package for Unix ...'
	-@rm -rf ./$(PKGDIR) ./$(PKGDIR)_`uname -p`.pkg
	-@sed -e "s/.VERSION./$(VERSION)/g" \
	      -e "s/.PSTAMP./$(LOGNAME)_`date | tr  ' ' '_'`/g" \
	      -e "s/.ARCH./Solaris_`uname -rp | tr ' ' ','`/g" \
	      ./unix/Packaging/pkginfo.in > ./unix/Packaging/pkginfo
	-@sed -e "s/.ARCH./`uname -p`/g" \
	      ./unix/Packaging/preinstall.in > ./unix/Packaging/preinstall
	/usr/bin/pkgmk -d . -b . -r . -f ./unix/Packaging/prototype $(PKGDIR)
	/usr/bin/pkgtrans -o -s . $(PKGDIR)_`uname -p`.pkg $(PKGDIR)
	@echo ''
	@echo "To install, copy $(PKGDIR)_`uname -p`.pkg to the target system, and"
	@echo "issue the command (as root):  pkgadd -d $(PKGDIR)_`uname -p`.pkg"
	@echo ''

install:	$(MANS)
	-$(INSTALL_D) $(BINDIR)
	$(INSTALL_PROGRAM) $(UNZIPS) $(BINDIR)
	$(INSTALL) unix/zipgrep $(BINDIR)
	$(RM) $(BINDIR)/zipinfo$E
	$(LN) $(BINDIR)/unzip$E $(BINDIR)/zipinfo$E
	-$(INSTALL_D) $(MANDIR)
	$(INSTALL) man/funzip.1 $(MANDIR)/funzip.$(manext)
	$(INSTALL) man/unzip.1 $(MANDIR)/unzip.$(manext)
	$(INSTALL) man/unzipsfx.1 $(MANDIR)/unzipsfx.$(manext)
	$(INSTALL) man/zipgrep.1 $(MANDIR)/zipgrep.$(manext)
	$(INSTALL) man/zipinfo.1 $(MANDIR)/zipinfo.$(manext)
	$(CHMOD) $(BINPERMS) $(INSTALLEDBIN)
	$(CHMOD) $(MANPERMS) $(INSTALLEDMAN)

uninstall:
	$(RM) $(INSTALLEDBIN) $(INSTALLEDMAN)

flags:  unix/configure
	sh unix/configure "AES_WG=${AES_WG}" \
         "CC=${CC}" "CFLAGS=${CF_NOOPT}" \
         "IZ_BZIP2=${IZ_BZIP2}" "IZ_ZLIB=${IZ_ZLIB}" \
         "LZMA=${LZMA}"


# the test zipfile
TESTZIP = testmake.zip

# test some basic features of the build
check:		test

test:
	sh unix/test_unzip.sh $(TESTZIP)


# Create a new testmake.zip.
#
# This target is intended for use by UnZip developers, not by normal
# users.  The method used relies on an existing testmake.zip file to
# provide "notes", which historically has non-UNIX line endings.
#
# Note that this is typically an iterative process, because the test
# archive includes an "unzip -Z" report on itself, which often results
# in mismatches on date-time and file size data.  If the results don't
# converge within a few iterations, then it may help to wait a minute (to
# get a different date-time), or to replace the current testmake.zip with
# the original (or some other old version).
#
# While crude, the method used here does try to save the original
# testmake.zip file as testmake.zip_orig, which is deleted only if the
# "diff" succeeds, which normally allows a manual restoration to the
# original state, if success remains elusive.

testmake_zip:
	if test ! -f testmake.zip_orig ; then \
	    cp -p testmake.zip testmake.zip_orig ; \
	fi
	@mkdir testmake
	@( cd testmake ; \
	../unzip ../testmake.zip > /dev/null ; \
	touch testmake.zipinfo ; \
	$(ZIP) testmake.zip notes testmake.zipinfo > /dev/null ; \
	../unzip -Z testmake.zip > testmake.zipinfo ; \
	$(ZIP) testmake.zip notes testmake.zipinfo > /dev/null ; \
	../unzip -Z testmake.zip > testmake.zipinfo_new ; \
	mv testmake.zip ../testmake.zip )
	@if diff testmake/testmake.zipinfo \
	 testmake/testmake.zipinfo_new 2> /dev/null ; then \
	    echo '' ; echo "   It's a miracle!" ; echo '' ;\
	    rm testmake.zip_orig ; \
	else \
	    echo '' ; echo '   Try again?' ; echo '' ; \
	fi
	@rm -r testmake


################################
# INDIVIDUAL MACHINE MAKERULES #
################################

#----------------------------------------------------------------------------
#  Generic targets using the configure script to determine configuration.
#----------------------------------------------------------------------------

# Well, try MAKE and see.  By now everyone may be happy.  10/28/04 EG
generic:	flags	   # now try autoconfigure first
	eval $(MAKE) $(MAKEF) unzips ACONF_DEP=flags `cat flags`
#	make $(MAKEF) unzips CF="${CF} `cat flags`"

# extensions to perform SVR4 package-creation after compilation
generic_pkg:	generic svr4package

#----------------------------------------------------------------------------
#  Old static generic targets (can't assume make utility groks "$(MAKE)")
#----------------------------------------------------------------------------

generic1:	unzips	   # first try if unknown

generic2:	unix_make  # second try if unknown:  hope make is called "make"
	make $(MAKEF) unzips CF="$(CF) -DBSD"

generic3:	unix_make  # third try if unknown:  hope make is called "make"
	make $(MAKEF) unzips CF="$(CF) -DSYSV"

# Generic build including bzip2 decompression support for unzip.
# Requires presence of the bzip2 sources in subdirectory bzip2.

generic_bz2:	unix_make
	@echo\
 'This target assumes bzip2 sources are available in subfolder bzip2/.'
	$(MAKE) $(MAKEF) unzips D_USE_BZ2="-DUSE_BZIP2"\
	 L_BZ2="-lbz2" LIBBZ2="$(IZ_OUR_BZIP2_DIR)/libbz2.a" \
	 CC_BZ="$(CC)" CFLAGS_BZ="$(CFLAGS)"

# Generic unzip and funzip target using either shared or static zlib for
# inflate rather than the original UnZip version.  (libz was libgz prior
# to 0.94)  Need to figure out how to force unzipsfx to use static libz.

generic_zlib:	unix_make
	@echo\
 'This target assumes zlib (libz.a or libz.so.*) is already installed.'
	$(MAKE) unzip funzip CF="$(CF) -DUSE_ZLIB" LF2="-lz $(LF2)"

# Generic GNU C shared library.  This is an example of how to compile UnZip as
# a shared library.  (Doing so as a static library would be similar.)  See also
# the linux_shlib target.

generic_shlib:	unix_make
	@echo\
 'This target requires GNU C.  When done, do "setenv LD_LIBRARY_PATH `pwd`"'
	@echo\
 'or similar in order to test the shared library in place (with ./unzip_shlib ,'
	@echo\
 'which is UnZip linked with the DLL).  This target is an example only.'
	@echo ''
	$(MAKE) objsdll CC=gcc CFLAGS="-O3 -Wall -fPIC -DDLL"
	gcc -shared -Wl,-soname,libunzip.so.0 -o libunzip.so.0.4 $(OBJSDLL)
	$(RM) libunzip.so.0 libunzip.so
	$(LN) -s libunzip.so.0.4 libunzip.so.0
	$(LN) -s libunzip.so.0 libunzip.so
	gcc -c -O unzipstb.c
	gcc -o unzip_shlib unzipstb.o -L. -lunzip

#----------------------------------------------------------------------------
#  "Autoconfig" group, aliases for the generic targets using configure:
#----------------------------------------------------------------------------

# Solaris:  generic, plus generation of installable package.
solaris_pkg:	generic_pkg

#----------------------------------------------------------------------------
#  "Normal" group (BSD vs. SysV may be set in unzip.h via predefined macros):
#----------------------------------------------------------------------------

386i:		unzips	# sun386i, SunOS 4.0.2
#3Bx:		unzips	# AT&T 3B2/1000-80; should work on any WE32XXX machine
#aix_rt:		unzips	# IBM RT 6150 under AIX 2.2.1
bull:		unzips	# Bull DPX/2, BOS 2.00.45 (doesn't require -Xk switch)
convex:		unzips	# Convex C-120 and C-210 (-O is enough; -ext is default)
cray:		unzips	# Cray-2 and Y-MP, using default (possibly old) compiler
dec:		unzips	# DEC 5820 (MIPS RISC), test version of Ultrix v4.0
encore:		unzips	# Multimax
eta:		unzips	# ETA-10P*, hybrid SysV with BSD 4.3 enhancements
gould:		unzips	# Gould PN9000 running UTX/32 2.1Bu01
hp:		unzips	# HP 9000 series (68020), 4.3BSD or HP-UX A.B3.10 Ver D
hpux:		unzips	# (to match zip's makefile entry)
mips:		unzips	# MIPS M120-5(?), SysV.3 [error in sys/param.h file?]
next10:		unzips	# NeXT (generic; use next2x or next3x for better opt.)
osf1:		unzips	# DECstation, including Alpha-based; DEC OSF/1 v1.x
pyr_:		unzips	# [failsafe target for pyramid target below]
pyr_ucb:	unzips	# Pyramids running BSD universe by default (see below)
realix:		unzips	# Modcomp Real/IX (SysV.3); note "gcc" = GLS C, not GNU
sco:		unzips	# Xenix/386 (tested on 2.3.1); SCO Unix 3.2.0.
sgi:		unzips	# Silicon Graphics; Irix 3.3.2, 4.0.x, 5.2, etc.
stellar:	unzips	# gs-2000
sun:		unzips	# old target; no good with solaris...use "sunos" now
sunos:		unzips	# no good with SunOS 3.x...use "sunos3" or "sunos4" now
sunos4:		unzips	# Sun 3, 4; SunOS 4.x (SOME SYSTEMS ARE SYSTEM V!)
tahoe:		unzips	# tahoe (CCI Power6/32), 4.3BSD
ultrix:		unzips	# VAXen, DEC 58x0 (MIPS guts), DECstation 2100; v4.x
vax:		unzips	# general-purpose VAX target (not counting VMS)

#----------------------------------------------------------------------------
#  BSD group (for timezone structs [struct timeb]):
#----------------------------------------------------------------------------

bsd:		_bsd	# generic BSD (BSD 4.2 & Ultrix handled in unzip.h)

_bsd:		unix_make
	$(MAKE) unzips CF="$(CF) -DBSD"

#----------------------------------------------------------------------------
#  SysV group (for extern long timezone and ioctl.h instead of sgtty.h):
#----------------------------------------------------------------------------

aix_rt:		_sysv	# IBM RT 6150 under AIX 2.2.1
aviion:		_sysv	# Data General AViiONs, DG/UX 4.3x
pyr_att:	_sysv	# Pyramids running AT&T (SysV) universe by default
stardent:	_sysv	# Stardent ...
sysv:		_sysv	# generic System V Unix (Xenix handled in unzip.h)
xos:		_sysv	# Olivetti LSX-3005..3045, X/OS 2.3 and 2.4

_sysv:		unix_make
	$(MAKE) unzips CF="$(CF) -DSYSV"

# extension to perform SVR4 package-creation after compilation
_sysvp:		_sysv svr4package

#----------------------------------------------------------------------------
#  Version 7 group (old/obsolescent):
#----------------------------------------------------------------------------

pixel:		_v7	# Pixel 80, 100 (68000-based, V7/mostly BSD4.1 compat.)
v7:		_v7	# generic Unix Version 7 box (prob. only Pixel...)

_v7:
	make $(MAKEF) unzips \
	 CF="$(CF) -DV7 -DNO_PARAM_H -DSHORT_NAMES -DBSD -DZMEM -DNO_LCHOWN -DNO_LCHMOD"

#----------------------------------------------------------------------------
#  "Unique" group (require non-standard options):
#----------------------------------------------------------------------------

# AT&T 3B2/1000-80; should work on any WE32XXX machine
3Bx:		unix_make
	$(MAKE) unzips CF="$(CF) -DCBREAK=2"

# AT&T 7300 (M68000/SysV.3) (add -DSYSV? -DNO_LIMITS?)
7300:		unix_make
	$(MAKE) unzips CF="$(CF) -DNO_DIR -DNO_MKDIR -DNO_STRNICMP -DNO_UID_GID -DNO_FCHMOD -DNO_LCHOWN -DNO_LCHMOD -DCBREAK=2"

7300_gcc:	unix_make
	$(MAKE) unzips CC=gcc LD=gcc LF2="" CFLAGS="-O2" \
	 LOC="-DNO_DIR -DNO_MKDIR -DNO_STDLIB_H -DNO_STRNICMP -DNO_UID_GID -DNO_FCHMOD -DNO_LCHOWN -DNO_LCHMOD -DCBREAK=2 $(LOC)"
	$(STRIP) $(UNZIPS)

# IBM AIX 3.x on an RS/6000:  see rs6000 target below
aix:		rs6000

# Amdahl (IBMish) mainframe, UTS (SysV) 1.2.4, 2.0.1, 3.x
amdahl:		unix_make
	$(MAKE) unzips CF="$(CF) -DSYSV -DNO_UID_GID -DNO_LCHOWN -DNO_LCHMOD"

# Amdahl UTS 2.1.4 with "extended file types" filesystem (aarrrggghhhh...)
amdahl_eft:	unix_make
	$(MAKE) unzips CF="$(CF) -eft -DSYSV -DNO_UID_GID -DNO_LCHOWN -DNO_LCHMOD"

# Apollo Domain/OS machines (added -D...SOURCE options) [Gordon Fox, 960810]
apollo:		unix_make
	$(MAKE) unzips CF="$(CF) -D_INCLUDE_BSD_SOURCE -D_INCLUDE_XOPEN_SOURCE -DNO_LCHOWN -DNO_LCHMOD"

# BSDI BSD/OS on 386 platform, using the assembler replacement for crc32.c
bsdi:		unix_make
	@echo 'NOTE:  use bsdi_noasm target for non-Intel BSD/OS compiles.'
	$(MAKE) unzips CC=gcc2 LD=shlicc2 AS=gcc2\
	 CFLAGS="-O3 -Wall -DASM_CRC -DBSD" CRCA_O=crc_gcc$O

# BSDI BSD/OS
bsdi_noasm:	unix_make
#	@echo 'NOTE:  use bsd target for non-Intel BSD/OS compiles.'
	$(MAKE) unzips CC=gcc2 LD=shlicc2 AS=gcc2\
	 CFLAGS="-O3 -Wall -DBSD"

# Coherent 3.x/4.x, Mark Williams C.  ``For Coherent's CC, it needs either
# -T0 or -T150000 (or bigger) added to the CFLAGS, otherwise the compiler
# runs out of memory and dies in zipinfo.c.'' [Fred "Fredex" Smith, 940719]
coherent:	unix_make
	$(MAKE) unzips CFLAGS="$(CFLAGS) -T0 -DNO_LCHOWN -DNO_LCHMOD"

# Cray-2, Y-MP or C90, running Unicos 5.x to 8.x (SysV + BSD enhancements)
# and Standard (ANSI) C compiler 3.0 or later.
cray_opt:	unix_make
	$(MAKE) unzips CFLAGS="$(CFLAGS) -h scalar3 -h vector3 -DNO_LCHOWN -DNO_LCHMOD"

# The unzip41 build on a Cyber 910/SGI running Irix v3.3.3 was successful
# with the following change to Makefile:
cyber_sgi:	unix_make
	$(MAKE) unzips CFLAGS="$(CFLAGS) -I/usr/include/bsd -DNO_LCHOWN -DNO_LCHMOD"\
	 LF="-lbsd $(LF)" SL="-lbsd $(SL)"

# The Cygwin environment on a Win32 system, treated as an UNIX emulator.
# This port does not offer full access to the Windows file system.
# Info-ZIP recommends using "win32/Makefile.gcc" instead.
cygwin:		unix_make
	$(MAKE) unzips CC=gcc LD=gcc AS=gcc\
	 CFLAGS="-O3 -DASM_CRC -DNO_LCHOWN -DNO_LCHMOD"\
	 AF="-Di386 $(AF)" CRCA_O=crc_gcc$O\
	 E=".exe" CP="cp" LN="ln -s"

# 680x0, DIAB dnix 5.2/5.3 (a Swedish System V clone)
#
# Options for the dnix cc:
#  -X7 = cc is strict ANSI C
#  -X9 = warnings if a function is used without a declaration
#
dnix:		unix_make
	$(MAKE) unzips CFLAGS="$(CFLAGS) -X7 -X9 -DDNIX"

# FreeBSD on Intel:
freebsd:		unix_make
	@echo 'NOTE:  use bsd target for non-Intel FreeBSD compiles (if any).'
	$(MAKE) unzips CC=gcc LD=gcc AS=gcc\
	 CFLAGS="-O3 -Wall -DASM_CRC -DBSD"\
	 AF="-Di386 $(AF)" CRCA_O=crc_gcc$O

# Generic BSDish Unix gcc.  ``The -O3 only works with later versions of gcc;
# you may have to use -O2 or -O for earlier versions.  I have no idea why
# -s causes this bug in gcc.''  [Bug:  "nm: unzip: no name list", "collect:
# /usr/bin/nm returned 1 exit status".]  If you don't have strip, don't
# worry about it (it just makes the executable smaller and can be replaced
# with "echo" instead).
#
gcc:		unix_make
	$(MAKE) unzips CC=gcc LD=gcc CFLAGS="-O3" LF2=""
	$(STRIP) $(UNZIPS)

# Heurikon HK68 (68010), UniPlus+ System V 5.0, Green Hills C-68000
hk68:		unix_make
	$(MAKE) unzips CC="gcc" LD="gcc"\
	 LF="-n $(LF)" SL="-n $(SL)" FL="-n $(FL)"\
	 CFLAGS="-ga -X138 -Dlocaltime=localti -Dtimezone=timezon"

# ISC Unix on 386 platform
isc:		unix_make
	$(MAKE) unzips LF2="-lc_s $(LF2)" CRCA_O=crc_sysv$O \
	 CFLAGS="-O" LOC="-DASM_CRC -DSYSV -DNO_UID_GID -DNEED_PTEM -DNO_LCHOWN -DNO_LCHMOD $(LOC)" \
	 AF="-DNO_UNDERLINE -Djecxz=jcxz -DALIGNMENT='.align 16' $(AF)"

isc_gcc:	unix_make
	$(MAKE) unzips AS=gcc CC=gcc LD=gcc CRCA_O=crc_gcc$O \
	 LF="-shlib $(LF)" SL="-shlib $(SL)" FL="-shlib $(FL)" LF2="" \
	 CFLAGS="-O3" LOC="-DSYSV -DASM_CRC -DNO_UID_GID -DNEED_PTEM -DNO_LCHOWN -DNO_LCHMOD $(LOC)" \
	 AF="-DNO_UNDERLINE -Djecxz=jcxz -DALIGNMENT='.align 16' $(AF)"
	$(STRIP) $(UNZIPS)

# "ISI machine (68025 CPU)" (based on e-mail from Rob White <rsw@tfs.com>;
# no further information).  May also need DIRENT defined.
isi:		unix_make
	$(MAKE) unzips CF="$(CF) -DDECLARE_ERRNO -DNO_LCHOWN -DNO_LCHMOD"

# Linux on 386 platform, using the assembler replacement for crc32.c. (-O4 and
# -fno-strength-reduce have virtually no effect beyond -O3.  Add "-m486
# -malign-functions=2 -malign-jumps=2 -malign-loops=2" for Pentium [Pro]
# systems.)
linux:		unix_make
	@echo 'NOTE:  use linux_noasm target for non-Intel Linux compiles.'
	$(MAKE) unzips CC=gcc LD=gcc AS=gcc\
	 CFLAGS="-O3 -Wall -DASM_CRC"\
	 AF="-Di386 $(AF)" CRCA_O=crc_gcc$O
# GRR:  this echo is pointless; if user gets this far, no difference to install
#	@echo 'Be sure to use the install_asm target rather than the install target'

linux_asm:	linux

# Linux (Posix, approximately SysV):  virtually any version since before 0.96,
# for any platform.  Change "-O" to "-O3" or whatever, as desired...
linux_noasm:	unix_make
	$(MAKE) unzips CC=gcc LD=gcc CFLAGS="-O -Wall"

# Linux with lcc compiler:  __inline__ (stat.h) not recognized, and must edit
# /usr/include/gnu/types.h to get rid of "long long" if __LCC__ defined.  -O3
# (or -O2 or -O) is ignored.  [GRR 960828: test target only]
#
linux_lcc:	unix_make
	$(MAKE) unzips CC=lcc LD=lcc CFLAGS="-O3 -Wall -D__inline__= "

# Linux host with go32 (djgpp) cross-compiler (go32crs.tgz) for 32-bit DOS.
linux_dos:	unix_make
	$(MAKE) unzips CC=go32gcc LD=go32gcc M=msdos OSDEP_H="msdos/doscfg.h" \
	 CFLAGS="-O2 -Wall"
#	go32-strip unzip
#	Due to limitations of the cross-compiling package, this has to be
#	done manually:
	@echo "Copy $(UNZIPS) to your DOS partition and use coff2exe."

# Linux ELF shared library (ooo, it's so easy).  This is a test target for
# now, and it only makes the UnZip/ZipInfo stuff (not fUnZip or UnZipSFX).
# The version number may eventually change to match the UnZip version.  Or
# not.  Whatever.  Also do "setenv LD_LIBRARY_PATH `pwd`" or similar to test
# the DLL in place (with unzip_shlib, which is UnZip linked with the shared
# library).
#
linux_shlib:	unix_make
	$(MAKE) objsdll CC=gcc CFLAGS="-O3 -Wall -fPIC"\
	 LOC="-DDLL -DASM_CRC $(LOC)"\
	 AS=gcc AF="-fPIC -Di386 $(AF)" CRCA_O=crc_gcc$O
	gcc -shared -Wl,-soname,libunzip.so.0 -o libunzip.so.0.4 $(OBJSDLL)\
	 crc_gcc.pic.o
	ln -sf libunzip.so.0.4 libunzip.so.0
	ln -sf libunzip.so.0 libunzip.so
	gcc -c -O unzipstb.c
	gcc -o unzip_shlib unzipstb.o -L. -lunzip

# Linux ELF shared library, as above, but using inflate() from zlib (libz.so)
# instead of the original UnZip version.  (libz was libgz prior to 0.94)
linux_shlibz:	unix_make
	$(MAKE) objsdll CC=gcc AS=gcc AF="-fPIC -Di386 $(AF)" CRCA_O=crc_gcc$O\
	 CFLAGS="-O3 -Wall -fPIC" LOC="-DDLL -DUSE_ZLIB -DASM_CRC $(LOC)"
	gcc -shared -Wl,-soname,libunzip.so.0 -o libunzip.so.0.4 $(OBJSDLL)\
	 crc_gcc.pic.o
	ln -sf libunzip.so.0.4 libunzip.so.0
	gcc -c -O unzipstb.c
	gcc -o unzip unzipstb.o -L. -lunzip -lz

# LynxOS-x86 2.3.0 and newer, a real-time BSD-like OS; uses gcc.
lynx:		unix_make
	$(MAKE) unzips CC=gcc CF="$(CF) -DLynx -DLYNX -DBSD -DUNIX"

# Macintosh MacOS X (Unix-compatible enviroment), using standard compiler
macosx:	unix_make
	$(MAKE) unzips CFLAGS="-O3 -Wall -DBSD" LF2=""
	$(STRIP) $(UNZIPS)

# Macintosh MacOS X (Unix-compatible enviroment), using gcc
macosx_gcc:	unix_make
	$(MAKE) unzips CC=gcc CFLAGS="-O3 -Wall -DBSD" LF2=""
	$(STRIP) $(UNZIPS)

# Minix 1.5 PC for the 386.  Invoke as is to use default cc, or as "make
# minix CC=gcc" to use gcc.  Try "make linux" if you have a working termios.h.
minix:		unix_make
	$(MAKE) unzips CF="$(CF) -DMINIX -DSHORT_NAMES -DNO_LCHOWN -DNO_LCHMOD" CC=$(CC) LD=$(CC)

# MPE/iX, the Unix variant for HP 3000 systems.
mpeix:		unix_make
	$(MAKE) unzips CC=c89\
	 CF="$(CF) -DUNIX -D_POSIX_SOURCE -DHAVE_TERMIOS_H -DPASSWD_FROM_STDIN -DNO_PARAM_H -DNO_LCHOWN -DNO_LCHMOD"\
	 LF2=-lbsd CP=cp LN="ln -s"

# NeXT info.
next:
	@echo ''
	@echo\
 '  Please pick a specific NeXT target:  "make next10" will create a generic'
	@echo\
 '  NeXT executable; "make next2x" will create a smaller executable (for'
	@echo\
 '  NeXTstep 2.0 and higher); "make next3x" will create a small executable'
	@echo\
 '  with significantly better optimization (NeXTstep 3.0 and higher only);'
	@echo\
 '  "make nextfat" will create a fat, multi-architecture (NeXT plus Intel)'
	@echo\
 '  executable (NeXTstep 3.1 and higher only).'
	@echo ''

# 68030 BSD 4.3+Mach.  NeXT 2.x: make the executable smaller.
next2x:		unix_make
	$(MAKE) unzips LF2="-object -s"

# NeXT 3.x: as above, plus better optimization.
next3x:		unix_make
	$(MAKE) unzips CFLAGS="-O2" LF2="-object -s"

# NeXT 3.1+: make the executable fat (multi-architecture binary [MAB],
# for "black" [NeXT] and "white" [x86] hardware, so far).
nextfat:	unix_make
	$(MAKE) unzips CFLAGS="-O2 -arch i386 -arch m68k" \
	 LF2="-arch i386 -arch m68k -object -s"

# IBM OS/390 (formerly MVS) compiled under "OpenEdition" shell
os390:		unix_make
	set -x; \
	$(MAKE) $(MAKEF) unzips \
	 CC=c89 LD="\$$(CC) -Wl,EDIT=NO" \
	 CF="$(CF) -DSYSV -DUNIX -DOS390 -DEBCDIC -DNO_PARAM_H \
	 -DNO_LCHOWN -DNO_LCHMOD \
	 -D_ALL_SOURCE $(HOST_VERSINFO)" LF2=""

# Sequent Symmetry running Dynix/ptx (sort of SysV.3):  needs to link
# with libseq to get symlink().
ptx:		unix_make
	$(MAKE) unzips CF="$(CF) -DSYSV -DTERMIO -DPTX -DNO_LCHOWN -DNO_LCHMOD" LF2="$(LF2) -lseq"

# Pyramid 90X (probably all) under >= OSx4.1, either universe.  (This is an
# experimental target!  If it fails, use either pyr_ucb or pyr_att instead.)
# The make in the BSD half is too stupid to understand $(MAKE), sigh...
pyramid:	unix_make
	-make $(MAKEF) pyr_`universe`

# QNX/Neutrino is "special" because you don't have any native development
# tools yet.  Set ARCH to "x86", "ppcbe", "ppcle", "mipsbe", or "mipsle"
# to produce x86, PowerPC (big- or little-endian) and MIPS (big-
# or little-endian) using gcc. [cjh]
qnxnto:		unix_make
	@if [ "$(ARCH)" = "" ] ; then \
		echo "You didn't set ARCH; I'll assume you meant ARCH=x86..." ; \
		echo '' ; \
		$(MAKE) $(MAKEF) CC="qcc -Vgcc_ntox86" unzips ; \
	else \
		echo "Making unzip for $(ARCH)..." ; \
		echo '' ; \
		$(MAKE) $(MAKEF) CC="qcc -Vgcc_nto$(ARCH)" unzips ; \
	fi

# REGULUS:  68040-based, "real-time" SysV.3 mutant; uses gcc, with "REGULUS"
# predefined.
regulus:	unix_make
	$(MAKE) unzips CF="$(CF) -traditional -DSYSV -DNO_MKDIR -DNO_LCHOWN -DNO_LCHMOD"

# IBM RS/6000 under AIX 3.2
rs6000:		unix_make
	$(MAKE) unzips CF="$(CF) -DBSD -D_BSD -DUNIX -DNO_LCHMOD" LF2="-lbsd"

# SCO cross compile from Unix to DOS. Tested with Xenix/386 and OpenDeskTop.
# Should work with Xenix/286 as well. (davidsen)  Note that you *must* remove
# the Unix objects and executable before doing this!  (Piet Plomp:  gcc won't
# recognize the -M0 flag that forces 8086 code.)  (GRR:  may need to reduce
# stack to 0c00h if using 286/small-model code...?)
sco_dos:	unix_make
	$(MAKE) unzips CFLAGS="-O -dos -M0" M=msdos OSDEP_H="msdos/doscfg.h" \
	 LF="-dos -F 2000" LF2="-o unzip.exe" \
	 FL="-dos" FL2="-o funzip.exe" SL="-dos" SL2="-o unzipsfx.exe"

# SCO UNIX with shared libraries and no international support.  If you are
# not using a USA-style keyboard and display, you may want to remove -nointl
# to get support.  It adds quite a bit to the size of the executable.
sco_sl:		unix_make
	$(MAKE) unzips LF="$(LF) -nointl" LF2="$(LF2) -lc_s"\
	 SL="$(SL) -nointl" FL="$(FL) -nointl"

# SCO Xenix/286 2.2.3 or later with development system 2.2.1 or later
sco_x286:	unix_make
	$(MAKE) unzips CF="$(CF) -Mel2 -LARGE -DNO_MKDIR -DNO_LCHOWN -DNO_LCHMOD" \
	 LF="$(LF) -Mel2 -LARGE -lx" SL="$(SL) -Mel2 -LARGE" \
	 FL="$(FL) -Mel2 -LARGE"

# Sequent Symmetry with Dynix.  (386, but needs -DZMEM)
# This should also work on Balance but I can't test it just yet.
sequent:	unix_make
	$(MAKE) unzips CF="$(CF) -DBSD -DZMEM -DNO_LCHOWN -DNO_LCHMOD"

# Sun 2, 3, 4 running SunOS 3.x
sunos3:		unix_make
	$(MAKE) unzips CF="$(CF) -DNO_UID_GID -DUID_USHORT -DNO_LCHOWN -DNO_LCHMOD"

# Generic System V + GNU C
sysv_gcc:	unix_make
	$(MAKE) unzips CC=gcc LD=gcc CFLAGS="-O2 -DSYSV" LF2=""
	$(STRIP) $(UNZIPS)

# AT&T 6300+, System V.2 Unix:  run-time out-of-memory error if don't use -Ml;
# also compile-time error if work arrays dimensioned at HSIZE+2 (>32K)
sysv6300:	unix_make
	$(MAKE) unzips CF="$(CF) -Ml -DSYSV -DNO_LCHOWN -DNO_LCHMOD" LF="$(LF) -Ml"\
	 SL="$(SL) -Ml" FL="$(FL) -Ml"

# Texas Instruments System V.3 (running on HP 9000-1500)
ti_sysv:	unix_make
	$(MAKE) unzips CF="$(CF) -DSYSV -DNO_UID_GID -DUID_USHORT -DNO_LCHOWN -DNO_LCHMOD"

# SCO Xenix (Joe Foster 950508:  "unzip needs to be linked with -lx [for the
# opendir(), readdir(), telldir(), rewinddir(), and closedir() calls]")
xenix:		 unix_make
	$(MAKE) unzips LF2="$(LF2) -lx"

