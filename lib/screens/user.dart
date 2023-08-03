import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/components/custom_error_while_loading.dart';
import 'package:creative_blogger_app/screens/home/components/preview_post_tile.dart';
import 'package:creative_blogger_app/utils/posts.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';
import 'package:creative_blogger_app/utils/user.dart';
import 'package:creative_blogger_app/utils/structs/public_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.username});

  static const routeName = "/user";

  final String username;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  PublicUser? _user;
  List<PreviewPost>? _posts;
  bool _isLoading = true;
  bool _arePreviewPostsLoading = true;

  @override
  void initState() {
    super.initState();
    _getPublicUser();
    //TODO décommenter cette ligne

    // _getPreviewPostsByAuthor(widget.username);
  }

  void _getPublicUser() {
    setState(() => _isLoading = true);
    getPublicUser(widget.username).then(
      (user) {
        setState(
          () {
            _user = user;
            _isLoading = false;
          },
        );
        //TODO delete the following
        if (_user != null) {
          _getPreviewPostsByAuthor(_user!.id);
        }
      },
    );
  }

  //TODO replace int by String
  Future<void> _getPreviewPostsByAuthor(int author,
      {int limit = 20, int page = 0}) async {
    setState(() => _arePreviewPostsLoading = true);
    var posts =
        await getPreviewPostsByAuthor(author: author, limit: limit, page: page);
    setState(() {
      _posts = posts;
      _arePreviewPostsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.user),
        flexibleSpace: Container(decoration: customDecoration()),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _getPublicUser(),
        child: _isLoading
            ? const Center(
                child: SpinKitSpinningLines(
                  color: Colors.blue,
                  size: 100,
                  duration: Duration(milliseconds: 1500),
                ),
              )
            : _user == null
                ? CustomErrorWhileLoadingComponent(
                    message: AppLocalizations.of(context)!
                        .an_error_occured_while_loading_user,
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              _user!.username,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .fontSize,
                              ),
                            ),
                            getPermission(_user!.permission),
                            Text(
                              AppLocalizations.of(context)!.signed_up_the(
                                  getHumanDate(_user!.createdAt)),
                            ),
                            if (_posts != null && _posts!.isNotEmpty) ...{
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.users_posts,
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize,
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    PreviewPostTile(post: _posts![index]),
                                //TODO add show more button
                                itemCount: (_posts ?? []).length,
                                shrinkWrap: true,
                              ),
                            },
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
