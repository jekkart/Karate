Feature: Rest API - Create user

  Background:
    * url 'https://gorest.co.in'
    * header Authorization = 'Bearer c759ab45473dcfd5bdac438dc8de960fcd3b24ecbe9c967323e27a662dff613d'

  Scenario Outline: Successful user creation <name>
    Given path 'public/v2/users'
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And request { name: '<name>', gender: '<gender>', email: '<email>', status: '<status>' }
    When method POST
    Then status 201
    And match response.id != ''
    And match response.name == '<name>'
    And match response.email == '<email>'
    And match response.gender == '<gender>'
    And match response.status == '<status>'
    Examples:
      | name        | email                 | gender | status   |
      | KarateDSL_5 | karate.dsl12@test.org | female | active   |
      | KarateDSL_6 | karate.dsl_13@test.org | male   | inactive |

  Scenario: Unsuccessful user creation (user already registered)
    Given path 'public/v2/users'
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And request { name: 'Tenali Ramakrishna', gender: 'male', email: 'tenali.ramakrishna@15ce.com', status: 'active' }
    When method POST
    Then status 422
    And match response[0].field == 'email'
    And match response[0].message == 'has already been taken'

    Scenario: get user
      Given path '/public/v2/users/2062810'
      And header Accept = 'application/json'
      And header Content-Type = 'application/json'
      When method GET
      Then status 200
      And match response.id == 2062810
      And match response.name == 'KarateDSL_6'
      And match response.email == 'karate.dsl_7@test.org'
      And match response.gender == 'male'
      And match response.status == 'inactive'