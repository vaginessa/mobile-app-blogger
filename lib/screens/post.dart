import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/components/post_tile.dart';
import 'package:creative_blogger_app/screens/home/home.dart';
import 'package:creative_blogger_app/utils/post.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key, required this.slug});

  static const routeName = "/post";

  final String slug;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Post? _post;
  bool isPostLoading = true;

  @override
  void initState() {
    super.initState();
    getPost(widget.slug).then((post) {
      if (mounted) {
        setState(() {
          _post = post;
          isPostLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.post),
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
        actions: [
          if (_post != null) ...{
            if (_post!.hasPermission) ...{
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (innerContext) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.are_you_sure),
                      content: Text(AppLocalizations.of(context)!
                          .this_post_will_be_definitely_deleted),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(innerContext),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(innerContext);
                            removePost(_post!.slug).then((fine) {
                              if (fine) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomeScreen.routeName,
                                  (route) => false,
                                  arguments: 0,
                                );
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: Text(AppLocalizations.of(context)!.im_sure),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            },
          },
        ],
      ),
      body: isPostLoading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.blue,
                size: 100,
                duration: Duration(milliseconds: 1500),
              ),
            )
          : _post == null
              ? Text(AppLocalizations.of(context)!
                  .an_error_occured_while_loading_post)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PostTile(post: _post!),
                      const SizedBox(height: 16),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
