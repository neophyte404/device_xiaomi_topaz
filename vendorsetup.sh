# Shebang is intentionally missing - do not run as a script

# Override host metadata to make builds more reproducible and avoid leaking info
export BUILD_USERNAME=neophyte
export BUILD_HOSTNAME=neophyte-build

# MiuiCamera
git clone --depth=1 https://github.com/neophyte404/vendor_xiaomi_miuicamera vendor/xiaomi/miuicamera

# Dont include OMX service
export TARGET_SUPPORTS_OMX_SERVICE=false
