using System.Collections.ObjectModel;
using System.Windows.Input;
using CinemaAPP.Helpers;

namespace CinemaAPP.ViewModels
{
    public sealed class NavigationPage
    {
        public string Title { get; }
        public string Description { get; }

        public NavigationPage(string title, string description)
        {
            Title = title;
            Description = description;
        }
    }

    public sealed class MainViewModel : ObservableObject
    {
        private NavigationPage selectedPage = null!;

        public ObservableCollection<NavigationPage> Pages { get; } = new();
        public ICommand NavigateCommand { get; }

        public NavigationPage SelectedPage
        {
            get => selectedPage;
            set => SetProperty(ref selectedPage, value);
        }

        public MainViewModel()
        {
            Pages.Add(new NavigationPage("Tổng quan", "Chọn chức năng ở menu để bắt đầu."));
            Pages.Add(new NavigationPage("Quản lý phim", "Quản lý danh sách phim."));
            Pages.Add(new NavigationPage("Quản lý phòng", "Quản lý phòng và ghế."));
            Pages.Add(new NavigationPage("Suất chiếu", "Quản lý lịch chiếu."));
            Pages.Add(new NavigationPage("Bán vé", "Chọn suất chiếu và ghế."));
            Pages.Add(new NavigationPage("Tài khoản", "Quản lý tài khoản."));
            Pages.Add(new NavigationPage("Thống kê", "Xem báo cáo doanh thu."));

            NavigateCommand = new RelayCommand(parameter =>
            {
                if (parameter is NavigationPage page)
                    SelectedPage = page;
            });

            SelectedPage = Pages[0];
        }
    }
}