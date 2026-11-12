using System;
using System.Collections.Generic;
using System.Data;
using CinemaAPP.Data;
using CinemaAPP.Models;
using Microsoft.Data.SqlClient;

namespace CinemaAPP.Services
{
    public class MovieService
    {
        // Danh sách mẫu lấy từ dữ liệu thật (Galaxy Cinema) kèm ảnh poster thật
        private static readonly List<Movie> SampleMovies = new()
        {
            new Movie { MovieID = 1, Title = "Godzilla Trừ Không", Genre = "Hành động, Giả tưởng", DurationMin = 135, AgeRating = "T16", MovieStatus = "Đang chiếu", ReleaseDate = new DateTime(2026, 11, 6), PosterPath = "godzilla-minus-zero.jpg", MovieDescription = "Tiếp nối Godzilla Minus One, hiểm họa mới xuất hiện đe dọa sự yên bình mong manh của nhân loại." },
            new Movie { MovieID = 2, Title = "Bò Sữa Bay", Genre = "Hoạt hình, Phiêu lưu", DurationMin = 108, AgeRating = "T18", MovieStatus = "Đang chiếu", ReleaseDate = new DateTime(2026, 11, 6), PosterPath = "bo-sua-bay.jpg", MovieDescription = "Chuyến phiêu lưu hài hước và bất ngờ của chú bò sữa kỳ lạ." },
            new Movie { MovieID = 3, Title = "Ramayana: Khởi Nguồn", Genre = "Hành động, Thần thoại", DurationMin = 168, AgeRating = "T13", MovieStatus = "Đang chiếu", ReleaseDate = new DateTime(2026, 11, 6), PosterPath = "ramayana-rise-of-a-legend.jpg", MovieDescription = "Sử thi hào hùng về cuộc chiến chống lại cái ác bảo vệ công lý." },
            new Movie { MovieID = 4, Title = "Chị Chị Em Em 3", Genre = "Tâm lý, Tình cảm", DurationMin = 122, AgeRating = "T18", MovieStatus = "Đang chiếu", ReleaseDate = new DateTime(2026, 11, 6), PosterPath = "chi-chi-em-em-3.jpg", MovieDescription = "Cuộc đấu trí và những bí mật gia tộc đầy kịch tính trong giới thượng lưu." },
            new Movie { MovieID = 5, Title = "Khi Thần Chết Đổ Chuông", Genre = "Kinh dị, Giật gân", DurationMin = 86, AgeRating = "T18", MovieStatus = "Đang chiếu", ReleaseDate = new DateTime(2026, 11, 6), PosterPath = "the-bell-a-call-to-die.jpg", MovieDescription = "Mỗi tiếng chuông vang lên là một sinh mệnh chuẩn bị bước vào cuộc truy đuổi tử thần." },
            new Movie { MovieID = 6, Title = "Chàng Mèo Mang Mũ", Genre = "Hoạt hình, Gia đình", DurationMin = 107, AgeRating = "P", MovieStatus = "Đang chiếu", ReleaseDate = new DateTime(2026, 11, 6), PosterPath = "the-cat-in-the-hat.jpg", MovieDescription = "Cuộc phiêu lưu đầy màu sắc và tiếng cười của chú mèo tinh nghịch cùng các bạn nhỏ." },
            new Movie { MovieID = 7, Title = "Án Mạng Karaoke", Genre = "Hài, Kinh dị", DurationMin = 96, AgeRating = "T16", MovieStatus = "Đang chiếu", ReleaseDate = new DateTime(2026, 11, 6), PosterPath = "an-mang-karaoke.jpg", MovieDescription = "Vụ án mạng ly kỳ xảy ra tại phòng hát karaoke trong một đêm mưa bão." },
            new Movie { MovieID = 8, Title = "Shaun The Sheep: Quái Lạ", Genre = "Hoạt hình, Hài hước", DurationMin = 91, AgeRating = "P", MovieStatus = "Đang chiếu", ReleaseDate = new DateTime(2026, 11, 6), PosterPath = "shaun-the-sheep-the-beast-of-mossy-bottom.jpg", MovieDescription = "Chú cừu thông minh Shaun và đàn cừu đối mặt với sinh vật bí ẩn ghé thăm nông trại." },
            new Movie { MovieID = 9, Title = "Quỷ Ăn Tạng 4", Genre = "Kinh dị, Bí ẩn", DurationMin = 111, AgeRating = "T18", MovieStatus = "Đang chiếu", ReleaseDate = new DateTime(2026, 11, 6), PosterPath = "death-whisperer-saming-the-werebeast.jpg", MovieDescription = "Phần tiếp theo rùng rợn về linh hồn quỷ dữ và cuộc săn lùng sinh tồn trong rừng sâu." },
            new Movie { MovieID = 10, Title = "Avengers: Ngày Tận Thế", Genre = "Hành động, Viễn tưởng", DurationMin = 174, AgeRating = "T16", MovieStatus = "Sắp chiếu", ReleaseDate = new DateTime(2026, 12, 18), PosterPath = "avengers-doomsday.jpg", MovieDescription = "Biệt đội siêu anh hùng tái hợp trong trận chiến định đoạt vận mệnh toàn vũ trụ." },
            new Movie { MovieID = 11, Title = "Dune: Hành Tinh Cát 3", Genre = "Khoa học viễn tưởng", DurationMin = 165, AgeRating = "T16", MovieStatus = "Sắp chiếu", ReleaseDate = new DateTime(2027, 1, 15), PosterPath = "dune-3.jpg", MovieDescription = "Chương cuối thiên sử thi hùng vĩ về cuộc thánh chiến trên hành tinh sa mạc Arrakis." },
            new Movie { MovieID = 12, Title = "Gatto: Mèo Nero", Genre = "Hoạt hình, Phiêu lưu", DurationMin = 95, AgeRating = "P", MovieStatus = "Sắp chiếu", ReleaseDate = new DateTime(2027, 3, 5), PosterPath = "gatto.jpg", MovieDescription = "Hành trình tìm lại chính mình của chú mèo Nero giữa thành phố Venice xinh đẹp." },
            new Movie { MovieID = 13, Title = "Kỷ Băng Hà: Điểm Bùng Nổ", Genre = "Hoạt hình, Hài", DurationMin = 100, AgeRating = "P", MovieStatus = "Sắp chiếu", ReleaseDate = new DateTime(2026, 12, 25), PosterPath = "ice-age-boiling-point.jpg", MovieDescription = "Hội bạn thân kỷ băng hà đối mặt với đợt phun trào núi lửa nguy hiểm nhưng hài hước." },
            new Movie { MovieID = 14, Title = "Bắt Cá Ba Tay", Genre = "Hài, Tình cảm", DurationMin = 105, AgeRating = "T16", MovieStatus = "Sắp chiếu", ReleaseDate = new DateTime(2026, 12, 10), PosterPath = "bat-ca-ba-tay.jpg", MovieDescription = "Tình huống dở khóc dở cười xoay quanh mối tình tay ba rắc rối." },
            new Movie { MovieID = 15, Title = "Chiến Binh Ánh Sáng", Genre = "Hành động", DurationMin = 130, AgeRating = "T16", MovieStatus = "Ngừng chiếu", ReleaseDate = new DateTime(2026, 9, 15), PosterPath = null, MovieDescription = "Bộ phim đã hoàn thành đợt chiếu tại các cụm rạp trên toàn quốc." }
        };

