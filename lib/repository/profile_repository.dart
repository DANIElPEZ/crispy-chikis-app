import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crispychikis/repository/sqlite_helper.dart';
import 'package:bcrypt/bcrypt.dart';

class ProfileRepository{
  final client = Supabase.instance.client;
  DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> registerUser(Map<String, dynamic> user)async{
    try{
      String hashedPassword=BCrypt.hashpw(user['contrasena'], BCrypt.gensalt());
      user['contrasena']=hashedPassword;
      final userSupabase = await client
          .from('usuarios')
          .insert(user)
          .select();

      final Map<String, dynamic> userMap = {
        'usuario_id': userSupabase.first['usuario_id'],
        'nombre': userSupabase.first['nombre'],
        'email': userSupabase.first['email'],
        'telefono': userSupabase.first['telefono'],
      };

      await dbHelper.insertORupdate(userMap);
    }catch(e){
      print(e);
    }
  }

  Future<void> updateUser(Map<String, dynamic> user)async{
    final userSupabase = await client
        .from('usuarios')
        .update(user)
        .eq('email', user['email'])
        .select();

    final Map<String, dynamic> userMap = {
      'usuario_id': userSupabase.first['usuario_id'],
      'nombre': userSupabase.first['nombre'],
      'email': userSupabase.first['email'],
      'telefono': userSupabase.first['telefono'],
    };

    await dbHelper.insertORupdate(userMap);
  }

  Future<void> updatePassword(String password, String email)async{
    await client
        .from('usuarios')
        .update({'contrasena':password})
        .eq('email', email);
  }

  Future<void> login(String email, String password)async{
    final user = await client
        .from('usuarios')
        .select('usuario_id, nombre, email, telefono, contrasena')
        .eq('email', email);

    final isValid=BCrypt.checkpw(password, user.first['contrasena']);
    if(!isValid || user.isEmpty){
      throw Exception('Usuario y/o contraseña invalido.');
    }

    final Map<String, dynamic> userMap = {
      'usuario_id': user.first['usuario_id'],
      'nombre': user.first['nombre'],
      'email': user.first['email'],
      'telefono': user.first['telefono']
    };

    await dbHelper.insertORupdate(userMap);
  }

  Future<Map<String, dynamic>> loadUser()async{
    return await dbHelper.getUser();
  }

  Future<void> logOut()async{
    await dbHelper.deleteUser();
  }
}