using System;
using System.Collections.Generic;
using System.Text;

namespace CinemaAPP.Models
{
    public class Account
    {
        public int AccountID { get; set; }
        public string Username { get; set; } = "";
        public string FullName { get; set; } = "";
        public string AccountRole { get; set; } = "";

        public bool IsAdmin => AccountRole == "Admin";

    }
}
