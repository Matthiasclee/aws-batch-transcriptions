#!/bin/bash

mkdir transcriptions 2>/dev/null

readarray files <<< "$(find audiofiles -name "*.mp3")"

for file in "${files[@]}"; do
  file="${file::-1}"
  file=$(echo $file | cut -d / -f 2)
  file="$file.json"

  aws s3api get-object \
    --bucket $AWS_CALL_TRANSCRIPTIONS_BUCKET \
    --key $file \
    --profile $AWSPROFILE \
    transcriptions/$file

  echo "$file" >> transcriptions.txt
  echo "> $(jq -r .results.transcripts[0].transcript transcriptions/$file)" >> transcriptions.txt
  echo >> transcriptions.txt
  echo >> transcriptions.txt
done
