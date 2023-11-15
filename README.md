# Teste Flutter VM - Bruno Barbieri

## Insights
- Como o a solução, relativamente, era de baixa complexidade, investi mais na UI e UX e busquei explorar mais funcionalidades do Flutter;
- Busquei utilizar todas as funcionalidades principais e mais comuns presentes em qualquer aplicação desenvolvida em Flutter:
  - Text();
  - TextForm();
  - Container();
  - SizedBox();
  - Icon();
  - ElelevatedButton();
  - AlertDialog();
  - AppBar();
  - FloatingActionButton();
- Além das funcionalidades comuns do material, adicinei uma dependência para mostrar sua utilização e melhorar a UX;
- Dividi o fluxo da solução em 3 etapas:
  - 1° etapa: Escolher a quantidaded de números gerados na lista;
  - 2° etapa: Reordenar a lista;
  - 3° etapa: Verificar ordem cresncente;
- Para reiniciar o processo utilizei um Floating Button na parte inferior da interface;
- Para dimensionamento e responsivaded envolvi a maior parte dos elementos em Container e SizedBox;
  - SizedBox: Para melhor performance e quando não era necessário nenhum customização;
  - Container: Quando era necessário customização;
  - Responsividade: Utilizei MediaQuery nos dimensionamento para garantir que os elementos se ajustes ao tamanho da tela e usei um SingleChildScrollView() para não gerar overflow dependendo da proporção da tela;
- Na appBar customizei a statusBar para garantir continuidade no design da tela;
- No TextForm do input da quantidade de números utilizei algumas condições para melhorar a experiência:
  - Limitei o número maximo para 99 números gerados na lista;
  - E adicionei um condição para aceitar somente números (sem ponto ou vírgula e sem letras);
- Para a feature de reordenar os números, adicionei a dependencia ReorderableGridView para melhorar experiência, já que o Material não possui essa funcionalidade. Pensei em usar o ReorderableListView presente no Material, mas o GridView deixa a experiência mais interessante.
- Para a verificar utilizei um AlertDialog() para o display do resultado da verificação.
