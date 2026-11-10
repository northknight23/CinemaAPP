using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace CinemaAPP.Helpers
{
    // Lớp cha cho mọi Model và ViewModel: lo phần "báo cho giao diện biết dữ liệu đã đổi".
    public abstract class ObservableObject : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler? PropertyChanged;

        protected void OnPropertyChanged([CallerMemberName] string? propertyName = null)
            => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));

        // Gán giá trị mới cho field; nếu khác giá trị cũ thì báo PropertyChanged và trả về true.
        protected bool SetProperty<T>(ref T field, T value, [CallerMemberName] string? propertyName = null)
        {
            if (EqualityComparer<T>.Default.Equals(field, value)) return false;
            field = value;
            OnPropertyChanged(propertyName);
            return true;
        }
    }
}
