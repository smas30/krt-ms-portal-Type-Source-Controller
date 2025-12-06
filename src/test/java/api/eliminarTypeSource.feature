@eliminarTypeSourceFeat
Feature: Eliminar type source mediante DELETE /api/v1/portal/ref-type-sources/{id}

  Background:
    * configure logPrettyResponse = false
    * configure logPrettyRequest = false
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token
    * def headers = headersTypeSourceConToken(authToken)
    * configure headers = headers
    # Llamar al feature de crear para obtener un ID de type source creado
    * def crearResponse = call read('classpath:api/crearTypeSource.feature@crearTypeSources')
    * def typeSourceId = crearResponse.response.data.id
    And print 'ID obtenido del feature crear:', typeSourceId

  @eliminarTypeSources
  Scenario: Eliminar un type source creado previamente
    Given url baseUrl + '/' + typeSourceId
    When method DELETE
    Then status 204
    And print 'Type Source eliminado con ID:', typeSourceId
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'