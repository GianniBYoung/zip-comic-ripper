#!/bin/bash

#creates necessary directories if missing
[ ! -d "./temp" ] && mkdir temp && [ ! -d "./aggregation" ] && mkdir aggregation && [ ! -d "./finished" ] && mkdir finished && echo "Directories created successfully."

totalPages=1
URL=$1
outputName=$2
echo Fetching from: $URL
issues=$(lynx -listonly -nonumbers -dump $URL | grep -e 'zip$')

for issue in $issues
do
	#gets images and saves into zip
    wget -c -nv --show-progress $issue  && echo " "

        #deletes unneeded file
    zip -q -d *.zip "hotcomic.net.txt"

    mv *.zip temp
    cd temp
    unzip -q *.zip

    rm *.zip
    counter=1     
    numberOfFiles="$(ls | sort -n| tail -n 1| cut -f1 -d '.')"

    while [ "$counter" -le "$numberOfFiles" ]
    do
        if [ $counter -lt 10 ]  
        then
                  
            if [ $totalPages -lt 10 ]
	    then                                 
                mv 0$counter.jpg ../aggregation/0$totalPages.jpg
            else
                mv 0$counter.jpg ../aggregation/$totalPages.jpg 
            fi
        else                         
                mv $counter.jpg ../aggregation/$totalPages.jpg
        fi                                              

        totalPages=$((totalPages+1))         
        counter=$((counter+1))
    done

cd ../
done

echo "Packing into final cbr."
cd aggregation
zip -q $2.cbr ./*
rm *.jpg
mv $2.cbr ../finished
echo "Completed. File located in ./finished"
