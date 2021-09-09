#1.Build the docker image from the docker file with arguments 

docker build . -t gols --build-arg PASSWORD=$PASSWORD --build-arg RECEIVER_EMAIL=$RECEIVER_EMAIL --build-arg SENDER_EMAIL=$SENDER_EMAIL

#Create he container from  the docker image

docker run -it  --name conatinername -p 30300:30303 golangapp

#You can specify the port and conatiner name if neede which depand on golang conf file