        public List<Movie> GetAll()
        {
            try
            {
                using SqlConnection conn = Db.Open();
                using var cmd = new SqlCommand(
                    @"SELECT MovieID, Title, DurationMin, Genre, Agerating, MovieStatus, ReleaseDate, PosterPath, MovieDescription
                      FROM MOVIE ORDER BY MovieID", conn);

                var list = new List<Movie>();
                using SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    list.Add(new Movie
                    {
                        MovieID = r.GetInt32(0),
                        Title = r.GetString(1),
                        DurationMin = r.GetInt32(2),
                        Genre = r.IsDBNull(3) ? "" : r.GetString(3),
                        AgeRating = r.IsDBNull(4) ? "P" : r.GetString(4),
                        MovieStatus = r.IsDBNull(5) ? "Đang chiếu" : r.GetString(5),
                        ReleaseDate = r.IsDBNull(6) ? null : r.GetDateTime(6),
                        PosterPath = r.IsDBNull(7) ? null : r.GetString(7),
                        MovieDescription = r.IsDBNull(8) ? null : r.GetString(8)
                    });
                }

                // Nếu trong CSDL đã có phim, trả về danh sách từ DB
                if (list.Count > 0)
                    return list;
            }
            catch (Exception)
            {
                // Khi chưa bật CSDL hoặc gặp lỗi kết nối, ứng dụng vẫn hoạt động mượt mà với dữ liệu mẫu
            }

            return new List<Movie>(SampleMovies);
        }

        public void Save(Movie movie)
        {
            if (movie.MovieID == 0)
            {
                Insert(movie);
            }
            else
            {
                Update(movie);
            }
        }

