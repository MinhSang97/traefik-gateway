import java.io.*;
import java.net.*;
import java.util.*;
import java.util.concurrent.*;
import java.time.*;
import java.time.format.DateTimeFormatter;

public class OrderServiceApplication {
    private static final int PORT = 8080;
    
    public static void main(String[] args) {
        System.out.println("🚀 Starting Java Order Service on port " + PORT);
        
        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            System.out.println("✅ Order Service is running on port " + PORT);
            
            while (true) {
                Socket clientSocket = serverSocket.accept();
                new Thread(() -> handleRequest(clientSocket)).start();
            }
        } catch (IOException e) {
            System.err.println("❌ Error starting server: " + e.getMessage());
        }
    }
    
    private static void handleRequest(Socket clientSocket) {
        try (BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
             PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)) {
            
            String requestLine = in.readLine();
            if (requestLine == null) return;
            
            String[] parts = requestLine.split(" ");
            String method = parts[0];
            String path = parts[1];
            
            String response = handleRequest(method, path);
            
            out.println("HTTP/1.1 200 OK");
            out.println("Content-Type: application/json");
            out.println("Access-Control-Allow-Origin: *");
            out.println("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
            out.println("Access-Control-Allow-Headers: Content-Type, Authorization");
            out.println("Connection: close");
            out.println();
            out.println(response);
            
        } catch (IOException e) {
            System.err.println("Error handling request: " + e.getMessage());
        } finally {
            try {
                clientSocket.close();
            } catch (IOException e) {
                System.err.println("Error closing socket: " + e.getMessage());
            }
        }
    }
    
    private static String handleRequest(String method, String path) {
        if (path.equals("/health")) {
            String timestamp = Instant.now().toString();
            return "{\"status\":\"healthy\",\"service\":\"order-service\",\"timestamp\":\"" + timestamp + "\"}";
        }
        
        if (path.equals("/orders/") || path.equals("/orders")) {
            return "[{\"id\":1,\"orderNumber\":\"ORD-001\",\"total\":150.00,\"status\":\"PENDING\"}," +
                   "{\"id\":2,\"orderNumber\":\"ORD-002\",\"total\":299.99,\"status\":\"COMPLETED\"}," +
                   "{\"id\":3,\"orderNumber\":\"ORD-003\",\"total\":75.50,\"status\":\"SHIPPED\"}]";
        }
        
        if (path.startsWith("/orders/") && path.length() > 8) {
            String id = path.substring(8);
            return "{\"id\":" + id + ",\"orderNumber\":\"ORD-" + String.format("%03d", Integer.parseInt(id)) + "\",\"total\":99.99,\"status\":\"PENDING\"}";
        }
        
        return "{\"message\":\"Order Service is running\",\"service\":\"order-service\"}";
    }
}
