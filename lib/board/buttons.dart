class MotionButton {
  int? id;
  String? name;
  String? icon;

  MotionButton({
    this.id,
    this.name,
    this.icon
  });
}

List<MotionButton> motionButtonCategories = [
  MotionButton(
      id: 1,
      name: 'Left',
      icon: 'assets/food.svg'
  ),
  MotionButton(
      id: 2,
      name: 'Right',
      icon: 'assets/drinks.svg'
  ),
  MotionButton(
      id: 3,
      name: 'Move',
      icon: 'assets/fruit.svg'
  ),
  MotionButton(
      id: 4,
      name: 'Move 2 Steps',
      icon: 'assets/chat.svg'
  ),
];