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

FROM scratch

COPY --from=builder  /dist/main /

ENTRYPOINT ["/main"]
