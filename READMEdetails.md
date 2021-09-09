### Docker container with Golang Application

Create a docker file with the following requiremnt

- minimal base image requirement to run the go application
- multi-stage build
- Extra points if you can build from scratch i.e FROM scratch
-  An executable to run by default when starting the container

### Expecting Output:

- A Dockerfile
- A README file with instructions on how to build and run the image
- An extra points if you can pass SENDER_EMAIL, PASSWORD & RECEIVER_EMAIL from the environment variable

### Preinstallation:

I have used the amazon linux for testig this application.Create the amazon linux instance and install the following packes of docker and golang apllication before creating the docke file:

```
sudo yum install docker -y
sudo yum install docker -y
sudo service docker restart
sudo chkconfig docker on
sudo usermod -a -G docker ec2-user
```
#### Install the golang application 

Set up golang application enviroment and make sure the golang supporting files and depandancies are available

- go.mod
- go.sum
- depandancies file


## Dockerfile
I  have used the golang:1.16-alpine docker image as a base image to build the docker file:

```
FROM golang:1.16-alpine AS builder
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

ARG  SENDER_EMAIL=${SENDER_EMAIL}
ARG  RECEIVER_EMAIL=${RECEIVER_EMAIL}
ARG PASSWORD=${PASSWORD}
ENV SENDER_EMAIL=$SENDER_EMAIL
ENV RECEIVER_EMAIL=$RECEIVER_EMAIL
ENV PASSWORD=$PASSWORD

RUN mkdir /build
WORKDIR /build

COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN go build -o main .

WORKDIR /dist
RUN cp /build/main .
EXPOSE 3000
CMD ["/dist/main"]
```
## Output:

- https://i.imgur.com/KDabSef.gif

docker image:
```
[root@ip-/Gowebdemo]# docker image ls
REPOSITORY        TAG           IMAGE ID       CREATED             SIZE
golangapp         latest        c377c2f92b45   55 minutes ago      536MB

```
docker container:
- https://i.imgur.com/68oHGUz.png
- https://i.imgur.com/eJhp5pC.png

## Multi-stage build and build from scratch i.e FROM scratch

We can build the application from the scratch base with binary of current application which helps to reduce the size of the image.

```
FROM golang:1.16-alpine
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
    

ARG  SENDER_EMAIL=${SENDER_EMAIL}
ARG  RECEIVER_EMAIL=${RECEIVER_EMAIL}
ARG PASSWORD=${PASSWORD}
ENV SENDER_EMAIL=$SENDER_EMAIL
ENV RECEIVER_EMAIL=$RECEIVER_EMAIL
ENV PASSWORD=$PASSWORD
RUN mkdir /build
WORKDIR /build

COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN go build -o main .

WORKDIR /dist
RUN cp /build/main .
EXPOSE 3000

FROM scratch

COPY --from=builder  /dist/main /

ENTRYPOINT ["/main"]

```

## Output
```
[root@/Gowebdemo]# docker image ls
REPOSITORY        TAG           IMAGE ID       CREATED              SIZE
golangscratch     latest        2c8853b40d15   About a minute ago   4.84MB
golangapp         latest        ed39635ca617   12 minutes ago       536MB

```
We can see that the image created from the scratch is only 4.84 MB size as it is too smaller than the real one.

## SENDER_EMAIL, PASSWORD & RECEIVER_EMAIL from the environment variable

We can pass the envirmental variable/  the variable through the command line while creating the container as those variable may be change base on our purpose.

we can specify the credetials as an Argument in the docker file and we can call value argument from the command line while build the image 
 
 `docker build . -t gols --build-arg PASSWORD=$PASSWORD  --build-arg RECEIVER_EMAIL=$RECEIVER_EMAIL --build-arg SENDER_EMAIL=$SENDER_EMAIL
D`
 

 ========================================================================================================

