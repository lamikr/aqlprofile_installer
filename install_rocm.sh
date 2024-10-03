RPM_NAME=hsa-amd-aqlprofile-1.0.0.60200.60200-crdnnh.14213.el9.x86_64.rpm
RPM_URL=https://repo.radeon.com/rocm/misc/aqlprofile/rhel-9/${RPM_NAME}
REL_NAME=rocm-6.2.0-14213
DOC_BASE_DIR_NAME=share/doc/hsa-amd-aqlprofile
DOC_SRC_DIR_NAME=opt/${REL_NAME}/${DOC_BASE_DIR_NAME}
LIB_SRC_DIR_NAME=opt/${REL_NAME}/lib
LIBHSA_AMD_AQLPROFILE64_SYMLINK_BASE_NAME=libhsa-amd-aqlprofile64.so
LIBHSA_AMD_AQLPROFILE64_FULL_NAME=${LIBHSA_AMD_AQLPROFILE64_SYMLINK_BASE_NAME}.1.0.60200

if [ -z "$1" ]; then
    echo ""
    echo "Error, no rocm sdk builder target directory defined"
    echo ""
    exit 1
else
    install_dir_prefix_rocm=${1}
    echo "rocm_root_directory parameter: ${install_dir_prefix_rocm}"
fi
if [ -z "$2" ]; then
    echo ""
    echo "Error, no aqlprofile source directory defined"
    echo ""
    exit 2
else
    source_dir_prefix_rocm=${2}
    echo "Using rocm version parameter: ${rocm_version_str}"
fi
if [ ! -d ${source_dir_prefix_rocm} ]; then
    mkdir -p ${source_dir_prefix_rocm}
fi
if [ ! -d ${source_dir_prefix_rocm} ]; then
    echo ""
    echo "Error, could not create source code directory ${source_dir_prefix_rocm}"
    echo ""
    exit 3
fi

cd ${source_dir_prefix_rocm}
if [ ! -e ${RPM_NAME} ]; then
    wget -c ${RPM_URL}

    if [ ! -e ${RPM_NAME} ]; then
        echo ""
        echo "Error, could not download ${RPM_URL}"
        echo ""
        exit 3
    fi
fi
if [ ! -e ${RPM_NAME} ]; then
    echo "Could not find: ${source_dir_prefix_rocm}/${RPM_NAME}"
fi
echo "Installing: ${source_dir_prefix_rocm}/${RPM_NAME}"
rpm2cpio ${RPM_NAME} | cpio -idmv

DOC_TRGT_DIR_NAME=${install_dir_prefix_rocm}/${DOC_BASE_DIR_NAME}
LIB_TRGT_DIR_NAME=${install_dir_prefix_rocm}/lib

if [ -e ${DOC_SRC_DIR_NAME} ]; then
    if [ ! -d ${DOC_TRGT_DIR_NAME} ]; then
        install -d ${DOC_TRGT_DIR_NAME}
    fi
    if [ -e ${DOC_SRC_DIR_NAME}/DISCLAIMER.txt ]; then
        if [ ! -e ${DOC_TRGT_DIR_NAME}/DISCLAIMER.txt ]; then
            install -Dm660 ${source_dir_prefix_rocm}/${DOC_SRC_DIR_NAME}/* ${DOC_TRGT_DIR_NAME}/
        fi
    fi
fi

if [ -d ${LIB_SRC_DIR_NAME}/hsa-amd-aqlprofile ]; then
    if [ ! -d ${LIB_TRGT_DIR_NAME}/hsa-amd-aqlprofile ]; then
        install -d ${LIB_TRGT_DIR_NAME}/hsa-amd-aqlprofile
    fi
    if [ -d ${LIB_TRGT_DIR_NAME}/hsa-amd-aqlprofile ]; then
        if [ ! -e ${LIB_TRGT_DIR_NAME}/${LIBHSA_AMD_AQLPROFILE64_FULL_NAME} ]; then
            install -Dm660 ${source_dir_prefix_rocm}/${LIB_SRC_DIR_NAME}/hsa-amd-aqlprofile/* ${LIB_TRGT_DIR_NAME}/hsa-amd-aqlprofile
            install -Dm660 ${source_dir_prefix_rocm}/${LIB_SRC_DIR_NAME}/${LIBHSA_AMD_AQLPROFILE64_FULL_NAME} ${LIB_TRGT_DIR_NAME}
            ln -s ${LIB_TRGT_DIR_NAME}/${LIBHSA_AMD_AQLPROFILE64_SYMLINK_BASE_NAME}.1 ${LIB_TRGT_DIR_NAME}/${LIBHSA_AMD_AQLPROFILE64_SYMLINK_BASE_NAME}
            ln -s ${LIB_TRGT_DIR_NAME}/${LIBHSA_AMD_AQLPROFILE64_FULL_NAME} ${LIB_TRGT_DIR_NAME}/${LIBHSA_AMD_AQLPROFILE64_SYMLINK_BASE_NAME}.1
            echo "aql profile libraries installed"
        fi
    fi
fi
