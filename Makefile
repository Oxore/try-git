CXX=g++
CXXFLAGS+=-Wall
CXXFLAGS+=-std=c++17
CXXFLAGS+=-O0
CXXFLAGS+=-I$(INCLUDE)
CXXFLAGS+=-L$$(pwd)/lib/build
LIBS+=-lsfml-graphics
LIBS+=-lsfml-window
LIBS+=-lsfml-system
LIBS+=-lBox2D

BUILD:=build
SRC:=src
INCLUDE:=./lib/Box2D/Box2D
SOURCES:=$(wildcard $(SRC)/*.cpp)
OBJECTS:=$(patsubst $(SRC)/%.cpp,$(BUILD)/%.o,$(SOURCES))

TARGET:=demo

#======================================================================

all: $(TARGET)

cover: box2d
cover: CXXFLAGS+=-coverage
cover: all

box2d: | libbuilddir
	cd lib/build && cmake .. && make

libbuilddir:
	@mkdir -p lib/build

$(TARGET): $(OBJECTS)
	@echo "Compiling: $@"
	@$(CXX) -o $@ $^ $(CXXFLAGS) $(LIBS)
	@echo "Build successfull"

$(OBJECTS): | $(BUILD)

$(BUILD):
	@mkdir -p $(BUILD)

$(BUILD)/%.o: $(SRC)/%.cpp
	@echo "Compiling: $@"
	@$(CXX) -c $(CXXFLAGS) $(LIBS) -o $@ $<

clean:
	@rm -rfv $(TARGET) $(BUILD) *.gcov lib/build/*

.PHONY: all clean
