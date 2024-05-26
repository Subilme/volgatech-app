mixin AppComponent {
  final List<AppComponent> components = [];
  
  Future<void> initComponent() async {
    await _initComponents();
  }
  
  Future<void> _initComponents() async {
    components.addAll(prepareComponents());
    for (var component in components) {
      await component.initComponent();
    }
  }

  List<AppComponent> prepareComponents() {
    return [];
  }
}
