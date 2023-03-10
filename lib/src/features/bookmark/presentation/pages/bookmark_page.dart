import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/presentation/widgets/loading_widget.dart';
import '../../../../core/presentation/widgets/message_widget.dart';
import '../../../../core/utils/screen_size.dart';
import '../bloc/movie_bookmark_bloc.dart';
import '../widgets/bookmarked_movies_widget.dart';

class BookmarkPage extends StatelessWidget {
  static const String routeName = '/bookmark';
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context: context);
    Future.delayed(
      Duration.zero,
      () {
        context.read<MovieBookmarkBloc>().add(GetBookmarkedMoviesEvent());
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
      ),
      body: Center(
        child: BlocBuilder<MovieBookmarkBloc, MovieBookmarkState>(
          builder: (context, state) {
            print('state: $state');
            if (state is LoadedState) {
              return BookmarkedMoviesWidget(
                  screenSize: screenSize, movies: state.bookmarkMovieList);
            } else if (state is EmptyState) {
              return const MessageWidget(message: 'Empty');
            } else if (state is ErrorState) {
              return MessageWidget(message: state.message);
            } else if (state is SuccessState) {
              context.read<MovieBookmarkBloc>().add(GetBookmarkedMoviesEvent());
              Fluttertoast.showToast(
                msg: "Success",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
            return const LoadingWidget();
          },
        ),
      ),
    );
  }
}
