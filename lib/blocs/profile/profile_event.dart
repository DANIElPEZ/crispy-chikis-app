abstract class ProfileEvent{}

class registerUser extends ProfileEvent{
  final String name;
  final String email;
  final String password;
  final String phone;
  final bool isChecked;
  registerUser(this.name, this.email, this.password, this.phone, this.isChecked);
}

class updateUser extends ProfileEvent{
  final String name;
  final String email;
  final String phone;
  updateUser(this.name, this.email, this.phone);
}

class loginUser extends ProfileEvent{
  final String email;
  final String password;
  loginUser(this.email, this.password);
}

class updatePassword extends ProfileEvent{
  final String password;
  updatePassword(this.password);
}

class loadUser extends ProfileEvent{}

class toggleRegister extends ProfileEvent{
  toggleRegister({required this.isRegister});
  final bool isRegister;
}

class logOut extends ProfileEvent{}