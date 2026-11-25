using System.IO;
using System.Windows;
using System.Windows.Controls;
using CinemaAPP.ViewModels;
using Microsoft.Win32;

namespace CinemaAPP.Views
{
    public partial class MovieManagementView : UserControl
    {
        public MovieManagementView()
        {
            InitializeComponent();
        }

        private void PickPoster_Click(object sender, RoutedEventArgs e)
        {
            if (DataContext is not MovieManagementViewModel vm) return;

            var dialog = new OpenFileDialog
            {
                Title = "Chọn ảnh poster phim",
                Filter = "Ảnh (*.jpg;*.jpeg;*.png;*.webp)|*.jpg;*.jpeg;*.png;*.webp|Tất cả (*.*)|*.*"
            };

            string assetsPosters = Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "Assets", "Posters");
            if (Directory.Exists(assetsPosters))
                dialog.InitialDirectory = assetsPosters;

            if (dialog.ShowDialog() == true)
            {
                // Nếu chọn file ngay trong Assets/Posters thì lưu tên file cho gọn, ngược lại lưu full path
                string dir = Path.GetDirectoryName(dialog.FileName) ?? "";
                vm.FormPosterPath = dir.EndsWith(Path.Combine("Assets", "Posters"), System.StringComparison.OrdinalIgnoreCase)
                    ? Path.GetFileName(dialog.FileName)
                    : dialog.FileName;
            }
        }
    }
}