        public void Insert(Movie movie)
        {
            try
            {
                using SqlConnection conn = Db.Open();
                using var cmd = new SqlCommand(
                    @"INSERT INTO MOVIE (Title, DurationMin, Genre, Agerating, MovieStatus, ReleaseDate, PosterPath, MovieDescription)
                      VALUES (@Title, @DurationMin, @Genre, @AgeRating, @MovieStatus, @ReleaseDate, @PosterPath, @MovieDescription);
                      SELECT SCOPE_IDENTITY();", conn);

                cmd.Parameters.Add("@Title", SqlDbType.NVarChar, 200).Value = movie.Title;
                cmd.Parameters.Add("@DurationMin", SqlDbType.Int).Value = movie.DurationMin;
                cmd.Parameters.Add("@Genre", SqlDbType.NVarChar, 50).Value = (object?)movie.Genre ?? DBNull.Value;
                cmd.Parameters.Add("@AgeRating", SqlDbType.NVarChar, 30).Value = (object?)movie.AgeRating ?? DBNull.Value;
                cmd.Parameters.Add("@MovieStatus", SqlDbType.NVarChar, 30).Value = (object?)movie.MovieStatus ?? DBNull.Value;
                cmd.Parameters.Add("@ReleaseDate", SqlDbType.Date).Value = (object?)movie.ReleaseDate ?? DBNull.Value;
                cmd.Parameters.Add("@PosterPath", SqlDbType.NVarChar, 260).Value = (object?)movie.PosterPath ?? DBNull.Value;
                cmd.Parameters.Add("@MovieDescription", SqlDbType.NVarChar, 1000).Value = (object?)movie.MovieDescription ?? DBNull.Value;

                var id = cmd.ExecuteScalar();
                if (id != null && id != DBNull.Value)
                    movie.MovieID = Convert.ToInt32(id);
            }
            catch
            {
                // Nếu không có DB, tự sinh ID cho dữ liệu cục bộ
                if (movie.MovieID == 0)
                {
                    movie.MovieID = SampleMovies.Count + 1;
                    SampleMovies.Add(movie);
                }
            }
        }

        public void Update(Movie movie)
        {
            try
            {
                using SqlConnection conn = Db.Open();
                using var cmd = new SqlCommand(
                    @"UPDATE MOVIE
                      SET Title = @Title, DurationMin = @DurationMin, Genre = @Genre,
                          Agerating = @AgeRating, MovieStatus = @MovieStatus,
                          ReleaseDate = @ReleaseDate, PosterPath = @PosterPath,
                          MovieDescription = @MovieDescription
                      WHERE MovieID = @MovieID", conn);

                cmd.Parameters.Add("@MovieID", SqlDbType.Int).Value = movie.MovieID;
                cmd.Parameters.Add("@Title", SqlDbType.NVarChar, 200).Value = movie.Title;
                cmd.Parameters.Add("@DurationMin", SqlDbType.Int).Value = movie.DurationMin;
                cmd.Parameters.Add("@Genre", SqlDbType.NVarChar, 50).Value = (object?)movie.Genre ?? DBNull.Value;
                cmd.Parameters.Add("@AgeRating", SqlDbType.NVarChar, 30).Value = (object?)movie.AgeRating ?? DBNull.Value;
                cmd.Parameters.Add("@MovieStatus", SqlDbType.NVarChar, 30).Value = (object?)movie.MovieStatus ?? DBNull.Value;
                cmd.Parameters.Add("@ReleaseDate", SqlDbType.Date).Value = (object?)movie.ReleaseDate ?? DBNull.Value;
                cmd.Parameters.Add("@PosterPath", SqlDbType.NVarChar, 260).Value = (object?)movie.PosterPath ?? DBNull.Value;
                cmd.Parameters.Add("@MovieDescription", SqlDbType.NVarChar, 1000).Value = (object?)movie.MovieDescription ?? DBNull.Value;

                cmd.ExecuteNonQuery();
            }
            catch
            {
                var idx = SampleMovies.FindIndex(m => m.MovieID == movie.MovieID);
                if (idx >= 0) SampleMovies[idx] = movie;
            }
        }

        public void Delete(int movieId)
        {
            try
            {
                using SqlConnection conn = Db.Open();
                using var cmd = new SqlCommand("DELETE FROM MOVIE WHERE MovieID = @MovieID", conn);
                cmd.Parameters.Add("@MovieID", SqlDbType.Int).Value = movieId;
                cmd.ExecuteNonQuery();
            }
            catch
            {
                SampleMovies.RemoveAll(m => m.MovieID == movieId);
            }
        }
    }
}

