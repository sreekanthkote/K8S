{
  	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Enable IAM User Permissions",
	  		"Effect": "Allow",
	  		"Principal": {"AWS": "arn:aws:iam::${aws_account_id}:root"},
	  		"Action": "kms:*",
	  		"Resource": "*"
		},
		{
			"Sid": "Allow access for Key Administrators",
  			"Effect": "Allow",
  			"Principal": {"AWS": [
    			"arn:aws:iam::${aws_account_id}:role/rwrd-admin-access"
  				]
  			},
  			"Action": [
    			"kms:Create*",
			    "kms:Describe*",
			    "kms:Enable*",
			    "kms:List*",
			    "kms:Put*",
			    "kms:Update*",
			    "kms:Revoke*",
			    "kms:Disable*",
			    "kms:Get*",
			    "kms:Delete*",
			    "kms:TagResource",
			    "kms:UntagResource",
			    "kms:ScheduleKeyDeletion",
			    "kms:CancelKeyDeletion"
  			],
  			"Resource": "*"
		},
		{
  			"Sid": "Allow use of the key",
  			"Effect": "Allow",
  			"Principal": {"AWS": [
    			"arn:aws:iam::${aws_account_id}:role/rwrd-admin-access",
    			"arn:aws:iam::${aws_account_id}:root"
  				]
  			},
  			"Action": [
			    "kms:Encrypt",
			    "kms:Decrypt",
			    "kms:ReEncrypt*",
			    "kms:GenerateDataKey*",
			    "kms:DescribeKey"
  			],
  			"Resource": "*"
		}

	]
}
