import 'package:get_it/get_it.dart';
import 'package:newproject/authentication/auth_service.dart';
import 'package:newproject/models/userContr.dart';

final getIt = GetIt.instance;

void setupServices(){
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<UserController>(UserController());
}