#1.Build the docker image from the docker file with arguments 

docker build . -t gols --build-arg PASSWORD=$PASSWORD

#Create he container from  the docker image

docker run -it  --name conatinername -p 30300:30303 golangapp

#You can specify the port and conatiner name if neede which depand on golang conf file
