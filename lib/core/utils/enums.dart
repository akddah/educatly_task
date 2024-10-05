enum RequestState {
  loading,
  done,
  error,
  initial;

  bool get isLoading => this == RequestState.loading;

  bool get isDone => this == RequestState.done;

  bool get isError => this == RequestState.error;

  bool get isInitial => this == RequestState.initial;
}
