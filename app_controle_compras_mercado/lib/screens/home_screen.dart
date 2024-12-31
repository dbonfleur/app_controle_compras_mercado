import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/page/page_bloc.dart';
import '../blocs/page/page_event.dart';
import '../blocs/page/page_state.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> _pages = [
    
  ];

   @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PageBloc(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        drawer: BlocBuilder<PageBloc, PageState>(
          builder: (context, state) {
            return DrawerMenu(
              onItemTapped: (index) {
                BlocProvider.of<PageBloc>(context).add(PageTapped(index));
                Navigator.pop(context);
              },
              selectedIndex: (state as PageSelected).index,
            );
          },
        ),
        body: BlocBuilder<PageBloc, PageState>(
          builder: (context, state) {
            return IndexedStack(
              index: (state as PageSelected).index,
              children: _pages,
            );
          },
        ),
      ),
    );
  }
}