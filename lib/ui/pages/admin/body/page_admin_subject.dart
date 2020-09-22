import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';
import 'package:loveli_core/loveli_core.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';
import 'state_admin_subject.dart';

import '../table/table.dart';

class PageAdminSubject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ProviderWidget(
        model: StateAdminSubject(globalUser: Provider.of(context)),
        onModelReady: (StateAdminSubject model) => model.loadSubjects(),
        builder: (context, StateAdminSubject state, child) {
          if (state.viewState == ViewState.busy) {
            return ViewStateBusyWidget();
          }
          List subjects = state.subjects.map((e) => e.toMap()).toList();
          return ResponsiveDatable(
            headers: [
              DatableHeader(
                text: 'ID',
                value: 'id',
                show: true,
                textAlign: TextAlign.center,
              ),
              DatableHeader(
                text: '标题',
                value: 'name',
                show: true,
                textAlign: TextAlign.center,
              ),
              DatableHeader(
                  text: '操作',
                  textAlign: TextAlign.center,
                  sourceBuilder: (value, raw) {
                    int index = subjects.indexOf(raw);
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      children: [
                        GFButton(
                          text: '删除',
                          onPressed: () {
                            state.deleteSubject(state.subjects[index], context);
                          },
                          shape: GFButtonShape.pills,
                          size: GFSize.SMALL,
                        ),
                        GFButton(
                          text: '编辑',
                          onPressed: () {},
                          shape: GFButtonShape.pills,
                          size: GFSize.SMALL,
                        )
                      ],
                    );
                  })
            ],
            source: subjects,
            showSelect: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      OutlineButton(
                        child: Text('+ 添加分类'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  width: 400,
                                  height: 280,
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          '添加 Subject',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        margin: EdgeInsets.only(bottom: 20),
                                      ),
                                      TextField(
                                        onChanged: (text) {
                                          state.setName(text);
                                        },
                                        decoration: InputDecoration(
                                          labelText: '输入标题',
                                        ),
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                          labelText: '输入描述',
                                        ),
                                        onChanged: (text) {
                                          state.setRemarks(text);
                                        },
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: OutlineButton(
                                          child: Text('提交'),
                                          onPressed: () async {
                                            var response = await state.createSubject(context);
                                            if (response != null) {
                                              showToast('创建成功', context: context);
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: Text(
                    '分类列表',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              ],
            ),
            footer: Container(
              padding: EdgeInsets.only(right: 20, top: 5, bottom: 15),
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 10,
                children: [
                  OutlineButton(
                    child: Text('上一页'),
                    onPressed: () {},
                  ),
                  OutlineButton(
                    child: Text('下一页'),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
