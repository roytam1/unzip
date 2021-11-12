#!/bin/sh

#    UnZip test script.
#
#    $1 = test archive name.  Default: testmake.zip
#    $2 = program directory (relative).  Default: .
#
#    2011-08-05  SMS.  New.

test_archive=${1:-testmake.zip}
prod=${2:-.}

pass=0
fail=0

# Clean environment.

if test -n "${UNZIP}" ; then
    UNZIP='' ; export UNZIP
fi

if test -n "${UNZIPOPT}" ; then
    UNZIPOPT='' ; export UNZIPOPT
fi

if test -n "${ZIPINFO}" ; then
    ZIPINFO='' ; export ZIPINFO
fi

if test -n "${ZIPINFOOPT}" ; then
    ZIPINFOOPT='' ; export ZIPINFOOPT
fi

# Check for existence of expected programs.

program_list='funzip unzip unzipsfx'
for program in $program_list ; do
    if test -f "${prod}/${program}" ; then
        echo ">>> Found executable: ${program}"
    else
        echo ">>> CAN'T FIND EXECUTABLE: ${prod}/${program}"
    fi
done

# Check for existence of test archive.

if test -f "${test_archive}" ; then
    echo ">>> Found test archive: ${test_archive}"
else
    echo ">>> CAN'T FIND TEST ARCHIVE: ${test_archive}"
fi

# Error/exit handler.

dir_orig=` pwd `

trap 'cd "${dir_orig}" ;
if test -n "${tmp_dir}" -a -d "${tmp_dir}" ; then
    rm -r "${tmp_dir}"
fi' 0 2 3 6 15

# Create and move into a temporary test directory.

tmp_dir="test_dir_$$"
mkdir "${tmp_dir}"
cd "${tmp_dir}"

# Expected test archive member names.

member_1='notes'
member_2='testmake.zipinfo'

# Test simple UnZip extraction.

echo ''
echo '>>> UnZip extraction test...'

../${prod}/unzip -b "../${test_archive}" "${member_1}"

if test -f "${member_1}" -a ! -f "${member_2}" ; then
    echo ">>> Pass."
    pass=` expr $pass + 1 `
else
    echo ">>> Fail: Can't find (only) expected extracted file: ${member_1}"
    pwd ; ls -l
    fail=` expr $fail + 1 `
fi

# Test UnZip extraction with "-x" option.

echo ''
echo '>>> UnZip "-x" extraction test...'

../${prod}/unzip -bo "../${test_archive}" -x "${member_1}"

if test -f "${member_2}"; then
    echo ">>> Pass."
    pass=` expr $pass + 1 `
else
    echo ">>> Fail: Can't find expected extracted file: ${member_2}"
    fail=` expr $fail + 1 `
fi

# Test UnZip extraction with "-d dest_dir" option.

echo ''
echo '>>> UnZip "-d dest_dir" extraction test...'

if test -f "${member_1}" ; then

    ../${prod}/unzip -bo "../${test_archive}" -d dest_dir "${member_1}"

    if test -f "dest_dir/${member_1}"; then
        if diff "${member_1}" "dest_dir/${member_1}" ; then
            echo ">>> Pass."
            pass=` expr $pass + 1 `
        else
            echo ">>> Fail: Extracted file contents mismatch."
            fail=` expr $fail + 1 `
        fi
    else
        echo \
 ">>> Fail: Can't find expected extracted file: dest_dir/${member_1}"
        fail=` expr $fail + 1 `
    fi
else
    echo \
 ">>> Fail: The UnZip \"-d\" test relies on success in the UnZip \"-x\" test."
    fail=` expr $fail + 1 `
fi

# Test UnZip extraction with "-o" option.

echo ''
echo '>>> UnZip "-o" extraction test...'

../${prod}/unzip -bo "../${test_archive}" "${member_1}"

if test -f "${member_1}"; then
    echo ">>> Pass."
    pass=` expr $pass + 1 `
else
    echo ">>> Fail: Can't find expected extracted file: ${member_1}"
    fail=` expr $fail + 1 `
fi

# Test ZipInfo ("unzip -Z").

echo ''
echo '>>> ZipInfo ("unzip -Z") test...'

if test -f "${member_2}"; then
    (
      cd ..
      ${prod}/unzip -Z "${test_archive}" > "${tmp_dir}/testmake.unzip-Z"
    )
    if diff testmake.unzip-Z "${member_2}" ; then
        echo ">>> Pass."
        pass=` expr $pass + 1 `
    else
        echo ">>> Fail: ZipInfo output mismatch."
        cat <<EOD

>>> ###   ZipInfo output does not match the expected output.
>>> ###   (If the only difference is in the date-time values, then this may
>>> ###   be caused by a time-zone difference, which may not be important.)

EOD
        fail=` expr $fail + 1 `
    fi
else
    echo ">>> Fail: The ZipInfo test relies on success in the UnZip test."
    fail=` expr $fail + 1 `
fi

# Test FunZip extraction.

echo ''
echo '>>> FunZip extraction test...'
echo '>>>  (Expect a "zipfile has more than one entry" warning.)'

if test -f "${member_1}" ; then

    ../${prod}/funzip < "../${test_archive}" > "dest_dir/${member_1}_fun"

    if test -f "dest_dir/${member_1}_fun"; then
        if diff "${member_1}" "dest_dir/${member_1}_fun" ; then
            echo ">>> Pass."
            pass=` expr $pass + 1 `
        else
            echo ">>> Fail: Extracted file contents mismatch."
            fail=` expr $fail + 1 `
        fi
    else
        echo \
 ">>> Fail: Can't find expected extracted file: dest_dir/${member_1}_fun"
        fail=` expr $fail + 1 `
    fi
else
    echo ">>> Fail: The FunZip test relies on success in the UnZip test."
    fail=` expr $fail + 1 `
fi

# Test UnZipSFX.

echo ''
echo '>>> UnZipSFX test...'

if test -f "dest_dir/${member_1}" ; then

    rm ${member_1} ${member_2}
    cat ../${prod}/unzipsfx "../${test_archive}" > test_sfx
    chmod 0700 test_sfx
    ./test_sfx -b ${member_1}

    if test -f "${member_1}"; then
        if diff "${member_1}" "dest_dir/${member_1}" ; then
            echo ">>> Pass."
            pass=` expr $pass + 1 `
        else
            echo ">>> Fail: Extracted file contents mismatch."
            fail=` expr $fail + 1 `
        fi
    else
        echo ">>> Fail: Can't find expected extracted file: ${member_1}"
        fail=` expr $fail + 1 `
    fi
else
    echo \
 ">>> Fail: The UnZipSFX test relies on success in the UnZip \"-d\" test."
    fail=` expr $fail + 1 `
fi

# Expected results.

fail_expected=0
pass_expected=7

# Result summary.

echo ''
echo ">>> Test Results:   Pass: ${pass}, Fail: ${fail}"
if test $pass -ne $pass_expected -o $fail -ne $fail_expected ; then
    echo ">>> ###   Expected: Pass: ${pass_expected}, Fail: ${fail_expected}"
fi
echo ''

