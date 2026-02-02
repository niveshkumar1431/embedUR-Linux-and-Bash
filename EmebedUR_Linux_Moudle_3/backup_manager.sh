#!/bin/bash
#Getting the command line arguments
shopt -s nullglob
source="$1"
destination="$2"
echo "The source directory path is: $1"
echo "The Destination direcotry path is: $2"
echo "The file type to be back up is: $3"
declare -A file_info
if [ ! -d "$destination" ];then
echo "The directory is not exsist and creating the directory"
mkdir -p "$destination"
if [ ! -d "$destination" ];
then
echo "Failed to create the directory and exiting...."
exit 
fi
fi
files=("$source"/*."$3")
if [ "${#files[@]}" -eq 0 ];then
echo "No matching file in directory"
echo "Exiting from program....."
exit 
fi
shopt -u nullglob
for file in "${files[@]}";do 
filename=$(basename "$file")
fileszie=$(stat -c %s "$file")
file_info["$filename"]="$fileszie"
done
for f in "${!file_info[@]}"; do
echo "File name: $f and file size: ${file_info[$f]} bytes"
done 
export BACKUP_COUNT=${#files[@]}
echo "Total number of file is:$BACKUP_COUNT"
for f in "${files[@]}"; do
fname=$(basename "$f")
dest="$destination/$fname"
if [ -f "$dest" ]; then
if [ "$f" -nt "$dest" ]; then
cp "$f" "$dest"
echo "Updated: $fname"
else
echo "Skipped: $fname (backup is newer)"
fi
else
cp "$f" "$dest"
echo "Copied: $fname"
((TOTAL_SIZE+=file_info["$filename"]))
fi
done
report="$destination/backup_report.log"

{
echo "Backup Report"
echo "-------------"
echo "Date              : $(date)"
echo "Source Directory  : $source"
echo "Backup Directory  : $destination"
echo "File Extension    : .$extension"
echo "Total Files Backed Up : $BACKUP_COUNT"
echo "Total Size Backed Up  : $TOTAL_SIZE bytes"
} > "$report"

echo "Backup completed successfully."
echo "Report saved at: $report"echo "Skipped: $fname (backup is already newer)"
