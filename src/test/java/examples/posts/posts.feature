Feature: API de posts

  Background:
    * url baseUrl

  @smoke
  Scenario: Crear un post desde un archivo JSON
    * def payload = read('create-post.json')
    Given path 'posts'
    And request payload
    When method post
    Then status 201
    And match response contains payload
    And match response.id == '#number'

  Scenario: Actualizar un post
    Given path 'posts', 1
    And request { id: 1, title: 'actualizado', body: 'texto', userId: 1 }
    When method put
    Then status 200
    And match response.title == 'actualizado'

  Scenario: Eliminar un post
    Given path 'posts', 1
    When method delete
    Then status 200
