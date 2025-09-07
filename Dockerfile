# -- BUILD --

# Lightwey  image of golang
FROM golang:1.25-alpine AS builder

# Initialize directory where Docker will find files
WORKDIR /app

# Copy files from build directory to workdir
COPY go.mod go.sum ./
RUN go mod download

# Copy other things
COPY . .

# Disable c-libraries, define linux as an operationg system for our image
RUN CGO_ENABLED=0 GOOS=linux go build -o /money-tracker ./main.go

# -- FINAL IMAGE --
# Use the lightest image
FROM alpine:latest

# Define a working directory
WORKDIR /root/

# Copy only compiled binary file
COPY --from=builder /money-tracker .

# Declare port for our container
EXPOSE 8080

# Comand which will be activate after starring our container
CMD ["./money-tracker"]