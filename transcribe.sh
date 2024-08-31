#!/bin/bash

readarray files <<< "$(find audiofiles -name "*.mp3")"

for file in "${files[@]}"; do
  file="${file::-1}"
  file=$(echo $file | cut -d / -f 2)

  aws transcribe start-transcription-job \
    --transcription-job-name="$file" \
    --language-code="en-US" \
    --media="MediaFileUri=s3://$AWS_CALL_TRANSCRIPTIONS_BUCKET/$file" \
    --media-format="mp3" \
    --output-bucket-name="$AWS_CALL_TRANSCRIPTIONS_BUCKET" \
    --profile $AWSPROFILE
done
