package com.example.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    // Generate a secure BCrypt hash of the plaintext password
    public static String hashPassword(String plainTextPassword) {
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(12));
    }

    // Check if the provided plaintext password matches the stored BCrypt hash
    public static boolean checkPassword(String plainTextPassword, String hashedPassword) {
        if (hashedPassword == null || !hashedPassword.startsWith("$2a$")) {
            return false;
        }
        return BCrypt.checkpw(plainTextPassword, hashedPassword);
    }
}
