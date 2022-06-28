abstract class LoginStates{}

class LoginInitialState extends LoginStates{}

class LoginSuccessState extends LoginStates{}

class LoginLoadingState extends LoginStates{}

class LoginErrorState extends LoginStates{
  late String error;
  LoginErrorState(String error){this.error = error;}
}

class ShownPassword extends LoginStates{}

class NotShownPassword extends LoginStates{}