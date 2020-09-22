import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';
import 'package:loveli_core/loveli_core.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:boke/model/model.dart';
import 'state_admin_article.dart';
import 'state_admin_article_add.dart';

import '../table/table.dart';

class PageAdminArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ProviderWidget(
        model: StateAdminArticle(globalUser: Provider.of(context)),
        onModelReady: (StateAdminArticle model) => model.loadTopics(),
        builder: (context, StateAdminArticle state, child) {
          if (state.viewState == ViewState.busy) {
            return ViewStateBusyWidget();
          }
          List tags = state.topics.map((e) => e.toMap()).toList();
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
                value: 'title',
                show: true,
                textAlign: TextAlign.center,
              ),
              DatableHeader(
                text: '分类',
                value: 'subject',
                show: true,
                textAlign: TextAlign.center,
                sourceBuilder: (value, raw) {
                  return Text(
                    value['name'],
                    textAlign: TextAlign.center,
                  );
                },
              ),
              DatableHeader(
                text: '标签',
                value: 'tags',
                show: true,
                textAlign: TextAlign.center,
                sourceBuilder: (value, raw) {
                  List tags = ValueUtil.toList(value);
                  if (tags.length > 0) {
                    return Wrap(
                      children: tags.map((e) => Text(ValueUtil.toStr(e['name']))).toList(),
                    );
                  } else {
                    return Text(
                      '无',
                      textAlign: TextAlign.center,
                    );
                  }
                },
              ),
              DatableHeader(
                  text: '操作',
                  textAlign: TextAlign.center,
                  sourceBuilder: (value, raw) {
                    int index = tags.indexOf(raw);
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      children: [
                        GFButton(
                          text: '删除',
                          onPressed: () {
                            state.deleteTopic(state.topics[index], context);
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
            source: tags,
            showSelect: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      OutlineButton(
                        child: Text('+ 添加文章'),
                        onPressed: () {
                          _showAddForm(context, state);
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
                    '文章列表',
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

  _showAddForm(
    BuildContext context,
    StateAdminArticle articleState,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProviderWidget<StateAdminArticleAdd>(
          model: StateAdminArticleAdd(
            articleState: articleState,
          ),
          onModelReady: (StateAdminArticleAdd addState) => addState.loadData(),
          builder: (context, StateAdminArticleAdd addState, child) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width - 120,
                height: MediaQuery.of(context).size.height - 160,
                padding: EdgeInsets.all(20),
                child: addState.subjects.length > 0 && addState.tags.length > 0
                    ? _buildAddForm(
                        context,
                        addState,
                      )
                    : ViewStateBusyWidget(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddForm(
    BuildContext context,
    StateAdminArticleAdd addState,
  ) {
    bool isMarkdown = addState.selectContentType == TopicContentType.markdown;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              '添加 Topic',
              style: TextStyle(fontSize: 20),
            ),
            margin: EdgeInsets.only(bottom: 20),
          ),
          _buildSelectContentType(context, addState),
          _buildSelectSubject(context, addState),
          _buildSelectTags(context, addState),
          _buildTitleRow(addState),
          isMarkdown ? _buildContentRow(addState) : _buildUrlRow(addState),
          _buildRemarksRow(addState),
          _buildSubmitRow(addState, context),
        ],
      ),
    );
  }

  Container _buildSubmitRow(StateAdminArticleAdd addState, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: OutlineButton(
        child: Text('提交'),
        onPressed: () async {
          var response = await addState.createTopic(context);
          if (response != null) {
            showToast('创建成功', context: context);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  TextField _buildTitleRow(StateAdminArticleAdd addState) {
    return TextField(
      onChanged: (text) {
        addState.setTitle(text);
      },
      decoration: InputDecoration(
        labelText: '输入文章标题',
      ),
    );
  }

  TextField _buildRemarksRow(StateAdminArticleAdd addState) {
    return TextField(
      onChanged: (text) {
        addState.setRemarks(text);
      },
      decoration: InputDecoration(
        labelText: '输入文章简介',
      ),
    );
  }

  TextField _buildUrlRow(StateAdminArticleAdd addState) {
    return TextField(
      keyboardType: TextInputType.url,
      onChanged: (text) {
        addState.setContent(text);
      },
      decoration: InputDecoration(
        labelText: '输入文章url',
      ),
    );
  }

  Container _buildContentRow(StateAdminArticleAdd addState) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 250,
      ),
      child: TextField(
        decoration: InputDecoration(labelText: '输入内容'),
        onChanged: (text) {
          addState.setContent(text);
        },
        minLines: 2,
        maxLines: 5,
      ),
    );
  }

  Container _buildSelectContentType(BuildContext context, StateAdminArticleAdd addState) {
    return Container(
      child: PopupMenuButton<TopicContentType>(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          width: MediaQuery.of(context).size.width - 120 - 20 * 2,
          child: addState.selectContentType == null
              ? Text('选择文章类型')
              : Text(topicContentTypeToShowString(addState.selectContentType)),
          padding: EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
        ),
        tooltip: '选择文章类型',
        onSelected: (type) {
          addState.setContentType(type);
        },
        itemBuilder: (context) {
          return addState.contentTypes.map((TopicContentType e) {
            return PopupMenuItem<TopicContentType>(
              value: e,
              child: Text(topicContentTypeToShowString(e)),
            );
          }).toList();
        },
      ),
    );
  }

  Container _buildSelectSubject(BuildContext context, StateAdminArticleAdd addState) {
    return Container(
      child: PopupMenuButton<Subject>(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          width: MediaQuery.of(context).size.width - 120 - 20 * 2,
          child: addState.selectSubject == null ? Text('选择文章分类') : Text(addState.selectSubject.name),
          padding: EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
        ),
        tooltip: '选择文章分类',
        onSelected: (subject) {
          addState.setSubject(subject);
        },
        itemBuilder: (context) {
          return addState.subjects.map((Subject e) {
            return PopupMenuItem<Subject>(
              value: e,
              child: Text(e.name),
            );
          }).toList();
        },
      ),
    );
  }

  Container _buildSelectTags(BuildContext context, StateAdminArticleAdd addState) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width - 120 - 20 * 2,
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Wrap(
        spacing: 20,
        children: [
          ...addState.selectTags.map((e) {
            return _btnTag(e, addState);
          }),
          addState.selectTags.length < addState.tags.length ? _btnAddTag(addState) : Container(),
        ],
      ),
    );
  }

  Widget _btnTag(Tag e, StateAdminArticleAdd addState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            e.name,
            style: TextStyle(color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: GestureDetector(
              onTap: () {
                addState.removeTag(e);
              },
              child: Icon(
                Icons.remove_circle,
                size: 14,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _btnAddTag(StateAdminArticleAdd addState) {
    return PopupMenuButton<Tag>(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '+ tag',
          style: TextStyle(color: Colors.white),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      tooltip: '选择 tag',
      onSelected: (tag) {
        addState.addTag(tag);
      },
      itemBuilder: (context) {
        return addState.tags.where((element) => !addState.selectTags.contains(element)).map((Tag e) {
          return PopupMenuItem<Tag>(
            value: e,
            child: Text(e.name),
          );
        }).toList();
      },
    );
  }
}
