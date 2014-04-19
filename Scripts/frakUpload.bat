::Use puttygen to generate the private key
::Make sure the public key is in ~/.ssh/authorized_keys on each host
pscp -i C:\Users\cuongd\Downloads\Pipeline\SSH\pipeline.ppk %1 cuongd@frak2:/space/cuongd/upload
pscp -i C:\Users\cuongd\Downloads\Pipeline\SSH\pipeline.ppk %1 cuongd@frak3:/space/cuongd/upload
pscp -i C:\Users\cuongd\Downloads\Pipeline\SSH\pipeline.ppk %1 cuongd@frak5:/space/cuongd/upload
pscp -i C:\Users\cuongd\Downloads\Pipeline\SSH\pipeline.ppk %1 cuongd@frak6:/space/cuongd/upload
pscp -i C:\Users\cuongd\Downloads\Pipeline\SSH\pipeline.ppk %1 cuongd@reda64qa:/space/cuongd/upload
