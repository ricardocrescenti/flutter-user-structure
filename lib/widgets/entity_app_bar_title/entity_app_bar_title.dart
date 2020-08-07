import 'package:flutter/material.dart';
import 'package:user_structure/user_structure.dart';

class EntityAppBarTitle extends StatelessWidget {
  final Widget title;
  final EntityModelPattern entity;

  EntityAppBarTitle({
    this.title,
    @required this.entity,
  }) {
    assert(entity != null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: AvatarWidget(avatar: entity.photo?.getPublicUrl(size: 75), size: 20)
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title,
            (entity == null ? Container() : Text(entity.name, style: Theme.of(context).textTheme.subtitle2))
          ],
        ),
      ]
    );
  }
}