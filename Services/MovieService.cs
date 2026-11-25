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
        private const int ForeignKeyViolation = 547;
        private const int UniqueViolation = 2627;
        private const int UniqueIndexViolation = 2601;

        public List<Movie> GetAll()
        {
            var list = new List<Movie>();
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"SELECT MovieID, Title, DurationMin, Genre, Agerating, MovieStatus, ReleaseDate, PosterPath, MovieDescription
                  FROM MOVIE ORDER BY MovieID", conn);

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

            return list;
        }

        public void Save(Movie movie)
        {
            if (movie.MovieID == 0)
                Insert(movie);
            else
                Update(movie);
        }

        public void Insert(Movie movie)
        {
            using SqlConnection conn = Db.Open();
            using var cmd = new SqlCommand(
                @"INSERT INTO MOVIE (Title, DurationMin, Genre, Agerating, MovieStatus, ReleaseDate, PosterPath, MovieDescription)
                  VALUES (@Title, @DurationMin, @Genre, @AgeRating, @MovieStatus, @ReleaseDate, @PosterPath, @MovieDescription);
                  SELECT CAST(SCOPE_IDENTITY() AS INT);", conn);

            BindMovieParameters(cmd, movie);

            try
            {
                object? id = cmd.ExecuteScalar();
                if (id == null || id == DBNull.Value)
                    throw new InvalidOperationException("Không lấy được mã phim mới từ SQL Server.");
                movie.MovieID = Convert.ToInt32(id);
            }
            catch (SqlException ex) when (ex.Number == UniqueViolation || ex.Number == UniqueIndexViolation)
            {
                throw new InvalidOperationException("Phim này đã tồn tại trong hệ thống.", ex);
            }
            catch (SqlException ex) when (ex.Number == ForeignKeyViolation)
            {
                throw new InvalidOperationException("Dữ liệu độ tuổi, trạng thái hoặc thời lượng không đúng quy định của CSDL.", ex);
            }
        }

        public void Update(Movie movie)
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
            BindMovieParameters(cmd, movie);

            try
            {
                if (cmd.ExecuteNonQuery() == 0)
                    throw new InvalidOperationException("Không tìm thấy phim cần cập nhật trong CSDL.");
            }
            catch (SqlException ex) when (ex.Number == ForeignKeyViolation)
            {
                throw new InvalidOperationException("Dữ liệu độ tuổi, trạng thái hoặc thời lượng không đúng quy định của CSDL.", ex);
            }
        }

        public void Delete(int movieId)
        {
            using SqlConnection conn = Db.Open();

            // Kiểm tra trước khi xóa để thông báo rõ ràng
            using (var checkCmd = new SqlCommand("SELECT COUNT(*) FROM SHOWTIME WHERE MovieID = @MovieID", conn))
            {
                checkCmd.Parameters.Add("@MovieID", SqlDbType.Int).Value = movieId;
                int showtimeCount = (int)checkCmd.ExecuteScalar()!;
                if (showtimeCount > 0)
                    throw new InvalidOperationException("Không thể xóa: phim này đã có suất chiếu được xếp (ràng buộc khóa ngoại).");
            }

            using var cmd = new SqlCommand("DELETE FROM MOVIE WHERE MovieID = @MovieID", conn);
            cmd.Parameters.Add("@MovieID", SqlDbType.Int).Value = movieId;
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex) when (ex.Number == ForeignKeyViolation)
            {
                throw new InvalidOperationException("Không thể xóa: phim đang có dữ liệu ràng buộc trong CSDL.", ex);
            }
        }

        private static void BindMovieParameters(SqlCommand cmd, Movie movie)
        {
            cmd.Parameters.Add("@Title", SqlDbType.NVarChar, 200).Value = movie.Title;
            cmd.Parameters.Add("@DurationMin", SqlDbType.Int).Value = movie.DurationMin;
            cmd.Parameters.Add("@Genre", SqlDbType.NVarChar, 50).Value = string.IsNullOrWhiteSpace(movie.Genre) ? DBNull.Value : movie.Genre;
            cmd.Parameters.Add("@AgeRating", SqlDbType.NVarChar, 30).Value = (object?)movie.AgeRating ?? DBNull.Value;
            cmd.Parameters.Add("@MovieStatus", SqlDbType.NVarChar, 30).Value = (object?)movie.MovieStatus ?? DBNull.Value;
            cmd.Parameters.Add("@ReleaseDate", SqlDbType.Date).Value = (object?)movie.ReleaseDate ?? DBNull.Value;
            cmd.Parameters.Add("@PosterPath", SqlDbType.NVarChar, 260).Value = string.IsNullOrWhiteSpace(movie.PosterPath) ? DBNull.Value : movie.PosterPath;
            cmd.Parameters.Add("@MovieDescription", SqlDbType.NVarChar, 1000).Value = string.IsNullOrWhiteSpace(movie.MovieDescription) ? DBNull.Value : movie.MovieDescription;
        }
    }
}
