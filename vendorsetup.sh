# Shebang is intentionally missing - do not run as a script

# Override host metadata to make builds more reproducible and avoid leaking info
export BUILD_USERNAME=neophyte
export BUILD_HOSTNAME=neophyte-build

# MiuiCamera
git clone --depth=1 https://github.com/neophyte404/vendor_xiaomi_miuicamera vendor/xiaomi/miuicamera

# Auto-apply framework patch for fix battery usage

apply_topaz_patches() {
    echo "=== Applying fix battery usage ==="

    # Detect Android top automatically (works even if envsetup.sh not sourced)
    if [ -z "$ANDROID_BUILD_TOP" ]; then
        ANDROID_BUILD_TOP=$(pwd)
        while [ "$ANDROID_BUILD_TOP" != "/" ] && [ ! -d "$ANDROID_BUILD_TOP/build" ]; do
            ANDROID_BUILD_TOP=$(dirname "$ANDROID_BUILD_TOP")
        done
    fi

    PATCH_DIR="${ANDROID_BUILD_TOP}/device/xiaomi/topaz/patches"
    PATCH_FILE="${PATCH_DIR}/0001-Revert-Use-getUahDischarge-when-available.patch"
    TARGET_DIR="${ANDROID_BUILD_TOP}/frameworks/base"

    echo "Using ANDROID_BUILD_TOP: $ANDROID_BUILD_TOP"
    echo "Looking for patch at: $PATCH_FILE"

    if [ ! -f "${PATCH_FILE}" ]; then
        echo "❌ Patch file not found: ${PATCH_FILE}"
        return
    fi

    cd "${TARGET_DIR}" || return

    if git apply --check "${PATCH_FILE}" >/dev/null 2>&1; then
        git apply --whitespace=fix "${PATCH_FILE}"
        echo "✅ Patch successfully applied."
    else
        echo "⚠️ Patch already applied or cannot be checked."
    fi

    cd "${ANDROID_BUILD_TOP}" || return
}

apply_topaz_patches
