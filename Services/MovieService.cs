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
        public List<Movie> GetAll()
        {
            var list = new List<Movie>();
            try
            {
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
            }
            catch (Exception)
            {
                // Khi không kết nối được CSDL hoặc bảng MOVIE rỗng, trả về danh sách rỗng
            }

            return list;
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
            }
        }
    }
}
