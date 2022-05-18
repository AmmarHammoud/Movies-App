import 'package:flutter/material.dart';
import 'package:flutter_app2/modules/home_screen/search_screen/cubit/cubit.dart';
import 'package:flutter_app2/modules/home_screen/search_screen/cubit/states.dart';
import 'package:flutter_app2/modules/movie_screen/movie_screen.dart';
import 'package:flutter_app2/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';

class SearchScreen extends StatelessWidget {
  late UserModel userModel;
  SearchScreen(this.userModel);
  @override
  Widget build(BuildContext context) {
    var search = TextEditingController();
    return BlocProvider(
      create: (context) => SearchForMovieCubit(),
      child: BlocConsumer<SearchForMovieCubit, SearchForMovieStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = SearchForMovieCubit.get(context).model?.results;
          return Scaffold(
              appBar: AppBar(
                title: Text('search for a movie'),
                titleSpacing: 0.0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left:20.0, right: 20.0, top: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: search,
                            onEditingComplete: (){SearchForMovieCubit.get(context).searchForMovie(search.text);},
                            style: TextStyle(fontSize: 20.0),
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.search_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if(state is SearchForMovieSuccessState)
                      Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              width: 500.0,
                              height: 700,
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    buildMovieItem(context, model?[index].id, model?[index].image,
                                        model?[index].title),
                                separatorBuilder: (context, index) =>
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                itemCount: model!.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(state is SearchForMovieLoadingState && search.text != '')
                      Center(child: CircularProgressIndicator()),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget buildMovieItem(context, String id, String image, String title) {
    return InkWell(
      onTap: (){navigateTo(context, MovieScreen(id, userModel, false));},
      child: Row(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image(
                width: 100.0,
                height: 125.0,
                image: NetworkImage(image),
              ),
            ),
          ),
          Expanded(child: Text(title)),
        ],
      ),
    );
  }
}
