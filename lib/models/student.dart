class Student{
  int _id;
  String _name;
  int _isActive;

  Student(this._name, this._isActive);
  Student.withId(this._id, this._name, this._isActive);

  int get isActive => _isActive;

  set isActive(int value) {
    _isActive = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  //nesneleri dbye yazmak metodu
  Map<String,dynamic> toMap() {
    Map<String,dynamic> map = Map();
    map["id"] = this._id;
    map["name"] = this._name;
    map["isActive"] = this._isActive;
    return map;
  }

  Student.fromMap(Map<String,dynamic> map){
    this._id = map["id"];
    this._name = map["name"];
    this._isActive = map["isActive"];
  }
}