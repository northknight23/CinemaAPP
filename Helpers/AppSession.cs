using CinemaAPP.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace CinemaAPP.Helpers
{
    public static class AppSession
    {
        public static Account? CurrentUser { get; set; }
        public static bool IsAdmin => CurrentUser?.IsAdmin == true;
        public static void Logout() => CurrentUser = null;
    }
}
