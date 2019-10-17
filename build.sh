cd /source
mcconfig -d -m -p esp32

mkdir /source/build
cp /root/moddable/build/tmp/esp32/debug/idf/* /source/build/
