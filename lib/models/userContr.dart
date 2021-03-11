import 'package:newproject/authentication/auth_service.dart';
import 'package:newproject/models/user.dart';
import 'package:newproject/services/locator.dart';

class UserController{
  UserModel _currentUser;
  Future init;


  UserController(){
    init = initUser();
  }

  Future<UserModel> initUser()async{
    _currentUser = await getIt.get<AuthService>().getUserId();
    return _currentUser;
  }

  UserModel get currentUser => _currentUser;
}