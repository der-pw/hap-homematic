#!/bin/sh

ADDONNAME=hap-homematic
CONFIG_DIR=/usr/local/etc/config
ADDON_DIR=/usr/local/addons/${ADDONNAME}
ADDONWWW_DIR=/usr/local/etc/config/addons/www
ADDONCFG_DIR=${CONFIG_DIR}/addons/${ADDONNAME}
NPMCACHE_DIR=/tmp/hap-homematic-cache
RCD_DIR=${CONFIG_DIR}/rc.d
LOGFILE=/var/log/hmhapinstall.log
PACKAGE_FILE=${ADDONCFG_DIR}/etc/hap-homematic.tgz
echo "[Installer]Check existency of the daemon" >>${LOGFILE}
# install the bundled package so addon and application versions stay in sync
if [ -f ${PACKAGE_FILE} ]; then
echo "[Installer]installing bundled HAP-Homematic package ...">>${LOGFILE}
mkdir ${NPMCACHE_DIR}
cd ${ADDON_DIR}
npm i --cache ${NPMCACHE_DIR} --no-save ${PACKAGE_FILE} >>${LOGFILE} 2>&1
INSTALL_RESULT=$?
rm -R ${NPMCACHE_DIR}
if [ ${INSTALL_RESULT} -ne 0 ]; then
echo "[Installer]bundled package installation failed with code ${INSTALL_RESULT}">>${LOGFILE}
exit ${INSTALL_RESULT}
fi
elif [ ! -f ${ADDON_DIR}/node_modules/hap-homematic/index.js ]; then
echo "[Installer]Looks like the daemon is not here so start installer" >>${LOGFILE}
echo "[Installer]Running on node version:" >>${LOGFILE}
node --version >>${LOGFILE}
echo "[Installer]NPM is :" >>${LOGFILE}
npm --version >>${LOGFILE}

echo "[Installer]Program Dir is ${ADDON_DIR}" >>${LOGFILE}

echo "[Installer]installing HAP-Homematic ...">>${LOGFILE}
#create a cache in /tmp
mkdir ${NPMCACHE_DIR}
cd ${ADDON_DIR}
npm i --cache ${NPMCACHE_DIR} ${ADDONNAME}
#remove the cache
rm -R ${NPMCACHE_DIR} 

else
echo "[Installer]daemon exists lets light this candle" >>${LOGFILE}
fi

# create the button in system control after either installation path
echo "[Installer]creating HomeKit Button ...">>${LOGFILE}
node ${ADDON_DIR}/node_modules/${ADDONNAME}/etc/hm_addon.js hap ${ADDON_DIR}/node_modules/${ADDONNAME}/etc/hap_addon.cfg
# create the .nobackup file into the addon directory
echo "[Installer]Adding .nobackup to addon dir ...">>${LOGFILE}
touch ${ADDON_DIR}/.nobackup
echo "[Installer]we are done ...">>${LOGFILE}
