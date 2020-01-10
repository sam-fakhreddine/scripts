$directory=
$filetype=
$from_encoding=
$to_encoding=
$output_directory=

for f in "$directory"*.$filetype ; do b=`basename $f`; iconv -f $from_encoding -t $to_encoding $f > $output_directory/$b; done
