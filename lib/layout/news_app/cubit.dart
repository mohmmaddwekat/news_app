import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_app/states.dart';
import 'package:news_app/modules/news_modules/business/business_screen.dart';
import 'package:news_app/modules/news_modules/science/science_screen.dart';
import 'package:news_app/modules/news_modules/sports/sports_screen.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.business,
        ),
        label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(
    //     Icons.settings,
    //   ),
    //   label: 'Settings',
    // ),
  ];
  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];
  void changeBottomNavigationBar(int index)
  {
    currentIndex = index;
    if(index == 1)
      getSports();
    else if(index == 2)
      getScience();
    emit(NewsBottomNewState());
  }
  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];
  List<dynamic> search = [];
  bool isDark = false;
  void getBusiness()
  {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country' : 'eg',
          'category' : 'business',
          'apiKey': '0851a8795db8431e9f732adfccf7cab7',
        }
    ).then((value) {
      business = value.data['articles'];
      emit(NewsBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsBusinessErrorState(error));
    });
  }

  void getSports()
  {
    emit(NewsGetSportsLoadingState());
    if(sports.length == 0)
      {
        DioHelper.getData(
            url: 'v2/top-headlines',
            query: {
              'country' : 'eg',
              'category' : 'sports',
              'apiKey': '0851a8795db8431e9f732adfccf7cab7',
            }
        ).then((value) {
          sports = value.data['articles'];
          emit(NewsSportsSuccessState());
        }).catchError((error){
          print(error.toString());
          emit(NewsSportsErrorState(error));
        });
      } else
        {
          emit(NewsSportsSuccessState());
        }
  }

  void getScience()
  {
    emit(NewsGetScienceLoadingState());
    if(science.length == 0)
      {
        DioHelper.getData(
            url: 'v2/top-headlines',
            query: {
              'country' : 'eg',
              'category' : 'science',
              'apiKey': '0851a8795db8431e9f732adfccf7cab7',
            }
        ).then((value) {
          science = value.data['articles'];
          emit(NewsScienceSuccessState());
        }).catchError((error){
          print(error.toString());
          emit(NewsScienceErrorState(error));
        });
      } else {
      emit(NewsScienceSuccessState());
      }

  }

  void getSearch(String value)
  {
    emit(NewsGetSearchLoadingState());
    DioHelper.getData(
        url: 'v2/everything',
        query: {
          'q' : value,
          'apiKey': '0851a8795db8431e9f732adfccf7cab7',
        }
    ).then((value) {
      search = value.data['articles'];
      emit(NewsSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsSearchErrorState(error));
    });

  }

  void changeAppMode({bool? fromShared})
  {
    if(fromShared != null){
      isDark = fromShared;
      emit(NewsChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBool(
          key: 'isDark',
          value: isDark
      ).then((value) {
        emit(NewsChangeModeState());
      });
    }
  }
}