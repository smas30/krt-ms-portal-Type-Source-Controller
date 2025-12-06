@obtenerTypeSourcePorId
Feature: Obtener type source por ID mediante GET /api/v1/portal/ref-type-sources/{id}

  Background:
    * configure logPrettyResponse = false
    * configure logPrettyRequest = false
    * def loginBody = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: loginBody }
    * def authToken = loginResponse.response.token
    * def headers = headersTypeSourceConToken(authToken)
    * configure headers = headers
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_typeSourceUnico.json')

  @obtenerTypeSourcesPorId
  Scenario: Obtener un type source por ID
    # Llamar al feature de obtener todos los type sources para obtener un ID
    * def obtenerListaResponse = call read('classpath:api/obtenerTypeSources.feature@obtenerTodosLosTypeSources')
    * def typeSourceId = obtenerListaResponse.response.data.data[0].id
    And print 'ID obtenido del feature obtenerTypeSources:', typeSourceId

    # Obtener ese type source por ID
    Given url baseUrl + '/' + typeSourceId
    When method GET
    Then status 200
    And match response.success == true
    And match response.data.id == typeSourceId
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Type Source obtenido exitosamente:', response.data
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'

