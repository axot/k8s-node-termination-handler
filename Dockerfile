# build stage
FROM golang:latest AS build-env
RUN go get github.com/golang/dep/cmd/dep 
RUN go get -d github.com/axot/k8s-node-termination-handler || true
WORKDIR /go/src/github.com/axot/k8s-node-termination-handler
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -tags netgo -o node-termination-handler

# final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /go/src/github.com/axot/k8s-node-termination-handler/node-termination-handler /app/
ENTRYPOINT ./node-termination-handler