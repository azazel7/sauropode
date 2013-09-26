DIRECTORY=""
DIRRIGHT="700"
FILERIGHT="600"

function PrintHelp
{
        echo "Usage : $0 [OPTIONS]"
        echo "          -h, --help                              Show this help message and exit"
        echo "          -D, --directory                         Choose the directory"
        echo "          -d, --dir_right                         Right for the directory (701, 777, 604, etc ...)"
        echo "          -f, --file_right                        Right for the file (701, 777, 604, etc ...)"
        exit 0
}

# Parameters

while [ $# -gt 0 ]; do
        case $1 in
                --help | -h)
                        PrintHelp
                ;;
                --directory | -D)
                        shift
                        DIRECTORY=$1
                ;;
                --dir_right | -d)
                        shift
                        DIRRIGHT=$1
                ;;
                --file_right | -f)
                        shift
                        FILERIGHT=$1
                ;;
        esac
        shift
done

if [ $DIRECTORY != "" ]
then
	find $DIRECTORY -type f -exec /usr/bin/chmod $FILERIGHT {} \;
	find $DIRECTORY -type d -exec /usr/bin/chmod $DIRRIGHT {} \;
fi 

