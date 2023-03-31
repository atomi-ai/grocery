import 'package:flutter/material.dart';

class CustomizedTab extends StatefulWidget {
  @override
  _CustomizedTabState createState() => _CustomizedTabState();
}

class Ingredient {
  String name;
  double price;

  Ingredient({
    required this.name,
    required this.price,
  });
}

class _CustomizedTabState extends State<CustomizedTab> {
  final _formKey = GlobalKey<FormState>();
  Map<Ingredient, double> _selectedIngredients = {};
  String _pizzaName = '';
  double _selectedQuantity = 10.0;
  double _pricePerUnit = 1.0;
  double _totalSelectedWeight = 0.0;

  List<Ingredient> _ingredients = [
    Ingredient(name: 'Mozzarella', price: 1.0),
    Ingredient(name: 'Tomato sauce', price: 0.5),
    Ingredient(name: 'Mushrooms', price: 0.8),
    Ingredient(name: 'Onions', price: 0.6),
    Ingredient(name: 'Peppers', price: 0.7),
    Ingredient(name: 'Olives', price: 0.9),
  ];

  Widget _buildIngredientItem(Ingredient ingredient) {
    return ListTile(
      title: Text(ingredient.name),
      trailing: SizedBox(
        width: 120,
        child: Row(
          children: [
            GestureDetector(
              child: Icon(Icons.remove),
              onTap: () {
                setState(() {
                  if (!_selectedIngredients.containsKey(ingredient)) {
                    return;
                  }
                  if (_selectedIngredients[ingredient] != null &&
                      _selectedIngredients[ingredient]! > 0 &&
                      _totalSelectedWeight > 0) {
                    _selectedIngredients[ingredient] = _selectedIngredients[ingredient]! - 2.0;
                    _totalSelectedWeight -= 2.0;
                  }
                });
              },
            ),
            SizedBox(
                width: 40,
                child: Text(
                  '${_selectedIngredients[ingredient] ?? 0}g',
                  textAlign: TextAlign.center,
                )),
            GestureDetector(
              child: Icon(Icons.add),
              onTap: () {
                if (_totalSelectedWeight + 2.0 <= _selectedQuantity) {
                  setState(() {
                    if (_selectedIngredients[ingredient] == null) {
                      _selectedIngredients[ingredient] = 2.0;
                    } else {
                      _selectedIngredients[ingredient] = _selectedIngredients[ingredient]! + 2.0;
                    }
                    _totalSelectedWeight += 2.0;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPizzaNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Pizza name'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name for your pizza';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _pizzaName = value;
        });
      },
    );
  }

  void _createPizza() {
    double totalWeight = 0.0;
    _selectedIngredients.forEach((ingredient, weight) {
      totalWeight += weight;
    });
    double price = totalWeight * _pricePerUnit;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Pizza'),
          content: Text(
              'Are you sure you want to create a pizza named $_pizzaName with a total weight of $totalWeight g for a total price of \$$price?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                // TODO: Create the pizza here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose your toppings',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10),
              _buildPriceAndRemainWeight(),
              Container(
                height: 240,
                child: ListView.builder(
                  itemCount: _ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = _ingredients[index];
                    return SizedBox(
                      height: 40,
                      child: _buildIngredientItem(ingredient),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildTotalQuantitySelector(), // 新增组件
              _buildPizzaNameField(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    _selectedIngredients.isNotEmpty ? _createPizza : null,
                child: const Text('Create pizza'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalQuantitySelector() {
    return Row(
      children: [
        const SizedBox(
          width: 150,
          child: Text('Total weight (g):'),
        ),
        const SizedBox(width: 20),
        Text('${_selectedQuantity.toStringAsFixed(1)}g'),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_selectedQuantity >= 10.0) {
                _selectedQuantity -= 10.0;
              }
            });
          },
          child: Text('-'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_selectedQuantity < 40.0) {
                _selectedQuantity += 10.0;
              }
            });
          },
          child: Text('+'),
        ),
      ],
    );
  }

  Widget _buildPriceAndRemainWeight() {
    double _price = (_selectedQuantity - 10.0) / 10.0;
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text('Additional cost: \$${_price}'),
        ),
        SizedBox(
          width: 200,
          child: Text('Remaining weight ${_selectedQuantity - _totalSelectedWeight}g',
          textAlign: TextAlign.right,),
        )],
    );
  }
}
