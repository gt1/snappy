#! /bin/bash
VERSION=`awk '
	/m4_define\(\[snappy_major\]/ {V=$0 ; sub(/.*\[/,"",V) ; sub(/\].*/,"",V) ; MAJOR=V} 
	/m4_define\(\[snappy_minor\]/ {V=$0 ; sub(/.*\[/,"",V) ; sub(/\].*/,"",V) ; MINOR=V} 
	/m4_define\(\[snappy_patchlevel\]/ {V=$0 ; sub(/.*\[/,"",V) ; sub(/\].*/,"",V) ; PATCHLEVEL=V} 
	END {print MAJOR "." MINOR "." PATCHLEVEL}' < configure.ac`

ADDFILES="aclocal.m4 autom4te.cache config.guess config.h.in config.sub configure depcomp INSTALL install-sh ltmain.sh m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 m4/ltversion.m4 Makefile.in missing"
RELEASE=${VERSION}-release

# create temporary branch
git checkout -b ${RELEASE}-branch master
# create configure and friends
./autogen.sh
# add files in temporary branch
git add ${ADDFILES}
# commit changes
git commit -m "Release ${RELEASE}"
# add tag
git tag ${RELEASE}
# push tag to origin
git push origin ${RELEASE}
# back to master branch
git checkout master
# delete temporary branch
git branch -D ${RELEASE}-branch
