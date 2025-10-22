FROM openjdk:17-alpine

WORKDIR /app

COPY . .

# Compile Java file
RUN javac OrderServiceApplication.java

EXPOSE 8080

CMD ["java", "OrderServiceApplication"]
