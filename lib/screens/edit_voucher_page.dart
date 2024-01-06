// ignore_for_file: use_build_context_synchronously

import '/apis/constants/utils.dart';
import '/apis/pdf_voucher.dart';
import '/db/fatoora_db.dart';
import '/models/vouchers.dart';
import '/screens/vouchers_page.dart';
import '/widgets/app_colors.dart';
import '/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import '../models/groups.dart';
import '../models/settings.dart';

class AddEditVoucherPage extends StatefulWidget {
  final Voucher? voucher;
  final String? type;

  const AddEditVoucherPage({
    super.key,
    this.voucher,
    this.type,
  });

  @override
  State<AddEditVoucherPage> createState() => _AddEditVoucherPageState();
}

class _AddEditVoucherPageState extends State<AddEditVoucherPage> {
  final _key1 = GlobalKey<FormState>();
  late int newId;
  late final Voucher voucher;
  late final String date;
  String numberInWord = '';
  String transType = '';
  String _selectedOption = '';
  final List<String> _options = [];

  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _numInWord = TextEditingController();
  final TextEditingController _voucherTo = TextEditingController();
  final TextEditingController _groupName = TextEditingController();

  final FocusNode focusNode = FocusNode();

  bool isLoading = false;
  int workOffline = 1;
  int curId = 1;
  num curAmount = 0.0;
  String curVoucherTo = '';
  String curDesc = '';
  String curName = '';
  String curDate = Utils.formatShortDate(DateTime.now());
  String curTime = Utils.formatTime(DateTime.now());
  String curType = '';

  @override
  void initState() {
    super.initState();
    getVoucher();
    focusNode.requestFocus();
  }

  Future getVoucher() async {
    try {
      setState(() => isLoading = true);
      switch (widget.type) {
        case 'RECEIPT':
          transType = 'سند قبض';
          break;
        case 'PAYMENT':
          transType = 'سند صرف';
          break;
        case 'EXPENSE':
          transType = 'تسجيل مصروفات';
          break;
        case 'DAMAGE':
          transType = 'تسجيل توالف';
          break;
        default:
          break;
      }
      _options.clear();
      await FatooraDB.instance.getAllGroups(widget.type!).then((list) {
        if (list.isNotEmpty) {
          for (int i = 0; i < list.length; i++) {
            _options.add(list[i].name);
          }
          _selectedOption = list[0].name;
        }
      });
      if (widget.voucher != null) {
        curId = widget.voucher!.id!;
        curAmount = widget.voucher!.amount;
        curVoucherTo = widget.voucher!.voucherTo;
        curDesc = widget.voucher!.desc;
        curName = widget.voucher!.name;
        curDate = widget.voucher!.date.substring(0, 10);
        curTime = widget.voucher!.date.substring(11, 16);
        curType = widget.voucher!.type;
        _amount.text = Utils.formatNoCurrency(curAmount);
        _numInWord.text =
            _amount.text.isEmpty ? '' : Utils.numToWord(_amount.text);
        _voucherTo.text = curVoucherTo;
        _desc.text = curDesc;
        _name.text = curName;
        _date.text = curDate;
        _time.text = curTime;
      } else {
        curId = (await FatooraDB.instance.getNewVoucherId())! + 1;
        _amount.text = '0.00';
        _voucherTo.text = '';
        _desc.text = '';
        _name.text = '';
        _date.text = curDate;
        _time.text = curTime;
      }

      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      messageBox(e.toString());
    }
  }

