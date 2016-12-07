curl --form token=Dd_7rtF5Wv5-Kzm15jZcig \
  --form email=tharding@lgnt.com.au \
  --form file=@/home/tobin/build/repos/jittertrap/jittertrap-coverity-build.lzma \
  --form version=$(date  +%d-%m-%Y_%H:%M) \
  --form description="" \
  https://scan.coverity.com/builds?project=taivas1080%2Fjittertrap
