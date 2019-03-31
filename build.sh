git clone $SOURCE_REPO

mcconfig -d -m -p esp32

cp /moddable/build/tmp/esp32/debug/idf/xs_esp32.bin /artifacts/firmware.bin
