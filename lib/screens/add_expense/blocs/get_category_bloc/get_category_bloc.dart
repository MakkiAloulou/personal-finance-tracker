import 'package:bloc/bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:personal_finance_tracker/screens/add_expense/blocs/get_category_bloc/get_categories_event.dart';
import 'package:personal_finance_tracker/screens/add_expense/blocs/get_category_bloc/get_categories_state.dart';


class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  ExpenseRepository expenseRepository;

  GetCategoriesBloc(this.expenseRepository) : super(GetCategoriesInitial()) {
    on<GetCategories>((event, emit) async {
      emit(GetCategoriesLoading());
      try {
        List<Category> categories = await expenseRepository.getCategory();
        emit(GetCategoriesSuccess(categories));
      } catch (e) {
        emit(GetCategoriesFailure());
      }
    });
  }
}