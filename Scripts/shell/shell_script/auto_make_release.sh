#!/bin/bash
#Program:
#	make release update files and img files  for Amlogic S905M
#History:
#	2016/02/15	Liu Pu(Braden Liu)	1st Release		V.0.00001

clear
echo '###################################################################'
echo '#   shell script for release update files and img files           #'
echo '#   VERSION : 0.00001  for S905M                         			#'
echo '#   AUTHOR  : liup@yinhe                                          #'
echo '###################################################################'

SW_MODE=$1
ITLB_APK=$2
DEBUG_MOD=$3
VERSION_FORM=$4
VERSION_TEST=$5
UPDATE_PARAM=$6
UPDATE_CHECK_VERSION=$7

function print_help()
{
	echo "usage  : $0 <HW|ZTE|EBUPT>  <DEF|CNTV|GITV> <DEBUG_ON|DEBUG_OFF> <VERSION_TEST> <VERSION_FORM> <G1-10|G2-20|G2-100A|G2-40|G2-40F...> <UPDATE_CHECK_VERSION>"
	echo "------------------------------------------"
	echo "ex.S905M:  $0 EBUPT DEF DEBUG_OFF V.194.01 V.194.98 G2-40F Update.zip"
	echo "version : V.ABC.DE"
	echo "A: 1 Yinhe 7 Skyworth"
	echo "B: 0 CNTV  1 GITV  2 BESTV 3 HuaShu 4-8 reverse 9 no ITLB apk"
	echo "C: 0 single-core 1 dual-core 2 quad-core ..."
	echo "DE: for software little version"
	echo "ex.CNTV  quad-core: V.102.12"
	echo "ex.GITV  quad-core: V.112.12"
	echo "ex.NOAPK quad-core: V.192.12"
	echo "------------------------------------------"
}

function create_make_setenv()
{
	echo "step $1 start: set env"

	source YH_Amlogic_toolchain/env_amlogic_yh.sh "$(pwd)/YH_Amlogic_toolchain/env_amlogic_yh.sh"
	source build/envsetup.sh
	export PROJECT_TYPE=jsmobile PROJECT_ID=p201
	lunch ${LUNCH_MODE}

	if [ "$?"x != "0"x ] ; then
		echo "step $1 failed"
		exit 1
	fi
}

function create_make_clean()
{
	echo "step $1 start: make clean"

	make clean

	if [ "$?"x != "0"x ] ; then
		echo "step $1 failed"
		exit 1
	fi
}

function create_make_compile()
{
	echo "step $1 start: compile $2"
	
#	# modify version in buildinfo.sh
#	sed -i "s/`cat ${FILE_BUILDINFO_SH} | grep ro.build.display.id=`/echo \"ro.build.display.id=$2\"/g" ${FILE_BUILDINFO_SH} 
#	if [ "$?"x != "0"x ] ; then
#		echo "step $1 failed<1>"
#		exit 1
#	fi	

	# modify version in cwmp.conf
	sed -i "s/`cat $FILE_CWMP_CONF | grep cpe_version`/cpe_version=$2/g" $FILE_CWMP_CONF
	if [ "$?"x != "0"x ] ; then
		echo "step $1 failed<2>"
		exit 1
	fi
	
	make otapackage -j16 2>&1 | tee otapackage.log
	if [ "$?"x == "0"x ] ; then
		echo "step $1 ok!!"
	else
		echo "step $1 failed"
		exit 1
	fi
}

function create_copy_img()
{
	echo "step $1 start: copy img $2"
	mkdir -p ${CREATE_FILES_DIR}/Img_$2
	cp -vf ./${PRODUCT_DIR}/aml_upgrade_package.img ${CREATE_FILES_DIR}/Img_$2
	cp -vf ./${PRODUCT_DIR}/recovery.img ${CREATE_FILES_DIR}/Img_$2
	cp -vf ./device/amlogic/${TARGET_PRODUCT}/upgrade/u-boot.bin.sd.bin ${CREATE_FILES_DIR}/Img_$2
	
	echo "--update_package=/sdcard/update.zip" > ${CREATE_FILES_DIR}/Img_$2/factory_update_param.aml
	echo "--wipe_data" >> ${CREATE_FILES_DIR}/Img_$2/factory_update_param.aml
	echo "--wipe_cache" >> ${CREATE_FILES_DIR}/Img_$2/factory_update_param.aml
	
	cp -vf ./${PRODUCT_DIR}/${FILE_UPDATE_ZIP} ${CREATE_FILES_DIR}/Img_$2/update.zip
	cp -vf ./${PRODUCT_DIR}/${FILE_UPDATE_ZIP} ${CREATE_FILES_DIR}/update_$2.zip
	
	# copy target_files_package zip for making Incremental update package
	mkdir -p ${CREATE_FILES_DIR}/Img_$2/ota/
	cp -vf ./${PRODUCT_DIR}/obj/PACKAGING/target_files_intermediates/${FILE_TARGET_UPDATE_ZIP} ${CREATE_FILES_DIR}/Img_$2/ota/
	
	cp -vf ./${PRODUCT_DIR}/obj/KERNEL_OBJ/vmlinux ${CREATE_FILES_DIR}/Img_$2/

	if [ "$?"x != "0"x ] ; then
		echo "step $1 failed"
		exit 1
	fi

	echo "${SW_MODE}_${ITLB_APK}_${UPDATE_PARAM}_${DEBUG_MOD}_${CREATE_DATE}_R-${CODE_VERSION}_$2" > ${CREATE_FILES_DIR}/Img_$2/version.txt
	if [ "$?"x == "0"x ] ; then
		echo "step $1 ok!!"
	else
		echo "step $1 failed"
		exit 1
	fi
}

