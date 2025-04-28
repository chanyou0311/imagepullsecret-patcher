# build stage
FROM --platform=$BUILDPLATFORM golang:1.23.8 AS builder

ARG TARGETARCH
ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -o /app/imagepullsecret-patcher

# final stage
FROM gcr.io/distroless/static

COPY --from=builder /app/imagepullsecret-patcher /app/

ENTRYPOINT ["/app/imagepullsecret-patcher"]