  void messageBox(String? message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('رسالة'),
          content: Text(message!),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("موافق"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addGroupName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.topCenter,
          content: TextFormField(
            controller: _groupName,
            autofocus: true,
            style: bodyStyle(),
            decoration: InputDecoration(
              // hintText: widget.type=='EXPENSE' ? 'أدخل نوع المصروف' : 'أدخل نوع التالف'
              labelText:
                  widget.type == 'EXPENSE' ? 'إضافة مصروف' : 'إضافة تالف',
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("حفظ"),
              onPressed: () async {
                if (_groupName.text.isNotEmpty) {
                  int newGroupId =
                      (await FatooraDB.instance.getNewGroupId())! + 1;
                  Group group = Group(
                      id: newGroupId,
                      type: widget.type!,
                      name: _groupName.text);
                  await FatooraDB.instance.createGroup(group);
                  _name.text = _groupName.text;
                  _options.clear();
                  await FatooraDB.instance
                      .getAllGroups(widget.type!)
                      .then((list) {
                    if (list.isNotEmpty) {
                      for (int i = 0; i < list.length; i++) {
                        _options.add(list[i].name);
                      }
                      _selectedOption = _groupName.text;
                    }
                  });
                  _groupName.clear();
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("إلغاء"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void dropDownBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.topCenter,
          scrollable: true,
          content: _options.isEmpty
              ? const Center(
                  child: Text('لا يوجد عناصر'),
                )
              : RadioGroup<String>.builder(
                  direction: Axis.vertical,
                  groupValue: _selectedOption,
                  onChanged: (value) => setState(() {
                    _selectedOption = value!;
                    _name.text = _selectedOption;
                    Navigator.of(context).pop();
                  }),
                  items: _options,
                  itemBuilder: (item) => RadioButtonBuilder(item),
                ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      child: const Text("أضف عنصر"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        addGroupName();
                      },
                    ),
                    TextButton(
                      child: const Text("إلغاء"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                _options.isEmpty
                    ? Container()
                    : TextButton(
                        child: const Text(
                          "حذف كل القائمة",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        onPressed: () async {
                          await FatooraDB.instance
                              .deleteAllGroups(widget.type!);
                          _options.clear();
                          await FatooraDB.instance
                              .getAllGroups(widget.type!)
                              .then((list) {
                            if (list.isNotEmpty) {
                              for (int i = 0; i < list.length; i++) {
                                _options.add(list[i].name);
                              }
                              _selectedOption = '';
                            }
                          });
                          Navigator.of(context).pop();
                        },
                      ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Center(
            child: Text(
              '$transType رقم $curId',
              style: const TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          actions: [
            // buildButtonSave(),
            widget.type == 'RECEIPT' || widget.type == 'PAYMENT'
                ? buildPrintPdf()
                : Container(),
            widget.type == 'RECEIPT' || widget.type == 'PAYMENT'
                ? Container()
                : buildButtonSave(),
          ],
        ),
        body: isLoading ? const Loading() : buildBody(),
      );

  Widget space(num count) => SizedBox(width: count * 5);

  Widget buildDateTime() {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: _date,
            readOnly: true,
            style: bodyStyle(),
            onTap: () => _selectDate(),
            decoration: const InputDecoration(
              labelText: 'التاريخ',
              suffixIcon: Icon(Icons.date_range),
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: TextFormField(
            controller: _time,
            readOnly: true,
            style: bodyStyle(),
            onTap: () => _selectTime(),
            decoration: const InputDecoration(
              labelText: 'الوقت',
              suffixIcon: Icon(Icons.access_time_rounded),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody() => Container(
        width: MediaQuery.of(context).size.width,
        // margin: const EdgeInsets.only(left: 10, right: 10),
        margin: const EdgeInsets.all(25),
        child: Form(
          key: _key1,
          child: Column(
            children: [
              buildDateTime(),
              widget.type == 'EXPENSE' || widget.type == 'DAMAGE'
                  ? buildName()
                  : buildVoucherTo(),
              Row(
                children: [
                  SizedBox(width: 120, child: buildAmount()),
                  Expanded(
                      child: TextFormField(
                    controller: _numInWord,
                    readOnly: true,
                    style: bodyStyle(),
                    decoration: const InputDecoration(labelText: 'فقط'),
                  )),
                ],
              ),
              buildDesc(),
/*
          Row(children: [
            Expanded(child: widget.type=='EXPENSE'||widget.type=='DAMAGE'? buildName() : buildVoucherTo()),
            // space(2),
            Expanded(child: buildDesc()),
          ],),
*/
            ],
          ),
        ),
      );

  TextStyle bodyStyle() => const TextStyle(
        color: AppColor.primary,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      );

  Widget buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColor.background,
          backgroundColor: AppColor.primary,
        ),
        onPressed: addOrUpdateVoucher,
        child: const Text('حفظ'),
      ),
    );
  }

  Widget buildPrintPdf() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColor.background,
          backgroundColor: AppColor.primary,
        ),
        onPressed: addOrUpdateVoucher,
        child: const Text('حفظ PDF'),
      ),
    );
  }

  Widget buildAmount() => TextFormField(
        controller: _amount,
        keyboardType: TextInputType.number,
        style: bodyStyle(),
        onTap: () {
          var textValue = _amount.text;
          _amount.selection = TextSelection(
            baseOffset: 0,
            extentOffset: textValue.length,
          );
        },
        onChanged: (value) {
          String formattedValue =
              value.isEmpty ? '' : Utils.formatNoCurrency(num.parse(value));
          setState(() {
            _numInWord.text =
                value.isEmpty ? '' : Utils.numToWord(formattedValue);
          });
        },
        decoration: const InputDecoration(labelText: 'المبلغ'),
      );

  Widget buildDesc() => TextFormField(
        controller: _desc,
        // autofocus: true,
        // readOnly: true,
        keyboardType: TextInputType.name,
        onTap: () => _desc.selection =
            TextSelection(baseOffset: 0, extentOffset: _desc.text.length),
        style: bodyStyle(),
        decoration: const InputDecoration(
          labelText: 'الشرح',
        ),
      );

  Widget buildName() => TextFormField(
        controller: _name,
        // autofocus: true,
        readOnly: true,
        keyboardType: TextInputType.name,
        onTap: () {
          if (_name.text.isNotEmpty) {
            _selectedOption = _name.text;
          }
          dropDownBox();
        },
        style: bodyStyle(),
        decoration: InputDecoration(
          labelText: widget.type == 'EXPENSE' ? 'نوع المصروف' : 'نوع التالف',
          suffixIcon: const Icon(Icons.search),
        ),
      );

  Widget buildVoucherTo() => TextFormField(
        controller: _voucherTo,
        // autofocus: true,
        // readOnly: true,
        keyboardType: TextInputType.name,
        onTap: () => _voucherTo.selection =
            TextSelection(baseOffset: 0, extentOffset: _voucherTo.text.length),
        style: bodyStyle(),
        decoration: InputDecoration(
          labelText: widget.type == 'RECEIPT' ? 'استلمنا من' : 'صرفنا إلى',
        ),
      );

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2055));
    if (picked != null) {
      setState(() => _date.text = Utils.formatShortDate(picked).toString());
    }
  }

  _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _time.text = picked.toString().substring(10, 15));
    }
  }

  Widget buildDate() => InkWell(
        onTap: () => _selectDate(),
        child: IgnorePointer(
          child: TextFormField(
            controller: _date,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            decoration: const InputDecoration(
              labelText: 'تاريخ القيد',
            ),
            // onChanged: onChangedPayer,
          ),
        ),
      );

  Widget buildTime() => InkWell(
        onTap: () => _selectTime(),
        child: IgnorePointer(
          child: TextFormField(
            controller: _time,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            decoration: const InputDecoration(
              labelText: 'وقت القيد',
            ),
            // onChanged: onChangedPayer,
          ),
        ),
      );

  /// To add/update voucher to database
  void addOrUpdateVoucher() async {
    {
      final isValid = _key1.currentState!.validate();

      if (isValid) {
        final isUpdating = widget.voucher != null;
        setState(() {
          isLoading = true;
        });
        if (isUpdating) {
          await updateVoucher();
        } else {
          await addVoucher();
        }
        setState(() {
          isLoading = false;
        });
        Get.to(() => VouchersPage(transactionType: widget.type));
        // Get.back();
      }
    }
  }

  Future updateVoucher() async {
    // int? newId = (await FatooraDB.instance.getNewVoucherId())! + 1;
    String? voucherId = widget.voucher?.id.toString();
    Voucher voucher = Voucher(
      id: widget.voucher?.id,
      date: '${_date.text} ${_time.text}',
      amount: num.parse(_amount.text.replaceAll(",", "")),
      voucherTo: _voucherTo.text,
      type: widget.type!,
      name: _name.text,
      desc: _desc.text,
    );
    await FatooraDB.instance.updateVoucher(voucher);
    if (widget.type == 'RECEIPT' || widget.type == 'PAYMENT') {
      List<Setting> settings = await FatooraDB.instance.getAllSettings();
      Setting setting = settings[0];
      PdfVoucher.generate(voucherId!, voucher, setting);
    }
  }

  Future addVoucher() async {
    int? newId = (await FatooraDB.instance.getNewVoucherId())! + 1;
    String voucherId = newId.toString();
    Voucher voucher = Voucher(
      date: '${_date.text} ${_time.text}',
      amount: num.parse(_amount.text.replaceAll(",", "")),
      voucherTo: _voucherTo.text,
      type: widget.type!,
      name: _name.text,
      desc: _desc.text,
    );
    await FatooraDB.instance.createVoucher(voucher);
    if (widget.type == 'RECEIPT' || widget.type == 'PAYMENT') {
      List<Setting> settings = await FatooraDB.instance.getAllSettings();
      Setting setting = settings[0];
      PdfVoucher.generate(voucherId, voucher, setting);
    }
  }
}
