mkdir lib/build-SFML
pushd lib/build-SFML && cmake -G "Unix Makefiles" -DBUILD_SHARED_LIBS=OFF ../SFML && popd
make -C lib/build-SFML
make SFML_STATIC=y EXTRA_LDFLAGS="-L./lib/build-SFML/lib" EXTRA_CXXFLAGS="-isystem ./lib/SFML/include" Q=
