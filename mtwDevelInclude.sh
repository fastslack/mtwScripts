#!/bin/sh

# Checking 
mtwCheckRoot
mtwCheckVersionVariable

# Devel Constants
PACKAGENAME="${BASENAME}"
PACKAGEPATH="${BASEDIR#${PACKSCRIPTS}}"
PACKAGESOURCE="${SOURCESDIR}${PACKAGEPATH}/${PACKAGENAME}-${VERSION}.tar.bz2"
PKGTMPDIR="${TMP}/${PACKAGENAME}.package"

CLEAN="0"

BUILD="1"
ARCH=`uname -m`

if [ ${ARCH} == "x86_64" ];then
	CFLAGS="-02 -fPIC"
	CXXFLAGS="-02 -fPIC"
fi

function mtwSourceExtract () {

	if [ ${VERSION} != "CVS" ]; then

		FILE=`ls ${SOURCESDIR}${PACKAGEPATH}/${PACKAGENAME}-${VERSION}.tar.*`
		EXT=${FILE##*.}
	
		PACKAGESOURCE="${SOURCESDIR}${PACKAGEPATH}/${PACKAGENAME}-${VERSION}.tar.${EXT}"

    	if [ ! -f "${PACKAGESOURCE}" ]; then
        	echo "${PACKAGESOURCE} not found!"
        	exit
    	fi

	    rm -rf ${PKGTMPDIR}
    	mkdir -p ${PKGTMPDIR}

    	cd ${TMP}

    	if [ ! -d "${TMP}/${PACKAGENAME}-${VERSION}/" ]; then
        	echo "Extracting ${PACKAGENAME}-${VERSION}.tar.${EXT}"
        	if [ ${EXT} == "bz2" ]; then
				tar jxfv ${PACKAGESOURCE} 1> /dev/null
			elif [ ${EXT} == "gz" ]; then
				tar zxfv ${PACKAGESOURCE} 1> /dev/null
			fi
    	fi

    	cd ${TMP}/${PACKAGENAME}-${VERSION}/

	else

		if [ ! -d "${SOURCESDIR}${PACKAGEPATH}" ]; then
            echo "${SOURCESDIR}${PACKAGEPATH} not found!"
            exit
		fi

		cd ${SOURCESDIR}${PACKAGEPATH}

	fi	

}

function mtwCreatePackage () {

	if [ ${VERSION} == "CVS" ]; then
		VERSION=${PACKDATE}
	fi

    if [ ${CLEAN} -eq 1 ]; then
		echo "Make clean"
        make clean 1> /dev/null
    fi

	echo "Making the binaries"
	make 1> /dev/null || exit 2

	echo "Making the Slackware Package"
	make install DESTDIR=${PKGTMPDIR} 1> /dev/null || exit 1

	# FIXXXXXXXXX
	#echo "${SOURCESDIR}${PACKAGEPATH}/install"

	#echo "${PROJECTSDIR}${PACKAGEPATH}"
	#echo "${PKGTMPDIR}"

	if [ -d "${PROJECTSDIR}${PACKAGEPATH}/install" ]; then
		cp -r ${PROJECTSDIR}${PACKAGEPATH}/install/ ${PKGTMPDIR}/.
                rm -rf ${PKGTMPDIR}/install/.svn/ 
	fi
	
	if [ ! -d "${PACKCOMPILED}${PACKAGEPATH}" ]; then
		echo "Mkdir"
		mkdir -p ${PACKCOMPILED}${PACKAGEPATH} 
	fi

	cd ${PKGTMPDIR}

	makepkg -l y -c n ${PACKCOMPILED}${PACKAGEPATH}/${PACKAGENAME}-${VERSION}-${ARCH}-${BUILD}mtw.tgz 1> /dev/null

	# Delete tmp
	cd ${PWD}
	rm -rf cd ${PKGTMPDIR}

	CV=$(mtwCheckVersion)

	if [ ${CV} -ne "0" ]; then
        echo "Package installed detected. The last version is ${CV}. Upgrading to ${VERSION}"
		upgradepkg ${PACKCOMPILED}${PACKAGEPATH}/${PACKAGENAME}-${VERSION}-${ARCH}-${BUILD}mtw.tgz
	else
        echo "Package not found. Installing ${PACKAGENAME}-${VERSION}-${ARCH}-${BUILD}.tgz"
		installpkg ${PACKCOMPILED}${PACKAGEPATH}/${PACKAGENAME}-${VERSION}-${ARCH}-${BUILD}mtw.tgz
	fi

	echo ${1}
}

function mtwCheckVersion()
{
    if [ -f ${PACKAGES}/${BASENAME}-????????-${ARCH}-${BUILD}mtw ]; then
        VER=`ls ${PACKAGES}/${BASENAME}-????????-${ARCH}-${BUILD}mtw | cut -d"-" -f2`

                if [ ${YEAR} -gt ${VER:0:4} ]; then
                    echo ${VER}
                    exit
                elif [ ${MONTH} -gt ${VER:4:2} ]; then
                        echo ${VER}
                        exit
                elif [ ${DAY} -ge ${VER:6:8} ]; then
                        echo ${VER}
                        exit
                else
                        echo 0
                        exit
                fi
   fi

   if [ -f ${PACKAGES}/${BASENAME}-??????????????-${ARCH}-${BUILD}mtw ]; then
            VER=`ls ${PACKAGES}/${BASENAME}-??????????????-${ARCH}-${BUILD}mtw | cut -d"-" -f2`

                if [ ${PACKDATE} -gt ${VER} ]; then
                    echo ${VER}
                else
                    echo 0
                fi
   else
               echo 0
   fi
}





