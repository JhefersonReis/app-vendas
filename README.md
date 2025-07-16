# Zello

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## 🎯 Sobre

O Zello é um aplicativo de ponto de venda (PDV) desenvolvido em Flutter, projetado para simplificar a gestão de vendas, clientes e produtos. Com uma interface intuitiva e funcionalidades robustas, o app é ideal para pequenos e médios negócios que buscam eficiência e controle.

## ✨ Funcionalidades

O aplicativo oferece um conjunto de funcionalidades para otimizar a gestão do seu negócio:

*   **Gestão de Clientes:** Cadastre, edite, visualize e remova clientes com facilidade.
*   **Gestão de Produtos:** Controle seu estoque, adicione novos produtos e gerencie informações detalhadas.
*   **Registro de Vendas:** Realize vendas de forma rápida e intuitiva, associando clientes e produtos.
*   **Relatórios:** Acesse relatórios para acompanhar o desempenho de suas vendas.
*   **Internacionalização:** Suporte para Português e Inglês.

## 🛠️ Tecnologias Utilizadas

Este projeto foi construído utilizando as seguintes tecnologias e bibliotecas:

*   **[Flutter](https://flutter.dev/)**: Framework para desenvolvimento de aplicações multiplataforma.
*   **[Riverpod](https://riverpod.dev/)**: Para gerenciamento de estado.
*   **[Drift](https://drift.simonbinder.eu/)**: Banco de dados local para persistência de dados.
*   **[GoRouter](https://pub.dev/packages/go_router)**: Para gerenciamento de rotas e navegação.
*   **[Intl](https://pub.dev/packages/intl)**: Para internacionalização (i18n).

## 📂 Estrutura do Projeto

O projeto segue uma arquitetura limpa e organizada, com uma estrutura baseada em features:

```
lib/
├── src/
│   ├── app/
│   │   ├── database/
│   │   ├── helpers/
│   │   ├── locale/
│   │   ├── providers/
│   │   └── router/
│   └── features/
│       ├── customers/
│       ├── home/
│       ├── products/
│       ├── reports/
│       └── sales/
└── main.dart
```

## 🚀 Como Executar o Projeto

Para executar o projeto, siga os passos abaixo:

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/JhefersonReis/zello.git
    ```

2.  **Acesse o diretório do projeto:**
    ```bash
    cd zello
    ```

3.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

4.  **Execute o gerador de código:**
    ```bash
    dart run build_runner build
    ```

5.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.