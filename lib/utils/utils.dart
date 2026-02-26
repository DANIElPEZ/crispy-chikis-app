bool sanitizeName(String name) {
  name = name.trim();
  final RegExp regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
  return regex.hasMatch(name);
}

bool sanitizeEmail(String email) {
  email = email.trim();
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

bool sanitizePhone(String phone) {
  phone=phone.trim();
  final RegExp regex = RegExp(r'^\+\d{1,3}\s\d{10}$');
  return regex.hasMatch(phone);
}

bool sanitizePassword(String password){
  password=password.trim();
  final RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#_-])[A-Za-z\d@$!%*?&.#_-]{8,}$');
  return passwordRegex.hasMatch(password);
}

bool sanitizeDirection(String direction) {
  direction = direction.trim();
  final RegExp regex = RegExp(r'^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s#,.\/º°-]+$');
  return regex.hasMatch(direction);
}

bool sanitizeDescription(String description) {
  description = description.trim();
  final RegExp regex = RegExp(r'^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s ,.-]+$');
  return regex.hasMatch(description);
}