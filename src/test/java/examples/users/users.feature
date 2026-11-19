Feature: API de usuarios

  Background:
    * url baseUrl

  @smoke
  Scenario: Obtener todos los usuarios
    Given path 'users'
    When method get
    Then status 200
    And match response == '#[10]'
    And match each response contains { id: '#number', name: '#string', email: '#string' }

  Scenario: Obtener un usuario por id
    Given path 'users', 1
    When method get
    Then status 200
    And match response.id == 1
    And match response.address.city == '#string'

  Scenario Outline: Usuarios por id - <id>
    Given path 'users', <id>
    When method get
    Then status 200
    And match response.username == '<username>'

    Examples:
      | id | username  |
      | 1  | Bret      |
      | 2  | Antonette |
