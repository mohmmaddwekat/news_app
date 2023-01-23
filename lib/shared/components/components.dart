import 'package:flutter/material.dart';
import 'package:news_app/modules/news_modules/web_view/web_view_screen.dart';
import 'package:news_app/shared/components/constants.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  Border? border,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmit,
  required FormFieldValidator<String> validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = false,
  VoidCallback? suffixPressed,
  GestureTapCallback? onTap,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      obscureText: isPassword,
      enabled: isClickable,
      validator: validate,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null ? IconButton(
          icon: Icon(
              suffix
          ),
          onPressed: suffixPressed,
        ) : null,
      ),
    );

 Widget conditionalBuilder({
   required bool condition,
   required Widget builder,
   Widget? fallback,
}) => condition ? builder : fallback ?? Container();

 Widget myDivider() => Padding(
   padding: const EdgeInsets.all(10.0),
   child: Container(
     width: double.infinity,
     height: 1.0,
     color: Colors.grey[300],
     padding: const EdgeInsetsDirectional.only(
       start: 20.0,
     ),
   ),
 );

 Widget buildArticleItem(article,context) => InkWell(
   child: Padding(
     padding: const EdgeInsets.all(20.0),
     child: Row(
       children: [
         Container(
           width: 120.0,
           height: 120.0,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10.0,),
               image: DecorationImage(
                   image: NetworkImage(article['urlToImage'] == null ? imagePlaceholder : article['urlToImage']),
                   fit: BoxFit.cover
               )
           ),
         ),
         SizedBox(
           width: 20.0,
         ),
         Expanded(
           child: Container(
             height: 120.0,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children:
               [
                 Expanded(
                   child: Builder(
                     builder: (context) {
                       return Text(
                         article['title'],
                         maxLines: 3,
                         overflow: TextOverflow.ellipsis,
                         style: Theme.of(context).textTheme.bodyText1,

                       );
                     }
                   ),
                 ),
                 Text(
                   article['publishedAt'],
                   style: TextStyle(
                     color: Colors.grey,
                     fontSize: 18.0,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ],
             ),
           ),
         ),
       ],
     ),
   ),
   onTap: (){
     navigateTo(context, WebViewScreen(article['url']));
   },
 );

 Widget articleBuilder(newsList, context, {isSearch= false}) => conditionalBuilder(
   condition: newsList.length > 0,
   builder: ListView.separated(
     physics: BouncingScrollPhysics(),
     itemBuilder: (context, index) => buildArticleItem(newsList[index],context),
     separatorBuilder: (context, index) => myDivider(),
     itemCount: 10,),
   fallback: isSearch ? Center() : Center(child: CircularProgressIndicator(),),
 );

 void navigateTo(context, widget) => Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => widget,
     ));