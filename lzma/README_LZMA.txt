                        README_LZMA.txt
                        ---------------

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      Description
      -----------

   The Info-ZIP programs UnZip (version 6.1 and later) and Zip (version
3.1 and later) offer optional support for LZMA compression (method 14)
and PPMd compression (method 98).  The PKWARE, Inc. APPNOTE describes
the LZMA method as an Early Feature Specification, hence subject to
change.

      http://www.pkware.com/documents/casestudies/APPNOTE.TXT

   Our LZMA implementation uses public-domain code from the LZMA
Software Development Kit (SDK) provided by Igor Pavlov:

      http://www.7-zip.org/sdk.html

Only a small subset of the LZMA SDK is used by (and provided with) the
Info-ZIP programs, in an "lzma" subdirectory.  A small change was made
to the header file "lzma/LzFind.h" to accommodate name length
limitations on VMS systems.  Some files may include some indentation
changes.  Files whose names begin with a numeric character were changed
to begin with an alphabetic character, to accommodate some IBM operating
systems:

      7zVersion.h  ->  SzVersion.h

   Our PPMd implementation uses additional public-domain code from the
p7zip project:

      http://p7zip.sourceforge.net/
      http://sourceforge.net/projects/p7zip/

The PPMd-related files are:

   From the LZMA SDK:
      lzma/Ppmd.h

   From the p7zip (version 9.20.1) kit:
      lzma/Ppmd8.c
      lzma/Ppmd8.h
      lzma/Ppmd8Dec.c

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      Building UnZip and Zip with LZMA Compression Support
      ----------------------------------------------------

   The build instructions (in the file INSTALL, in the UnZip and Zip
source kits) describe how to build UnZip and Zip with LZMA compression.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      Acknowledgement
      ---------------

   We're grateful to Igor Pavlov for providing the LZMA and PPMd
compression code, and to Dmitry Shkarin for the p7zip material.  Any
problems involving LZMA or PPMd compression in Info-ZIP programs should
be reported to the Info-ZIP team, not to Mr. Pavlov or Mr. Shkarin. 
However, any questions on LZMA or PPMd compression algorithms, or
regarding the original LZMA SDK or PPMd code (except as we modified and
use it) should be addressed to the original authors.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      Document Revision History
      -------------------------

      2011-08-14  New.  LZMA SDK version 9.20.  (SMS)

      2011-12-24  Added PPMd from p7zip version 9.20.1.  (SMS)

      2011-12-24  Removed references to 7zFile.[ch], SzFile.[ch].  (SMS)
