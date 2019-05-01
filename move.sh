#!/bin/bash

files=$(find './' -not -path '*/\.*' | grep 'review')

for f in $files
do
	mv $f $(echo $f | sed 's/monthly-catch-up/monthly_catchup/g')
done