function create_update_cwmp()
{
	echo "step $1 start: copy update_cwmp $2"
	cp -vf "./${PRODUCT_DIR}/${FILE_UPDATE_ZIP}" "${CREATE_FILES_DIR}/${SW_MODE}_Yinhe_${UPDATE_PARAM}_$2_${CREATE_DATE}_Full_${UPDATE_CHECK_VERSION}"

	if [ "$?"x == "0"x ] ; then
		echo "step $1 ok!!"
	else
		echo "step $1 failed"
		exit 1
	fi
}

function create_update_inc()
{
	echo "step $1 start: copy update_inc VERSION_FORM $2 - VERSION_TEST $3"
	
	./build/tools/releasetools/ota_from_target_files -i ${CREATE_FILES_DIR}/Img_$2/ota/${FILE_TARGET_UPDATE_ZIP} ${CREATE_FILES_DIR}/Img_$3/ota/${FILE_TARGET_UPDATE_ZIP} ${CREATE_FILES_DIR}/${SW_MODE}_Yinhe_${UPDATE_PARAM}_$2-$3_${CREATE_DATE}_Increment_${UPDATE_CHECK_VERSION}

	if [ "$?"x == "0"x ] ; then
		echo "step $1 ok!!"
	else
		echo "step $1 failed"
		exit 1
	fi
}

#echo "SW_MODE<$SW_MODE>"
#echo "DEBUG_MOD<$DEBUG_MOD>"
#echo "VERSION_FORM<$VERSION_FORM>"
#echo "VERSION_TEST<$VERSION_TEST>"
CREATE_FILES_DIR="tmp_create_files"
#rm -rf "$CREATE_FILES_DIR"


BUILD_CMD="$SW_MODE
$ITLB_APK
$DEBUG_MOD"
#echo "BUILD_CMD<$BUILD_CMD>"

LUNCH_MODE_ENG="p201_iptv-eng"
LUNCH_MODE_USER="p201_iptv-user"
LUNCH_MODE=

if [ "$SW_MODE"x != "HW"x ] && [ "$SW_MODE"x != "ZTE"x ] && [ "$SW_MODE"x != "EBUPT"x ] ; then
	print_help
	exit 1
fi

if [ "$ITLB_APK"x != "DEF"x ] && [ "$ITLB_APK"x != "CNTV"x ] && [ "$ITLB_APK"x != "GITV"x ] && [ "$ITLB_APK"x != "DEFAD"x ]; then
	print_help
	exit 1
fi

if [ "$DEBUG_MOD"x == "DEBUG_ON"x ] ; then
	LUNCH_MODE=${LUNCH_MODE_ENG}
	echo LUNCH_MODE=${LUNCH_MODE}
elif [ "$DEBUG_MOD"x == "DEBUG_OFF"x ] ; then
	LUNCH_MODE=${LUNCH_MODE_USER}
	echo LUNCH_MODE=${LUNCH_MODE}
else
	print_help
	exit 1
fi

if ! [ "$#" -eq "7" ] ; then
	print_help
	exit 1
fi


create_make_setenv "01"

CREATE_DATE=`date +%Y%m%d`
CODE_VERSION=`git log --oneline | head -n 1 | awk '{printf "%s\n", $1}'`
CREATE_FILES_DIR="tmp_create_files/${SW_MODE}_${ITLB_APK}_${UPDATE_PARAM}_${DEBUG_MOD}_${CREATE_DATE}_R-${CODE_VERSION}/"
FILE_BUILDINFO_SH="build/tools/buildinfo.sh"
FILE_CWMP_CONF="device/amlogic/common/ChinaMobile_apks/js/tr069/cwmp.conf"
PRODUCT_DIR="out/target/product/${TARGET_PRODUCT}/"
FILE_UPDATE_ZIP="${TARGET_PRODUCT}-ota-${CREATE_DATE}.zip"
# for making Incremental update package
FILE_TARGET_UPDATE_ZIP="${TARGET_PRODUCT}-target_files-${CREATE_DATE}.zip"

echo 'output dir: <$CREATE_FILES_DIR>'
rm -rf "$CREATE_FILES_DIR"
mkdir -p "$CREATE_FILES_DIR"

create_make_clean "02"

create_make_compile "11" "$VERSION_FORM"
create_copy_img "12" "$VERSION_FORM"
create_update_cwmp "13" "$VERSION_FORM"

create_make_compile "21" "$VERSION_TEST"
create_copy_img "22" "$VERSION_TEST"
create_update_cwmp "23" "$VERSION_TEST"

create_update_inc "31" "$VERSION_FORM" "$VERSION_TEST"

echo "output dir: <$CREATE_FILES_DIR>"
echo "run successfully!!"
