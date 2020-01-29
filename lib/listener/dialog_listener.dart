/*
  description:
  author:59432
  create_time:2020/1/29 17:25
*/

typedef OnConfirm = void Function();
typedef OnCancel = void Function();

class DialogListener {
  OnConfirm onConfirm;
  OnCancel onCancel;

  DialogListener({this.onConfirm, this.onCancel});
}