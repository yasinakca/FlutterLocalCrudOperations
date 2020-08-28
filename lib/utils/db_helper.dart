class DbHelper{
  static DbHelper _dbHelper;

  DbHelper.internal();
  
  factory DbHelper(){
    if(_dbHelper == null) {
      _dbHelper = DbHelper.internal();
      return _dbHelper;
    }else {
      return _dbHelper;
    }
  }
}