#!/bin/bash
#This script to move data from /backup to AWS S3 bucket
#Created 20-02-2017
#Updated 27-02-2017
#aws s3 mv command will move data to s3 instead of copy

bucket={{ssm:backupbucket}}
copypath={{ssm:backuppath}}
snsarn={{ssm:snstopic}}


aws s3 mv $copypath s3://$bucket/ --recursive


#Email Notification

if [ “$?” = "0" ]; then
	aws sns publish --topic-arn $snsarn --message "S3 backup is sucessfully completed."
else
 	aws sns publish --topic-arn $snsarn --message "S3 Backup has failed for THIS server"
fi

#END
