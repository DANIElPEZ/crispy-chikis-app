import 'package:crispychikis/blocs/profile/profile_event.dart';
import 'package:crispychikis/blocs/profile/profile_state.dart';
import 'package:crispychikis/repository/profile_repository.dart';
import 'package:crispychikis/utils/utils.dart';
import 'package:bloc/bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository})
      : super(ProfileState.initial()) {
    on<registerUser>((event, emit) async {
      if (!sanitizeEmail(event.email)) {
        emit(state.copyWith(message: 'email incorrecto'));
      }
      if (!sanitizeName(event.name)) {
        emit(state.copyWith(message: '${state.message}\nnombre incorrecto'));
      }
      if (!sanitizePhone(event.phone)) {
        emit(state.copyWith(
            message: '${state.message}\ntelefono incorrecto'));
      }
      if (!sanitizePassword(event.password)) {
        emit(state.copyWith(
            message:
                '${state.message}\ncontraseña incorrecta'));
      }

      final Map<String, dynamic> user = {
        'nombre': event.name,
        'email': event.email,
        'telefono': event.phone,
        'acepto': event.isChecked?1:2,
        'contrasena': event.password
      };

      try {
        if(!event.isChecked) throw Exception('Debes aceptar las políticas.');
        if(event.name.isEmpty || event.phone.isEmpty || event.email.isEmpty || event.password.isEmpty) throw Exception('Debes llenar todos los campos.');
        await profileRepository.registerUser(user);
        add(loadUser());
        emit(state.copyWith(message: ''));
      } catch (e) {
        emit(state.copyWith(message: e is Exception ? e.toString().replaceAll('Exception: ', ''):'Error al registrarse.'));
      }
    });

    on<updateUser>((event, emit) async {
      if (!sanitizeEmail(event.email)) {
        emit(state.copyWith(message: 'email incorrecto'));
      }
      if (!sanitizeName(event.name)) {
        emit(state.copyWith(message: '${state.message}\nnombre incorrecto'));
      }
      if (!sanitizePhone(event.phone)) {
        emit(state.copyWith(
            message: '${state.message}\ntelefono incorrecto'));
      }

      final Map<String, dynamic> user = {
        'nombre': event.name,
        'email': event.email,
        'telefono': event.phone
      };

      try {
        await profileRepository.updateUser(user);
        add(loadUser());
      } catch (e) {
        emit(state.copyWith(message: 'Error al actualizar.'));
      }
    });

    on<updatePassword>((event, emit) async {
      if (!sanitizePassword(event.password)) {
        emit(state.copyWith(message: 'contraseña incorrecta'));
      }

      try {
        await profileRepository.updatePassword(event.password, state.email);
        emit(state.copyWith(message: ''));
      } catch (e) {
        emit(state.copyWith(message: 'Error al actualizar.'));
      }
    });

    on<loadUser>((event, emit) async {
      try {
        final result = await profileRepository.loadUser();
        emit(state.copyWith(
            name: result['nombre'], email: result['email'], phone: result['telefono'], message: ''));
      } catch (e) {
        print(e);
      }
    });

    on<loginUser>((event, emit) async {
      if (sanitizeEmail(event.email) && sanitizePassword(event.password)) {
        try{
          await profileRepository.login(event.email, event.password);
          add(loadUser());
          emit(state.copyWith(message: ''));
        }catch(e){
          emit(state.copyWith(message: 'Usuario y/o contraseña invalidos.'));
        }
      }
    });

    on<toggleRegister>((event, emit){
      emit(state.copyWith(isRegister: event.isRegister, message: ''));
    });

    on<logOut>((event, emit)async{
      await profileRepository.logOut();
      emit(state.copyWith(name: '',phone: '', email: '', isRegister: false));
    });
  }
}
