@crearTypeSourceController
Feature: Crear type source mediante POST /api/v1/portal/ref-type-sources

  Background:
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token
    * def headers = headersTypeSourceConToken(authToken)
    * configure headers = headers
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_typeSourceUnico.json')
    * def crearRequest = read('classpath:JsonRequest/crearTypeSourceRequest.json')

  @crearTypeSources
  Scenario: Crear un type source con datos únicos
    * def crearRequest = read('classpath:JsonRequest/crearTypeSourceRequest.json')
    * def timestamp = java.lang.System.currentTimeMillis()
    * set crearRequest.label = crearRequest.label + ' ' + timestamp
    * set crearRequest.name = crearRequest.name + ' ' + timestamp
    Given url baseUrl
    And request crearRequest
    When method POST
    Then status 200
    And match response.success == true
    * def typeSourceId = response.data.id
    And print 'Type Source creado con ID:', typeSourceId
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Type Source creado con ID:', response.data.id
    And print response
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'

  @crearConDatosIncompletos @crearTypeSourceError
  Scenario: Crear type source con datos incompletos - debe retornar error
    * def schemaErrorText = karate.readAsString('classpath:Schema/sc_errorResponse.json')
    * def requestIncompleto =
    """
    {
      "label": "Test",
      "status": 1
    }
    """
    Given url baseUrl
    And request requestIncompleto
    When method POST
    Then status 400
    And match response.success == false
    And print 'Respuesta de error (datos incompletos):', response
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaErrorText, responseText)
    * match isValid == true
    And print 'Errores:', response.data.errors
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'

  @crearConBodyVacio @crearTypeSourceError
  Scenario: Crear type source con body vacio - debe retornar error
    * def schemaErrorText = karate.readAsString('classpath:Schema/sc_errorResponse.json')
    Given url baseUrl
    And request {}
    When method POST
    Then status 400
    And match response.success == false
    And print 'Respuesta de error (body vacio):', response
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaErrorText, responseText)
    * match isValid == true
    And print 'Mensaje de error:', response.data.message
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'

