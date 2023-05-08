class SessionManager{
  static final SessionManager instance = SessionManager.internal();

  factory SessionManager() => instance;

  SessionManager.internal();

  String? sessionId;
  bool? isActive;

  void startSession(String sessionId){
    this.sessionId = sessionId;
    this.isActive = true;
  }

  void endSession(){
    this.sessionId = null;
    this.isActive = false;
  }

  String get getSessionId => sessionId!;
  bool get getIsActive => isActive!;
}