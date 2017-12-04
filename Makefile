CC=g++
CXXFLAGS+=-Wall
CXXFLAGS+=-std=c++17
CXXFLAGS+=-O0
CXXFLAGS+=-I$(INCLUDE)
LIBS+=-lsfml-graphics
LIBS+=-lsfml-window
LIBS+=-lsfml-system
LIBS+=-lBox2D

BUILD:=build
SRC:=src
INCLUDE:=.
SOURCES:=$(wildcard $(SRC)/*.cpp)
OBJECTS:=$(patsubst $(SRC)/%.cpp,$(BUILD)/%.o,$(SOURCES))

TARGET:=demo

#======================================================================

all: $(TARGET)

cover: CXXFLAGS+=-coverage
cover: all

$(TARGET): $(OBJECTS)
	@echo "Compiling: $@"
	@$(CC) -o $@ $^ $(CXXFLAGS) $(LIBS)
	@echo "Build successfull"

$(OBJECTS): | $(BUILD)

$(BUILD):
	@mkdir -p $(BUILD)

$(BUILD)/%.o: $(SRC)/%.cpp
	@echo "Compiling: $@"
	@$(CC) -c $(CXXFLAGS) $(LIBS) -o $@ $<

clean:
	@rm -rfv $(TARGET) $(BUILD) *.gcov

.PHONY: all clean
