mkdir -p tmp
rm -rf tmp/*
mkdir -p tmp/hap
mkdir -p tmp/www

# Bundle the application package so the CCU installer does not depend on the
# npm registry serving the same version as this addon archive.
mkdir -p tmp/hap/etc
npm pack .. --pack-destination tmp/hap/etc
mv tmp/hap/etc/hap-homematic-*.tgz tmp/hap/etc/hap-homematic.tgz

# copy all relevant stuff
cp -a update_script tmp/
cp -a rc.d tmp/
cp -a VERSION tmp/www/
cp -a etc tmp/hap

# generate archive
cd tmp
tar --exclude=._* --exclude=.DS_Store -czvf ../hap-homematic-$(cat ../VERSION).tar.gz *
cd ..
rm -rf tmp
