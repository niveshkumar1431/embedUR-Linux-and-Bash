#!/bin/bash
> errors.log
echo

#Help Menu

show_help()
{
        cat <<EOF
USAGE:
  file_analyzer.sh [OPTIONS]

OPTIONS:
  -d <directory>   Recursively search a directory
  -f <file>        Search inside a file
  -k <keyword>     Keyword to search (required)
  --help           Show this help and exit
EOF
}

#Searching keyword in the directory

search_directory()
{
	local current_dir=$1
	for item in "$current_dir"/*; do
		[[ ! -e "$item" ]] && continue

		if [[ -f "$item" ]]; then
			if grep -q "$key_word" "$item"; then
				echo "Keyword '$key_word' found in file: $item"
			fi
	
		elif [[ -d "$item" ]]; then
			search_directory "$item"
		fi
	done
}

#Searching a keyword in a file

search_keyword()
{
	if [[ ! -f "$file_found" ]]; then
		echo "Error: File not found" | tee -a errors.log >&2
	fi
	file_content=$(cat "$file_found")
	grep "$key_word" <<< "$file_content"
	if [[ $? -gt 0 ]];then
		echo "No matching word in the file /"$file_found/"" |tee -a erros.log >&2
	fi	
}

#Checking the help command 

if [[ "$1" == "--help" ]];then
	show_help
	exit 
fi

#Getopts

while getopts ":d:k:f:" flag 
do
        case $flag in
                d)
                        dir=$OPTARG
			;;
                k)
                        key_word=$OPTARG
			;;
                f)
                        file_search=$OPTARG
			;;
		:)
			echo "Error: Option -$OPTARG requires an argument" |tee -a error.logs >&2
			exit 
			;;
                ?)
                        echo "Error: Invalid option"|tee -a errors.log >&2
			echo "Use --help for usage" |tee -a errors.log >&2
			exit
			;;
        esac
done

#Checking the valid keyword

if [[ -z "$key_word" || ! $key_word =~ ^[0-9A-Za-z_]+$ ]]; then
	echo "Error: Keyword is not valid" |tee -a errors.log >&2
	exit
fi
#Checking whether the direcotry is exist

if [[ -n "$dir" && -n "$key_word" ]]; then
	if [[ ! -d "$dir" ]]; then
		echo "Error: Directory does not exist" | tee -a errors.log >&2
		exit
	else
		search_directory "$dir"
	fi

#Check whether file is exist

elif [[ -n "$file_search" && -n "$key_word" ]];then
	if [[ ! -f "$file_search" ]];then
		echo "Error: File does not exist" | tee -a errors.log >&2
		exit
	fi
	file_found="$file_search"
	search_keyword
else
	echo "Error: Invalid arguments" | tee -a errors.log >&2
	echo "Use --help for usage information" | tee -a errors.log >&2
	exit
fi

#Printing the special parameters

echo
echo "Special parameters" 
echo "------------------------------------------------"
echo "Script name: $0"
echo "The number of arguments is: $#"
echo "The arguments passed: $@"
echo "Exit status: $?"
