package DATN.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import javax.sql.DataSource;
import java.net.InetAddress;

@Configuration
public class DataSourceConfig {

    @Bean
    public DataSource dataSource() {
        String[] urls = {
                "jdbc:sqlserver://26.142.28.217:1433;databaseName=DATN_WebBHDT;encrypt=false",
                "jdbc:sqlserver://localhost:1433;databaseName=DATN_WebBHDT;encrypt=false"
        };

        String username = "DEV_BACKEND";
        String password = "DEV";

        for (String url : urls) {
            try {
                String host = url
                        .replace("jdbc:sqlserver://", "")
                        .split(";")[0]
                        .split(":")[0];

                InetAddress inet = InetAddress.getByName(host);
                if (!inet.isReachable(1000)) {
                    System.out.println("⚠️ Host không khả dụng: " + host);
                    continue;
                }

                // Tạo DataSource và kiểm tra kết nối
                DriverManagerDataSource dataSource = new DriverManagerDataSource();
                dataSource.setUrl(url);
                dataSource.setUsername(username);
                dataSource.setPassword(password);
                dataSource.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

                // ✅ Kiểm tra kết nối 1 lần
                dataSource.getConnection().close();
                System.out.println("✅ Kết nối thành công với: " + url);

                return dataSource;

            } catch (Exception e) {
                System.out.println("❌ Không kết nối được với: " + url + " - " + e.getMessage());
            }
        }

        throw new RuntimeException("❗Không thể kết nối SQL Server bằng bất kỳ URL nào.");
    }
}
