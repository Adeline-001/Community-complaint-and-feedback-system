package com.example.util;

import io.jsonwebtoken.Claims;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class JwtUtilTest {

    @Test
    void generateToken_ShouldReturnValidJwtToken() {
        // Arrange
        String testEmail = "testuser@example.com";
        String testRole = "citizen";
        int testId = 123;

        // Act
        String token = JwtUtil.generateToken(testEmail, testRole, testId);

        // Assert
        assertThat(token).isNotNull();
        assertThat(token.split("\\.")).hasSize(3); // JWT should have 3 parts (Header.Payload.Signature)
    }

    @Test
    void validateTokenAndGetClaims_ShouldExtractCorrectInformation() {
        // Arrange
        String testEmail = "admin@example.com";
        String testRole = "admin";
        int testId = 456;
        String token = JwtUtil.generateToken(testEmail, testRole, testId);

        // Act
        Claims claims = JwtUtil.validateTokenAndGetClaims(token);

        // Assert
        assertThat(claims).isNotNull();
        assertThat(claims.getSubject()).isEqualTo(testEmail);
        assertThat(claims.get("role", String.class)).isEqualTo(testRole);
        assertThat(claims.get("id", Integer.class)).isEqualTo(testId);
    }

    @Test
    void validateTokenAndGetClaims_WithInvalidToken_ShouldReturnNull() {
        // Arrange
        String invalidToken = "eyJhbGciOiJIUzI1NiJ9.InvalidPayload.InvalidSignature";

        // Act
        Claims claims = JwtUtil.validateTokenAndGetClaims(invalidToken);

        // Assert
        assertThat(claims).isNull();
    }
}
