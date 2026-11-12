using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace CinemaAPP.Helpers
{
    public static class PasswordHasher
    {
        public static string Hash(string password)
        {
            byte[] bytes = SHA256.HashData(Encoding.UTF8.GetBytes(password));
            return Convert.ToHexString(bytes).ToLowerInvariant();
        }
    }
}
