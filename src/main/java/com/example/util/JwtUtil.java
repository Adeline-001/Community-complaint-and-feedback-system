package com.example.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

import java.security.Key;
import java.util.Date;

public class JwtUtil {
    // 256-bit secret key for HS256 algorithm (Load from environment variables for
    // production security)
    private static final String SECRET_KEY_STRING = System.getenv("JWT_SECRET") != null
            ? System.getenv("JWT_SECRET")
            : "MySuperSecretKeyForCommunityComplaintSystem2026";
    private static final Key SECRET_KEY = Keys.hmacShaKeyFor(SECRET_KEY_STRING.getBytes());

    // Token validity: 24 hours
    private static final long EXPIRATION_TIME = 86400000;

    public static String generateToken(String email, String role, int id) {
        return Jwts.builder()
                .setSubject(email)
                .claim("role", role)
                .claim("id", id)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                .signWith(SECRET_KEY, SignatureAlgorithm.HS256)
                .compact();
    }

    public static Claims validateTokenAndGetClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            System.err.println("[JWT ERROR] Token validation failed: " + e.getMessage());
            return null;
        }
    }
}
