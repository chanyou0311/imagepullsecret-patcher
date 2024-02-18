# build stage
FROM --platform=$BUILDPLATFORM golang:1.13 as builder

ARG TARGETARCH
ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build

# final stage
FROM scratch

COPY --from=builder /app/imagepullsecret-patcher /app/

ENTRYPOINT ["/app/imagepullsecret-patcher"]
