import 'package:flutter/material.dart';

class Aluno {
  final String nome;
  final String curso;

  Aluno({required this.nome, required this.curso});
}

List<Aluno> alunos = [
  Aluno(nome: 'Jeferson', curso: 'INFO 22'),
  Aluno(nome: 'Raphael', curso: 'INFO 22'),
  Aluno(nome: 'Otávio', curso: 'INFO 22'),
];

class FlipCardSingle extends StatefulWidget {
  final Aluno aluno;

  const FlipCardSingle({super.key, required this.aluno});

  @override
  State<FlipCardSingle> createState() => _FlipCardSingleState();
}

class _FlipCardSingleState extends State<FlipCardSingle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationY(_animation.value * 3.14159),
            alignment: Alignment.center,
            child:
                _animation.value < 0.5
                    ? _buildFrontCard()
                    : Transform(
                      transform: Matrix4.rotationY(3.14159),
                      alignment: Alignment.center,
                      child: _buildBackCard(),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: 200,
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            widget.aluno.nome,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.aluno.curso,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: 200,
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Verso do cartão',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}

class FlipCardWidget extends StatelessWidget {
  const FlipCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cartão do Aluno'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: alunos.length,
            itemBuilder: (context, index) {
              return FlipCardSingle(aluno: alunos[index]);
            },
          ),
        ),
      ),
    );
  }
}
