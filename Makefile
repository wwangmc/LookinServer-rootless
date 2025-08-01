THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
DEBUG = 1
FINALPACKAGE = 1

# 定义打包模式常量
ROOTFULL = 0
ROOTLESS = 1
ROOTHIDE = 2

# 默认使用 rootfull (0)，可通过命令行覆盖，如 `make TYPE=1` 选择 rootless
TYPE ?= $(ROOTLESS)

TARGET = iphone:clang:16.5:15.0
ifeq ($(TYPE), $(ROOTLESS))
    THEOS_PACKAGE_SCHEME = rootless
else ifeq ($(TYPE), $(ROOTHIDE))
    THEOS_PACKAGE_SCHEME = roothide
else 
	TARGET = iphone:clang:16.5:12.0
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = lookin

lookin_FILES = $(shell find LookinServer -name "*.m") $(wildcard GCDWebServer/**/*.m)  Tweak.xm
lookin_CFLAGS = -Wno-error -Wno-module-import-in-extern-c -fobjc-arc

# 定义需要包含的目录（可自由增删）
SEARCH_DIRS := GCDWebServer LookinServer

# 自动查找所有目录并添加 -I 前缀
lookin_CFLAGS += $(shell find $(SEARCH_DIRS) -type d | sed 's/^/-I/')
include $(THEOS_MAKE_PATH)/tweak.mk