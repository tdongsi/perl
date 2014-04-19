::Use puttygen to generate the private key
::Make sure the public key is in ~/.ssh/authorized_keys on each host
pscp -i C:\Users\cuongd\Downloads\Pipeline\SSH\pipeline.ppk cuongd@frak2:/space/cuongd/upload/%1 frak2_%1
pscp -i C:\Users\cuongd\Downloads\Pipeline\SSH\pipeline.ppk cuongd@frak3:/space/cuongd/upload/%1 frak3_%1
pscp -i C:\Users\cuongd\Downloads\Pipeline\SSH\pipeline.ppk cuongd@frak5:/space/cuongd/upload/%1 frak5_%1
pscp -i C:\Users\cuongd\Downloads\Pipeline\SSH\pipeline.ppk cuongd@frak6:/space/cuongd/upload/%1 frak6_%1
