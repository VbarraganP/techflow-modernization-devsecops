FROM golang:1.25.7-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git
COPY go.mod ./
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-s -w" -o app .

FROM scratch
WORKDIR /
COPY --from=builder /app/app /
EXPOSE 8000
CMD ["/app"]