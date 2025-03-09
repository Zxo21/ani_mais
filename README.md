# Ani+

Ani+ é um aplicativo desenvolvido como Trabalho de Conclusão de Curso (TCC) na formação de Análise e Desenvolvimento de Sistemas. O objetivo do projeto é fornecer uma plataforma para o gerenciamento da saúde de animais de estimação, permitindo que os tutores registrem informações importantes sobre seus pets, como comorbidades, vacinas e medicamentos.

## Funcionalidades

- **Cadastro de perfis de animais**: Permite adicionar múltiplos pets com dados personalizados.
- **Registro de comorbidades**: Armazena histórico de doenças e condições de saúde.
- **Controle de vacinas**: Agenda e acompanha a vacinação dos animais.
- **Gerenciamento de medicamentos**: Facilita o controle de medicações, com lembretes.
- **Interface intuitiva**: Design focado na usabilidade e experiência do usuário.

## Tecnologias Utilizadas

- **Frontend**: Flutter (Dart)
- **Backend**: PHP com MySQL
- **Comunicação**: HTTP requests para interação com a API

## Estrutura do Projeto

O aplicativo segue uma arquitetura baseada em requisições HTTP para interagir com um backend PHP, que gerencia a persistência de dados no banco MySQL.

- **Flutter**: Responsável pela interface do usuário e lógica do aplicativo.
- **PHP API**: Manipula as requisições, garantindo a comunicação com o banco de dados.
- **MySQL**: Armazena informações dos pets e seus históricos.

## Como Executar

1. Clone o repositório:
   ```bash
   git clone https://github.com/seuusuario/ani_mais.git
   ```
2. Instale as dependências do Flutter:
   ```bash
   flutter pub get
   ```
3. Configure o backend:
   - Certifique-se de ter um servidor PHP rodando (ex: XAMPP, Laragon, ou servidor web).
   - Importe o banco de dados MySQL utilizando o script `database.sql`.
   - Configure as credenciais do banco no arquivo `config.php`.
4. Execute o aplicativo:
   ```bash
   flutter run
   ```

## Licença

Este projeto foi desenvolvido como um trabalho acadêmico e está disponível para fins educacionais e não comerciais.

---

