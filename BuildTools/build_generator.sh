out_put_file="KeyGenerator/KeyGenerator"
source_directory_path="KeyGenerator/Sources/*"
sources=`find $source_directory_path -type f`

rm -rf $out_put_file

/usr/bin/xcrun -sdk macosx swiftc -o "${out_put_file}" $sources
