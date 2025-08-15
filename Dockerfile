# Sử dụng image JDK chính thức, nhẹ và ổn định
FROM eclipse-temurin:17-jdk

# Tạo thư mục trong container
WORKDIR /app

# Copy file JAR đã build vào container
COPY target/*.jar app.jar

# Mở port mà ứng dụng sử dụng
EXPOSE 8080

# Lệnh chạy app
ENTRYPOINT ["java", "-jar", "app.jar"]
