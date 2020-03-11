#!/bin/bash
totalPages=1
URL=$1
echo $URL
for issue in $(lynx -listonly -nonumbers -dump $URL | grep -e 'zip$')
do
	#gets images and saves into zip
    wget -c -nv --show-progress $issue

        #deletes unneeded file
    zip -q -d *.zip "hotcomic.net.txt"

    mv *.zip temp
    cd temp
    unzip *.zip

    rm *.zip
    counter=1     
    numberOfFiles="$(ls | sort -n| tail -n 1| cut -f1 -d '.')"

    while [ "$counter" -le "$numberOfFiles" ]
    do
        if [ $counter -lt 10 ]  
        then
                  
            if [ $totalPages -lt 10 ]
	    then                                 
                mv 0$counter.jpg ../finished/0$totalPages.jpg
            else
                mv 0$counter.jpg ../finished/$totalPages.jpg 
            fi
        else                         
                mv $counter.jpg ../finished/$totalPages.jpg
        fi                                              

        totalPages=$((totalPages+1))         
        counter=$((counter+1))
    done

cd ../
done
cd finished
zip comic.cbr ./*
rm *.jpg
