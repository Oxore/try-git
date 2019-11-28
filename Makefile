Q=@
CXX=g++
CXXFLAGS+=-Wall
CXXFLAGS+=-std=c++17
CXXFLAGS+=-O0
CXXFLAGS+=-I$(INCLUDE)
CXXFLAGS+=$(EXTRA_CXXFLAGS)
ifdef SFML_STATIC
CXXFLAGS+=-DSFML_STATIC
LDFLAGS+=-lsfml-graphics-s
LDFLAGS+=-lsfml-window-s
LDFLAGS+=-lsfml-system-s
ifeq ($(OS),Windows_NT)
LDFLAGS+=-static
LDFLAGS+=-static-libgcc
LDFLAGS+=-static-libstdc++
LDFLAGS+=-lopengl32
LDFLAGS+=-lgdi32
LDFLAGS+=-lwinmm
LDFLAGS+=-mwindows
else
UNAME_S:=$(shell uname -s)
ifeq ($(UNAME_S),Linux)
LDFLAGS+=-pthread
LDFLAGS+=-lX11
LDFLAGS+=-lXrandr
LDFLAGS+=-ldl
LDFLAGS+=-ludev
LDFLAGS+=-lGL
endif
ifeq ($(UNAME_S),Darwin)
LDFLAGS+=-framework OpenGL
LDFLAGS+=-framework AppKit
LDFLAGS+=-framework IOKit
LDFLAGS+=-framework Carbon
endif
endif # ($(OS),Windows_NT)
else # SFML_STATIC
LDFLAGS+=-lsfml-graphics
LDFLAGS+=-lsfml-window
LDFLAGS+=-lsfml-system
endif # SFML_STATIC
LDFLAGS+=-lBox2D
LDFLAGS+=-L./lib/build-box2d
LDFLAGS+=$(EXTRA_LDFLAGS)

BUILD:=build
SRC:=src
INCLUDE:=./lib/Box2D/Box2D
SOURCES:=$(wildcard $(SRC)/*.cpp)
OBJECTS:=$(patsubst $(SRC)/%.cpp,$(BUILD)/%.o,$(SOURCES))

TARGET:=demo

#======================================================================

all: box2d
all: $(TARGET)

cover: CXXFLAGS+=-coverage
cover: all

box2d: | lib/build-box2d
	cd lib/build-box2d && cmake -G 'Unix Makefiles' -DBUILD_SHARED_LIBS=OFF .. && $(MAKE)

lib/build-box2d:
	$(Q)mkdir -p $@

$(TARGET): $(OBJECTS)
	@echo "Compiling: $@"
	$(Q)$(CXX) -o $@ $^ $(LDFLAGS)
	@echo "Build successfull"

$(OBJECTS): | $(BUILD)

$(BUILD):
	$(Q)mkdir -p $(BUILD)

$(BUILD)/%.o: $(SRC)/%.cpp
	@echo "Compiling: $@"
	$(Q)$(CXX) -c $(CXXFLAGS) -o $@ $<

clean:
	$(Q)rm -rfv $(TARGET) $(BUILD) *.gcov

mrproper: clean
	$(Q)rm -rfv lib/build/*

.PHONY: all clean mrproper
