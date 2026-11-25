using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Threading;
using CinemaAPP.Helpers;
using CinemaAPP.Models;
using CinemaAPP.ViewModels;

namespace CinemaAPP.Views
{
    public partial class RoomManagementView : UserControl
    {
        private readonly DispatcherTimer _liveTimer;

        public RoomManagementView()
        {
            InitializeComponent();
            _liveTimer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(3) };
            _liveTimer.Tick += async (_, _) =>
            {
                if (DataContext is RoomManagementViewModel vm)
                    await vm.RefreshLiveAsync();
            };

            Loaded += async (_, _) =>
            {
                CinemaSync.BookingsChanged += OnExternalDataChanged;
                CinemaSync.RoomsChanged += OnExternalDataChanged;
                _liveTimer.Start();
                if (DataContext is RoomManagementViewModel vm)
                    await vm.RefreshLiveAsync();
            };

            Unloaded += (_, _) =>
            {
                _liveTimer.Stop();
                CinemaSync.BookingsChanged -= OnExternalDataChanged;
                CinemaSync.RoomsChanged -= OnExternalDataChanged;
            };
        }

        private void OnExternalDataChanged()
        {
            Dispatcher.BeginInvoke(async () =>
            {
                if (DataContext is RoomManagementViewModel vm)
                    await vm.RefreshLiveAsync();
            });
        }

        private void RoomCard_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            // Bỏ qua nếu người dùng bấm vào các nút hành động (Sửa / Xóa / Xem sơ đồ)
            if (HasButtonAncestor(e.OriginalSource as DependencyObject))
                return;

            if (sender is FrameworkElement { DataContext: Room room }
                && DataContext is RoomManagementViewModel vm
                && vm.ViewSeatMapCommand.CanExecute(room))
            {
                vm.ViewSeatMapCommand.Execute(room);
            }
        }

        private static bool HasButtonAncestor(DependencyObject? source)
        {
            while (source != null)
            {
                if (source is Button) return true;
                source = VisualTreeHelper.GetParent(source);
            }
            return false;
        }
    }
}
