class ProfileState {
  ProfileState(
      {required this.name,
      required this.email,
      required this.password,
      required this.phone,
      required this.message,
      required this.isRegister,
      required this.isChecked});

  final String name;
  final String email;
  final String phone;
  final String password;
  final bool isChecked;
  final String message;
  final bool isRegister;

  factory ProfileState.initial() {
    return ProfileState(
        name: '',
        email: '',
        password: '',
        phone: '',
        message: '',
        isChecked: false,
        isRegister: false);
  }

  ProfileState copyWith(
      {String? name,
      String? email,
      String? password,
      String? phone,
      bool? isRegister,
      String? message,
      bool? isChecked}) {
    return ProfileState(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        message: message ?? this.message,
        isRegister: isRegister ?? this.isRegister,
        isChecked: isChecked ?? this.isChecked);
  }
}
