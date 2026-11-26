using BCrypt.Net;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace CinemaAPP.Helpers
{
    public static class PasswordHasher
    {
        private const int SaltSize = 11;
        public static string Hash(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password, SaltSize);
        }
        public static bool Verify(string password, string hashedPassword)
        {
            try
            {
                return BCrypt.Net.BCrypt.Verify(password, hashedPassword);
            }
            catch (BCrypt.Net.SaltParseException)
            {
                return false;
            }
        }
    }
}
