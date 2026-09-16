package util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class HashUtil {

    public static String generarSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        // Use Base64 to represent the salt as string, but replace any non-alphanumeric just in case
        return Base64.getEncoder().encodeToString(salt).replaceAll("[^a-zA-Z0-9]", "").substring(0, 10);
    }

    public static String hashPassword(String password, String salt) {
        try {
            String input = password + salt;
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error al cifrar contraseña", e);
        }
    }
}
